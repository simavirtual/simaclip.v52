/*            BIBLIOTECAS DE FUNCIONES PARA LA AYUDA DEL SISTEMA

REQUERIMIENTOS

- Compilar: clipper FuncsAyu /w/m

OBJETIVOS

- Son independientes de cualquier programa

FUNCIONES

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES GENERALES
       #INCLUDE "inkey.ch"
*>>>>FIN DECLARACION DE CONSTANTES GENERALES

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2000 JUE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   SEP 28/2000 JUE

OBJETIVOS:

1)- Crea la estructura del archivo.

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfHlp(lShared,nModCry,PathHlp,FileHlp,lIntUno,fNtxHlp,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathHlp				    // Path del Archivo
       FileHlp				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxHlp				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfHlp := {{"cCodigoHlp","Character",20,0},; // C¢digo de la Ayuda
			 {"mAyudasHlp","Memo"     ,10,0}}  // Texto de Ayuda
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfHlp
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathHlp) == 0
	    DBCREATE(FileHlp,aDbfHlp,"DBFNTX")
	    Proteger(FileHlp,nModCry)

       CASE DIRCHANGE(PathHlp) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathHlp)

       CASE DIRCHANGE(PathHlp) == -5
	    cError('NO TIENE DERECHOS EN: '+PathHlp)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2000 JUE A
       Colombia, Bucaramanga        INICIO: 05:40 PM   SEP 28/2000 JUE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfHlp(lShared,nModCry,PathHlp,FileHlp,lIntUno,fNtxHlp)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathHlp			      // Path del Archivo
       FileHlp			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxHlp			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathHlp+'\'+FileHlp,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DE LA MATRICULA")
       Termometro(100)

       CreaDbfHlp(lShared,nModCry,PathHlp,FileHlp,lIntUno,fNtxHlp)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2000 JUE A
       Colombia, Bucaramanga        INICIO: 05:45 PM   SEP 28/2000 JUE

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

FUNCTION nActStrHlp(lShared,nModCry,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'HLP',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION GENERAL')
	  CloseDbf('HLP',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := HLP->(DBSTRUCT())
       CloseDbf('HLP',PathArc+'\'+cNomArc,nModCry)
       CreaDbfHlp(lShared,nModCry,PathArc,cNomArc,,,@aStrNew)
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
	  cError('El Archivo AYUDAS su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfHlp(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: CONSULTA DEL TEXTO DE LA AYUDA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2000 JUE A
       Colombia, Bucaramanga        INICIO: 05:45 PM   SEP 28/2000 JUE

OBJETIVOS:

1- Permite consultar y modificar el texto de ayuda.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AYUDA(nModCry,cNomPrg,nNroLin,cNomVar,cColorM,cColorF,lInsHlp)

*>>>>DESCRIPCION DE PARAMETROS
/*     nModCry                              // Modo de Protecci¢n
       cNomPrg                              // Nombre del Programa
       nNroLin                              // N£mero de L¡nea
       cNomVar                              // Variable que se edita
       cColorM                              // Color del Marco y Mensajes
       cColorF                              // Color del Fondo
       lInsHlp                              // Insertar la Ayuda */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cCurSel
       LOCAL cCurColor
       LOCAL aCampos
       LOCAL Sel
       LOCAL bAyuda

       FIELD TEXTO,CODIGO IN Ayuda
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONTROL DE PARAMETROS
       cSavPan := SAVESCREEN(0,0,24,79)
       cCurSel := LTRIM(STR(SELECT()))
       IF cColorM # NIL .AND. VALTYPE(cColorM) # "C" .OR.;
	  cColorF # NIL .AND. VALTYPE(cColorF) # "C" .OR.;
	  VALTYPE(lInsHlp) # "L"
	  RETURN -1
       ENDIF
*>>>>FIN CONTROL DE PARAMETROS

*>>>>INSERCION DEL TEXTO DE AYUDA
       bAyuda := SETKEY(28, {|| NIL})
       IF lInsHlp
	  SETKEY(306, {|x,y|MODMEMO(cNomPrg,cNomVar)})   // Alt+M
       ENDIF
*>>>>FIN INSERCION DEL TEXTO DE AYUDA

*>>>>CREACION DEL ARCHIVO DE LA AYUDA
       IF .NOT. FILE("AYUDA.DBF")
	  aCampos := {}
	  AADD(aCampos, {"CODIGO", "C", 20, 0})
	  AADD(aCampos, {"TEXTO", "M", 10, 0})
	  DBCREATE("AYUDA", aCampos)
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO DE LA AYUDA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       DBUSEAREA(.T.,,"AYUDA",,.T.)
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CREACION DEL ARCHIVO DEL INDICE
       IF !FILE("AYUDA.NTX")
	   DBCREATEINDEX("AYUDA","Codigo",{|| CODIGO})
       ELSE
	   DBSETINDEX("AYUDA")
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO DEL INDICE

*>>>>BUSQUEDA DE LA AYUDA
       DBSEEK(cNomPrg+cNomVar)
*>>>>FIN BUSQUEDA DE LA AYUDA

*>>>>MARCO DE LA AYUDA
       SETCOLOR(IF(cColorM # NIL,cColorM,SETCOLOR()))

       @ 2,2,24,78 BOX ;
	 CHR(201)+CHR(205)+CHR(187)+CHR(186)+CHR(188)+CHR(205)+;
	 CHR(200)+CHR(186)+CHR(32)
       @ 24,8 SAY "[AvP g], [ReP g], [], [], [Esc]"

       SETCOLOR(IF(cColorF # NIL,cColorF,SETCOLOR()))
*>>>>FIN MARCO DE LA AYUDA

*>>>>VISUALIZA EL TEXTO DE LA AYUDA
       IF DBSEEK(cNomPrg+cNomVar)
	  MEMOEDIT(TEXTO,3,3,23,77,.F.)
       ELSE
       *   cError("No existe ayuda para este proceso")
	  @ 10,10 SAY "No existe ayuda para este proceso"
	  xInkey(0)
       ENDIF
       DBCLOSEAREA()
       SELECT(cCurSel)
       SETCOLOR(cCurColor)
       SETKEY(306, {|| NIL})
       SETKEY(28, bAyuda)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN VISUALIZA EL TEXTO DE LA AYUDA

/*************************************************************************
* TITULO..: MODIFICACION DEL TEXTO DE LA AYUDA                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2000 JUE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   SEP 28/2000 JUE

OBJETIVOS:

1- Permite editar y modificar el campo memo del texto de la ayuda

2- [Alt+M] -> Permite modificar el texto de la ayuda

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

STATIC FUNCTION ModMemo(cA,cB)

*>>>>DESCRIPCION DE PARAMETROS
/*     cA                                   // Pendiente
       cB                                   // Pendiente */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       FIELD CODIGO, TEXTO IN ayuda
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL ALIAS
       IF ALIAS()#"AYUDA"
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ALIAS

*>>>>ANALISIS DE LA BUSQUEDA
       DO CASE
	  CASE FOUND()
	       BloqueaReg()
	       TEXTO := MEMOEDIT(TEXTO,3,3,23,77)
	       UNLOCK
	  CASE !FOUND()
	       DBAPPEND()
	       CODIGO := cA+cB
	       TEXTO  := MEMOEDIT(TEXTO,3,3,23,77)
	       UNLOCK
       ENDCASE
       KEYBOARD CHR(K_ESC)  // Desaparece la pantalla tras ser editado
       RETURN NIL
*>>>>FIN ANALISIS DE LA BUSQUEDA

/*************************************************************************
* TITULO..: BLOQUEO DEL REGISTRO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2000 JUE A
       Colombia, Bucaramanga        INICIO: 06:45 PM   SEP 28/2000 JUE

OBJETIVOS:

1- Permite editar y modificar el campo memo del texto de la ayuda

2- [Alt+M] -> Permite modificar el texto de la ayuda

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BloqueaReg( nTiempo )
  LOCAL lInsHlp,cPantal

  // Comprobaci¢n de si se ha pasado o no par metro
  IF nTiempo = NIL
     nTiempo := 0
  END IF

  // Comprobaci¢n del tipo de par metro
  IF VALTYPE( nTiempo ) != "N"
     RETURN ( .F. )
  END IF


  // Se comprueba si existe fichero .DBF activo
  IF EMPTY( ALIAS( ) )
     RETURN ( .F. )
  END IF

  // Si el bloqueo tiene ‚xito
  IF RLOCK( )
     RETURN ( .T. )
  END IF

  // Para diferenciar si es tiempo indefinido
  lInsHlp := IIF( nTiempo = 0 , .T. , .F. )

  cPantal := SAVESCREEN( 12,15,14,58 )
  WHILE nTiempo > 0 .OR. lInsHlp
     INKEY( 1 )

     // Se activa pantalla de visualizaci¢n
     IF LASTKEY( ) = K_ENTER
        // Mostramos el nombre del fichero
        @ 12,15,14,58 BOX "ÚÄ¿³ÙÄÀ³ "
        @ 13,17 SAY "Intentado Bloquear Registro de " +;
                    UPPER( ALIAS( ) )
     END IF
     nTiempo--

     // Si el bloqueo tiene ‚xito
     IF RLOCK( )
        RESTSCREEN( 12,15,14,58,cPantal )
        RETURN ( .T. )
     END IF
  END
  RESTSCREEN( 12,15,14,58,cPantal )
RETURN ( .F. )      // No se ha podido realizar el bloqueo

/*************************************************************************
* TITULO..: ESTADO DE ESPERO                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2000 JUE A
       Colombia, Bucaramanga        INICIO: 06:45 PM   SEP 28/2000 JUE

OBJETIVOS:

1- Permite editar y modificar el campo memo del texto de la ayuda

2- [Alt+M] -> Permite modificar el texto de la ayuda

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xInkey( nSegundos, bBloque, cMens )
LOCAL nTecla, bBloqueTecla, nTranscurrido,;
      nTiempo := Seconds( ),nFila:=ROW(), nCol:=COL(),;
      cLinea  := SAVESCREEN(0,0,24,79)

  IF cMens != NIL
*     @ FILAREQ, COLREQ SAY cMens
  END IF

  WHILE .T.
    WHILE ( nTecla:=Inkey() ) == 0
      IF (nTranscurrido:=Seconds()-nTiempo)>=nSegundos.AND.;
          nSegundos != 0
         RETURN 0
      END IF
      IF bBloque != NIL .AND. VALTYPE( bBloque ) = 'B'
         EVAL(bBloque)
      END IF
    END

    IF ( bBloqueTecla := SETKEY( nTecla ) ) != NIL
       EVAL(bBloqueTecla, PROCNAME( 1 ), PROCLINE( 1 ) )
       nTiempo := Seconds( ) - nTranscurrido
    ELSE
       EXIT
    END IF
  END

  IF cMens != NIL
*     RESTSCREEN(FILAREQ, COLREQ, FILAREQ, MAXCOL(), cLinea )
     RESTSCREEN(0,0,24,79,cLinea)
     DEVPOS( nFila, nCol )
  END IF

RETURN nTecla