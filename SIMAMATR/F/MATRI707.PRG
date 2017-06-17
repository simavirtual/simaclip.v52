/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: UTILIDADES                               MODULO No. 707

**************************************************************************
* TITULO..: MENU DE MATENIMIENTO ARCHIVOS DEL SISTEMA                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 03/1998 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 AM   NOV 03/1998 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza un men£ de los archivos a realizarle el mantenimiento

2- Ejecuta las diferentes funciones del mantemiento


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_707(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

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
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       aMenus := {'1<BANCOS           >',;
		  '2<CONCEPTOS        >',;
		  '3<NIVELES          >',;
		  '4<GRUPOS           >',;
		  '5<PAGOS            >',;
		  '6<PERSONAS         >',;
		  '7<CONTRATANTES     >',;
		  '8<TIPO RECIBOS     >',;
		  '9<TIPO OBSERVACINES>'}

       aAyuda := {'Realiza el Mantenimiento del archivo Bancos',;
		  'Realiza el Mantenimiento del archivo Conceptos',;
		  'Realiza el Mantenimiento del archivo Niveles',;
		  'Realiza el Mantenimiento del archivo Pagos',;
		  'Realiza el Mantenimiento del archivo Grupos',;
		  'Realiza el Mantenimiento del archivo Pagos',;
		  'Realiza el Mantenimiento de las Personas',;
		  'Realiza el Mantenimiento de los Contratantes',;
		  'Realiza el Mantenimiento de los Tipos de Recibos',;
		  'Realiza el Mantenimiento de los Tipos de Observaciones'}
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       nNroCol := nColInf
       IF nColInf + nLenOpc + 2 > 78
	  nNroCol := 78-nLenOpc
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-2,nNroCol,NIL,NIL,nNroOpc,.F.)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       MantenBan(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			 cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
			 cMaeAlu,cJorTxt,cMaeAct)
	      *Mantenimiento del archivo Bancos

	  CASE nNroOpc == 2
	       MantenCon(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			 cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
			 cMaeAlu,cJorTxt,cMaeAct)
	      *Mantenimiento del archivo Conceptos

	  CASE nNroOpc == 3
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenNiv(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			 cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
			 cMaeAlu,cJorTxt,cMaeAct)
	      *Mantenimiento del archivo Niveles


	  CASE nNroOpc == 4
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenGru(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			 cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
			 cMaeAlu,cJorTxt,cMaeAct)
	      *Mantenimiento del archivo Grupos

	  CASE nNroOpc == 5
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenPag(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			 cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
			 cMaeAlu,cMaeAct,cJorTxt)
	      *Mantenimiento del archivo Pagos

	  CASE nNroOpc == 6
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Matri_776(aParam1,aParam2,aParam3)
	      *Mantenimiento de las Personas

	  CASE nNroOpc == 7
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Matri_777(aParam1,aParam2,aParam3)
	      *Mantenimiento de los Contratantes

	  CASE nNroOpc == 8

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{cPatSis+'\'+FileTrc,NIL,'TRC'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := IF(nPrueba # 0,.T.,.F.)
		  lDelReg := .F.
		  lInsReg := .T.
		  lHaySql := .F.

		  MantenTrc(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql)
***************FIN MANTENIMIENTO DEL ARCHIVO

	  CASE nNroOpc == 9

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{cPatSis+'\'+FileTob,NIL,'TOB'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := .T.
		  lDelReg := .T.
		  lInsReg := .T.
		  lHaySql := .F.

		  MantenTob(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql)
***************FIN MANTENIMIENTO DEL ARCHIVO


	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA