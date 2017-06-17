/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: RESUMEN JUICIOS

**************************************************************************
* TITULO..: RESUMEN DE JUICIOS VALORATIVOS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   NOV 19/95 MIE


OBJETIVOS:

1- Imprime por grupos el resumen para cada estudiante de los juicios
   valorativos de cada asignatura.


2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_307(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cPatTem := ''                  // Path Temporal

       LOCAL       k := 0                   // Contador
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nPorAcu := 0                   // Porcentaje acumulado
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroBis == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       cPatTem := cPatSis+'\'+cMaeAct
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileApr,'APR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatTem+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE TCO->nTipBolTbl== 0
	    cError('NO SE HA ESPECIFICADO EL TIPO DE BOLETIN A IMPRIMIR')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

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
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatTem+'\'+'PLAN'+SUBS(GRU->cCodigoGru,1,2)+;
			 cAnoSis+ExtFile,'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			ALLTRIM(SUBS('JARDIN  PRIMERO SEGUNDO TERCERO '+;
				     'CUARTO  QUINTO  SEXTO   SEPTIMO '+;
				     'OCTAVO  NOVENO  DECIMO  UNDECIMO',;
				  (VAL(SUBS(GRU->cCodigoGru,1,2))+1)*8-7,8)))
		CLOSE ALL
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatTem+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatTem+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('BIMESTRE: '+STR(nNroBis,2)+'º'+;
			'IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL RESUMEN
	    aNotAre := {}
	    aNotMat := {}

	    DetAreas(@aNotAre,@aNotMat,nNroBis)

	    ResumenJui(cNomEmp,cNomSis,cAnoUsr,cMaeAct,cJorTxt,;
		       GRU->cCodigoGru,aNotAre,aNotMat,nNroBis)

	    CloseDbf('NOT')
	    CloseDbf('PLA')
**********FIN IMPRESION DEL RESUMEN

	  SELECT GRU
	  SKIP

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

/*************************************************************************
* TITULO DE LA FUNCION..: RESUMEN DE LOS JUICIOS VALORATIVOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   NOV 19/95 MIE

OBJETIVOS:

1- Imprime para cada alumno del grupo su juicio valorativo de cada
   asignatura.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ResumenJui(cNomEmp,cNomSis,cAnoUsr,cMaeAct,cJorTxt,;
		   cCodGru,aNotAre,aNotMat,nNroBis)

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistemas
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 12                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n

       LOCAL   cNota := ''                  // Nota
       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL     j,i,k  := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       SELECT NOT
       nTotReg := NOT->(RECCOUNT())
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'RESUMEN DE JUICIOS VALORATIVOS. JORNADA: '+cJorTxt,;
			    'A¥O: '+cAnoUsr+' PERIODO: '+STR(nNroBis,2),;
			    'GRUPO: '+cCodGru,;
			    nNroPag++,;
			    cTotPagina(nTotReg))
		 @ PROW(),00 SAY CONDEN_ON
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {02,06,26,92,02}
		 aTitulo := {'No',;
			     'CODIGO',;
			     'APELLIDOS Y NOMBRES ',;
			     'JUICIOS VALORATIVOS','No'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := 144
		 @ PROW(),00 SAY DRAFT_ON+PICA
		 @ PROW()+1,01 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,01 SAY cTxtPrn
		 @ PROW()+1,01 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(30)
	    cNombreTes := SUBS(cNombreTes,1,26)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroBis <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    DO CASE
	    CASE lRetiroTes
		 aNroCol := {02,06,26,92,02}
		 aTitulo := {STR(k,2),;
			     NOT->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D     O',;
			     STR(k,2)}
		cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       *Prepara la variable de impresion
		k++
		@ PROW()+1,01 SAY cTxtPrn

	    CASE NOT->lRetGruNot

		 aNroCol := {02,06,26,92,02}
		 aTitulo := {STR(k,2),;
			     NOT->cCodigoEst,;
			     cNombreTes,;
			     'O    T    R    O           G     R    U    P    O',;
			     STR(k,2)}

		cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       *Prepara la variable de impresion
		k++
		@ PROW()+1,01 SAY cTxtPrn
	    OTHERWISE

		 aNroCol := {02,06,26}
		 aTitulo := {STR(k,2),;
			     NOT->cCodigoEst,;
			     cNombreTes}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW()+1,01 SAY cTxtPrn
		 k++

		 aNroCol := {}
		 aTitulo := {}
		       j := 1
		 FOR i := 1 TO LEN(aNotMat)
		     AADD(aTitulo,j)
		     AADD(aNroCol,j)
		     aNroCol[j] := 10
		     cNota := ALLTRIM(SUBS(&(aNotMat[i,4]),nNroBis*4-3,4))
		     aTitulo[j] := aNotMat[i,7]+':'+ALLTRIM(cNota)
		     IF MOD(j,10) == 0 .AND. j # LEN(aNotMat)
			cTxtPrn := cRegPrint(aTitulo,aNroCol)
			@ PROW()+1,01 SAY cTxtPrn
			aNroCol := {}
			aTitulo := {}
			      j := 0
		     ENDIF
		     IF MOD(j,10) # 0 .AND. i == LEN(aNotMat)
			cTxtPrn := cRegPrint(aTitulo,aNroCol)
			@ PROW()+1,01 SAY cTxtPrn
		     ENDIF
		     j++
		 NEXT

		 FOR i := 1 TO LEN(aNotAre)

		    IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		       AADD(aTitulo,j)
		       AADD(aNroCol,j)
		       aNroCol[j] := 10
		       cNota := ALLTRIM(SUBS(&(aNotAre[i,4]),nNroBis*4-3,4))
		       aTitulo[j] := aNotAre[i,7]+':'+ALLTRIM(cNota)
		       IF MOD(j,10) == 0 .AND. i # LEN(aNotAre)
			  cTxtPrn := cRegPrint(aTitulo,aNroCol)
			  @ PROW()+1,01 SAY cTxtPrn
			  aNroCol := {}
			  aTitulo := {}
				j := 0
		       ENDIF
		       IF MOD(j,10) # 0 .AND. i == LEN(aNotAre)
			  cTxtPrn := cRegPrint(aTitulo,aNroCol)
			  @ PROW()+1,01 SAY cTxtPrn
		       ENDIF
		       j++
		    ENDIF

		 NEXT
	    ENDCASE
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
*	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SELECT NOT
	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
*	  DerechosPrn(cNomSis,cNomEmp,n17Stan)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS