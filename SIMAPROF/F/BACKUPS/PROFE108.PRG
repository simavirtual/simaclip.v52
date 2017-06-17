/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LISTAS
SUBMODULO...: MENU DE PAZ Y SALVO

**************************************************************************
* TITULO..: MENU DE PAZ Y SALVO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2003 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   OCT 21/2003 MAR


OBJETIVOS:

1- Menu de Paz y Salvos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_108(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

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
	    Profe_181(aP1,aP2,aP3)
	   *Grabaci¢n del Paz y Salvo

       CASE nNroOpc == 2
	    Profe_182(aP1,aP2,aP3)
	   *Consulta

       CASE nNroOpc == 3
	    Profe_183(aP1,aP2,aP3)
	   *Impresi¢n de los Paz y Salvos

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: GRABACION DE LOS PAZ Y SALVOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2003 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   OCT 21/2003 MAR


OBJETIVOS:

1- Permite Grabar los Paz y Salvos de los Estudiantes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_181(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nHayPaz := 0                   // 1=>NO Paz y Salvo 2=>SI Paz y Salvo
       LOCAL cFilter := ''                  // C¢ndici¢n del Filtro
       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL cCampos := ''                  // Nombre de Campo
       LOCAL lAgrega := .T.                 // .T. Agregar Registro
       LOCAL cSavTem := ''                  // Salvar Pantalla Temporal

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodPazTpr := ''               // C¢digo del Profesor
       LOCAL cDescriTdp := ''               // Descripci¢n del Paz y Salvo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE JARDIN')

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE PRIMARIA')

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE BACHILLERATO')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE CONTABILIDAD')

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

*>>>>LOCALIZACION DEL PROFESOR
       IF !lLocCodigo('cCodigoPro','PRO',cCodPro,'DEL PROFESOR')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       cCodPazTpr := ALLTRIM(PRO->cCodPazPro)
*>>>>FIN LOCALIZACION DEL PROFESOR

*>>>>ANALISIS DEL FILTRO
       cFilter := ''
       IF !EMPTY(cCodPazTpr)
	  FOR i := 1 TO LEN(cCodPazTpr)/2
	      cFilter += 'nCodigoPaz == '+SUBS(cCodPazTpr,i*2-1,2)
	      IF i < LEN(cCodPazTpr)/2
		 cFilter += ' .OR. '
	      ENDIF
	  ENDFOR
       ENDIF

       IF lLocCodigo('cCodigoPro','GRU',cCodPro)
	  IF EMPTY(cFilter)
	     cFilter += 'nNroTipPaz == 2'
	  ELSE
	     cFilter += ' .OR. nNroTipPaz == 2'
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DEL FILTRO

*>>>>ANALISIS DE DECISION
       IF EMPTY(cFilter)
	  cError('NO ESTA HABILITADO PARA GRABAR PAZ Y SALVO')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>FILTRACION DEL ARCHIVO
       SELECT PAZ
       SET FILTER TO &cFilter
       PAZ->(DBGOTOP())

       IF PAZ->(EOF())
	  cError('ERROR EN LOS ITEMS '+ALLTRIM(cCodPazTpr)+;
		 'ASIGNADOS AL PROFESOR')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>LECTURA DEL NUMERO DEL ITEM DEL PAZ Y SALVO
       @ nFilInf+1,nColInf SAY 'ITEM DEL PAZ Y SALVO:';
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

**********VALIDACION DEL GRUPO
	    IF PAZ->nNroTipPaz == 2 .AND.;
	       GRU->cCodigoGru # &cMaeAct->cCodigoGru
	       cError(cNombreTes+' NO ES DEL GRUPO '+GRU->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL GRUPO

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
	       REPL DPZ->cCodigoPro WITH cCodPro
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2003 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   OCT 21/2003 MAR


OBJETIVOS:

1- Permite Consultar los Paz y Salvos Grabados

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_182(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL oBrowse := NIL                 // Browse del Archivo


       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE JARDIN')

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE PRIMARIA')

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE BACHILLERATO')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE CONTABILIDAD')

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

*>>>>LOCALIZACION DEL PROFESOR
       IF !lLocCodigo('cCodigoPro','PRO',cCodPro,'DEL PROFESOR')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PROFESOR

*>>>>FILTRACION DE LOS INDICADORES
       SELECT DPZ
       SET FILTER TO DPZ->cCodigoPro == cCodPro .AND.;
		     !DPZ->lPazSdoDpz
       DPZ->(DBGOTOP())
       IF DPZ->(EOF())
	  cError('NO APARACEN DESCRIPCIONES DE DEUDAS DE PAZ Y SALVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS INDICADORES

*>>>>CONSULTA DEL BROWSE
       oBrowse := oDefBrwDpz(lShared,cAnoUsr,cPatSis,nFilPal+1,00,22,79)
       DPZ->(CtrlBrw(lShared,oBrowse))
       CloseAll()
       RETURN NIL
*>>>>FIN CONSULTA DEL BROWSE

/*************************************************************************
* TITULO..: IMPRESION DE LOS PAZ Y SALVOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2003 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   OCT 21/2003 MAR


OBJETIVOS:

1- Permite Imprimir las Estudiante que no estan a Paz y Salvo con el
   Profesor.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_183(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

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

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE JARDIN')

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE PRIMARIA')

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE BACHILLERATO')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE CONTABILIDAD')

       CASE PAZ->(RECCOUNT()) == 0
	    cError('NO EXISTEN ITEMS DE PAZ Y SALVOS CREADOS')

       CASE SPR->(RECCOUNT()) == 0
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
       IF !lLocCodigo('nCodigoPrn','PRN',SPR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LOCALIZACION DEL PROFESOR
       IF !lLocCodigo('cCodigoPro','PRO',cCodPro,'DEL PROFESOR')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PROFESOR

*>>>>FILTRACION DE LOS INDICADORES
       SELECT DPZ
       SET FILTER TO DPZ->cCodigoPro == cCodPro .AND.;
		     !DPZ->lPazSdoDpz
       DPZ->(DBGOTOP())
       IF DPZ->(EOF())
	  cError('NO APARACEN DESCRIPCIONES DE DEUDAS DE PAZ Y SALVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS INDICADORES

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
       aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SPR->lPrnArcSpr
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.F.)
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
	    IF !lSekCodMae(DPZ->cCodigoEst,cMaeAlu,@cMaeAct)
	       cNombreTes = 'CODIGO NO EXISTE'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 &cMaeAct->cNombreEst
	    cNombreTes := SUBS(cNombreTes,1,40)
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