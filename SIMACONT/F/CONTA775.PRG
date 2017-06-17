/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: VARIOS - INDICADORES

**************************************************************************
* TITULO..: MENU TRASLADO DE INDICADORES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 26/2007 LUN A
       Bucaramanga, Colombia	    INICIO: 09:15 AM   FEB 26/2007 LUN

OBJETIVOS:

1- Visualiza el men£ para el traslado de los indicadores.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_775(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL nLenOpc := 0                   // Longitud de las opciones

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
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<POR GRADOS        >')
       AADD(aMenus,'2<POR MATERIAS      >')
       AADD(aMenus,'3<POR INDICADORES   >')
       AADD(aMenus,'4<MARCAR INDICADORES>')

       AADD(aAyuda,'Permite trasladar indicadores por Grados')
       AADD(aAyuda,'Permite trasladar indicadores por Materias')
       AADD(aAyuda,'Permite trasladar indicadores uno a uno')
       AADD(aAyuda,'Permite marcar indicadores para NO trasladar')
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>SELECCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       IF nNroOpc == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>SELECCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 3
	    CopyIndInd(lShared,cPatSis,cMaeAlu,cMaeAct,nFilInf,nColInf,cAnoUsr)
	  *ÀTraslado de indicadores uno a uno

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO..: TRASLADO DE INDICADORES UNO A UNO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 26/2007 LUN A
       Bucaramanga, Colombia	    INICIO: 10:30 AM   FEB 26/2007 LUN

OBJETIVOS:

1- Permite trasladar los indicadores por grados

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CopyIndInd(lShared,cPatSis,cMaeAlu,cMaeAct,nFilInf,nColInf,cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cAnoUsr				    // A¤o del Sistema	*/
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathMtr := ''                  // Path de SimaMatr
       LOCAL PathCon := ''                  // Path de SimaCont
       LOCAL PathPro := ''                  // Path de SimaProf
       LOCAL PathCar := ''                  // Path de SimaCart
       LOCAL nModCry := 0                   // Modo de Protecci¢n

       LOCAL       i := 0                   // Contador
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path Anterior

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cSecInd := ''                  // Secuencial del Indicador
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL cMatAnt := ''                  // Materia Anterior
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       LOCAL cCodigoTma := ''               // C¢digo de la materia

       LOCAL cCodigoTcl := ''               // C¢digo de la Clase
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Nombre del Indicador
       LOCAL cExtra1Tju := ''               // Nombre del Indicador Extra 1
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       IF !PathConAno(lShared,cAnoUsr,cPatSis,;
		      @PathPro,@PathMtr,@PathCar,@PathCon,.F.)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>PATH DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
*>>>>FIN PATH DEL A¥O ANTERIOR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,cPatAnt+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'ACO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatAnt+'\'+cMaeAct+'\'+;
			 FileJui+cMaeAct+SUBS(cAnoAnt,3,2)+ExtFile,'JUI',;
			 cPatAnt+'\'+cMaeAct+'\'+;
			 fNtxJui+cMaeAct+SUBS(cAnoAnt,3,2)+cExtNtx,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathPro+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileJui+cMaeAct+ExtFile,'IND',;
			 PathPro+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 fNtxJui+cMaeAct+cExtNtx,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

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
       CASE ACO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL DEL A¥O ANTERIOR')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE JUI->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES PARA TRASLADAR')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS CLASES DE INDICADORES')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL CODIGO DEL NIVEL
       cSavPan := SAVESCREEN(0,0,24,79)
       cCodigoTni := SPACE(02)
       @ nFilInf+1,nColInf+4 SAY 'NIVEL' GET cCodigoTni  PICT '@! XX';
			      VALID lValNivel(ROW(),COL()-2,@cCodigoTni)

       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(cCodigoTni)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL CODIGO DEL NIVEL

*>>>>ANALISIS DEL PLAN ACADEMICO POR GRUPO
       FilePla := 'PLAN'+cCodigoTni+cAnoSis+ExtFile
       IF NIV->lPlaGruNiv

**********FILTRACION DEL GRUPO POR NIVELES
	    SELECT GRU
	    SET FILTER TO SUBS(GRU->cCodigoGru,1,2) == cCodigoTni
	    GRU->(DBGOTOP())

	    IF GRU->(EOF())
	       cError('NO EXISTEN GRUPOS PARA EL NIVEL '+cCodigoTni)
	       GRU->(DBCLEARFILTER())
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN FILTRACION DEL GRUPO POR NIVELES

**********LECTURA DEL CODIGO DEL GRUPO
	    cSavPan := SAVESCREEN(0,0,24,79)
	    cCodigoTgr := cSpaces('GRU','cCodigoGru')
	    @ nFilInf+1,nColInf+4 SAY 'GRUPO:';
				  GET cCodigoTgr PICT '@9';
				  VALID lValGrupo(ROW(),COL()-4,@cCodigoTgr)
	    READ
	    GRU->(DBCLEARFILTER())
	    RESTSCREEN(0,0,24,79,cSavPan)

	    IF EMPTY(cCodigoTgr)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
	    FilePla := 'PL'+cCodigoTgr+cAnoSis+ExtFile
**********FIN LECTURA DEL CODIGO DEL GRUPO

       ENDIF
*>>>>FIN ANALISIS DEL PLAN ACADEMICO POR GRUPO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		      FilePla,'PLA',NIL,lShared)
	  cError('ABRIENDO ARCHIVO DE PLAN ACADEMICO')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>FILTRACION DEL PLAN POR MATERIAS Y AREAS NO PROMEDIABLES
       SELECT PLA
       SET FILTER TO !EMPTY(PLA->cMatIndPla)
       PLA->(DBGOTOP())
       IF PLA->(EOF())
	  cError('NO EXISTEN MATERIAS CONFIGURADAS PARA EL TRASLADO DE INDICADORES')
	  PLA->(DBCLEARFILTER())
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL PLAN POR MATERIAS Y AREAS NO PROMEDIABLES

*>>>>CAPTURA DE LAS MATERIAS DEL PLAN POR INTERVALO
       nRegIni := 0
       nRegFin := 0
       IF !lIntervPla(nFilInf+1,01,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CAPTURA DE LAS MATERIAS DEL PLAN POR INTERVALO

*>>>>SELECCION DE LA CLASE DE INDICADOR
       SELECT CLA
       DO WHILE .T.
	  IF nSelRegDbf(nFilInf+1,nColInf-12,'CLA','cNombreCla') == 0
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
	  IF lPregunta('ESCOGIO '+ALLTRIM(CLA->cNombreCla)+;
	     ' DESEA CONTINUAR? Si No')
	     EXIT
	  ENDIF
       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN SELECCION DE LA CLASE DE INDICADOR

*>>>>MATERIA O AREA A TRASLADAR
       IF EMPTY(CLA->cCodigoMat)
	  IF UPPER(CLA->cCodigoCla) == 'A'
	     cCodigoTma := SUBS(PLA->cCodigoMat,1,2)+'00'
	  ELSE
	     cCodigoTma := PLA->cCodigoMat
	  ENDIF
       ELSE
	  cCodigoTma := CLA->cCodigoMat
	  cCodigoTni := SPACE(02)
       ENDIF
       cCodigoTcl := CLA->cCodigoCla
*>>>>FIN MATERIA O AREA A TRASLADAR

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'CLASE DE INDICADOR: '+;
			     ALLTRIM(CLA->cNombreCla),22,'°')
       aTamCol := {06,30}
       aTitulo := {'CODIGO','INDICADOR '}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
       nNroFil++
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>TRASLADO DE LOS INDICADORES
       DO WHILE .T.

**********CAPTURA DEL SECUENCIAL DEL INDICADOR
	    cSecInd := SPACE(03)
	    @ nNroFil,aNroCol[1] GET cSecInd PICT '999';
				 VALID lCorrecion(@cSecInd)
	    READ
	    IF EMPTY(cSecInd)
	       EXIT
	    ENDIF
	    cCodigoTju := cCodigoTma+cCodigoTcl+cSecInd
**********FIN CAPTURA DEL SECUENCIAL DEL INDICADOR

**********BUSQUEDA DEL INDICADOR
	    IF !lSekCodigo(IF(ACO->lIndNivTbl,;
			      cCodigoTni+cCodigoTju,;
			      cCodigoTju),'JUI','INDICADOR')
	       LOOP
	    ENDIF
	    cNombreTju := JUI->cNombreJui
	    cExtra1Tju := JUI->cExtra1Jui
**********FIN BUSQUEDA DEL INDICADOR

**********CAPTURA DEL JUICIO
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    @ nNroFil,aNroCol[2] GET cNombreTju PICT;
				 IF(CLA->lMinuscCla,"@S68","@!S68")

	    IF EMPTY(cExtra1Tju) .OR. TCO->nJuiExtTbl # 0
		@ ++nNroFil,aNroCol[2] GET cExtra1Tju PICT;
				       IF(CLA->lMinuscCla,"@S68","@!S68")
	    ENDIF
	    READ
	    IF EMPTY(cNombreTju)
	       EXIT
	    ENDIF
**********FIN CAPTURA DEL JUICIO

**********LECTURA DE GRABACION
	    nNroOpc := nLeeOpcion('1<GRABAR> '+;
				  '2<NO GRABAR> '+;
				  '3<CORREGIR>?',3,'1')
**********FIN LECTURA DE GRABACION


       ENDDO
       RETURN NIL
*>>>>FIN TRASLADO DE LOS INDICADORES
