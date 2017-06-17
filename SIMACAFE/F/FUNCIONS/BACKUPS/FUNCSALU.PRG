/*               	   SIMA - SISTEMA DE CAFETERIA
	    BIBLIOTECAS DE FUNCIONES PARA LOS ARCHIVOS MAESTROS DE ALUMNOS


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: APERTURA DE LOS MAESTROS DE LA CONTABILIDAD                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   JUL 03/2002 MIE

OBJETIVOS:

1)- Pone en uso los archivos de alumnos de la contabilidad habilitados

2)- Retorna por referencia los param‚tros de la funci¢n marcados con @

3)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseMae(lShared,cPatSis,cMaeAlu,cAnoSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cPatSis			            // Path del Sistema
       cMaeAlu                              // Maestros habilitados
       cAnoSis                              // A¤o del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF 'JAR' $ cMaeAlu

	  PathAlu := cPatSis+'\JAR\'
	  IF !lUseDbf(.T.,PathAlu+FMaeJar+cAnoSis+ExtFile,'JAR',;
			  PathAlu+fNtxJar+cAnoSis+cExtNtx,lShared)
	     cError('ABRIENDO ARCHIVOS DE JARDIN EN '+PathAlu)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu

	  PathAlu := cPatSis+'\PRI\'
	  IF !lUseDbf(.T.,PathAlu+FMaePri+cAnoSis+ExtFile,'PRI',;
			  PathAlu+fNtxPri+cAnoSis+cExtNtx,lShared)
	     cError('ABRIENDO ARCHIVOS DE PRIMARIA EN '+PathAlu)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu

	  PathAlu := cPatSis+'\BTO\'
	  IF !lUseDbf(.T.,PathAlu+FMaeBto+cAnoSis+ExtFile,'BTO',;
			  PathAlu+fNtxBto+cAnoSis+cExtNtx,lShared)
	     cError('ABRIENDO ARCHIVOS DE BACHILLERATO EN '+PathAlu)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO DE ALUMNOS		         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Permite el mantenimiento del archivo Alumnos

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenAlu(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL cTitCam := ''                  // T¡tulo del Campo
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL GetList := {}                  // Variable del Sistema

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths

       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCaf,'CAF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseGru(lShared,cIntUno,cMaeAct,cAnoUsr) .OR.;
	  !lUseDbfs(aUseDbf)
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

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DEFINCION DEL BROWSE
       cTitSup := '<< CONSULTA DE ESTUDIANTE DE '+cMaeAct+;
		  ' .TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>'
      *ÀT¡tulo Superior del Browse

       AADD(aCampos,{{"CODIGO","cCodigoEst"},{NIL}})
       AADD(aCampos,{{"GRUPO","cCodigoGru"},{NIL}})
       AADD(aCampos,{{"APELLIDOS;DEL ESTUDIANTE","cApelliEst"},{NIL}})
       AADD(aCampos,{{"NOMBRES;DEL ESTUDIANTE","cNombreEst"},{NIL}})
       AADD(aCampos,{{"RETIRADO","lRetiroEst"},{NIL}})
       AADD(aCampos,{{"F.RETIRO","dFecRetEst"},{NIL}})
       AADD(aCampos,{{"CONCEPTOS","cConcepEst"},{NIL}})
       AADD(aCampos,{{"RUTAS","cCodigoRut"},{NIL}})
       FOR i := 1 TO 12
	   cTitCam := 'INGRESOS A LA CAFETERIA MES '+cMes(i,3)+;
	   ';1234567890123456789012345678901'
	   AADD(aCampos,{{cTitCam,'cRes'+cMes(i,3)+'Est'},{NIL}})
       ENDFOR
     *ÀDefinici¢n de Campos

       cTitInf := '<F5>Buscar <F9>Otros <ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse
*>>>>FIN DEFINCION DEL BROWSE

*>>>>BROWSE DEL ARCHIVO
       SELECT &cMaeAct
       SETKEY(K_F5,{||BuscarAlu(oBrowse,cMaeAct,SUBS(cAnoUsr,3,2),cIntUno)})

       SETKEY(K_F9,{||MenuOtrAlu(aP1,aP2,aP3,oBrowse)})

       DO CASE
       CASE cMaeAct == 'JAR'
	    JAR->(CtrlBrw(lSiRed,oBrowse))

       CASE cMaeAct == 'PRI'
	    PRI->(CtrlBrw(lSiRed,oBrowse))

       CASE cMaeAct == 'BTO'
	    BTO->(CtrlBrw(lSiRed,oBrowse))

       ENDCASE
       SETKEY(K_F5,NIL)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DEL ARCHIVO

/*************************************************************************
* TITULO..: BUSCAR EL CODIGO DEL ESTUDIANTE                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:45 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Debe estar en uso los archivos de Alumnos

2- Busca el c¢digo del Estudiante

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarAlu(oBrowse,cMaeAct,cAnoSis,cIntUno)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse				    // Browse de Alumnos
       cMaeAct			            // Maestro Actual
       cAnoSis                              // A¤o del sistema
       cIntUno			            // Path de la contabilidad */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // Registro del Pago
       LOCAL nColLin := 0                   // Columna de lectura de linea
       LOCAL nTecPul := 0                   // Tecla pulsada
       LOCAL nLenCam := 0                   // Longitud de campo a leer

       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''               // C¢digo del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL METODO DE BUSQUEDA
       aMenus := {'1<POR APELLIDO>',;
		  '2<POR NOMBRE  >',;
		  '3<POR CODIGO  >'}
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,NIL,09,30,'BUSQUEDA',NIL,1,.F.)
       IF nNroOpc == 0
	  oBrowse:REFRESHALL()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN SELECCION DEL METODO DE BUSQUEDA

*>>>>ACTIVACION DE LOS INDICES
       SELECT &cMaeAct
       DO CASE
       CASE 'JAR' $ cMaeAct
	    DO CASE
	    CASE nNroOpc == 1
		 fNtxAlu := cIntUno+'\JAR\'+Ntx1Jar+cAnoSis+cExtNtx

	    CASE nNroOpc == 2
		 fNtxAlu := cIntUno+'\JAR\'+Ntx2Jar+cAnoSis+cExtNtx

	    CASE nNroOpc == 3
		 fNtxAlu := cIntUno+'\JAR\'+fNtxJar+cAnoSis+cExtNtx
	    ENDCASE

       CASE 'PRI' $ cMaeAct
	    DO CASE
	    CASE nNroOpc == 1
		 fNtxAlu := cIntUno+'\PRI\'+Ntx1Pri+cAnoSis+cExtNtx
	    CASE nNroOpc == 2
		 fNtxAlu := cIntUno+'\PRI\'+Ntx2Pri+cAnoSis+cExtNtx

	    CASE nNroOpc == 3
		 fNtxAlu := cIntUno+'\PRI\'+fNtxPri+cAnoSis+cExtNtx
	    ENDCASE

       CASE 'BTO' $ cMaeAct
	    DO CASE
	    CASE nNroOpc == 1
		 fNtxAlu := cIntUno+'\BTO\'+Ntx1Bto+cAnoSis+cExtNtx
	    CASE nNroOpc == 2
		 fNtxAlu := cIntUno+'\BTO\'+Ntx2Bto+cAnoSis+cExtNtx
	    CASE nNroOpc == 3
		 fNtxAlu := cIntUno+'\BTO\'+fNtxBto+cAnoSis+cExtNtx
	    ENDCASE
       ENDCASE
       DBCLEARIND()
       DBSETINDEX(fNtxAlu)
       GO TOP
       oBrowse:GOTOP()
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
*>>>>FIN ACTIVACION DE LOS INDICES

*>>>>IMPRESION DEL TITULO DE BUSQUEDA
       SET CURSOR ON
       DO CASE
       CASE nNroOpc == 1
	    nLenCam := LEN(cSpaces(cMaeAct,"cApelliEst"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL APELLIDO:')

       CASE nNroOpc == 2
	    nLenCam := LEN(cSpaces(cMaeAct,"cNombreEst"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL NOMBRE:')

       CASE nNroOpc == 3
	    nLenCam := LEN(cSpaces(cMaeAct,"cCodigoEst"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol)

       ENDCASE
       nColLin := nNroCol
*>>>>FIN IMPRESION DEL TITULO DE BUSQUEDA

*>>>>BUSQUEDA DEL REGISTRO
       DO WHILE .T.

**********IMPRESION DEL TITULO DE BUSQUEDA
	    DO CASE
	    CASE nNroOpc == 1
		 TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL APELLIDO:')
		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigo+;
				      SPACE(nLenCam-LEN(cCodigo))
		 SET COLOR TO

	    CASE nNroOpc == 2
		 TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL NOMBRE:')
		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigo+;
				      SPACE(nLenCam-LEN(cCodigo))
		 SET COLOR TO

	    CASE nNroOpc == 3
		 TitBuscar(nLenCam,@nNroFil,@nNroCol)
		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigo+;
				      SPACE(nLenCam-LEN(cCodigo))
		 SET COLOR TO

	    ENDCASE
**********FIN IMPRESION DEL TITULO DE BUSQUEDA

**********LECTURA DEL CARACTER
	    nTecPul := nLeeChr(nNroFil,nColLin)
	    IF nTecPul == 27 .OR. nTecPul == 13 .OR. LEN(cCodigo) == nLenCam
	       EXIT
	    ENDIF
	    cCodigo += CHR(nTecPul)
	    nColLin++
**********FIN LECTURA DEL CARACTER

**********BUSQUEDA DEL CODIGO
	    SELECT &cMaeAct
	    nNroReg := RECNO()
	    IF lSekCodMae(cCodigo,cMaeAct,cMaeAct,.F.)
	       nNroReg := RECNO()
	    ENDIF
	    GO TOP
	    oBrowse:GOTOP()
	    GO nNroReg
	    oBrowse:FORCESTABLE()
**********FIN BUSQUEDA DEL CODIGO

       ENDDO
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN BUSQUEDA DEL REGISTRO

/*************************************************************************
* TITULO..: ENCONTRAR CODIGO DEL ESTUDIANTE                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:35 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Permite encontrar el c¢digo del estudiante dentro de los maestros
   habilitados

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna .T. si encontro el c¢digo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSekCodMae(cCodEst,cMaeAlu,cMaeAct,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodEst			            // C¢digo del Alumno
       cMaeAlu                              // Maestros Habilitados
       cMaeAct			            // Alias del maestro del alumno
       lMensaj                              // .T. Mostrar Mensaje */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .F.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF 'JAR' $ cMaeAlu

	   cMaeAct := 'JAR'
	   lExiste := .F.
	   SELECT &cMaeAct
	   IF DBSEEK(cCodEst)
	      lExiste := .T.
	   ELSE
	      cMaeAct := NIL
	   ENDIF

       ENDIF

       IF 'PRI' $ cMaeAlu .AND. !lExiste

	   lExiste := .F.
	   cMaeAct := 'PRI'
	   SELECT &cMaeAct
	   IF DBSEEK(cCodEst)
	      lExiste := .T.
	   ELSE
	      cMaeAct := NIL
	   ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu .AND. !lExiste

	  lExiste := .F.
	  cMaeAct := 'BTO'
	  SELECT &cMaeAct
	  IF DBSEEK(cCodEst)
	     lExiste := .T.
	  ELSE
	     cMaeAct := NIL
	  ENDIF
       ENDIF

       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       IF !lExiste .AND. lMensaj
	  cError('EL CODIGO: '+cCodEst+' NO EXISTE')
       ENDIF
       RETURN lExiste
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: LECTURA DEL CODIGO DEL ESTUDIANTE                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:40 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Deben estar en uso los maestros habilitados

2- Lee y valida el c¢digo del Estudiante de cualquier maestro

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el c¢digo del estudiante

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeCodEst(nNroFil,nNroCol,cMaeAlu,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       cMaeAlu                              // Meaestro Habilitados
       cMaeAct			            // @Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList := {}                  // Variable del sistema

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cGetsSi := ''                  // Color del Get Selecionados
       LOCAL cGetsNo := ''                  // Color del Get No Seleccionados

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[1],'')),,;
	       @cGetsSi,@cGetsNo)
       cSetColor(','+cGetsSi+',,,'+cGetsNo)
*>>>>IF ANALISIS DEL COLOR

*>>>>CAPTURA Y VALIDACION DEL CODIGO
       DO WHILE .T.

**********CAPTURA DEL CODIGO
	    cCodigoTes := SPACE(06)
	    @ nNroFil,nNroCol GET cCodigoTes PICT '999999';
				  VALID lCorrecion(@cCodigoTes)

	    READ
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
**********FIN CAPTURA DEL CODIGO

**********VALIDACION EXISTENCIA DEL CODIGO
	    IF !lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct)
	       LOOP
	    ENDIF
	    EXIT
**********FIN VALIDACION EXISTENCIA CODIGO

       ENDDO
       SET COLOR TO
       RETURN cCodigoTes
*>>>>FIN CAPTURA Y VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 10/2004 MIE A
       Colombia, Bucaramanga        INICIO: 10:11 AM   NOV 10/2004 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrAlu(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<NO INGRESOS A CAFETERIA>')

       aAyuda := {}
       AADD(aAyuda,'Imprime los Estudiantes que NO ingresaron a Cafeter¡a')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,'MENU OTROS',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
          RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    CaF_00300(aP1,aP2,aP3,oBrowse)
	  *ÀIngresos a la Cafeteria

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 10/2004 MIE A
       Colombia, Bucaramanga        INICIO: 10:11 AM   NOV 10/2004 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrAlu011(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL dFecIng := CTOD('00/00/00')    // Fecha de Ingreso
       LOCAL lHayCaf := .F.                 // .T. Tiene Servicio de Cafeteria
       LOCAL cCampo  := ''                  // Campo
       LOCAL cMesSer := ''                  // Mes del Servicio de Cafeteria
       LOCAL cDiaSer := ''                  // Dia del Servicio de la Cafeteria
       LOCAL nNroSer := 0                   // N£mero de Servicios de la Cafeteria
       LOCAL lSiorNo := .F.                 // Variable de Control
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LOS GRUPOS',;
			 22,NIL,NIL,20,60)

       IF !lIntervGru(nNroFil,21,@nRegIni,@nRegFin)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  SELECT &cMaeAct
	  DBGOTOP()

	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DE LA FECHA DE VENCIMIENTO
       @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
       dFecIng := DATE()
       @ nNroFil+3,21 SAY 'FECHA DE INGRESO' GET dFecIng
       READ
       IF EMPTY(dFecIng)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  SELECT &cMaeAct
	  DBGOTOP()

	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA FECHA DE VENCIMIENTO

*>>>>ANALISIS DE DECISION
       lSiorNo := lPregunta('Imprimir. Estudiantes que SI ingresaron a la '+;
			    'Cafeteria? No Si')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)

	  SELECT &cMaeAct
	  DBGOTOP()

	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())
       nLenPrn := PCL('n17Stan')

       IF CAF->lPrnArcCaF
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := IF(lSiorNo,'EstSiCaF','EstNoCaF')
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAF->cOpcPrnCaF,.F.,.T.)
          IF EMPTY(nOpcPrn)
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   cTxtMaeAct(cMaeAct)+' JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   'ESTUDIANTES QUE '+IF(lSiorNo,'SI','NO')+' '+;
		   'INGRESARON A CAFETERIA',;
		   'FECHA:'+cFecha(dFecIng)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,8)
       AADD(aTitPrn,'GRUPO')

       AADD(aNroCol,40)
       AADD(aTitPrn,'NOMBRE')

       AADD(aNroCol,60)
       AADD(aTitPrn,'OBSERVACION')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
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

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cIntDos+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO EL ARCHIVO DE CLIENTES')
	       CloseDbf('CLI')
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO ESTAN CREADOS LOS CLIENTES DE LA CARTERA')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI')
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********RECORRIDO DE REGISTROS POR CLIENTES
	    SELECT CLI
	    CLI->(DBGOTOP())
	    DO WHILE .NOT. CLI->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+;
			      cGruFin+'ºNo. '+CLI->(STR(RECNO(),2))+'/'+;
			      CLI->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(CLI->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(32),1,40)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------VALIDACION DEL ACCESO A LA CAFETERIA
		 lHayCaf := .F.
		 IF !EMPTY(&cMaeAct->cConcepEst)

		    FOR i := 1 TO LEN(ALLTRIM(&cMaeAct->cConcepEst))/2
			cCodigoTco := SUBS(&cMaeAct->cConcepEst,i*2-1,2)
			IF lLocCodigo('cCodigoCon','CON',cCodigoTco) .AND.;
			   CON->nTipoCon == 2  // Cafeteria
			   lHayCaf := .T.
			ENDIF
		    ENDFOR

		 ENDIF

		 IF !lHayCaf
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VALIDACION DEL ACCESO A LA CAFETERIA

*--------------VALIDACION DEL INGRESO A LA CAFETERIA
		 cCampo := cMaeAct+'->cRes'+cMes(MONTH(dFecIng),3)+'Est'
		 cMesSer := &cCampo
		 cDiaSer := SUBS(cMesSer,DAY(dFecIng),1)
		 nNroSer := VAL(cDiaSer)

		 lHayErr := .T.
		 DO CASE
		 CASE lSiorNo .AND. nNroSer == 0
		 CASE !lSiorNo .AND. nNroSer > 0
		 OTHERWISE
		      lHayErr := .F.
		 ENDCASE
		 IF lHayErr
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VALIDACION DEL INGRESO A LA CAFETERIA

*--------------IMPRESION DEL REGISTRO
		 aRegPrn := {}
		 AADD(aRegPrn,&cMaeAct->cCodigoEst)
		 AADD(aRegPrn,&cMaeAct->cCodigoGru+'-'+;
			       STR(CLI->(RECNO()),2))
		 AADD(aRegPrn,cNombreTes)
		 AADD(aRegPrn,'')

		 lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*--------------FIN IMPRESION DEL REGISTRO

	       CLI->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO DE REGISTROS POR CLIENTES

	  SELECT GRU
	  GRU->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS