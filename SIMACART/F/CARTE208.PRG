/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: COBROS                                   MODULO No. 208

**************************************************************************
* TITULO..: INTERFAZ CONTABLE                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2013 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   OCT 01/2013 MAR


OBJETIVOS:

1- Visualiza el men£ de la interfaz Contable

2- Ejecuta las diferentes opciones del menu.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_208(aParam1,aParam2,aParam3,;
		   cEmpCob)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro de la Cartera */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-FACT.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL nMesIni := 0                   // Mes Inicial del pago
       LOCAL cNroMes := ''                  // N£mero del Mes

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
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
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
       lPrnArc := SCA->lPrnArcCar
       nCodPrn := SCA->nCodigoPrn
       cOpcPrn := SCA->cOpcPrnCar
       CloseAll()
*>>>>FIN LOCALIZACION DE LA IMPRESORA


*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus  := {}
       AADD(aMenus,"1<MOVIMIENTOS      >")
       AADD(aMenus,"2<CUENTA T         >")
       AADD(aMenus,"3<CUENTAS CONTABLES>")
       AADD(aMenus,"4<CONCILIACIONES   >")

       aAyuda  := {}
       AADD(aAyuda,'Permite Consultar los movimienstos contables')
       AADD(aAyuda,'Permite Consultar la Cuent T Contable')
       AADD(aAyuda,'Permite Consultar las cuentas contables')
       AADD(aAyuda,'Permite Consultar las conciliaciones')
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-1,nColInf+2,NIL,NIL,nNroOpc,.F.)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1

***************SELECCION DEL MES
		 cSavPan := SAVESCREEN(0,0,24,79)
		 nMesIni := 0
		 nMesIni := nMesano(nFilInf+5,15,'Mes de los Movimientos',.T.)
		 RESTSCREEN(0,0,24,79,cSavPan)

		 IF nMesIni == 0
		    CloseAll()
		    RETURN NIL
		 ENDIF
		 cNroMes := STR(nMesIni,2)
		 lCorrecion(@cNroMes)
		 FileMvt := 'MOVIMI'+cNroMes+ExtFile
***************FIN SELECCION DEL MES

***************VALIDACION DEL ARCHIVO
		 IF !FILE(cPatSis+'\MOVIM'+'\'+FileMvt)
		    CreaDbfMvt(lShared,nModCry,cPatSis+'\MOVIM',FileMvt)
		 ENDIF
		 nActStrMvt(lShared,nModCry,cPatSis+'\MOVIM',FileMvt)
***************FIN VALIDACION DEL ARCHIVO

***************MANTENIMIENTO DEL ARCHIVO
		 lModReg := .T.
		 lDelReg := .F.
		 lInsReg := .T.
		 lHaySql := .F.

		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{cPatSis+'\MOVIM'+'\'+FileMvt,NIL,'MVT'})

		 AADD(aArchvo,{cIntUno+'\'+PathSis+'\'+fSimaCo,NIL,'SCO'})

		 IF 'JAR' $ cMaeAlu
		    cNalias := 'JAR'
		    AADD(aArchvo,{cIntUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  cIntUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF

		 IF 'PRI' $ cMaeAlu
		    cNalias := 'PRI'
		    AADD(aArchvo,{cIntUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  cIntUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF

		 IF 'BTO' $ cMaeAlu
		    cNalias := 'BTO'
		    AADD(aArchvo,{cIntUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  cIntUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF


		 AADD(aArchvo,{cIntUno+'\'+cPatSis+'\'+;
			       FileGru+'POS'+cAnoSis+ExtFile,NIL,'GRU'})

		 AADD(aArchvo,{PathSis+'\'+fSimCar,NIL,'SCA'})
		 AADD(aArchvo,{cPatSis+'\'+;
			       fCarAno+cAnoUsr+ExtFile,NIL,'CAA'})
		 AADD(aArchvo,{cPatSis+'\'+FileCon,NIL,'CON'})
		 AADD(aArchvo,{cPatSis+'\'+FileDes,NIL,'DES'})
		 AADD(aArchvo,{cPatSis+'\'+FileTar,NIL,'TAR'})
		 AADD(aArchvo,{cPatSis+'\'+FileCnc,NIL,'CNC'})

		 MantenMvt(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			   cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			   cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
			   cPatSis,cMaeAlu,nMesIni)
***************FIN MANTENIMIENTO DEL ARCHIVO


	  CASE nNroOpc == 2

***************MANTENIMIENTO DEL ARCHIVO
		 lModReg := .F.
		 lDelReg := .F.
		 lInsReg := .T.
		 lHaySql := .F.

		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{cPatSis+'\'+FileCtt,NIL,'CTT'})

		 MantenCtt(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			   cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			   cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql)
***************FIN MANTENIMIENTO DEL ARCHIVO


	  CASE nNroOpc == 3
	       MantenPuc(aParam1,aParam2,aParam3,'1234')
	      *Mantenimientos del Archivo de Cuentas del Puc


	  CASE nNroOpc == 4

***************MANTENIMIENTO DEL ARCHIVO
		 lModReg := .T.
		 lDelReg := .F.
		 lInsReg := .T.
		 lHaySql := .F.


		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{cPatSis+'\'+FileCnc,NIL,'CNC'})

		 MantenCnc(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			   cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			   cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
			   cPatSis,cMaeAlu)
***************FIN MANTENIMIENTO DEL ARCHIVO

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA