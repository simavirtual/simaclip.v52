/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : MATRICULAS
SUBMODULO...: IMPRESIONES         MODULO No. 632

**************************************************************************
* TITULO..: IMPRESION DE MATRICULADOS POR APELLIDO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 30/94 VIE A
						       NOV 30/94 VIE
REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite generar el listado de los alumnos matr¡culados por orden
   alfebetico por apellido

2- Ejecuta las diferentes funciones de la consulta


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_632(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n

       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nNroNiv := 0                   // N£mero Nivel
       LOCAL cNivIni := 0                   // Nivel Inicial
       LOCAL cNivFin := 0                   // Nivel Final
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL GetList := {}                  // Variable del Sistema
       FIELD cCodigoGru
       FIELD cApelliEst
       FIELD cNombreEst
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
       IF  !lParam0101(aParams,;
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

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
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
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>TIPO DE ESTUDIANTES
       nNroOpc := nLeeOpcion('IMPRIMIR: '+;
		 '1<NUEVOS> 2<ANTIGUOS> 3<TODOS> 4<ABANDONAR>?',4,'0')

       IF nNroOpc == 4
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN TIPO DE ESTUDIANTES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 632
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<MATRICULAS><IMPRESIONES><POR APELLIDO>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'ESTUDIANTES MATRICULADOS POR NIVELES')  // T¡tulo Uno
       AADD(aTitIso,'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')       // T¡tulo Dos
       AADD(aTitIso,'')                                      // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'matr'+cAnoUsr
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.T.,2,bInsIso,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF

       IF nOpcPrn == 6
	  FilePrn := PathDoc+'\matr'+cAnoUsr+'.xls'
       ELSE
	  FilePrn := PathDoc+'\matr'+cAnoUsr+'.txt'
       ENDIF

       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>IMPRESION DEL INFORME
       PrnMatApel(lShared,PathUno,cNomEmp,cNomSis,;
		  cNomUsr,cAnoUsr,cMaeAlu,cJorTxt,;
		  FilePrn,nOpcPrn,@nHanXml,cOpcSys,;
		  nNroOpc,nNroIso,cCodIso,aTitIso,;
		  cPiePag,aPieIso,nTotPie,aMezIso,;
		  bInsIso,@bDerAut,cPatSis)

       EVAL(bDerAut)
      *Derechos de Autor
       EJECT

       SET DEVICE TO SCREEN

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME


/*************************************************************************
* TITULO..: IMPRESION DE ALUMNOS MATRICULADOS POR NIVELES                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2012 MIE A
       Bucaramanga, Colombia	    INICIO: 02:00 PM   DIC 06/2012 MIE

OBJETIVOS:

1- Imprime los estudiante matr¡culados por nombre.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnMatApel(lShared,PathUno,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		    cMaeAlu,cJorTxt,FilePrn,nOpcPrn,nHanXml,cOpcSys,;
		    nNroOpc,nNroIso,cCodIso,aTitIso,cPiePag,aPieIso,;
		    nTotPie,aMezIso,bInsIso,bDerAut,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       PathUno                              // Path de Integraci¢n Uno
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAlu			            // Maestros habilitados
       cJorTxt                              // Jornada Escogida
       FilePrn                              // Archivo de impresion
       nOpcPrn                              // Opci¢n de Impresi¢n
       nHanXml                              // Manejador del Archivo
       nNroOpc                              // N£mero de Opci¢n
       cOpcSys                              // Opci¢n del Sistema
       nNroIso                              // N£mero Iso del Informe
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       cPiePag                              // Pie de P gina por defecto
       aPieIso      		            // Textos del pie de p gina
       nTotPie                              // Total de Pie de p ginas
       aMezIso                              // Campos a Mesclar
       bInsIso                              // Block de Gestion Documental
       bDerAut                              // @Block Derechos de Autor
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

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
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
     *ÀVariables de informe

       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL nTotAno := 0                   // Total de A¤os
       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       STATIC lSiPaso := .F.                // Control de Flujo

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cApelliTes := ''               // Apellido del Estudiante
       LOCAL cNomfulTes := ''               // Nombre Completo
       FIELD cCodigoGru
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,;
		   aTitIso[1],;
		   aTitIso[2],;
		   aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       IF nOpcPrn == 6
	  aNroCol := {06,06,40,40}
	  aTitPrn := {'CODIGO',;
		      'CURSO ',;
		      'APELLIDOS',;
		      'NOMBRES '}

	  cCabCol := cRegPrint(aTitPrn,aNroCol)
       ELSE
	  aNroCol := {04,06,40,06,08,14,04,06,06}
	  aTitPrn := {'No. ',;
		      'CODIGO',;
		      'APELLIDOS Y NOMBRES ',;
		      'CURSO ',;
		      SPACE(08),;
		      'F. NACIMIENTO',;
		      'A¥OS','HOMBRE','MUJER'}

	  cCabCol := cRegPrint(aTitPrn,aNroCol)
       ENDIF
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
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

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       IF !lSiPaso
	  nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
				nOpcPrn,aCabPrn,aTitPrn)
	  lSiPaso := .T.
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO POR NIVELES
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)

***********SELECCION DE LAS AREAS DE TRABAJO
	     IF !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,;
			    cMaeAct,cAnoSis,.T.,.F.)
		LOOP
	     ENDIF
***********FIN SELECCION DE LAS AREAS DE TRABAJO

***********RECORRIDO DE ESTUDIANTES
	     SELECT &cMaeAct

	     DBGOTOP()
	     DO WHILE .NOT. EOF()

*===============IMPRESION DE LA LINEA DE ESTADO
		  SET DEVICE TO SCREEN
		  LineaEstados('REGISTRO No. '+cMaeAct+':'+STR(RECNO(),4)+'/'+;
				STR(RECCOUNT(),4),cNomSis)
		  SET DEVICE TO PRINT
*===============FIN IMPRESION DE LA LINEA DE ESTADO


*===============ANALISIS DE DECISION
		  lHayErr := .F.
		  DO CASE
		  CASE nNroOpc == 1 .AND. &cMaeAct->lEstNewEst
		  CASE nNroOpc == 2 .AND. !&cMaeAct->lEstNewEst
		  CASE nNroOpc == 3
		  OTHERWISE
		       lHayErr := .T.
		  ENDCASE
		  IF lHayErr
		     SELECT &cMaeAct
		     DBSKIP()
		     LOOP
		  ENDIF
*===============FIN ANALISIS DE DECISION

*===============IMPRESION DEL INFORME
		  cNombreTes := ALLTRIM(&cMaeAct->cNombreEst)
		  cApelliTes := ALLTRIM(&cMaeAct->cApelliEst)

		  cNomfulTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				   &cMaeAct->cNombreEst+SPACE(10)

		  cNomfulTes := SUBS(cNomfulTes+SPACE(40),1,40)
		  cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		  cApelliTes := SUBS(cApelliTes+SPACE(40),1,40)

		  nTotAno := nAnosSi(&cMaeAct->dFecNacEst,DATE())

		  IF nOpcPrn == 6
		     aRegPrn := {&cMaeAct->cCodigoEst,;
				 &cMaeAct->cCodigoGru,;
				 cApelliTes,;
				 cNombreTes}

		     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			     aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		  ELSE
		     aRegPrn := {STR(i++,4),;
				 &cMaeAct->cCodigoEst,;
				 cNombreTes,;
				 &cMaeAct->cCodigoGru,;
				 IF(&cMaeAct->lRetiroEst,'RETIRADO',;
				    IF(&cMaeAct->lEstNewEst,'NUEVO',SPACE(08))),;
				 cFecha(&cMaeAct->dFecNacEst),;
				 STR(nTotAno,4),;
				 IF(&cMaeAct->lSexFemEst,'','X'),;
				 IF(&cMaeAct->lSexFemEst,'X','')}

		     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			     aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		  ENDIF
*===============FIN IMPRESION DEL INFORME

		SELECT &cMaeAct
		DBSKIP()

	     ENDDO
***********FIN RECORRIDO DE ESTUDIANTES


       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR NIVELES
