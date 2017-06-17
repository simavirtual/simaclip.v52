/*SIMA - SISTEMA DE CAFETERIA

MODULO      : INFORMES
SUBMODULO...: PAZ Y SALVOS                             MODULO No. 306

**************************************************************************
* TITULO..: GRABACION DE LOS PAZ Y SALVOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2003 MIE A
       Colombia, Bucaramanga        INICIO: 07:30 AM   NOV 12/2003 MIE

OBJETIVOS:

1- Permite Grabar los Paz y Salvos Contables.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_306(aP1,aP2,aP3)

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
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL       i := 0                   // Contador

       LOCAL nPrueba := 0                   // Habilitar pruebas
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀVariables archivos

       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL cUsrIso := ''                  // Usuario del Iso
       LOCAL nCodXsl := 0                   // C¢digo Xsl informes
       LOCAL cPiePag := ''                  // Pie de p gina informes
       LOCAL aMezIso := {}                  // Campos a Mesclar
     *ÀVariables informes

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCaF,'CAF',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAF->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       nPrueba := CAF->nPruebaCaF
       lPrnArc := CAF->lPrnArcCaF
       nCodPrn := CAF->nCodigoPrn
       cOpcPrn := CAF->cOpcPrnCaF
       cUsrIso := CAF->cUsrIsoCaF
       nCodXsl := CAF->nCodXslCaF
       cPiePag := CAF->cPiePagCaF

       CloseDbf('CAF')
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

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
	    Cafe_361(aP1,aP2,aP3)
	   *Grabaci¢n del Paz y Salvo

       CASE nNroOpc == 2
	    Cafe_362(aP1,aP2,aP3)
	   *Consulta

       CASE nNroOpc == 3

************AREAS DE TRABAJO
	      aArchvo := {}
	      FOR i := 1 TO LEN(cMaeAlu)/3
		  cMaeAct := SUBS(cMaeAlu,i*3-2,3)
		  AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				FileAlu+cMaeAct+cAnoSis+ExtFile,;
				PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				fNtxAlu+cMaeAct+cAnoSis+cExtNtx,cMaeAct})
	      ENDFOR
	      AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+;
			    fPazEst+cAnoSis+ExtFile,NIL,'PAZ'})
	      AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+;
			    fDpzEst+cAnoSis+ExtFile,NIL,'DPZ'})
	      AADD(aArchvo,{PathSis+'\'+fSimCaf,NIL,'CAF'})
	      AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
	      AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
	      AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
	      AADD(aArchvo,{cPatSis+'\'+;
			    FCaFAno+cAnoUsr+ExtFile,NIL,'CFA'})
************FIN AREAS DE TRABAJO

************IMPRESION DEL ARCHIVO
	      lModReg := .F.
	      lDelReg := .F.
	      lInsReg := .F.
	      lHaySql := .F.

	      CaF_00800(aP1,aP2,aP3,;
			aArchvo,cOpcPrn,nCodPrn,lModReg,;
			lDelReg,lInsReg,lHaySql,oBrowse)
************FIN IMPRESION DEL ARCHIVO

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: GRABACION DE LOS PAZ Y SALVOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2003 MIE A
       Colombia, Bucaramanga        INICIO: 07:30 AM   NOV 12/2003 MIE

OBJETIVOS:

1- Permite Grabar los Paz y Salvos de los Estudiantes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_361(aP1,aP2,aP3)

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
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
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

       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FCaFAno+cAnoUsr+ExtFile,'CFA',NIL,lShared,nModCry})
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
       CASE CFA->(RECCOUNT()) == 0
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
       cCodPaz := ALLTRIM(CFA->cCodPazCfA)
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
       Bucaramanga, Colombia	    INICIO: 07:55 PM   NOV 12/2003 MIE

OBJETIVOS:

1- Permite Consultar los Paz y Salvos Grabados

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_362(aP1,aP2,aP3)

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
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL       i := 0                   // Contador
       LOCAL cFilter := ''                  // C¢ndici¢n del Filtro
       LOCAL cCodPaz := ''                  // C¢digo del Paz y Salvo

       LOCAL oBrowse := NIL                 // Browse del Archivo


       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FCaFAno+cAnoUsr+ExtFile,'CFA',NIL,lShared,nModCry})
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
       cCodPaz := ALLTRIM(CFA->cCodPazCfA)
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
