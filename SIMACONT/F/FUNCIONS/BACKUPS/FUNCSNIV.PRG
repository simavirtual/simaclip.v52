/*               	 SISTEMA CONTABILIDAD ACADEMICA
		 BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO NIVELES

REQUERIMIENTOS:

- Compilar: clipper FuncsNiv /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo niveles

FUNCIONES:

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:05 PM   OCT 06/95 VIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfNiv(PathNiv,FileNiv,fNtxNiv)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfNiv(lShared,PathNiv,FileNiv,fNtxNiv,cMaeAct,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       PathNiv				    // Path del Archivo
       FileNiv				    // Nombre del Archivo
       fNtxNiv				    // Archivo de Indices
       cMaeAct			            // Maestro Actual
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfStr := {}                  // Estructura del Archivo

       LOCAL       i := 0                   // Contador
       LOCAL nMinNiv := 0                   // M¡nimo nivel
       LOCAL nMaxNiv := 0                   // M ximo nivel
       LOCAL cCodigoTni := ''               // C¢digo del nivel

       AADD(aDbfStr,{"cCodigoNiv","Character",02,0}) // C¢digo del nivel
       AADD(aDbfStr,{"lPlaGruNiv","Logical"  ,01,0}) // .T. Plan Acadimico por Grupos .F. Plan Academico por Niveles.
       AADD(aDbfStr,{"cIdentiNiv","Character",02,0}) // Identificaci¢n del Nivel. JA -> Jardin A
       AADD(aDbfStr,{"cNombreNiv","Character",12,0}) // Nombre del Nivel. Jardin B. Undecimo
       AADD(aDbfStr,{"nNroGruNiv","Numeric"  ,02,0}) // N£mero de grupos en el nivel
       AADD(aDbfStr,{"nVlrTotNiv","Numeric"  ,10,0}) // Valor Total Servicios Educativos. Valor Inicial segun dadacredito
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
       IF !lUseDbf(.T.,PathNiv+'\'+FileNiv,'NIV',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE GRADOS EN CREACION DE ESTRUCTURAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>SELECCION DEL MAXIMO NIVEL
       DO CASE
       CASE 'JAR' $ cMaeAct
	    nMinNiv := 12
	    nMaxNiv := 16
       CASE 'PRI' $ cMaeAct
	    nMinNiv := 0
	    nMaxNiv := 5
       CASE 'BTO' $ cMaeAct
	    nMinNiv := 6
	    nMaxNiv := 11
       ENDCASE
*>>>>FIN SELECCION DEL MAXIMO NIVEL

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       FOR i := nMinNiv TO nMaxNiv
	   cCodigoTni := STR(i,2)
	   lCorrecion(@cCodigoTni,.T.)
	   IF NIV->(lRegLock(lShared,.T.))
	      REPL NIV->cCodigoNiv WITH cCodigoTni
	      REPL NIV->lPlaGruNiv WITH .F.
	      REPL NIV->nNroGruNiv WITH 0
	      NIV->(DBCOMMIT())
	   ELSE
	      cError('NO SE GRABA GRADO')
	   ENDIF
	   IF lShared
	      NIV->(DBUNLOCK())
	   ENDIF
       NEXT
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:10 PM   OCT 06/95 VIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfNiv(lShared,PathNiv,FileNiv,fNtxNiv,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Archivos Compartidos
       PathNiv			      // Path del Archivo
       FileNiv			      // Nombre del Archivo
       fNtxNiv			      // Archivo de Indice
       cMaeAct			      // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathNiv+'\'+FileNiv,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE LOS GRADOS")
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
* TITULO DE LA FUNCION..: VALIDACION DEL NIVEL                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:15 PM   OCT 06/95 VIE

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
	     cCodNiv := cSpaField('NIV','cCodigoNiv')
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:16 PM   OCT 06/95 VIE

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
* TITULO DEL PROGRAMA..: INTERVALO DE NIVELES                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:18 PM   OCT 06/95 VIE

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
       cMsgTxt ='GRADO INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'GRADO FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT NIV
	nNroCol = nNroCol + LEN(cMsgTxt)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()-1
	ENDIF
	nColInf := nColSup+1

	NIV->(DBGOTOP())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||NIV->cCodigoNiv})

	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	NIV->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY NIV->cCodigoNiv
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       NIV->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||NIV->cCodigoNiv})
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
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE CONCEPTOS         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 04/97 MAR A
       Colombia, Bucaramanga        INICIO: 10:30 AM   FEB 04/97 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo Niveles

SINTAXIS:

MantenNiv()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenNiv(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		   cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		   lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		   cJornad)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nModCry := 0                   // Modo de Protecci¢n

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL oBrwNiv := NIL                 // Objeto para el Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,;
			 cMaeAct,NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+'GRU'+;
			 cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CON->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       IF !lFileLock()
	  oBrwNiv := oDefBrwNiv(lShared,nFilPal+1,00,22,79)

	  SETKEY(K_F9,{||MenuOtrNiv(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,;
				    cNomEmp,cNomDpt,cNomMun,nFilPal,nFilInf,;
				    nColInf,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
				    lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
				    cJorTxt,cJornad,oBrwNiv)})

	  NIV->(CtrlBrw(lShared,oBrwNiv))
       ENDIF
       DBUNLOCKALL()
       CloseAll(aUseDbf)
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
       oBrwNiv:Cargo     := {'<<MANTENIMIENTO DE GRADOS>>',;
			    '<ENTER>Modificar <F9>Otros <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT NIV
       oColumn	     := TBCOLUMNNEW('CODIGO', {||NIV->cCodigoNiv})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IDENTIFICACION DEL GRADO',;
				   {||NIV->cIdentiNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'},{'FIELD','cIdentiNiv'},;
			 {'PICTURE','@!'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL GRADO', {||NIV->cNombreNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','cNombreNiv'},;
			 {'PICTURE','@!'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO DE CURSOS', {||NIV->nNroGruNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','nNroGruNiv'},;
			 {'PICTURE','99'}}
       oBrwNiv:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PLAN POR CURSO', {||NIV->lPlaGruNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'}, {'FIELD','lPlaGruNiv'},;
			 {'PICTURE','@!'}}
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

       RETURN oBrwNiv
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: SIGUIENTE NIVEL                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 13/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   NOV 13/2002 MIE

OBJETIVOS:

1- Promueve al siguiente nivel o grado del estudiante.

2- Retorna el siguiente nivel.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSgteNiv(cCodNiv)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodNiv                              // C¢digo del Nivel */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSgtNiv := ''                  // Siguiente Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PROMOCION AL SIGUIENTE NIVEL
       IF cCodNiv == '16'
	  cSgtNiv := '00'
       ELSE
	  IF cCodNiv # '11'
	     cSgtNiv := STR(VAL(cCodNiv)+1,2)
	  ENDIF
       ENDIF
       lCorrecion(@cSgtNiv)
       RETURN cSgtNiv
*>>>>FIN PROMOCION AL SIGUIENTE NIVEL

/*************************************************************************
* TITULO..: MENU DE INFORMES                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 07/2003 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   ABR 07/2003 MAR

OBJETIVOS:

1- Menu de informes para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrNiv(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		    cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		    lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		    cJornad,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION Y EJECUCION DEL MENU
       AADD(aMenus,'1<MATERIAS NO IMPRIMIR  >')
       AADD(aMenus,'2<ESTUDIANTES POR EDADES>')
       AADD(aMenus,'3<AREAS NO IMPRIMIR     >')

       AADD(aAyuda,'Imprime las Materias que NO se imprimen en el Boletin')
       AADD(aAyuda,'Imprime el total de Estudiantes por Edades')
       AADD(aAyuda,'Permite activar para que no se impriman las Areas en el Boletin')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1

	    OtrNiv01(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		     cNomDpt,cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,;
		     cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		     cMaeAlu,cMaeAct,cJorTxt,cJornad,oBrowse)
	  *ÀMaterias NO se imprimen en el boletin

       CASE nNroOpc == 2

	    OtrNiv02(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		     cNomDpt,cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,;
		     cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		     cMaeAlu,cMaeAct,cJorTxt,cJornad,oBrowse)
	  *ÀEstudiantes por Edades.

       CASE nNroOpc == 3

	    OtrNiv03(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		     cNomDpt,cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,;
		     cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		     cMaeAlu,cMaeAct,cJorTxt,cJornad,oBrowse)
	  *ÀAreas NO se imprimen en el boletin

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: MATERIAS NO IMPRIMIBLES.                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 07/2003 MAR A
       Colombia, Bucaramanga        INICIO: 03:30 AM   ABR 07/2003 MAR

OBJETIVOS:

1- Imprime un informe con los Estudiantes Retirados

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrNiv01(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		  cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		  lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		  cJornad,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL cNombreTma := ''               // Nombre de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('MATERIA NO EXISTEN')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := NIV->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis+' JORNADA: '+cJorTxt+' DE '+cAnoUsr,;
		   'MATERIAS QUE NO SE IMPRIMEN',;
		   '',;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}

       cCodIni := PCL({"DraftOn","CondenOn"})
       cCodFin := PCL({"DraftOn","CondenOn"})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,06,80,02,02,02,02,02}
       aTitulo := {'NIVEL ','GRUPO ','CODMAT','NOMBRE DE LA MATERIA',;
		   'P1','P2','P3','P4','P5'}
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>SELECCION DEL TIPO DE IMPRESION
       ActivaPrn(lShared,cNomSis,PathSis,fSimaCo,'cColaAcCon','Con')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset"})

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS RECUPERACIONES
       cSavPan := SAVESCREEN(0,0,24,79)
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********VISUALIZACION DE AVANCE
	    SET DEVICE TO SCREEN
	    LineaEstado('REGISTRO: '+STR(NIV->(RECNO()),5)+'/'+;
			 STR(NIV->(RECCOUNT()),5),cNomSis)
	    SET DEVICE TO PRINT
**********FIN VISUALIZACION DE AVANCE

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			   cFilePlan(cAnoUsr,GRU->cCodigoGru),'PLA',NIL,lShared)

	       cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		       cNomNiv(SUBS(GRU->cCodigoGru,1,2)))

	       CloseDbf('PLA')
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO POR PLAN ACADEMICO
	    SELECT PLA
	    PLA->(DBGOTOP())
	    DO WHILE .NOT. PLA->(EOF())

*--------------ANALISIS DE DECISION
		 IF EMPTY(PLA->cPrnBolPla)
		    PLA->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE DECISION

*--------------LOCALIZACION DE LA MATERIA
		 cNombreTma := PLA->cCodigoMat+' MATERIA NO EXISTE'
		 IF lLocCodigo('cCodigoMat','MAT',PLA->cCodigoMat)
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIA

*--------------IMPRESION DEL REGISTRO
		 aTitulo := {NIV->cCodigoNiv,;
			     GRU->cCodigoGru,;
			     PLA->cCodigoMat,;
			     cNombreTma,;
			     IF(SUBS(PLA->cPrnBolPla,1,1)=='1','N','S'),;
			     IF(SUBS(PLA->cPrnBolPla,2,1)=='1','N','S'),;
			     IF(SUBS(PLA->cPrnBolPla,3,1)=='1','N','S'),;
			     IF(SUBS(PLA->cPrnBolPla,4,1)=='1','N','S'),;
			     IF(SUBS(PLA->cPrnBolPla,5,1)=='1','N','S')}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*--------------FIN IMPRESION DEL REGISTRO

	       PLA->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR PLAN ACADEMICO

**********AVANCE DEL SIGUIENTE REGISTRO
	    GRU->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       SELECT NIV
       NIV->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: ESTUDIANTES POR EDADES                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 22/2003 MAR A
       Colombia, Bucaramanga        INICIO: 12:54 AM   AGO 22/2003 MAR

OBJETIVOS:

1- Imprime los estudiates por edades.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrNiv02(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		  cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		  lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		  cJornad,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL     i,k := 0                   // Contadores
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nSexFem := 0                   // Sexo Femenino
       LOCAL nSexMas := 0                   // Sexo Masculino
       LOCAL aTotAno := {}                  // Totales por Edad
       LOCAL nNroAno := 0                   // N£mero de A¤os
       LOCAL dFecAct := CTOD('00/00/00')    // Fecha de Corte para la Edad

       LOCAL cNombreTma := ''               // Nombre de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRADOS ESTUDIO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DE LA FECHA
       cSavPan := SAVESCREEN(0,0,24,79)
       TitBuscar(10,@nNroFil,@nNroCol,;
		 'FECHA DE CORTE:','FECHA',13)

       SETCURSOR(1)
       dFecAct := DATE()
       @ nNroFil,nNroCol GET dFecAct
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA FECHA

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := NIV->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis+' JORNADA: '+cJorTxt+' DE '+cAnoUsr,;
		   'ESTUDIANTES POR EDADES A '+cFecha(dFecAct),;
		   '',;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}

       cCodIni := PCL({"DraftOn","CondenOn"})
       cCodFin := PCL({"DraftOn","CondenOn"})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,04,08,08}
       aTitulo := {'GRADO','EDAD','HOMBRES','MUJERES'}
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>SELECCION DEL TIPO DE IMPRESION
       ActivaPrn(lShared,cNomSis,PathSis,fSimaCo,'cColaAcCon','Con')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset"})

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO POR GRADOS
       cSavPan := SAVESCREEN(0,0,24,79)
       NIV->(DBGOTOP())
       DO WHILE .NOT. NIV->(EOF())

**********LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('REGISTRO: '+STR(NIV->(RECNO()),5)+'/'+;
			 STR(NIV->(RECCOUNT()),5),cNomSis)
	    SET DEVICE TO PRINT
**********FIN LINEA DE ESTADO

**********FILTRACION DE LOS ESTUDIANTES
	    SELECT &cMaeAct
	    SET FILTER TO
	    SET FILTER TO SUBS(cCodigoGru,1,2) == NIV->cCodigoNiv
	    DBGOTOP()
**********FIN FILTRACION DE LOS ESTUDIANTES

**********RECORRIDO POR LOS ESTUDIANTES
	    aTotAno := {}
	    SELECT &cMaeAct
	    DO WHILE .NOT. EOF()

*--------------ANALISIS DEL SEXO
		 IF &cMaeAct->lSexFemEst
		    nSexFem := 1
		    nSexMas := 0
		 ELSE
		    nSexFem := 0
		    nSexMas := 1
		 ENDIF
*--------------FIN ANALISIS DEL SEXO

*--------------CALCULOS A¥OS CUMPLIDOS
		 nNroAno := nAnosSi(&cMaeAct->dFecNacEst,dFecAct)
		 IF EMPTY(aTotAno)
		    AADD(aTotAno,{nNroAno,nSexMas,nSexFem})
		 ELSE
		    i := ASCAN(aTotAno,{|aArr|aArr[1] == nNroAno})
		    IF i == 0
		       AADD(aTotAno,{nNroAno,nSexMas,nSexFem})
		    ELSE
		       aTotAno[i,2] += nSexMas
		       aTotAno[i,3] += nSexFem
		    ENDIF
		 ENDIF
*--------------FIN CALCULOS A¥OS CUMPLIDOS

	       SELECT &cMaeAct
	       DBSKIP()

	    ENDDO
**********FIN RECORRIDO POR LOS ESTUDIANTES

**********IMPRESION DEL REGISTRO
	    aTotAno := ASORT(aTotAno,,,{|x,y|x[1]<=y[1]})
	    FOR i := 1 TO LEN(aTotAno)

		aTitulo := {NIV->cCodigoNiv,;
			    STR(aTotAno[i,1],4),;
			    STR(aTotAno[i,2],4),;
			    STR(aTotAno[i,3],4)}

		cTxtPrn := cRegPrint(aTitulo,aNroCol)
		lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    ENDFOR
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    NIV->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       SELECT NIV
       NIV->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: MANTENIMIENTO VALOR TOTAL SERVICIOS EDUCATIVOS               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 AM   ABR 19/2004 LUN

OBJETIVOS:

1- Permite el mantenimiento del valor total de los servicios educativos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManTotSer(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,aUseDbf,nCodPrn)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       aUseDbf                              // Areas de Trabajo
       nCodPrn                              // C¢digo de Impresora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL oBrowse := NIL                 // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       nCodPrn := IF(EMPTY(nCodPrn),0,nCodPrn)
       IF !lLocCodigo('nCodigoPrn','PRN',nCodPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oDefTotSer(lShared,nFilPal+1,00,22,79,cAnoUsr)

/*
       SETKEY(K_F9,{||MenuTotSer(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				 cJorTxt,aUseDbf,nCodPrn,oBrowse)})
*/

       NIV->(CtrlBrw(lShared,oBrowse))
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: BROWSE DEL TOTAL DE SERVICIOS EDUCATIVOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 07:00 AM   ABR 19/2004 LUN

OBJETIVOS:

1- Define el objeto Browse del total de servicios educativos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefTotSer(lShared,nFilSup,nColSup,nFilInf,nColInf,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Niveles
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<TOTAL SERVICIOS EDUCATIVOS. A¥O:'+;
			      cAnoUsr+'>>',;
			    '<ENTER>Modificar <F9>Otros <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT NIV
       oColumn	     := TBCOLUMNNEW('NIVEL', {||NIV->cCodigoNiv})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR INICIAL',{||NIV->nVlrTotNiv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NIV'},{'FIELD','nVlrTotNiv'},;
			 {'PICTURE','9999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE


/*************************************************************************
* TITULO..: VALIDAR EL TOTAL DE SERVICIOS EDUCATIVOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 07:30 AM   ABR 19/2004 LUN

OBJETIVOS:

1- Valida el valor total de los servicios educativos de todos los niveles
   estan definidos

2- Retorn .T. Si no hay problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValTotSer(lShared,nModCry,PathInt,cPatSis,FileNiv,ExtFile,;
		    nAnoIni,nAnoFin,cMaeAlu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Integraci¢n
       PathInt                              // Path de Integraci¢n
       cPatSis                              // Path del Sistema
       nAnoIni                              // A¤o Inicial de Validaci¢n
       nAnoFin                              // A¤o Final de Validaci¢n
       FileNiv                              // Archivo del Nivel
       ExtFile                              // Extensi¢n del Archivo
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL i,j := 0                       // Contadores
       LOCAL cAnoSis := ''                  // A¤o Actual
       LOCAL cMaeAct := ''                  // Maestro Actual
*>>>>FIN DECLARACION DE VARIABLES


*>>>>ANALISIS PARA CADA A¥O
       FOR j := nAnoIni TO nAnoFin

***********ANALISIS PARA CADA NIVEL
	     FOR i := 1 TO LEN(cMaeAlu)/3

*---------------SELECION DE LAS AREAS DE TRABAJO
		  cAnoSis := SUBS(str(j,4),3,2)
		  cMaeAct := SUBS(cMaeAlu,i*3-2,3)
		  cPatSis := STR(j,4)+SUBS(cPatSis,5,4)

		  IF !lUseDbf(.T.,PathInt+'\'+cPatSis+'\'+cMaeAct+'\'+;
				  FileNiv+cAnoSis+ExtFile,'NIV',NIL,;
				  lShared,nModCry)
		     cError('ABRIENDO EL ARCHIVO DE NIVELES DEL A¥O '+cAnoSis)
		     CloseDbf('NIV')
		     RETURN .F.
		  ENDIF
*---------------FIN SELECION DE LAS AREAS DE TRABAJO

*---------------VALIDACION DE CONTENIDOS DE ARCHIVOS
		  lHayErr := .T.
		  DO CASE
		  CASE NIV->(RECCOUNT()) == 0
		       cError('NO EXISTEN NIVELES CREADOS')

		  OTHERWISE
		       lHayErr :=.F.
		  ENDCASE
		  IF lHayErr
		     CloseDbf('NIV')
		     RETURN .F.
		     RETURN NIL
		  ENDIF
*---------------FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*---------------ANALISIS DE VALIDACION
		  SELECT NIV
		  NIV->(DBGOTOP())
		  lHayErr :=.F.
		  DO WHILE .NOT. NIV->(EOF())

		     IF NIV->nNroGruNiv # 0 .AND. NIV->nVlrTotNiv == 0
			lHayErr := .T.
			EXIT
		     ENDIF

		     NIV->(DBSKIP())

		  ENDDO
		  IF lHayErr
		     EXIT
		  ENDIF
*---------------FIN ANALISIS DE VALIDACION

	     ENDFOR
	     IF lHayErr
		cError('NO SE HAN DEFINIDO LOS COSTOS PARA '+STR(j,4))
		EXIT
	     ENDIF
***********ANALISIS PARA CADA NIVEL

       ENDFOR
       CloseDbf('NIV')
       RETURN !lHayErr
*>>>>FIN ANALISIS PARA CADA A¥O

/*************************************************************************
* TITULO..: AREAS NO IMPRIMIBLES.                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 28/2006 MAR A
       Colombia, Bucaramanga        INICIO: 07:30 AM   MAR 28/2006 MAR

OBJETIVOS:

1- Activa el Swiche para activar la NO impresi¢n de las areas en el boletin

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrNiv03(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		  cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		  lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		  cJornad,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
     *ÀVariables generales

*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       IF !lPregunta('Desea activar para que NO se impriman '+;
		    'las Areas en el Boletin?No Si')
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
       IF !lPregunta('SE AUTORIZO EL PROCESO. '+;
		     'ESTA SEGURO DE CONTINUAR?No Si')
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>RECORRIDO POR GRUPOS
       cSavPan := SAVESCREEN(0,0,24,79)
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********VISUALIZACION DE AVANCE
	    LineaEstado('REGISTRO: '+STR(NIV->(RECNO()),5)+'/'+;
			 STR(NIV->(RECCOUNT()),5),cNomSis)
**********FIN VISUALIZACION DE AVANCE

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			   cFilePlan(cAnoUsr,GRU->cCodigoGru),'PLA',NIL,lShared)

	       cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		       cNomNiv(SUBS(GRU->cCodigoGru,1,2)))

	       CloseDbf('PLA')
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO POR PLAN ACADEMICO
	    SELECT PLA
	    PLA->(DBGOTOP())
	    DO WHILE .NOT. PLA->(EOF())

*--------------ANALISIS DE DECISION
		 IF SUBS(PLA->cCodigoMat,3,2) # '00' .OR.;
		    (SUBS(PLA->cCodigoMat,3,2) == '00' .AND.;
		     PLA->cTipArePla == 'N')

		    PLA->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE DECISION

*--------------GRABACION DE LA NO IMPRESION DEL AREA
		 SELECT PLA
		 IF PLA->(lRegLock(lShared,.F.))
		    REPL PLA->cPrnBolPla WITH '11111'
		    PLA->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABA EL REGISTRO')
		 ENDIF
		 IF lShared
		    PLA->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DE LA NO IMPRESION DEL AREA

	       PLA->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR PLAN ACADEMICO

**********AVANCE DEL SIGUIENTE REGISTRO
	    GRU->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)

       SELECT NIV
       NIV->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS