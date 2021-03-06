/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: PAGOS EN LINEA

**************************************************************************
* TITULO..: MENU DE PAGOS EN LINEA                                       *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: MAY 06/2008 MAR A
       Bucaramanga, Colombia        INICIO: 07:00 AM   MAY 06/2008 MAR

OBJETIVOS:

1- Visualiza un men� de pagos en li�na

2- Ejecuta las diferentes opciones

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_209(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci�n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C�digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *�Detalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C�digo de la Empresa
     *�Detalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A�o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A�o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *�Detalles del Usuario

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
     *�Sitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci�n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci�n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci�n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci�n Cuatro
     *�Path de Integraci�n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men� principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen�
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen�
     *�Detalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *�Detalles Acad�micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci�n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL PathRfa := ''                  // Path Recibos facturados
       LOCAL fRecFac := 'RECI'              // Ej: RECIENE.DAT

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL cNalias := ''                  // Alias del Archivo
     *�Variables archivos

       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL nCodPrn := 0                   // C�digo de Impresi�n
       LOCAL cOpcPrn := ''                  // Opciones de Impresi�n.
       LOCAL cUsrIso := ''                  // Usuario del Iso
       LOCAL nCodXsl := 0                   // C�digo Xsl informes
       LOCAL cPiePag := ''                  // Pie de p�gina informes
       LOCAL aMezIso := {}                  // Campos a Mesclar
     *�Variables informes

       LOCAL nPrueba := 0                   // Habilitar pruebas
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL bInsReg := NIL                 // Block Insertar registros
     *�Variables registros

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroCol := 0                   // N�mero de Columna
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men�
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men�
     *�Variables de menu

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL PathAct := ''                  // Path Actual

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
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
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DEL MES
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de la Facturaci�n',.T.)

       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIni == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni,.T.)
*>>>>FIN CAPTURA DEL MES

*>>>>DIRECTORIOS
       PathAct := cPathAct()

       PathOnl := cPatSis+'\online\'+cMes(nMesIni,3)
       Mdir(PathOnl,PathAct)
     *�Directorio para el mes de facturacion

       Mdir(PathDoc+'\online\'+cAnoUsr+'\'+;
	    cMes(nMesIni,3)+'\'+SUBS(SCO->cSerFacCon,1,5),PathAct)
     *�Directorio para el mes de facturacion. Exportaci�n
*>>>>FIN DIRECTORIOS

*>>>>VALIDACION DE LA EXISTENCIA DEL ARCHIVO
       FileOnl := FileOnl+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile
       IF !FILE(PathOnl+'\'+FileOnl)
	  CreaDbfOnl(lShared,nModCry,PathOnl,FileOnl)
       ENDIF
       nActStrOnl(lShared,nModCry,PathOnl,FileOnl)
*>>>>FIN VALIDACION DE LA EXISTENCIA DEL ARCHIVO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileBan,'BAN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathOnl+'\'+FileOnl,'ONL',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
       nPrueba := SCA->nPruebaCar
       lPrnArc := SCA->lPrnArcCar
       nCodPrn := SCA->nCodigoPrn
       cOpcPrn := SCA->cOpcPrnCar
       cUsrIso := SCA->cUsrIsoCar
       nCodXsl := SCA->nCodXslCar
       cPiePag := SCA->cPiePagCar
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>PARAMETROS ESPECIFICOS
       aP2 := {}
       AADD(aP2,{'PathOnl',PathOnl})
       AADD(aP2,{'FileOnl',FileOnl})
       AADD(aP2,{'nMesIni',nMesIni})
       AADD(aP2,{'nPagOnl',SCA->nPagOnlCar})
       AADD(aP2,{'cCodEmp','01'}) // Ojo Revisar
       AADD(aP2,{'cCodFac',ALLTRIM(SCA->cCodFacCar)})
*>>>>FIN PARAMETROS ESPECIFICOS


*>>>>DECLARACION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus := {}
       AADD(aMenus,'1<CREAR    >')
       AADD(aMenus,'2<CONSULTAR>')
       AADD(aMenus,'3<RECIBOS  >')

       aAyuda := {}
       AADD(aAyuda,'Permite crear los registros de la facturaci�n')
       AADD(aAyuda,'Consultar los registros de la facturaci�n')
       AADD(aAyuda,'Consultar los recibos facturados')
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       nNroCol := nColInf
       IF nColInf + nLenOpc + 2 > 78
	  nNroCol := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nNroCol,NIL,NIL,nNroOpc,.F.)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1

***************ANALISIS DE DECISION
		 IF ONL->(RECCOUNT()) # 0
		    cError('EL ARCHIVO DE '+cMes(VAL(cMesIni))+' '+;
			   'YA ESTA CREADO')

		    IF !lPregunta('DESEA VOLVER A GENERAR EL ARCHIVO DE'+' '+;
				  cMes(VAL(cMesIni))+'?No Si')
		       LOOP
		    ENDIF
		 ENDIF
***************FIN ANALISIS DE DECISION

***************CREACION DEL ARCHIVO
		 Carte_291(aP1,aP2,aP3)
***************FIN CREACION DEL ARCHIVO

	  CASE nNroOpc == 2

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
		 AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
		 AADD(aArchvo,{PathSis+'\'+FSimCar,NIL,'SCA'})
		 AADD(aArchvo,{PathOnl+'\'+FileOnl,NIL,'ONL'})
***************FIN AREAS DE TRABAJO

***************DETALLES DEL INFORME
		 aP3 := {}
		 AADD(aP3,{'cPieTre',cPiePag})
		 AADD(aP3,{'cUsrIso',cUsrIso})
		 AADD(aP3,{'nCodXsl',nCodXsl})
***************FIN DETALLES DEL INFORME

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := .F.
		  lDelReg := .F.
		  lInsReg := .F.
		  lHaySql := .F.
		  bInsReg := NIL

		  MantenOnl(aP1,aP2,aP3,aArchvo,cOpcPrn,;
			    nCodPrn,lModReg,lDelReg,;
			    lInsReg,lHaySql,bInsReg)
***************FIN MANTENIMIENTO DEL ARCHIVO

***************AREAS DE TRABAJO
		 aUseDbf := {}
		 AADD(aUseDbf,{.T.,PathSis+'\'+;
				   FSimCar,'SCA',NIL,lShared,nModCry})

		 AADD(aUseDbf,{.T.,cPatSis+'\'+;
				   fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

		 AADD(aUseDbf,{.T.,PathOnl+'\'+;
				   FileOnl,'ONL',NIL,lShared,nModCry})
***************FIN AREAS DE TRABAJO


***************SELECCION DE LAS AREAS DE TRABAJO
		IF !lUseDbfs(aUseDbf)
		ENDIF
***************FIN SELECCION DE LAS AREAS DE TRABAJO

	  CASE nNroOpc == 3

***************AREAS DE TRABAJO
		 PathRfa := cPatSis+'\RECIBOS\'+cMes(nMesIni,3)
		 fRecFac := 'RECI'+cMes(nMesIni,3)+ExtFile

		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
		 AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
		 AADD(aArchvo,{PathSis+'\'+FSimCar,NIL,'SCA'})
		 AADD(aArchvo,{PathRfa+'\'+fRecFac,NIL,'RFA'})

		 IF 'JAR' $ cMaeAlu
		    cNalias := 'JAR'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF

		 IF 'PRI' $ cMaeAlu
		    cNalias := 'PRI'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF

		 IF 'BTO' $ cMaeAlu
		    cNalias := 'BTO'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF
***************FIN AREAS DE TRABAJO

***************DETALLES DEL INFORME
		 aP3 := {}
		 AADD(aP3,{'cPieTre',cPiePag})
		 AADD(aP3,{'cUsrIso',cUsrIso})
		 AADD(aP3,{'nCodXsl',nCodXsl})
***************FIN DETALLES DEL INFORME

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := .F.
		  lDelReg := .F.
		  lInsReg := .F.
		  lHaySql := .F.
		  bInsReg := NIL

		  MantenRfa(lShared,nModCry,cNomSis,cCodEmp,;
			    cNitEmp,cEmpPal,cNomEmp,cNomSec,;
			    cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			    cOpcPrn,nCodPrn,lModReg,lDelReg,;
			    lInsReg,lHaySql,cMaeAlu,cMaeAct)
***************FIN MANTENIMIENTO DEL ARCHIVO

***************AREAS DE TRABAJO
		 aUseDbf := {}
		 AADD(aUseDbf,{.T.,PathSis+'\'+;
				   FSimCar,'SCA',NIL,lShared,nModCry})

		 AADD(aUseDbf,{.T.,cPatSis+'\'+;
				   fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

		 AADD(aUseDbf,{.T.,PathOnl+'\'+;
				   FileOnl,'ONL',NIL,lShared,nModCry})
***************FIN AREAS DE TRABAJO


***************SELECCION DE LAS AREAS DE TRABAJO
		IF !lUseDbfs(aUseDbf)
		ENDIF
***************FIN SELECCION DE LAS AREAS DE TRABAJO

	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

