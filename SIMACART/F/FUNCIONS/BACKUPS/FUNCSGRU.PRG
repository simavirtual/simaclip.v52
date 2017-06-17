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
* TITULO DE LA FUNCION..: APERTURA DE LOS ARCHIVOS DE GRUPOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:50 PM   FEB 02/96 VIE

OBJETIVOS:

1)- Pone en uso los archivos de grupos

2)- Retorna por referencia los param‚tros de la funci¢n marcados con @

3)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseGru(lShared,cPatSis,cMaeAlu,cAnoSis,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cPatSis			            // Path del Sistema
       cMaeAlu                              // Maestros habilitados
       cAnoSis                              // A¤o del sistema
       lAnoAct                              // .F. A¤o Anteriores */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                // .T. Hay Error
       LOCAL PathGru := ''                 // Path del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lAnoAct := IF(lAnoAct == NIL,.T.,lAnoAct)

       IF 'JAR' $ cMaeAlu

	  PathGru := cPatSis+'\JAR\'
	  IF !lUseDbf(.T.,PathGru+FGruJar+cAnoSis+ExtFile,;
			  IF(lAnoAct,'GRU','GRU'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE JARDIN EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu

	  PathGru := cPatSis+'\PRI\'
	  IF !lUseDbf(.T.,PathGru+FGruPri+cAnoSis+ExtFile,;
			  IF(lAnoAct,'GRU','GRU'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE PRIMARIA EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu

	  PathGru := cPatSis+'\BTO\'
	  IF !lUseDbf(.T.,PathGru+FGruBto+cAnoSis+ExtFile,;
			  IF(lAnoAct,'GRU','GRU'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE BACHILLERATO EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DE UN GRUPO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de grupos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite escoger un grupo determinado

4- Retorna .T. si escogio el grupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSelGrupo(nNroFil,nNroCol,nNroReg,cTitulo)

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
	SELECT GRU
	nNroCol = nNroCol + LEN(cTitulo)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - 1
	ENDIF
	nColInf := nColSup+3

	GRU->(DBGOTOP())
	nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||GRU->cCodigoGru})
	IF nNroReg == 0
	   RETURN .F.
	ENDIF
	GRU->(DBGOTO(nNroReg))
	@ nFilSup,nColSup SAY GRU->cCodigoGru
	RETURN .T.
*>>>>FIN SELEECION DEL GRUPO

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO DEL GRUPO         	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez        FECHA DE CREACION: JUL 02/94 SAB A
							JUL 02/94 SAB
OBJETIVOS:

1- Debe estar en uso el archivo de Grupo

2- Verifica la existencia del c¢digo del Grupo.

3- Deja el archivo en el registro del c¢digo del Grupo si este existe.

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodGru(cCodigo,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				    // C¢digo a localizar
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT GRU
       GO TOP
       LOCATE FOR GRU->cCodigoGru == cCodigo
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('EL CURSO: '+cCodigo+' NO EXISTE')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE GRUPOS	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 09/94 SAB A
						       JUL 09/94 SAB
OBJETIVOS:
1- Permite el mantenimiento del archivo Grupos

SINTAXIS:

MantenGru()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenGru(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,;
		   lIntCua,cMaeAlu,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
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
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"      // Archivo Grupos

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro

       LOCAL oBrwGru := NIL                 // Browse de Grupos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,;
		  @cIntUno,@cIntDos,@cIntTre,@cIntCua)
     *ÀLectura de paths

       cIntUno := IF(lIntUno,cIntUno,cPatSis)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
	  cError('ABRIENDO ARCHIVOS DE MANTENIMIENTO DE GRUPOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
     *ÀArchivos del sistema
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0 .AND. lIntUno
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwGru := oDefBrwGru(lShared,00,00,22,79,lIntUno,cMaeAct)
       SETKEY(K_F5,{||BuscarGru(oBrwGru,cMaeAct)})
       GRU->(CtrlBrw(lShared,oBrwGru))
       SETKEY(K_F5,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE GRUPOS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 09/94 SAB A
						       JUL 09/94 SAB
OBJETIVOS:

1- Define el objeto Browse del archivo Grupos

SINTAXIS:

 oBrwGru := oDefBrwGru(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwGru(lShared,nFilSup,nColSup,nFilInf,nColInf,lIntUno,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       lIntUno                              // Primera Integraci¢n
       cMaeAct			      // Alias del Maestro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwGru := NIL		    // Browse de Grupos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwGru := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwGru:ColSep    := '³'
       oBrwGru:HeadSep   := 'Ä'

       IF lIntUno
	  oBrwGru:Cargo := {'<<MANTENIMIENTO DE GRUPOS DE '+;
			       cNomNiv(cMaeAct)+' >>',;
			    '<F5>Buscar  <ESC>Abandonar'}
       ELSE
	  oBrwGru:Cargo := {'<<MANTENIMIENTO DE GRUPOS DE '+;
			       cNomNiv(cMaeAct)+' >>',;
			    '<INS>Incluir  <F5>Buscar  <DEL>Borrar  '+;
			    '<ESC>Abandonar',{||IncluirGru(lShared,cMaeAct)}}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT GRU
       oColumn	     := TBCOLUMNNEW('GRUPO', {||GRU->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwGru:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ALUMNOS', {||GRU->nNroAluGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','nNroAluGru'},;
			 {'PICTURE','99'}}
       oBrwGru:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwGru
*>>>>FIN DEFINICION DEL OBJETO BROWSE


/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO DE GRUPOS	     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 09/94 SAB A
						       JUL 09/94 SAB
OBJETIVOS:
1- Incluye un registro al archivo de Grupos

SINTAXIS:

  IncluirGru()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirGru(lShared,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cMaeAct			            // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL cMsgTxt := ''                  // Texto Temporal
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DATOS DEL GRUPO '+;
				 'PARA '+cNomNiv(cMaeAct),22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTgr := cSpaces('GRU','cCodigoGru')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    cMsgTxt := 'CODIGO DEL GRUPO   :'
	    @ nNroFil,nNroCol SAY cMsgTxt

	    IF !lLeeCodGru(nNroFil,nNroCol+LEN(cMsgTxt),@cCodigoTgr,cMaeAct)
	       LOOP
	    ENDIF

	    IF lLocCodigo('cCodigoGru','GRU',cCodigoTgr)
	       cError('EL CODIGO DEL GRUPO YA EXISTE')
	       LOOP
	    ENDIF
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE SPACE(01) $ cCodigoTgr
		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE GRABA EL REGISTRO')

	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT GRU
       IF lGrabar
	  IF GRU->(lRegLock(lShared,.T.))
	     REPL GRU->cCodigoGru WITH cCodigoTgr
	     GRU->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  GRU->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL GRUPO EN EL BROWSE        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 09/94 SAB A
						       JUL 09/94 SAB
OBJETIVOS:

1- Localiza el c¢digo del Grupos dentro del Browse de Grupos

2- Retorna NIL

SINTAXIS:

  BuscarGru(oBrwGru)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarGru(oBrwGru,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwGru			            // Browse de Grupos
       cMaeAct                              // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegGru := 0                   // Registro del Grupos
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTgr := cSpaces('GRU','cCodigoGru')
       TitBuscar(LEN(cCodigoTgr),@nNroFil,@nNroCol)

       DO WHILE .T.
	 lLeeCodGru(nNroFil,nNroCol,@cCodigoTgr,cMaeAct)
	 IF EMPTY(cCodigoTgr)
	    IF lValGrupo(nNroFil,nNroCol,@cCodigoTgr)
	       EXIT
	    ENDIF
	 ENDIF
	 EXIT
       ENDDO
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigoTgr == cSpaces('GRU','cCodigoGru')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT GRU
       IF lBuscar .AND. lLocCodGru(cCodigoTgr)
	   nRegGru := RECNO()
	   GO TOP
	   oBrwGru:GOTOP()
	   GO nRegGru
	   oBrwGru:FORCESTABLE()
       ELSE
	  oBrwGru:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL GRUPO		*
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 09/94 SAB A
						       JUL 09/94 SAB
OBJETIVOS:

1- Debe estar en uso el archivo Grupos

2- Realiza la validaci¢n del c¢digo del Grupos

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodGru(cCodGru,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodGru			            // C¢digo del Grupos
       cNalias			            // Alias del maestro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aNomNiv := ''
       LOCAL nNroNiv := 0                   // N£mero del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL GRUPO EN EL NIVEL
       lHayErr := .T.
       nNroNiv := VAL(SUBS(cCodGru,1,2))
       aNomNiv := {'JARDIN','PRIMERO','SEGUNDO','TERCERO','CUARTO','QUINTO',;
		   'SEXTO','SEPTIMO','OCTAVO','NOVENO','DECIMO','UNDECIMO'}

       DO CASE
       CASE cCodGru == cSpaces('GRU','cCodigoGru')
	    lHayErr := .F.

       CASE cNalias == 'JAR' .AND. !(nNroNiv >= 0 .AND. nNroNiv < 1)
	    cError(aNomNiv[nNroNiv+1]+' NO PERTENECE A JARDIN')

       CASE cNalias == 'PRI' .AND. !(nNroNiv >= 1 .AND. nNroNiv < 6)
	    cError(aNomNiv[nNroNiv+1]+' NO PERTENECE A PRIMARIA')

       CASE cNalias == 'BTO' .AND. !(nNroNiv >= 6 .AND. nNroNiv <= 11)
	    cError(aNomNiv[nNroNiv+1]+' NO PERTENECE A BACHILLERATO')
       OTHERWISE
	    lHayErr := .F.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO DEL GRUPO EN EL NIVEL

*>>>>VALIDACION DEL CODIGO DEL GRUPO
       IF lLocCodGru(cCodGru,.F.) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL GRUPO

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL CODIGO DEL GRUPO                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 25/96 DOM A
       Colombia, Bucaramanga        INICIO: 03:00 PM   FEB 25/96 DOM

OBJETIVOS:

1- Lee el c¢digo el C¢digo del Grupo

2- Valida el c¢digo del nivel

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeeCodGru(nNroFil,nNroCol,cCodGru,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodGru				    // C¢digo del Grupo
       cMaeAct                              // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL cCodNiv := ''                  // C¢digo del Nivel
       LOCAL lLeeyo  := .F.                 // .T. Ley¢ el c¢digo
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       cCodGru := SPACE(04)
       @ nNroFil,nNroCol+2 SAY 'GRUPO:' GET cCodGru PICT '9999';
			   VALID lValGrupo(nNroFil,nNroCol+9,@cCodGru) .OR.;
				 EMPTY(cCodGru)
       READ

       lLeeyo := .T.
       IF LASTKEY() == K_ESC
	  lLeeyo := .F.
       ENDIF
       RETURN lLeeyo
*>>>>FIN CAPTURA DEL CODIGO

/*************************************************************************
* TITULO..: CREACION DEL ARCHIVO DE GRUPOS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 18/2001 JUE A
       Colombia, Bucaramanga        INICIO: 11:20 AM   OCT 18/2001 JUE

OBJETIVOS:

1- Crea un archivo con todos los grupos habilitados.

2- Retorna el nombre del Archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lCreallGru(lShared,cAnoUsr,cMaeAlu,cIntUno,FileTem)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cAnoUsr                              // A¤o del Usuario
       cMaeAlu                              // Maestros habilitados
       cIntUno                              // Path de integraci¢n uno
       FileTem                              // Archivo Temporal de Grupos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE ARCHIVOS
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
*>>>>FIN DECLARACION DE ARCHIVOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('FUE')
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN .F.
       ENDIF
*>>>>SELECION DE LAS AREAS DE TRABAJO

*>>>>CREACION DE TODOS LOS GRUPOS
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis)
	      cError('ABRIENDO ARCHIVOS')
	      CloseDbf('FUE')
	      CloseDbf('GRU')
	      IF !lFileDelete(FileTem)
		 cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	      ENDIF
	      RETURN .F.
	   ENDIF

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
	      SKIP

	   ENDDO

       ENDFOR
       CloseDbf('FUE')
       CloseDbf('GRU')
       RETURN .T.
*>>>>FIN CREACION DE TODOS LOS GRUPOS