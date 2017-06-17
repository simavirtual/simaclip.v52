/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: ACTUALIZAR                     MODULO No. 706

**************************************************************************
* TITULO..: MENU DE ACTUALIZACION DE ESTRUCTURAS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 27/1998 MIE A
       Colombia, Bucaramanga        INICIO: 12:30 PM   ENE 27/1998 MIE

OBJETIVOS:

1- Visualiza un men£ para la actualizaci¢n de las estructuras.

2- Ejecuta las diferentes funciones.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_704(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL lPrueba := .F.                 // .T. Pruebas

       LOCAL cValNot := ''                  // Validaci¢n de los Juicios

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
       CloseAll(aUseDbf)



*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus := {}
       AADD(aMenus,'1<ACTUALIZAR NOTAS>')
       AADD(aMenus,'2<CREAR IMPORTAR  >')
       AADD(aMenus,'3<IMPORTAR DATOS  >')

       aAyuda := {}
       AADD(aAyuda,'Permite actualizar las estructuras de los archivos de notas')
       AADD(aAyuda,'Permite crear los archivos para importar datos')
       AADD(aAyuda,'Permite importar los datos')
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

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-3,nColInf,NIL,NIL,nNroOpc)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       Conta_741(aParam1,aParam2,aParam3)

	  CASE nNroOpc == 2
	       CreaImport()
	     *ÀCrear los archivos en excel para permitir importar datos

	  CASE nNroOpc == 3
	       Conta_743(aParam1,aParam2,aParam3)

	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO..: ACTUALIZAR NOTAS                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 23/2007 VIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   FEB 23/2007 VIE

OBJETIVOS:

1- Actualiza las estructuras de los archivo de notas

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_741(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL lValida := .F.                 // Validar el Proceso
       LOCAL PathAct := ''                  // Path Actual
       LOCAL fArchvo := ''                  // Archivo
       LOCAL aCamDif := {}                  // Campos Diferentes

       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
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

*>>>>ANALISIS DE DECISION
       cError('DEBE GARANTIZAR QUE NINGUN USUARIO ESTE '+;
	      'UTILIZANDO EL SIMA')

       IF !lPregunta('ESTA SEGURO QUE NINGUN USUARIO '+;
		     'ESTA UTILIZANDO EL SIMA?No Si')
	  CloseAll()
	  RETURN NIL
       ENDIF

       IF !lPregunta('REALIZO COPIA DE SEGURIDAD? No Si')
	  cError('DEBE SACAR COPIA DE TODOS LOS A¥OS A ACTUALIZAR')
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})
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
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('SE VA A ACTUALIZAR LOS ARCHIVOS DE NOTAS DEL A¥O: '+;
		    cAnoUsr+' DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA LA ACTUALIZACION')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lValida := lPregunta('DESEA VALIDAR LA OPERACION '+;
			    'DE CADA ARCHIVO? No Si')
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTUALIZACION DE LOS ARCHIVOS DE NOTAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+'.DBF',;
			   'NOT',NIL,lNoRed)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' FAVOR CONSULTAR')
	      CloseAll(aUseDbf)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ACTUALIZANDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ACTUALIZACION DE LA ESTRUCTURA DE LAS NOTAS
	    SELECT NOT
	    ZAP
	    IF NOT->(EOF())

	       fArchvo := cPatSis+'\'+cMaeAct+'\NOTAS\BACKUPS\'+;
			  'NT'+GRU->cCodigoGru+cAnoSis+ExtFile
	       APPEND FROM &fArchvo

	       IF NOT->(EOF())
		  cError('EL ARCHIVO DEL GRUPO '+GRU->cCodigoGru+;
			 'AL APPENDIZAR SUS REGISTROS APARECE VACIO')
		  CloseAll(aUseDbf)
		  RETURN NIL
	       ENDIF
	    ELSE
	       cError('DEBE EMPEZAR DE NUEVO. VUELA A COPIAR LOS ARCHIVOS',;
		      'NO SE PUDO BORRAR LOS REGISTROS DEL ARCHIVO FUENTE')
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN ACTUALIZACION DE LA ESTRUCTURA DE LAS NOTAS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\BACKUPS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+'.dat',;
			   'BAK',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' FAVOR CONSULTAR')
	      CloseDbf('BAK')
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DEL PROCESO
	    IF lValida
	       cError('GRUPO: '+GRU->cCodigoGru+;
		      ' REGISTROS: '+STR(NOT->(RECCOUNT()),4))
	    ENDIF
**********FIN VALIDACION DEL PROCESO

**********LECTURA POR MATERIAS
	    aCamDif := aCamNotDif()
	    IF LEN(aCamDif) # 0
	       FOR i := 1 TO LEN(aCamDif)
		   NotBakaDbf(lShared,GRU->cCodigoGru,;
			      'NOT->'+aCamDif[i,1],;
			      'BAK->'+aCamDif[i,2])
	       ENDFOR
	    ENDIF
**********FIN LECTURA POR MATERIAS

	  CloseDbf('NOT')
	  GRU->(DBSKIP())

       ENDDO
       CloseAll(aUseDbf)
       DIRCHANGE (PathAct)
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LOS ARCHIVOS DE NOTAS

/*************************************************************************
* TITULO..: DIFERENCIAS EN CAMPOS DE NOTAS       	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 29/2006 MAR A
       Colombia, Bucaramanga        INICIO: 04:30 AM   NOV 29/2006 MAR

OBJETIVOS:

1- Determina que cambios han variado de acuerdo a los porcentajes en
   el plan de estudios.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aCamNotDif()

*>>>>DESCRIPCION DE PARAMETROS
/*     FileNot                              // Archivo de Notas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador
       LOCAL aStrNot := {}                  // Estructura del Archivo
       LOCAL aCamNot := {}                  // Campos de Notas
       LOCAL aStrBak := {}                  // Estructura del Archivo
       LOCAL aCamBak := {}                  // Campos de Backups
       LOCAL aCamDif := {}                  // Campos Diferentes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR NOTAS
       aStrNot := NOT->(DBSTRUCT())
       FOR i := 1 TO LEN(aStrNot)

	   IF SUBS(UPPER(aStrNot[i,1]),1,3) # UPPER('cNt')
	      LOOP
	   ENDIF

	   IF SUBS(UPPER(aStrNot[i,1]),8,3) == UPPER('Rec')
	      LOOP
	   ENDIF
	   AADD(aCamNot,aStrNot[i,1])
       ENDFOR
*>>>>FIN RECORRIDO POR NOTAS

*>>>>RECORRIDO POR BACKUPS
       aStrBak := BAK->(DBSTRUCT())
       FOR i := 1 TO LEN(aStrBak)

	   IF SUBS(UPPER(aStrBak[i,1]),1,3) # UPPER('cNt')
	      LOOP
	   ENDIF

	   IF SUBS(UPPER(aStrBak[i,1]),8,3) == UPPER('Rec')
	      LOOP
	   ENDIF
	   AADD(aCamBak,aStrBak[i,1])
       ENDFOR
*>>>>FIN RECORRIDO POR BACKUPS

*>>>>RECORRIDO POR CAMPOS DE NOTAS
       FOR i := 1 TO LEN(aCamNot)
	   FOR j := 1 TO LEN(aCamBak)

	       IF SUBS(UPPER(aCamNot[i]),1,7) == SUBS(UPPER(aCamBak[j]),1,7)

		  IF UPPER(aCamNot[i]) # UPPER(aCamBak[j])
		     AADD(aCamDif,{aCamNot[i],aCamBak[j]})
		  ENDIF

	       ENDIF

	   ENDFOR
       ENDFOR

       RETURN aCamDif
*>>>>FIN RECORRIDO POR CAMPOS DE NOTAS

/*************************************************************************
* TITULO..: LECTURAS POR MATERIAS DE BACKUPS     	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 01/2006 VIE A
       Colombia, Bucaramanga        INICIO: 03:30 AM   DIC 01/2006 VIE

OBJETIVOS:

1- Graba las materias que ha variado en los porcentajes de BACKUPS a
   NOTAS

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION NotBakaDbf(lShared,cCodGru,cCamNot,cCamBak)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cCamNot                              // Campo de Notas
       cCamBak                              // Campo de Backups
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'GRUPO:'+cCodGru+' '+cCamNot+'='+cCamBak,22,'°')
       aTamCol := {04,06,20,20}
       aTitulo := {'No.','CODIGO','NOTAS ','BACKUPS'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
       nNroFil++
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>RECORRIDO POR NOTAS
       SELECT BAK
       BAK->(DBGOTOP())

       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********GRABACION DE LAS NOTAS
	    IF NOT->cCodigoEst == BAK->cCodigoEst

	       @ nNroFil,aNroCol[1] SAY STR(NOT->(RECNO()),2,0)
	       @ nNroFil,aNroCol[2] SAY NOT->cCodigoEst
	       @ nNroFil,aNroCol[3] SAY &cCamNot
	       @ nNroFil,aNroCol[4] SAY &cCamBak

	       SELECT NOT
	       IF NOT->(lRegLock(lShared,.F.))

		  REPL &cCamNot WITH &cCamBak

		  NOT->(DBCOMMIT())

	       ELSE
		  cError('NO SE PUEDE GRABAR LAS NOTAS')
	       ENDIF

	       IF lShared
		  NOT->(DBUNLOCK())
	       ENDIF

	       @ nNroFil,aNroCol[1] SAY STR(NOT->(RECNO()),2,0)
	       @ nNroFil,aNroCol[2] SAY NOT->cCodigoEst
	       @ nNroFil,aNroCol[3] SAY &cCamNot
	       @ nNroFil,aNroCol[4] SAY &cCamBak

	    ELSE
	       cError('DESCUADRE EN ESTUDIANTES',;
		      NOT->cCodigoEst,BAK->cCodigoEst)

	    ENDIF
**********FIN GRABACION DE LAS NOTAS

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(03,'GRUPO:'+cCodGru+' '+cCamNot+'='+cCamBak,22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

	  NOT->(DBSKIP())
	  BAK->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR NOTAS


/*************************************************************************
* TITULO..: CREA EL ARCHIVO PARA ACTUALIZAR DATOS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 23/2007 VIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   FEB 23/2007 VIE

OBJETIVOS:

1- Actualiza las estructuras de los archivo de notas

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_743(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL lValida := .F.                 // Validar el Proceso
       LOCAL PathAct := ''                  // Path Actual
       LOCAL fArchvo := ''                  // Archivo
       LOCAL aCamDif := {}                  // Campos Diferentes

       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
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

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAlu+'IMPOR'+ExtFile,'IMP',NIL,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAlu+'ALU'+ExtFile,'ALU',NIL,;
			 lShared,nModCry})
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
       CASE IMP->(RECCOUNT()) # 0
	    cError('EXISTEN REGISTROS EN MAEIMPOR.DAT')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN MAEALU.DAT')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO DEL ARCHIVO
       SELECT ALU
       ALU->(DBGOTOP())
       DO WHILE .NOT. ALU->(EOF())


	  LineaEstado('REGISTROS:'+ALU->(STR(RECNO(),4))+'/'+;
				   ALU->(STR(RECCOUNT(),4)),cNomSis)

	  IF IMP->(lRegLock(lShared,.T.))

	     REPL IMP->cCodigoEst WITH STR(ALU->cCodigoEst,6)
	     REPL IMP->cCodigoGru WITH SUBS(ALU->cCodigoGru,AT('-',ALU->cCodigoGru)+1,4)
	     REPL IMP->cApelliEst WITH ALU->cApelliEst
	     REPL IMP->cNombreEst WITH ALU->cNombreEst


	     IMP->(DBCOMMIT())
	     IF lShared
		IMP->(DBUNLOCK())
	     ENDIF
	  ELSE
	     cError('NO SE GRABA EL REGISTRO')
	  ENDIF

	  ALU->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO DEL ARCHIVO