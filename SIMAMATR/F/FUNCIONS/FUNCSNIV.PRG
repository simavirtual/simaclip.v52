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

FUNCTION CreaDbfNiv(lShared,PathNiv,FileNiv,fNtxNiv,cMaeAct,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathNiv				    // Path del Archivo
       FileNiv				    // Nombre del Archivo
       fNtxNiv				    // Archivo de Indices
       cMaeAct			            // Maestro actual
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfStr := {}                  // Estructura del Archivo

       LOCAL       i := 0                   // Contador
       LOCAL nMinNiv := 0                   // M¡nimo nivel
       LOCAL nMaxNiv := 0                   // M ximo nivel
       LOCAL cCodigoTni := ''               // C¢digo del nivel

       LOCAL GetList := {}                  // Variable del sistema

       AADD(aDbfStr,{"cCodigoNiv","Character",02,0}) // C¢digo del nivel
       AADD(aDbfStr,{"lPlaGruNiv","Logical"  ,01,0}) // .T. Plan Acadimico por Grupos .F. Plan Academico por Niveles.
       AADD(aDbfStr,{"cIdentiNiv","Character",02,0}) // Identificaci¢n del Nivel. JA -> Jardin A
       AADD(aDbfStr,{"cNombreNiv","Character",12,0}) // Nombre del Nivel. Jardin B. Undecimo
       AADD(aDbfStr,{"nNroGruNiv","Numeric"  ,02,0}) // N£mero de grupos en el nivel
       AADD(aDbfStr,{"nVlrTotNiv","Numeric"  ,10,0}) // Valor Total Servicios Educativos.
       AADD(aDbfStr,{"nVlrUnoNiv","Numeric"  ,10,2}) // Valor Uno Contrato de Servicio
       AADD(aDbfStr,{"nVlrDosNiv","Numeric"  ,10,2}) // Valor Dos Contrato de Servicio
       AADD(aDbfStr,{"nVlrTreNiv","Numeric"  ,10,2}) // Valor Tres Contrato de Servicio
       AADD(aDbfStr,{"nVlrCuaNiv","Numeric"  ,10,2}) // Valor Cuatro Contrato de Servicio
       AADD(aDbfStr,{"nVlrCinNiv","Numeric"  ,10,2}) // Valor Cinco Contrato de Servicio
       AADD(aDbfStr,{"nVlrSeiNiv","Numeric"  ,10,2}) // Valor Seis Contrato de Servicio
       AADD(aDbfStr,{"nVlrSieNiv","Numeric"  ,10,2}) // Valor Siete Contrato de Servicio
       AADD(aDbfStr,{"nVlrOchNiv","Numeric"  ,10,2}) // Valor Ocho Contrato de Servicio
       AADD(aDbfStr,{"nVlrNueNiv","Numeric"  ,10,2}) // Valor Nueve Contrato de Servicio
       AADD(aDbfStr,{"nVlrDieNiv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr011Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr012Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr013Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr014Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr015Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr016Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr017Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr018Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr019Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
       AADD(aDbfStr,{"nVlr020Niv","Numeric"  ,10,2}) // Valor Dies Contrato de Servicio
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathNiv) == 0
	    DBCREATE(FileNiv,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathNiv) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathNiv)

       CASE DIRCHANGE(PathNiv) == -5
	    cError('NO TIENE DERECHOS EN: '+PathNiv)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !EMPTY(cMaeAct)
	  IF !lUseDbf(.T.,PathNiv+'\'+FileNiv,'NIV',NIL,lShared)
	     cError('ABRIENDO EL ARCHIVO NIVELES EN CREACION DE ESTRUCTURAS')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>SELECCION DEL MAXIMO NIVEL
       IF !EMPTY(cMaeAct)

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

       ENDIF
*>>>>FIN SELECCION DEL MAXIMO NIVEL

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF !EMPTY(cMaeAct)

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
	  CloseDbf('NIV')

       ENDIF
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

FUNCTION RecuDbfNiv(lShared,PathNiv,FileNiv,fNtxNiv,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathNiv			      // Path del Archivo
       FileNiv			      // Nombre del Archivo
       fNtxNiv			      // Archivo de Indice
       cMaeAct			      // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathNiv+'\'+FileNiv,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE NIVELES")
       Termometro(100)

       CreaDbfNiv(lShared,PathNiv,FileNiv,fNtxNiv,cMaeAct)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 15/2002 VIE A
       Colombia, Bucaramanga        INICIO: 11:55 PM   NOV 15/2002 VIE

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

FUNCTION nActStrNiv(lShared,PathArc,cNomArc,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo
       cMaeAct			            // Maestro Actual */
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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'NIV',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO EN ACTUALIZACION')
	  CloseDbf('NIV')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := NIV->(DBSTRUCT())
       CloseDbf('NIV')
       CreaDbfNiv(lShared,PathArc,cNomArc,,cMaeAct,@aStrNew)
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
       IF lCambio .AND. lShared
	  cError('NIVELES DE '+cMaeAct+' su Estructura Esta DesActualizada.',;
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
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfNiv(lShared,PathArc,FileTem,,cMaeAct)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL CODIGO DEL NIVEL                   *
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
* TITULO DEL PROGRAMA..: INTERVALO DE NIVELES                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 08/96 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 08/96 JUE

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
			      {||NIV->cCodigoNiv},,.T.)
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	NIV->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY NIV->cCodigoNiv
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       NIV->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||NIV->cCodigoNiv},,.T.)
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
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lAnoAct := IF(lAnoAct == NIL,.T.,lAnoAct)
       IF 'JAR' $ cMaeAlu

	  PathNiv := cPatSis+'\JAR\'
	  IF !lUseDbf(.T.,PathNiv+FileNiv+cAnoSis+ExtFile,;
			  IF(lAnoAct,'NIV','NIV'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE JARDIN EN '+PathNiv)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu

	  PathNiv := cPatSis+'\PRI\'
	  IF !lUseDbf(.T.,PathNiv+FileNiv+cAnoSis+ExtFile,;
			  IF(lAnoAct,'NIV','NIV'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE PRIMARIA EN '+PathNiv)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu

	  PathNiv := cPatSis+'\BTO\'
	  IF !lUseDbf(.T.,PathNiv+FileNiv+cAnoSis+ExtFile,;
			  IF(lAnoAct,'NIV','NIV'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE BACHILLERATO EN '+PathNiv)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL NIVEL                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/96 MAR A
       Colombia, Bucaramanga        INICIO: 01:45 PM   AGO 13/96 MAR

1- Debe estar en uso el archivo Niveles

2- Realiza la validaci¢n del c¢digo del Nivel

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValNivel(nNroFil,nNroCol,cCodNiv,nRegNiv)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodNiv			            // Codigo del nivel
       nRegNiv			            // @Registro del Nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       IF !lLocCodigo('cCodigoNiv','NIV',cCodNiv)
	  lSelNivel(nNroFil,nNroCol,@nRegNiv)
	  IF nRegNiv == 0
	     cCodNiv := cSpaces('NIV','cCodigoNiv')
	  ELSE
	     GO nRegNiv
	     cCodNiv := NIV->cCodigoNiv
	  ENDIF
       ELSE
	  nRegNiv := RECNO()
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DE UN NIVEL                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/96 MAR A
       Colombia, Bucaramanga        INICIO: 01:50 PM   AGO 13/96 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de Niveles

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite escoger un nivel determinado

4- Retorna .T. si escogio el nivel

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSelNivel(nNroFil,nNroCol,nNroReg,cTitulo)

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
	SELECT NIV
	nNroCol = nNroCol + LEN(cTitulo)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - 1
	ENDIF
	nColInf := nColSup+1

	NIV->(DBGOTOP())
	nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||NIV->cCodigoNiv})
	IF nNroReg == 0
	   RETURN .F.
	ENDIF
	NIV->(DBGOTO(nNroReg))
	@ nFilSup,nColSup SAY NIV->cCodigoNiv
	RETURN .T.
*>>>>FIN SELEECION DEL GRUPO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE CONCEPTOS         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 26/96 LUN A
       Colombia, Bucaramanga        INICIO: 11:20 AM   AGO 26/96 LUN

OBJETIVOS:

1- Permite el mantenimiento del archivo Niveles

SINTAXIS:

MantenNiv()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenNiv(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		   cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		   cMaeAlu,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro

       LOCAL oBrwNiv := NIL                 // Objeto para el Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       LeePathMaA(lShared,cPatSis,cAnoUsr,;
		  @cIntUno,@cIntDos,@cIntTre,@cIntCua)
     *ÀLectura de paths

       cIntUno := IF(lIntUno,cIntUno,cPatSis)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cIntUno+'\'+cMaeAct+'\'+;
		   FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO NIVELES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwNiv := oDefBrwNiv(lShared,nFilPal+1,00,22,79)
       NIV->(CtrlBrw(lShared,oBrwNiv))
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE NIVELES	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 26/96 LUN A
       Colombia, Bucaramanga        INICIO: 11:25 AM   AGO 26/96 LUN

OBJETIVOS:

1- Define el objeto Browse del archivo Niveles

SINTAXIS:

 oBrwNiv := oDefBrwNiv(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwNiv(lShared,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwNiv := NIL		    // Browse de Niveles
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwNiv := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwNiv:ColSep    := '³'
       oBrwNiv:HeadSep   := 'Ä'
       oBrwNiv:Cargo     := {'<<MANTENIMIENTO DE NIVELES>>',;
			    '<ENTER>Modificar   <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT NIV
       oColumn	     := TBCOLUMNNEW('CODIGO', {||NIV->cCodigoNiv})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IDENTIFICACION DEL NIVEL',;
				   {||NIV->cIdentiNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'},{'FIELD','cIdentiNiv'},;
			 {'PICTURE','@!'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL NIVEL', {||NIV->cNombreNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','cNombreNiv'},;
			 {'PICTURE','@!'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO DE GRUPOS', {||NIV->nNroGruNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nNroGruNiv'},;
			 {'PICTURE','99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR1', {||NIV->nVlrUnoNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrUnoNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR2', {||NIV->nVlrDosNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrDosNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR3', {||NIV->nVlrTreNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrTreNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR4', {||NIV->nVlrCuaNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrCuaNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR5', {||NIV->nVlrCinNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrCinNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR6', {||NIV->nVlrSeiNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrSeiNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR7', {||NIV->nVlrSieNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrSieNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR8', {||NIV->nVlrOchNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrOchNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR9', {||NIV->nVlrNueNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrNueNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR10', {||NIV->nVlrDieNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlrDieNiv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR11', {||NIV->nVlr011Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr011Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR12', {||NIV->nVlr012Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr012Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR13', {||NIV->nVlr013Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr013Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR14', {||NIV->nVlr014Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr014Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR15', {||NIV->nVlr015Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr015Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR16', {||NIV->nVlr016Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr016Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR17', {||NIV->nVlr017Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr017Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR18', {||NIV->nVlr018Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr018Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR19', {||NIV->nVlr019Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr019Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR20', {||NIV->nVlr020Niv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nVlr020Niv'},;
			 {'PICTURE','9999999.99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwNiv
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL GRUPO DEL NIVEL      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 27/96 MAR A
       Colombia, Bucaramanga        INICIO: 11:40 AM   AGO 27/96 MAR

OBJETIVOS:

1)- Valida si el c¢digo del grupo se encuentra valido en el intervalo
    del total de grupos en el nivel

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValGru(cCodNiv,nNroGru,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodNiv                              // C¢digo del nivel
       nNroGru                              // N£mero del grupo
       lMensaj                              // .T. Imprimir Mensaje */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS PARAMETROS
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>LOCALIZACION DEL NIVEL
       IF lLocCodigo('cCodigoNiv','NIV',cCodNiv)
	  IF nNroGru == 0 .OR. nNroGru > NIV->nNroGruNiv
	     IF lMensaj
		cError('EL GRUPO '+STR(nNroGru,2)+' NO EXISTE')
		lHayErr := .T.
	     ENDIF
	  ENDIF
       ELSE
	  cError('EL NIVEL '+cCodNiv+' NO EXISTE')
       ENDIF
       RETURN !lHayErr
*>>>>FIN LOCALIZACION DEL NIVEL

/*************************************************************************
* TITULO DE LA FUNCION..: MAESTRO ACTUAL DE ACUERDO AL NIVEL             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 13/96 VIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   DIC 13/96 VIE

OBJETIVOS:

1- Seleciona el maestro Actual de Acuerdo al Nivel

2- Retorna el maestro actual

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cMaeActNiv(cCodNiv)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodNiv                              // C¢digo del nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMaeAct := ''                  // Maestro Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL NIVEL
       DO CASE
       CASE VAL(cCodNiv) >= 0 .AND. VAL(cCodNiv) <= 5
	    cMaeAct := 'PRI'

       CASE VAL(cCodNiv) >= 6 .AND. VAL(cCodNiv) <= 11
	    cMaeAct := 'BTO'

       CASE VAL(cCodNiv) >= 12 .AND. VAL(cCodNiv) <= 16
	    cMaeAct := 'JAR'

       OTHERWISE
	    cMaeAct := 'ERROR'
       ENDCASE
       RETURN cMaeAct
*>>>>FIN ANALISIS DEL NIVEL