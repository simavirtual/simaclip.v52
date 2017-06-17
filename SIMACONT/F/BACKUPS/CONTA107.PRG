/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INICIO DE A¥O
SUBMODULO...: CARGAS ACADEMICAS

**************************************************************************
* TITULO..: CARGAS ACADEMICAS                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/1995 LUN A
       Colombia, Bucaramanga        INICIO: 12:45 AM   MAY 15/1995 LUN


OBJETIVOS:

1- Permite definir las cargas acad‚micas de los profesores

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_107(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cNroNiv := ''                  // N£mero del Nivel
       LOCAL cNomPla := ''                  // Nombre del Plan Academico

       LOCAL oBrwCar := NIL                 // Browse de la Carga
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
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
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuN,'SUN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuG,'SUG',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
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

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

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

*>>>>DEFINICION DE LAS CARGAS ACADEMICAS
       DO WHILE .T.

***********LECTURA DEL GRUPO
	     cCodigoTgr := cSpaField('GRU','cCodigoGru')
	     @ nFilInf+1,nColInf SAY 'GRUPO:';
				 GET cCodigoTgr PICT '@9';
				 VALID lValGrupo(ROW(),COL()-4,@cCodigoTgr)
	     READ
	     IF EMPTY(cCodigoTgr)
		EXIT
	     ENDIF
	     cNroNiv := SUBS(cCodigoTgr,1,2)
***********FIN LECTURA DEL GRUPO

**********LOCALIZACION DEL NIVEL
	   IF !lLocCodigo('cCodigoNiv','NIV',cNroNiv)
	      cError('EL NIVEL '+cNroNiv+' NO EXISTE')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN LOCALIZACION DEL NIVEL

**********SELECCION DEL NOMBRE DEL ARCHIVO DEL PLAN ACADEMICO
	    IF NIV->lPlaGruNiv
	       FilePla := 'PL'+cCodigoTgr+cAnoSis+ExtFile
	       cNomPla := cCodigoTgr
	    ELSE
	       FilePla := 'PLAN'+cNroNiv+cAnoSis+ExtFile
	       cNomPla := cNomNiv(cNroNiv)
	    ENDIF
**********FIN SELECCION DEL NOMBRE DEL ARCHIVO DEL PLAN ACADEMICO

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			     FilePla,'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO DE '+cNomPla)

		CLOSE ALL
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     IF PLA->(RECCOUNT()) == 0
		cError('NO EXISTEN PLAN ACADEMICO PARA ESTE GRUPO')
		CLOSE PLA
		LOOP
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********ASIGNACION DEL PROFESOR
	     SET FILTER TO SUBS(PLA->cCodigoMat,3,2) <> '00' .OR.;
			   (SUBS(PLA->cCodigoMat,3,2) == '00' .AND.;
			    PLA->cTipArePla == 'N')

	     oBrwCar := oDefCargas(lShared,nFilPal+1,00,22,79,;
				   cCodigoTgr,cMaeAct)
	     SETKEY(K_F9,{||PrnGruCar(lShared,cNomEmp,cNomSis,;
			    cAnoUsr,cJorTxt,cCodigoTgr)})
	     PLA->(CtrlBrw(lShared,oBrwCar))
	     SETKEY(K_F9,NIL)
	     SET FILTER TO
	     CloseDbf('PLA')
***********FIN ASIGNACION DEL PROFESOR

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN DEFINICION DE LAS CARGAS ACADEMICAS

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS PROFESORES DEL GRUPO          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 25/97 MAR A
       Colombia, Bucaramanga        INICIO: 03:25 PM   FEB 25/97 MAR

OBJETIVOS:

1- Imprime los profesores que dictan en el grupo

2- Debe estar en uso los archivos de Plan Acad‚mico, Materias,
   profesores y grupos.

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnGruCar(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt,cCodGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
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

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cIntHor := ''                  // Intensidad Horaria
       LOCAL cConFil := ''                  // Condici¢n del filtro
       LOCAL nRegAct := 0                   // Registro Actual
     *ÀVariables espec¡ficas

       LOCAL cCodigoTpr := ''               // C¢digo del profesor
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL lMatVarTma := .F.              // .T. Materia Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       cConFil := PLA->(DBFILTER())
       nRegAct := PLA->(RECNO())
       SET FILTER TO
       IF PLA->(RECCOUNT()) == 0
	  cError('EL PLAN ACADEMICO NO ESTA CREADO')
	  SET FILTER TO &cConFil
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := PLA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'PROFESORES PARA GRUPO '+cCodGru+;
		   '. A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,84,02,06,52}
       aTitulo := {'CODIGO',;
		   'MATERIA',;
		   'IH',;
		   'CODIGO',;
		   'NOMBRE DEL PROFESOR'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  NNETSETQ('COLA')
	  NNETCAPBEG(1)
	  IF !lPregunta('DESEA IMPRIMIR EN RED? Si No')
	     NNETCAPEND(1)
	  ENDIF
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   SET FILTER TO &cConFil
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT PLA
       GO TOP
       DO WHILE .NOT. PLA->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PLA->(RECNO()) / PLA->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LOCALIZACION DE LA MATERIA
	    IF SUBS(PLA->cCodigoMat,3,2) == '00'
	       cNombreTma := 'AREA NO EXISTE'
	    ELSE
	       cNombreTma := 'MATERIA NO EXISTE'
	    ENDIF
	    IF lLocCodigo('cCodigoMat','MAT',PLA->cCodigoMat)
	       cNombreTma := MAT->cNombreMat
	    ENDIF
**********FIN LOCALIZACION DE LA MATERIA

**********LECTURA DEL AREA
	    IF SUBS(PLA->cCodigoMat,3,2) == '00'

	       cIntHor := SPACE(02)
	       IF PLA->cTipArePla == 'N'
		  cIntHor := PLA->cIntHorPla
	       ENDIF
	       cNombreTma := cNombreTma+SPACE(04)

	    ELSE
	       cIntHor    := PLA->cIntHorPla
	       cNombreTma := SPACE(02)+cNombreTma+SPACE(02)
	    ENDIF
**********FIN LECTURA DEL AREA

**********LOCALIZACION DEL PROFESOR DEL AREA
	    cCodigoTpr := '******'
	    cNombreTpr := SPACE(52)
	    IF SUBS(PLA->cCodigoMat,3,2) # '00' .OR. PLA->cTipArePla == 'N'

	       cNombreTpr := 'PROFESOR NO EXISTE'
	       cCodigoTpr := PLA->(&('cPr'+cCodGru+'Pla'))

	       IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
		  IF MAT->nMatVarMat == 0
		     cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
				   PRO->cNombrePro
		  ELSE
		     cCodigoTpr := '******'
		     cNombreTpr := SPACE(52)
		  ENDIF
	       ENDIF
	       cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
	    ENDIF
**********FIN LOCALIZACION DEL PROFESOR DEL AREA

**********IMPRESION DEL AREA
	    IF SUBS(PLA->cCodigoMat,3,2) == '00'
	       aTitulo := {PLA->cCodigoMat,;
			   cNombreTma,;
			   cIntHor,;
			   cCodigoTpr,;
			   cNombreTpr}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL AREA

**********IMPRESION DE LOS PROFESORES
	    IF SUBS(PLA->cCodigoMat,3,2) # '00'

*--------------LOCALIZACION DEL PROFESOR
		 IF MAT->nMatVarMat == 0
		    cCodigoTpr := PLA->(&('cPr'+cCodGru+'Pla'))
		    IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
		       cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
				     PRO->cNombrePro
		    ELSE
		       cNombreTpr := 'PROFESOR NO EXISTE'
		    ENDIF
		 ELSE
		    cCodigoTpr := '******'
		    cNombreTpr := SPACE(52)
		 ENDIF
		 cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
*--------------FIN LOCALIZACION DEL PROFESOR

*--------------IMPRESION DEL REGISTRO
		 IF EMPTY(cNombreTma)
		    aTitulo := {SPACE(06),;
				SPACE(32),;
				SPACE(02),;
				cCodigoTpr,;
				cNombreTpr}
		 ELSE
		    aTitulo := {PLA->cCodigoMat,;
				cNombreTma,;
				cIntHor,;
				cCodigoTpr,;
				cNombreTpr}
		 ENDIF
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 cNombreTma := ''
*--------------FIN IMPRESION DEL REGISTRO

*--------------IMPRESION DE LA SUBDIVISION POR NIVEL
		 IF MAT->nMatVarMat == 1

*..................FILTRACION DE LA SUBDIVISION
		     SELECT SUN
		     SET FILTER TO (SUN->cCodigoNiv == SUBS(cCodGru,1,2) .OR.;
				    SUN->cCodigoNiv == 'XX')            .AND.;
			 SUBS(SUN->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
		     GO TOP
*..................FIN FILTRACION DE LA SUBDIVISION

*..................RECORRIDO DE LA SUBDIVISION POR NIVEL
		     DO WHILE .NOT. SUN->(EOF())

*                       LOCALIZACION DE LA MATERIA
			  IF lLocCodigo('cCodigoMat','MAT',SUN->cCodigoMat)
			     cNombreTma := SPACE(04)+MAT->cNombreMat
			  ELSE
			     cNombreTma := SPACE(04)+'MATERIA NO EXISTE'
			  ENDIF
*                       FIN LOCALIZACION DE LA MATERIA

*                       LOCALIZACION DEL PROFESOR
			  cCodigoTpr := SPACE(06)
			  cNombreTpr := SPACE(52)

			  IF SUN->lPorNivSuN
			     cCodigoTpr := SUN->cCodigoPro
			  ELSE
			     cCodigoTpr := MAT->cCodigoPro
			  ENDIF

			  IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
			     cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
					   PRO->cNombrePro
			  ENDIF
			  cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
*                       FIN LOCALIZACION DEL PROFESOR

*                       IMPRESION DEL REGISTRO
			  aTitulo := {SUN->cCodigoMat,;
				      cNombreTma,;
				      SUN->cIntHorSuN,;
				      cCodigoTpr,;
				      cNombreTpr}
			  cTxtPrn := cRegPrint(aTitulo,aNroCol)
			  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
			  cNombreTma := ''
*                       FIN IMPRESION DEL REGISTRO

			SUN->(DBSKIP())

		     ENDDO
		     SET FILTER TO
		     SELECT PLA
*..................FIN RECORRIDO DE LA SUBDIVISION POR NIVEL

		 ENDIF
*--------------FIN IMPRESION DE LA SUBDIVISION POR NIVEL

*--------------IMPRESION DE LA SUBDIVISION POR GRUPO
		 IF MAT->nMatVarMat == 2

*..................FILTRACION DE LA SUBDIVISION
		     SELECT SUG
		     SET FILTER TO SUG->cCodigoGru == cCodGru .AND.;
			 SUBS(SUG->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
		     GO TOP
*..................FIN FILTRACION DE LA SUBDIVISION

*..................RECORRIDO DE LA SUBDIVISION POR GRUPO
		     DO WHILE .NOT. SUG->(EOF())

*                       LOCALIZACION DE LA MATERIA
			  IF lLocCodigo('cCodigoMat','MAT',SUG->cCodigoMat)
			     cNombreTma := SPACE(04)+MAT->cNombreMat
			  ELSE
			     cNombreTma := SPACE(04)+'MATERIA NO EXISTE'
			  ENDIF
*                       FIN LOCALIZACION DE LA MATERIA

*                       LOCALIZACION DEL PROFESOR
			  cCodigoTpr := SUG->cCodigoPro
			  cNombreTpr := SPACE(52)

			  IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
			     cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
					   PRO->cNombrePro
			  ENDIF
			  cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
*                       FIN LOCALIZACION DEL PROFESOR

*                       IMPRESION DEL REGISTRO
			  aTitulo := {SUG->cCodigoMat,;
				      cNombreTma,;
				      SUG->cIntHorSuG,;
				      cCodigoTpr,;
				      cNombreTpr}
			  cTxtPrn := cRegPrint(aTitulo,aNroCol)
			  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
			  cNombreTma := ''
*                       FIN IMPRESION DEL REGISTRO

			SUG->(DBSKIP())

		     ENDDO
		     SET FILTER TO
		     SELECT PLA
*..................FIN RECORRIDO DE LA SUBDIVISION POR GRUPO

		 ENDIF
*--------------FIN IMPRESION DE LA SUBDIVISION POR GRUPO

	    ENDIF
**********IMPRESION DE LOS PROFESORES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PLA
	    PLA->(DBSKIP())
	    IF PLA->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>RESTAURACION DEL FILTRO
       SELECT PLA
       SET FILTER TO &cConFil
      *Activa el filtro

       GO nRegAct
*>>>>FIN RESTAURACION DEL FILTRO

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

