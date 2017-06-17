/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : LISTADOS
SUBMODULO...: DIRECTORIO DE GENERAL

**************************************************************************
* TITULO..: DIRECTORIO CON INFORMACION DEL ALUMNO                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2004 MIE A
       Bucaramanga, Colombia	    INICIO: 12:30 PM   AGO 09/2004 MIE

OBJETIVOS:

1- Permite imprimir el directorio General de alumnos Matriculados.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_334(aParam1,aParam2,aParam3,lHayNot)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lHayNot                              // .T. Creados archivos de notas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cCodGru := ''                  // C¢dgio del grupo

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL cColPrn := ''                  // Columna de Impresi¢n
     *ÀVariables de informe

       LOCAL nNroAlu := 1                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cPadres := ''                  // Padres
       LOCAL cDocNit := ''                  // Documento de Identidad
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante

       FIELD cCodigoGru                     // C¢digo del Grupo
     *ÀVariables de Campo
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())

       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'dirgen'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.,2)
          IF EMPTY(nOpcPrn)
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION POR GRUPOS
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********FILTRACION DEL MAESTRO
	    SET DEVICE TO SCREEN

	    cCodGru := GRU->cCodigoGru
	    SELECT &cMaeAct
	    IF !lHayNot
	       SET FILTER TO cCodigoGru == cCodGru
	       GO TOP
	       IF EOF()
		  cError('NO HAY ALUMNOS PARA EL GRUPO '+cCodGru)
		  SET FILTER TO
		  EXIT
	       ENDIF
	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+cCodGru+;
			'ºPOR FAVOR ESPERE ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF lHayNot
	       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			      'NT'+cCodGru+cAnoSis+ExtFile,;
			      'NOT',NIL,lShared)

		  cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru)
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>TOTAL DE REGISTRO A IMPRIMIR
       IF lHayNot
	  SELECT NOT
	  nTotReg := NOT->(RECCOUNT())
       ELSE
	  SELECT &cMaeAct
	  COUNT FOR cCodigoGru == cCodGru TO nTotReg
	*Total de registros a imprimir
       ENDIF
       nTotReg += nLinTot
*>>>>FIN TOTAL DE REGISTRO A IMPRIMIR

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       aCabPrn := {cNomEmp,cNomSis,;
		   'DIRECTORIO GENERAL ALUMNOS MATRICULADOS',;
		   'A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt+' GRUPO: '+cCodGru,;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       IF nOpcPrn == 6

	  aNroCol := {}
	  aTitPrn := {}

	  AADD(aNroCol,02)
	  AADD(aTitPrn,'No')

	  AADD(aNroCol,06)
	  AADD(aTitPrn,'CODIGO')

	  AADD(aNroCol,50)
	  AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'DIRECCION')

	  AADD(aNroCol,16)
	  AADD(aTitPrn,'BARRIO')

	  AADD(aNroCol,30)
	  AADD(aTitPrn,'CIUDAD')

	  AADD(aNroCol,32)
	  AADD(aTitPrn,'TELEFONO')

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'NOMBRE DEL PAPA')

	  AADD(aNroCol,32)
	  AADD(aTitPrn,'TELEFONO PAPA')

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'NOMBRE DE LA MADRE')

	  AADD(aNroCol,32)
	  AADD(aTitPrn,'TELEFONO MADRE')

       ELSE
	  aNroCol := {02,06,06,50,36,50,16,40}
	  aTitPrn := {'No',;
		      'CODIGO',;
		      'GRUPO',;
		      'NOMBRE DEL ESTUDIANTE',;
		      'DOCUMENTO',;
		      'DIRECCION',;
		      'TEL. CASA',;
		      'NOMBRES DE LOS PADRES'}
       ENDIF
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
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       IF nOpcPrn == 6
	  nHanXml := CreaFrmPrn(lShared,PathPrn+'\Dir'+GRU->cCodigoGru+'.xls',;
				aNroCol,nOpcPrn,aCabPrn,aTitPrn)
       ELSE
	  nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL CUERPO DEL INFORME
	    nNroAlu := 1
	    DBGOTOP()
	    DO WHILE .NOT. EOF() .AND. nTotReg # 0

*==============BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lHayNot
		    IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
		       cNombreTes := 'EL ALUMNO NO EXISTE'
		    ENDIF
		 ENDIF
		 cPadres := ALLTRIM(&cMaeAct->cNomMadEst)+','+;
			    ALLTRIM(&cMaeAct->cNomPadEst)
		 cPadres := SUBS(cPadres+SPACE(40),1,40)

		 cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			       RTRIM(&cMaeAct->cNombreEst)+SPACE(50)
		 cNombreTes := SUBS(cNombreTes,1,50)
*==============FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*==============ANALISIS DE DECISION
	       IF nOpcPrn == 6

		  IF &cMaeAct->lRetiroEst .OR.;
		     (lHayNot .AND. NOT->lRetGruNot)

		     IF lHayNot
			SELECT NOT
		     ELSE
			SELECT &cMaeAct
		     ENDIF
		     DBSKIP()
		     LOOP

		  ENDIF
		 ENDIF
*==============FIN ANALISIS DE DECISION

*==============IMPRESION DEL CONTENIDO DEL INFORME
		 SET DEVICE TO PRINT
		 DO CASE
		 CASE &cMaeAct->lRetiroEst .AND. nOpcPrn # 6
		      aNroCol := {02,06,06,50,38,102}
		      aRegPrn := {STR(nNroAlu,2),;
				  &cMaeAct->cCodigoEst,;
				  &cMaeAct->cCodigoGru,;
				  cNombreTes,;
				  SPACE(38),;
				  'RETIRADO'}

		 CASE lHayNot .AND. NOT->lRetGruNot .AND. nOpcPrn # 6

		      aNroCol := {02,06,06,50,38,102}
		      aRegPrn := {STR(nNroAlu,2),;
				  &cMaeAct->cCodigoEst,;
				  &cMaeAct->cCodigoGru,;
				  cNombreTes,;
				  SPACE(38),;
				  'OTRO GRUPO'}

		 OTHERWISE

		      IF nOpcPrn == 6

			 aRegPrn := {}
			 AADD(aRegPrn,STR(nNroAlu,2))
			 AADD(aRegPrn,&cMaeAct->cCodigoEst)
			 AADD(aRegPrn,cNombreTes)
			 AADD(aRegPrn,&cMaeAct->cDireccEst)
			 AADD(aRegPrn,&cMaeAct->cBarrioEst)
			 AADD(aRegPrn,&cMaeAct->cCiudadEst)

			 AADD(aRegPrn,SUBS(ALLTRIM(&cMaeAct->cTelefnEst)+','+;
					   ALLTRIM(&cMaeAct->cTelCelEst)+;
					   SPACE(32),1,32))

			 AADD(aRegPrn,SUBS(ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
					   ALLTRIM(&cMaeAct->cApePadEst)+;
					   SPACE(40),1,40))

			 AADD(aRegPrn,SUBS(ALLTRIM(&cMaeAct->cCelPadEst)+','+;
					   ALLTRIM(&cMaeAct->cTelPadEst)+;
					   SPACE(32),1,32))

			 AADD(aRegPrn,SUBS(ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
					   ALLTRIM(&cMaeAct->cApeMadEst)+;
					   SPACE(40),1,40))

			 AADD(aRegPrn,SUBS(ALLTRIM(&cMaeAct->cCelMadEst)+','+;
					   ALLTRIM(&cMaeAct->cTelMadEst)+;
					   SPACE(32),1,32))

		      ELSE
			 cDocNit := ALLTRIM(&cMaeAct->cDocNitEst)+' '+;
				    ALLTRIM(&cMaeAct->cLugNitEst)
			 cDocNit := SUBS(cDocNit+SPACE(36),1,36)

			 aNroCol := {02,06,06,50,36,14,50,16,40}
			 aRegPrn := {STR(nNroAlu,2),;
				     &cMaeAct->cCodigoEst,;
				     &cMaeAct->cCodigoGru,;
				     cNombreTes,;
				     cDocNit,;
				     SUBS(&cMaeAct->cDireccEst+;
					  &cMaeAct->cBarrioEst,1,50),;
				     &cMaeAct->cTelefnEst,;
				     cPadres}
		      ENDIF
		 ENDCASE
		 nNroAlu++

		 lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			 bCabeza)
*==============FIN IMPRESION DEL CONTENIDO DEL INFORME

*==============AVANCE DEL SIGUIENTE REGISTRO
		 IF lHayNot
		    SELECT NOT
		 ELSE
		    SELECT &cMaeAct
		 ENDIF
		 DBSKIP()
*==============FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
	    CloseDbf('NOT')
**********FIN IMPRESION DEL CUERPO DEL INFORME

**********IMPRESION DEL DIRECTORIO
	    IF !lHayNot
	       SET FILTER TO
	    ENDIF
**********FIN IMPRESION DEL DIRECTORIO

**********INCREMENTO DEL SIGUIENTE GRUPO
	    CloseXls(PathPrn+'\Dir'+GRU->cCodigoGru+'.xls',nHanXml)
	    SELECT GRU
	    DBSKIP()

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       IF nOpcPrn # 6
	  VerPrn(nOpcPrn,FilePrn,nHanXml)
       ELSE
	  cError('PROCESO TERMINADO')
       ENDIF

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION POR GRUPOS