/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : ACTUALIZAR
SUBMODULO...: ACTUALIZAR ALUMNOS                       MODULO No. 5

**************************************************************************
* TITULO..: GRABACION DE LOS PAZ Y SALVOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2003 MIE A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   NOV 12/2003 MIE

OBJETIVOS:

1- Permite Grabar los Paz y Salvos Contables.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_509(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       AADD(aMenus,'1<GRABACION>')
       AADD(aMenus,'2<CONSULTA >')
       AADD(aMenus,'3<IMPRESION>')

       AADD(aAyuda,'Grabaci¢n de los Paz y Salvos')
       AADD(aAyuda,'Consulta de la Grabaci¢n de los Paz y Salvos')
       AADD(aAyuda,'Impresi¢n de la Descripci¢n de Deudas')

       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,nNroOpc)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(nNroOpc)
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Carte_591(aParam1,aParam2,aParam3)
	   *Grabaci¢n del Paz y Salvo

       CASE nNroOpc == 2
	    Carte_592(aParam1,aParam2,aParam3)
	   *Consulta

       CASE nNroOpc == 3
	    Carte_593(aParam1,aParam2,aParam3)
	   *Impresi¢n de los Paz y Salvos


       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: GRABACION DE LOS PAZ Y SALVOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2003 MIE A
       Bucaramanga, Colombia	    INICIO: 04:45 PM   NOV 12/2003 MIE


OBJETIVOS:

1- Permite Grabar los Paz y Salvos de los Estudiantes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_591(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL       i := 0                   // Contador
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // Columnas del Encabezado del  Estudiante
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nHayPaz := 0                   // 1=>NO Paz y Salvo 2=>SI Paz y Salvo
       LOCAL cFilter := ''                  // C¢ndici¢n del Filtro
       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL cCampos := ''                  // Nombre de Campo
       LOCAL lAgrega := .T.                 // .T. Agregar Registro
       LOCAL cCodPaz := ''                  // C¢digo del Paz y Salvo
       LOCAL cSavTem := ''                  // Salvar Pantalla Temporal

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cDescriTdp := ''               // Descripci¢n del Paz y Salvo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE PAZ->(RECCOUNT()) == 0
	    cError('NO EXISTEN ITEMS DE PAZ Y SALVOS CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DEL ARCHIVO
       cCodPaz := ALLTRIM(CAA->cCodPazCaA)
       cFilter := ''
       IF !EMPTY(cCodPaz)
	  FOR i := 1 TO LEN(cCodPaz)/2
	      cFilter += 'nCodigoPaz == '+SUBS(cCodPaz,i*2-1,2)
	      IF i < LEN(cCodPaz)/2
		 cFilter += ' .OR. '
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>ANALISIS DE DECISION
       IF EMPTY(cFilter)
	  cError('NO ESTA HABILITADA LA GRABACION DE PAZ Y SALVO')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>FILTRACION DEL ARCHIVO
       SELECT PAZ
       SET FILTER TO &cFilter
       PAZ->(DBGOTOP())

       IF PAZ->(EOF())
	  cError('ERROR EN LOS ITEMS '+ALLTRIM(cCodPaz)+;
		 'ASIGNADOS AL PROFESOR')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>LECTURA DEL NUMERO DEL ITEM DEL PAZ Y SALVO
       @ nFilInf+1,01 SAY 'ITEM DEL PAZ Y SALVO:';
		      GET nCodPaz PICT '99';
		      VALID lValidaPaz(ROW(),COL()-1,@nCodPaz)
       READ
       IF EMPTY(nCodPaz)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DEL ITEM DEL PAZ Y SALVO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('ESCOGIO EL ITEM '+ALLTRIM(PAZ->cNombrePaz)+;
		     '.DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DEL TIPO DE PAZ Y SALVO
       nHayPaz := nLeeOpcion('TIPO DE GRABACION: '+;
		 '1<NO Paz y Salvo> 2<SI Paz y Salvo> 3<ABANDONAR>?',3,'1')

       IF nHayPaz == 3
	  CloseAll()
	  RETURN NIL
       ENDIF
       IF !lPregunta('Escogio '+IF(nHayPaz==1,'NO','SI')+' Paz y Salvos'+;
		     '.DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE PAZ Y SALVO

*>>>>IMPRESION DE LOS ENCABEZADOS
       cSavTem := SAVESCREEN(23,00,23,79)
       nNroFil := nMarco(nFilPal+1,'Digite los c¢digos que '+;
				   IF(nHayPaz==1,'NO','SI')+' '+;
				   'estan a Paz y Salvo por '+;
				    ALLTRIM(PAZ->cNombrePaz),22,'°')

       nNroCol := 1
       aTamCol := {06,40,06}
       aTitulo := {'CODIGO','DESCRIPCION DEUDA',''}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS REGISTROS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ALUMNO: '+cNombreTes+'º'+;
			'GRUPO:'+&cMaeAct->cCodigoGru,cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LOCALIZACION DESCRIPCION DEUDA
	    lAgrega := .T.
	    cDescriTdp := SPACE(70)
	    SELECT DPZ
	    LOCATE FOR DPZ->cCodigoEst == cCodigoTes .AND.;
		       DPZ->nCodigoPaz == nCodPaz
	    IF FOUND()
	       lAgrega := .F.
	       cDescriTdp := DPZ->cDescriDpz
	    ENDIF
**********FIN LOCALIZACION DESCRIPCION DEUDA

**********LECTURA DE LA DESCRIPCION DE LA DEUDA
	    IF nHayPaz == 1
	       DO WHILE .T.
		  @ nNroFil,aNroCol[2] GET cDescriTdp PICT "@s64X"
		  READ
		  IF nHayPaz == 1 .AND. lAgrega .AND.;
		     EMPTY(cDescriTdp)
		     cError('DEBE ESCRIBIR QUE DEBE EL ESTUDIANTE')
		     LOOP
		  ENDIF
		  EXIT
	       ENDDO
	    ENDIF
**********FIN LECTURA DE LA DESCRIPCION DE LA DEUDA

**********ANALISIS DE DECISION
	    IF !lPregunta('DESEA GRABAR? Si No')
	       LOOP
	    ENDIF
	    RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
	    RESTSCREEN(23,00,23,79,cSavTem)
**********FIN ANALISIS DE DECISION

**********GRABACION DEL PAZ Y SALVO
	    SELECT &cMaeAct
	    IF lRegLock(lShared,.F.)
	       cCampos := cMaeAct+'->cPazSdoEst'
	       IF nHayPaz==1
		  REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,'N')
	       ELSE
		  REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,SPACE(01))
	       ENDIF
	       DBCOMMIT()
	    ELSE
	       cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	    ENDIF
	    IF lShared
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DEL PAZ Y SALVO

**********GRABACION DE LA DESCRIPCION DEL PAZ Y SALVO
	    IF DPZ->(lRegLock(lShared,lAgrega))

	       IF lAgrega
		  REPL DPZ->cCodigoEst WITH cCodigoTes
		  REPL DPZ->nCodigoPaz WITH nCodPaz
	       ENDIF
	       IF nHayPaz == 1
		  REPL DPZ->cDescriDpz WITH cDescriTdp
	       ENDIF
	       REPL DPZ->lPazSdoDpz WITH IF(nHayPaz==1,.F.,.T.)
	       DPZ->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	    ENDIF
	    IF lShared
	       DPZ->(DBUNLOCK())
	    ENDIF
	    @ nNroFil,aNroCol[1] SAY cCodigoTes
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY &cMaeAct->cCodigoGru+'....'+;
				     IF(nHayPaz==1,'NO','SI')+;
				     ' Paz y Salvo'
**********FIN GRABACION DE LA DESCRIPCION DEL PAZ Y SALVO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'Digite los c¢digos que '+;
					     IF(nHayPaz==1,'NO','SI')+' '+;
					     'estan a Paz y Salvo por '+;
					      ALLTRIM(PAZ->cNombrePaz),22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt
		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY &cMaeAct->cCodigoGru
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

/*************************************************************************
* TITULO..: CONSULTA DE LOS PAZ Y SALVOS                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2003 MIE A
       Bucaramanga, Colombia	    INICIO: 06:00 PM   NOV 12/2003 MIE

OBJETIVOS:

1- Permite Consultar los Paz y Salvos Grabados

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_592(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL       i := 0                   // Contador
       LOCAL cFilter := ''                  // C¢ndici¢n del Filtro
       LOCAL cCodPaz := ''                  // C¢digo del Paz y Salvo

       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PAZ->(RECCOUNT()) == 0
	    cError('NO EXISTEN ITEMS DE PAZ Y SALVOS CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS PARA EL FILTRO
       cCodPaz := ALLTRIM(CAA->cCodPazCaA)
       cFilter := ''
       IF !EMPTY(cCodPaz)
	  FOR i := 1 TO LEN(cCodPaz)/2
	      cFilter += 'nCodigoPaz == '+SUBS(cCodPaz,i*2-1,2)
	      IF i < LEN(cCodPaz)/2
		 cFilter += ' .OR. '
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN ANALISIS PARA EL FILTRO

*>>>>ANALISIS DE DECISION
       IF EMPTY(cFilter)
	  cError('NO APARACEN DESCRIPCIONES DE DEUDAS DE PAZ Y SALVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       cFilter += ' .AND. !DPZ->lPazSdoDpz'
*>>>>FIN ANALISIS DE DECISION

*>>>>FILTRACION DEL ARCHIVO
       SELECT DPZ
       SET FILTER TO &cFilter
       DPZ->(DBGOTOP())

       IF DPZ->(EOF())
	  cError('NO APARACEN DESCRIPCIONES DE DEUDAS DE PAZ Y SALVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>CONSULTA DEL BROWSE
       oBrowse := oDefBrwDpz(lShared,cAnoUsr,cPatSis,nFilPal+1,00,22,79)
       DPZ->(CtrlBrw(lShared,oBrowse))
       CloseAll()
       RETURN NIL
*>>>>FIN CONSULTA DEL BROWSE

/*************************************************************************
* TITULO..: IMPRESION DE LOS PAZ Y SALVOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2003 MIE A
       Bucaramanga, Colombia	    INICIO: 06:15 PM   NOV 12/2003 MIE


OBJETIVOS:

1- Permite Imprimir las Estudiante que no estan a Paz y Salvo con el
   Profesor.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_593(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

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
       LOCAL nTotPag := 0                   // Total P ginas
       LOCAL lPrnCab := .T.                 // .T. Imprimir el Encabezado
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL cFilter := ''                  // C¢ndici¢n del Filtro
       LOCAL cCodPaz := ''                  // C¢digo del Paz y Salvo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PAZ->(RECCOUNT()) == 0
	    cError('NO EXISTEN ITEMS DE PAZ Y SALVOS CREADOS')

       CASE DPZ->(RECCOUNT()) == 0
	    cError('NO EXISTEN DESCRIPCION DE DEUDAS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

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
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ANALISIS PARA EL FILTRO
       cCodPaz := ALLTRIM(CAA->cCodPazCaA)
       cFilter := ''
       IF !EMPTY(cCodPaz)
	  FOR i := 1 TO LEN(cCodPaz)/2
	      cFilter += 'nCodigoPaz == '+SUBS(cCodPaz,i*2-1,2)
	      IF i < LEN(cCodPaz)/2
		 cFilter += ' .OR. '
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN ANALISIS PARA EL FILTRO

*>>>>ANALISIS DE DECISION
       IF EMPTY(cFilter)
	  cError('NO APARACEN DESCRIPCIONES DE DEUDAS DE PAZ Y SALVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       cFilter += ' .AND. !DPZ->lPazSdoDpz'
*>>>>FIN ANALISIS DE DECISION

*>>>>FILTRACION DEL ARCHIVO
       SELECT DPZ
       SET FILTER TO &cFilter
       DPZ->(DBGOTOP())

       IF DPZ->(EOF())
	  cError('NO APARACEN DESCRIPCIONES DE DEUDAS DE PAZ Y SALVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO


*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  '',;
		  'DESCRIPCION DE DEUDAS DE PAZ Y SALVOS',;
		  '',;
		  nNroPag,NIL,lTamAnc}

       cCodIni := PCL({'DraftOn','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,40,70}
       aTitulo := {'CODIGO','GRUPO','NOMBRE','DESCRIPCION'}

       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT DPZ
       DPZ->(DBGOTOP())
       DO WHILE .NOT. DPZ->(EOF())

**********IMPRESION DEL ENCABEZADO
	    IF lPrnCab

	       SendCodes(PCL('Reset'))

	       EVAL(bCabeza)
	      *Impresi¢n del Encabezado

	       lPrnCab := .F.
	    ENDIF
**********FIN IMPRESION DEL ENCABEZADO

**********VISUALIZACION DATOS DEL ESTUDIANTE
	    IF !lSekCodMae(DPZ->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	       cNombreTes = 'CODIGO NO EXISTE'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN VISUALIZACION DATOS DEL ESTUDIANTE

**********IMPRESION DEL PERIODO
	    aTitulo := {DPZ->cCodigoEst,;
			&cMaeAct->cCodigoGru,;
			cNombreTes,;
			DPZ->cDescriDpz}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
**********FIN IMPRESION DEL PERIODO

	  DPZ->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN

       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS