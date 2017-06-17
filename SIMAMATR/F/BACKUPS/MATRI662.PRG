/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : MATRICULAS
SUBMODULO...: ORDENES         MODULO No. 662

**************************************************************************
* TITULO..: IMPRESION DE LAS ORDENES POR ALUMNOS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 JUE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   AGO 14/96 JUE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir la ¢rdenes de matr¡culas de los estudinates antiguos


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_662(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contadores
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
     *ÀGestion Documental

       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL PathAlu := ''                  // Path de Alumnos
       LOCAL cAnoAnt := .F.                 // A¤o Anterior

       LOCAL nNroDoc := 1                   // N£mero del Documento
       LOCAL cNroDoc := ''                  // N£mero del Documento
       LOCAL cTxtUno := ''                  // Texto temporal Uno
       LOCAL cTxtDos := ''                  // Texto temporal Dos
       LOCAL cTxtTre := ''                  // Texto temporal tres
       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda
       LOCAL lOficio := .F.                 // .T. Tama¤o Oficio
       LOCAL aMezIni := {}                  // Campos a Mesclar iniciales
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL bCodBlo := NIL                 // Code Block.
       LOCAL nLenLin := 0                   // Longitud de la l¡nea
     *ÀVaribles de Edici¢n de Archivos

       LOCAL cNalias := ''                  // Alias Antiguos o nuevos
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nPrnOrd := 5                   // Tipo de Orden de Matr¡cula
       LOCAL nSgtNiv := 0                   // Siguiente Nivel
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
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

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS EN MATRICULAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ANO->nTipOrdAno == 0
	    cError('NO SE HA ESPECIFICADO EL NUMERO DE HOJA ORDEN DE MATRICULA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL NUMERO DEL DOCUMENTO
       IF ANO->nTipOrdAno == 99
	  cSavPan := SAVESCREEN(0,0,24,79)
	  SET CURSOR ON
	  TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','DOCUMENTO MODELO')
	  @ nNroFil,nNroCol GET nNroDoc PICT '99'
	  READ
	  IF EMPTY(nNroDoc)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     CloseAll()
	     RETURN NIL
	  ENDIF
	  cNroDoc := STR(nNroDoc,2)
	  lCorrecion(@cNroDoc)
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DEL DOCUMENTO

*>>>>EDICION DEL DOCUMENTO
       IF ANO->nTipOrdAno == 99

	  cTxtUno := 'Inserte el texto: (FECHA) => '+;
		      'para incluir la Fecha del Sistema'+;
		      CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (PADRE) => '+;
		       'para incluir el nombre del padre'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (PADNIT) => '+;
		       'para incluir la c‚dula del Padre'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (PADLUG) => '+;
		       'para incluir el lugar de la c‚dula del Padre'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (MADRE) => '+;
		       'para incluir el nombre de la madre'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (MADNIT) => '+;
		       'para incluir la c‚dula de la Madre'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (MADLUG) => '+;
		       'para incluir el lugar de la c‚dula de la Madre'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (ACUDIENTE) => '+;
		       'para incluir el nombre del acudiente'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (ACUNIT) => '+;
		       'para incluir la c‚dula del Acudiente'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (ACULUG) => '+;
		       'para incluir el lugar de la c‚dula del Acudiente'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (ESTUDIANTE) => '+;
		       'para incluir el nombre del Estudiante'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (CODIGO) => '+;
		       'para incluir el c¢digo del Estudiante'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (GRUPO) => '+;
		       'para incluir el grupo del Estudiante'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (NIVEL) => '+;
		       'para incluir el Nivel o Grado del Estudiante'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR1)  => '+;
		       'para incluir el valor1'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR2)  => '+;
		       'para incluir el valor2'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR3)  => '+;
		       'para incluir el valor3'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR4)  => '+;
		       'para incluir el valor4'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR5)  => '+;
		       'para incluir el valor5'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR6)  => '+;
		       'para incluir el valor6'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR7)  => '+;
		       'para incluir el valor7'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR8)  => '+;
		       'para incluir el valor8'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR9)  => '+;
		       'para incluir el valor9'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (VALOR10)  => '+;
		       'para incluir el valor10'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)

	  cTxtDos := 'Inserte el texto: (NOMGER)  => '+;
		       'para incluir el Nombre del Rector'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (DOCGER)  => '+;
		       'para incluir la c‚dula del Rector'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (C1DOC)  => '+;
		       'para incluir la c‚dula del Contratante No. 1'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (C1LUG)  => '+;
		       'para incluir e lugar de la c‚dula del Contratante No. 1'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (C2DOC)  => '+;
		       'para incluir la c‚dula del Contratante No. 2'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (C2LUG)  => '+;
		       'para incluir e lugar de la c‚dula del Contratante No. 2'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (C3DOC)  => '+;
		       'para incluir la c‚dula del Contratante No. 3'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (C3LUG)  => '+;
		       'para incluir e lugar de la c‚dula del Contratante No. 3'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (C4DOC)  => '+;
		       'para incluir la c‚dula del Contratante No. 4'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: (C4LUG)  => '+;
		       'para incluir e lugar de la c‚dula del Contratante No. 4'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)

	  cTxtTre := 'Inserte el texto: <JI>  => '+;
		       'para justificar el texto a la izquierda'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: <JD>  => '+;
		       'para justificar el texto a la derecha'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: <JF>  => '+;
		       'para selecionar justificaci¢n completa'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: <T1>  => '+;
		       'Tama¤o de letra No. 1 : PICA(10cpi)'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: <T2>  => '+;
		       'Tama¤o de letra No. 2 : ELITE(12cpi)'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: <C1>  => '+;
		       'Activar impresi¢n Condensado'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		     'Inserte el texto: <C0>  => '+;
		       'Desactivar impresi¢n Condensado'+;
		       CHR(13)+CHR(10)+CHR(13)+CHR(10)

	  cTxtHlp := cTxtUno+cTxtDos+cTxtTre
	  cTitHlp := 'TEXTOS PARA LA SUSTITUCION'

	  bCodBlo  := {||Eject()}
	  CamSusPrn(@aMezIni)
	  AADD(aMezIni,{'<SLP>',bCodBlo})
	  AADD(aMezIni,{'<FECHA>',cFecha(DATE(),10)})

	  EditFile(cNomSis,"Bases\OrdMtr"+cNroDoc+'.Txt',;
			    "Edite el Texto del Documento No. "+cNroDoc,;
			    cTxtHlp,cTitHlp)

	  lOficio := !lPregunta('DESEA IMPRIMIR EN TAMANO CARTA? Si No')
	  IF !lPregunta('VA A IMPRIMIR EN TAMA¥O '+IF(lOficio,'OFICIO','CARTA')+;
			' .DESEA CONTINUAR? No Si')
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RETURN NIL
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
*>>>>FIN EDICION DEL DOCUMENTO

*>>>>ANALISIS DE DECISION
       IF ANO->nTipOrdAno # 99
	  nPrnOrd := nLeeOpcion('1<PREMATRICULA> '+;
				'2<ORDEN MATRICULA> '+;
				'3<SOLICITUD CUPO> '+;
				'4<ACTUALIZACION>?',4,'0')
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECION DEL A¥O ANTERIOR
       IF nPrnOrd < 4
	  cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	  cPatAnt := cPatSis
	  cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	  cPatAnt := PathUno+'\'+cPatAnt
	  PathAlu := PathUno+'\'+cPatSis
       ELSE
	  cAnoAnt := cAnoUsr
	  cPatAnt := PathUno+'\'+cPatSis
       ENDIF
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+;
		       FilePer,'PER',NIL,lShared) .OR.;
	  !lUseMaeMtr(lShared,cPatAnt,cMaeAlu,SUBS(cAnoAnt,3,2),lAnoAct)
	  cError('ABRIENDO ARCHIVOS EN MATRICULAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAA' $ cMaeAlu .AND. JAA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoAnt)

       CASE 'PRA' $ cMaeAlu .AND. PRA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoAnt)

       CASE 'BTA' $ cMaeAlu .AND. BTA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoAnt)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS DE LOS '+;
				   'ESTUDIANTES',22,'°')
       nNroCol := 1
       aTamCol := {06,40,06,06}
       aTitulo := {'CODIGO','NOMBRE','GRUPO ','REPITE'}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 606
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<MATRICULAS><ORDENES>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'')                                 // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

*      cPiePag := ALLTRIM(SCO->cPiePagCon)
       cPiePag := ''
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
	 FilePrn := 'mtr606'+ALLTRIM(STR(ANO->nTipOrdAno,2,0))
	 nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,'2',.T.,.F.,bInsIso)
	 IF EMPTY(nOpcPrn)
	    CloseAll()
	    RETURN NIL
	 ENDIF
	 SendCodes(PCL({"Reset","ProporOf","CondenOn"}))
      ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
*	  cCodIso := 'ISO:'+cCodIso
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

*>>>>GRABACION DE LOS REGISTROS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    SET DEVICE TO SCREEN
	    cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)

	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cMaeAct)
	    cNalias := cMaeAct

	    IF LASTKEY() == K_ESC .OR. EMPTY(cCodigoTes) .OR.;
	       EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := ALLTRIM(RTRIM(&cNalias->cApelliEst)+' '+;
				  &cNalias->cNombreEst)

	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY SUBS(&cNalias->cCodigoGru,1,2)
	    @ nNroFil,aNroCol[4] SAY IF(&cNalias->lRepiteEst,'SI','NO')
**********FIN LECTURA DEL CODIGO

**********VALIDACION DEL CODIGO
	    DO CASE
	    CASE !(&cNalias->lSiCupoEst)
		 cError(cNombreTes+' NO TIENE CUPO')
		 LOOP

/*
	    CASE SUBS(&cNalias->cCodigoGru,1,2) = '11' .AND.;
		 !&cNalias->lRepiteEst .AND. nPrnOrd < 4
		 cError(cNombreTes+' ES BACHILLER')
		 LOOP
*/
	    ENDCASE
**********FIN VALIDACION DEL CODIGO

**********PREGUNTA DE DECISION
	    IF lPregunta('DESEA IMPRIMIR EL FORMATO? Si No',21)
	       SET DEVICE TO PRINT
	       DO CASE
	       CASE ANO->nTipOrdAno == 1
		    OrdenMtr01(cCodigoTes,;
			       &cNalias->cCodigoGru,;
			       &cNalias->cNombreEst,;
			       &cNalias->cApelliEst,;
			       &cNalias->lRepiteEst,;
			       cNomSis,cNomEmp,nPrnOrd,;
			       cCodIso)
		  *ÀOrden de Matr¡cula por Defecto.

	       CASE ANO->nTipOrdAno == 2

		      OrdenMtr02(&cMaeAct->cCodigoEst,;
				 &cMaeAct->cCodigoGru,;
				 &cMaeAct->cNombreEst,;
				 &cMaeAct->cApelliEst,;
				 &cMaeAct->lRepiteEst,;
				 cNomSis,cNomEmp,nPrnOrd)
		    *ÀOrden de Matr¡cula por Defecto con Procedencia.

		 CASE ANO->nTipOrdAno == 3
		      OrdenMtr03(&cMaeAct->cCodigoEst,;
				 &cMaeAct->cCodigoGru,;
				 &cMaeAct->cNombreEst,;
				 &cMaeAct->cApelliEst,;
				 &cMaeAct->lRepiteEst,;
				 cNomSis,cNomEmp,cAnoUsr)
		    *ÀOrden de Matr¡cula por Defecto con Procedencia.

		 CASE ANO->nTipOrdAno == 4
		      FrmActInf1(cMaeAct)
		    *Formato de Actualizaci¢n de informaci¢n

		 CASE ANO->nTipOrdAno == 5
		      FrmActInf2(cMaeAct,cCodIso)
		    *Formato de Actualizaci¢n de informaci¢n con datos

	       CASE ANO->nTipOrdAno == 6
		    OrdenMtr04(cNomSis,cNomEmp,cCodigoTes,;
			       &cNalias->cCodigoGru,;
			       &cNalias->cNombreEst,;
			       &cNalias->cApelliEst,;
			       &cNalias->lRepiteEst,;
			       nPrnOrd)
		  *ÀOrden de Matr¡cula por Defecto.

		 CASE ANO->nTipOrdAno == 7
		      FrmActInf3(cMaeAct)
		    *Formato de Actualizaci¢n de informaci¢n con datos

		 CASE ANO->nTipOrdAno == 8
		      OrdenMtr05(cCodEmp,;
				 &cMaeAct->cCodigoEst,;
				 &cMaeAct->cCodigoGru,;
				 &cMaeAct->cNombreEst,;
				 &cMaeAct->cApelliEst,;
				 &cMaeAct->lRepiteEst,;
				 cNomSis,cNomEmp,cAnoUsr)
		    *ÀOrden de Matr¡cula.

		 CASE ANO->nTipOrdAno == 9

		      OrdenMtr06(cMaeAct,cAnoUsr,cCodIso)
		    *Formato de Actualizaci¢n de informaci¢n con datos

		 CASE ANO->nTipOrdAno == 98  // Igual Hoja de Matr¡cula

		      nSgtNiv := nSgteNiv(VAL(SUBS(&cMaeAct->cCodigoGru,1,2)),;
					     &cMaeAct->lRepiteEst)

		      DO CASE
		      CASE ANO->nTipMtrAno == 1

			   HojaMatr01(&cMaeAct->cCodigoEst,;
				      .F.,;
				      &cMaeAct->lRepiteEst,;
				      nSgtNiv,;
				      &cMaeAct->cNombreEst,;
				      &cMaeAct->cApelliEst,;
				      &cMaeAct->dFecNacEst,;
				      &cMaeAct->cLugNacEst,;
				      &cMaeAct->cDocNitEst,;
				      &cMaeAct->cLugNitEst,;
				      &cMaeAct->cDireccEst,;
				      &cMaeAct->cBarrioEst,;
				      &cMaeAct->cTelefnEst,;
				      ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				      ALLTRIM(&cMaeAct->cApePadEst),;
				      &cMaeAct->cPadNitEst,;
				      &cMaeAct->cPadLugEst,;
				      &cMaeAct->cProPadEst,;
				      &cMaeAct->cEmpPadEst,;
				      &cMaeAct->cCarPadEst,;
				      &cMaeAct->cTelPadEst,;
				      ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				      ALLTRIM(&cMaeAct->cApeMadEst),;
				      &cMaeAct->cMadNitEst,;
				      &cMaeAct->cMadLugEst,;
				      &cMaeAct->cProMadEst,;
				      &cMaeAct->cEmpMadEst,;
				      &cMaeAct->cCarMadEst,;
				      &cMaeAct->cTelMadEst,;
				      ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				      ALLTRIM(&cMaeAct->cApeAcuEst),;
				      &cMaeAct->cAcuNitEst,;
				      &cMaeAct->cAcuLugEst,;
				      &cMaeAct->cTe1AcuEst,;
				      DATE(),;
				      TIME(),;
				      '',cNomSis,;
				      cNomEmp,cAnoUsr,cJorTxt,cCodIso,.F.)
			 *ÀHoja de Matr¡cula por Defecto

		      CASE ANO->nTipMtrAno == 2
			   HojaMatr02(&cMaeAct->cCodigoEst,;
				      .F.,;
				      &cMaeAct->lRepiteEst,;
				      nSgtNiv,;
				      &cMaeAct->cNombreEst,;
				      &cMaeAct->cApelliEst,;
				      &cMaeAct->dFecNacEst,;
				      &cMaeAct->cLugNacEst,;
				      &cMaeAct->cDocNitEst,;
				      &cMaeAct->cLugNitEst,;
				      &cMaeAct->cDireccEst,;
				      &cMaeAct->cBarrioEst,;
				      &cMaeAct->cTelefnEst,;
				      ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				      ALLTRIM(&cMaeAct->cApePadEst),;
				      &cMaeAct->cPadNitEst,;
				      &cMaeAct->cPadLugEst,;
				      &cMaeAct->cProPadEst,;
				      &cMaeAct->cEmpPadEst,;
				      &cMaeAct->cCarPadEst,;
				      &cMaeAct->cTelPadEst,;
				      ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				      ALLTRIM(&cMaeAct->cApeMadEst),;
				      &cMaeAct->cMadNitEst,;
				      &cMaeAct->cMadLugEst,;
				      &cMaeAct->cProMadEst,;
				      &cMaeAct->cEmpMadEst,;
				      &cMaeAct->cCarMadEst,;
				      &cMaeAct->cTelMadEst,;
				      ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				      ALLTRIM(&cMaeAct->cApeAcuEst),;
				      &cMaeAct->cAcuNitEst,;
				      &cMaeAct->cAcuLugEst,;
				      &cMaeAct->cTe1AcuEst,;
				      DATE(),;
				      TIME(),;
				      '',cNomSis,;
				      cNomEmp,cAnoUsr,cJorTxt,cCodIso,.F.)
			 *ÀHoja de Matr¡cula con Procedencia

		    CASE ANO->nTipMtrAno == 3

			 HojaMatr03(&cMaeAct->cCodigoEst,;
				    .F.,;
				    &cMaeAct->lRepiteEst,;
				    nSgtNiv,;
				    &cMaeAct->cNombreEst,;
				    &cMaeAct->cApelliEst,;
				    &cMaeAct->dFecNacEst,;
				    &cMaeAct->cLugNacEst,;
				    &cMaeAct->cDocNitEst,;
				    &cMaeAct->cLugNitEst,;
				    &cMaeAct->cDireccEst,;
				    &cMaeAct->cBarrioEst,;
				    &cMaeAct->cTelefnEst,;
				    &cMaeAct->cTelCelEst,;
				    &cMaeAct->cMaiEstEst,;
				    ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				    ALLTRIM(&cMaeAct->cApePadEst),;
				    &cMaeAct->cPadNitEst,;
				    &cMaeAct->cPadLugEst,;
				    &cMaeAct->cProPadEst,;
				    &cMaeAct->cEmpPadEst,;
				    &cMaeAct->cDirPadEst,;
				    &cMaeAct->cBarPadEst,;
				    &cMaeAct->cCarPadEst,;
				    &cMaeAct->cTelPadEst,;
				    &cMaeAct->cCelPadEst,;
				    &cMaeAct->cFaxPadEst,;
				    &cMaeAct->cBipPadEst,;
				    &cMaeAct->cMaiPadEst,;
				    ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				    ALLTRIM(&cMaeAct->cApeMadEst),;
				    &cMaeAct->cMadNitEst,;
				    &cMaeAct->cMadLugEst,;
				    &cMaeAct->cProMadEst,;
				    &cMaeAct->cEmpMadEst,;
				    &cMaeAct->cDirMadEst,;
				    &cMaeAct->cBarMadEst,;
				    &cMaeAct->cCarMadEst,;
				    &cMaeAct->cTelMadEst,;
				    &cMaeAct->cCelMadEst,;
				    &cMaeAct->cFaxMadEst,;
				    &cMaeAct->cBipMadEst,;
				    &cMaeAct->cMaiMadEst,;
				    &cMaeAct->cParAcuEst,;
				    ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				    ALLTRIM(&cMaeAct->cApeAcuEst),;
				    &cMaeAct->cAcuNitEst,;
				    &cMaeAct->cAcuLugEst,;
				    &cMaeAct->cProAcuEst,;
				    &cMaeAct->cEmpAcuEst,;
				    &cMaeAct->cDirAcuEst,;
				    &cMaeAct->cBarAcuEst,;
				    &cMaeAct->cCarAcuEst,;
				    &cMaeAct->cTe1AcuEst,;
				    &cMaeAct->cCelAcuEst,;
				    &cMaeAct->cFaxAcuEst,;
				    &cMaeAct->cBipAcuEst,;
				    &cMaeAct->cMaiAcuEst,;
				    DATE(),;
				    TIME(),;
				    '',cNomSis,;
				    cNomEmp,cAnoUsr,cJorTxt,cCodIso,.F.)
		       *ÀHoja de Matr¡cula La Salle Bogota

		      CASE ANO->nTipMtrAno == 5
			   HojaMatr05(&cMaeAct->cCodigoEst,;
				      .F.,;
				      &cMaeAct->lRepiteEst,;
				      nSgtNiv,;
				      &cMaeAct->cNombreEst,;
				      &cMaeAct->cApelliEst,;
				      &cMaeAct->dFecNacEst,;
				      &cMaeAct->cLugNacEst,;
				      &cMaeAct->cDocNitEst,;
				      &cMaeAct->cLugNitEst,;
				      &cMaeAct->cDireccEst,;
				      &cMaeAct->cBarrioEst,;
				      &cMaeAct->cTelefnEst,;
				      &cMaeAct->cTelCelEst,;
				      &cMaeAct->cMaiEstEst,;
				      ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				      ALLTRIM(&cMaeAct->cApePadEst),;
				      &cMaeAct->cPadNitEst,;
				      &cMaeAct->cPadLugEst,;
				      &cMaeAct->cProPadEst,;
				      &cMaeAct->cEmpPadEst,;
				      &cMaeAct->cCarPadEst,;
				      &cMaeAct->cTelPadEst,;
				      &cMaeAct->cDirPadEst,;
				      &cMaeAct->cCelPadEst,;
				      ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				      ALLTRIM(&cMaeAct->cApeMadEst),;
				      &cMaeAct->cMadNitEst,;
				      &cMaeAct->cMadLugEst,;
				      &cMaeAct->cProMadEst,;
				      &cMaeAct->cEmpMadEst,;
				      &cMaeAct->cCarMadEst,;
				      &cMaeAct->cTelMadEst,;
				      &cMaeAct->cDirMadEst,;
				      &cMaeAct->cCelMadEst,;
				      ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				      ALLTRIM(&cMaeAct->cApeAcuEst),;
				      &cMaeAct->cAcuNitEst,;
				      &cMaeAct->cAcuLugEst,;
				      &cMaeAct->cTe1AcuEst,;
				      &cMaeAct->cDirAcuEst,;
				      &cMaeAct->cProAcuEst,;
				      &cMaeAct->cCelAcuEst,;
				      DATE(),;
				      TIME(),;
				      '',cNomSis,;
				      cNomEmp,cAnoUsr,cJorTxt,cCodIso,.F.)
			 *ÀHoja de Matr¡cula. F-AM-04 30-09-2010

		      ENDCASE

	       CASE ANO->nTipOrdAno == 99  // Archivo de Edici¢n

		    nSgtNiv := nSgteNiv(VAL(SUBS(&cMaeAct->cCodigoGru,1,2)),;
				   &cMaeAct->lRepiteEst)

*===================CAMPOS DE SUSTITUCION
		      aMezcla := {}
		      AADD(aMezcla,{'(ESTUDIANTE)',cNombreTes})
		      AADD(aMezcla,{'(CODIGO)',&cMaeAct->cCodigoEst})
		      AADD(aMezcla,{'(GRUPO)',&cMaeAct->cCodigoGru})
		      AADD(aMezcla,{'(GRADO)',;
				      cNomNiv(SUBS(&cMaeAct->cCodigoGru,1,2))})
		      AADD(aMezcla,{'(NIVEL)',cNomNiv(nSgtNiv)})

		      AADD(aMezcla,{'(cApelliEst)',&cMaeAct->cApelliEst})
		      AADD(aMezcla,{'(cNombreEst)',&cMaeAct->cNombreEst})
		      AADD(aMezcla,{'(dFecNacEst)',cFecha(&cMaeAct->dFecNacEst)})
		      AADD(aMezcla,{'(cLugNacEst)',&cMaeAct->cLugNacEst})
		      AADD(aMezcla,{'(cDocNitEst)',&cMaeAct->cDocNitEst})
		      AADD(aMezcla,{'(cLugNitEst)',&cMaeAct->cLugNitEst})
		      AADD(aMezcla,{'(cTipNitEst)',&cMaeAct->cTipNitEst})
		      AADD(aMezcla,{'(lFotNitEst)',IF(&cMaeAct->lFotNitEst,'S','N')})
		      AADD(aMezcla,{'(lSexFemEst)',IF(&cMaeAct->lSexFemEst,'S','N')})
		      AADD(aMezcla,{'(cDireccEst)',&cMaeAct->cDireccEst})
		      AADD(aMezcla,{'(cBarrioEst)',&cMaeAct->cBarrioEst})
		      AADD(aMezcla,{'(cCiudadEst)',&cMaeAct->cCiudadEst})
		      AADD(aMezcla,{'(cTelefnEst)',&cMaeAct->cTelefnEst})
		      AADD(aMezcla,{'(cTelCelEst)',&cMaeAct->cTelCelEst})
		      AADD(aMezcla,{'(cMaiEstEst)',&cMaeAct->cMaiEstEst})
		      AADD(aMezcla,{'(cParNitEst)',&cMaeAct->cParNitEst})
		      AADD(aMezcla,{'(cNomEpsEst)',&cMaeAct->cNomEpsEst})
		      AADD(aMezcla,{'(cGrupRhEst)',&cMaeAct->cGrupRhEst})

		      AADD(aMezcla,{'(cNitCo1Est)',&cMaeAct->cNitCo1Est})
		      AADD(aMezcla,{'(cTipCo1Est)',&cMaeAct->cTipCo1Est})
		      AADD(aMezcla,{'(lNoRCo1Est)',IF(&cMaeAct->lNoRCo1Est,'S','N')})
		      AADD(aMezcla,{'(cNitCo2Est)',&cMaeAct->cNitCo2Est})
		      AADD(aMezcla,{'(cTipCo2Est)',&cMaeAct->cTipCo2Est})
		      AADD(aMezcla,{'(lNoRCo2Est)',IF(&cMaeAct->lNoRCo2Est,'S','N')})
		      AADD(aMezcla,{'(cNitCo3Est)',&cMaeAct->cNitCo3Est})
		      AADD(aMezcla,{'(cTipCo3Est)',&cMaeAct->cTipCo3Est})
		      AADD(aMezcla,{'(lNoRCo3Est)',IF(&cMaeAct->lNoRCo3Est,'S','N')})
		      AADD(aMezcla,{'(cNitCo4Est)',&cMaeAct->cNitCo4Est})
		      AADD(aMezcla,{'(cTipCo4Est)',&cMaeAct->cTipCo4Est})
		      AADD(aMezcla,{'(lNoRCo4Est)',IF(&cMaeAct->lNoRCo4Est,'S','N')})

		      AADD(aMezcla,{'(cApePadEst)',&cMaeAct->cApePadEst})
		      AADD(aMezcla,{'(cNomPadEst)',&cMaeAct->cNomPadEst})
		      AADD(aMezcla,{'(lPadQepEst)',IF(&cMaeAct->lPadQepEst,'S','N')})
		      AADD(aMezcla,{'(dNacPadEst)',&cMaeAct->dNacPadEst})
		      AADD(aMezcla,{'(cLugPadEst)',&cMaeAct->cLugPadEst})
		      AADD(aMezcla,{'(cPadNitEst)',&cMaeAct->cPadNitEst})
		      AADD(aMezcla,{'(cPadLugEst)',&cMaeAct->cPadLugEst})
		      AADD(aMezcla,{'(cPadTntEst)',&cMaeAct->cPadTntEst})
		      AADD(aMezcla,{'(lPadFotEst)',IF(&cMaeAct->lPadFotEst,'S','N')})
		      AADD(aMezcla,{'(cProPadEst)',&cMaeAct->cProPadEst})
		      AADD(aMezcla,{'(cEmpPadEst)',&cMaeAct->cEmpPadEst})
		      AADD(aMezcla,{'(cCarPadEst)',&cMaeAct->cCarPadEst})
		      AADD(aMezcla,{'(cDirPadEst)',&cMaeAct->cDirPadEst})
		      AADD(aMezcla,{'(cBarPadEst)',&cMaeAct->cBarPadEst})
		      AADD(aMezcla,{'(cCiuPadEst)',&cMaeAct->cCiuPadEst})
		      AADD(aMezcla,{'(cTelPadEst)',&cMaeAct->cTelPadEst})
		      AADD(aMezcla,{'(cCelPadEst)',&cMaeAct->cCelPadEst})
		      AADD(aMezcla,{'(cFaxPadEst)',&cMaeAct->cFaxPadEst})
		      AADD(aMezcla,{'(cBipPadEst)',&cMaeAct->cBipPadEst})
		      AADD(aMezcla,{'(cMaiPadEst)',&cMaeAct->cMaiPadEst})

		      AADD(aMezcla,{'(cApeMadEst)',&cMaeAct->cApeMadEst})
		      AADD(aMezcla,{'(cNomMadEst)',&cMaeAct->cNomMadEst})
		      AADD(aMezcla,{'(lMadQepEst)',IF(&cMaeAct->lMadQepEst,'S','N')})
		      AADD(aMezcla,{'(dNacMadEst)',cFecha(&cMaeAct->dNacMadEst)})
		      AADD(aMezcla,{'(cLugMadEst)',&cMaeAct->cLugMadEst})
		      AADD(aMezcla,{'(cMadNitEst)',&cMaeAct->cMadNitEst})
		      AADD(aMezcla,{'(cMadLugEst)',&cMaeAct->cMadLugEst})
		      AADD(aMezcla,{'(cMadTntEst)',&cMaeAct->cMadTntEst})
		      AADD(aMezcla,{'(lMadFotEst)',IF(&cMaeAct->lMadFotEst,'S','N')})
		      AADD(aMezcla,{'(cProMadEst)',&cMaeAct->cProMadEst})
		      AADD(aMezcla,{'(cEmpMadEst)',&cMaeAct->cEmpMadEst})
		      AADD(aMezcla,{'(cCarMadEst)',&cMaeAct->cCarMadEst})
		      AADD(aMezcla,{'(cDirMadEst)',&cMaeAct->cDirMadEst})
		      AADD(aMezcla,{'(cBarMadEst)',&cMaeAct->cBarMadEst})
		      AADD(aMezcla,{'(cCiuMadEst)',&cMaeAct->cCiuMadEst})
		      AADD(aMezcla,{'(cTelMadEst)',&cMaeAct->cTelMadEst})
		      AADD(aMezcla,{'(cCelMadEst)',&cMaeAct->cCelMadEst})
		      AADD(aMezcla,{'(cFaxMadEst)',&cMaeAct->cFaxMadEst})
		      AADD(aMezcla,{'(cBipMadEst)',&cMaeAct->cBipMadEst})
		      AADD(aMezcla,{'(cMaiMadEst)',&cMaeAct->cMaiMadEst})

		      AADD(aMezcla,{'(cApeAcuEst)',&cMaeAct->cApeAcuEst})
		      AADD(aMezcla,{'(cNomAcuEst)',&cMaeAct->cNomAcuEst})
		      AADD(aMezcla,{'(lAcuQepEst)',IF(&cMaeAct->lAcuQepEst,'S','N')})
		      AADD(aMezcla,{'(dNacAcuEst)',cFecha(&cMaeAct->dNacAcuEst)})
		      AADD(aMezcla,{'(cLugAcuEst)',&cMaeAct->cLugAcuEst})
		      AADD(aMezcla,{'(cAcuNitEst)',&cMaeAct->cAcuNitEst})
		      AADD(aMezcla,{'(cAcuLugEst)',&cMaeAct->cAcuLugEst})
		      AADD(aMezcla,{'(cAcuTntEst)',&cMaeAct->cAcuTntEst})
		      AADD(aMezcla,{'(lAcuFotEst)',IF(&cMaeAct->lAcuFotEst,'S','N')})
		      AADD(aMezcla,{'(cProAcuEst)',&cMaeAct->cProAcuEst})
		      AADD(aMezcla,{'(cEmpAcuEst)',&cMaeAct->cEmpAcuEst})
		      AADD(aMezcla,{'(cCarAcuEst)',&cMaeAct->cCarAcuEst})
		      AADD(aMezcla,{'(cDirAcuEst)',&cMaeAct->cDirAcuEst})
		      AADD(aMezcla,{'(cBarAcuEst)',&cMaeAct->cBarAcuEst})
		      AADD(aMezcla,{'(cCiuAcuEst)',&cMaeAct->cCiuAcuEst})
		      AADD(aMezcla,{'(cTe1AcuEst)',&cMaeAct->cTe1AcuEst})
		      AADD(aMezcla,{'(cTe2AcuEst)',&cMaeAct->cTe2AcuEst})
		      AADD(aMezcla,{'(cCelAcuEst)',&cMaeAct->cCelAcuEst})
		      AADD(aMezcla,{'(cFaxAcuEst)',&cMaeAct->cFaxAcuEst})
		      AADD(aMezcla,{'(cBipAcuEst)',&cMaeAct->cBipAcuEst})
		      AADD(aMezcla,{'(cMaiAcuEst)',&cMaeAct->cMaiAcuEst})
		      AADD(aMezcla,{'(cParAcuEst)',&cMaeAct->cParAcuEst})

		      FOR i := 1 TO LEN(aMezIni)
			  AADD(aMezcla,{aMezIni[i,1],aMezIni[i,2]})
		      NEXT
*===================CAMPOS DE SUSTITUCION

*====================IMPRESION DEL DOCUMENTO
		       PrnFileDoc('Bases\OrdMtr'+cNroDoc+'.Txt',aMezcla,;
				   NIL,NIL,NIL,lOficio)
*====================FIN IMPRESION DEL DOCUMENTO


	       ENDCASE
	       VerPrn(nOpcPrn,FilePrn)
	       SET DEVICE TO SCREEN
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
			    'DE LOS ESTUDIANTES PARA ORDEN DE MATRICULA',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY SUBS(&cNalias->cCodigoGru,1,2)
		 @ nNroFil,aNroCol[4] SAY IF(&cNalias->lRepiteEst,'SI','NO')
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS