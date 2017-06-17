/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: PAGOS POR MODEM

**************************************************************************
* TITULO..: MENU DE PAGOS EN LINEA                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 20/2012 JUE A
       Colombia, Bucaramanga        INICIO: 09:45 PM   SEP 20/2012 JUE

OBJETIVOS:

1- Visualiza un men£ de pagos en linea

2- Ejecuta las diferentes opciones

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_507(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
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
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
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
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

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

       LOCAL cCodEan := ''                  // C¢digo EAN-13
       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL PathAct := ''                  // Path Actual

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
       cPatAnt := PathUno+'\'+cPatAnt
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FilePag,'PAG',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf) .OR.;
	  !lUseMaeMtr(lShared,cPatAnt,cMaeAlu,SUBS(cAnoAnt,3,2),NIL)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>SELECCION DEL BANCO
       IF BAN->(RECCOUNT()) > 1
	  nSelBanco(nFilInf+1,nColInf-1)
       ELSE
	  SELECT BAN
	  BAN->(DBGOTOP())
       ENDIF
*>>>>FIN SELECCION DEL BANCO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE BAN->nPagOnlBan == 0
	    cError(ALLTRIM(BAN->cNombreBan)+' '+;
		  'NO TIENE DEFINIDO UN FORMATO PARA PAGOS EN LINEA')

       CASE BAN->nPagOnlBan > 7
	    cError('FORMATO PARA PAGOS EN LINEA No.'+;
		   STR(BAN->nPagOnlBan,2)+' '+'NO ESTA HABILITADO')

       CASE EMPTY(MTR->cSerFacMtr)
	    cError('NO SE HA DEFINIDO LA DESCRIPCION DEL SERVICIO FACTURADO')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE PAG->(RECCOUNT()) == 0
	    cError('NO EXISTE REGISTROS EN PAGOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

/*
*>>>>LECTURA DE LOS DETALLES DEL BANCO
       IF !lLocCodigo('cCodigoBan','BAN',PAG->cCodigoBan)
	  cError('NO SE ENCONTRO EL BANCO QUE FIGURA EN  PAGOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LOS DETALLES DEL BANCO
*/

*>>>>ANALISIS DE DECISION
       cCodEan := IF(EMPTY(BAN->cEanCtaBan),SCO->cCodEanCon,BAN->cEanCtaBan)

       lHayErr := .T.
       DO CASE
       CASE EMPTY(cCodEan)
	    cError('NO SE HA DEFINIDO EL CODIGO DE BARRAS EAN')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CAPTURA DEL MES
       nMesIni := 13
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni,.T.)
*>>>>FIN CAPTURA DEL MES

*>>>>DIRECTORIOS
       PathAct := cPathAct()

       IF nMesIni == 13
	  PathOnl := cPatSis+'\online\13'
       ELSE
	  PathOnl := cPatSis+'\online\'+cMes(nMesIni,3)
       ENDIF
       Mdir(PathOnl,PathAct)
     *ÀDirectorio para el mes de facturacion

       IF nMesIni == 13
	  Mdir(PathDoc+'\online\'+cAnoUsr+'\13',PathAct)
	*ÀDirectorio para el mes de facturacion. Exportaci¢n
       ENDIF
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
       AADD(aUseDbf,{.T.,PathOnl+'\'+FileOnl,'ONL',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>PARAMETROS ESPECIFICOS
       aP2 := {}
       AADD(aP2,{'PathOnl',PathOnl})
       AADD(aP2,{'FileOnl',FileOnl})
       AADD(aP2,{'nMesIni',nMesIni})

       AADD(aP2,{'nPagOnl',BAN->nPagOnlBan})
       AADD(aP2,{'cCodSer',MTR->cCodFacMtr})
       AADD(aP2,{'cSerFac',MTR->cSerFacMtr})
       AADD(aP2,{'cNroNit',cNitEmp})
       AADD(aP2,{'cCodEan',cCodEan})
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>DECLARACION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus := {}
       AADD(aMenus,'1<CREAR    >')
       AADD(aMenus,'2<CONSULTAR>')

       aAyuda := {}
       AADD(aAyuda,'Permite crear los registros de la facturaci¢n')
       AADD(aAyuda,'Consurtar los registros de la facturaci¢n')
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
		    cError('EL ARCHIVO DE YA ESTA CREADO')

		    IF !lPregunta('DESEA VOLVER A GENERAR EL ARCHIVO?No Si')
		       LOOP
		    ENDIF
		 ENDIF
***************FIN ANALISIS DE DECISION

***************CREACION DEL ARCHIVO
		 CreaArcOnl(aP1,aP2,aP3)
***************FIN CREACION DEL ARCHIVO

	  CASE nNroOpc == 2

***************AREAS DE TRABAJO
/*
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
		 AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
		 AADD(aArchvo,{PathSis+'\'+FSimCar,NIL,'SCA'})
		 AADD(aArchvo,{PathOnl+'\'+FileOnl,NIL,'ONL'})
*/
***************FIN AREAS DE TRABAJO

***************PARAMETROS ESPECIFICOS
		 aP2 := {}
		 AADD(aP2,{'nMesIni',13})
		 AADD(aP2,{'nPagOnl',BAN->nPagOnlBan})
		 AADD(aP2,{'cCodEmp','01'}) // Revisar
		 AADD(aP2,{'cCodFac',ALLTRIM(MTR->cCodFacMtr)})
***************FIN PARAMETROS ESPECIFICOS

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

/*************************************************************************
* TITULO..: PAGOS EN LINEA                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 20/2012 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 20/2012 JUE

OBJETIVOS:

1- Permite generar un archivo plano de acuerdo al estandar de la Asobancaria
   para poder pagar la facturaci¢n en los cajeros automaticos.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaArcOnl(aP1,aP2,aP3)

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

*>>>>PARAMETROS ESPECIFICOS
       LOCAL nMesIni := xPrm(aP2,'nMesIni') // Mes inicial
       LOCAL nPagOnl := xPrm(aP2,'nPagOnl') // Formato para pagos en lineas.
       LOCAL cSerFac := xPrm(aP2,'cSerFac') // Servicio Facturado. Campo No.4 Registro de encabezado de lote. Formato Asobancaria 2001
       LOCAL cNroNit := xPrm(aP2,'cNroNit') // Nit
       LOCAL cCodEan := xPrm(aP2,'cCodEan') // C¢digo Ean
       LOCAL cCodSer := xPrm(aP2,'cCodSer') // C¢digo del Servicio
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador

       LOCAL nForPag := 0                   // Forma de pago
       LOCAL cForPag := ''                  // Forma de pago
       LOCAL aFecHoy := {}                  // Fecha de Proceso
       LOCAL cFecHoy := ''                  // Fecha del Proceso
       LOCAL cHorHoy := ''                  // Hora del Proceso

       LOCAL cRegIni := ''                  // Registro Inicial
       LOCAL cRegFin := ''                  // Registro Inicial
       LOCAL nTotReg := 0                   // Total de Registros
       LOCAL cTotReg := ''                  // Total de Registros
       LOCAL nTotOpo := 0                   // Total Valor Oportuno
       LOCAL cTotOpo := ''                  // Total Valor Oportuno
       LOCAL nTotExt := 0                   // Total Valor Extemporaneo
       LOCAL cTotExt := ''                  // Total Valor Extemporaneo

       LOCAL aTotErr := {}                  // Registro de Errores
       LOCAL aValErr := {1,3}               // Campos a Validar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE

       CASE nPagOnl == 0
	    cError('NO SE HA DEFINIDO EL FORMATO PARA PAGOS EN LINEA')

       CASE nPagOnl > 7
	    cError('FORMATO PARA PAGOS EN LINEA No.'+;
		   STR(nPagOnl,2)+' '+'NO ESTA HABILITADO')

       CASE EMPTY(cSerFac)
	    cError('NO SE HA DEFINIDO LA DESCRIPCION DEL SERVICIO FACTURADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       cSerFac := ALLTRIM(cSerFac)
       cCodSer := ALLTRIM(cCodSer)

       nForPag := 0
       cForPag := ''
       DO CASE
       CASE nPagOnl == 1  // Asobancaria 2001

	    nForPag := nLeeOpcion('GENERAR ARCHIVO PARA: '+;
		      '1<PAGO OPO> 2<PAGO EXT> 3<ABANDONAR>?',3,'0')
	    *Lee la forma de pago

	    IF nForPag == 3
	       RETURN NIL
	    ENDIF
	    cForPag := IF(nForPag==1,'1','2')

	    cError('PARA PAGO '+IF(cForPag=='1','OPORTUNO','EXTEMPORANEO'),;
		   'SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'DE ASOBANCARIA 2001')

       CASE nPagOnl == 2  // Asobancaria 2001. Place to Play

	    cError('SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'DE ASOBANCARIA 2001. PLACE TO PAY')

       CASE nPagOnl == 4  // Formato de ColPatria

	    nForPag := nLeeOpcion('GENERAR ARCHIVO PARA: '+;
		      '1<PAGO OPO> 2<PAGO EXT> 3<ABANDONAR>?',3,'0')
	    *Lee la forma de pago

	    IF nForPag == 3
	       RETURN NIL
	    ENDIF
	    cForPag := IF(nForPag==1,'1','2')

	    cError('PARA PAGO '+IF(cForPag=='1','OPORTUNO','EXTEMPORANEO'),;
		   'SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'DE COLPATRIA')


       CASE nPagOnl == 5  // Avisor. Manual Intercambio Archivos eCollect V.3.1.3

	    cError('SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'DE AVISOR TECHNOLOGIES')
	    cForPag := ''

       CASE nPagOnl == 7  // Pagos Virtuales Davivienda

	    cError('SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'PARA PAGOS VIRTURALES DE DAVIVIENDA')
	    cForPag := ''

       ENDCASE
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ANALISIS DE DECISION
       PathOnl := xPrm(aP2,'PathOnl')
       FileOnl := xPrm(aP2,'FileOnl')

       CloseDbf('ONL')
       CreaDbfOnl(lShared,nModCry,PathOnl,FileOnl)
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathOnl+'\'+FileOnl,'ONL',NIL,lShared,nModCry})
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
       CASE ONL->(RECCOUNT()) > 0
	    cError('EXISTEN REGISTROS YA CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>REGISTRO ENCABEZADO DE ARCHIVO
       aFecHoy := aFecha(DATE())
       cHorHoy := TIME()

       DO CASE
       CASE nPagOnl == 1       // Asobancaria 2001

	    cNitEmp := SUBS(cNroNit+SPACE(10),1,10)
	    lCorrecion(@cNitEmp)

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cHorHoy := SUBS(cHorHoy,1,2)+SUBS(cHorHoy,4,2)

	    cRegIni := '01'+;               // 01=>002:002.(Si) Constante. Indica el tipo de registro
		       cNitEmp+;            // 02=>010:012.(Si) Nit de la Empresa que presenta la facutraci¢n
		       REPL('0',10)+;       // 03=>010:022.(Si) Nit Recuador adicional que factura conjuntamente con la principal.
		       REPL('0',3)+;        // 04=>003:025.(Si) Ojo.C¢digo de la entidad financiera donde la Empresa tiene cuenta y desea que se le abone el recaudo por domiciliaci¢n. Este campo corresponde al c¢digo de tr nsito de la entidad financiera.
		       cFecHoy+;            // 05=>008:033.(Si) Fecha de Creaci¢n del archivo
		       cHorHoy+;            // 06=>004:037.(Si) Hora de grabaci¢n del archivo en formato de hora militar, es decir de 0001 hasta las 2400
		       'A'+;                // 07=>001:038.(Si) Modificardor de archivo. Car cter que refleja el orden cron¢logico de grabaci¢n de los archivos y permite diferenciar varios archivos generados en un mismo d¡a. Se debe empezar primero las letras may£sculas (A-Z) y posteriormente los n£meros
		       REPL(SPACE(01),182)  // 08=>182:220.(Si) Reservado. Blancos.


       CASE nPagOnl == 2       // Asobancaria 2001. Place to Pay

	    cNitEmp := SUBS(cNroNit+SPACE(10),1,10)
	    lCorrecion(@cNitEmp)

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cHorHoy := SUBS(cHorHoy,1,2)+SUBS(cHorHoy,4,2)

	    cRegIni := '01'+;               // 01=>002:002.(Si) Constante. Indica el tipo de registro
		       cNitEmp+;            // 02=>010:012.(Si) Nit de la Empresa que presenta la facutraci¢n
		       REPL('0',10)+;       // 03=>010:022.(Si) Nit Recuador adicional que factura conjuntamente con la principal. No usado por PlacetoPay
		       REPL('0',3)+;        // 04=>003:025.(Si) Ojo.C¢digo de la entidad financiera donde la Empresa tiene cuenta y desea que se le abone el recaudo por domiciliaci¢n. Este campo corresponde al c¢digo de tr nsito de la entidad financiera. No Usado por Placetopay
		       cFecHoy+;            // 05=>008:033.(Si) Fecha de Creaci¢n del archivo
		       cHorHoy+;            // 06=>004:037.(Si) Hora de grabaci¢n del archivo en formato de hora militar, es decir de 0001 hasta las 2400
		       'A'+;                // 07=>001:038.(Si) Modificardor de archivo. Car cter que refleja el orden cron¢logico de grabaci¢n de los archivos y permite diferenciar varios archivos generados en un mismo d¡a. Se debe empezar primero las letras may£sculas (A-Z) y posteriormente los n£meros
		       REPL(SPACE(01),182)  // 08=>182:220.(Si) Reservado. Blancos


       CASE nPagOnl == 3       // Red Multicolor

	    cNitEmp := SUBS(cNroNit+SPACE(09),1,9)
	    lCorrecion(@cNitEmp)

	    cRegIni := '0001'+;                   // Ind. Encabezado Valor fijo
		       '0001'+;                   // Valor fijo
		       cNitEmp+;                  // C¢digo de la Empresa
		       '0001'+;                   // C¢digo Interno
		       '0'+aFecHoy[3]+;           // A¤o facturaci¢n
			   aFecHoy[1]+;           // Mes facturaci¢n
			   aFecHoy[2]+;           // Dia facturaci¢n
		       REPL(SPACE(01),54)         // Filler

       CASE nPagOnl == 4       // ColPatria

	    cRegIni := ''  // No requiere registro inicial


       CASE nPagOnl == 5       // Avisor

						  // Ini:Fin:Len
	    cRegIni := '1'+;                      // 001:001:001 Registro de control
		       ''+;                       // 002:009:008 Fecha de Corte del Archivo
		       +;                         // 010:015:006 Cantidad total de registros tipo 2 en el archivo
		       ''+;                       // 016:033:018 Valor total de transacciones en el archivo
		       '0'+aFecHoy[3]+;           // 034:035:002 Identificador del ciclo de facturaci¢n
			   aFecHoy[1]+;           // 036:562:527 Espacios
			   aFecHoy[2]+;           //
		       REPL(SPACE(01),54)         // Filler
	  *ÀEncabezado

	    cRegIni := ''

       CASE nPagOnl == 7  // Pagos Virtuales - Davivienda

	    cRegIni := ''


       ENDCASE
*>>>>REGISTRO ENCABEZADO DE ARCHIVO

*>>>>GRABACION REGISTRO ENCABEZADO DE ARCHIVO
       IF !EMPTY(cRegIni)

	  IF ONL->(lRegLock(lShared,.T.))

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->cCodigoEst WITH 'INICIO'
	     REPL ONL->nPagOnlCar WITH nPagOnl
	     REPL ONL->cForPagOnl WITH cForPag
	     REPL ONL->cRegistTxt WITH cRegIni

	     REPL ONL->cNomUsrOnl WITH cNomUsr
	     REPL ONL->dFecUsrOnl WITH DATE()
	     REPL ONL->cHorUsrOnl WITH TIME()

	     ONL->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION REGISTRO ENCABEZADO DE ARCHIVO

*>>>>REGISTRO ENCABEZADO DE LOTE
       DO CASE
       CASE nPagOnl == 1       // Asobancaria 2001

	    cNitEmp := SUBS(cNroNit+SPACE(10),1,10)
	    lCorrecion(@cNitEmp)

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cRegIni := '05'+;               // 1=>002:002.(Si) Constante. Indica el tipo de registro.
		       cCodEan+;            // 2=>013:015.(Si) C¢digo del servicio facturado. C¢digo EAN13 o Nit
		       '0001'+;             // 3=>004:019.(Si) N£mero del lote. Consecutivo del lote dentro del archivo. Cada archivo tiene su propia secuencia de numeraci¢n de lotes.
		       cSerFac+;            // 4=>015:034.(Si) Nombre del servicio facturado que se le muestra al cliente receptor.
		       REPL(SPACE(01),186)  // 5=>186:220.(Si) Reservado.Filler.

       CASE nPagOnl == 2       // Asobancaria 2001. Place to Play

	    cNitEmp := SUBS(cNroNit+SPACE(10),1,10)
	    lCorrecion(@cNitEmp)

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cRegIni := '05'+;               // 1=>002:002.(Si) Constante. Indica el tipo de registro.
		       cCodEan+;            // 2=>013:015.(Si) C¢digo del servicio facturado. C¢digo EAN13 o Nit
		       '0001'+;             // 3=>004:019.(Si) N£mero del lote. Consecutivo del lote dentro del archivo. Cada archivo tiene su propia secuencia de numeraci¢n de lotes.
		       cSerFac+;            // 4=>015:034.(Si) Nombre del servicio facturado que se le muestra al cliente receptor.
		       REPL(SPACE(01),186)  // 5=>186:220.(Si) Reservado.Filler

       CASE nPagOnl == 3       // Red Multicolor

	    cRegIni := ''

       CASE nPagOnl == 4       // ColPatria

	    cRegIni := ''

       CASE nPagOnl == 5       // Avisor

	    cRegIni := ''

       CASE nPagOnl == 7  // Pagos Virtuales - Davivienda

	    cRegIni := ''

       ENDCASE
*>>>>FIN REGISTRO ENCABEZADO DE LOTE

*>>>>GRABACION REGISTRO ENCABEZADO DE LOTE
       IF !EMPTY(cRegIni)

	  IF ONL->(lRegLock(lShared,.T.))

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->nPagOnlCar WITH nPagOnl

	     REPL ONL->cCodigoEst WITH 'LOTINI'
	     REPL ONL->cForPagOnl WITH cForPag
	     REPL ONL->cRegistTxt WITH cRegIni

	     REPL ONL->cNomUsrOnl WITH cNomUsr
	     REPL ONL->dFecUsrOnl WITH DATE()
	     REPL ONL->cHorUsrOnl WITH TIME()

	     ONL->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION REGISTRO ENCABEZADO DE LOTE

*>>>>REGISTRO DETALLE
       PagOnlMtr(aP1,aP2,aP3,nMesIni,cForPag,aTotErr,;
		 aValErr,@nTotReg,@nTotOpo,@nTotExt,nPagOnl)
*>>>>FIN REGISTRO DETALLE

*>>>>REGISTRO DE CONTROL DE LOTE
       cRegIni := ''
       DO CASE
       CASE nPagOnl == 1       // Asobancaria 2001

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cRegIni := '08'+;               // 01=>002:002.(Si) Indica el tipo de registro. Constante
		       cTotReg+;            // 02=>009:011.(Si) Total registros del lote.
		       cTotOpo+;            // 03=>018:029.(Si) Valor de servicio principal. Valor de la facturaci¢n de la empresa principal
		       REPL('0',18)+;       // 04=>018:047.(No) Valor de servicio adicional.
		       '0001'+;             // 05=>004:051.(Si) Valor N£mero del lote
		       REPL(SPACE(01),169)  // 06=>169:220.(Si) Reservado. Blancos.

       CASE nPagOnl == 2       // Asobancaria 2001. Place to Pay

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cRegIni := '08'+;               // 01=>002:002.(Si) Indica el tipo de registro. Constante
		       cTotReg+;            // 02=>009:011.(Si) Total registros del lote.
		       cTotOpo+;            // 03=>018:029.(Si) Valor de servicio principal. Valor de la facturaci¢n de la empresa principal
		       REPL('0',18)+;       // 04=>018:047.(No) Valor de servicio adicional.
		       '0001'+;             // 05=>004:051.(Si) Valor N£mero del lote
		       REPL(SPACE(01),169)  // 06=>169:220.(Si) Reservado. Blancos

       CASE nPagOnl == 4       // ColPatria

	    cRegIni := ''

       CASE nPagOnl == 5       // Avisor

	    cRegIni := ''

       CASE nPagOnl == 7  // Pagos Virtuales - Davivienda

	    cRegIni := ''

       ENDCASE
*>>>>FIN REGISTRO DE CONTROL DE LOTE

*>>>>GRABACION REGISTRO CONTROL DE LOTE
       IF !EMPTY(cRegIni)

	  IF ONL->(lRegLock(lShared,.T.))

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->nPagOnlCar WITH nPagOnl

	     REPL ONL->cCodigoEst WITH 'LOTFIN'
	     REPL ONL->cForPagOnl WITH cForPag
	     REPL ONL->cRegistTxt WITH cRegIni

	     REPL ONL->cNomUsrOnl WITH cNomUsr
	     REPL ONL->dFecUsrOnl WITH DATE()
	     REPL ONL->cHorUsrOnl WITH TIME()

	     ONL->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION REGISTRO CONTROL DE LOTE

*>>>>REGISTRO FINAL
       DO CASE
       CASE nPagOnl == 1            // Asobancaria 2001

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cRegFin := '09'+;               // 01=>002:002.(Si) Indica el tipo de registro. Constante
		       cTotReg+;            // 02=>009:011.(Si) N£mero total de registros tipo "6" grabados en el archivo.
		       cTotOpo+;            // 03=>018:029.(Si) Valor total del servicio principal
		       REPL('0',18)+;       // 04=>018:047.(No) Valor total del servicio adicional.
		       REPL(SPACE(01),173)  // 06=>173:220.(Si) Reservado. Blancos.

       CASE nPagOnl == 2            // Asobancaria 2001. Place to Pay

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cRegFin := '09'+;               // 01=>002:002.(Si) Indica el tipo de registro. Constante
		       cTotReg+;            // 02=>009:011.(Si) N£mero total de registros tipo "6" grabados en el archivo.
		       cTotOpo+;            // 03=>018:029.(Si) Valor total del servicio principal
		       REPL('0',18)+;       // 04=>018:047.(No) Valor total del servicio adicional.
		       REPL(SPACE(01),173)  // 06=>173:220.(Si) Reservado. Blancos

       CASE nPagOnl == 3       // Red Multicolor

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,11,0)+'00'
	    lCorrecion(@cTotOpo)

	    cTotExt := STR(nTotExt,11,0)+'00'
	    lCorrecion(@cTotExt)

	    cRegFin := '0009'+;             // Ind. Encabezado Vr Fijo
		       cTotReg+;            // Total Registros Detalle
		       '0000'+;             // Total Reg. Borrados. Valor fijo
		       cTotOpo+;            // Total Vr Principal
		       cTotExt+;            // Total Adicional
		       REPL(SPACE(01),41)   // Espacios

       CASE nPagOnl == 4       // ColPatria

	    cRegFin := ''

       CASE nPagOnl == 5       // Avisor

	    cRegFin := ''

       CASE nPagOnl == 7  // Pagos Virtuales - Davivienda

	    cRegFin := ''

       ENDCASE
*>>>>FIN REGISTRO FINAL

*>>>>REGISTRO FINAL
       IF !EMPTY(cRegFin)
	  IF ONL->(lRegLock(lShared,.T.))

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->cCodigoEst WITH 'FINAL'
	     REPL ONL->nPagOnlCar WITH nPagOnl
	     REPL ONL->cForPagOnl WITH cForPag
	     REPL ONL->cRegistTxt WITH cRegFin

	     REPL ONL->cNomUsrOnl WITH cNomUsr
	     REPL ONL->dFecUsrOnl WITH DATE()
	     REPL ONL->cHorUsrOnl WITH TIME()

	     ONL->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF
       ENDIF
*>>>>FIN REGISTRO FINAL

*>>>>ACTUALIZACION REGISTRO INICIAL
       ONL->(DBGOTOP())

       cRegIni := ''
       DO CASE
       CASE nPagOnl == 5       // Avisor

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cTotReg := STR(nTotReg,6)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cTotExt := STR(nTotExt,16,0)+'00'
	    lCorrecion(@cTotExt)

	    cCodSer := SUBS(cCodSer,3,2)  // N£mero que identifica el servicio

				     // No=>Ini:Fin:Len.(Requerido)
	    cRegIni := '1'           // 01=>001:001:001.(S) Registro detalle
	    cRegIni += cFecHoy       // 02=>002:009:008.(S) Fecha de Corte
	    cRegIni += cTotReg       // 03=>010:015:006.(S) Cantidad total registros tipo 2
	    cRegIni += cTotOpo       // 04=>016:033:016.(S) Valor total de transacciones suma del campo ValueDate1
	    cRegIni += cCodSer	     // 05=>034:035:002.(S) 00=Cuando se maneja un solo ciclo de facturacion
	    cRegIni += SPACE(527)    // 06=>036:562:527.(S) Espacios para completar la longitud del registro


       ENDCASE
*>>>>FIN ACTUALIZACION REGISTRO INICIAL

*>>>>ACTUALIZACION REGISTRO INICIAL
       IF !EMPTY(cRegIni)

	  IF ONL->(lRegLock(lShared,.F.))

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->cRegistTxt WITH cRegIni
	     ONL->(DBCOMMIT())

	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF

       ENDIF
       RETURN NIL
*>>>>FIN ACTUALIZACION REGISTRO INICIAL


/*************************************************************************
* TITULO..: RECORRIDO DE LOS PAGOS EN LINEA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2012 VIE A
       Bucaramanga, Colombia        INICIO: 11:00 AM   SEP 21/2012 VIE

OBJETIVOS:

1- Crea los registros de los pagos facturados.

2- Retorna .T. Si no hay problemas.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PagOnlMtr(aP1,aP2,aP3,nMesIni,cForPag,aTotErr,;
		   aValErr,nTotReg,nTotOpo,nTotExt,nPagOnl)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nMesIni                              // Mes Inicial
       cForPag			            // Forma de pago
       aTotErr                              // Registro de Errores
       aValErr                              // Campos a Validar
       nTotReg                              // Total Registros
       nTotOpo                              // Total pago oporturno
       nTotExt                              // Total pago extemporaneo
       nPagOnl                              // Formato para pagos en lineas */
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

*>>>>PARAMETROS ESPECIFICOS
       LOCAL cCodSer := xPrm(aP2,'cCodSer') // C¢digo del Servicio
       LOCAL cSerFac := xPrm(aP2,'cSerFac') // Servicio Facturado.
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL nVlrInt := 0                   // Valor de los Intereses

       LOCAL cMsgErr := ''                  // Mensaje de Error
       LOCAL aRegErr := {}                  // Registro Error

       LOCAL aFecHoy := {}                  // Fecha de Proceso
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL cMesFin := ''                  // Mes Final
       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cNroRef := ''                  // N£mero de la Referencia
       LOCAL cRefPal := ''                  // Referencia principal del Usuario
       LOCAL cRefSec := ''                  // Referencia secundaria del Usuario
       LOCAL cIdeCli := ''                  // N£mero de Identificaci¢n del Cliente
       LOCAL aFecOpo := {}                  // Fecha para pago oportuno
       LOCAL cFecOpo := ''                  // Fecha para pago oportuno
       LOCAL aFecExt := {}                  // Fecha para pago extemporaneo
       LOCAL cFecExt := ''                  // Fecha para pago extemporaneo
       LOCAL cVlrOpo := ''                  // Valor Oportuno
       LOCAL cVlrInt := ''                  // Valor de los Intereses
       LOCAL cVlrExt := ''                  // Valor Extemporaneo

       LOCAL cVlrPag := ''                  // Valor a pagar
       LOCAL cFecPag := ''                  // Fecha de pago

       LOCAL cRegTxt := ''                  // Registro en texto
       LOCAL cRegUsr := ''                  // Registro en texto

       LOCAL aVlrCon := {}                  // Valores por conceptos
       LOCAL nVlrMes := 0                   // Valor del Mes
       LOCAL nVlrOpo := 0                   // Valor Oportuno
       LOCAL nVlrAde := 0                   // Valor por adelantado

       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cNomFac := ''                  // Nombre para el Recibo
       LOCAL cDocNit := ''                  // Documento del que paga

       LOCAL cCodOnl := ''                  // C¢digo Asignado pago en l¡nea

       LOCAL cNombre := ''                  // Nombre del Estudiante
       LOCAL cApelli := ''                  // Apellidos del Estudiante
       LOCAL cDescri := ''                  // Descripci¢n

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cApelliTes := ''               // Apellidos del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR PAGOS
       cCodSer := ALLTRIM(cCodSer)
       cSerFac := ALLTRIM(cSerFac)

       SELECT PAG
       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SELECT PAG
	    LineaEstados('REGISTRO No. '+PAG->(STR(RECNO(),4))+'/'+;
			  PAG->(STR(RECCOUNT(),4)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE DECISION
	    IF PAG->cMatricPag # '1' // Diferente a matricula
	       PAG->(DBSKIP())
	       LOOP
	    ENDIF

	    IF PAG->nVlrPagPag == 0
	       PAG->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********ANALISIS DEL RECIBO PAGADO
	    IF !EMPTY(PAG->dFecPagPag) .AND.;
	       (PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A')

	       PAG->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DEL RECIBO PAGADO

**********ANALISIS DE DECISION
	    IF nPagOnl # 5 .AND.; // Avisor
	       nPagOnl # 7	  // Pagos Virtuales - Davivienda

	      PAG->(DBSKIP())
	      LOOP

	    ENDIF
**********FIN ANALISIS DE DECISION

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(PAG->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	    IF !lHayAlu

	       IF !lLocCodigo('cCodigoEst','ADM',PAG->cCodigoEst)
		  PAG->(DBSKIP())
		  LOOP
	       ENDIF

	       cNombreTes := RTRIM(ADM->cNombreEst)
	       cApelliTes := RTRIM(ADM->cApelliEst)

	       cNomFac := cNomFacMae('ADM',1)
	       cDocNit := cNitFacMae('ADM',1)

	    ELSE
	       cNombreTes := ALLTRIM(&cMaeAct->cNombreEst)
	       cApelliTes := ALLTRIM(&cMaeAct->cApelliEst)

	       cNomFac := cNomFacMae(cMaeAct,1)
	       cDocNit := cNitFacMae(cMaeAct,1)

	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********CALCULO DE LOS INTERESES
	    nVlrInt := 0
	    IF PAG->lIntPenPag
	       nVlrInt  := ROUND((PAG->nVlrMesPag*PAG->nIntmorPag)/100,0)
	    ELSE
	       nVlrInt := PAG->nVlrMorPag
	    ENDIF
**********FIN CALCULO DE LOS INTERESES

**********DETALLES DE LA FACTURACION
	    cMesIni := STR(PAG->nMesIniPag,2)
	    lCorrecion(@cMesIni)

	    cMesFin := STR(PAG->nMesFinPag,2)
	    lCorrecion(@cMesFin)

	    cCodEmp := STR(SCO->nCodEmpCon,2)
	    lCorrecion(@cCodEmp)

	    cNroFac := STR(PAG->nNroFacAno,8)
	    lCorrecion(@cNroFac)

	    cCodFac := PAG->cCodigoEst+cMesIni+cMesFin

	    aFecHoy := aFecha(DATE())
	    aFecOpo := aFecha(PAG->dPagOpoPag)
	    aFecExt := aFecha(PAG->dPagExtPag)


	    cRegTxt := ''
	    cRegUsr := ''
	    DO CASE
	    CASE nPagOnl == 1       // Asobancaria 2001
	    CASE nPagOnl == 2       // Asobancaria 2001. Place to Play
	    CASE nPagOnl == 3       // Red Multicolor
	    CASE nPagOnl == 4       // ColPatria
	    CASE nPagOnl == 5       // Avisor


		 cCodOnl := SUBS(cCodOnl,1,35)
		 cCodSer := SUBS(cCodSer,1,35)

		 cRefPal := cCodFac+REPL(' ',70)
		 cRefSec := PAG->cCodigoEst+REPL(' ',74)

		 cFecOpo := aFecOpo[3]+aFecOpo[1]+aFecOpo[2]
		 cFecExt := aFecExt[3]+aFecExt[1]+aFecExt[2]
	       *ÀAAAAMMDD

		 cVlrOpo := STR(PAG->nVlrPagPag,16,0)+'00'
		 lCorrecion(@cVlrOpo)
		 nVlrOpo := PAG->nVlrPagPag

		 cVlrExt := STR(PAG->nVlrPagPag+nVlrInt,16,0)+'00'
		 lCorrecion(@cVlrExt)

					  // No=>Ini:Fin:Len.(Requerido)
		 cRegTxt := '2'           // 01=>001:001:001.(S) Registro detalle
		 cRegTxt += cCodOnl	  // 02=>002:036:035.(S) C¢digo interno de entidad asignado por Avisor
		 cRegTxt += cCodSer	  // 03=>037:071:035.(S) C¢digo interno asignado por la Empresa para clasificar el servicio que se factura
		 cRegTxt += cRefSec	  // 04=>072:151:080.(S) Primer referencia
		 cRegTxt += cRefPal	  // 05=>152:231:080.(N) Segunda referencia
		 cRegTxt += SPACE(80)	  // 06=>232:311:080.(N) Tercera referencia
		 cRegTxt += SPACE(40)	  // 07=>312:351:040.(N) C¢digo de ¡tem cuando el servicio es de tipo Estado de cuenta
		 cRegTxt += SPACE(80)	  // 08=>352:431:040.(N) Descripci¢n de ¡tem cuando el servicio es de tipo Estado de cuenta
		 cRegTxt += '0'		  // 09=>432:432:001.(S) Nota d‚bito(= 0 Deuda del usuario) o cr‚dito(= 1 A favor del Usuario)
		 cRegTxt += cFecOpo	  // 10=>433:440:008.(S) Primera fecha de vencimiento
		 cRegTxt += cVlrOpo	  // 11=>441:458:018.(S) Valor primera fecha
		 cRegTxt += cFecExt	  // 12=>459:466:008.(N) Segunda fecha vencimiento
		 cRegTxt += cVlrExt	  // 13=>467:484:018.(N) Valor segunda fecha
		 cRegTxt += REPL('0',8)	  // 14=>485:492:008.(N) Tercera fecha de vencimiento
		 cRegTxt += REPL('0',18)  // 15=>493:510:018.(N) Valor tercera fecha
		 cRegTxt += REPL('0',8)	  // 14=>511:518:008.(N) Cuarta fecha de vencimiento
		 cRegTxt += REPL('0',18)  // 15=>519:536:018.(N) Valor cuarta fecha
		 cRegTxt += REPL('0',8)	  // 14=>537:544:008.(N) Quinta fecha de vencimiento
		 cRegTxt += REPL('0',18)  // 15=>545:562:018.(N) Valor quinta fecha


		 cNombre := SUBS(cNombreTes+SPACE(50),1,50)
		 cApelli := SUBS(cApelliTes+SPACE(50),1,50)

					  // No=>Ini:Fin:Len.(Requerido)
		 cRegUsr := cRefSec       // 01=>001:080:080.(S) Identifica al usuario autorizado.Debe corresponder con el campo Reference1 del archivo de entrada
		 cRegUsr += '01'          // 02=>081:082:002.(S) Indicador del tipo de usuario
		 cRegUsr += REPL(' ',35)  // 03=>083:117:035.(N) Segundo criterio de autenticaci[on del usuario para ingresar a efectuar pagos
		 cRegUsr += REPL('0',02)  // 04=>118:119:002.(N) Tipo de identificaci¢n
		 cRegUsr += cNombre       // 05=>120:169:050.(S) Nombre del Usuario
		 cRegUsr += cApelli       // 06=>170:219:050.(S) Apellido del Usuario
		 cRegUsr += REPL(' ',50)  // 07=>220:269:050.(N) mail
		 cRegUsr += REPL(' ',80)  // 08=>270:349:080.(N) Direcci¢n
		 cRegUsr += REPL(' ',50)  // 09=>350:399:050.(N) Ciudad
		 cRegUsr += REPL(' ',50)  // 10=>400:449:050.(N) Telefono
		 cRegUsr += REPL(' ',80)  // 11=>450:529:080.(N) *N£mero del periodo al cual pertenece
		 cRegUsr += '  '          // 12=>530:531:002.(N) Rol del usuario
		 cRegUsr += ' '           // 13=>532:532:001.(N) Tipo de Persona

	    CASE nPagOnl == 7             // Pagos Virtuales - Davivienda

		 cDescri := 'RECIBO DE '+;
			    ALLTRIM(cSerFac)+' '+;
			    cAnoUsr
			    

		 cVlrOpo := ALLTRIM(STR(PAG->nVlrPagPag,10,0))
		 cVlrOpo := cVlrOpo
		 nVlrOpo := PAG->nVlrPagPag

		 cFecOpo := aFecOpo[2]+'/'+aFecOpo[1]+'/'+aFecOpo[3]
	       *ÀDDMMAAAA

		 cVlrExt := ALLTRIM(STR(PAG->nVlrPagPag+nVlrInt,10,0))
		 cVlrExt := cVlrExt


		 cFecExt := aFecExt[2]+'/'+aFecExt[1]+'/'+aFecExt[3]
	       *ÀDDMMAAAA

		 cRegTxt := cCodFac+ALLTRIM(cCodSer)+cAnoSis+'|'+;                    // 01. ID_UNICO_PAGO
			    PAG->cCodigoEst+'|'+;                                     // 02. ID_CLIENTE
			    cVlrOpo+'|'+;	                                      // 03. VALOR_CON_IVA
			    '0|'+;                                                    // 04. VALOR_IVA
			    cDescri+'.PAGO OPORTUNO|'+;                               // 05. CONCEPTO
			    cFecOpo+'|'+;                                             // 06. FECHA_VENCIMIENTO
			    ' |'+;	                                              // 07. EMAIL
			    ' |'+;	                                              // 08. CLAVE_PAGO
			    ALLTRIM(cNombreTes)+'|'+;                                 // 09. NOMBRE
			    ALLTRIM(cApelliTes)+'|'+;                                 // 10. APELLIDO
			    ' |'+;	                                              // 11. TELEFONO
			    PAG->cCodigoGru+'|'+;                                     // 12. CAMPO_OPCIONAL1
			    cCodFac+cAnoUsr+ALLTRIM(cCodSer)+cNroFac+'|'+;            // 13. CAMPO_OPCIONAL2
			    ALLTRIM(BAN->cValCtaBan)+'|'+;                            // 14. CAMPO_OPCIONAL3
			    cFecExt+'|'+;		                              // 15. FECHA EXTEMPORANEO
			    cVlrExt+'|'+;                                             // 16. VALOR EXTEMPORANEO. VALOR CON IVA 2
			    '0|'+;                                                    // 17. VALOR_IVA 2
			    cDescri+'.PAGO EXTEMPORANEO'                              // 18. CONCEPTO 2


	    ENDCASE
**********DETALLES DE LA FACTURACION

**********GRABACION DEL PAGO
	    IF ONL->(lRegLock(lShared,.T.))

	       REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	       REPL ONL->nPagOnlCar WITH nPagOnl

	       REPL ONL->cCodigoEst WITH PAG->cCodigoEst
	       REPL ONL->cCodigoGru WITH PAG->cCodigoGru
	       REPL ONL->nMesIniPag WITH PAG->nMesIniPag
	       REPL ONL->nMesFinPag WITH PAG->nMesFinPag
	       REPL ONL->cForPagOnl WITH cForPag
	       REPL ONL->nVlrOpoPag WITH nVlrOpo
	       REPL ONL->nVlrExtPag WITH PAG->nVlrPagPag+nVlrInt
	       REPL ONL->dFecFacPag WITH PAG->dFecFacPag
	       REPL ONL->dPagOpoPag WITH PAG->dPagOpoPag
	       REPL ONL->dPagExtPag WITH PAG->dPagExtPag
	       REPL ONL->nNroFacCaA WITH VAL(cNroFac)
	       REPL ONL->nIntMorPag WITH PAG->nIntMorPag
	       REPL ONL->nVlrMorPag WITH PAG->nVlrMorPag
	       REPL ONL->cConcepPag WITH PAG->cConcepPag

	       REPL ONL->cNombreEst WITH cNombreTes
	       REPL ONL->cApelliEst WITH cApelliTes


	       REPL ONL->cRegistTxt WITH cRegTxt
	       REPL ONL->cRegUsrTxt WITH cRegUsr


	       REPL ONL->cNomUsrOnl WITH cNomUsr
	       REPL ONL->dFecUsrOnl WITH DATE()
	       REPL ONL->cHorUsrOnl WITH TIME()

	       nTotReg++
	       nTotOpo += ONL->nVlrOpoPag
	       nTotExt += ONL->nVlrExtPag

	       ONL->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	    ENDIF
	    IF lShared
	       ONL->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL PAGO

	  SELECT PAG
	  PAG->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR PAGOS