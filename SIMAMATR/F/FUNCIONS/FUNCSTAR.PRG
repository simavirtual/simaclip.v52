/*                       SIMA - CARTERA ACADEMICA
		BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO TARIFAS

REQUERIMIENTOS:

- Compilar: clipper funcsTar /w/m/b

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
       Colombia, Bucaramanga        INICIO: 02:30 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfTar(PathTar,FileTar,lIntUno,fNtxTar)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfTar(lShared,PathTar,FileTar,lIntUno,fNtxTar)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathTar				    // Path del Archivo
       FileTar				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxTar				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfTar := {{"cCodigoGru","Character",04,0},;
			 {"cCodigoCon","Character",02,0},;
			 {"nValorTar" ,"Numeric"  ,07,0}}

*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathTar) == 0
	    DBCREATE(FileTar,aDbfTar,"DBFNTX")

       CASE DIRCHANGE(PathTar) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathTar)

       CASE DIRCHANGE(PathTar) == -5
	    cError('NO TIENE DERECHOS EN: '+PathTar)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfTar(lShared,PathTar,FileTar,lIntUno,fNtxTar)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathTar			      // Path del Archivo
       FileTar			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxTar			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathTar+'\'+FileTar,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE TARIFAS")
       Termometro(100)

       CreaDbfTar(lShared,PathTar,FileTar,lIntUno,fNtxTar)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO DE LA TARIFA               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/96 MAR A
       Colombia, Bucaramanga        INICIO: 01:55 PM   AGO 13/96 MAR

1- Debe estar en uso el archivo de Tarifas

2- Verifica la existencia del c¢digo compuesto por los c¢digos del nivel y
   del concepto

3- Deja el archivo en el registro localizado

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodTar(cCodTar,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodTar			            // C¢digo de la tarifa
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT TAR
       GO TOP
       LOCATE FOR TAR->cCodigoGru+TAR->cCodigoCon == cCodTar
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('LA TARIFA: '+SUBS(cCodTar,4,2)+' PARA EL CURSO: '+;
		     SUBS(cCodTar,1,3)+' NO SE ENCUENTRA')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE TARIFAS	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:20 PM   AGO 13/96 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo Tarifas

SINTAXIS:

MantenTar()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenTar(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		   cPatSis,PathUno,PathDos,PathTre,PathCua,;
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
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
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

       LOCAL oBrwTar := NIL                 // Browse de Tarifas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       LeePathMaA(lShared,cPatSis,cAnoUsr,;
		  @cIntUno,@cIntDos,;
		  @cIntTre,@cIntCua)
     *ÀLectura de paths

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cIntUno+'\'+cMaeAct+'\'+;
		      FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		      FileTar,'TAR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		      FileCon,'CON',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS DE TABLA DE PAGOS')
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE NIV->(RECCOUNT()) == 0
	    cError('NO ESTAN DEFINIDOS LOS NIVELES DE LOS CURSOS')
	    RETURN NIL

       CASE CON->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS CONCEPTOS A COBRAR')
	    RETURN NIL

       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT TAR
       oBrwTar := oDefBrwTar(lShared,nFilPal+1,00,22,79,cMaeAct)

       SETKEY(K_F5,{||BuscarTar(oBrwTar)})

       SETKEY(K_F9,{||MenuOtrTar(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
				 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
				 cPatSis,PathUno,PathDos,PathTre,PathCua,;
				 cMaeAlu,cMaeAct,cJorTxt,oBrwTar)})

       TAR->(CtrlBrw(lShared,oBrwTar))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       IF TAR->(RECCOUNT()) # 0
	  CLOSE ALL
	  OrdenarTar(lShared,cNomUsr,cPatSis+'\'+FileTar)
       ENDIF
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE TARIFAS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:25 PM   AGO 13/96 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo Tarifas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwTar(lShared,nFilSup,nColSup,nFilInf,nColInf,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAct                              // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwTar := NIL                 // Browse de Tarifas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwTar := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwTar:ColSep    := '³'
       oBrwTar:HeadSep   := 'Ä'
       oBrwTar:Cargo     := {'<<MANTENIMIENTO DE TARIFAS>>',;
			    '<ENTER>Modificar  <INS>Incluir  <F5>Buscar  '+;
			    '<DEL>Borrar  <ESC>Abandonar',;
			    {||IncluirTar(lShared,cMaeAct)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT TAR
       oColumn	     := TBCOLUMNNEW('CURSO', {||TAR->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTar:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO DEL CONCEPTO', {||TAR->cCodigoCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTar:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR', {||TAR->nValorTar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nValorTar'},;
			 {'PICTURE','9999999'}}
       oBrwTar:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwTar
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO DE TARIFAS   	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:27 PM   AGO 13/96 MAR

OBJETIVOS:

1- Permite incluir un registro al archivo de Tarifas

SINTAXIS:

  IncluirTar()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirTar(lShared,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cMaeAct                              // Maestro Actual   */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lGrabar := .F.                 // Grabar el registro
       LOCAL lInsReg := .F.                 // Insertar el Registro
       LOCAL cGruIni := ''                  // Grupo Inicial
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL cCodCon := ''                  // C¢digo del concepto
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n

       LOCAL cNivIni := ''                  // Nivel Inicial
       LOCAL cNivFin := ''                  // Nivel Final

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTco                     // C¢digo del concepto
       FIELD cCodigoGru                     // C¢digo del grupo
       LOCAL nValorTta  := 0                // Valor de la tarifa
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DETALLES '+;
				 'DE LA DE LAS TARIFAS PARA '+;
				 cNomNiv(cMaeAct),22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
		 cGruIni := cSpaces('TAR','cCodigoGru')
		 cGruFin := cSpaces('TAR','cCodigoGru')
		 cCodCon := cSpaces('TAR','cCodigoCon')
	       nValorTta := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL CONCEPTO:';
				GET cCodCon PICT '@!';
				VALID lValConcep(ROW(),COL()-2,@cCodCon)

	    @ nNroFil+1,nNroCol SAY 'VALOR DEL CONCEPTO :';
				GET nValorTta  PICT '9999999.99'

	    @ nNroFil+3,nNroCol SAY 'NIVEL INICIAL      :';
				GET cNivIni PICT '99';
			     VALID lValNivel(ROW(),COL(),@cNivIni,@nRegIni)

	    @ nNroFil+4,nNroCol SAY 'NIVEL FINAL        :';
				GET cNivFin PICT '99';
			     VALID lValNivel(ROW(),COL(),@cNivFin,@nRegFin)
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE cCodCon == cSpaces('TAR','cCodigoCon') .OR.;
		 cNivIni == cSpaces('NIV','cCodigoNiv') .OR.;
		 cNivFin == cSpaces('NIV','cCodigoNiv') .OR.;
		 nValorTta == 0

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE ASIGNAN TARIFAS')

	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR LAS TARIFAS PARA LOS GRUPOS '+;
			    'ESCOGIDOS? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DE LAS TARIFAS
       SELECT NIV
       GO nRegIni
       DO WHILE RECNO() <= nRegFin .AND. lGrabar

**********ANALISIS PARA LA GRABACION
	    SELECT TAR
	    GO TOP
	    IF lLocCodTar(NIV->cCodigoNiv+'00'+cCodCon,.F.)
	       lInsReg := .F.
	    ELSE
	       lInsReg := .T.
	    ENDIF
**********FIN ANALISIS PARA LA GRABACION

**********GRABACION DE LA TARIFA PARA EL GRUPO
	    IF TAR->(lRegLock(lShared,lInsReg))
	       REPL TAR->cCodigoGru WITH NIV->cCodigoNiv+'00'
	       REPL TAR->cCodigoCon WITH cCodCon
	       REPL TAR->nValorTar  WITH nValorTta
	    ENDIF
**********FIN GRABACION DE LA TARIFA PARA EL GRUPO

**********INCREMENTO DEL SIGUIENTE GRUPO
	    SELECT NIV
	    SKIP

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO
       RETURN NIL
*>>>>FIN GRABACION DE LAS TARIFAS

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DE LA TARIFA EN EL BROWSE     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/94 VIE A
						       JUL 08/94 VIE
OBJETIVOS:

1- Debe estar en uso los archivos de Tarifas, Grupos y Conceptos

2- Busca el c¢digo de la tarifa compuesto por los c¢digos del grupo y
   del concepto dentro del Browse de Tarifas

3- Retorna NIL

SINTAXIS:

  BuscarTar(oBrwTar)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarTar(oBrwTar)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwTar				    // Browse de Tarifas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegTar := 0                   // Registro de Tarifa
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodNiv := ''               // C¢digo del Nivel
       LOCAL cCodCon := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       TitBuscar(LEN(cSpaces('TAR','cCodigoGru'))+;
		 LEN(cSpaces('TAR','cCodigoCon'))+1,@nNroFil,@nNroCol)

       cCodNiv := cSpaces('NIV','cCodigoNiv')
       cCodCon := cSpaces('TAR','cCodigoCon')

       @ nNroFil,nNroCol GET cCodNiv PICT '99';
			 VALID lValNivel(ROW(),COL()-2,@cCodNiv)

       @ nNroFil,nNroCol+LEN(cSpaces('TAR','cCodigoCon'))+2;
			 GET cCodCon PICT '@!';
			 VALID lValConcep(ROW(),COL()-2,@cCodCon)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       DO CASE
       CASE cCodNiv == cSpaces('NIV','cCodigoNiv') .AND.;
	    cCodCon == cSpaces('TAR','cCodigoCon')

	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       CASE cCodNiv == cSpaces('NIV','cCodigoNiv') .OR.;
	    cCodCon == cSpaces('TAR','cCodigoCon')

	    cError('PATRON DE BUSQUEDA INCOMPLETO',;
		   'ADVERTENCIA')
       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT TAR
       IF lBuscar .AND. lLocCodTar(cCodNiv+'00'+cCodCon)
	  nRegTar := RECNO()
	  GO TOP
	  oBrwTar:GOTOP()
	  GO nRegTar
	  oBrwTar:FORCESTABLE()
       ELSE
	  oBrwTar:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: ORDENACION DE UN ARCHIVO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 25/96 DOM A
       Bucaramanga, Colombia        INICIO: 06:45 PM   FEB 25/96 DOM

OBJETIVOS:

1)- Permite Ordenar el maestro de alumnos seleccionado

2)- Permite activar el nivel de estudios Jardin, Primaria o Bachillerato

3)- Retorna las tres iniciales del nivel de estudios

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenarTar(lShared,cNomUsr,FileDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cAnoUsr                              // A¤o del usuario
       FileDbf                              // Archivo a Ordenar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL ARCHIVO
       FileTem := SUBS(cNomUsr,1,3)+FileTem+cExtTem
       IF FILE(FileTem)
	  cError(ALLTRIM(cNomUsr)+;
		 ' ESTA ORDENANDO. NO PUEDE UTILIZAR EL MISMO USUARIO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>COPIA DEL ARCHIVO
       FILECOPY(FileDbf,;
		DIRNAME()+'\'+FileTem)
*>>>>FIN COPIA DEL MAESTRO PARA EL ORDENAMIENTO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,DIRNAME()+'\'+;
		      FileTem,'TEM',NIL,.F.)
	  cError('ABRIENDO ARCHIVO MAESTRO TEMPORAL EN '+DIRNAME())
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TEM->(RECCOUNT()) == 0
	    cError('NO EXISTEN TEMMNOS GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseDbf('TEM')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ORDENAMIENTO DEL MAESTRO
       TERMOMETRO(0,'ORDENANDO EL ARCHIVO TARIFAS')
       TERMOMETRO(50)
       SORT TO &(FileDbf) ;
	    ON cCodigoGru,cCodigoCon
       TERMOMETRO(100)
*>>>>FIN ORDENAMIENTO DEL MAESTRO

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       CloseDbf('TEM')
       IF !lFileDelete(DIRNAME()+'\'+FileTem)
	  cError('NO SE BORRO EL MAESTRO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>BORRADO DEL ARCHIVO TEMPORAL

/*************************************************************************
* TITULO DE LA FUNCION..: VALOR DEL CONCEPTO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/96 JUE A
       Bucaramanga, Colombia        INICIO: 09:45 PM   JUL 15/96 JUE

OBJETIVOS:

1- Debe estar en uso el archivo de tarifas y conceptos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Termina el programa si no existe el c¢digo o valor del concepto

4- Retorna el valor del concepto

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nValorTar(cCodGru,cCodCon,cNomCon)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodGru                              // C¢digo del grupo
       cCodCon                              // C¢digo del concepto
       cNomCon                              // @Nombre del Concepto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nValor  := 0                  // Valor del concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL VALOR DEL CONCEPTO
       SELECT TAR
       GO TOP
       LOCATE FOR TAR->cCodigoGru == cCodGru .AND.;
		  TAR->cCodigoCon == cCodCon

       IF FOUND()
	  nValor := TAR->nValorTar
       ELSE
	  nValor := 0
	 *No existe tarifa asignada
       ENDIF
*>>>>FIN LECTURA DEL VALOR DEL CONCEPTO

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       cNomCon := NIL
       SELECT CON
       GO TOP
       LOCATE FOR CON->cCodigoCon == cCodCon

       IF FOUND()
	  cNomCon := CON->cNombreCon
       ELSE
	  cNomCon := 'No Existe Con:'+cCodCon
	  nValor  := 0
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

*>>>>VALIDACION DEL NOMBRE DEL CONCEPTO
       IF cNomCon == SPACE(16)
	  cNomCon := 'No Existe Nom:'+cCodCon
	  nValor  := 0
       ENDIF
       RETURN nValor
*>>>>FIN VALIDACION DEL NOMBRE DEL CONCEPTO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 24/2004 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   FEB 24/2004 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrTar(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		    cPatSis,PathUno,PathDos,PathTre,PathCua,;
		    cMaeAlu,cMaeAct,cJorTxt,oBrowse)

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
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<IMPRESION DE TARIFAS')

       AADD(aAyuda,'Permite Imprimir las Tarifas para la facturaci¢n')

       IF LEN(aMenus) == 1
	  nNroOpc := 1
       ELSE
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nNroOpc == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrTar011(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		      nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		      cPatSis,PathUno,PathDos,PathTre,PathCua,;
		      cMaeAlu,cMaeAct,cJorTxt,oBrowse)
	   *Impresi¢n de las Tarifas

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION DE LAS TARIFAS                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 24/2004 MIE A
       Colombia, Bucaramanga        INICIO: 10:10 AM   FEB 24/2004 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite imprimir el archivo con caracteristicas especificas

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTar011(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		   cPatSis,PathUno,PathDos,PathTre,PathCua,;
		   cMaeAlu,cMaeAct,cJorTxt,oBrowse)

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
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe Espec¡fico
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos Encabezados para impresi¢n
       LOCAL aRegPrn := {}                  // Regitros para impresi¢n
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
       LOCAL aRegXml := {}                  // Registros Xml
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTco := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nLinTot := 2

       nTotReg := nTotReg+nLinTot
       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'RELACION DE TARIFAS DE COBRO',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,20,12}
       aTitPrn := {'GRUPO ','CONCEPTO','VALOR '}
       cCabCol := cRegPrint(aTitPrn,aNroCol)
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
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
/*     ActivaPrn(lShared,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF */
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

/*
*>>>>APERTURA DEL ARCHIVO XML
       FileXml := cPatSis+'\FILEWWW\'+'tarifas.xml'

       nHanXml := nOpenXml(FileXml,aCabPrn)
       IF EMPTY(nHanXml)
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO XML
*/

*>>>>IMPRESION DEL TERMOMETRO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO LAS TARIFAS')
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT TAR
       GO TOP
       DO WHILE .NOT. TAR->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstados('REGISTROS: '+TAR->(STR(RECNO(),5))+'/'+;
				       TAR->(STR(RECCOUNT(),5)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LOCALIZACION DEL CONCEPTO
	    IF lLocCodigo('cCodigoCon','CON',TAR->cCodigoCon)
	       cNombreTco := CON->cNombreCon
	    ELSE
	       cNombreTco := 'Concepto NO existe'
	    ENDIF
**********FIN LOCALIZACION DEL CONCEPTO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aRegPrn := {TAR->cCodigoGru,;
			TAR->cCodigoCon+':'+cNombreTco,;
			TRANS(TAR->nValorTar,'@Z ####,###,###')}

*	    SaveRegXml(FileXml,nHanXml,aRegPrn,aTitPrn)

	    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(( TAR->(RECNO()) / TAR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF

	    SELECT TAR
	    TAR->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*       CloseXml(FileXml,nHanXml)
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,PCL('n20Stan'))
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       SET FILTER TO
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS