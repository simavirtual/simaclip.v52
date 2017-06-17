/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: LISTAS CONTROL DE ASISTENCIA

**************************************************************************
* TITULO..: LISTA PARA CONTROL DE ASISTENCIA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 30/97 MIE A
       Bucaramanga, Colombia	    INICIO: 12:45 PM   ENE 30/97 MIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza el men£ para la impresi¢n de las listas de control de asistencia

2- Ejecuta las diferentes funciones para las listas de control de asistencia

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_302(aParam1,aParam2,aParam3)

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

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final

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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseMae(lShared,cPatSis,cMaeAlu,cAnoSis) .OR.;
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

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL NUMERO DE COPIA
       @ nFilInf+3,nColInf SAY 'NRO COPIAS' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

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

*>>>>IMPRESION DE N COPIAS
       nNroCop := 1
       DO WHILE nNroCop <= nCopias

**********IMPRESION POR GRUPOS
	    SELECT GRU
	    GO nRegFin

	    GO nRegIni
	    DO WHILE GRU->(RECNO()) <= nRegFin

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+;
			     'ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			     STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------IMPRESION DE LA LISTA DE CONTROL
		 ControlAsi(lShared,cPatSis,GRU->cCodigoGru,cNomEmp,;
			    cNomSis,cAnoUsr,cMaeAct,cJorTxt,lHayNot)
*--------------FIN IMPRESION DE LA LISTA DE CONTROL

	       SELECT GRU
	       GRU->(DBSKIP())
	    ENDDO
**********FIN IMPRESION POR GRUPOS

	  nNroCop++

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       CLOSE ALL
       IF !lHayNot .AND. !lFileDelete(fNtxTem)
	  cError('NO SE BORRO EL ARCHIVO INDICE TEMPORAL')
       ENDIF
       CLOSE ALL
       RETURN NIL
*>>>>BORRADO DEL ARCHIVO TEMPORAL

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LA LISTA DE CONTROL DE ASISTENCIA *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 29/97 MIE A
       Bucaramanga, Colombia	    INICIO: 05:55 PM   ENE 29/97 MIE


OBJETIVOS:

1- Imprime la lista de control de asistencia para el grupo determinado.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ControlAsi(lShared,cPatSis,cCodGru,cNomEmp,cNomSis,cAnoUsr,cMaeAct,cJorTxt,lHayNot)

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
       #INCLUDE "\EPSONFX.PRG" // Impresora EPSON FX

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistemas
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 12                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cNombreTes := ''                  // Nombre del estudiante
       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
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

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       @ PROW(),00 SAY INICIALIZA
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lHayNot
	  SELECT NOT
	  nTotReg := NOT->(RECCOUNT())
       ELSE
	  SELECT &cMaeAct

	  COUNT FOR cCodigoGru == cCodGru TO nTotReg
	*Total de registros a imprimir
       ENDIF
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'CONTROL DE ASISTENCIA. JORNADA: '+cJorTxt,;
			    'A¥O: '+cAnoUsr,;
			    'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
						 SUBS(cCodGru,3,2),;
			    nNroPag++,;
			    cTotPagina(nTotReg))
		 @ PROW(),00 SAY CONDEN_ON+ELITE
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {02,06,44,;
			     02,02,02,02,02,02,02,02,02,02,;
			     02,02,02,02,02,02,02,02,02,02,;
			     02,02,02,02,02,02,02,02,02,02,02,02}
		 aTitulo := {'No',;
			     'CODIGO',;
			     'APELLIDOS Y NOMBRES ',;
			     '1' ,'2' ,'3' ,'4' ,'5' ,'6' ,'7' ,'8' ,'9' ,'10',;
			     '11','12','13','14','15','16','17','18','19','20',;
			     '21','22','23','24','25','26','27','28','29','30',;
			     '31','No'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := 144
		 @ PROW(),00 SAY DRAFT_ON+ELITE
		 @ PROW()+1,0 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,0 SAY cTxtPrn
		 @ PROW()+1,0 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lHayNot
	       IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
		  cNombreTes := 'EL ALUMNO NO EXISTE'
	       ENDIF
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(30)
	    cNombreTes := SUBS(cNombreTes,1,44)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 aNroCol := {02,06,44,92,02}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D     O',;
			     STR(i,2)}

	    CASE lHayNot .AND. NOT->lRetGruNot

		 aNroCol := {02,06,44,92,02}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'O    T    R    O           G     R    U    P    O',;
			     STR(i,2)}
	    OTHERWISE
		 aNroCol := {02,06,44,;
			     02,02,02,02,02,02,02,02,02,02,;
			     02,02,02,02,02,02,02,02,02,02,;
			     02,02,02,02,02,02,02,02,02,02,02,02}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     SPACE(02),SPACE(02),SPACE(02),SPACE(02),;
			     SPACE(02),SPACE(02),SPACE(02),SPACE(02),;
			     SPACE(02),SPACE(02),SPACE(02),SPACE(02),;
			     SPACE(02),SPACE(02),SPACE(02),SPACE(02),;
			     SPACE(02),SPACE(02),SPACE(02),SPACE(02),;
			     SPACE(02),SPACE(02),SPACE(02),SPACE(02),;
			     SPACE(02),SPACE(02),SPACE(02),SPACE(02),;
			     SPACE(02),SPACE(02),SPACE(02),;
			     STR(i,2)}
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion
	    i++
	    @ PROW()+1,0 SAY cTxtPrn
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  IF lHayNot
	     SELECT NOT
	  ELSE
	     SELECT &cMaeAct
	  ENDIF
	  SKIP

       ENDDO
       CloseDbf('NOT')
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  DerechosPrn(cNomSis,cNomEmp,n17Stan)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS