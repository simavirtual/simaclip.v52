/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: VARIOS                 MODULO No. 707

**************************************************************************
* TITULO..: MENU DE VARIOS                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 21/99 MIE A
       Colombia, Bucaramanga        INICIO: 12:30 PM   ABR 21/99 MIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza un men£ varios de otras utilidades.

2- Ejecuta las diferentes funciones del mantemiento


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_707(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

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
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared,nModCry})
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
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       nPrueba := SCO->nPruebaSco
       lPrnArc := SCO->lPrnArcCon
       nCodPrn := SCO->nCodigoPrn
       cOpcPrn := SCO->cOpcPrnCon
       cUsrIso := SCO->cUsrIsoSco
       nCodXsl := SCO->nCodXslSco
       cPiePag := SCO->cPiePagSco
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       AADD(aMenus,'1<NUMERO DE LISTA >')
       AADD(aMenus,'2<PROMOCIONES     >')
       AADD(aMenus,'3<NRO INDICADORES >')
       AADD(aMenus,'4<INDICADORES     >')

/*
       AADD(aMenus,'2<HORARIO DE CLASE>')
       AADD(aMenus,'3<DIVISION HORAS  >')
       AADD(aMenus,'4<FUNCIONES       >')


*       AADD(aMenus,'6<INDICADORES     >')
*/

       AADD(aAyuda,'Permite consultar y modificar los n£mero de lista')
       AADD(aAyuda,'Actualiza los c¢digos de promoci¢n en el maestro de Estudiantes')
       AADD(aAyuda,'Consulta el control del Total de Indicadores')
       AADD(aAyuda,'Consulta los Indicadores')

/*
       AADD(aAyuda,'Permite consultar y modificar el Horario de Clase')
       AADD(aAyuda,'Permite realizar la Divisi¢n de la Horas para el Horario')
       AADD(aAyuda,'Permite Definir las Funciones del Personal')
*/


*       AADD(aAyuda,'Permite trasladar los indicadores'}
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

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,nNroOpc,.F.)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       RESTSCREEN(0,0,24,79,cSavPan)
	       ManNroLis(aP1,aP2,aP3)
	      *Mantenimiento de N£mero de lista.

	  CASE nNroOpc == 2
	       RESTSCREEN(0,0,24,79,cSavPan)
	       AproboMae(aP1,aP2,aP3)

	  CASE nNroOpc == 3

***************ANALISIS DE DECISION
		 cError('DEBE GARANTIZAR QUE NINGUN USUARIO ESTE '+;
			'UTILIZANDO EL SIMA')

		 IF !lPregunta('ESTA SEGURO QUE NINGUN USUARIO '+;
			       'ESTA UTILIZANDO EL SIMA? No Si')
		    LOOP
		 ENDIF

		 IF !lPregunta('REALIZO COPIA DE SEGURIDAD? No Si')
		    cError('DEBE SACAR COPIA SEGURIDAD')
		    cError('SE ABANDONA EL PROCESO')
		    LOOP
		 ENDIF
		 IF !lPregunta('DESEA CONTINUAR? No Si')
		    cError('SE ABANDONA EL PROCESO')
		    LOOP
		 ENDIF
***************FIN ANALISIS DE DECISION

***************SELECCION DEL NIVEL
		 RESTSCREEN(0,0,24,79,cSavPan)
		 cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
		 nParameSet(aP1,'cMaeAct',cMaeAct)
***************FIN SELECCION DEL NIVEL

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
		 AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
		 AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
			       FNroInd+cMaeAct+cAnoSis+ExtFile,NIL,'NRO'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := IF(nPrueba==1,.T.,.F.)
		  lDelReg := .F.
		  lInsReg := IF(nPrueba==1,.T.,.F.)
		  lHaySql := .F.
		  bInsReg := NIL

		  MantenNro(aP1,aP2,aP3,;
			    aArchvo,cOpcPrn,nCodPrn,lModReg,;
			    lDelReg,lInsReg,lHaySql,bInsReg)
		*ÀClase de Indicadores
***************FIN MANTENIMIENTO DEL ARCHIVO

	  CASE nNroOpc == 4

***************SELECCION DEL NIVEL
		 RESTSCREEN(0,0,24,79,cSavPan)
		 cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
		 nParameSet(aP1,'cMaeAct',cMaeAct)
***************FIN SELECCION DEL NIVEL

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
		 AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
		 AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
			       FileJui+cMaeAct+cAnoSis+ExtFile,NIL,'JUI'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := .F.
		  lDelReg := .F.
		  lInsReg := .F.
		  lHaySql := .F.
		  bInsReg := NIL

		  MantenJui(aP1,aP2,aP3,;
			    aArchvo,cOpcPrn,nCodPrn,lModReg,;
			    lDelReg,lInsReg,lHaySql,bInsReg)
		*ÀClase de Indicadores
***************FIN MANTENIMIENTO DEL ARCHIVO

/*
	  CASE nNroOpc == 3

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{cPatSis+'\'+FileHor,NIL,'HOR'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := IF(nPrueba==1,.T.,.F.)
		  lDelReg := .F.
		  lInsReg := .T.
		  lHaySql := .F.

		  MantenHor(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql)
***************FIN MANTENIMIENTO DEL ARCHIVO


	  CASE nNroOpc == 3
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenHra(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			 cPatSis,cMaeAlu,cMaeAct,cJorTxt,lModReg)
	      *Mantenimiento Horas

	  CASE nNroOpc == 4
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenFun(aP1,aP2,aP3)
	      *Mantenimiento Horas

	  CASE nNroOpc == 6

	       RESTSCREEN(0,0,24,79,cSavPan)
	       Conta_775(aP1,aP2,aP3)
*/

	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO..: ACTUALIZA LOS CODIGOS DE PROMOCION                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 23/95 MAR A
       Colombia, Bucaramanga        INICIO: 10:20 AM   MAY 23/95 MAR

OBJETIVOS:

1- Actualiza los c¢digos de la promoci¢n de notas en el maestro de Estudiantes

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AproboMae(aP1,aP2,aP3)

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nNroFil := 0                   // N£mero de la fila
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELECT &cMaeAct
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DESICION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DESICION

*>>>>RECORRIDO DE LOS GRUPOS
       SELECT GRU
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	      CloseAll()
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DEL CUERPO DEL INFORME
	    nNroFil := nMarco(nFilPal,'GRUPO: '+GRU->cCodigoGru)
	    SELECT NOT
	    NOT->(DBGOTOP())
	    DO WHILE .NOT. NOT->(EOF())

*--------------VISUALIZACION DEL REGISTRO
		 @ nNroFil,01 SAY 'CODIGO: '+NOT->cCodigoEst

		 nNroFil++
		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal,'GRUPO: '+GRU->cCodigoGru)
		 ENDIF
*--------------FIN VISUALIZACION DEL REGISTRO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cError('EL CODIGO:'+NOT->cCodigoEst+' NO EXISTE')
		    NOT->(DBSKIP())
		 ENDIF
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------GRABACION DEL CODIGO DE PROMOCION
		 SELECT &cMaeAct
		 IF lRegLock(lShared,.F.)
		    REPL &cMaeAct->nAproboNot WITH NOT->nAproboNot
		    DBCOMMIT()
		 ENDIF
		 IF lShared
		    DBUNLOCK()
		 ENDIF
*--------------FIN GRABACION DEL CODIGO DE PROMOCION

	       NOT->(DBSKIP())

	    ENDDO
**********FIN IMPRESION DEL CUERPO DEL INFORME

	  GRU->(DBSKIP())

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS GRUPOS