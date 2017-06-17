/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : MATRICULAS - INFORMES
SUBMODULO...: OTROS DOCUMENTOS - POR ALUMNOS. NUEVOS

**************************************************************************
* TITULO..: IMPRESION OTROS DOCUMENTOS. POR ALUMNOS NUEVOS               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2002 LUN A
       Colombia, Bucaramanga        INICIO: 05:00 PM   OCT 21/2002 LUN

OBJETIVOS:

1- Permite imprimir Otros Documentos de los estudiantes Nuevos
   por alumnos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matr_6374(aParam1,aParam2,aParam3)

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

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL     i,j := 0                   // Contador
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cCabeza := ''                  // Encabezado de columna

       LOCAL nNroCop := 0                   // N£mero de Copias
       LOCAL cDocume := ''                  // Documentos
       LOCAL nLenLin := 0                   // Longitud de la l¡nea
       LOCAL nNroDoc := 1                   // N£mero del Documento
       LOCAL cNroDoc := ''                  // N£mero del Documento
       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda

       LOCAL aMezIni := {}                  // Campos a Mesclar iniciales
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL aFirmas := {}                  // Firmantes del Certificado
       LOCAL bCodBlo := NIL                 // Code Block.
       LOCAL aDatCnt := {}                  // Datos del Contratante

       LOCAL cTxtUno := ''                  // Texto temporal Uno
       LOCAL cTxtDos := ''                  // Texto temporal Dos
       LOCAL cTxtTre := ''                  // Texto temporal tres
       LOCAL cTxtCua := ''                  // Texto temporal Cuatro
       LOCAL lOficio := .F.                 // .T. Tama¤o Oficio

       LOCAL cNumeroTad := ''               // N£mero de Inscripci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante

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
       IF !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+;
		       fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+;
		       FilePer,'PER',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileCnt+ExtFile,'CNT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
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

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS NIVELES GRABADOS')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       IF lPregunta('DESEA CAMBIAR LA IMPRESORA POR DEFECTO:'+;
		     ALLTRIM(PRN->cNombrePrn)+'? No Si')
	  IF nSelPrn(nFilInf,nColInf+1) == 0
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
	  IF !lPregunta('ESCOGIO LA IMPRESORA:'+ALLTRIM(PRN->cNombrePrn)+'. '+;
		       'DESEA CONTINUAR? Si No')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL NUMERO DE LINEAS
       cSavPan := SAVESCREEN(0,0,24,79)
       nLenLin := 150
       @ nFilInf+1,nColInf SAY 'CARACTERES POR LINEA';
			   GET nLenLin PICT '999';
			   VALID nLenLin <= 150
       READ
       IF nLenLin == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DEL NUMERO DE LINEAS

*>>>>LECTURA DEL NUMERO DEL DOCUMENTO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       TitBuscar(18,@nNroFil,@nNroCol,'DIGITOS DE DOS EN DOS:',;
				      'DOCUMENTOS A IMPRIMIR')
       cDocume := SPACE(20)
       @ nNroFil,nNroCol GET cDocume PICT '99999999999999999999'
       READ
       IF EMPTY(cDocume) .OR. !lPar(LEN(ALLTRIM(cDocume)))
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseAll()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DEL NUMERO DEL DOCUMENTO

*>>>>VALIDACION DE LOS DOCUMENTOS
       FOR i := 1 TO LEN(ALLTRIM(cDocume))/2

	   nNroDoc := VAL(SUBS(cDocume,i*2-1,2))
	   cNroDoc := STR(nNroDoc,3)
	   lCorrecion(@cNroDoc)

	   IF !FILE("Bases\Docum"+cNroDoc+'.Doc')
	      cError('EL DOCUMENTO NO EXISTE',;
		     'Bases\Docum'+cNroDoc+'.Doc')
	      CloseAll()
	      RETURN NIL
	   ENDIF

       ENDFOR
*>>>>FIN VALIDACION DE LOS DOCUMENTOS

*>>>>LECTURA DEL NUMERO DE COPIAS
       TitBuscar(18,@nNroFil,@nNroCol,'COPIAS','COPIAS')
       nNroCop := 1
       @ nNroFil,nNroCol GET nNroCop PICT "99"
       READ
       IF EMPTY(nNroCop)
	  CloseAll()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DEL NUMERO DE COPIAS

*>>>>EDICION DEL DOCUMENTO
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

       cTxtDos := 'Inserte el texto: (VALOR11)  => '+;
		    'para incluir el valor11'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR12)  => '+;
		    'para incluir el valor12'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR13)  => '+;
		    'para incluir el valor13'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR14)  => '+;
		    'para incluir el valor14'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR15)  => '+;
		    'para incluir el valor15'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR16)  => '+;
		    'para incluir el valor16'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR17)  => '+;
		    'para incluir el valor17'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR18)  => '+;
		    'para incluir el valor18'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR19)  => '+;
		    'para incluir el valor19'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (VALOR20)  => '+;
		    'para incluir el valor20'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)

       cTxtTre := 'Inserte el texto: (NOMGER)  => '+;
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

       cTxtCua := 'Inserte el texto: <JI>  => '+;
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

       cTxtHlp := cTxtUno+cTxtDos+cTxtTre+cTxtCua
       cTitHlp := 'TEXTOS PARA LA SUSTITUCION'

       CamSusPrn(@aMezIni)
       AADD(aMezIni,{'<SLP>',{||Eject()}})

       AADD(aMezIni,{'(YEAR)',cAnoUsr})
       AADD(aMezIni,{'(FECHA)',cFecha(DATE(),10)})

       lOficio := !lPregunta('DESEA IMPRIMIR EN TAMANO CARTA? Si No')
       IF !lPregunta('VA A IMPRIMIR EN TAMA¥O '+IF(lOficio,'OFICIO','CARTA')+;
		     ' .DESEA CONTINUAR? No Si')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN EDICION DEL DOCUMENTO

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Docum'+cNroDoc
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
			 'DEL ESTUDIANTE',22,'°')
       cCabeza := cRegPrint({'CODIGO','NOMBRE'},;
			    {06,30},@aNroCol)
       @ nNroFil,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LAS NOTAS
       bCodBlo  := {||Eject()}
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)
	    IF lLeeCodAdm(nNroFil,aNroCol[1],;
			  @cNumeroTad,{||lLocCodigo('cNumeroAdm',;
					 'ADM',cNumeroTad,;
					 'NUMERO DE INSCRIPCION')})
		EXIT
	    ENDIF
	    cNombreTes := RTRIM(ADM->cNombreEst)+' '+ADM->cApelliEst
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
	    @ nNroFil,aNroCol[2] SAY cNombreTes
**********FIN LECTURA DEL CODIGO

**********ANALISIS SI EL CANDIDATO ESTA RETIRADO
	    IF ADM->lRetiroAdm
	       cError(cNombreTes+ ' ESTA RETIRADO')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL CANDIDATO ESTA RETIRADO

**********VALIDACION DEL CODIGO
	    IF !ADM->lSiCupoEst
	       cError(cNombreTes+' NO TIENE CUPO')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL CODIGO

**********LOCALIZACION DEL NIVEL
	    IF !lLocCodigo('cCodigoNiv','NIV',SUBS(ADM->cCodigoGru,1,2))
	       cError('EL NIVEL '+SUBS(ADM->cCodigoGru,1,2)+' NO EXISTE')
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL NIVEL

**********CAMPOS A SUSTITUIR EN EL DOCUMENTO
	    aDatCnt := aLocAllCnt('ADM')

	    cNombreTes := RTRIM(ADM->cNombreEst)+' '+;
			  RTRIM(ADM->cApelliEst)


	    aMezcla := {}
	    AADD(aMezcla,{'(FECHA)' ,cFecha(DATE(),10)})

	    AADD(aMezcla,{'(PADRE)' ,ALLTRIM(ADM->cNomPadEst)+' '+;
				     ALLTRIM(ADM->cApePadEst)})
	    AADD(aMezcla,{'(PADNIT)',ALLTRIM(ADM->cPadNitEst)})
	    AADD(aMezcla,{'(PADLUG)',ALLTRIM(ADM->cPadLugEst)})

	    AADD(aMezcla,{'(MADRE)' ,ALLTRIM(ADM->cNomMadEst)+' '+;
				     ALLTRIM(ADM->cApeMadEst)})
	    AADD(aMezcla,{'(MADNIT)',ALLTRIM(ADM->cMadNitEst)})
	    AADD(aMezcla,{'(MADLUG)',ALLTRIM(ADM->cMadLugEst)})

	    AADD(aMezcla,{'(ACUDIENTE)' ,ALLTRIM(ADM->cNomAcuEst)+' '+;
					 ALLTRIM(ADM->cApeAcuEst)})
	    AADD(aMezcla,{'(ACUNIT)',ALLTRIM(ADM->cAcuNitEst)})
	    AADD(aMezcla,{'(ACULUG)'    ,ALLTRIM(ADM->cAcuLugEst)})

	    AADD(aMezcla,{'(ESTUDIANTE)',cNombreTes})
	    AADD(aMezcla,{'(CODIGO)'    ,ADM->cCodigoEst})

	    AADD(aMezcla,{'(GRUPO)'     ,ADM->cCodigoGru})
	    AADD(aMezcla,{'(NIVEL)'     ,cNomNiv(SUBS(ADM->cCodigoGru,1,2))})

	    AADD(aMezcla,{'(NOMGER)'    ,ALLTRIM(SCO->cGerentCon)})
	    AADD(aMezcla,{'(DOCGER)'    ,ALLTRIM(SCO->cNitGerCon)})

	    AADD(aMezcla,{'(C1NOM)',cLocateCnt(cMaeAct,'C1NOM',aDatCnt)})
	    AADD(aMezcla,{'(C1DOC)',cLocateCnt(cMaeAct,'C1DOC',aDatCnt)})
	    AADD(aMezcla,{'(C1LUG)',cLocateCnt(cMaeAct,'C1LUG',aDatCnt)})
	    AADD(aMezcla,{'(C1TIP)',cLocateCnt(cMaeAct,'C1TIP',aDatCnt)})

	    AADD(aMezcla,{'(C2NOM)',cLocateCnt(cMaeAct,'C2NOM',aDatCnt)})
	    AADD(aMezcla,{'(C2DOC)',cLocateCnt(cMaeAct,'C2DOC',aDatCnt)})
	    AADD(aMezcla,{'(C2LUG)',cLocateCnt(cMaeAct,'C2LUG',aDatCnt)})
	    AADD(aMezcla,{'(C2TIP)',cLocateCnt(cMaeAct,'C2TIP',aDatCnt)})

	    AADD(aMezcla,{'(C3NOM)',cLocateCnt(cMaeAct,'C3NOM',aDatCnt)})
	    AADD(aMezcla,{'(C3DOC)',cLocateCnt(cMaeAct,'C3DOC',aDatCnt)})
	    AADD(aMezcla,{'(C3LUG)',cLocateCnt(cMaeAct,'C3LUG',aDatCnt)})
	    AADD(aMezcla,{'(C3TIP)',cLocateCnt(cMaeAct,'C3TIP',aDatCnt)})

	    AADD(aMezcla,{'(C4NOM)',cLocateCnt(cMaeAct,'C4NOM',aDatCnt)})
	    AADD(aMezcla,{'(C4DOC)',cLocateCnt(cMaeAct,'C4DOC',aDatCnt)})
	    AADD(aMezcla,{'(C4LUG)',cLocateCnt(cMaeAct,'C4LUG',aDatCnt)})
	    AADD(aMezcla,{'(C4TIP)',cLocateCnt(cMaeAct,'C4TIP',aDatCnt)})

	    AADD(aMezcla,{'(VALOR1)',;
			    ALLTRIM(TRANS(NIV->nVlrUnoNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR2)',;
			    ALLTRIM(TRANS(NIV->nVlrDosNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR3)',;
			    ALLTRIM(TRANS(NIV->nVlrTreNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR4)',;
			    ALLTRIM(TRANS(NIV->nVlrCuaNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR5)',;
			    ALLTRIM(TRANS(NIV->nVlrCinNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR6)',;
			    ALLTRIM(TRANS(NIV->nVlrSeiNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR7)',;
			    ALLTRIM(TRANS(NIV->nVlrSieNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR8)',;
			    ALLTRIM(TRANS(NIV->nVlrOchNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR9)',;
			    ALLTRIM(TRANS(NIV->nVlrNueNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR10)',;
			    ALLTRIM(TRANS(NIV->nVlrDieNiv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR11)',;
			    ALLTRIM(TRANS(NIV->nVlr011Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR12)',;
			    ALLTRIM(TRANS(NIV->nVlr012Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR13)',;
			    ALLTRIM(TRANS(NIV->nVlr013Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR14)',;
			    ALLTRIM(TRANS(NIV->nVlr014Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR15)',;
			    ALLTRIM(TRANS(NIV->nVlr015Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR16)',;
			    ALLTRIM(TRANS(NIV->nVlr016Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR17)',;
			    ALLTRIM(TRANS(NIV->nVlr017Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR18)',;
			    ALLTRIM(TRANS(NIV->nVlr018Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR19)',;
			    ALLTRIM(TRANS(NIV->nVlr019Niv,'####,###.##'))})

	    AADD(aMezcla,{'(VALOR20)',;
			    ALLTRIM(TRANS(NIV->nVlr020Niv,'####,###.##'))})

	    AADD(aMezcla,{'<SLP>',bCodBlo})
	    AADD(aMezcla,{'<T1>',PCL({'Pica'})})
	    AADD(aMezcla,{'<T2>',PCL({'Elite'})})
	    AADD(aMezcla,{'<C1>',PCL({'CondenOn'})})
	    AADD(aMezcla,{'<C0>',PCL({'CondenOf'})})

	    FOR i := 1 TO LEN(aMezIni)
		AADD(aMezcla,{aMezIni[i,1],aMezIni[i,2]})
	    NEXT
**********FIN CAMPOS A SUSTITUIR EN EL DOCUMENTO

**********IMPRESION DE LA MATRICULA
	    SET DEVICE TO PRINT
	    FOR i := 1 TO nNroCop

		FOR j := 1 TO LEN(ALLTRIM(cDocume))/2
		    nNroDoc := VAL(SUBS(cDocume,j*2-1,2))
		    cNroDoc := STR(nNroDoc,3)
		    lCorrecion(@cNroDoc)
		    PrnFileDoc("Bases\Docum"+cNroDoc+'.Doc',;
			       aMezcla,nLenLin,NIL,NIL,lOficio)
		ENDFOR

	    ENDFOR
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DE LA MATRICULA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
				   'DEL ESTUDIANTE',22,'°')
		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,01 SAY cNumeroTad
		 SET COLOR TO

		 @ nNroFil,aNroCol[2] SAY cNombreTes
*--------------FIN IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LAS NOTAS DE LOS ESTUDIANTES