/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: MANTENIMIENTOS

**************************************************************************
* TITULO..: MENU DE MATENIMIENTO ARCHIVOS DEL SISTEMA                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 06/1996 VIE A
       Colombia, Bucaramanga        INICIO: 12:30 PM   SEP 06/1996 VIE

OBJETIVOS:

1- Visualiza un men£ de los archivos a realizarle el mantenimiento

2- Ejecuta las diferentes funciones del mantemiento

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_705(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

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

       LOCAL lPrueba := .F.                 // .T. Pruebas
       LOCAL cValNot := ''                  // Validaci¢n de los Juicios
     *ÀVariables especificas

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
       aParams := aParams(aP1,aP2,aP3)
       IF  !lParam0102(aParams,;
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CON->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPrnArc := CON->lPrnArcCon
       nCodPrn := CON->nCodigoPrn
       cOpcPrn := CON->cOpcPrnCon
       lPrueba := CON->lPruebaCon
       cValNot := TCO->cValNotTbl
       CloseAll()
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus := {}
       AADD(aMenus,'1<TABLA DE APROBACION  >')
       AADD(aMenus,'2<CLASE DE INDICADORES >')
       AADD(aMenus,'3<TABLA DE EVALUACIONES>')
       AADD(aMenus,'4<ARCHIVO DE NOTAS     >')
       AADD(aMenus,'5<TABLA DE ORGANIZACION>')
       AADD(aMenus,'6<ASIGNACION ACADEMICA >')
       AADD(aMenus,'7<JUICIOS VALORATIVOS  >')

*       AADD(aMenus,'8<PRUEBAS              >')

       aAyuda := {}
       AADD(aAyuda,'Permite el Mantenimiento de la tabla de Aprobaciones')
       AADD(aAyuda,'Permite el Mantenimiento de la clase de Indicadores')
       AADD(aAyuda,'Permite el Mantenimiento de la tabla de Evaluaciones')
       AADD(aAyuda,'Permite el Mantenimiento de Notas')
       AADD(aAyuda,'Permite el Mantenimiento de la tabla de Organizaci¢n')
       AADD(aAyuda,'Permite realizar cambios en la asignaci¢n Acad‚mica')
       AADD(aAyuda,'Permite el Mantenimiento del Juicio Valorativo')

*       AADD(aAyuda,'Prueba de Lectura')
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-2,nColInf,NIL,NIL,nNroOpc)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       MantenApr(aP1,aP2,aP3)
	      *Mantenimiento Tabla de Aprobaciones

	  CASE nNroOpc == 2

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
		 AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
		 AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+FileCla,NIL,'CLA'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := .T.
		  lDelReg := .T.
		  lInsReg := .T.
		  lHaySql := .F.
		  bInsReg := NIL

		  MantenCla(aP1,aP2,aP3,;
			    aArchvo,cOpcPrn,nCodPrn,lModReg,;
			    lDelReg,lInsReg,lHaySql,bInsReg)
		*ÀClase de Indicadores
***************FIN MANTENIMIENTO DEL ARCHIVO

	  CASE nNroOpc == 3
	       ManTblEva(aP1,aP2,aP3)
	      *Mantenimiento Tabla de Evaluaciones

	  CASE nNroOpc == 4

	       HayCamJnt(lShared,cAnoUsr,cPatSis,cMaeAlu,.T.)

	       MantenNot(aP1,aP2,aP3)
	      *Mantenimiento Archivo de Notas

	  CASE nNroOpc == 5
	       MantenOrg(aP1,aP2,aP3)
	      *Mantenimiento Tabla de Organizaci¢n

	  CASE nNroOpc == 6
	       Conta_756(aP1,aP2,aP3)
	      *Asignaci¢n Acad‚mica

	  CASE nNroOpc == 7

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+FileJvf,NIL,'JVF'})
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		 lModReg := .T.
		 lDelReg := lPrueba
		 lInsReg := .T.
		 lHaySql := lPrueba

		 MantenJvf(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
			   cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
			   aArchvo,lPrnArc,cOpcPrn,nCodPrn,;
			   lModReg,lDelReg,lInsReg,lHaySql,;
			   cMaeAct,cValNot)
***************FIN MANTENIMIENTO DEL ARCHIVO

/*
	  CASE nNroOpc == 8
	       Conta_758(aP1,aP2,aP3)
	      *Prueba
*/

	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA