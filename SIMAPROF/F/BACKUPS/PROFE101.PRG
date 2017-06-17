/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LISTAS
SUBMODULO...: LISTAS DE CLASE

**************************************************************************
* TITULO..: IMPRIME LAS LISTAS DE CLASE                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUE 18/1996 JUE A
       Colombia, Bucaramanga        INICIO: 02:10 PM   JUE 18/1996 JUE

OBJETIVOS:

1- Permite imprimir las listas de clase del profesor

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_101(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual

       LOCAL     i,j := 0                   // Contador
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nTipLis := 0                   // Tipo de Lista

       LOCAL nNroPer := 0                   // N£mero de Periodos
       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nTipBol := 0                   // Tipo de Boletin
       LOCAL nNroLin := 0                   // N£mero de l¡neas
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL cNomMat := ''                  // Nombre de la Materia
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared)       .OR.;
	  !lUseMae(lShared,PathUno+'\'+cPatSis+'\',cMaeAct,cAnoSis) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FProTbl+cMaeAct+ExtFile,'TBL',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
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
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE TBL->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL NIVEL')

       CASE TBL->nTipLisTbl > 5
	    cError('LISTA DE CLASE NO PERMITIDA '+STR(TBL->nTipLisTbl,2))

       CASE TBL->nLisAuxTbl > 5
	    cError('LISTA AUXILIAR NO PERMITIDA '+STR(TBL->nLisAuxTbl,2))

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       lHayErr := .F.
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SPR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,nTotPer)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>VALIDACION DE LA LECTURA
       nNroOpc := 1
       IF TBL->nLisAuxTbl > 0
	  nNroOpc := nLeeOpcion('FAVOR SELECIONE: '+;
				'1<LISTA DE CLASE> 2<LISTA AUXILIAR> '+;
				'3<REGRESAR?',3,'0')
	  IF nNroOpc == 3
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       nTipLis := IF(nNroOpc==1,TBL->nTipLisTbl,TBL->nLisAuxTbl)
*>>>>FIN VALIDACION DE LA LECTURA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervCaP(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL NUMERO DE LINEAS
       nNroLin := 1
       IF EMPTY(TBL->nTipLisTbl)
	  @ nFilInf+3,nColInf SAY 'NRO LINEAS' GET nNroLin PICT '99'
	  READ
	  IF nNroLin == 0
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>LECTURA DEL NUMERO DE COPIA
       nCopias := 1
       @ nFilInf+3,nColInf SAY 'NRO COPIAS' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nNroIso := 101
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<LISTAS><LISTAS DE CLASE>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'')  // T¡tulo Uno
       AADD(aTitIso,'')  // T¡tulo Dos
       AADD(aTitIso,'')  // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       aPieIso := {}
       AADD(aPieIso,'')  // Pie de p gina Uno
       AADD(aPieIso,'')  // Pie de p gina Dos
       AADD(aPieIso,'')  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SPR->lPrnArcSpr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'listas'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.T.,.F.,bInsIso)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
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

*>>>>IMPRESION DE N COPIAS
       SET DEVICE TO SCREEN
       nTipBol := 3
       DO WHILE nNroCop <= nCopias

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO'+'ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			 STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRISION DE LOS GRUPOS
	    SELECT CAP
	    GO nRegIni
	    DO WHILE CAP->(RECNO()) <= nRegFin

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,cPatPro+'\'+;
				 CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
		    cError('ABRIENDO ARCHIVO DE NOTAS DEL PROFESOR GRUPO '+;
			   SUBS(CAP->cCodigoCar,5,4))

		    CAP->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------NOMBRE DEL AREA
		 cNomMat := CAP->cNombreMat
		 IF SUBS(CAP->cCodigoCar,3,2) == '00'
		    cNomMat := 'AREA '+CAP->cNombreMat
		 ENDIF
		 cNomMat := SUBS(CAP->cCodigoCar,1,4)+':'+ALLTRIM(cNomMat)
		 cNomMat := SUBS(cNomMat+SPACE(80),1,80)
*--------------FIN NOMBRE DEL AREA

*--------------VALIDACION DE CONTENIDOS DE ARCHIVOS
		 lHayErr := .T.
		 cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
		 DO CASE
		 CASE NOP->(RECCOUNT()) == 0
		      cError('NO EXISTEN ESTUDIANTES DEL GRUPO: '+cCodigoTgr)
		 OTHERWISE
		      lHayErr :=.F.
		 ENDCASE

		 IF lHayErr
		    CAP->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*--------------IMPRESION DE LA LISTA DE CLASE
		 DO CASE
		 CASE nTipLis == 0
		      Lista00(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			      cNomPro,nNroPer,nTipBol,nNroLin,;
			      cCodigoTgr,cNomMat,cMaeAct,;
			      cJorTxt,cPatPro)

		 CASE nTipLis == 1
		      Lista01(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			      cNomPro,nNroPer,nTipBol,nNroLin,;
			      cCodigoTgr,cNomMat,cMaeAct,;
			      cJorTxt,cPatPro)

		 CASE nTipLis == 2
		      Lista02(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			      cNomPro,nNroPer,nTipBol,nNroLin,;
			      cCodigoTgr,cNomMat,cMaeAct,;
			      cJorTxt,cPatPro,cCodIso,aTitIso,aPieIso)

		 CASE nTipLis == 3
		      Lista03(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			      cNomPro,nNroPer,nTipBol,nNroLin,;
			      cCodigoTgr,cNomMat,cMaeAct,;
			      cJorTxt,cPatPro)

		 CASE nTipLis == 4
		      Lista04(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			      cNomPro,nNroPer,nTipBol,nNroLin,;
			      cCodigoTgr,cNomMat,cMaeAct,;
			      cJorTxt,cPatPro,cCodIso,aTitIso,aPieIso)

		 CASE nTipLis == 5
		      Lista05(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			      cNomPro,nNroPer,nTipBol,nNroLin,;
			      cCodigoTgr,cNomMat,cMaeAct,;
			      cJorTxt,cPatPro)
		    *ÀLista de clase sugerida por BeleBan. 2010
		 ENDCASE
*--------------FIN IMPRESION DE LA LISTA DE CLASE

	       CAP->(DBSKIP())
	       CloseDbf('NOP')

	    ENDDO
**********FIN IMPRISION DE LOS GRUPOS

	  nNroCop++

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO..: LISTA DE CLASE POR DEFECTO                                   *
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

FUNCTION Lista00(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,;
		 nNroPer,nTipBol,nNroLin,cCodGru,cNomMat,cMaeAct,;
		 cJorTxt,cPatPro)

*>>>>PARAMATROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       nNroPer                              // N£mero del Periodo
       nTipBol                              // Tipo de Boletin
       nNroLin                              // N£mero de L¡neas
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cPatPro                              // Path del Profesor */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nTotPag := 0                   // Total P ginas
       LOCAL nHanXml := 0                   // Manejador del Archivo
     *ÀVariables de informe

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio

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

       nTotReg := (NOP->(RECCOUNT())*nNroLin)+2

       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  ALLTRIM(cNomMat),;
		  'LISTA DE CLASE PARA EL PERIODO No. '+STR(nNroPer,1),;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
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
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(SPR->lPrnArcSpr)
	   RETURN NIL
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
       nTotPag := 1
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,IF(nTipBol==3,44,26))
	    lRetiroTno := NOP->lRetiroNoP
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
	    IF lRetiroTno .AND. CAP->nTipCarCar # 0
	       NOP->(DBSKIP())
	       LOOP
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

		 aTitulo := {STR(NOP->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D      O'}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

	    CASE lRetiroTno
		 aNroCol := {02,06,26,74,04,04,04,04,02}
		 aTitulo := {STR(NOP->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     IF(CAP->nTipCarCar # 0,;
				'F U E R A  D E  L I S T A',;
				'P E R T E N E C E    A   O T R O  G R U P O')}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))

		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

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

		 aTitulo := {STR(NOP->(RECNO()),2),;
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
		 AADD(aTitulo,STR(NOP->(RECNO()),2))
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion




	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
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

	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
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
		  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
	       ENDFOR
	    ENDIF
**********FIN IMPRESION DE LA SEGUNDA LINEA

	  NOP->(DBSKIP())

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
*>>>>FIN IMPRESION DERECHOS

*>>>>GRABACION DEL LOG
       IF !EMPTY(nTotPag)
	  AADD(aGenLog,{'nCodigoLog',5})
	  AADD(aGenLog,{'cOpcionLog','<LISTAS DE CLASE>'})
	  AADD(aGenLog,{'cMaeActLog',cMaeAct})
	  AADD(aGenLog,{'nNroPerLog',nNroPer})
	  AADD(aGenLog,{'cNomUsrLog',cNomUsr})
	  AADD(aGenLog,{'nPrnLisLog',nTotPag})

	  AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)})
	  AADD(aGenLog,{'cHorIniLog',cHorIni})
	  AADD(aGenLog,{'cHorFinLog',TIME()})

	  cTxtLog :=  ALLTRIM(cNomMat)+' GRUPO: '+;
		      cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)
	  AADD(aCamLog,{'cObsMatLog',cTxtLog})

	  cTxtLog := ''
	  AADD(aCamLog,{'cObservLog',cTxtLog})

	  aCamLog := aGraProLog(lShared,'LOG',aCamLog,aGenLog)
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL LOG

/*************************************************************************
* TITULO..: LISTA DE CLASE No. 1                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUE 18/96 JUE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   JUE 18/96 JUE

OBJETIVOS:

1- Imprime una lista de clase para el grupo determinado sugerido por
   Colsalle

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Lista01(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,;
		 nNroPer,nTipBol,nNroLin,cCodGru,cNomMat,cMaeAct,;
		 cJorTxt,cPatPro)

*>>>>PARAMATROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       nNroPer                              // N£mero del Periodo
       nTipBol                              // Tipo de Boletin
       nNroLin                              // N£mero de L¡neas
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cPatPro                              // Path del Profesor */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nTotPag := 0                   // Total P ginas
     *ÀVariables de informe

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio


       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo

       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := (NOP->(RECCOUNT())*nNroLin)+2
       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  ALLTRIM(cNomMat),;
		  'REGISTRO DE NOTAS. PERIODO No. '+STR(nNroPer,1),;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,16,02,;
		   04,04,04,04,04,04,04,04,04,04,;
		   04,04,04,04,04,04,04,04,04,04}
       AADD(aNroCol,04)
       AADD(aNroCol,02)

       aTitulo := {}
       AADD(aTitulo,'No')
       AADD(aTitulo,'CODIGO')
       AADD(aTitulo,'NOMBRES')
       AADD(aTitulo,'GR')
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,'AUSE')
       AADD(aTitulo,'No')
       cCabCol := cRegPrint(aTitulo,aNroCol)
       cCabCol := STUFF(cCabCol,31,1,'º')
       cCabCol := STUFF(cCabCol,36,1,'º')
       cCabCol := STUFF(cCabCol,91,1,'º')
       cCabCol := STUFF(cCabCol,131,1,'º')
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')

       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(SPR->lPrnArcSpr)
	   RETURN NIL
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
       nTotPag := 1
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,16)
	    lRetiroTno := NOP->lRetiroNoP
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
	    IF lRetiroTno .AND. CAP->nTipCarCar # 0
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE FUERA DE LISTA

**********IMPRESION DE LA PRIMERA LINEA
	    DO CASE
	    CASE lRetiroTes
		 aNroCol := {02,06,16,102}
		 AADD(aNroCol,04)
		 AADD(aNroCol,02)

		 aTitulo := {STR(NOP->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D      O'}
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

	    CASE lRetiroTno
		 aNroCol := {02,06,16,102,04,02}
		 aTitulo := {STR(NOP->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     IF(CAP->nTipCarCar # 0,;
				'F U E R A  D E  L I S T A',;
				'P E R T E N E C E    A   O T R O  G R U P O')}
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

	    CASE !lRetiroTes .AND. !lRetiroTno
		 aNroCol := {02,06,16,02,;
			     04,04,04,04,04,04,04,04,04,04,;
			     04,04,04,04,04,04,04,04,04,04}
		 AADD(aNroCol,04)
		 AADD(aNroCol,02)

		 aTitulo := {}
		 AADD(aTitulo,STR(NOP->(RECNO()),2))
		 AADD(aTitulo,&cMaeAct->cCodigoEst)
		 AADD(aTitulo,cNombreTes)
		 AADD(aTitulo,SPACE(02))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    cTxtPrn := STUFF(cTxtPrn,31,1,'º')
	    cTxtPrn := STUFF(cTxtPrn,36,1,'º')
	    cTxtPrn := STUFF(cTxtPrn,91,1,'º')
	    cTxtPrn := STUFF(cTxtPrn,131,1,'º')

	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
**********FIN IMPRESION DE LA PRIMERA LINEA


	  NOP->(DBSKIP())

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
*>>>>FIN IMPRESION DERECHOS

*>>>>GRABACION DEL LOG
       IF !EMPTY(nTotPag)
	  AADD(aGenLog,{'nCodigoLog',5})
	  AADD(aGenLog,{'cOpcionLog','<LISTAS DE CLASE>'})
	  AADD(aGenLog,{'cMaeActLog',cMaeAct})
	  AADD(aGenLog,{'nNroPerLog',nNroPer})
	  AADD(aGenLog,{'cNomUsrLog',cNomUsr})
	  AADD(aGenLog,{'nPrnLisLog',nTotPag})

	  AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)})
	  AADD(aGenLog,{'cHorIniLog',cHorIni})
	  AADD(aGenLog,{'cHorFinLog',TIME()})

	  cTxtLog :=  ALLTRIM(cNomMat)+' GRUPO: '+;
		      cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)
	  AADD(aCamLog,{'cObsMatLog',cTxtLog})

	  cTxtLog := ''
	  AADD(aCamLog,{'cObservLog',cTxtLog})

	  aCamLog := aGraProLog(lShared,'LOG',aCamLog,aGenLog)
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL LOG

/*************************************************************************
* TITULO..: LISTA DE CLASE No. 2                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 24/2006 MIE A
       Colombia, Bucaramanga        INICIO: 09:30 AM   MAY 24/2006 MIE

OBJETIVOS:

1- Imprime una lista de clase para el grupo determinado, sugerido
   Colegio Virrey Solis.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Lista02(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,;
		 nNroPer,nTipBol,nNroLin,cCodGru,cNomMat,cMaeAct,;
		 cJorTxt,cPatPro,cCodIso,aTitIso,aPieIso)

*>>>>PARAMATROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       nNroPer                              // N£mero del Periodo
       nTipBol                              // Tipo de Boletin
       nNroLin                              // N£mero de L¡neas
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cPatPro                              // Path del Profesor
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso      		            // Textos del pie de p gina */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL aCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bPiePag := NIL                 // Block Pie de p gina
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nTotPag := 0                   // Total P ginas
     *ÀVariables de informe

*       LOCAL cCodIso := ''                  // C¢digo de Iso para el informe
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo

       LOCAL   i,j,k := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

/*
*>>>>CODIGO ISO PARA EL INFORME
	DO CASE
	CASE 'SALLE' $ cNomEmp
	     cCodIso := 'ISO:F-SED-001'

	ENDCASE
	cCodIso := 'ISO:CODIGO PGF-03-R03'
*>>>>FIN CODIGO ISO PARA EL INFORME
*/

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .T.

       nTotReg := (NOP->(RECCOUNT())*nNroLin)+2

       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr+cCodIso,;
		  ALLTRIM(cNomMat),;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2)+'. PERIODO No. '+STR(nNroPer,1),;
		  IF(EMPTY(aTitIso[1]),;
		    'PLANILLA DE EVALUACION',;
		     aTitIso[1]),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA No. 1
       aNroCol := {02,06,40,38,04,04,38,04,04,38,04,04,04,04,04}

       aTitulo := {}
       AADD(aTitulo,'No')
       AADD(aTitulo,'CODIGO')
       AADD(aTitulo,'APELLIDOS Y NOMBRES')
       AADD(aTitulo,'LOGROS 1')
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'LOGROS 2')
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'LOGROS 3')
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,SPACE(04))

       cCabCol := cRegPrint(aTitulo,aNroCol)

       aCabCol := {}
       AADD(aCabCol,cCabCol)
*>>>>ENCABEZADOS DE COLUMNA No. 1

*>>>>ENCABEZADOS DE COLUMNA No. 2
       aNroCol := {02,06,40,;
		   12,12,12,04,04,;
		   12,12,12,04,04,;
		   12,12,12,04,04,;
		   04,04,04}

       aTitulo := {}
       AADD(aTitulo,SPACE(aNroCol[1]))
       AADD(aTitulo,SPACE(aNroCol[2]))
       AADD(aTitulo,SPACE(aNroCol[3]))

       AADD(aTitulo,'IND1')
       AADD(aTitulo,'IND2')
       AADD(aTitulo,'IND3')
       AADD(aTitulo,'PR.I')
       AADD(aTitulo,'RECU')

       AADD(aTitulo,'IND1')
       AADD(aTitulo,'IND2')
       AADD(aTitulo,'IND3')
       AADD(aTitulo,'PR.I')
       AADD(aTitulo,'RECU')

       AADD(aTitulo,'IND1')
       AADD(aTitulo,'IND2')
       AADD(aTitulo,'IND3')
       AADD(aTitulo,'PR.I')
       AADD(aTitulo,'RECU')

       AADD(aTitulo,'DEF ')
       AADD(aTitulo,'JVF ')
       AADD(aTitulo,'AUS ')

       cCabCol := cRegPrint(aTitulo,aNroCol)
       AADD(aCabCol,cCabCol)
*>>>>ENCABEZADOS DE COLUMNA No. 2

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL(IF(lTamAnc,'n17Stan','n17Wide'))
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       aCabSec := {}
       AADD(aCabSec,'PROFESOR: '+ALLTRIM(cNomPro))
       AADD(aCabSec,'LOGRO 1:')
       AADD(aCabSec,'LOGRO 2:')
       AADD(aCabSec,'LOGRO 3:')

       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,aCabCol,;
			       nColCab,cCodFin,aCabSec)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>DEFINICION DEL PIE DE PAGINA
       bPiePag := {||PiePagPrn(aPieIso,nLenPrn)}
/*
       bPiePag := {||PiePagina('LUGAR DE ALMACENAMIENTO: '+;
			       'COORDINACION ACADEMICA '+;
			       'TIEMPO DE RETENCION: 1 A¥O '+;
			       'DISPOSICION FINAL: DESTRUCCION',nLenPrn)}
*/
*>>>>FIN DEFINICION DEL PIE DE PAGINA

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(SPR->lPrnArcSpr)
	   RETURN NIL
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
       nTotPag := 1
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
	    lRetiroTno := NOP->lRetiroNoP
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
	    IF lRetiroTno .AND. CAP->nTipCarCar # 0
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE FUERA DE LISTA

**********IMPRESION DE LA PRIMERA LINEA
	    DO CASE
	    CASE lRetiroTes

		 aNroCol := {02,06,40,160}

		 aTitulo := {}
		 AADD(aTitulo,STR(NOP->(RECNO()),2))
		 AADD(aTitulo,&cMaeAct->cCodigoEst)
		 AADD(aTitulo,cNombreTes)
		 AADD(aTitulo,'R      E      T      I      R      A      D      O')

	    CASE lRetiroTno

		 aNroCol := {02,06,40,160}

		 aTitulo := {}
		 AADD(aTitulo,STR(NOP->(RECNO()),2))
		 AADD(aTitulo,&cMaeAct->cCodigoEst)
		 AADD(aTitulo,cNombreTes)

		 AADD(aTitulo,IF(CAP->nTipCarCar # 0,;
		      'F U E R A  D E  L I S T A',;
		      'P E R T E N E C E    A   O T R O  G R U P O'))

	    CASE !lRetiroTes .AND. !lRetiroTno

		 aNroCol := {02,06,40,;
			     12,12,12,04,04,;
			     12,12,12,04,04,;
			     12,12,12,04,04,;
			     04,04,04}

		 aTitulo := {}

		 AADD(aTitulo,STR(NOP->(RECNO()),2))
		 AADD(aTitulo,&cMaeAct->cCodigoEst)
		 AADD(aTitulo,cNombreTes)

		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,'')
		 AADD(aTitulo,'')

		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,'')
		 AADD(aTitulo,'')

		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,SPACE(06)+'|'+SPACE(05))
		 AADD(aTitulo,'')
		 AADD(aTitulo,'')

		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,SPACE(04))


	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    lPrnReg(01,00,cTxtPrn,bPagina,bPiePag,bCabeza,@nTotPag)
**********FIN IMPRESION DE LA PRIMERA LINEA


	  NOP->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  EVAL(bPiePag)
	 *Impresi¢n de Derechos
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DERECHOS

*>>>>GRABACION DEL LOG
       IF !EMPTY(nTotPag)
	  AADD(aGenLog,{'nCodigoLog',5})
	  AADD(aGenLog,{'cOpcionLog','<LISTAS DE CLASE>'})
	  AADD(aGenLog,{'cMaeActLog',cMaeAct})
	  AADD(aGenLog,{'nNroPerLog',nNroPer})
	  AADD(aGenLog,{'cNomUsrLog',cNomUsr})
	  AADD(aGenLog,{'nPrnLisLog',nTotPag})

	  AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)})
	  AADD(aGenLog,{'cHorIniLog',cHorIni})
	  AADD(aGenLog,{'cHorFinLog',TIME()})

	  cTxtLog :=  ALLTRIM(cNomMat)+' GRUPO: '+;
		      cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)
	  AADD(aCamLog,{'cObsMatLog',cTxtLog})

	  cTxtLog := ''
	  AADD(aCamLog,{'cObservLog',cTxtLog})

	  aCamLog := aGraProLog(lShared,'LOG',aCamLog,aGenLog)
       ENDIF
*>>>>FIN GRABACION DEL LOG

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .T.

       nTotReg := (NOP->(RECCOUNT())*nNroLin)+2
       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr+cCodIso,;
		  ALLTRIM(cNomMat),;
		  'PLANILLA DE EVALUACION. PERIODO No. '+STR(nNroPer,1),;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA No. 1
       aNroCol := {02,02,118,76}

       aTitulo := {}
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,SPACE(02))
       AADD(aTitulo,'INDICADORES DE LOGRO')
       AADD(aTitulo,'INSTANCIAS VERIFICADORAS')

       cCabCol := cRegPrint(aTitulo,aNroCol)

       aCabCol := {}
       AADD(aCabCol,cCabCol)
*>>>>ENCABEZADOS DE COLUMNA No. 1

*>>>>ENCABEZADOS DE COLUMNA No. 2
       aNroCol := {02,02,118,04,04,10,10,10,10,10,10}

       aTitulo := {}
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'')

       AADD(aTitulo,'IND')
       AADD(aTitulo,'I.Y.')
       AADD(aTitulo,'LOGRO1')
       AADD(aTitulo,'FECHA')
       AADD(aTitulo,'LOGRO2')
       AADD(aTitulo,'FECHA')
       AADD(aTitulo,'LOGRO3')
       AADD(aTitulo,'FECHA')

       cCabCol := cRegPrint(aTitulo,aNroCol)

       AADD(aCabCol,cCabCol)
*>>>>ENCABEZADOS DE COLUMNA No. 2

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL(IF(lTamAnc,'n17Stan','n17Wide'))
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       aCabSec := {}
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,aCabCol,;
			       nColCab,cCodFin,aCabSec)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(SPR->lPrnArcSpr)
	   RETURN NIL
       ENDIF

       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
       nTotPag := 1
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       FOR k := 1 TO 3

	   FOR i := 1 TO 3

	     aTitulo := {}
	     AADD(aTitulo,IF(i=1,STR(k,1),''))
	     AADD(aTitulo,STR(i,1))
	     FOR j := 1 TO LEN(aNroCol)-2
		 AADD(aTitulo,'')
	     ENDFOR

	     cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    *Prepara la variable de impresion

	     lPrnReg(01,00,cTxtPrn,bPagina,bPiePag,bCabeza,@nTotPag)

	   ENDFOR

       ENDFOR
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  EVAL(bPiePag)
	 *Impresi¢n de Derechos
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: LISTA DE CLASE POR DEFECTO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUE 18/96 JUE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   JUE 18/96 JUE

OBJETIVOS:

1- Imprime una lista de clase por defecto sin encebezado

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Lista03(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,;
		 nNroPer,nTipBol,nNroLin,cCodGru,cNomMat,cMaeAct,;
		 cJorTxt,cPatPro)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       nNroPer                              // N£mero del Periodo
       nTipBol                              // Tipo de Boletin
       nNroLin                              // N£mero de L¡neas
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cPatPro                              // Path del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nTotPag := 0                   // Total P ginas
     *ÀVariables de informe

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio

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

       nTotReg := (NOP->(RECCOUNT())*nNroLin)+2

       aCabeza := {'','',;
		  ALLTRIM(cNomMat),;
		  'LISTA DE CLASE PARA EL PERIODO No. '+STR(nNroPer,1),;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2)+'.JORNADA '+cJorTxt+'.A¥O:'+cAnoUsr,;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,IF(nTipBol==3,36,26),;
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
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(SPR->lPrnArcSpr)
	   RETURN NIL
       ENDIF
       SendCodes(PCL('Reset'))

       @ PROW()+TBL->nLinEspTbl,00 SAY ''
     *ÀEspacio para el encabezado

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
       nTotPag := 1
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,IF(nTipBol==3,36,26))
	    lRetiroTno := NOP->lRetiroNoP
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
	    IF lRetiroTno .AND. CAP->nTipCarCar # 0
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE FUERA DE LISTA

**********IMPRESION DE LA PRIMERA LINEA
	    DO CASE
	    CASE lRetiroTes
		 aNroCol := {02,06,IF(nTipBol==3,36,26),74}
		 IF nTipBol # 3
		    AADD(aNroCol,04)
		    AADD(aNroCol,04)
		    AADD(aNroCol,04)
		 ENDIF
		 AADD(aNroCol,04)
		 AADD(aNroCol,02)

		 aTitulo := {STR(NOP->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D      O'}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

	    CASE lRetiroTno
		 aNroCol := {02,06,26,74,04,04,04,04,02}
		 aTitulo := {STR(NOP->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     IF(CAP->nTipCarCar # 0,;
				'F U E R A  D E  L I S T A',;
				'P E R T E N E C E   A   O T R O  G R U P O')}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))

		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

	    CASE !lRetiroTes .AND. !lRetiroTno
		 aNroCol := {02,06,IF(nTipBol==3,36,26),;
			     02,06,06,06,06,06,06,06,06,06,06}
		 IF nTipBol # 3
		    AADD(aNroCol,04)
		    AADD(aNroCol,04)
		    AADD(aNroCol,04)
		 ENDIF
		 AADD(aNroCol,04)
		 AADD(aNroCol,02)

		 aTitulo := {STR(NOP->(RECNO()),2),;
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
		 AADD(aTitulo,STR(NOP->(RECNO()),2))
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    SendCodes(PCL('SubryOn'))
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
	    SendCodes(PCL('SubryOf'))
**********FIN IMPRESION DE LA PRIMERA LINEA

**********IMPRESION DE LA SEGUNDA LINEA
	    IF nNroLin >= 2
	       aNroCol := {IF(nTipBol==3,36,26),; //46
			   02,06,06,06,06,06,06,06,06,06,06}
	       IF nTipBol # 3
		  AADD(aNroCol,04)
		  AADD(aNroCol,04)
		  AADD(aNroCol,04)
	       ENDIF
	       AADD(aNroCol,04)
	       AADD(aNroCol,02)

	       aTitulo := {SPACE(IF(nTipBol==3,46,36)),;
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

	       SendCodes(PCL('SubryOn'))
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
	       SendCodes(PCL('SubryOf'))

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

		  SendCodes(PCL('SubryOn'))
		  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
		  SendCodes(PCL('SubryOf'))

	       ENDFOR
	    ENDIF
**********FIN IMPRESION DE LA SEGUNDA LINEA

	  NOP->(DBSKIP())

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
*>>>>FIN IMPRESION DERECHOS

*>>>>GRABACION DEL LOG
       IF !EMPTY(nTotPag)
	  AADD(aGenLog,{'nCodigoLog',5})
	  AADD(aGenLog,{'cOpcionLog','<LISTAS DE CLASE>'})
	  AADD(aGenLog,{'cMaeActLog',cMaeAct})
	  AADD(aGenLog,{'nNroPerLog',nNroPer})
	  AADD(aGenLog,{'cNomUsrLog',cNomUsr})
	  AADD(aGenLog,{'nPrnLisLog',nTotPag})

	  AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)})
	  AADD(aGenLog,{'cHorIniLog',cHorIni})
	  AADD(aGenLog,{'cHorFinLog',TIME()})

	  cTxtLog :=  ALLTRIM(cNomMat)+' GRUPO: '+;
		      cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)
	  AADD(aCamLog,{'cObsMatLog',cTxtLog})

	  cTxtLog := ''
	  AADD(aCamLog,{'cObservLog',cTxtLog})

	  aCamLog := aGraProLog(lShared,'LOG',aCamLog,aGenLog)
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL LOG

/*************************************************************************
* TITULO..: LISTA DE CLASE No. 4                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 12/2007 MAR A
       Colombia, Bucaramanga        INICIO: 09:15 AM   FEB 12/2007 MAR

OBJETIVOS:

1- Imprime una lista de clase para el control y evaluaci¢n de indicadores
   sugerencia del colegio Colegio La Salle. Bucaramanga

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Lista04(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,;
		 nNroPer,nTipBol,nNroLin,cCodGru,cNomMat,cMaeAct,;
		 cJorTxt,cPatPro,cCodIso,aTitIso,aPieIso)

*>>>>PARAMATROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       nNroPer                              // N£mero del Periodo
       nTipBol                              // Tipo de Boletin
       nNroLin                              // N£mero de L¡neas
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cPatPro                              // Path del Profesor
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso      		            // Textos del pie de p gina */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL aCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bPiePag := NIL                 // Block Pie de p gina
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nTotPag := 0                   // Total P ginas
     *ÀVariables de informe

*       LOCAL cCodIso := ''                  // C¢digo de Iso para el informe
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo

       LOCAL   i,j,k := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := (NOP->(RECCOUNT())*nNroLin)+2

       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr+cCodIso,;
		  ALLTRIM(cNomMat),;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2)+'. PERIODO No. '+STR(nNroPer,1),;
		  IF(EMPTY(aTitIso[1]),;
		    'CONTROL Y EVALUACION DE INDICADORES',;
		     aTitIso[1]),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA No. 1
       aNroCol := {02,06,34,;
		   12,12,12,12,12,12,12}

       aTitulo := {}
       AADD(aTitulo,'No')
       AADD(aTitulo,'CODIGO')
       AADD(aTitulo,'APELLIDOS Y NOMBRES')
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'')

       cCabCol := cRegPrint(aTitulo,aNroCol)

       aCabCol := {}
       AADD(aCabCol,cCabCol)
*>>>>ENCABEZADOS DE COLUMNA No. 1

*>>>>ENCABEZADOS DE COLUMNA No. 2
       aNroCol := {02,06,34,;
		   12,12,12,12,12,12,12}

       aTitulo := {}
       AADD(aTitulo,SPACE(aNroCol[1]))
       AADD(aTitulo,SPACE(aNroCol[2]))
       AADD(aTitulo,SPACE(aNroCol[3]))

       AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
		    SPACE(02)+'|'+SPACE(02))
       AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
		    SPACE(02)+'|'+SPACE(02))
       AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
		    SPACE(02)+'|'+SPACE(02))
       AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
		    SPACE(02)+'|'+SPACE(02))
       AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
		    SPACE(02)+'|'+SPACE(02))
       AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
		    SPACE(02)+'|'+SPACE(02))
       AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
		    SPACE(02)+'|'+SPACE(02))

       cCabCol := cRegPrint(aTitulo,aNroCol)
       AADD(aCabCol,cCabCol)
*>>>>ENCABEZADOS DE COLUMNA No. 2

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL(IF(lTamAnc,'n17Stan','n17Wide'))
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       aCabSec := {}
       AADD(aCabSec,'PROFESOR: '+ALLTRIM(cNomPro))
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,aCabCol,;
			       nColCab,cCodFin,aCabSec)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>DEFINICION DEL PIE DE PAGINA
       bPiePag := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN DEFINICION DEL PIE DE PAGINA

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(SPR->lPrnArcSpr)
	   RETURN NIL
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
       nTotPag := 1
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(34),1,34)
	    lRetiroTno := NOP->lRetiroNoP
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
	    IF lRetiroTno .AND. CAP->nTipCarCar # 0
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE FUERA DE LISTA

**********IMPRESION DE LA PRIMERA LINEA
	    DO CASE
	    CASE lRetiroTes

		 aNroCol := {02,06,34,160}

		 aTitulo := {}
		 AADD(aTitulo,STR(NOP->(RECNO()),2))
		 AADD(aTitulo,&cMaeAct->cCodigoEst)
		 AADD(aTitulo,cNombreTes)
		 AADD(aTitulo,'R      E      T      I      R      A      D      O')

	    CASE lRetiroTno

		 aNroCol := {02,06,34,160}

		 aTitulo := {}
		 AADD(aTitulo,STR(NOP->(RECNO()),2))
		 AADD(aTitulo,&cMaeAct->cCodigoEst)
		 AADD(aTitulo,cNombreTes)

		 AADD(aTitulo,IF(CAP->nTipCarCar # 0,;
		      'F U E R A  D E  L I S T A',;
		      'P E R T E N E C E    A   O T R O  G R U P O'))

	    CASE !lRetiroTes .AND. !lRetiroTno

		 aNroCol := {02,06,34,;
			     08,08,08,08,08,08,08}

		 aTitulo := {}

		 AADD(aTitulo,STR(NOP->(RECNO()),2))
		 AADD(aTitulo,&cMaeAct->cCodigoEst)
		 AADD(aTitulo,cNombreTes)

		 AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
			      SPACE(02)+'|'+SPACE(02))
		 AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
			      SPACE(02)+'|'+SPACE(02))
		 AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
			      SPACE(02)+'|'+SPACE(02))
		 AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
			      SPACE(02)+'|'+SPACE(02))
		 AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
			      SPACE(02)+'|'+SPACE(02))
		 AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
			      SPACE(02)+'|'+SPACE(02))
		 AADD(aTitulo,SPACE(02)+'|'+SPACE(02)+'|'+;
			      SPACE(02)+'|'+SPACE(02))

	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    lPrnReg(01,00,cTxtPrn,bPagina,bPiePag,bCabeza,@nTotPag)
**********FIN IMPRESION DE LA PRIMERA LINEA


	  NOP->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  EVAL(bPiePag)
	 *Impresi¢n de Derechos
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DERECHOS

*>>>>GRABACION DEL LOG
       IF !EMPTY(nTotPag)
	  AADD(aGenLog,{'nCodigoLog',5})
	  AADD(aGenLog,{'cOpcionLog','<LISTAS DE CLASE>'})
	  AADD(aGenLog,{'cMaeActLog',cMaeAct})
	  AADD(aGenLog,{'nNroPerLog',nNroPer})
	  AADD(aGenLog,{'cNomUsrLog',cNomUsr})
	  AADD(aGenLog,{'nPrnLisLog',nTotPag})

	  AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)})
	  AADD(aGenLog,{'cHorIniLog',cHorIni})
	  AADD(aGenLog,{'cHorFinLog',TIME()})

	  cTxtLog :=  ALLTRIM(cNomMat)+' GRUPO: '+;
		      cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)
	  AADD(aCamLog,{'cObsMatLog',cTxtLog})

	  cTxtLog := ''
	  AADD(aCamLog,{'cObservLog',cTxtLog})

	  aCamLog := aGraProLog(lShared,'LOG',aCamLog,aGenLog)
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL LOG

/*************************************************************************
* TITULO..: LISTA DE CLASE POR DEFECTO                                   *
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

FUNCTION Lista05(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,;
		 nNroPer,nTipBol,nNroLin,cCodGru,cNomMat,cMaeAct,;
		 cJorTxt,cPatPro)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       nNroPer                              // N£mero del Periodo
       nTipBol                              // Tipo de Boletin
       nNroLin                              // N£mero de L¡neas
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cPatPro                              // Path del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nTotPag := 0                   // Total P ginas
       LOCAL nHanXml := 0                   // Manejador del Archivo
     *ÀVariables de informe

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio

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

       nTotReg := (NOP->(RECCOUNT())*nNroLin)+2

       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  ALLTRIM(cNomMat),;
		  'LISTA DE CLASE PARA EL PERIODO No. '+STR(nNroPer,1),;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitulo := {}
       AADD(aNroCol,02)
       AADD(aTitulo,'No')

       AADD(aNroCol,06)
       AADD(aTitulo,'CODIGO')

       AADD(aNroCol,44)
       AADD(aTitulo,'APELLIDOS Y NOMBRES ')

       AADD(aNroCol,24)
       AADD(aTitulo,'EVALUCIONES')

       AADD(aNroCol,24)
       AADD(aTitulo,'TAREA-TRABAJO')

       AADD(aNroCol,04)
       AADD(aTitulo,'ACUM')

       AADD(aNroCol,06)
       AADD(aTitulo,'A.EVA ')

       AADD(aNroCol,04)
       AADD(aTitulo,'AUSE')

       AADD(aNroCol,02)
       AADD(aTitulo,'No')

       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(SPR->lPrnArcSpr)
	   RETURN NIL
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
       nTotPag := 1
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,IF(nTipBol==3,44,26))
	    lRetiroTno := NOP->lRetiroNoP
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
	    IF lRetiroTno .AND. CAP->nTipCarCar # 0
	       NOP->(DBSKIP())
	       LOOP
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

		 aTitulo := {STR(NOP->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D      O'}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

	    CASE lRetiroTno
		 aNroCol := {02,06,26,74,04,04,04,04,02}
		 aTitulo := {STR(NOP->(RECNO()),2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     IF(CAP->nTipCarCar # 0,;
				'F U E R A  D E  L I S T A',;
				'P E R T E N E C E    A   O T R O  G R U P O')}
		 IF nTipBol # 3
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))
		    AADD(aTitulo,SPACE(04))

		 ENDIF
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

	    CASE !lRetiroTes .AND. !lRetiroTno

		 aNroCol := {}
		 aTitulo := {}
		 AADD(aNroCol,02)
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

		 AADD(aNroCol,06)
		 AADD(aTitulo,&cMaeAct->cCodigoEst)

		 AADD(aNroCol,44)
		 AADD(aTitulo,cNombreTes)

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,06)
		 AADD(aTitulo,'')

		 AADD(aNroCol,04)
		 AADD(aTitulo,'')

		 AADD(aNroCol,02)
		 AADD(aTitulo,STR(NOP->(RECNO()),2))

	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    SendCodes(PCL('SubryOn'))
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
	    SendCodes(PCL('SubryOf'))
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

	       SendCodes(PCL('SubryOn'))
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
	       SendCodes(PCL('SubryOf'))

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
		  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza,@nTotPag)
	       ENDFOR
	    ENDIF
**********FIN IMPRESION DE LA SEGUNDA LINEA

	  NOP->(DBSKIP())

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
*>>>>FIN IMPRESION DERECHOS

*>>>>GRABACION DEL LOG
       IF !EMPTY(nTotPag)
	  AADD(aGenLog,{'nCodigoLog',5})
	  AADD(aGenLog,{'cOpcionLog','<LISTAS DE CLASE>'})
	  AADD(aGenLog,{'cMaeActLog',cMaeAct})
	  AADD(aGenLog,{'nNroPerLog',nNroPer})
	  AADD(aGenLog,{'cNomUsrLog',cNomUsr})
	  AADD(aGenLog,{'nPrnLisLog',nTotPag})

	  AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)})
	  AADD(aGenLog,{'cHorIniLog',cHorIni})
	  AADD(aGenLog,{'cHorFinLog',TIME()})

	  cTxtLog :=  ALLTRIM(cNomMat)+' GRUPO: '+;
		      cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)
	  AADD(aCamLog,{'cObsMatLog',cTxtLog})

	  cTxtLog := ''
	  AADD(aCamLog,{'cObservLog',cTxtLog})

	  aCamLog := aGraProLog(lShared,'LOG',aCamLog,aGenLog)
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL LOG