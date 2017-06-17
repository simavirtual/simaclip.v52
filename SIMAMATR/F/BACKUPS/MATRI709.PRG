/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: VARIOS                                  MODULO No. 708

**************************************************************************
* TITULO..: MENU UTILIDADES VARIOS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 03/98 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 AM   NOV 03/98 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza un men£ de utilidades varios

2- Ejecuta las diferentes funciones


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_709(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroCol := 0                   // N£mero de Columna

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL nPrueba := 0                   // Activar Pruebas Pruebas
     *ÀVariables de mantenimiento

       LOCAL lSisben := .F.                 // .T. Hay Sisben
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
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

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0101(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
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
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPrnArc := MTR->lPrnArcMtr
       nCodPrn := MTR->nCodigoPrn
       cOpcPrn := MTR->cOpcPrnMtr
       nPrueba := MTR->nPruebaMtr

       lSisben := ANO->lSisbenAno
       CloseAll(aUseDbf)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus := {}
       AADD(aMenus,'1<NOTAS EVALUACIONES>')
       AADD(aMenus,'2<NOTAS ENTREVISTAS >')
       AADD(aMenus,'3<LIMITE DE CUPOS   >')
       AADD(aMenus,'4<CREAR TARIFAS     >')
       AADD(aMenus,'5<EJECUTAR          >')
       AADD(aMenus,'6<DIGITO DE CHEQUEO >')
       AADD(aMenus,'7<CONTROL DE RECIBOS>')
       AADD(aMenus,'8<CAMBIAR DE GRADO  >')
       IF lSisben
	  AADD(aMenus,'9<SISBEN            >')
       ENDIF

       aAyuda := {}
       AADD(aAyuda,'Permite Definir el n£mero de notas para las evaluaciones')
       AADD(aAyuda,'Permite Definir el n£mero de notas para las entrevistas')
       AADD(aAyuda,'Permite Definir la cantidad de cupos para cada nivel')
       AADD(aAyuda,'Permite Crear la tabla con los valores de los conceptos')
       AADD(aAyuda,'Permite Ejecutar ciertas funciones espec¡ficas')
       AADD(aAyuda,'Permite calcular el digito de Chequeo seg£n algor¡tmos especificado')
       AADD(aAyuda,'Permite Consultar el Control de los Recibos Impresos')
       AADD(aAyuda,'Permite Cambiar de Grado a un Estudiante')
       IF lSisben
	  AADD(aAyuda,'Permite el mantenmiento de los registros del Sisben')
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

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

	  IF lSisben
	     nNroOpc := nMenu(aMenus,aAyuda,nFilInf-2,nNroCol,;
			      NIL,NIL,nNroOpc,.F.)
	  ELSE
	     nNroOpc := nMenu(aMenus,aAyuda,nFilInf,nNroCol,;
			      NIL,NIL,nNroOpc,.F.)
	  ENDIF

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Matri_791(aParam1,aParam2,aParam3)
	      *Notas Examenes

	  CASE nNroOpc == 2
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Matri_792(aParam1,aParam2,aParam3)
	      *Notas Entrevistas

	  CASE nNroOpc == 3
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Matri_793(aParam1,aParam2,aParam3)
	      *Limite de cupos

	  CASE nNroOpc == 4
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenTar(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			 cPatSis,PathUno,PathDos,PathTre,PathCua,;
			 cMaeAlu,cMaeAct,cJorTxt)
	       RESTSCREEN(0,0,24,79,cSavPan)
	      *Crear Tarifas

	  CASE nNroOpc == 5
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Matri_795(aParam1,aParam2,aParam3)
	      *Mezclar Grupos

	  CASE nNroOpc == 6
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Matri_796(aParam1,aParam2,aParam3)
	      *Digito de Chequeo

	  CASE nNroOpc == 7
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenRec(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,PathUno,PathDos,;
			 PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt)
	       RESTSCREEN(0,0,24,79,cSavPan)
	      *Mantenimiento Control de Recibos

	  CASE nNroOpc == 8
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Matri_608(aParam1,aParam2,aParam3,.T.)
	       RESTSCREEN(0,0,24,79,cSavPan)
	      *Cambiar el Grado de un Estudiante

	  CASE nNroOpc == 9

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{cPatSis+'\'+FileSib,NIL,'SIB'})

		 IF 'JAR' $ cMaeAlu
		    cMaeAct := 'JAR'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				  FileAlu+cMaeAct+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				  fNtxAlu+cMaeAct+cAnoSis+cExtNtx,;
				  cMaeAct})
		 ENDIF

		 IF 'PRI' $ cMaeAlu
		    cMaeAct := 'PRI'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				  FileAlu+cMaeAct+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				  fNtxAlu+cMaeAct+cAnoSis+cExtNtx,;
				  cMaeAct})
		 ENDIF

		 IF 'BTO' $ cMaeAlu
		    cMaeAct := 'BTO'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				  FileAlu+cMaeAct+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				  fNtxAlu+cMaeAct+cAnoSis+cExtNtx,;
				  cMaeAct})
		 ENDIF


***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := .T.
		  lDelReg := .T.
		  lInsReg := .T.
		  lHaySql := .F.

		  MantenSib(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
			    cMaeAlu,cMaeAct)
***************FIN MANTENIMIENTO DEL ARCHIVO


	  ENDCASE

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA