/*                      SIMA - CONTABILIDAD ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO NIVELES

REQUERIMIENTOS:

- Compilar: clipper funcsNiv /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfNiv(PathNiv,FileNiv,lIntUno,fNtxNiv)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfNiv(lShared,PathNiv,FileNiv,lIntUno,fNtxNiv,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathNiv				    // Path del Archivo
       FileNiv				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxNiv				    // Archivo de Indices
       cMaeAct			           // Maestro actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL       i := 0                   // Contador
       LOCAL nMinNiv := 0                   // M¡nimo nivel
       LOCAL nMaxNiv := 0                   // M ximo nivel
       LOCAL cCodigoTni := ''               // C¢digo del nivel

       LOCAL GetList := {}                  // Variable del sistema
       LOCAL aDbfNiv := {{"cCodigoNiv","Character",02,0},; // C¢digo del nivel
			 {"cIdentiNiv","Character",02,0},; // Identificaci¢n del Nivel. JA -> Jardin A
			 {"cNombreNiv","Character",12,0},; // Nombre del Nivel. Jardin B. Undecimo
			 {"nNroGruNiv","Numeric"  ,02,0} } // N£mero de Grupos en el nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathNiv) == 0
	    DBCREATE(FileNiv,aDbfNiv,"DBFNTX")

       CASE DIRCHANGE(PathNiv) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathNiv)

       CASE DIRCHANGE(PathNiv) == -5
	    cError('NO TIENE DERECHOS EN: '+PathNiv)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathNiv+'\'+FileNiv,'NIV',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO NIVELES EN CREACION DE ESTRUCTURAS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>SELECCION DEL MAXIMO NIVEL
       DO CASE
       CASE 'PRI' $ cMaeAct
	    nMinNiv := 0
	    nMaxNiv := 5

       CASE 'BTO' $ cMaeAct
	    nMinNiv := 6
	    nMaxNiv := 11

       CASE 'JAR' $ cMaeAct
	    nMinNiv := 12
	    nMaxNiv := 16

       OTHERWISE
	  cError('No existen maestros habilitados NIV')
	  CloseDbf('NIV')
	  RETURN NIL
       ENDCASE
*>>>>FIN SELECCION DEL MAXIMO NIVEL

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       FOR i := nMinNiv TO nMaxNiv

	   cCodigoTni := STR(i,2)
	   lCorrecion(@cCodigoTni,.T.)

	   IF NIV->(lRegLock(lShared,.T.))
	      REPL NIV->cCodigoNiv WITH cCodigoTni
	   ELSE
	      cError('NO SE GRABA NIVEL')
	   ENDIF

	   NIV->(DBCOMMIT())
	   IF lShared
	      NIV->(DBUNLOCK())
	   ENDIF
       NEXT
       CLOSE NIV
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:45 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfNiv(lShared,PathNiv,FileNiv,lIntUno,fNtxNiv,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathNiv			      // Path del Archivo
       FileNiv			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxNiv			      // Archivo de Indice
       cMaeAct			// Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathNiv+'\'+FileNiv,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE NIVELES")
       Termometro(100)

       CreaDbfNiv(lShared,PathNiv,FileNiv,lIntUno,fNtxNiv,cMaeAct)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL NIVEL                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 11:40 AM   ENE 03/95 MIE

OBJETIVOS:

1)- Valida en el c¢digo del nivel

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodNiv(cCodNiv,cMaeAlu,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodNiv                              // C¢digo del nivel
       cMaeAlu                              // Maestros habilitados
       lMensaj                              // .T. Imprimir Mensaje */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS PARAMETROS
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>VALIDACION DEL NIVEL PARA JARDIN
       IF ISALPHA(cCodNiv)
	  IF !lValCodJar(@cCodNiv,cMaeAlu)
	     IF lMensaj
		cError('EL NIVEL ESPECIFICADO NO ESTA DISPONIBLE')
		RETURN lHayErr
	     ENDIF
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL NIVEL PARA JARDIN

*>>>>VALIDACION DEL CODIGO
       IF !EMPTY(cCodNiv)
	  DO CASE
	  CASE cMaeAlu $ 'JARPRIBTO' .AND. LEN(cMaeAlu) == 9 .AND.;
	       VAL(cCodNiv) >= 0 .AND. VAL(cCodNiv) <= 16
	       lHayErr := .F.

	  CASE cMaeAlu $ 'JARPRI' .AND. LEN(cMaeAlu) == 6 .AND.;
	       ((VAL(cCodNiv) >= 12 .AND. VAL(cCodNiv) <= 16) .OR.;
	       (VAL(cCodNiv)  >= 0  .AND. VAL(cCodNiv) <= 5))
	       lHayErr := .F.

	  CASE cMaeAlu $ 'JARBTO' .AND. LEN(cMaeAlu) == 6 .AND.;
	       ((VAL(cCodNiv) >= 12 .AND. VAL(cCodNiv) <= 16) .OR.;
	       (VAL(cCodNiv)  >= 6  .AND. VAL(cCodNiv) <= 11))
	       lHayErr := .F.

	  CASE cMaeAlu $ 'JARPRIBTO' .AND. LEN(cMaeAlu) == 9 .AND.;
	       ((VAL(cCodNiv) >= 12 .AND. VAL(cCodNiv) <= 16) .OR.;
	       (VAL(cCodNiv)  >= 0  .AND. VAL(cCodNiv) <= 11))
	       lHayErr := .F.

	  CASE cMaeAlu $ 'JARPRI'   .AND. LEN(cMaeAlu) == 6 .AND.;
	       ((VAL(cCodNiv) >= 12 .AND. VAL(cCodNiv) <= 16) .OR.;
	       (VAL(cCodNiv)  >= 0  .AND. VAL(cCodNiv) <= 5))
	       lHayErr := .F.

	  CASE (cMaeAlu $ 'JARBTO'  .AND. LEN(cMaeAlu) == 6) .AND.;
	       ((VAL(cCodNiv) >= 12 .AND. VAL(cCodNiv) <= 16) .OR.;
	       (VAL(cCodNiv) >= 6   .AND. VAL(cCodNiv) <= 11))
	       lHayErr := .F.

	  CASE cMaeAlu $ 'PRIBTO' .AND. LEN(cMaeAlu) == 6 .AND.;
	       VAL(cCodNiv) >= 0 .AND. VAL(cCodNiv) <= 11
	       lHayErr := .F.

	  CASE cMaeAlu $ 'JAR' .AND. LEN(cMaeAlu) == 3 .AND.;
	       VAL(cCodNiv) >= 12 .AND. VAL(cCodNiv) <= 16
	       lHayErr := .F.

	  CASE cMaeAlu $ 'PRI' .AND. LEN(cMaeAlu) == 3 .AND.;
	       VAL(cCodNiv) >= 0 .AND. VAL(cCodNiv) <= 5
	       lHayErr := .F.

	  CASE cMaeAlu $ 'BTO' .AND. LEN(cMaeAlu) == 3 .AND.;
	       VAL(cCodNiv) >= 6 .AND. VAL(cCodNiv) <= 11
	       lHayErr := .F.

	  OTHERWISE
	       lHayErr := .T.
	       IF lMensaj
		  cError('EL NIVEL ESPECIFICADO NO ESTA DISPONIBLE')
	       ENDIF
	  ENDCASE

       ENDIF
       RETURN !lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DEL PROGRAMA..: LECTURA DE LOS NIVELES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 04:20 PM   ENE 03/96 MIE

OBJETIVOS:

1- Retorna por referencia los param‚tros de la funci¢n marcados con @

2- Lee el intervalo de niveles y el n£mero de copias a imprimir

3- Retorna .T. para continuar

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeeNivels(nNroFil,nNroCol,cNivIni,cNivFin,nCopias,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       cNivIni		                    // @Nivel Inicial
       cNivFin		                    // @Nivel Final
       nCopias		                    // @N£mero de copias
       cMaeAlu                              // Maestros Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt                        // Texto variable
       LOCAL cNivTem			    // Nivel Temporal
       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt := 'NIVEL INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'NIVEL FINAL  :'
       IF nCopias # NIL
	  @ nNroFil+2,nNroCol SAY 'NRO DE COPIAS:'
       ENDIF
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>LECTURA DE LOS NIVELES
       cNivIni := SPACE(02)
       cNivFin := SPACE(02)

       nNroCol := nNroCol + LEN(cMsgTxt)
       @ nNroFil  ,nNroCol GET cNivIni  PICT '@! XX';
			   VALID lValCodNiv(cNivIni,cMaeAlu)

       @ nNroFil+1,nNroCol GET cNivFin  PICT '@! XX';
			   VALID lValCodNiv(cNivFin,cMaeAlu)
       IF nCopias # NIL
	  nCopias := 1
	  @ nNroFil+2,nNroCol GET nCopias PICT '99'  VALID nCopias # 0
       ENDIF
       READ
*>>>>FIN LECTURA DE LOS NIVELES

*>>>>CONVERSION DEL NIVEL PARA JARDIN Y PRIMARIA
       IF 'JAR' $ cMaeAlu .OR. 'PRI' $ cMaeAlu
	  IF ISALPHA(cNivIni) .OR. '00' $ cNivIni
	     cNivIni := cConverNiv(cNivIni)
	  ENDIF
	  IF ISALPHA(cNivFin) .OR. '00' $ cNivIni
	     cNivFin := cConverNiv(cNivFin)
	  ENDIF
       ENDIF
*>>>>FIN CONVERSION DEL NIVEL PARA JARDIN Y PRIMARIA

*>>>>INTERCAMBIO DE NIVELES
       IF VAL(cNivIni) > VAL(cNivFin)
	  cNivTem := cNivIni
	  cNivIni := cNivFin
	  cNivFin := cNivTem
       ENDIF
       RETURN IF(EMPTY(cNivIni) .OR. EMPTY(cNivFin),.F.,;
		 lPregunta('DESEA CONTINUAR? Si No'))
*>>>>FIN INTERCAMBIO DE NIVELES


/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL CODIGO DEL ASPIRANTE               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 08:10 PM   ENE 03/96 MIE

OBJETIVOS:

1)- Lee el c¢digo del nivel

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeeCodNiv(nNroFil,nNroCol,cCodNiv,bValida)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodNiv				    // C¢digo del nivel
       bValida                              // Code Block de Validacion */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL lLeeyo  := .T.                 // .T. Ley¢ el c¢digo
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET ESCAPE ON   // Activa la <ESC> en los GET

       cSavLin := SAVESCREEN(21,0,21,79)
       Centrar('ENTRE EL NIVEL. '+;
	       'PARA TERMINAR PRESIONE: <ENTER> o <ESC>',21)

       cCodNiv := SPACE(02)
       @ nNroFil,nNroCol GET cCodNiv PICT '@! 99';
			 VALID lCorrecion(@cCodNiv) .AND.;
			 IF(EMPTY(cCodNiv),.T.,EVAL(bValida))
       READ

*       cCodNiv := cConverNiv(cCodNiv)
       @ nNroFil,nNroCol SAY cCodNiv COLOR("I")
     *ÀImprime el Codigo Convertido

       RESTSCREEN(21,0,21,79,cSavLin)
       SET ESCAPE OFF               // Activa la <ESC> en los GET

       IF LASTKEY() == K_ESC .OR. EMPTY(cCodNiv)
	  lLeeyo := .F.
       ENDIF
       RETURN lLeeyo
*>>>>FIN CAPTURA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: CONVERSION DEL CODIGO DEL NIVEL                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 10/96 SAB A
       Colombia, Bucaramanga        INICIO: 07:55 PM   FEB 10/96 SAB

OBJETIVOS:

1)- Convervierte el C¢digo Nivel para  Jardin al C¢digo
    que se necesite de acuerdo al par metro

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cConverNiv(cCodNiv)

*>>>>PARAMETROS DE LA FUNCION
/*       cCodNiv                            // C¢digo del Nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aNivels := {{'12','MA'},;
			 {'13','CA'},;
			 {'14','PA'},;
			 {'15','PR'},;
			 {'16','JA'},;
			 {'00','TR'}}       // Equivalencias de nivel
       LOCAL      i := 0                    // Contador
       LOCAL      j := 0                    // Contador
       LOCAL cNivel := ''                   // Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL PARAMETRO
       IF ISDIGIT(cCodNiv)
	  IF VAL(cCodNiv) < 12 .AND. VAL(cCodNiv) > 16
	     cError('MAL PASADO EL CODIGO DEL NIVEL')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL PARAMETRO

*>>>>CONVERSION DEL NIVEL NUMERICO
       j := 1
       IF ISALPHA(cCodNiv)
	  j := 2
       ENDIF

       FOR i:=1 TO LEN(aNivels)
	   IF aNivels[i,j] == cCodNiv
	      cNivel := aNivels[i,IF(j==1,2,1)]
	      EXIT
	   ENDIF
	   cNivel := cCodNiv
       ENDFOR
       RETURN cNivel
*>>>>CONVERSION DEL NIVEL

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DE JARDIN                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 10/95 SAB A
       Colombia, Bucaramanga        INICIO: 09:40 AM   FEB 10/95 SAB

OBJETIVOS:

1)- Valida en el c¢digo del nivel

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodJar(cCodNiv,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodNiv                              // C¢digo del nivel
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL NIVEL ALFABETICO
      IF 'JAR' $ cMaeAlu .AND. ISALPHA(cCodNiv)
	  IF cCodNiv == 'MA' .OR. cCodNiv == 'CA' .OR.;
	     cCodNiv == 'PA' .OR. cCodNiv == 'PR' .OR.;
	     cCodNiv == 'JA'
	     lHayErr := .F.
             cCodNiv := cConverNiv(cCodNiv)
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu .AND. lHayErr .AND. ISALPHA(cCodNiv)
	  IF cCodNiv == 'JB'
	     lHayErr := .F.
	     cCodNiv := cConverNiv(cCodNiv)
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL NIVEL ALFABETICO

*>>>>VALIDACION DEL NIVEL NUMERICO
      IF 'JAR' $ cMaeAlu .AND. !lHayErr
	  IF (VAL(cCodNiv) >= 12 .AND. VAL(cCodNiv) <= 16)
	     lHayErr := .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu .AND. !lHayErr
	  IF (VAL(cCodNiv) >= 0 .AND. VAL(cCodNiv) <= 5)
	     lHayErr := .F.
	  ENDIF
       ENDIF
	  
       RETURN !lHayErr
*>>>>FIN VALIDACION DEL NIVEL NUMERICO

/*************************************************************************
* TITULO DE LA FUNCION..: NOMBRE DEL NIVEL                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 11/96 DOM A
       Colombia, Bucaramanga        INICIO: 11:00 AM   FEB 11/96 DOM

OBJETIVOS:

1)- Determina el nombre del nivel

2)- Retorna el nombre del nivel

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomNiv(cCodNiv)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodNiv                              // C¢digo del nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cNomNiv := ''                  // Nombre del nivel

       LOCAL aNivel  := {'PRIMERO','SEGUNDO','TERCERO','CUARTO','QUINTO',;
			 'SEXTO','SEPTIMO','OCTAVO','NOVENO' ,'DECIMO',;
			 'UNDECIMO','MATERNALES','CAMINADORES','PARVULOS',;
			 'JARDIN','PREJARDIN','TRANSICION'}

       i := IF(VALTYPE(cCodNiv)=='C',VAL(cCodNiv),cCodNiv)
       RETURN IF(i==0,aNivel[17],aNivel[i])
*>>>>FIN DECLARACION DE VARIABLES

/*************************************************************************
* TITULO DEL PROGRAMA..: INTERVALO DE NIVELES                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 08/94 JUE A
						       SEP 08/94 JUE
OBJETIVOS:

1- Debe estar en uso el archivo de niveles

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite selecionar un intervalo de niveles

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lInterNiv(nNroFil,nNroCol,nRegIni,nRegFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                // N£mero de la fila
       nNroCol                // N£mero de la Columna
       nRegIni                // @Registro Inicial
       nRegFin                // @Registro Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt                  // Texto variable
       LOCAL nFilSup                  // Fila superior
       LOCAL nColSup                  // Colunma superior
       LOCAL nFilInf                  // Fila inferior
       LOCAL nColInf                  // Columna inferior
       LOCAL nRegTem                  // Registro temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt ='NIVEL INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'NIVEL FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT NIV
	nNroCol = nNroCol + LEN(cMsgTxt)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+1

	NIV->(DBGOTOP())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			      {||NIV->cCodigoNiv},.T.)
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	NIV->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY NIV->cCodigoNiv
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       NIV->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||NIV->cCodigoNiv},.T.)
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       NIV->(DBGOTO(nRegFin))
       @ nFilSup+1,nColSup SAY NIV->cCodigoNiv
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
* TITULO DE LA FUNCION..: APERTURA DEL ARCHIVO DE NIVELES                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:50 PM   FEB 02/96 VIE

OBJETIVOS:

1)- Pone en uso los archivos de alumnos de la contabilidad habilitados

2)- Retorna por referencia los param‚tros de la funci¢n marcados con @

3)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseNiv(lShared,cPatSis,cMaeAlu,cAnoSis,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cPatSis			            // Path del Sistema
       cMaeAlu                              // Maestros habilitados
       cAnoSis                              // A¤o del sistema
       lAnoAct                              // .F. A¤o Anteriores */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathNiv := ''                  // Path del Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lAnoAct := IF(lAnoAct == NIL,.T.,lAnoAct)
       IF 'JAR' $ cMaeAlu

	  PathNiv := cPatSis+'\JAR\'
	  IF !lUseDbf(.T.,PathNiv+FileNiv+cAnoSis+ExtFile,;
			  IF(lAnoAct,'NIV','NIV'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE JARDIN EN '+PathNiv)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu

	  PathNiv := cPatSis+'\PRI\'
	  IF !lUseDbf(.T.,PathNiv+FileNiv+cAnoSis+ExtFile,;
			  IF(lAnoAct,'NIV','NIV'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE PRIMARIA EN '+PathNiv)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu

	  PathNiv := cPatSis+'\BTO\'
	  IF !lUseDbf(.T.,PathNiv+FileNiv+cAnoSis+ExtFile,;
			  IF(lAnoAct,'NIV','NIV'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE BACHILLERATO EN '+PathNiv)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO