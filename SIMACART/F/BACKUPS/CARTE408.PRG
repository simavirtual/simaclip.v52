/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: PAGOS EN LINEA

**************************************************************************
* TITULO..: MENU DE FACTURACION MAS PAGOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/2008 MAR A
       Bucaramanga, Colombia        INICIO: 07:00 AM   MAY 06/2008 MAR

OBJETIVOS:

1- Visualiza un men£ de pagos en li¡na

2- Ejecuta las diferentes opciones

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_408(aP1,aP2,aP3)

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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
     *ÀVariables archivos

       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL cUsrIso := ''                  // Usuario del Iso
       LOCAL nCodXsl := 0                   // C¢digo Xsl informes
       LOCAL cPiePag := ''                  // Pie de p gina informes
       LOCAL aMezIso := {}                  // Campos a Mesclar
     *ÀVariables informes

       LOCAL nPrueba := 0                   // Habilitar pruebas
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL bInsReg := NIL                 // Block Insertar registros
     *ÀVariables registros

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
     *ÀVariables de menu

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL PathAct := ''                  // Path Actual

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus := {}
       AADD(aMenus,'1<FACTURACION MAS PAGOS>')
       AADD(aMenus,'2<PAGOS POR CONCEPTOS  >')
       AADD(aMenus,'3<IMPUESTO ICA         >')
       AADD(aMenus,'4<INICIALIZACION       >')
       AADD(aMenus,'5<ANTICIPOS            >')

       aAyuda := {}
       AADD(aAyuda,'Imprime el comportamiento de pagos de acuerdo a la forma de pago')
       AADD(aAyuda,'Imprime el comportameitno de pagos mes a mes')
       AADD(aAyuda,'Imprime el informe para pagar el impuesto del ICA')
       AADD(aAyuda,'Inicializa los totales en cero')
       AADD(aAyuda,'Genera el informe de Anticpos para la Dian')
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
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_481(aP1,aP2,aP3)
	      *Facturaci¢n mas pagos anual


	  CASE nNroOpc == 2
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_482(aP1,aP2,aP3)
	      *Pogos por conceptos.

	  CASE nNroOpc == 3
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_483(aP1,aP2,aP3)
	      *Facturaci¢n mas pagos por meses

	  CASE nNroOpc == 4
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_484(aP1,aP2,aP3)
	      *Inicializa los totales.

	  CASE nNroOpc == 5
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_485(aP1,aP2,aP3)
	      *Anticipos Dian


	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* NOMBRE ..: FACTURACION Y PAGOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2005 MIE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   ABR 20/2005 MIE

OBJETIVOS:

1- Imprime una relaci¢n detallada de facilitar los reportes de acuerdo
   al total de la facturaci¢n y pagos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_481(aParam1,aParam2,aParam3)

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
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

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
       LOCAL nNroAlu := 0                   // N£mero de Estudiantes
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL nVlrMtr := 0                   // Valor de la matr¡cula
       LOCAL nVlrFac := 0                   // Valor de la facturaci¢n
       LOCAL nVlrPag := 0                   // Valor de los pagos
       LOCAL nTotPag := 0                   // Valor temporal
       LOCAL nTotFac := 0                   // Total Facturado

       LOCAL nOpcRep := 0                   // Opci¢n del Reporte
       LOCAL lHayAlu := .F.                 // .T. Existe el Estudiante
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n
       LOCAL nSdoAct := 0                   // Saldo Actual

       LOCAL cDocPad := ''                  // N£mero del Documento
       LOCAL cAp1Pad := ''                  // Primer apellido
       LOCAL cAp2Pad := ''                  // Segundo apellido
       LOCAL cNo1Pad := ''                  // Primer Nombre
       LOCAL cNo2Pad := ''                  // Segundo Nombre
       LOCAL cDirPad := ''                  // Direccion del Padre
       LOCAL cCiuPad := ''                  // Ciudad del Padre
       LOCAL cDepPad := ''                  // Departamento del Padre

       LOCAL cDocMad := ''                  // N£mero del Documento
       LOCAL cAp1Mad := ''                  // Primer apellido
       LOCAL cAp2Mad := ''                  // Segundo apellido
       LOCAL cNo1Mad := ''                  // Primer Nombre
       LOCAL cNo2Mad := ''                  // Segundo Nombre
       LOCAL cDirMad := ''                  // Direccion de la Madre
       LOCAL cCiuMad := ''                  // Ciudad de la Madre
       LOCAL cDepMad := ''                  // Departamento de la Madre

       LOCAL cDocNit := ''                  // Documento de Identidad
       LOCAL cApeUno := ''                  // Primer Apellido
       LOCAL cApeDos := ''                  // Segundo Apellido
       LOCAL cNomUno := ''                  // Primer Nombre
       LOCAL cNomDos := ''                  // Segundo Nombre
       LOCAL cDirecc := ''                  // Direccion de la Casa
       LOCAL cCiudad := ''                  // Ciudad de la Direcci¢n
       LOCAL cDepart := ''                  // Departamento de la Direcci¢n

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *ÀVariables de campo
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
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       IF !lUseDbf(.T.,cIntDos+'\'+;
		      'MATR'+cAnoUsr+ExtFile,'MTR',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
       cIntCua := ALLTRIM(MTR->cIntCuaAno)
       IF !EMPTY(cIntCua)
	  PathUno := cIntCua
	  cIntCua := cIntCua+'\'+cPatSis
	  cIntUno := cIntCua
       ENDIF
       CloseAll()
*>>>>FIN AREAS DE TRABAJO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntDos+'\'+FilePag,'PMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileTar,'TMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileCon,'CMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->nMesFinCaA == 0
	    cError('SE DEBE DEFINIR EL MES FINAL DE LA FACTURACION')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
      IF EMPTY(CAA->cConMatCaA)
	 cError('EN LA CONFIGURACION DEL A¥O SE HABILITAN',;
		'NO SE INCLUYE LA FACTURACION DE LAS MATRICULAS')
	 IF !lPregunta('DESEA CONTINUAR? No Si')
	    CloseAll(aUseDbf)
	    RETURN NIL
	 ENDIF
      ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')

       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,10 SAY 'PARA LOS MOROROS DE LA FACTURACION DE '+;
		   cMes(CAA->nMesFinCaA)+':(MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(dFecPrn)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := SUBS(SCA->cSerFacCar,1,1)+'tpa'+cAnoUsr
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ANALISIS DE DECISION
       IF nOpcPrn == 7 .OR. nOpcPrn == 8

	  SET DEVICE TO SCREEN
	  nOpcRep := nLeeOpcion('REPORTAR A: '+;
				'1<CONTRATANTE> '+;
				'2<PADRE> '+;
				'3<MADRE> '+;
				'4<TODOS> '+;
				'5<ABANDONAR>'+;
				'<?',5,'0')

	  IF EMPTY(nOpcRep) .OR. nOpcRep == 5
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
	  SET DEVICE TO PRINT

       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'TOTAL PAGOS POR ESTUDIANTES',;
		   '',;
		   ''}

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
       AADD(aTitPrn,'No.')

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'GRUPO')

       IF nOpcPrn == 7 .OR. nOpcPrn == 8

	  IF nOpcRep == 2 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 PADRE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS PADRE')

	  ENDIF
	*ÀInformaci¢n del padre

	  IF nOpcRep == 3 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 MADRE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS MADRE')

	  ENDIF
	*ÀInformaci¢n de la madre


	  IF nOpcRep == 1 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 CONTRATANTE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS CONTRATANTE')

	  ENDIF
	*ÀInformaci¢n del contratante

       ELSE

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'NOMBRE')

       ENDIF

       AADD(aNroCol,12)
       AADD(aTitPrn,'PAGADO')

       AADD(aNroCol,12)
       AADD(aTitPrn,'DEUDA')

       AADD(aNroCol,12)
       AADD(aTitPrn,'FACTURADO')

       AADD(aNroCol,12)
       AADD(aTitPrn,'PAGADO')

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

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

// cMaeAlu := 'BTO' // ojo

*>>>>RECORRIDO POR NIVELES
       SET DEVICE TO SCREEN
       nNroFil := nMarco(03,'ESTUDIANTES')

       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseDbf(.T.,cIntUno+'\'+cMaeAct+'\'+'GRU'+;
			 cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry)

		cError('ABRIENDO EL ARCHIVO GRUPOS DE '+cMaeAct)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     GRU->(DBGOTOP())

// lLocCodigo('cCodigoGru','GRU','1104')  // ojo

	     DO WHILE .NOT. GRU->(EOF())


*===============PREPARACION DE LAS VARIABLES DE ARCHIVOS
		  FileCli := cPatSis+'\CLIENTES\CL'+;
			     GRU->cCodigoGru+cAnoSis+ExtFile

		  FilePag := cPatSis+'\PAGOS\PA'+;
			     GRU->cCodigoGru+cAnoSis+ExtFile
*===============FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

*===============SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		     cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*===============FIN SELECION DE LAS AREAS DE TRABAJO

*===============RECORRIDO POR CLIENTES
		  CLI->(DBGOTOP())

*lLocCodigo('cCodigoEst','CLI','212005')  // ojo


		  DO WHILE .NOT. CLI->(EOF())

*--------------------IMPRESION DE LA LINEA DE ESTADO
		       LineaEstado('CODIGO: '+CLI->cCodigoEst+;
				   'ºGRUPO: '+GRU->cCodigoGru+;
				   'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
					   STR(CLI->(RECCOUNT()),2),cNomSis)
*--------------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		       IF CLI->lRetgruCli
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------------BUSQUEDA DEL ESTUDIANTE
		       cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
		       lHayAlu := lSekCodMae(CLI->cCodigoEst,;
					     cMaeAct,@cMaeAct)
*--------------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------------LOCALIZACION DEL PAGO
		       PAG->(DBSETFILTER())
		       IF !lLocCodigo('cCodigoEst','PAG',CLI->cCodigoEst)
			  lHayAlu := .F.
		       ENDIF
*--------------------FIN LOCALIZACION DEL PAGO

*--------------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		       lRetadoTes := .F.
		       cNombreTes := 'CODIGO:'+CLI->cCodigoEst+;
				     ' NO EXISTE'

		       IF lHayAlu
			  cCodigoTes := &cMaeAct->cCodigoEst
			  IF &cMaeAct->lRetiroEst
			     lRetadoTes := .T.
			  ENDIF
			  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
					&cMaeAct->cNombreEst
			  cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		       ENDIF
*--------------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------------LOCALIZACION RECIBO MATRICULA
		       SELECT PMT
		       LOCATE FOR PMT->cCodigoEst == cCodigoTes .AND.;
				  PMT->cMatricPag == '1'
*--------------------LOCALIZACION RECIBO MATRICULA

*--------------------TARIFAS DE MATRICULAS
		       nTotFac := 0
		       nTotPag := 0

		       aVlrCon := {}
		       nTotFac := 0
		       nVlrMtr := 0

		       IF PMT->(FOUND())
			  VlrTarMtr(PMT->cConcepPag,GRU->cCodigoGru,;
				    aVlrCon,.F.)
			  nVlrMtr := nSuma(aVlrCon,3)
			  nTotFac += nVlrMtr
		       ENDIF
*--------------------FIN TARIFAS DE MATRICULAS

*--------------------TARIFAS SERVICIOS EDUCATIVOS
		       IF lHayAlu
			  lVlrConAno(aVlrCon,.F.,cPatSis+'\'+fNtxDes)
			  SELECT PAG
			  SET FILTER TO
			  nVlrPag := nSuma(aVlrCon,3)

			  nTotPag += nVlrPag
		       ENDIF
*--------------------FIN TARIFAS SERVICIOS EDUCATIVOS

*--------------------TOTAL FACTURADO
		       IF lHayAlu
			  nVlrFac := nFacConAno(CLI->cCodigoEst)
			  nTotFac += nVlrFac
		       ENDIF
*--------------------FIN TOTAL FACTURADO

*--------------------GRABACION DEL TOTAL PAGADO
		       SELECT &cMaeAct
		       IF lHayAlu
			  IF lRegLock(lShared,.F.)

			     REPL &cMaeAct->nTotPagEst WITH nTotPag
			     REPL &cMaeAct->nTotFacEst WITH nTotFac

			  ELSE
			      cError('NO SE GRABA EL REGISTRO')
			  ENDIF

			  DBCOMMIT()
			  IF lShared
			     DBUNLOCK()
			  ENDIF

		       ENDIF
*--------------------FIN GRABACION DEL TOTAL PAGADO

*--------------------INFORMACION DEL PADRE Y MADRE
		       cDocPad := ''
		       cAp1Pad := ''
		       cAp2Pad := ''
		       cNo1Pad := ''
		       cNo2Pad := ''
		       cDirPad := ''
		       cCiuPad := ''
		       cDepPad := ''
		     *ÀInformaci¢n del padre

		       cDocMad := ''
		       cAp1Mad := ''
		       cAp2Mad := ''
		       cNo1Mad := ''
		       cNo2Mad := ''
		       cDirMad := ''
		       cCiuMad := ''
		       cDepMad := ''
		     *ÀInformaci¢n de la Madre

		       IF lHayAlu

			  cDocPad := ALLTRIM(&cMaeAct->cPadNitEst)

			  SepararNom(ALLTRIM(&cMaeAct->cApePadEst),;
				     @cAp1Pad,@cAp2Pad)              // Apellidos

			  SepararNom(ALLTRIM(&cMaeAct->cNomPadEst),;
				     @cNo1Pad,@cNo2Pad)              // Nombres

			  cDirPad := ALLTRIM(&cMaeAct->cDirPadEst)+' '+;
				     ALLTRIM(&cMaeAct->cBarPadEst)
			  cCiuPad := &cMaeAct->cCiuPadEst
			  cDepPad := SPACE(01)
			*ÀInformaci¢n del padre

			 cDocMad := ALLTRIM(&cMaeAct->cMadNitEst)

			 SepararNom(ALLTRIM(&cMaeAct->cApeMadEst),;
				    @cAp1Mad,@cAp2Mad)              // Apellidos

			 SepararNom(ALLTRIM(&cMaeAct->cNomMadEst),;
				    @cNo1Mad,@cNo2Mad)              // Nombres

			 cDirMad := ALLTRIM(&cMaeAct->cDirMadEst)+' '+;
				    ALLTRIM(&cMaeAct->cBarMadEst)
			 cCiuMad := &cMaeAct->cCiuMadEst

			 cDepMad := SPACE(01)
		       *ÀInformaci¢n de la Madre

		       ENDIF
*--------------------FIN INFORMACION DEL PADRE Y MADRE

*--------------------LOCALIZACION DE PRIMER CONTRATANTE
		       cDocNit := ''
		       cApeUno := ''
		       cApeDos := ''
		       cNomUno := ''
		       cNomDos := ''
		       cDirecc := ''
		       cCiudad := ''
		       cDepart := ''

		       DO CASE

		       CASE EMPTY(&cMaeAct->cNitCo1Est)

			    DO CASE
			    CASE !EMPTY(cDocPad)

				 cDocNit := cDocPad
				 cApeUno := cAp1Pad
				 cApeDos := cAp2Pad
				 cNomUno := cNo1Pad
				 cNomDos := cNo2Pad
				 cDirecc := cDirPad
				 cCiudad := cCiuPad
				 cDepart := cDepPad
			       *ÀPrimer contratante. Padre

			    CASE !EMPTY(cDocMad)

				 cDocNit := cDocMad
				 cApeUno := cAp1Mad
				 cApeDos := cAp2Mad
				 cNomUno := cNo1Mad
				 cNomDos := cNo2Mad
				 cDirecc := cDirMad
				 cCiudad := cCiuMad
				 cDepart := cDepMad
			       *ÀPrimer contratante. Madre

			    OTHERWISE
				 cApeUno := 'C:'+&cMaeAct->cNitCo1Est
				 cApeDos := 'P:'+cDocPad
				 cNomUno := 'M:'+cDocMad
			    ENDCASE


		       CASE ALLTRIM(&cMaeAct->cNitCo1Est) == ALLTRIM(cDocPad)

			    cDocNit := cDocPad
			    cApeUno := cAp1Pad
			    cApeDos := cAp2Pad
			    cNomUno := cNo1Pad
			    cNomDos := cNo2Pad
			    cDirecc := cDirPad
			    cCiudad := cCiuPad
			    cDepart := cDepPad
			  *ÀPrimer contratante. Padre

		       CASE ALLTRIM(&cMaeAct->cNitCo1Est) == ALLTRIM(cDocMad)

			    cDocNit := cDocMad
			    cApeUno := cAp1Mad
			    cApeDos := cAp2Mad
			    cNomUno := cNo1Mad
			    cNomDos := cNo2Mad
			    cDirecc := cDirMad
			    cCiudad := cCiuMad
			    cDepart := cDepMad
			  *ÀPrimer contratante. Madre

		       OTHERWISE

			   IF lLocNitPer(&cMaeAct->cNitCo1Est,;
					 &cMaeAct->cTipCo1Est)

			      cDocNit := PER->cDocNitPer
			      cApeUno := PER->cApeUnoPer
			      cApeDos := PER->cApeDosPer
			      cNomUno := PER->cNomUnoPer
			      cNomDos := PER->cNomDosPer
			      cDirecc := ALLTRIM(PER->cDireccPer)+' '+;
					 ALLTRIM(PER->cBarrioPer)
			      cCiudad := PER->cCiudadPer
			      cDepart := SPACE(01)

			   ELSE

			      cApeUno := 'C:'+&cMaeAct->cNitCo1Est
			      cApeDos := 'P:'+cDocPad
			      cNomUno := 'M:'+cDocMad

			   ENDIF

		       ENDCASE
*--------------------FIN LOCALIZACION DE PRIMER CONTRATANTE

*--------------------ACTIVACION DEL INDICE
		       SELECT DES
*                      SET FILTER TO // Falta analizar si se requiere
		       IF lShared
			  DBSETINDEX(cPatSis+'\'+fNtxDes)
		       ELSE
			  SET INDEX TO (cPatSis+'\'+fNtxDes)
		       ENDIF
*--------------------FIN ACTIVACION DEL INDICE

*--------------------CALCULO DEL SALDO ACTUAL
		       lPrnFec := .T.

		       nSdoAct := nSdoActEst(CLI->cCodigoEst,lRetadoTes,;
					     cMaeAlu,CAA->nMesFinCaA,;
					     lPrnFec,dFecPrn)
*--------------------FIN CALCULO DEL SALDO ACTUAL

*--------------------IMPRESION DEL REGISTRO
		       IF lHayAlu

			  nNroAlu++
			  aRegPrn := {}

			  AADD(aRegPrn,STR(nNroAlu,6))    // 1
			  AADD(aRegPrn,CLI->cCodigoEst)   // 2
			  AADD(aRegPrn,GRU->cCodigoGru)   // 3

			  IF nOpcPrn == 7 .OR. nOpcPrn == 8

			     IF nOpcRep == 2 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocPad)
				AADD(aRegPrn,cAp1Pad)
				AADD(aRegPrn,cAp2Pad)
				AADD(aRegPrn,cNo1Pad)
				AADD(aRegPrn,cNo2Pad)
				AADD(aRegPrn,cDirPad)
				AADD(aRegPrn,cCiuPad)
				AADD(aRegPrn,cDepPad)
				AADD(aRegPrn,SPACE(01)) // Pais
			     ENDIF
			   *ÀInformaci¢n del padre

			     IF nOpcRep == 3 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocMad)
				AADD(aRegPrn,cAp1Mad)
				AADD(aRegPrn,cAp2Mad)
				AADD(aRegPrn,cNo1Mad)
				AADD(aRegPrn,cNo2Mad)
				AADD(aRegPrn,cDirMad)
				AADD(aRegPrn,cCiuMad)
				AADD(aRegPrn,cDepMad)
				AADD(aRegPrn,SPACE(01)) // Pais
			     ENDIF
			   *ÀInformaci¢n de la madre

			     IF nOpcRep == 1 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocNit)   // 4
				AADD(aRegPrn,cApeUno)   // 5
				AADD(aRegPrn,cApeDos)   // 6
				AADD(aRegPrn,cNomUno)   // 7
				AADD(aRegPrn,cNomDos)   // 8
				AADD(aRegPrn,cDirecc)   // 9
				AADD(aRegPrn,cCiudad)   // 10
				AADD(aRegPrn,cDepart)   // 11
				AADD(aRegPrn,SPACE(01)) // 12 Pais
			     ENDIF
			   *ÀInformaci¢n primer contratante

			  ELSE

			     AADD(aRegPrn,cNombreTes)

			  ENDIF
			  IF nTotFac > nTotPag
			     AADD(aRegPrn,TRANS(nTotFac,"##########")) // 13
			  ELSE
			     AADD(aRegPrn,TRANS(nTotPag,"##########")) // 13
			  ENDIF

			  AADD(aRegPrn,TRANS(nSdoAct,"##########")) // 14

			  AADD(aRegPrn,TRANS(nTotFac,"##########")) // 15
			  AADD(aRegPrn,TRANS(nTotPag,"##########")) // 16

			  SET DEVICE TO PRINT
			  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
				  bCabeza)
			  SET DEVICE TO SCREEN

		       ENDIF
*--------------------FIN IMPRESION DEL REGISTRO

*--------------------VISUALIZACION
		       @ nNroFil,01 SAY 'GRUPO: '+GRU->cCodigoGru+' '+;
					cNombreTes+' TOTAL $'+;
					TRANS(nTotPag,"##########")
		       nNroFil++
		       IF nNroFil == 21
			  nNroFil := nMarco(03,'ESTUDIANTES')
		       ENDIF
*--------------------FIN VISUALIZACION

		     CLI->(DBSKIP())

		  ENDDO
*===============FIN RECORRIDO POR CLIENTES

		GRU->(DBSKIP())

*EXIT

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

       ENDFOR
*>>>>FIN RECORRIDO POR NIVELES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: FACTURACION DEL A¥O                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 06:15 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Descrimina todos los Conceptos del A¤o

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nFacConAno(cCodEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegPag := 0                   // Registro de Pagos
       LOCAL nFacAno := 0                   // Facturaci¢n del A¤o
       LOCAL aVlrCon := {}                  // Valor de los conceptos
       LOCAL aAntici[16]                    // Anticipos. 8 Conceptos
       LOCAL aAntEst := {}                  // Anticipos del Estudiante
       LOCAL nAntici := 0                   // Anticipos de los Estudiantes
       LOCAL nVlrMes := 0                   // Valor del Mes
*>>>>FIN DECLARACION DE VARIABLES

       AFILL(aAntici,0)

*>>>>FILTRACION DE LOS PAGOS
       SELECT PAG
       nRegPag := PAG->(RECNO())
       SET FILTER TO PAG->cCodigoEst == cCodEst
       PAG->(DBGOTOP())
       IF PAG->(EOF())
	  SET FILTER TO
	  RETURN nFacAno
       ENDIF
*>>>>FIN FILTRACION DE LOS PAGOS

*>>>>RECORRIDO DEL ARCHIVO
       SELECT PAG
       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

**********FACTURACION DEL MES
	    aVlrCon := {}
	    nVlrMes := nVlrMes(@aVlrCon)
	    nFacAno += nVlrMes
**********FIN FACTURACION DEL MES

**********ANTICIPOS DEL MES
	    IF (PAG->nMesIniPag # PAG->nMesFinPag .OR.;
		lHayAntici(PAG->nMesIniPag,PAG->cIniFinPag)) .AND.;
		(PAG->cEstadoPag = 'P' .OR. PAG->cEstadoPag = 'A') .AND.;
		!EMPTY(PAG->dFecPagPag)

		IF CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses

		   aAntEst := AnticiVar(GRU->cCodigoGru,;
					aVlrCon,;
					PAG->nMesIniPag+1,;
					PAG->nMesFinPag,;
					aAntici,;
					PAG->cIniFinPag,;
					PAG->cConcepPag,;
					PAG->cConcepPag)

		ELSE
		   aAntEst := Anticipos(aVlrCon,;
					(nNroMesFac(PAG->nMesIniPag,;
					 PAG->nMesFinPag)-1),aAntici,;
					PAG->cIniFinPag,PAG->cConcepPag,;
					PAG->cConcepPag)
	       ENDIF

	       nAntici := nSuma(aAntEst)
	       nFacAno += nAntici

	    ENDIF
**********FIN ANTICIPOS DEL MES

	  PAG->(DBSKIP())

       ENDDO
       SET FILTER TO
       PAG->(DBGOTO(nRegPag))
       RETURN nFacAno
*>>>>FIN RECORRIDO DEL ARCHIVO

/*************************************************************************
* NOMBRE ..: PAGOS POR CONCEPTOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2005 MIE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   ABR 20/2005 MIE

OBJETIVOS:

1- Descrimina lo total pagado


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_482(aParam1,aParam2,aParam3)

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
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL nVlrMtr := 0                   // Valor de la Matricula
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL nTotFac := 0                   // Total Facturado
       LOCAL nTotPag := 0                   // Valor Pagado

       LOCAL cCampos := ''                  // Campo
       LOCAL cCampo1 := ''                  // Campo
       LOCAL cCampo2 := ''                  // Campo
       LOCAL aDbfStr := {}                  // Valor Por Conceptos


       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
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
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathPrn+'\TotPagos.dbf','DN1',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN FIN AREAS DE TRABAJO

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
       CASE EMPTY(CAA->cConMatCaA)
	    cError('NO SE HAN DEFINIDO LOS CODIGOS DE LOS CONCEPTOS PARA EL CERTIFICADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CREACION DE LA ESTRUCUTURA
       aDbfStr := DN1->(DBSTRUCT())

       FOR i := 1 TO LEN(ALLTRIM(CAA->cConMatCaA))/2

	   cCodigoTco := SUBS(ALLTRIM(CAA->cConMatCaA),i*2-1,2)
	      cCampos := 'cVlr'+cCodigoTco

	   AADD(aDbfStr,{cCampos,'Character',12,0})

       ENDFOR

       cCampos := 'cVlr'+'INT'
       AADD(aDbfStr,{cCampos,'Character',12,0})

       DBCREATE(PathPrn+'\DIAN.DBF',aDbfStr,"DBFNTX")

       aDbfStr := DN1->(DBSTRUCT())
       CloseAll(aUseDbf)
*>>>>FIN CREACION DE LA ESTRUCUTURA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathPrn+'\TotPagos.dbf','DN1',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathPrn+'\DIAN.DBF','DN2',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntDos+'\'+FilePag,'PMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileTar,'TMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileCon,'CMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->nMesFinCaA == 0
	    cError('SE DEBE DEFINIR EL MES FINAL DE LA FACTURACION')

       CASE DN1->(RECCOUNT()) == 0
	    cError('EL ARCHIVO DIAN1 NO CONTIENE REGISTROS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO DE REGISTROS
       SELECT DN1
       DN1->(DBGOTOP())
       DO WHILE .NOT. DN1->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('REGISTROS:'+DN1->(STR(RECNO(),4))+'/'+;
				     DN1->(STR(RECCOUNT(),4))+;
			'ºCodigo:'+DN1->cCampo2,cNomSis)
**********FIN LINEA DE ESTADO

**********TOTAL FACTURADO
//                  Facturado           Pagado
	    IF VAL(DN1->cCampo15) > VAL(DN1->cCampo16)
	       nTotFac := VAL(DN1->cCampo15)
	    ELSE
	       nTotFac := VAL(DN1->cCampo16)
	    ENDIF
	    nTotPag := nTotFac
**********FIN TOTAL FACTURADO

**********LOCALIZACION RECIBO MATRICULA
	    cCodigoTes := ALLTRIM(DN1->cCampo2)
	    cCodigoTgr := ALLTRIM(DN1->cCampo3)

	    SELECT PMT
	    LOCATE FOR PMT->cCodigoEst == cCodigoTes .AND.;
		       PMT->cMatricPag == '1'
**********FIN LOCALIZACION RECIBO MATRICULA

**********TARIFAS DE LAS MATRICULAS
	    aVlrCon := {}
	    IF !EMPTY(CAA->cConMatCaA)

	       VlrTarMtr(PMT->cConcepPag,cCodigoTgr,aVlrCon,.F.)

	       nVlrMtr := nSuma(aVlrCon,3)

	       nTotPag -= nVlrMtr

	    ENDIF
**********FIN TARIFAS DE LAS MATRICULAS

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       cCodigoTgr+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE PAGOS')
	       DN1->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO DEL PAGO
	    IF !lLocCodPag(cCodigoTes,nMesUltPag(cCodigoTes,.F.))
	       cError('NO SE HA LOCALIZADO EL PAGO')
	       DN1->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO DEL PAGO

**********DESCRIMINACION DEL PAGO
	    IF nTotPag > 0
	       lVlrConPag(nTotPag,aVlrCon)
	    ENDIF
**********FIN DESCRIMINACION DEL PAGO

**********GRABACION DEL REGISTRO
	    IF DN2->(lRegLock(lShared,.T.))

	       FOR i := 1 TO LEN(aDbfStr)

		   cCampos := aDbfStr[i,1]
		   cCampo1 := 'DN1->'+cCampos
		   cCampo2 := 'DN2->'+cCampos

		   REPL &cCampo2 WITH &cCampo1

	       ENDFOR

*	       IF nTotFac == nSuma(aVlrCon,3)

		  FOR i := 1 TO LEN(aVlrCon)
		      cCampos := 'DN2->cVlr'+aVlrCon[i,1]
		      REPL &cCampos WITH STR(aVlrCon[i,3],12)
		  ENDFOR

*	       ENDIF

	       DN2->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       DN2->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  DN1->(DBSKIP())
	*ÀAvance del registro

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE REGISTROS

/*************************************************************************
* TITULO..: DISCRIMINACION CONCEPTOS DEL PAGO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 10/2003 VIE A
       Bucaramanga, Colombia        INICIO: 07:00 PM   OCT 10/2003 VIE

OBJETIVOS:

1- Permite descriminar los pagos realizados

2- El registro del pago debe estar ubicado en el £ltimo recibo

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lVlrConPag(nTotPag,aVlrCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     nTotPag			          // @Valor de la Deuda
       aVlrCon                            // Valor de los Conceptos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL     i,k := 0                   // Contador
       LOCAL nSdoAnt := 0                   // Saldo Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior
       LOCAL nVlrMes := 0                   // Valor del Mes
       LOCAL nIntMes := 0                   // Valor Intereses del Mes
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL aRegPag := {}                  // Registro de Pagos
       LOCAL nVlrRec := 0                   // Valor Recargos
       LOCAL nMesRec := 0                   // Mes del Recargo
       LOCAL nRegDes := 0                   // Registro del Descuento
       LOCAL nVlrPag := 0                   // Valor Pagado
*>>>>FIN DECLARACION DE VARIABLES


*>>>>DESCRIMINACION TOTAL PAGADO
       nVlrPag := nTotPag
       nRegAct := PAG->(RECNO())

       IF nVlrPag # 0

**********LECTURA DE LOS REGISTROS DE PAGOS
	    aRegPag := aRegPagos(PAG->cCodigoEst)

	    IF EMPTY(aRegPag)
	       RETURN lHayErr
	    ENDIF
**********FIN LECTURA DE LOS REGISTROS DE PAGOS

**********RECORRIDO DE PAGOS
	    FOR k := 1 TO LEN(aRegPag)

		PAG->(DBGOTO(aRegPag[k]))

*===============INTERESES
		  IF nVlrPag > 0

		     IF (PAG->cEstadoPag == 'D' .OR.;
			 PAG->cEstadoPag == 'A')

			nIntMes := nVlrIntPag(CAA->lIntPenCaA,;
					      PAG->nMesIniPag,;
					      CAA->nMesAmnCaA)

			IF nIntMes # 0

			   VlrCon('INT',;
				  SUBS('INTERESES'+SPACE(16),1,16),;
				  nIntMes,;
				  aVlrCon)

			   nVlrPag -= nIntMes

			ENDIF
		     ENDIF

		  ENDIF
*===============FIN INTERESES

*===============ANALISIS DEL RECARGO
		  IF nVlrPag > 0

		     nMesRec := PAG->nMesIniPag
		     nVlrRec := PAG->nVlrRecPag

		     nVlrPag -= nVlrRec

		   ENDIF
*===============FIN ANALISIS DEL RECARGO

*===============DESCRIPCION DEL PAGO
		  IF nVlrPag > 0
		     ConVlrPag(@nVlrPag,aVlrCon)
		  ENDIF
*===============FIN DESCRIPCION DEL PAGO

*===============DESCRIMINACION DEL RECARGO
		  IF nVlrRec # 0

		     nRegDes := DES->(RECNO())
		     IF (lSekCodDes(PAG->cCodigoEst,nMesRec,.F.) .AND.;
				     DES->nTipDesDes == 2) .AND.;
				     DES->nValorDes == nVlrRec     // Recargo
			VlrConDes(nVlrRec,aVlrCon)
		     ELSE
			VlrCon('REC',;
			       SUBS('ERROR EN RECARGO'+SPACE(16),1,16),;
			       nVlrRec,;
			       aVlrCon)
		     ENDIF
		     DES->(DBGOTO(nRegDes))

		  ENDIF
*===============FIN DESCRIMINACION DEL RECARGO

	    ENDFOR
	    nTotPag := nVlrPag
**********FIN RECORRIDO DE PAGOS

       ENDIF
       PAG->(DBGOTO(nRegAct))

       RETURN !lHayErr
*>>>>FIN DESCRIMINACION TOTAL PAGADO

/*************************************************************************
* TITULO..: DISCRIMINACION CONCEPTOS DEL DEL MES                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/2003 VIE A
       Bucaramanga, Colombia        INICIO: 01:06 PM   SEP 05/2003 VIE

OBJETIVOS:

1- Descrimina el valor de los conceptos facturados del mes de acuerdo
   al valor especificado.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ConVlrPag(nVlrDiv,aVlrCon,lSiCert)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDiv                              // @Valor a Discriminar
       aVlrCon                              // @Valor de los Conceptos
       lSiCert                              // .T. Si Certificado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIMINACION DEL VALOR
       lSiCert := IF(lSiCert==NIL,.F.,lSiCert)
       FOR i := 1 TO LEN(ALLTRIM(PAG->cConcepPag))/2

***********LOCALIZACION DEL CONCEPTO
	     cCodigoTco := SUBS(PAG->cConcepPag,i*2-1,2)

	     lLocCodigo('cCodigoCon','CON',cCodigoTco)

	     nVlrCon := nVlrConPag(cCodigoTco,'PAG')
	    *Valor del Concepto
***********FIN LOCALIZACION DEL CONCEPTO

***********ANALISIS DEL PAGO ANTICIPADO
	     IF PAG->nMesIniPag # PAG->nMesFinPag
		nVlrCon += nVlrCon * (PAG->nMesFinPag-PAG->nMesIniPag)
	     ELSE
		IF lHayAntici(PAG->nMesIniPag,PAG->cIniFinPag)
		   nMesIni := 0
		   nMesFin := 0
		   cIniFinPag(i,PAG->cIniFinPag,@nMesIni,@nMesFin)
		   nVlrCon += nVlrCon * (nMesFin-nMesIni)
		ENDIF
	     ENDIF
***********FIN ANALISIS DEL PAGO ANTICIPADO

***********DESCUENTO DE LA BECA
	     IF PAG->nVlrBecPag # 0 .AND. 'PENSION' $ CON->cNombreCon
		nVlrCon -= PAG->nVlrBecPag
	     ENDIF
***********FIN DESCUENTO DE LA BECA

***********SUMA DEL CONCEPTO DESCRIMINADO
	     IF nVlrCon # 0

*---------------RESTA DEL VALOR DESCRIMINADO
		  IF nVlrCon <= nVlrDiv
		     nVlrDiv -= nVlrCon
		  ELSE
		     nVlrCon := nVlrDiv
		     nVlrDiv := 0
		  ENDIF
*---------------FIN RESTA DEL VALOR DESCRIMINADO


*---------------SUMA DEL CONCEPTO DESCRIMINADO
		  IF lSiCert
		     IF CON->lSiCertCon

			VlrCon(IF(EMPTY(CON->cCodCerCon),;
				  cCodigoTco,CON->cCodCerCon),;
			       IF(EMPTY(CON->cNomCerCon),;
				  CON->cNombreCon,CON->cNomCerCon),;
			       nVlrCon,aVlrCon)
		     ENDIF
		  ELSE
		     VlrCon(cCodigoTco,CON->cNombreCon,nVlrCon,aVlrCon)
		  ENDIF
*---------------FIN SUMA DEL CONCEPTO DESCRIMINADO

	     ENDIF
***********FIN SUMA DEL CONCEPTO DESCRIMINADO

***********ANALISIS DE DECISION
	     IF nVlrDiv == 0
		EXIT
	     ENDIF
***********FIN ANALISIS DE DECISION

       ENDFOR
       RETURN NIL
*>>>>FIN DESCRIMINACION DEL VALOR

/*************************************************************************
* NOMBRE ..: INICIALIZACION DE LOS TOTALES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 31/2016 JUE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   MAR 31/2016 JUE

OBJETIVOS:

1- Imprime una relaci¢n detallada de facilitar los reportes de acuerdo
   al total de la facturaci¢n y pagos por meses

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_484(aParam1,aParam2,aParam3)

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
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

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
       LOCAL nNroAlu := 0                   // N£mero de Estudiantes
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL nVlrMtr := 0                   // Valor de la matr¡cula
       LOCAL nVlrFac := 0                   // Valor de la facturaci¢n
       LOCAL nVlrPag := 0                   // Valor de los pagos
       LOCAL nTotPag := 0                   // Valor temporal
       LOCAL nTotFac := 0                   // Total Facturado

       LOCAL nOpcRep := 0                   // Opci¢n del Reporte
       LOCAL lHayAlu := .F.                 // .T. Existe el Estudiante
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n
       LOCAL nSdoAct := 0                   // Saldo Actual

       LOCAL cDocPad := ''                  // N£mero del Documento
       LOCAL cAp1Pad := ''                  // Primer apellido
       LOCAL cAp2Pad := ''                  // Segundo apellido
       LOCAL cNo1Pad := ''                  // Primer Nombre
       LOCAL cNo2Pad := ''                  // Segundo Nombre
       LOCAL cDirPad := ''                  // Direccion del Padre
       LOCAL cCiuPad := ''                  // Ciudad del Padre
       LOCAL cDepPad := ''                  // Departamento del Padre

       LOCAL cDocMad := ''                  // N£mero del Documento
       LOCAL cAp1Mad := ''                  // Primer apellido
       LOCAL cAp2Mad := ''                  // Segundo apellido
       LOCAL cNo1Mad := ''                  // Primer Nombre
       LOCAL cNo2Mad := ''                  // Segundo Nombre
       LOCAL cDirMad := ''                  // Direccion de la Madre
       LOCAL cCiuMad := ''                  // Ciudad de la Madre
       LOCAL cDepMad := ''                  // Departamento de la Madre

       LOCAL cDocNit := ''                  // Documento de Identidad
       LOCAL cApeUno := ''                  // Primer Apellido
       LOCAL cApeDos := ''                  // Segundo Apellido
       LOCAL cNomUno := ''                  // Primer Nombre
       LOCAL cNomDos := ''                  // Segundo Nombre
       LOCAL cDirecc := ''                  // Direccion de la Casa
       LOCAL cCiudad := ''                  // Ciudad de la Direcci¢n
       LOCAL cDepart := ''                  // Departamento de la Direcci¢n

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *ÀVariables de campo
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
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       IF !lUseDbf(.T.,cIntDos+'\'+;
		      'MATR'+cAnoUsr+ExtFile,'MTR',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
       cIntCua := ALLTRIM(MTR->cIntCuaAno)
       IF !EMPTY(cIntCua)
	  PathUno := cIntCua
	  cIntCua := cIntCua+'\'+cPatSis
	  cIntUno := cIntCua
       ENDIF
       CloseAll()
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
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

*>>>>RECORRIDO POR NIVELES
       nNroFil := nMarco(03,'ESTUDIANTES')
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis,.F.)
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********RECORRIDO POR ALUMNOS
	     SELECT &cMaeAct
	     DBGOTOP()
	     DO WHILE .NOT. EOF()

		SELECT &cMaeAct

*===============LINEA DE ESTADO
		  LineaEstado(cMaeAct+':'+STR(RECNO(),4)+'/'+;
					  STR(RECCOUNT(),4)+;
			      'ºCODIGO:'+&cMaeAct->cCodigoEst,cNomSis)
*===============FIN LINEA DE ESTADO

*===============INICIALIZACION DE LOS TOTALES
		  IF lRegLock(lShared,.F.)

		     REPL &cMaeAct->nTotPagEst WITH 0
		     REPL &cMaeAct->nTotFacEst WITH 0

		  ELSE
		      cError('NO SE GRABA EL REGISTRO')
		  ENDIF

		  DBCOMMIT()
		  IF lShared
		     DBUNLOCK()
		  ENDIF
*===============FIN INICIALIZACION DE LOS TOTALES

		SELECT &cMaeAct
		DBSKIP()

	     ENDDO
***********FIN RECORRIDO POR ALUMNOS

       ENDFOR
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO POR NIVELES

/*************************************************************************
* NOMBRE ..: FACTURACION Y PAGOS POR MESES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 31/2016 JUE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   MAR 31/2016 JUE

OBJETIVOS:

1- Imprime una relaci¢n detallada de facilitar los reportes de acuerdo
   al total de la facturaci¢n y pagos por meses

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_483(aParam1,aParam2,aParam3)

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
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

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
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL cMesFin := ''                  // Mes Final
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroAlu := 0                   // N£mero de Estudiantes
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL nVlrMtr := 0                   // Valor de la matr¡cula
       LOCAL nVlrFac := 0                   // Valor de la facturaci¢n
       LOCAL nVlrPag := 0                   // Valor de los pagos
       LOCAL nTotPag := 0                   // Valor temporal
       LOCAL nTotFac := 0                   // Total Facturado
       LOCAL nVlrIca := 0                   // Valor impuesto Ica.
       LOCAL nTotIca := 0                   // Total Impuesto Ica.

       LOCAL nOpcRep := 0                   // Opci¢n del Reporte
       LOCAL lHayAlu := .F.                 // .T. Existe el Estudiante
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL nSdoAct := 0                   // Saldo Actual

       LOCAL cDocPad := ''                  // N£mero del Documento
       LOCAL cAp1Pad := ''                  // Primer apellido
       LOCAL cAp2Pad := ''                  // Segundo apellido
       LOCAL cNo1Pad := ''                  // Primer Nombre
       LOCAL cNo2Pad := ''                  // Segundo Nombre
       LOCAL cDirPad := ''                  // Direccion del Padre
       LOCAL cCiuPad := ''                  // Ciudad del Padre
       LOCAL cDepPad := ''                  // Departamento del Padre

       LOCAL cDocMad := ''                  // N£mero del Documento
       LOCAL cAp1Mad := ''                  // Primer apellido
       LOCAL cAp2Mad := ''                  // Segundo apellido
       LOCAL cNo1Mad := ''                  // Primer Nombre
       LOCAL cNo2Mad := ''                  // Segundo Nombre
       LOCAL cDirMad := ''                  // Direccion de la Madre
       LOCAL cCiuMad := ''                  // Ciudad de la Madre
       LOCAL cDepMad := ''                  // Departamento de la Madre

       LOCAL cDocNit := ''                  // Documento de Identidad
       LOCAL cApeUno := ''                  // Primer Apellido
       LOCAL cApeDos := ''                  // Segundo Apellido
       LOCAL cNomUno := ''                  // Primer Nombre
       LOCAL cNomDos := ''                  // Segundo Nombre
       LOCAL cDirecc := ''                  // Direccion de la Casa
       LOCAL cCiudad := ''                  // Ciudad de la Direcci¢n
       LOCAL cDepart := ''                  // Departamento de la Direcci¢n

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL nMesFinTpa := 0                // Mes Final del pago
     *ÀVariables de campo
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
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       IF !lUseDbf(.T.,cIntDos+'\'+;
		      'MATR'+cAnoUsr+ExtFile,'MTR',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
       cIntCua := ALLTRIM(MTR->cIntCuaAno)
       IF !EMPTY(cIntCua)
	  PathUno := cIntCua
	  cIntCua := cIntCua+'\'+cPatSis
	  cIntUno := cIntCua
       ENDIF
       CloseAll()
*>>>>FIN AREAS DE TRABAJO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntDos+'\'+FilePag,'PMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileTar,'TMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileCon,'CMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->nMesFinCaA == 0
	    cError('SE DEBE DEFINIR EL MES FINAL DE LA FACTURACION')

       CASE CAA->nImpIcaCaA == 0
	    cError('NO SE HA DEFINIDO EL PORCENTAJE DEL IMPUESTO ICA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS MESES A FACTURAR
       nMesIniTpa := 0 ; nMesFinTpa := 0
       MesIniFin(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
		 @nMesIniTpa,@nMesFinTpa)

       IF nMesIniTpa == 0 .OR. nMesFinTpa == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       cMesIni := STR(nMesIniTpa,2)
       lCorrecion(@cMesIni)

       cMesFin := STR(nMesFinTpa,2)
       lCorrecion(@cMesFin)
*>>>>FIN CAPTURA DE LOS MESES A FACTURAR

*>>>>ANALISIS DE DECISION
       IF !lPregunta('IMPUESTO ICA:'+STR(CAA->nImpIcaCaA,5,2)+;
		     '% .DESEA CONTINUAR? No Si')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := SUBS(SCA->cSerFacCar,1,1)+'t'+;
		     cMesIni+cMesFin+;
		     SUBS(cAnoUsr,3,2)
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ANALISIS DE DECISION
       IF nOpcPrn == 7 .OR. nOpcPrn == 8

	  SET DEVICE TO SCREEN
	  nOpcRep := nLeeOpcion('REPORTAR A: '+;
				'1<CONTRATANTE> '+;
				'2<PADRE> '+;
				'3<MADRE> '+;
				'4<TODOS> '+;
				'5<ABANDONAR>'+;
				'<?',5,'0')

	  IF EMPTY(nOpcRep) .OR. nOpcRep == 5
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
	  SET DEVICE TO PRINT

       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'IMPUESTO ICA:'+STR(CAA->nImpIcaCaA,5,2)+'%',;
		   'A¥O:'+cAnoUsr,;
		   'MESES:'+cMes(nMesIniTpa,3)+' A '+cMes(nMesIniTpa,3)}

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
       AADD(aTitPrn,'No.')

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'GRUPO')

       IF nOpcPrn == 7 .OR. nOpcPrn == 8

	  IF nOpcRep == 2 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 PADRE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS PADRE')

	  ENDIF
	*ÀInformaci¢n del padre

	  IF nOpcRep == 3 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 MADRE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS MADRE')

	  ENDIF
	*ÀInformaci¢n de la madre


	  IF nOpcRep == 1 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 CONTRATANTE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS CONTRATANTE')

	  ENDIF
	*ÀInformaci¢n del contratante

       ELSE

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'NOMBRE')

       ENDIF

       AADD(aNroCol,12)
       AADD(aTitPrn,'PAGADO')

       AADD(aNroCol,12)
       AADD(aTitPrn,'IMP ICA')

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

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*cMaeAlu := 'BTO' // ojo

*>>>>RECORRIDO POR NIVELES
       SET DEVICE TO SCREEN
       nNroFil := nMarco(03,'A¥O:'+cAnoUsr+;
			    '.IMPUESTO ICA:'+STR(CAA->nImpIcaCaA,5,2)+'%'+;
			    '.MESES:'+cMes(nMesIniTpa,3)+' A '+;
				      cMes(nMesIniTpa,3))

       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseDbf(.T.,cIntUno+'\'+cMaeAct+'\'+'GRU'+;
			 cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry)

		cError('ABRIENDO EL ARCHIVO GRUPOS DE '+cMaeAct)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     GRU->(DBGOTOP())

*lLocCodigo('cCodigoGru','GRU','1104')  // ojo

	     DO WHILE .NOT. GRU->(EOF())


*===============PREPARACION DE LAS VARIABLES DE ARCHIVOS
		  FileCli := cPatSis+'\CLIENTES\CL'+;
			     GRU->cCodigoGru+cAnoSis+ExtFile

		  FilePag := cPatSis+'\PAGOS\PA'+;
			     GRU->cCodigoGru+cAnoSis+ExtFile
*===============FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

*===============SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		     cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*===============FIN SELECION DE LAS AREAS DE TRABAJO

*===============RECORRIDO POR CLIENTES
		  CLI->(DBGOTOP())

*lLocCodigo('cCodigoEst','CLI','212158')  // ojo


		  DO WHILE .NOT. CLI->(EOF())

*--------------------IMPRESION DE LA LINEA DE ESTADO
		       LineaEstado('CODIGO: '+CLI->cCodigoEst+;
				   'ºGRUPO: '+GRU->cCodigoGru+;
				   'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
					   STR(CLI->(RECCOUNT()),2),cNomSis)
*--------------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		       IF CLI->lRetgruCli
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------------BUSQUEDA DEL ESTUDIANTE
		       cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
		       lHayAlu := lSekCodMae(CLI->cCodigoEst,;
					     cMaeAct,@cMaeAct)
*--------------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------------LOCALIZACION DEL PAGO
		       PAG->(DBSETFILTER())
		       IF !lLocCodigo('cCodigoEst','PAG',CLI->cCodigoEst)
			  lHayAlu := .F.
		       ENDIF
*--------------------FIN LOCALIZACION DEL PAGO

*--------------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		       lRetadoTes := .F.
		       cNombreTes := 'CODIGO:'+CLI->cCodigoEst+;
				     ' NO EXISTE'

		       IF lHayAlu
			  cCodigoTes := &cMaeAct->cCodigoEst
			  IF &cMaeAct->lRetiroEst
			     lRetadoTes := .T.
			  ENDIF
			  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
					&cMaeAct->cNombreEst
			  cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		       ENDIF
*--------------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------------TARIFAS DE MATRICULAS
		       nTotFac := 0
		       nTotPag := 0

		       aVlrCon := {}
		       nTotFac := 0
		       nVlrMtr := 0
*--------------------FIN TARIFAS DE MATRICULAS

*--------------------TARIFAS SERVICIOS EDUCATIVOS
		       IF lHayAlu
			  lVlrConMes(aVlrCon,.F.,cPatSis+'\'+fNtxDes,;
				     nMesIniTpa,nMesFinTpa)
			  SELECT PAG
			  SET FILTER TO
			  nVlrPag := nSuma(aVlrCon,3)

			  nTotPag += nVlrPag
		       ENDIF
*--------------------FIN TARIFAS SERVICIOS EDUCATIVOS

*--------------------ANALISIS DECISION
		       IF nTotPag == 0
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS DECISION

*--------------------TOTAL FACTURADO
		       IF lHayAlu
			  nVlrFac := nFacConMes(CLI->cCodigoEst,;
						nMesIniTpa,nMesFinTpa)
			  nTotFac += nVlrFac
		       ENDIF
*--------------------FIN TOTAL FACTURADO

*--------------------GRABACION DEL TOTAL PAGADO
		       SELECT &cMaeAct
		       IF lHayAlu
			  IF lRegLock(lShared,.F.)

			     REPL &cMaeAct->nTotPagEst WITH nTotPag
			     REPL &cMaeAct->nTotFacEst WITH nTotFac

			  ELSE
			      cError('NO SE GRABA EL REGISTRO')
			  ENDIF

			  DBCOMMIT()
			  IF lShared
			     DBUNLOCK()
			  ENDIF

		       ENDIF
*--------------------FIN GRABACION DEL TOTAL PAGADO

*--------------------INFORMACION DEL PADRE Y MADRE
		       cDocPad := ''
		       cAp1Pad := ''
		       cAp2Pad := ''
		       cNo1Pad := ''
		       cNo2Pad := ''
		       cDirPad := ''
		       cCiuPad := ''
		       cDepPad := ''
		     *ÀInformaci¢n del padre

		       cDocMad := ''
		       cAp1Mad := ''
		       cAp2Mad := ''
		       cNo1Mad := ''
		       cNo2Mad := ''
		       cDirMad := ''
		       cCiuMad := ''
		       cDepMad := ''
		     *ÀInformaci¢n de la Madre

		       IF lHayAlu

			  cDocPad := ALLTRIM(&cMaeAct->cPadNitEst)

			  SepararNom(ALLTRIM(&cMaeAct->cApePadEst),;
				     @cAp1Pad,@cAp2Pad)              // Apellidos

			  SepararNom(ALLTRIM(&cMaeAct->cNomPadEst),;
				     @cNo1Pad,@cNo2Pad)              // Nombres

			  cDirPad := ALLTRIM(&cMaeAct->cDirPadEst)+' '+;
				     ALLTRIM(&cMaeAct->cBarPadEst)
			  cCiuPad := &cMaeAct->cCiuPadEst
			  cDepPad := SPACE(01)
			*ÀInformaci¢n del padre

			 cDocMad := ALLTRIM(&cMaeAct->cMadNitEst)

			 SepararNom(ALLTRIM(&cMaeAct->cApeMadEst),;
				    @cAp1Mad,@cAp2Mad)              // Apellidos

			 SepararNom(ALLTRIM(&cMaeAct->cNomMadEst),;
				    @cNo1Mad,@cNo2Mad)              // Nombres

			 cDirMad := ALLTRIM(&cMaeAct->cDirMadEst)+' '+;
				    ALLTRIM(&cMaeAct->cBarMadEst)
			 cCiuMad := &cMaeAct->cCiuMadEst

			 cDepMad := SPACE(01)
		       *ÀInformaci¢n de la Madre

		       ENDIF
*--------------------FIN INFORMACION DEL PADRE Y MADRE

*--------------------LOCALIZACION DE PRIMER CONTRATANTE
		       cDocNit := ''
		       cApeUno := ''
		       cApeDos := ''
		       cNomUno := ''
		       cNomDos := ''
		       cDirecc := ''
		       cCiudad := ''
		       cDepart := ''

		       DO CASE

		       CASE EMPTY(&cMaeAct->cNitCo1Est)

			    DO CASE
			    CASE !EMPTY(cDocPad)

				 cDocNit := cDocPad
				 cApeUno := cAp1Pad
				 cApeDos := cAp2Pad
				 cNomUno := cNo1Pad
				 cNomDos := cNo2Pad
				 cDirecc := cDirPad
				 cCiudad := cCiuPad
				 cDepart := cDepPad
			       *ÀPrimer contratante. Padre

			    CASE !EMPTY(cDocMad)

				 cDocNit := cDocMad
				 cApeUno := cAp1Mad
				 cApeDos := cAp2Mad
				 cNomUno := cNo1Mad
				 cNomDos := cNo2Mad
				 cDirecc := cDirMad
				 cCiudad := cCiuMad
				 cDepart := cDepMad
			       *ÀPrimer contratante. Madre

			    OTHERWISE
				 cApeUno := 'C:'+&cMaeAct->cNitCo1Est
				 cApeDos := 'P:'+cDocPad
				 cNomUno := 'M:'+cDocMad
			    ENDCASE


		       CASE ALLTRIM(&cMaeAct->cNitCo1Est) == ALLTRIM(cDocPad)

			    cDocNit := cDocPad
			    cApeUno := cAp1Pad
			    cApeDos := cAp2Pad
			    cNomUno := cNo1Pad
			    cNomDos := cNo2Pad
			    cDirecc := cDirPad
			    cCiudad := cCiuPad
			    cDepart := cDepPad
			  *ÀPrimer contratante. Padre

		       CASE ALLTRIM(&cMaeAct->cNitCo1Est) == ALLTRIM(cDocMad)

			    cDocNit := cDocMad
			    cApeUno := cAp1Mad
			    cApeDos := cAp2Mad
			    cNomUno := cNo1Mad
			    cNomDos := cNo2Mad
			    cDirecc := cDirMad
			    cCiudad := cCiuMad
			    cDepart := cDepMad
			  *ÀPrimer contratante. Madre

		       OTHERWISE

			   IF lLocNitPer(&cMaeAct->cNitCo1Est,;
					 &cMaeAct->cTipCo1Est)

			      cDocNit := PER->cDocNitPer
			      cApeUno := PER->cApeUnoPer
			      cApeDos := PER->cApeDosPer
			      cNomUno := PER->cNomUnoPer
			      cNomDos := PER->cNomDosPer
			      cDirecc := ALLTRIM(PER->cDireccPer)+' '+;
					 ALLTRIM(PER->cBarrioPer)
			      cCiudad := PER->cCiudadPer
			      cDepart := SPACE(01)

			   ELSE

			      cApeUno := 'C:'+&cMaeAct->cNitCo1Est
			      cApeDos := 'P:'+cDocPad
			      cNomUno := 'M:'+cDocMad

			   ENDIF

		       ENDCASE
*--------------------FIN LOCALIZACION DE PRIMER CONTRATANTE

*--------------------ACTIVACION DEL INDICE
		       SELECT DES
*                      SET FILTER TO // Falta analizar si se requiere
		       IF lShared
			  DBSETINDEX(cPatSis+'\'+fNtxDes)
		       ELSE
			  SET INDEX TO (cPatSis+'\'+fNtxDes)
		       ENDIF
*--------------------FIN ACTIVACION DEL INDICE

*--------------------CALCULO DEL SALDO ACTUAL
		       lPrnFec := .T.

		       nSdoAct := 0
*--------------------FIN CALCULO DEL SALDO ACTUAL

*--------------------CALCULO IMPUESTO ICA
		       nVlrIca := ROUND((nTotPag * CAA->nImpIcaCaA)/100,0)
		       nTotIca += nVlrIca
*--------------------FIN CALCULO IMPUESTO ICA

*--------------------IMPRESION DEL REGISTRO
		       IF lHayAlu

			  nNroAlu++
			  aRegPrn := {}

			  AADD(aRegPrn,STR(nNroAlu,6))    // 1
			  AADD(aRegPrn,CLI->cCodigoEst)   // 2
			  AADD(aRegPrn,GRU->cCodigoGru)   // 3


			  IF nOpcPrn == 7 .OR. nOpcPrn == 8

			     IF nOpcRep == 2 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocPad)
				AADD(aRegPrn,cAp1Pad)
				AADD(aRegPrn,cAp2Pad)
				AADD(aRegPrn,cNo1Pad)
				AADD(aRegPrn,cNo2Pad)
				AADD(aRegPrn,cDirPad)
				AADD(aRegPrn,cCiuPad)
				AADD(aRegPrn,cDepPad)
				AADD(aRegPrn,SPACE(01)) // Pais
			     ENDIF
			   *ÀInformaci¢n del padre

			     IF nOpcRep == 3 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocMad)
				AADD(aRegPrn,cAp1Mad)
				AADD(aRegPrn,cAp2Mad)
				AADD(aRegPrn,cNo1Mad)
				AADD(aRegPrn,cNo2Mad)
				AADD(aRegPrn,cDirMad)
				AADD(aRegPrn,cCiuMad)
				AADD(aRegPrn,cDepMad)
				AADD(aRegPrn,SPACE(01)) // Pais
			     ENDIF
			   *ÀInformaci¢n de la madre

			     IF nOpcRep == 1 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocNit)   // 4
				AADD(aRegPrn,cApeUno)   // 5
				AADD(aRegPrn,cApeDos)   // 6
				AADD(aRegPrn,cNomUno)   // 7
				AADD(aRegPrn,cNomDos)   // 8
				AADD(aRegPrn,cDirecc)   // 9
				AADD(aRegPrn,cCiudad)   // 10
				AADD(aRegPrn,cDepart)   // 11
				AADD(aRegPrn,SPACE(01)) // 12 Pais
			     ENDIF
			   *ÀInformaci¢n primer contratante

			  ELSE

			     AADD(aRegPrn,cNombreTes)

			  ENDIF

			  AADD(aRegPrn,TRANS(nTotPag,"##########"))
			  AADD(aRegPrn,TRANS(nVlrIca,"##########"))

			  SET DEVICE TO PRINT
			  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
				  bCabeza)
			  SET DEVICE TO SCREEN

		       ENDIF
*--------------------FIN IMPRESION DEL REGISTRO

*--------------------VISUALIZACION
		       @ nNroFil,01 SAY 'GRUPO: '+GRU->cCodigoGru+' '+;
					cNombreTes+' TOTAL $'+;
					TRANS(nTotPag,"##########")
		       nNroFil++
		       IF nNroFil == 21
			  nNroFil := nMarco(03,'A¥O:'+cAnoUsr+;
					       '.IMPUESTO ICA:'+;
					       STR(CAA->nImpIcaCaA,5,2)+'%'+;
					       '.MESES:'+cMes(nMesIniTpa,3)+' A '+;
							 cMes(nMesIniTpa,3))
		       ENDIF
*--------------------FIN VISUALIZACION

		     CLI->(DBSKIP())

		  ENDDO
*===============FIN RECORRIDO POR CLIENTES

		GRU->(DBSKIP())

*EXIT
*ojo

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

       ENDFOR
*>>>>FIN RECORRIDO POR NIVELES

*>>>>IMPRESION DE LOS TOTALES
       IF !(nOpcPrn == 7 .OR. nOpcPrn == 8)
	  SET DEVICE TO PRINT
	  @ PROW()+2,00 SAY 'TOTAL IMPUESTO ICA...$ '+TRANS(nTotIca,"####,###,###")
       ENDIF
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO..: VALOR DE LOS CONCEPTOS DEL A¥O                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 06:15 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Descrimina todos los Conceptos del A¤o

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lVlrConMes(aVlrCon,lSiCert,fNtxDes,nMesIni,nMesFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     aVlrCon                              // Valor de los Conceptos
       lSiCert                              // .T. Certificado
       fNtxDes                              // Archivo Indice del Descuento
       nMesIni                              // Mes Inicial
       nMesFin                              // Mes Final */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aRegPag := {}                  // Registro de Pagos
       LOCAL nRegDes := 0                   // Registro del Descuento
       LOCAL nRegPag := 0                   // Registro de Pagos
       LOCAL lPago   := .F.                 // .T. Pago el recibo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS PAGOS
       aRegPag := aRegPagos(PAG->cCodigoEst)
       SELECT PAG
       PAG->(DBGOTOP())

       DO WHILE .NOT. PAG->(EOF())

**********VALIDACION DEL MES
	    IF !(PAG->nMesIniPag >= nMesIni .AND.;
		 PAG->nMesIniPag <= nMesFin)

		 PAG->(DBSKIP())
		 LOOP

	    ENDIF
**********FIN VALIDACION DEL MES

**********VALIDACION DEL PAGO DEL RECIBO
	    lPago := (PAG->cEstadoPag == 'P' .OR.;
		      PAG->cEstadoPag == 'A') .AND. !EMPTY(PAG->dFecPagPag)
	    IF !lPago
	       PAG->(DBSKIP())
	       LOOP
	    ENDIF

	    nRegPag := PAG->(RECNO())
	    DES->(DBSETINDEX(fNtxDes))
	    lHayErr := !lVlrConRec(aVlrCon,lSiCert)
	    DES->(DBCLEARINDEX())
**********FIN VALIDACION DEL PAGO DEL RECIBO

**********FILTRACION DE LOS DESCUENTOS,RECARGOS Y ABONOS DEL ESTUDIANTE
	    SELECT DES
	    SET FILTER TO DES->cCodigoEst == PAG->cCodigoEst
	    DES->(DBGOTOP())
	    IF DES->(EOF())
	       SET FILTER TO
	       PAG->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LOS DESCUENTOS,RECARGOS Y ABONOS DEL ESTUDIANTE

**********IMPRESION DEL LOS ABONOS
	    IF .NOT. DES->(EOF())
	       SELECT DES
	       DES->(DBGOTOP())
	       DO WHILE .NOT. DES->(EOF())

*-----------------VALIDACION DEL ABONO
		    IF !(DES->nNroMesDes == PAG->nMesIniPag .AND.; // Abono
			 DES->nTipDesDes == 3 .AND. !DES->lDesEfeDes)

			 DES->(DBSKIP())
			 LOOP

		    ENDIF
*-----------------FIN VALIDACION DEL ABONO

*-----------------DESCRIMINACION DEL ABONO
		    nRegDes := DES->(RECNO())
		    DES->(DBSETINDEX(fNtxDes))
		    DES->(DBGOTO(nRegDes))
		    lHayErr := !lVlrConAbo(aVlrCon,lSiCert)
		    DES->(DBCLEARINDEX())

		    PAG->(DBGOTO(nRegPag))
*-----------------FIN DESCRIMINACION DEL ABONO

		  DES->(DBSKIP())

	       ENDDO
	    ENDIF
**********FIN IMPRESION DEL LOS ABONOS

	  PAG->(DBSKIP())

       ENDDO
       RETURN lHayErr
*>>>>FIN IMPRESION DE LOS PAGOS

/*************************************************************************
* TITULO..: FACTURACION DEL MES                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 06:15 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Descrimina todos los Conceptos del A¤o

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nFacConMes(cCodEst,nMesIni,nMesFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nMesIni                              // Mes Inicial
       nMesFin                              // Mes Final */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegPag := 0                   // Registro de Pagos
       LOCAL nFacAno := 0                   // Facturaci¢n del A¤o
       LOCAL aVlrCon := {}                  // Valor de los conceptos
       LOCAL aAntici[16]                    // Anticipos. 8 Conceptos
       LOCAL aAntEst := {}                  // Anticipos del Estudiante
       LOCAL nAntici := 0                   // Anticipos de los Estudiantes
       LOCAL nVlrMes := 0                   // Valor del Mes
*>>>>FIN DECLARACION DE VARIABLES

       AFILL(aAntici,0)

*>>>>FILTRACION DE LOS PAGOS
       SELECT PAG
       nRegPag := PAG->(RECNO())
       SET FILTER TO PAG->cCodigoEst == cCodEst
       PAG->(DBGOTOP())
       IF PAG->(EOF())
	  SET FILTER TO
	  RETURN nFacAno
       ENDIF
*>>>>FIN FILTRACION DE LOS PAGOS

*>>>>RECORRIDO DEL ARCHIVO
       SELECT PAG
       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

**********VALIDACION DEL MES
	    IF !(PAG->nMesIniPag >= nMesIni .AND.;
		 PAG->nMesIniPag <= nMesFin)

		 PAG->(DBSKIP())
		 LOOP

	    ENDIF
**********FIN VALIDACION DEL MES

**********FACTURACION DEL MES
	    aVlrCon := {}
	    nVlrMes := nVlrMes(@aVlrCon)
	    nFacAno += nVlrMes
**********FIN FACTURACION DEL MES

**********ANTICIPOS DEL MES
	    IF (PAG->nMesIniPag # PAG->nMesFinPag .OR.;
		lHayAntici(PAG->nMesIniPag,PAG->cIniFinPag)) .AND.;
		(PAG->cEstadoPag = 'P' .OR. PAG->cEstadoPag = 'A') .AND.;
		!EMPTY(PAG->dFecPagPag)

		IF CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses

		   aAntEst := AnticiVar(GRU->cCodigoGru,;
					aVlrCon,;
					PAG->nMesIniPag+1,;
					PAG->nMesFinPag,;
					aAntici,;
					PAG->cIniFinPag,;
					PAG->cConcepPag,;
					PAG->cConcepPag)

		ELSE
		   aAntEst := Anticipos(aVlrCon,;
					(nNroMesFac(PAG->nMesIniPag,;
					 PAG->nMesFinPag)-1),aAntici,;
					PAG->cIniFinPag,PAG->cConcepPag,;
					PAG->cConcepPag)
	       ENDIF

	       nAntici := nSuma(aAntEst)
	       nFacAno += nAntici

	    ENDIF
**********FIN ANTICIPOS DEL MES

	  PAG->(DBSKIP())

       ENDDO
       SET FILTER TO
       PAG->(DBGOTO(nRegPag))
       RETURN nFacAno
*>>>>FIN RECORRIDO DEL ARCHIVO

/*************************************************************************
* NOMBRE ..: REPORTE ANTICIPOS PARA LA DIAN                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/2017 MIE A
       Bucaramanga, Colombia        INICIO: 07:30 AM   MAY 03/2017 MIE

OBJETIVOS:

1- Genera el informe de anticipos para la Dian.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_485(aParam1,aParam2,aParam3)

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
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

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
       LOCAL nNroAlu := 0                   // N£mero de Estudiantes
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL nVlrMtr := 0                   // Valor de la matr¡cula
       LOCAL nVlrFac := 0                   // Valor de la facturaci¢n
       LOCAL nVlrPag := 0                   // Valor de los pagos
       LOCAL nTotPag := 0                   // Valor temporal
       LOCAL nTotFac := 0                   // Total Facturado

       LOCAL nOpcRep := 0                   // Opci¢n del Reporte
       LOCAL lHayAlu := .F.                 // .T. Existe el Estudiante
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n
       LOCAL nSdoAct := 0                   // Saldo Actual

       LOCAL cDocPad := ''                  // N£mero del Documento
       LOCAL cAp1Pad := ''                  // Primer apellido
       LOCAL cAp2Pad := ''                  // Segundo apellido
       LOCAL cNo1Pad := ''                  // Primer Nombre
       LOCAL cNo2Pad := ''                  // Segundo Nombre
       LOCAL cDirPad := ''                  // Direccion del Padre
       LOCAL cCiuPad := ''                  // Ciudad del Padre
       LOCAL cDepPad := ''                  // Departamento del Padre

       LOCAL cDocMad := ''                  // N£mero del Documento
       LOCAL cAp1Mad := ''                  // Primer apellido
       LOCAL cAp2Mad := ''                  // Segundo apellido
       LOCAL cNo1Mad := ''                  // Primer Nombre
       LOCAL cNo2Mad := ''                  // Segundo Nombre
       LOCAL cDirMad := ''                  // Direccion de la Madre
       LOCAL cCiuMad := ''                  // Ciudad de la Madre
       LOCAL cDepMad := ''                  // Departamento de la Madre

       LOCAL cDocNit := ''                  // Documento de Identidad
       LOCAL cApeUno := ''                  // Primer Apellido
       LOCAL cApeDos := ''                  // Segundo Apellido
       LOCAL cNomUno := ''                  // Primer Nombre
       LOCAL cNomDos := ''                  // Segundo Nombre
       LOCAL cDirecc := ''                  // Direccion de la Casa
       LOCAL cCiudad := ''                  // Ciudad de la Direcci¢n
       LOCAL cDepart := ''                  // Departamento de la Direcci¢n

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *ÀVariables de campo
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
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       IF !lUseDbf(.T.,cIntDos+'\'+;
		      'MATR'+cAnoUsr+ExtFile,'MTR',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
       cIntCua := ALLTRIM(MTR->cIntCuaAno)
       IF !EMPTY(cIntCua)
	  PathUno := cIntCua
	  cIntCua := cIntCua+'\'+cPatSis
	  cIntUno := cIntCua
       ENDIF
       CloseAll()
*>>>>FIN AREAS DE TRABAJO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntDos+'\'+FilePag,'PMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileTar,'TMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileCon,'CMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->nMesFinCaA == 0
	    cError('SE DEBE DEFINIR EL MES FINAL DE LA FACTURACION')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
      IF EMPTY(CAA->cConMatCaA)
	 cError('EN LA CONFIGURACION DEL A¥O SE HABILITAN',;
		'NO SE INCLUYE LA FACTURACION DE LAS MATRICULAS')
	 IF !lPregunta('DESEA CONTINUAR? No Si')
	    CloseAll(aUseDbf)
	    RETURN NIL
	 ENDIF
      ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')

       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,10 SAY 'PARA LOS MOROROS DE LA FACTURACION DE '+;
		   cMes(CAA->nMesFinCaA)+':(MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(dFecPrn)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := SUBS(SCA->cSerFacCar,1,1)+'ade'+cAnoUsr
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ANALISIS DE DECISION
       IF nOpcPrn == 7 .OR. nOpcPrn == 8

	  SET DEVICE TO SCREEN
	  nOpcRep := nLeeOpcion('REPORTAR A: '+;
				'1<CONTRATANTE> '+;
				'2<PADRE> '+;
				'3<MADRE> '+;
				'4<TODOS> '+;
				'5<ABANDONAR>'+;
				'<?',5,'0')

	  IF EMPTY(nOpcRep) .OR. nOpcRep == 5
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
	  SET DEVICE TO PRINT

       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'RELACION DE ANTIPOS POR ESTUDIANTES',;
		   '',;
		   ''}

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
       AADD(aTitPrn,'No.')

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'GRUPO')

       IF nOpcPrn == 7 .OR. nOpcPrn == 8

	  IF nOpcRep == 2 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 PADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 PADRE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO PADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS PADRE')

	  ENDIF
	*ÀInformaci¢n del padre

	  IF nOpcRep == 3 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 MADRE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 MADRE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO MADRE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS MADRE')

	  ENDIF
	*ÀInformaci¢n de la madre


	  IF nOpcRep == 1 .OR. nOpcRep == 4

	     AADD(aNroCol,16)
	     AADD(aTitPrn,'CC CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO1 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'APELLIDO2 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE1 CONTRATANTE')

	     AADD(aNroCol,20)
	     AADD(aTitPrn,'NOMBRE2 CONTRATANTE')

	     AADD(aNroCol,100)
	     AADD(aTitPrn,'DIRECCION CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'CIUDAD CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'DEPARTAMENTO CONTRATANTE')

	     AADD(aNroCol,40)
	     AADD(aTitPrn,'PAIS CONTRATANTE')

	  ENDIF
	*ÀInformaci¢n del contratante

       ELSE

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'NOMBRE')

       ENDIF

       AADD(aNroCol,12)
       AADD(aTitPrn,'PAGADO')

       AADD(aNroCol,12)
       AADD(aTitPrn,'DEUDA')

       AADD(aNroCol,12)
       AADD(aTitPrn,'FACTURADO')

       AADD(aNroCol,12)
       AADD(aTitPrn,'PAGADO')

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

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*cMaeAlu := 'BTO' // ojo

*>>>>RECORRIDO POR NIVELES
       SET DEVICE TO SCREEN
       nNroFil := nMarco(03,'ESTUDIANTES')

       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseDbf(.T.,cIntUno+'\'+cMaeAct+'\'+'GRU'+;
			 cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry)

		cError('ABRIENDO EL ARCHIVO GRUPOS DE '+cMaeAct)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     GRU->(DBGOTOP())

// lLocCodigo('cCodigoGru','GRU','0702')  // ojo

	     DO WHILE .NOT. GRU->(EOF())


*===============PREPARACION DE LAS VARIABLES DE ARCHIVOS
		  FileCli := cPatSis+'\CLIENTES\CL'+;
			     GRU->cCodigoGru+cAnoSis+ExtFile

		  FilePag := cPatSis+'\PAGOS\PA'+;
			     GRU->cCodigoGru+cAnoSis+ExtFile
*===============FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

*===============SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		     cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*===============FIN SELECION DE LAS AREAS DE TRABAJO

*===============RECORRIDO POR CLIENTES
		  CLI->(DBGOTOP())

//lLocCodigo('cCodigoEst','CLI','212031')  // ojo


		  DO WHILE .NOT. CLI->(EOF())

*--------------------IMPRESION DE LA LINEA DE ESTADO
		       LineaEstado('CODIGO: '+CLI->cCodigoEst+;
				   'ºGRUPO: '+GRU->cCodigoGru+;
				   'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
					   STR(CLI->(RECCOUNT()),2),cNomSis)
*--------------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		       IF CLI->lRetgruCli
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------------BUSQUEDA DEL ESTUDIANTE
		       cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
		       lHayAlu := lSekCodMae(CLI->cCodigoEst,;
					     cMaeAct,@cMaeAct)
*--------------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------------LOCALIZACION DEL PAGO
		       PAG->(DBSETFILTER())
		       IF !lLocCodigo('cCodigoEst','PAG',CLI->cCodigoEst)
			  lHayAlu := .F.
		       ENDIF
*--------------------FIN LOCALIZACION DEL PAGO

*--------------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		       lRetadoTes := .F.
		       cNombreTes := 'CODIGO:'+CLI->cCodigoEst+;
				     ' NO EXISTE'

		       IF lHayAlu
			  cCodigoTes := &cMaeAct->cCodigoEst
			  IF &cMaeAct->lRetiroEst
			     lRetadoTes := .T.
			  ENDIF
			  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
					&cMaeAct->cNombreEst
			  cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		       ENDIF
*--------------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------------LOCALIZACION RECIBO MATRICULA
		       SELECT PMT
		       LOCATE FOR PMT->cCodigoEst == cCodigoTes .AND.;
				  PMT->cMatricPag == '1'
*--------------------LOCALIZACION RECIBO MATRICULA

*--------------------TARIFAS DE MATRICULAS
		       nTotFac := 0
		       nTotPag := 0

		       aVlrCon := {}
		       nTotFac := 0
		       nVlrMtr := 0
/*
		       IF PMT->(FOUND())
			  VlrTarMtr(PMT->cConcepPag,GRU->cCodigoGru,;
				    aVlrCon,.F.)
			  nVlrMtr := nSuma(aVlrCon,3)
			  nTotFac += nVlrMtr
		       ENDIF
*/
*--------------------FIN TARIFAS DE MATRICULAS

*--------------------TARIFAS SERVICIOS EDUCATIVOS
		       lHayPag := .F.
		       IF lHayAlu

			  lVlrFecAno(aVlrCon,.F.,cPatSis+'\'+fNtxDes,dFecPrn,@lHayPag)

			  SELECT PAG
			  SET FILTER TO

			  IF lHayPag
			     nVlrPag := nSuma(aVlrCon,3)
			     nTotPag += nVlrPag
			  ENDIF

		       ENDIF
*--------------------FIN TARIFAS SERVICIOS EDUCATIVOS

*--------------------ANALISIS DE DECISION
		       IF !lHayPag
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS DE DECISION

*--------------------TOTAL FACTURADO
		       IF lHayAlu .AND. lHayPag
			  nVlrFac := nFacConAno(CLI->cCodigoEst)
			  nTotFac += nVlrFac
		       ENDIF
*--------------------FIN TOTAL FACTURADO


*--------------------GRABACION DEL TOTAL PAGADO
		       SELECT &cMaeAct
		       IF lHayAlu .AND. lHayPag
			  IF lRegLock(lShared,.F.)

			     REPL &cMaeAct->nTotPagEst WITH nTotPag
			     REPL &cMaeAct->nTotFacEst WITH nTotFac

			  ELSE
			      cError('NO SE GRABA EL REGISTRO')
			  ENDIF

			  DBCOMMIT()
			  IF lShared
			     DBUNLOCK()
			  ENDIF

		       ENDIF
*--------------------FIN GRABACION DEL TOTAL PAGADO

*--------------------INFORMACION DEL PADRE Y MADRE
		       cDocPad := ''
		       cAp1Pad := ''
		       cAp2Pad := ''
		       cNo1Pad := ''
		       cNo2Pad := ''
		       cDirPad := ''
		       cCiuPad := ''
		       cDepPad := ''
		     *ÀInformaci¢n del padre

		       cDocMad := ''
		       cAp1Mad := ''
		       cAp2Mad := ''
		       cNo1Mad := ''
		       cNo2Mad := ''
		       cDirMad := ''
		       cCiuMad := ''
		       cDepMad := ''
		     *ÀInformaci¢n de la Madre

		       IF lHayAlu .AND. lHayPag

			  cDocPad := ALLTRIM(&cMaeAct->cPadNitEst)

			  SepararNom(ALLTRIM(&cMaeAct->cApePadEst),;
				     @cAp1Pad,@cAp2Pad)              // Apellidos

			  SepararNom(ALLTRIM(&cMaeAct->cNomPadEst),;
				     @cNo1Pad,@cNo2Pad)              // Nombres

			  cDirPad := ALLTRIM(&cMaeAct->cDirPadEst)+' '+;
				     ALLTRIM(&cMaeAct->cBarPadEst)
			  cCiuPad := &cMaeAct->cCiuPadEst
			  cDepPad := SPACE(01)
			*ÀInformaci¢n del padre

			 cDocMad := ALLTRIM(&cMaeAct->cMadNitEst)

			 SepararNom(ALLTRIM(&cMaeAct->cApeMadEst),;
				    @cAp1Mad,@cAp2Mad)              // Apellidos

			 SepararNom(ALLTRIM(&cMaeAct->cNomMadEst),;
				    @cNo1Mad,@cNo2Mad)              // Nombres

			 cDirMad := ALLTRIM(&cMaeAct->cDirMadEst)+' '+;
				    ALLTRIM(&cMaeAct->cBarMadEst)
			 cCiuMad := &cMaeAct->cCiuMadEst

			 cDepMad := SPACE(01)
		       *ÀInformaci¢n de la Madre

		       ENDIF
*--------------------FIN INFORMACION DEL PADRE Y MADRE

*--------------------LOCALIZACION DE PRIMER CONTRATANTE
		       cDocNit := ''
		       cApeUno := ''
		       cApeDos := ''
		       cNomUno := ''
		       cNomDos := ''
		       cDirecc := ''
		       cCiudad := ''
		       cDepart := ''

		       DO CASE

		       CASE EMPTY(&cMaeAct->cNitCo1Est)

			    DO CASE
			    CASE !EMPTY(cDocPad)

				 cDocNit := cDocPad
				 cApeUno := cAp1Pad
				 cApeDos := cAp2Pad
				 cNomUno := cNo1Pad
				 cNomDos := cNo2Pad
				 cDirecc := cDirPad
				 cCiudad := cCiuPad
				 cDepart := cDepPad
			       *ÀPrimer contratante. Padre

			    CASE !EMPTY(cDocMad)

				 cDocNit := cDocMad
				 cApeUno := cAp1Mad
				 cApeDos := cAp2Mad
				 cNomUno := cNo1Mad
				 cNomDos := cNo2Mad
				 cDirecc := cDirMad
				 cCiudad := cCiuMad
				 cDepart := cDepMad
			       *ÀPrimer contratante. Madre

			    OTHERWISE
				 cApeUno := 'C:'+&cMaeAct->cNitCo1Est
				 cApeDos := 'P:'+cDocPad
				 cNomUno := 'M:'+cDocMad
			    ENDCASE


		       CASE ALLTRIM(&cMaeAct->cNitCo1Est) == ALLTRIM(cDocPad)

			    cDocNit := cDocPad
			    cApeUno := cAp1Pad
			    cApeDos := cAp2Pad
			    cNomUno := cNo1Pad
			    cNomDos := cNo2Pad
			    cDirecc := cDirPad
			    cCiudad := cCiuPad
			    cDepart := cDepPad
			  *ÀPrimer contratante. Padre

		       CASE ALLTRIM(&cMaeAct->cNitCo1Est) == ALLTRIM(cDocMad)

			    cDocNit := cDocMad
			    cApeUno := cAp1Mad
			    cApeDos := cAp2Mad
			    cNomUno := cNo1Mad
			    cNomDos := cNo2Mad
			    cDirecc := cDirMad
			    cCiudad := cCiuMad
			    cDepart := cDepMad
			  *ÀPrimer contratante. Madre

		       OTHERWISE

			   IF lLocNitPer(&cMaeAct->cNitCo1Est,;
					 &cMaeAct->cTipCo1Est)

			      cDocNit := PER->cDocNitPer
			      cApeUno := PER->cApeUnoPer
			      cApeDos := PER->cApeDosPer
			      cNomUno := PER->cNomUnoPer
			      cNomDos := PER->cNomDosPer
			      cDirecc := ALLTRIM(PER->cDireccPer)+' '+;
					 ALLTRIM(PER->cBarrioPer)
			      cCiudad := PER->cCiudadPer
			      cDepart := SPACE(01)

			   ELSE

			      cApeUno := 'C:'+&cMaeAct->cNitCo1Est
			      cApeDos := 'P:'+cDocPad
			      cNomUno := 'M:'+cDocMad

			   ENDIF

		       ENDCASE
*--------------------FIN LOCALIZACION DE PRIMER CONTRATANTE

*--------------------ACTIVACION DEL INDICE
		       SELECT DES
*                      SET FILTER TO // Falta analizar si se requiere
		       IF lShared
			  DBSETINDEX(cPatSis+'\'+fNtxDes)
		       ELSE
			  SET INDEX TO (cPatSis+'\'+fNtxDes)
		       ENDIF
*--------------------FIN ACTIVACION DEL INDICE

*--------------------CALCULO DEL SALDO ACTUAL
		       lPrnFec := .T.

		       nSdoAct := nSdoActEst(CLI->cCodigoEst,lRetadoTes,;
					     cMaeAlu,CAA->nMesFinCaA,;
					     lPrnFec,dFecPrn)
*--------------------FIN CALCULO DEL SALDO ACTUAL


*--------------------IMPRESION DEL REGISTRO
		       IF lHayAlu .AND. lHayPag

			  nNroAlu++
			  aRegPrn := {}

			  AADD(aRegPrn,STR(nNroAlu,6))    // 1
			  AADD(aRegPrn,CLI->cCodigoEst)   // 2
			  AADD(aRegPrn,GRU->cCodigoGru)   // 3

			  IF nOpcPrn == 7 .OR. nOpcPrn == 8

			     IF nOpcRep == 2 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocPad)
				AADD(aRegPrn,cAp1Pad)
				AADD(aRegPrn,cAp2Pad)
				AADD(aRegPrn,cNo1Pad)
				AADD(aRegPrn,cNo2Pad)
				AADD(aRegPrn,cDirPad)
				AADD(aRegPrn,cCiuPad)
				AADD(aRegPrn,cDepPad)
				AADD(aRegPrn,SPACE(01)) // Pais
			     ENDIF
			   *ÀInformaci¢n del padre

			     IF nOpcRep == 3 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocMad)
				AADD(aRegPrn,cAp1Mad)
				AADD(aRegPrn,cAp2Mad)
				AADD(aRegPrn,cNo1Mad)
				AADD(aRegPrn,cNo2Mad)
				AADD(aRegPrn,cDirMad)
				AADD(aRegPrn,cCiuMad)
				AADD(aRegPrn,cDepMad)
				AADD(aRegPrn,SPACE(01)) // Pais
			     ENDIF
			   *ÀInformaci¢n de la madre

			     IF nOpcRep == 1 .OR. nOpcRep == 4
				AADD(aRegPrn,cDocNit)   // 4
				AADD(aRegPrn,cApeUno)   // 5
				AADD(aRegPrn,cApeDos)   // 6
				AADD(aRegPrn,cNomUno)   // 7
				AADD(aRegPrn,cNomDos)   // 8
				AADD(aRegPrn,cDirecc)   // 9
				AADD(aRegPrn,cCiudad)   // 10
				AADD(aRegPrn,cDepart)   // 11
				AADD(aRegPrn,SPACE(01)) // 12 Pais
			     ENDIF
			   *ÀInformaci¢n primer contratante

			  ELSE

			     AADD(aRegPrn,cNombreTes)

			  ENDIF
			  IF nTotFac > nTotPag
			     AADD(aRegPrn,TRANS(0,"##########"))    // 13
			  ELSE
			     AADD(aRegPrn,TRANS(0,"##########"))    // 13
			  ENDIF

			  AADD(aRegPrn,TRANS(0,"##########"))       // 14

			  AADD(aRegPrn,TRANS(0,"##########"))       // 15
			  AADD(aRegPrn,TRANS(nTotPag,"##########")) // 16

			  SET DEVICE TO PRINT
			  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
				  bCabeza)
			  SET DEVICE TO SCREEN

		       ENDIF
*--------------------FIN IMPRESION DEL REGISTRO

*--------------------VISUALIZACION
		       @ nNroFil,01 SAY 'GRUPO: '+GRU->cCodigoGru+' '+;
					cNombreTes+' TOTAL $'+;
					TRANS(nTotPag,"##########")
		       nNroFil++
		       IF nNroFil == 21
			  nNroFil := nMarco(03,'ESTUDIANTES')
		       ENDIF
*--------------------FIN VISUALIZACION

		     CLI->(DBSKIP())

		  ENDDO
*===============FIN RECORRIDO POR CLIENTES

		GRU->(DBSKIP())

*EXIT

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

       ENDFOR
*>>>>FIN RECORRIDO POR NIVELES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: VALOR DE LOS CONCEPTOS DEL A¥O POR FECHA                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 06:15 PM   MAY 06/2002 VIE

OBJETIVOS:

1- Descrimina todos los Conceptos del A¤o con fecha

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lVlrFecAno(aVlrCon,lSiCert,fNtxDes,dFecFin,lHayPag)

*>>>>DESCRIPCION DE PARAMETROS
/*     aVlrCon                              // Valor de los Conceptos
       lSiCert                              // .T. Certificado
       fNtxDes                              // Archivo Indice del Descuento
       dFecFin                              // Fecha de Corte
       lHayPag                              // @.T. Hay Pago */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aRegPag := {}                  // Registro de Pagos
       LOCAL nRegDes := 0                   // Registro del Descuento
       LOCAL nRegPag := 0                   // Registro de Pagos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS PAGOS
       lHayPag := .F.
       aRegPag := aRegPagos(PAG->cCodigoEst)
       SELECT PAG
       PAG->(DBGOTOP())

       DO WHILE .NOT. PAG->(EOF())

	  IF EMPTY(PAG->dFecPagPag)
	     PAG->(DBSKIP())
	     LOOP
	  ENDIF

	  IF !(PAG->dFecPagPag <= dFecFin)
	     PAG->(DBSKIP())
	     LOOP
	  ENDIF

	  IF PAG->cEstadoPag = 'D' .OR. PAG->cEstadoPag = '*'
	     PAG->(DBSKIP())
	     LOOP
	  ENDIF


	  lHayPag := .T.
	  nRegPag := PAG->(RECNO())
	  DES->(DBSETINDEX(fNtxDes))
	  lHayErr := !lVlrConRec(aVlrCon,lSiCert)
	  DES->(DBCLEARINDEX())

**********FILTRACION DE LOS DESCUENTOS,RECARGOS Y ABONOS DEL ESTUDIANTE
	    SELECT DES
	    SET FILTER TO DES->cCodigoEst == PAG->cCodigoEst
	    DES->(DBGOTOP())
	    IF DES->(EOF())
	       SET FILTER TO
	       PAG->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LOS DESCUENTOS,RECARGOS Y ABONOS DEL ESTUDIANTE

**********IMPRESION DEL LOS ABONOS
	    IF .NOT. DES->(EOF())
	       SELECT DES
	       DES->(DBGOTOP())
	       DO WHILE .NOT. DES->(EOF())

*-----------------VALIDACION DEL ABONO
		    IF !(DES->nNroMesDes == PAG->nMesIniPag .AND.; // Abono
			 DES->nTipDesDes == 3 .AND. !DES->lDesEfeDes)

			 DES->(DBSKIP())
			 LOOP

		    ENDIF
*-----------------FIN VALIDACION DEL ABONO

*-----------------DESCRIMINACION DEL ABONO
		    nRegDes := DES->(RECNO())
		    DES->(DBSETINDEX(fNtxDes))
		    DES->(DBGOTO(nRegDes))
		    lHayErr := !lVlrConAbo(aVlrCon,lSiCert)
		    DES->(DBCLEARINDEX())

		    PAG->(DBGOTO(nRegPag))
*-----------------FIN DESCRIMINACION DEL ABONO

		  DES->(DBSKIP())

	       ENDDO
	    ENDIF
**********FIN IMPRESION DEL LOS ABONOS

	  PAG->(DBSKIP())

       ENDDO
       RETURN lHayErr
*>>>>FIN IMPRESION DE LOS PAGOS