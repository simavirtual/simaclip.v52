/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : LISTADOS
SUBMODULO...: LISTAS PROVISIONALES

**************************************************************************
* TITULO..: MENU PARA LISTAS DE CLASE PROVISIONALES                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 29/97 MIE A
       Bucaramanga, Colombia	    INICIO: 04:25 PM   ENE 29/97 MIE

OBJETIVOS:

1- Visualiza el men£ para la impresi¢n de las listas de clase provisionales

2- Ejecuta las diferentes funciones para las listas de clase

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_311(aParam1,aParam2,aParam3)

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

*>>>>DECLARCION Y EJECUCION DEL MENU
       cNalias := cMaeAct
       aMenus  := {'1<POR PROFESOR >',;
		   '2<POR GRUPOS   >',;
		   '3<SOLO NOMBRES >'}
       aAyuda := {'Imprime las listas para los profesores',;
		  'Imprime las listas de clase de un grupo determinado',;
		  'Imprime las listas de clase de un grupo con solo los nombres'}

       SAVE SCREEN
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
       RESTORE SCREEN
       IF nNroOpc == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Cont_3111(aParam1,aParam2,aParam3)
	   *Listas de Clase por profesor

       CASE nNroOpc == 2
	    Cont_3112(aParam1,aParam2,aParam3)
	   *Listas de clase por grupos

       CASE nNroOpc == 3
	    Cont_3113(aParam1,aParam2,aParam3)
	   *Listas de clase por grupos solo nombres

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LA LISTA DE CLASE                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUE 18/96 JUE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   JUE 18/96 JUE

OBJETIVOS:

1- Imprime una lista de clase para el grupo determinado

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ListaClase(cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,nNroPer,;
		    nTipBol,nNroLin,cCodGru,cNomMat,cMaeAct,cJorTxt,;
		    lProfes)

*>>>>PARAMATROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       nNroPer                              // N£mero del Periodo
       nTipBol                              // Tipo de Boletin
       nNroLin                              // N£mero de L¡neas
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       lProfes			            // .T. Si SimaProf */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
     *ÀVariables de informe

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo

       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL NUMERO DE LINEAS
       DO CASE
       CASE nNroLin >= 48
	    nNroLin := 48
       CASE nNroLin >= 24
	    nNroLin := 24
       CASE nNroLin >= 16
	    nNroLin := 16
       CASE nNroLin >= 12
	    nNroLin := 12
       CASE nNroLin >= 8
	    nNroLin := 8
       CASE nNroLin >= 6
	    nNroLin := 6
       CASE nNroLin >= 4
	    nNroLin := 4
       ENDCASE
*>>>>FIN VALIDACION DEL NUMERO DE LINEAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := (NOT->(RECCOUNT())*nNroLin)+2
       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  ALLTRIM(cNomMat),;
		  'LISTA DE CLASE PARA EL PERIODO No. '+STR(nNroPer,1),;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,IF(nTipBol==3,44,26),;
		   02,06,06,06,06,06,06,06,06,06,06}
       IF nTipBol # 3
	  AADD(aNroCol,04)
	  AADD(aNroCol,04)
	  AADD(aNroCol,04)
       ENDIF
       AADD(aNroCol,04)
       AADD(aNroCol,02)

       aTitulo := {'No',;
		   'CODIGO',;
		   'APELLIDOS Y NOMBRES ',;
		   'GR',;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06)),;
		   IF(nNroLin >= 2,'------',SPACE(06))}
       IF nTipBol # 3
	  AADD(aTitulo,'ACUM')
	  AADD(aTitulo,'MINI')
	  AADD(aTitulo,'DEFI')
       ENDIF
       AADD(aTitulo,'AUSE')
       AADD(aTitulo,'No')
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       aCabSec := {}
       IF !EMPTY(cNomPro)
	  aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       ENDIF

       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOT->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,IF(nTipBol==3,44,26))
	    lRetiroTno := IF(lProfes,NOT->lRetiroNoP,NOT->lRetGruNot)
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS DE FUERA DE LISTA
	    IF lRetiroTno
	       IF lProfes
		  IF CAR->nTipCarCar # 0
		     NOT->(DBSKIP())
		     LOOP
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE FUERA DE LISTA

**********IMPRESION DE LA PRIMERA LINEA
	    DO CASE
	    CASE lRetiroTes
		 aNroCol := {02,06,IF(nTipBol==3,44,26),74}
		 IF nTipBol # 3
		    AADD(aNroCol,04)
		    AADD(aNroCol,04)
		    AADD(aNroCol,04)
		 ENDIF
		 AADD(aNroCol,04)
		 AADD(aNroCol,02)

		 aTitulo := {STR(NOT->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D      O'}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOT->(RECNO()),2))

	    CASE lRetiroTno
		 aNroCol := {02,06,26,74,04,04,04,04,02}

		 IF SELECT('CAR') # 0
		    aTitulo := {STR(NOT->(RECNO()),2),;
				&cMaeAct->cCodigoEst,;
				cNombreTes,;
				IF(CAR->nTipCarCar # 0,;
				   'F U E R A  D E  L I S T A',;
				   'P E R T E N E C E    A   O T R O  G R U P O')}
		 ELSE
		    aTitulo := {STR(NOT->(RECNO()),2),;
				&cMaeAct->cCodigoEst,;
				cNombreTes,;
				'P E R T E N E C E    A   O T R O  G R U P O'}
		 ENDIF

		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))

		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOT->(RECNO()),2))

	    CASE !lRetiroTes .AND. !lRetiroTno
		 aNroCol := {02,06,IF(nTipBol==3,44,26),;
			     02,06,06,06,06,06,06,06,06,06,06}
		 IF nTipBol # 3
		    AADD(aNroCol,04)
		    AADD(aNroCol,04)
		    AADD(aNroCol,04)
		 ENDIF
		 AADD(aNroCol,04)
		 AADD(aNroCol,02)

		 aTitulo := {STR(NOT->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     SPACE(02),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06)}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOT->(RECNO()),2))
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DE LA PRIMERA LINEA

**********IMPRESION DE LA SEGUNDA LINEA
	    IF nNroLin >= 2
	       aNroCol := {IF(nTipBol==3,38,26),; //46
			   02,06,06,06,06,06,06,06,06,06,06}
	       IF nTipBol # 3
		  AADD(aNroCol,04)
		  AADD(aNroCol,04)
		  AADD(aNroCol,04)
	       ENDIF
	       AADD(aNroCol,04)
	       AADD(aNroCol,02)

	       aTitulo := {SPACE(IF(nTipBol==3,54,36)),;
			   SPACE(02),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(06)}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(02))

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	      *Prepara la variable de impresion

	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DE LA SEGUNDA LINEA

**********IMPRESION DE LA SEGUNDA LINEA
	    IF nNroLin > 2
	       FOR i:= 1 TO nNroLin - 2

		  IF nTipBol # 3
		     aNroCol := {128}
		     aTitulo := {SPACE(128)}

		     cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    *Prepara la variable de impresion

		  ELSE
		     cTxtPrn := '|'+SPACE(135)+'|'
		  ENDIF
		  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	       ENDFOR
	    ENDIF
**********FIN IMPRESION DE LA SEGUNDA LINEA

	  NOT->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  EVAL(bDerAut)
	 *Impresi¢n de Derechos

	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS