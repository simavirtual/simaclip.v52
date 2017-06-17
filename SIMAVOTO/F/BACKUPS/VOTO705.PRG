/* SIMA - SIMA - SISTEMA DE VOTACION DEL GOBIERNO ESCOLAR

MODULO      : UTILIDADES
SUBMODULO...: MANTENIMIENTO

**************************************************************************
* TITULO..: MANTENIMIENTO DEL SISTEMA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Visualiza un men£ de Utilidades Mantenimiento

2- Ejecuta las diferentes opciones

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Voto_705(aP1,aP2,aP3)

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
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL       i := 0                   // Contador
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

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimVot,'VOT',NIL,lShared,nModCry})
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
       CASE VOT->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       nPrueba := VOT->nPruebaVot
       lPrnArc := VOT->lPrnArcVot
       nCodPrn := VOT->nCodigoPrn
       cOpcPrn := VOT->cOpcPrnVot
       cUsrIso := VOT->cUsrIsoVot
       nCodXsl := VOT->nCodXslVot
       cPiePag := VOT->cPiePagVot

       CloseDbf('VOT')
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DECLARACION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus := {}
       AADD(aMenus,'1<ESTUDIANTES>')
       AADD(aMenus,'2<PROFESORES >')

       aAyuda := {}
       AADD(aAyuda,'Permite consultar los Estudiantes')
       AADD(aAyuda,'Permite consultar los Profesores')
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

	  CASE nNroOpc == 1  // Estudiantes

***************SELECCION DEL NIVEL
		 RESTSCREEN(0,0,24,79,cSavPan)

		 cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
		 nParameSet(aP1,'cMaeAct',cMaeAct)
***************FIN SELECCION DEL NIVEL

***************AREAS DE TRABAJO
		 aArchvo := {}

		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
		 AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})

		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileAlu+cMaeAct+cAnoSis+ExtFile,NIL,cMaeAct})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		 lModReg := IF(nPrueba==0,.F.,.T.)
		 lDelReg := IF(nPrueba==0,.F.,.T.)
		 lInsReg := IF(nPrueba==0,.F.,.T.)
		 lHaySql := IF(nPrueba==0,.F.,.T.)
		 bInsReg := NIL

		 ManAluVot(aP1,aP2,aP3,aArchvo,cOpcPrn,;
			   nCodPrn,lModReg,lDelReg,;
			   lInsReg,lHaySql,bInsReg)
***************FIN MANTENIMIENTO DEL ARCHIVO

	  CASE nNroOpc == 2  // Profesores

***************AREAS DE TRABAJO
		 aArchvo := {}

		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
		 AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})

		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+;
			       FilePro+cAnoSis+ExtFile,NIL,'PRO'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		 lModReg := IF(nPrueba==0,.F.,.T.)
		 lDelReg := IF(nPrueba==0,.F.,.T.)
		 lInsReg := IF(nPrueba==0,.F.,.T.)
		 lHaySql := IF(nPrueba==0,.F.,.T.)
		 bInsReg := NIL

		 ManProVot(aP1,aP2,aP3,aArchvo,cOpcPrn,;
			   nCodPrn,lModReg,lDelReg,;
			   lInsReg,lHaySql,bInsReg)
***************FIN MANTENIMIENTO DEL ARCHIVO

	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA