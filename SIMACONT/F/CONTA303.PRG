/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : LISTADOS
SUBMODULO...: DIRECTORIO DE ALUMNOS

**************************************************************************
* TITULO..: MENU PARA DIRECTORIO DE ALUMNOS                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 04/97 VIE A
       Bucaramanga, Colombia	    INICIO: 12:45 PM   ABR 04/97 VIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza el men£ del directorio de alumnos.

2- Permite imprimir el directorio de alumnos.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_303(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL lHayNot := .F.                 // .T. Creados Archivos Notas
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       FIELD cCodigoGru                     // C¢digo del Grupo
       FIELD cNombreEst                     // Nombre del Estudiante
       FIELD cApelliEst                     // Apellido del Estudiante
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
       AADD(aMenus,'1<INFORMACION DEL ALUMNO >')
       AADD(aMenus,'2<INFORMACION DEL PADRE  >')
       AADD(aMenus,'3<INFORMACION DE LA MADRE>')
       AADD(aMenus,'4<DIRECTORIO GENERAL     >')
       AADD(aMenus,'5<DIRECTORIO EMAIL       >')

       AADD(aAyuda,'Imprime el directorio con la informaci¢n del alumno')
       AADD(aAyuda,'Imprime el directorio con la informaci¢n del padre')
       AADD(aAyuda,'Imprime el directorio con la informaci¢n de la madre')
       AADD(aAyuda,'Directorio General de Alumnos Matriculados')
       AADD(aAyuda,'Directorio General de Emails')

       SAVE SCREEN
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
       RESTORE SCREEN
       IF nNroOpc == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseMae(lShared,cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		     FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct

       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES MATRICULADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>VALIDACION DE EXISTENCIA DE ARCHIVO DE NOTAS
       lHayNot := .F.
       IF lFilesNot(cPatSis+'\'+cMaeAct,cAnoSis)
	  lHayNot := .T.
       ENDIF
*>>>>FIN VALIDACION DE EXISTENCIA DE ARCHIVO DE NOTAS

*>>>>INDEXACION DEL ARCHIVO
       SELECT &cMaeAct
       IF !lHayNot
	  SAVE SCREEN
	  Termometro(0,'ORDENANDO POR APELLIDO')
	  Termometro(50)

	  fNtxTem := SUBS(cNomUsr,1,3)+FileTem+cExtNtx
	  INDEX ON cCodigoGru+;
		   cApelliEst+;
		   cNombreEst TO &fNtxTem
	  Termometro(100)
	  RESTORE SCREEN
	  IF lShared
	     DBSETINDEX(fNtxTem)
	  ELSE
	     SET INDEX TO &fNtxTem
	  ENDIF
       ENDIF
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1

	    Conta_331(aParam1,aParam2,aParam3,lHayNot)
	   *Directorio con informaci¢n del alumno

       CASE nNroOpc == 2
	    Conta_332(aParam1,aParam2,aParam3,lHayNot)
	   *Directorio con informaci¢n del padre

       CASE nNroOpc == 3
	    Conta_333(aParam1,aParam2,aParam3,lHayNot)
	   *Directorio con informaci¢n de la madre

       CASE nNroOpc == 4

	    Conta_334(aParam1,aParam2,aParam3,lHayNot)
	   *Directorio General Alumnos Matriculados

       CASE nNroOpc == 5

	    Conta_335(aParam1,aParam2,aParam3,lHayNot)
	   *Directorio General emails

       ENDCASE
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       CloseAll()
       IF !lHayNot .AND. !lFileDelete(fNtxTem)
	  cError('NO SE BORRO EL ARCHIVO INDICE TEMPORAL')
       ENDIF
       CloseAll()
       RETURN NIL
*>>>>BORRADO DEL ARCHIVO TEMPORAL

/*************************************************************************
* TITULO DE LA FUNCION..: DIRECTORIO CON INFORMACION DEL ALUMNO          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 04/97 VIE A
       Bucaramanga, Colombia	    INICIO: 05:55 PM   ABR 04/97 VIE


OBJETIVOS:

1- Imprime el directorio con la informaci¢n del alumno.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DirectAlum(lShared,cPatSis,cCodGru,cNomEmp,;
		    cNomSis,cAnoUsr,cMaeAct,cJorTxt,lHayNot)

*>>>>PARAMATROS DE LA FUNCION
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida
       lHayNot                              // .T. Creados Archivos Notas */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL nNroAlu := 1                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNomAcuTes := ''               // Nombre del Acudiente
       FIELD cCodigoGru                     // C¢digo del Grupo
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF lHayNot
	  IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			 'NT'+cCodGru+cAnoSis+ExtFile,;
			 'NOT',NIL,lShared)

	     cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .T.

*******TOTAL DE REGISTRO A IMPRIMIR
	 IF lHayNot
	    SELECT NOT
	    nTotReg := NOT->(RECCOUNT())
	 ELSE
	    SELECT &cMaeAct

	    COUNT FOR cCodigoGru == cCodGru TO nTotReg
	  *Total de registros a imprimir
	 ENDIF
	 nTotReg += nLinTot
*******FIN TOTAL DE REGISTRO A IMPRIMIR

       aCabeza := {cNomEmp,cNomSis,;
		   'DIRECTORIO CON LA INFORMACION DEL ALUMNO A¥O:'+;
		   cAnoUsr+' JORNADA: '+cJorTxt,;
		   'GRUPO: '+cCodGru,;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,50,50,40,16,14,14,14,02}
       aTitulo := {'No',;
		   'CODIGO',;
		   'NOMBRE DEL ESTUDIANTE',;
		   'ACUDIENTE',;
		   'DIRECCION',;
		   'BARRIO',;
		   'TELEFONO',;
		   'TEL PADRE',;
		   'TEL MADRE',;
		   'No'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n20Wide
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TERMOMETRO DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT
*>>>>FIN TERMOMETRO DE IMPRESION

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********VISUALIZACION DE AVANCE
	    nAvance := INT((nNroAlu / nTotReg )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lHayNot
	       IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
		  cNombreTes := 'EL ALUMNO NO EXISTE'
	       ENDIF
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(50)
	    cNombreTes := SUBS(cNombreTes,1,50)

	    cNomAcuTes := RTRIM(&cMaeAct->cApeAcuEst)+' '+;
			  RTRIM(&cMaeAct->cNomAcuEst)+SPACE(50)
	    cNomAcuTes := SUBS(cNomAcuTes,1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 aNroCol := {02,06,50,50,102,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     cNomAcuTes,;
			     'R      E      T      I      R      A      D     O',;
			     STR(nNroAlu,2)}

	    CASE lHayNot .AND. NOT->lRetGruNot

		 aNroCol := {02,06,50,50,102,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     cNomAcuTes,;
			     'O    T    R    O           G     R    U    P    O',;
			     STR(nNroAlu,2)}

	    OTHERWISE
		 aNroCol := {02,06,50,50,40,16,14,14,14,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     cNomAcuTes,;
			     &cMaeAct->cDireccEst,;
			     &cMaeAct->cBarrioEst,;
			     &cMaeAct->cTelefnEst,;
			     &cMaeAct->cCelPadEst,;
			     &cMaeAct->cCelMadEst,;
			     STR(nNroAlu,2)}
	    ENDCASE
	    nNroAlu++
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    IF lHayNot
	       SELECT NOT
	    ELSE
	       SELECT &cMaeAct
	    ENDIF
	    DBSKIP()
	    IF EOF()
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CloseDbf('NOT')
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO DE LA FUNCION..: DIRECTORIO CON INFORMACION DEL PADRE           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 07/97 LUN A
       Bucaramanga, Colombia	    INICIO: 11:25 AM   ABR 07/97 LUN


OBJETIVOS:

1- Imprime el directorio con la informaci¢n del padre

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DirectPapa(lShared,cPatSis,cCodGru,cNomEmp,;
		    cNomSis,cAnoUsr,cMaeAct,cJorTxt,lHayNot)

*>>>>PARAMATROS DE LA FUNCION
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida
       lHayNot                              // .T. Creados Archivos Notas */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL nNroAlu := 1                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNomPadTes := ''               // Nombre del Padre
       FIELD cCodigoGru                     // C¢digo del Grupo
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF lHayNot
	  IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			 'NT'+cCodGru+cAnoSis+ExtFile,;
			 'NOT',NIL,lShared)

	     cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .T.

*******TOTAL DE REGISTRO A IMPRIMIR
	 IF lHayNot
	    SELECT NOT
	    nTotReg := NOT->(RECCOUNT())
	 ELSE
	    SELECT &cMaeAct

	    COUNT FOR cCodigoGru == cCodGru TO nTotReg
	  *Total de registros a imprimir
	 ENDIF
	 nTotReg += nLinTot
*******FIN TOTAL DE REGISTRO A IMPRIMIR

*******DEFINCION DEL ENCABEZADO
       aCabeza := {cNomEmp,cNomSis,;
		   'DIRECTORIO CON LA INFORMACION DEL PADRE A¥O:'+;
		   cAnoUsr+' JORNADA: '+cJorTxt,;
		   'GRUPO: '+cCodGru,;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*******FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,40,40,26,26,20,14,14,14,02}
       aTitulo := {'No',;
		   'CODIGO',;
		   'NOMBRE DEL ESTUDIANTE',;
		   'NOMBRE DEL PADRE',;
		   'PROFESION',;
		   'EMPRESA DONDE TRABAJA',;
		   'CARGO QUE DESENPE¥A',;
		   'TELEFONO',;
		   'TEL CASA',;
		   'TEL ACUDIENTE',;
		   'No'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n20Wide
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TERMOMETRO DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT
*>>>>FIN TERMOMETRO DE IMPRESION

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********VISUALIZACION DE AVANCE
	    nAvance := INT((nNroAlu / nTotReg )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lHayNot
	       IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
		  cNombreTes := 'EL ALUMNO NO EXISTE'
	       ENDIF
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(40)
	    cNombreTes := SUBS(cNombreTes,1,40)

	    cNomPadTes := RTRIM(&cMaeAct->cApePadEst)+' '+;
			  RTRIM(&cMaeAct->cNomPadEst)+SPACE(40)
	    cNomPadTes := SUBS(cNomPadTes,1,40)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 aNroCol := {02,06,40,40,120,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     cNomPadTes,;
			     'R      E      T      I      R      A      D     O',;
			     STR(nNroAlu,2)}

	    CASE lHayNot .AND. NOT->lRetGruNot

		 aNroCol := {02,06,40,40,120,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'O    T    R    O           G     R    U    P    O',;
			     STR(nNroAlu,2)}

	    OTHERWISE
		 aNroCol := {02,06,40,40,26,26,20,14,14,14,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     cNomPadTes,;
			     &cMaeAct->cProPadEst,;
			     &cMaeAct->cEmpPadEst,;
			     &cMaeAct->cCarPadEst,;
			     &cMaeAct->cTelPadEst,;
			     &cMaeAct->cTelefnEst,;
			     &cMaeAct->cTe1AcuEst,;
			     STR(nNroAlu,2)}
	    ENDCASE
	    nNroAlu++
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    IF lHayNot
	       SELECT NOT
	    ELSE
	       SELECT &cMaeAct
	    ENDIF
	    DBSKIP()
	    IF EOF()
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CloseDbf('NOT')
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO DE LA FUNCION..: DIRECTORIO CON INFORMACION DE LA MADRE         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 07/97 LUN A
       Bucaramanga, Colombia	    INICIO: 11:55 AM   ABR 07/97 LUN


OBJETIVOS:

1- Imprime el directorio con la informaci¢n del padre.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DirectMama(lShared,cPatSis,cCodGru,cNomEmp,;
		    cNomSis,cAnoUsr,cMaeAct,cJorTxt,lHayNot)

*>>>>PARAMATROS DE LA FUNCION
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida
       lHayNot                              // .T. Creados Archivos Notas */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL nNroAlu := 1                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNomMadTes := ''               // Nombre de la Madre
       FIELD cCodigoGru                     // C¢digo del Grupo
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF lHayNot
	  IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			 'NT'+cCodGru+cAnoSis+ExtFile,;
			 'NOT',NIL,lShared)

	     cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .T.

*******TOTAL DE REGISTRO A IMPRIMIR
	 IF lHayNot
	    SELECT NOT
	    nTotReg := NOT->(RECCOUNT())
	 ELSE
	    SELECT &cMaeAct

	    COUNT FOR cCodigoGru == cCodGru TO nTotReg
	  *Total de registros a imprimir
	 ENDIF
	 nTotReg += nLinTot
*******FIN TOTAL DE REGISTRO A IMPRIMIR

       aCabeza := {cNomEmp,cNomSis,;
		   'DIRECTORIO CON LA INFORMACION DE LA MADRE A¥O:'+;
		   cAnoUsr+' JORNADA: '+cJorTxt,;
		   'GRUPO: '+cCodGru,;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,40,40,26,26,20,14,14,14,02}
       aTitulo := {'No',;
		   'CODIGO',;
		   'NOMBRE DEL ESTUDIANTE',;
		   'NOMBRE DE LA MADRE',;
		   'PROFESION',;
		   'EMPRESA DONDE TRABAJA',;
		   'CARGO QUE DESENPE¥A',;
		   'TELEFONO',;
		   'TEL CASA',;
		   'TEL ACUDIENTE',;
		   'No'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n20Wide
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TERMOMETRO DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT
*>>>>FIN TERMOMETRO DE IMPRESION

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********VISUALIZACION DE AVANCE
	    nAvance := INT((nNroAlu / nTotReg )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lHayNot
	       IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
		  cNombreTes := 'EL ALUMNO NO EXISTE'
	       ENDIF
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(40)
	    cNombreTes := SUBS(cNombreTes,1,40)

	    cNomMadTes := RTRIM(&cMaeAct->cApeMadEst)+' '+;
			  RTRIM(&cMaeAct->cNomMadEst)+SPACE(40)
	    cNomMadTes := SUBS(cNomMadTes,1,40)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 aNroCol := {02,06,40,40,120,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     cNomMadTes,;
			     'R      E      T      I      R      A      D     O',;
			     STR(nNroAlu,2)}

	    CASE lHayNot .AND. NOT->lRetGruNot

		 aNroCol := {02,06,40,40,120,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     cNomMadTes,;
			     'O    T    R    O           G     R    U    P    O',;
			     STR(nNroAlu,2)}

	    OTHERWISE

		 aNroCol := {02,06,40,40,26,26,20,14,14,14,02}
		 aTitulo := {STR(nNroAlu,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     cNomMadTes,;
			     &cMaeAct->cProMadEst,;
			     &cMaeAct->cEmpMadEst,;
			     &cMaeAct->cCarMadEst,;
			     &cMaeAct->cTelMadEst,;
			     &cMaeAct->cTelefnEst,;
			     &cMaeAct->cTe1AcuEst,;
			     STR(nNroAlu,2)}
	    ENDCASE
	    nNroAlu++
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    IF lHayNot
	       SELECT NOT
	    ELSE
	       SELECT &cMaeAct
	    ENDIF
	    DBSKIP()
	    IF EOF()
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CloseDbf('NOT')
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: DIRECTORIO CON INFORMACION DE LA MADRE                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       INICIO: 09:30 AM  MAR 16/2009 LUN
       Bucaramanga, Colombia        FINAL : 10:05 AM  MAR 16/2009 LUN


OBJETIVOS:

1- Imprime el directorio con la informaci¢n de los emails.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DirecEmail(lShared,cPatSis,cCodGru,cNomEmp,;
		    cNomSis,cAnoUsr,cMaeAct,cJorTxt,;
		    lHayNot,fArcPrn,nOpcPrn,nArcHan)

*>>>>DECLARACION DE PARAMETROS
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida
       lHayNot                              // .T. Creados Archivos Notas
       fArcPrn                              // Archivo de impresi¢n
       nArcHan			            // @Manejador del Archivo */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL nRegPrn := 0                       // Registro de Impresi¢n
       LOCAL cFecPrn := ''                      // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                      // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                      // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                       // N£mero de p gina
       LOCAL lTamAnc := .F.                     // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                       // L¡neas totales de control
       LOCAL nTotReg := 0                       // Total de registros
       LOCAL aCabPrn := {}	                // Encabezado del informe General
       LOCAL aCabeza := {}                      // Encabezado del informe
       LOCAL cCodIni := ''                      // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                      // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                      // Columnas de impresi¢n
       LOCAL aTitPrn := {}                      // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                      // Registros para impresi¢n
       LOCAL cCabCol := ''                      // Encabezado de Columna
       LOCAL aCabSec := {}                      // Encabezado Secundario
       LOCAL nLenPrn := 0                       // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                     // .T. Centrar el informe
       LOCAL nColCab := 0                       // Columna del encabezado
       LOCAL bPagina := NIL                     // Block de P gina
       LOCAL bCabeza := NIL                     // Block de Encabezado
       LOCAL bDerAut := NIL                     // Block Derechos de Autor
       LOCAL nLinReg := 1                       // L¡neas del registro
       LOCAL cTxtPrn := ''                      // Texto de impresi¢n
       LOCAL aPrnWww := {}		        // Detalles informes para www
       LOCAL lPrnCab := .T.                     // .T. Imprimir el Encabezado
     *ÀVariables de informe

       LOCAL nNroAlu := 1                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cTelefnTes := ''               // Telefono fijo de la Casa
       LOCAL cCelPadTes := ''               // Celular del padre
       LOCAL cMaiPadTes := ''               // Email del padre
       LOCAL cCelMadTes := ''               // Celular de la madre
       LOCAL cMaiMadTes := ''               // Email del padre

       LOCAL cNomMadTes := ''               // Nombre de la Madre
       FIELD cCodigoGru                     // C¢digo del Grupo
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF lHayNot
	  IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			 'NT'+cCodGru+cAnoSis+ExtFile,;
			 'NOT',NIL,lShared)

	     cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>TOTAL DE REGISTRO A IMPRIMIR
       IF lHayNot
	  SELECT NOT
	  nTotReg := NOT->(RECCOUNT())
       ELSE
	  SELECT &cMaeAct

	  COUNT FOR cCodigoGru == cCodGru TO nTotReg
	*Total de registros a imprimir
       ENDIF
*>>>>TOTAL DE REGISTRO A IMPRIMIR

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg += nLinTot

       aCabPrn := {cNomEmp,cNomSis,;
		   'DIRECTORIO DE EMAILS A¥O:'+;
		   cAnoUsr+' JORNADA: '+cJorTxt,;
		   'GRUPO: '+cCodGru,;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,2)
       AADD(aTitPrn,'No')

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,40)
       AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')

       AADD(aNroCol,14)
       AADD(aTitPrn,'TEL FIJO')

       AADD(aNroCol,14)
       AADD(aTitPrn,'CEL PADRE')

       AADD(aNroCol,14)
       AADD(aTitPrn,'CEL MADRE')

       AADD(aNroCol,40)
       AADD(aTitPrn,'EMAIL DEL PADRE')

       AADD(aNroCol,40)
       AADD(aTitPrn,'EMAIL DE LA MADRE')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n20Wide')
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn,;
			       cCodIso,cFecIso,cVerIso)}
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,'')  // cFecPrn
       AADD(aCabPrn,'')  // cHorPrn
       AADD(aCabPrn,'')  // cDiaPrn

       aPrnWww := {}
       AADD(aPrnWww,{'nCodXsl','0'})
       AADD(aPrnWww,{'cCodInf',''})
       AADD(aPrnWww,{'cCodIso',''})
       AADD(aPrnWww,{'cFecIso',''})
       AADD(aPrnWww,{'cVerIso',''})
       AADD(aPrnWww,{'cPieUno',''})
       AADD(aPrnWww,{'cPieDos',''})
       AADD(aPrnWww,{'cPieTre',''})

       FilePrn := fArcPrn
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
			     nOpcPrn,aCabPrn,aTitPrn,aPrnWww)
       nArcHan := nHanXml
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>TERMOMETRO DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT
*>>>>FIN TERMOMETRO DE IMPRESION

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********VISUALIZACION DE AVANCE
	    nAvance := INT((nNroAlu / nTotReg )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lHayNot
	       IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
		  cNombreTes := 'EL ALUMNO NO EXISTE'
	       ENDIF
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(40)
	    cNombreTes := SUBS(cNombreTes,1,40)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********INFORMACION DEL ESTUDIANTE
	    cCodigoTes := &cMaeAct->cCodigoEst
	    cTelefnTes := &cMaeAct->cTelefnEst
	    cCelPadTes := &cMaeAct->cCelPadEst
	    cMaiPadTes := &cMaeAct->cMaiPadEst
	    cCelMadTes := &cMaeAct->cCelMadEst
	    cMaiMadTes := &cMaeAct->cMaiMadEst

	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 cTelefnTes := 'RETIRADO'

	    CASE lHayNot .AND. NOT->lRetGruNot
		 cTelefnTes := 'OTRO GRUPO'

	    ENDCASE
**********FIN INFORMACION DEL ESTUDIANTE

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}

	    AADD(aRegPrn,STR(nNroAlu,2))
	    AADD(aRegPrn,cCodigoTes)
	    AADD(aRegPrn,cNombreTes)
	    AADD(aRegPrn,cTelefnTes)
	    AADD(aRegPrn,cCelPadTes)
	    AADD(aRegPrn,cCelMadTes)
	    AADD(aRegPrn,cMaiPadTes)
	    AADD(aRegPrn,cMaiPadTes)

            lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    nNroAlu++
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    IF lHayNot
	       SELECT NOT
	    ELSE
	       SELECT &cMaeAct
	    ENDIF
	    DBSKIP()
	    IF EOF()
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CloseDbf('NOT')
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS