/*                    SIMA - CONTABILIDAD ACADEMICA
	    BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE BOLETINES EN XML

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: GENERACION DEL BOLETIN EN XML                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 10/2004 JUE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   JUN 10/2004 JUE

OBJETIVOS:

1- Genera el boletin para un estudiante con solo indicadores con el
   control de las recuperaciones en cada asignatura en Xml

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoleXml07(lShared,cCodEmp,cNomEmp,cNomSis,cAnoUsr,cPatSis,PathCar,;
		   cNomEst,cTitUno,cTitDos,nNroBis,cPorcen,nPorAcu,cJorTxt,;
		   cMaeAct,aNotAre,aNotMat,aFirmas)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cCodEmp                              // C¢digo de la Empresa
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del sistema
       cPatSis                              // Path del Sistema
       PathCar                              // Path del SimaCart
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aFirmas                              // Firmas para el libro final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nHanXml := -1                  // Manejador del Archivo

       LOCAL FileXml := ''                  // Archivo Xml
       LOCAL cUrlXsl := ''                  // Url para el Xsl
       LOCAL cUrlBol := ''                  // Url para el Boletin
       LOCAL cLogBol := ''                  // Logo del Boletin
       LOCAL cUrlFot := ''                  // Url para la Foto
       LOCAL cFotEst := ''                  // Foto del Estudiante
       LOCAL cExtFot := ''                  // Extension de la Foto
       LOCAL cMsgBol := ''                  // Mensaje para el boletin

       LOCAL PathWeb := ''                  // Path del sistio
       LOCAL FileImg := ''                  // Archivo de Imagen
       LOCAL FileXsl := ''                  // Archivo Xsl

       LOCAL i,j := 0                       // Contadores
       LOCAL lNotAre := .F.                 // .T. Nota de Area .F. Nota de Asignatura
       LOCAL nSdoEst := 0                   // Saldo Actual del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL ESTUDIANTE
       nSdoEst := -1
       IF !EMPTY(PathCar)
	  IF lLocCodigo('cCodigoEst','CLI',NOT->cCodigoEst)
	     nSdoEst := CLI->nSdoActCli+CLI->nSdoMorCli
	  ELSE
	     nSdoEst := -1
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL ESTUDIANTE

*>>>>ANALISIS DE LA URL
      PathWeb := '..\..\..\..\..\simaweb'
      FileXsl := PathWeb+'\img\boleti07.www'

       cUrlXsl := 'href="http://simavirtual.com/b/'+LOWER(cCodEmp)+'/'
       IF !EMPTY(TCO->cUrlBolTbl)
	  cUrlBol := ALLTRIM(TCO->cUrlBolTbl)
       ELSE
	  cUrlBol := 'http://simavirtual.com/b/'+LOWER(cCodEmp)+'/'
       ENDIF
       cUrlBol := ALLTRIM(TCO->cUrlBolTbl)

       IF !EMPTY(TCO->cLogBolTbl)
	  cLogBol := ALLTRIM(TCO->cLogBolTbl)
       ELSE
	  cLogBol := 'logo.gif'
       ENDIF

       IF !EMPTY(TCO->cUrlFotTbl)
	  cUrlFot := ALLTRIM(TCO->cUrlFotTbl)
       ELSE
	  cUrlFot := PathWeb+'\fotos\'
       ENDIF

       IF !EMPTY(TCO->cExtFotTbl)
	  cExtFot := ALLTRIM(TCO->cExtFotTbl)
       ELSE
	  cExtFot := '.jpg'
       ENDIF

       cFotEst := NOT->cCodigoEst+'01'
       IF !FILE('..\simaweb\fotos\'+cFotEst+cExtFot)
	  cUrlFot := ''
	  cFotEst := ''
	  cExtFot := ''
       ENDIF

       IF !FILE('..\simaweb\img\'+cLogBol)
	  cLogBol := ''
       ELSE
	  cLogBol := PathWeb+'\img\'+cLogBol
       ENDIF
*>>>>FIN ANALISIS DE LA URL

*>>>>MENSAJDE DEL BOLETIN
       IF nNroBis == TCO->nTotPerTbl
	  IF EMPTY(ALLTRIM(TCO->cBolFinTbl))
	     cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
	  ELSE
	     cMsgBol := ALLTRIM(TCO->cBolFinTbl)
	  ENDIF
       ELSE
	  cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
       ENDIF
*>>>>FIN MENSAJDE DEL BOLETIN

*>>>>CREACION DEL ARCHIVO
       FileXml := cPatSis+'\sitios\boletin\boleestu'+'\'+;
		  'p'+STR(nNroBis,1)+NOT->cCodigoEst+'.xml'

       IF FCREATE(FileXml,0) == -1
	   cError(FileXml,'EL ARCHIVO','NO SE PUEDE CREAR')
	   CloseAll()
	   Quit
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHanXml := FOPEN(FileXml,2)) = -1 .AND. lFHayErr(FileXml)
	  cError(FileXml,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
       lSaveTxt('<?xml version="1.0" encoding="iso-8859-1"?>',;
		nHanXml,FileXml)

       lSaveTxt('<?xml-stylesheet type="text/xsl" href="'+FileXsl+'"?>',nHanXml,FileXml)
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>CREACION DEL ENCABEZADO
       lSaveTxt('<boletin'+CHR(13)+CHR(10)+SPACE(02)+;
		    'codigo="'+NOT->cCodigoEst+'"'+;
			       CHR(13)+CHR(10)+SPACE(02)+;
		    'logo="'+cLogBol+'"'+;
			       CHR(13)+CHR(10)+SPACE(02)+;
		    'nombre="'+cNomEst+'"'+;
			       CHR(13)+CHR(10)+SPACE(02)+;
		    'periodo="'+STR(nNroBis,1)+'"'+;
				CHR(13)+CHR(10)+SPACE(02)+;
		    'grupo="'+GRU->cCodigoGru+'"'+;
			      CHR(13)+CHR(10)+SPACE(02)+;
		    'lista="'+ALLTRIM(STR(NOT->(RECNO()),2))+'"'+;
			      CHR(13)+CHR(10)+SPACE(02)+;
		    'year="'+cAnoUsr+'"'+;
			     CHR(13)+CHR(10)+SPACE(02)+;
		    'jornada="'+cJorTxt+'"'+;
				CHR(13)+CHR(10)+SPACE(02)+;
		    'titulo="'+ALLTRIM(cMsgBol)+'"'+;
			       CHR(13)+CHR(10)+SPACE(02)+;
		    'urlbol="'+cUrlBol+'"'+;
			       CHR(13)+CHR(10)+SPACE(02)+;
		    'urlfot="'+cUrlFot+'"'+;
			       CHR(13)+CHR(10)+SPACE(02)+;
		    'foto="'+cFotEst+'"'+;
			       CHR(13)+CHR(10)+SPACE(02)+;
		    'extfot="'+cExtFot+'"'+;
			       CHR(13)+CHR(10)+;
		'>',nHanXml,FileXml)
*>>>>CREACION DEL ENCABEZADO

*>>>>IMPRESION DEL CUERPO DEL BOLETIN
       lNotAre := .T.
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL AREA
	     IF SUBS(aNotAre[i][4],7,4) == 'AREN'

		j := 0
		XmlAreMat(nHanXml,FileXml,;
			  aNotAre,aNotMat,i,j,lNotAre,nNroBis)
	     ENDIF
***********FIN IMPRESION DEL AREA

***********IMPRESION DE LA MATERIA
	     FOR j:=1 TO LEN(aNotMat)

		 IF aNotAre[i,2] == aNotMat[j,1]
		    XmlAreMat(nHanXml,FileXml,;
			      aNotAre,aNotMat,i,j,!lNotAre,nNroBis)
		 ENDIF

	     NEXT
***********FIN IMPRESION DE LA MATERIA

       NEXT
       lSaveTxt('</boletin>',nHanXml,FileXml)
*>>>>FIN IMPRESION DEL CUERPO DEL BOLETIN

*>>>>CERRANDO EL ARCHIVO
       IF !FCLOSE(nHanXml) .AND. lFHayErr(FileXml)
	  cError('ERROR CERRANDO EL ARCHIVO '+FileXml)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO EL ARCHIVO


/*************************************************************************
* TITULO..: IMPRESION XML DEL AREA O ASIGNATURA                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 16/2004 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   JUN 16/2004 MIE

OBJETIVOS:

1- Permite imprimir a un archivo xml, las notas respectivas del area o
   asignatura


2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION XmlAreMat(nHanXml,FileXml,aNotAre,aNotMat,i,j,lNotAre,nNroBis)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHanXml                              // Manejador de Archivo Xml
       FileXml                              // Archivo Xml
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       i,j                                  // Contador de Area y Materia
       lNotMat                              // .T. Nota Area .F. Nota Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL p,k,y,x := 0                   // Contadores
       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL cTx1Top := ''                  // Texto para el Encabezado
       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cNroFol := NIL                 // N£mero de Folio

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lPrnEva := .F.                 // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       LOCAL nLenEva := 0                   // Longitud del Nombre de la Evaluaci¢n del Indicador
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lPrnCod := .F.                 // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL nLinObs := 0                   // L¡neas de Observaci¢n
       LOCAL bDerPrn := NIL                 // Derechos de Impresi¢n
       LOCAL bCabBol := NIL                 // Encabezados del Boletin
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cAcuAre := ''                  // Acumulado del area
       LOCAL cProAre := ''                  // Promedio del area
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cClaInd := ''                  // Clase de Indicador de Configuraci¢n
       LOCAL cIntens := ''                  // Intensidad Horaria
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL cNomCla := ''                  // Nombre de la Clase
       LOCAL lSiPaso := .F.                 // .T. Control de Flujo
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL cMatRec := ''                  // Materia de las Recuperaciones
       LOCAL cTitReN := ''                  // T¡tulo Indicadores NO Recuperados
       LOCAL cTitReS := ''                  // T¡tulo Indicadores SI Recuperados
       LOCAL cIndAnt := ''                  // Indicadores Periodos Anteriores
       LOCAL cChrIni := ''                  // C¢digo Inicial de Impresi¢n
       LOCAL cChrFin := ''                  // C¢digo Final de Impresi¢n
       LOCAL cChrLin := ''                  // Caracter separador de l¡nea
       LOCAL nNroPos := 0                   // N£mero de la Posici¢n
       LOCAL lPiePag := .T.                 // .T. Imprimir el Pie de P gina
       LOCAL cIndExt := ''                  // Indicador Extra
       LOCAL cClaAnt := ''                  // C¢digo de Clase Anterior
       LOCAL cClaAct := ''                  // C¢digo de Clase Actual

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cCamJuiNot := ''               // Campo de Indicadores
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       cTx1Top := ALLTRIM(SCO->cTxtLibCon)+;
		  ALLTRIM(SCO->cTxtLi1Con)
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='1',.T.,.F.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)
       cMsgBol := ALLTRIM(TCO->cMsgBolTbl)


       IF !lPrnNot
	  lHayNot := .F.
       ENDIF
       IF !lHayNot .AND. lEvaInd
	  lNotNum := .F.
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>ANALISIS DE LA IMPRESION
       IF lNotAre
	  IF aNotAre[i][12]  // .T. No Imprimir
	     RETURN NIL
	  ENDIF
       ELSE
	  IF aNotMat[j][12]   // .T. No Imprimir
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION

*>>>>ANALISIS DE LA IMPRESION DE LA MODALIDAD
       IF lNotAre

	  IF aNotAre[i][13]  // .T. Modalidad
	     cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
	     IF EMPTY(cJuicio)
		RETURN NIL
	     ENDIF
	     cJuicio := ''
	  ENDIF

       ELSE

	  IF aNotMat[j][13]  // .T. Modalidad
	     cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(01)
	     IF EMPTY(cJuicio)
		RETURN NIL
	     ENDIF
	  ENDIF

       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*>>>>LECTURA DE LA NOTA
       cNota := ''
       IF EMPTY(cNotAcu)

	  IF lNotAre
	     cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
	  ELSE
	     cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
	  ENDIF
	  cNota := ALLTRIM(cNota)

       ELSE

	  IF lNotAre
	     cCamNotDef := aNotAre[i,4]
	     cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
	  ELSE
	     cCamNotDef := aNotMat[j,4]
	     cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
	  ENDIF

	  FOR p := 1 TO nNroBis

	      cNotDef := SUBS(&cCamNotDef,p*4-3,4)
	      cNotRec := SUBS(&cCamNotRec,p*4-3,4)
	      IF lRecNot
		 IF !EMPTY(cNotRec)
		    cNota += ALLTRIM(cNotDef)+;
			     LOWER(ALLTRIM(cNotRec))+SPACE(02)
		 ELSE
		    cNota += cNotDef
		 ENDIF
	      ELSE
		 cNota += cNotDef
	      ENDIF

	  NEXT
       ENDIF
*>>>>FIN LECTURA DE LA NOTA

*>>>>CONTEO DE LAS FALLAS
	  IF lNotAre
	     cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
	  ELSE
	     cCamFal := aNotMat[j,6]
	  ENDIF

	  cNroFal := 0

	  IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
	     FOR k := 1 TO nNroBis
		cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
	     NEXT
	  ELSE
	     cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
	  ENDIF
	  cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*>>>>FIN CONTEO DE LAS FALLAS

*>>>>INTENSIDAD HORARIA
       IF lNotAre
	  cIntens := aNotAre[i,11]
       ELSE
	  cIntens := aNotMat[j,3]
       ENDIF

       IF VAL(cIntens) == 0
	  cIntens := SPACE(02)
       ENDIF
*>>>>FIN INTENSIDAD HORARIA

*>>>>NOMBRE DE LA ASISNATURA
       IF lNotAre
	  cNomAre := aNotAre[i,3]
       ELSE
	  IF lPrnAre
	     IF lMatVar
		cNomMat := ALLTRIM(aNotAre[i,3])+' : '+;
			   ALLTRIM(aNotMat[j,10])
	      *ÀMateria Notas o Certificado
	     ELSE
		cNomMat := ALLTRIM(aNotAre[i,3])+' : '+;
			   ALLTRIM(aNotMat[j,2])
	     ENDIF
	  ELSE
	     IF lMatVar
		cNomMat := aNotMat[j,10]
	      *ÀMateria Notas o Certificado
	     ELSE
		cNomMat := aNotMat[j,2]
	     ENDIF
	  ENDIF
       ENDIF
*>>>>FIN NOMBRE DE LA ASISNATURA

*>>>>IMPRESION DEL REGISTRO
       IF lHayNot .OR. lEvaInd
	  aNotMatXml(lHayNot,lEvaInd,lPrnEva,nLenEva,;
		     lPrnCod,nNroBis,cNotAcu,cIntens,;
		     IF(lNotAre,cNomAre,cNomMat),;
		     cNota,cNroFal,;
		     nHanXml,FileXml)

       ELSE
	  lSaveTxt('<materia>'+IF(lNotAre,cNomAre,cNomMat),nHanXml,FileXml)
	  lSaveTxt('<ih>'+cIntens+'</ih>',nHanXml,FileXml)
	  
       ENDIF
*>>>>FIN IMPRESION DEL REGISTRO

*>>>>ORDENAMIENTO DE LOS INDICADORES
       IF lNotAre
	  cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
       ELSE
	  cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
       ENDIF

       aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
       IF TCO->nRecPerTbl==1
	  aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
       ENDIF
*>>>>FIN ORDENAMIENTO DE LOS INDICADORES

*>>>>IMPRESION DE ETIQUETA DE CLASE
       IF LEN(aJuicio) # 0
	  lSaveTxt('<clase>'+cNomCla,nHanXml,FileXml)
	  cClaAnt := SUBS(aJuicio[1],1,1)
       ENDIF
*>>>>FIN IMPRESION DE ETIQUETA DE CLASE

*>>>>IMPRESION DE LOS INDICADORES
       lSiPaso := .F.
       FOR k := 1 TO LEN(aJuicio)

***********VALIDACION DEL INDICADOR
	     cCodJui    := aJuicio[k]
	     cCodLog    := SUBS(cCodJui,1,4)
	     cCodigoTev := SUBS(cCodJui,5,1)
	     IF EMPTY(cCodJui)
		LOOP
	     ENDIF
***********FIN VALIDACION DEL INDICADOR

***********BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
	     IF lEvaInd .AND. lPrnEva
		IF lLocCodigo('cCodigoEva','EVA',;
			      SUBS(cCodigoTev,1,1),;
			      'DE LA EVALUACION '+cCodJui)
		   cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
		ELSE
		   cCodigoTev := 'NO EXISTE'
		ENDIF
	     ELSE
		cCodigoTev += SPACE(03)
	     ENDIF
***********FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

***********BUSQUEDA DE LA CLASE DE INDICADOR
	     cCodigoTni := SUBS(GRU->cCodigoGru,1,2)

	     IF lNotAre
		cCodigoTma := SUBS(aNotAre[i,6],9,4)
	     ELSE
		cCodigoTma := SUBS(aNotMat[j,11],3,4)
	     ENDIF

	     IF cCodLog # SPACE(04)

		cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
		IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
			      'DE LA CLASE')

		   cNomCla := IF(EMPTY(CLA->cNomBolCla),;
				 "**INDICADORES**",CLA->cNomBolCla)

		   nLenTxt := LEN(ALLTRIM(cNomCla))

		   IF EMPTY(CLA->cCodigoMat)

		      IF lNotAre

			 cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			 cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      ELSE

			 IF EMPTY(SUBS(aNotMat[j,11],1,2))
			    cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			   *Por nivel
			 ELSE
			    cCodigoTni := SUBS(aNotMat[j,11],1,2)
			   *Por Niveles
			 ENDIF

		      ENDIF

		   ELSE
		      cCodigoTni := SPACE(02)
		      cCodigoTma := CLA->cCodigoMat
		   ENDIF
		 *ÀAsignaci¢n del nivel para usar indicador nivel o materia

		ENDIF
	     ENDIF
***********FIN BUSQUEDA DE LA CLASE DE INDICADOR

***********BUSQUEDA DEL INDICADOR
	     cCodigoTju := IF(lIndNiv,;
			      cCodigoTni+cCodigoTma+cCodLog,;
			      cCodigoTma+cCodLog)

	     cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
	     cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)

	     IF lSekCodigo(cCodigoTju,'JUI')
		cNombreTju := cNomInd(JUI->cNombreJui,;
				      CLA->lMinuscCla,;
				      CLA->cTipPrnCla,.T.)
	     ENDIF
	     cNombreTju := ALLTRIM(cNombreTju)
***********FIN BUSQUEDA DEL INDICADOR

***********IMPRESION CLASE DE INDICADOR
	     IF lHayNot .AND. !lEvaInd

		IF !lSiPaso
		   cCodAnt := cCodigoTcl
		ENDIF

		IF cCodAnt $ CLA->cCodClaCla
		   IF !lSiPaso
		      aRegPrn := {}
		      AADD(aRegPrn,SPACE(02))
		      AADD(aRegPrn,cNomCla)

		      IF EMPTY(cNotAcu)
			 AADD(aRegPrn,SPACE(04))
		      ELSE
			 FOR p := 1 TO nNroBis
			    AADD(aRegPrn,SPACE(02))
			 NEXT
		      ENDIF
		      AADD(aRegPrn,SPACE(02))

*		      @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)

		   ENDIF

		   IF k < LEN(aJuicio)
		      IF SUBS(aJuicio[k+1],1,1) == cCodAnt
			 lSiPaso := .T.
		      ELSE
			 lSiPaso := .F.
		      ENDIF
		   ENDIF

		ENDIF
	     ENDIF
***********FIN IMPRESION CLASE DE INDICADOR

***********IMPRESION DEL INDICADOR
	     IF lHayNot .OR. lEvaInd

		aRegPrn := {}
		AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
		AADD(aRegPrn,'- '+cNombreTju)

		IF EMPTY(cNotAcu)
		   AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
		ELSE
		   FOR p := 1 TO nNroBis
		       AADD(aRegPrn,SPACE(02))
		   NEXT
		ENDIF
		AADD(aRegPrn,SPACE(04))

	     ELSE
		aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
			    '- '+cNombreTju,;
			    SPACE(04)}
	     ENDIF
*	     @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
***********FIN IMPRESION DEL INDICADOR

***********IMPRESION DE ETIQUETA DE CLASE
	     IF cClaAnt # cClaAct
		cClaAnt := cClaAct
		lSaveTxt('</clase>',nHanXml,FileXml)
		lSaveTxt('<clase>'+cNomCla,nHanXml,FileXml)
	     ENDIF
***********FIN IMPRESION DE ETIQUETA DE CLASE

***********IMPRESION DE LOS INDICADORES EXTRAS
	     FOR x := 1 TO TCO->nJuiExtTbl

		 cIndExt := &('JUI->cExtra'+STR(x,1)+'Jui')
		 cIndExt := cNomInd(cIndExt,;
				    CLA->lMinuscCla,CLA->cTipPrnCla,.T.)
		 cNombreTju += ' '+ALLTRIM(cIndExt)

		 IF lHayNot .OR. lEvaInd

		    aRegPrn := {}
		    AADD(aRegPrn,SPACE(02))
		    AADD(aRegPrn,'  '+cIndExt)

		    IF EMPTY(cNotAcu)
		       AADD(aRegPrn,SPACE(04))
		    ELSE
		       FOR p := 1 TO nNroBis
			   AADD(aRegPrn,SPACE(02))
		       NEXT
		    ENDIF
		    AADD(aRegPrn,SPACE(04))

		 ELSE
		     aRegPrn := {SPACE(02),;
				 '  '+cIndExt,;
				 SPACE(04)}
		 ENDIF

		 IF !EMPTY(cIndExt)
*		    @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF

lSaveTxt('<ic>'+cClaInd(cClaInd,cCodigoTcl)+'</ic>',nHanXml,FileXml)
lSaveTxt('<ind>'+cNombreTju+'</ind>',nHanXml,FileXml)


	     NEXT
***********FIN IMPRESION DE LOS INDICADORES EXTRAS

       NEXT
*>>>>FIN IMPRESION DE LOS INDICADORES

*>>>>IMPRESION DE ETIQUETA DE CLASE
       IF LEN(aJuicio) # 0
	  lSaveTxt('</clase>',nHanXml,FileXml)
       ENDIF
*>>>>FIN IMPRESION DE ETIQUETA DE CLASE

*>>>>ANALISIS DE LOS INDICADORES RECUPERADOS
       IF nNroBis > 1

**********ANALISIS RECUPERACIONES PERIODOS ANTERIORES
	    FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*--------------INDICADORES POR SI/NO RECUPERAR
		  IF lNotAre
		     cCamJuiNot := aNotAre[i,6]
		  ELSE
		     cCamJuiNot := aNotMat[j,5]
		  ENDIF

		  cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
		     cIndAnt := &cCamJuiNot
		     cSiRecu := ''
		     cNoRecu := ''
		  IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*--------------FIN INDICADORES POR SI/NO RECUPERAR

*--------------IMPRESION DE LOS INDICADORES RECUPERADOS
		 IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
		    !EMPTY(cSiRecu)

		    cTitReS := ALLTRIM(TCO->cTitReSTbl)
		    IF EMPTY(cTitReS)
		       cTitReS := '** INDICADORES RECUPERADOS '+;
				  'PERIODO NO.# **'
		    ENDIF

		    nNroPos := AT('NO.#',cTitReS)
		    IF nNroPos # 0
		       cTitReS := STUFF(cTitReS,;
					nNroPos,4,'No.'+STR(y,1))
		    ENDIF

CambiarChr(@cTitReS,'<>','--')
lSaveTxt('<clase>'+cTitReS,nHanXml,FileXml)

		    IF lHayNot .OR. lEvaInd

		       aRegPrn := {}
		       AADD(aRegPrn,SPACE(02))
		       AADD(aRegPrn,cTitReS)

		       IF EMPTY(cNotAcu)
			  AADD(aRegPrn,SPACE(04))
		       ELSE
			  FOR p := 1 TO nNroBis
			      AADD(aRegPrn,SPACE(02))
			  NEXT
		       ENDIF
		       AADD(aRegPrn,SPACE(04))

		    ELSE
		       aRegPrn := {SPACE(02),;
				   cTitReS,;
				   SPACE(02)}
		    ENDIF
*			  @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)

		    IF lNotAre

			PrnIndXml(nHanXml,FileXml,aNroCol,aTitulo,;
				  SUBS(aNotAre[i,6],9,4),;
				  cSiRecu,lIndNiv,lOficio,;
				  lHayNot,SPACE(09),lEvaInd,;
				  lPrnEva,nLenEva,;
				  cCodigoTni,bDerPrn,;
				  bCabBol,cNotAcu,nNroBis)

		    ELSE

		       IF EMPTY(aNotMat[j,14]) // Materias Selectivas
			  cMatRec := SUBS(aNotMat[j,11],3,4)
		       ELSE
			  cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
		       ENDIF

		       PrnIndXml(nHanXml,FileXml,aNroCol,aTitulo,;
				 cMatRec,;
				 cSiRecu,lIndNiv,lOficio,;
				 lHayNot,SPACE(09),lEvaInd,;
				 lPrnEva,nLenEva,;
				 SUBS(aNotMat[j,11],1,2),;
				 bDerPrn,bCabBol,cNotAcu,nNroBis)


		    ENDIF
lSaveTxt('</clase>',nHanXml,FileXml)
		 ENDIF
*--------------FIN IMPRESION DE LOS INDICADORES RECUPERADOS

*--------------IMPRESION DE LOS INDICADORES POR RECUPERAR
		 IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
		    !EMPTY(cNoRecu) .AND. y < nNroBis

		    cTitReN := ALLTRIM(TCO->cTitReNTbl)
		    IF EMPTY(cTitReN)
		       cTitReN := '** INDICADORES POR RECUPERAR '+;
				  'PERIODO NO.# **'
		    ENDIF

		    nNroPos := AT('NO.#',cTitReN)
		    IF nNroPos # 0
		       cTitReN := STUFF(cTitReN,;
					nNroPos,4,'No.'+STR(y,1))
		    ENDIF
CambiarChr(@cTitReN,'<>','--')

lSaveTxt('<clase>'+cTitReN,nHanXml,FileXml)

		    IF lHayNot .OR. lEvaInd

		       aRegPrn := {}
		       AADD(aRegPrn,SPACE(02))
		       AADD(aRegPrn,cTitReN)

		       IF EMPTY(cNotAcu)
			  AADD(aRegPrn,SPACE(04))
		       ELSE
			  FOR p := 1 TO nNroBis
			      AADD(aRegPrn,SPACE(02))
			  NEXT
		       ENDIF
		       AADD(aRegPrn,SPACE(04))

		    ELSE
		       aRegPrn := {SPACE(02),;
				   cTitReN,;
				   SPACE(02)}
		    ENDIF
*			  @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)

		    IF lNotAre

		       PrnIndXml(nHanXml,FileXml,aNroCol,aTitulo,;
				 SUBS(aNotAre[i,6],9,4),;
				 cNoRecu,lIndNiv,lOficio,;
				 lHayNot,cClaInd,lEvaInd,;
				 lPrnEva,nLenEva,;
				 cCodigoTni,bDerPrn,;
				 bCabBol,cNotAcu,nNroBis)

		    ELSE

		       IF EMPTY(aNotMat[j,14]) // Materias Selectivas
			  cMatRec := SUBS(aNotMat[j,11],3,4)
		       ELSE
			  cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
		       ENDIF

		       PrnIndXml(nHanXml,FileXml,aNroCol,aTitulo,;
				 cMatRec,;
				 cNoRecu,lIndNiv,lOficio,;
				 lHayNot,cClaInd,lEvaInd,;
				 lPrnEva,nLenEva,;
				 SUBS(aNotMat[j,11],1,2),;
				 bDerPrn,bCabBol,cNotAcu,nNroBis)

		    ENDIF
lSaveTxt('</clase>',nHanXml,FileXml)
		 ENDIF
*--------------FIN IMPRESION DE LOS INDICADORES POR RECUPERAR

	    NEXT
**********ANALISIS RECUPERACIONES PERIODOS ANTERIORES

       ENDIF
*>>>>FIN ANALISIS DE LOS INDICADORES RECUPERADOS


lSaveTxt('</materia>',nHanXml,FileXml)

RETURN NIL


/*************************************************************************
* TITULO..: REGISTRO DE IMPRESION DEL BOLETIN                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Prepara el registro de impresi¢n del Boletin en un vector.

2- Retorna el vector de impresion

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aNotMatXml(lHayNot,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		    nNroPer,cNotAcu,cColNo1,cColNo2,cColNo3,;
		    cColNo4,nHanXml,FileXml)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas
       cColNo1                              // Columna No. 1  Intensidad
       cColNo2                              // Columna No. 2  Materia
       cColNo3                              // Columna No. 3  Nota o Notas
       cColNo4                              // Columna No. 4  Fallas
       nHanXml                              // Manejador Archivo Xml
       FileXml                              // Archivo Xml  */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REGISTRO DE IMPRESION DEL BOLETIN
       lSaveTxt('<materia>'+cColNo2,nHanXml,FileXml)
       lSaveTxt('<ih>'+cColNo1+'</ih>',nHanXml,FileXml)

       IF lHayNot .OR. lEvaInd

	  IF lHayNot

	     IF EMPTY(cNotAcu)

		IF lPrnCod  // Nota como Codigo
		   lSaveTxt('<juicio p="P'+STR(nNroPer,1)+'">'+cColNo3+;
			    '</juicio>',nHanXml,FileXml)
		ELSE
		   lSaveTxt('<juicio p="*********JUICIO*********">'+;
			     IF(EMPTY(cColNo3),'',ALLTRIM(cTxtNotaXml(cColNo3)))+;
			    '</juicio>',nHanXml,FileXml)

		ENDIF

	     ELSE

		FOR i := 1 TO nNroPer

		   lSaveTxt('<juicio p="P'+STR(i,1)+'">'+;
				ALLTRIM(SUBS(cColNo3,i*4-3,4))+;
			    '</juicio>',nHanXml,FileXml)
		NEXT

	     ENDIF

	  ELSE

	     IF lPrnEva

		IF nLenEva > 4

		   lSaveTxt('<juicio p="P'+STR(nNroPer,1)+'">'+;
				SPACE(nLenEva)+;
			    '</juicio>',nHanXml,FileXml)

		ELSE

		   lSaveTxt('<juicio p="P'+STR(nNroPer,1)+'">'+;
				SPACE(06)+;
			    '</juicio>',nHanXml,FileXml)

		ENDIF

	     ELSE
		lSaveTxt('<juicio p="P'+STR(nNroPer,1)+'">'+SPACE(04)+;
			 '</juicio>',nHanXml,FileXml)
	     ENDIF
	  ENDIF


       ELSE

	   lSaveTxt('<juicio p="P'+STR(nNroPer,1)+'">'+cColNo3+;
		    '</juicio>',nHanXml,FileXml)

       ENDIF
       lSaveTxt('<aus>'+cColNo4+'</aus>',nHanXml,FileXml)
       RETURN NIL
*>>>>FIN REGISTRO DE IMPRESION DEL BOLETIN


FUNCTION cTxtNotaXml(cNota,lSpaces)

LOCAL cTxtNot := ''

lSpaces := IF(EMPTY(lSpaces),.F.,lSpaces)
DO CASE
CASE 'E' $ cNota
     cTxtNot := '**EXCELENTE**'
CASE 'S' $ cNota
     cTxtNot := 'SOBRESALIENTE'
CASE 'B' $ cNota
     cTxtNot := '****BUENO****'
CASE 'A' $ cNota
     cTxtNot := '**ACEPTABLE**'
CASE 'R' $ cNota
     cTxtNot := '***REGULAR***'
CASE 'I' $ cNota
     cTxtNot := '*INSUFICIENTE*'
CASE 'D' $ cNota
     cTxtNot := '**DEFICIENTE**'
OTHERWISE
     IF .NOT. lSpaces
	cTxtNot := 'SIN NOTA     '
     ENDIF
ENDCASE
RETURN cTxtNot

/*************************************************************************
* TITULO..: IMPRESION DE LOS INDICADORES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 VIE

OBJETIVOS:

1- Imprime los indicadores de cualquier asignatura

2- Los indicadores pueden ser de las recuperaciones.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnIndXml(nHanXml,FileXml,aNroCol,aTitulo,cCodMat,cLogros,;
		   lIndNiv,lOficio,lHayNot,cClaInd,lEvaInd,lPrnEva,;
		   nLenEva,cNivInd,bDerPrn,bCabBol,cNotAcu,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNroCol                              // Columnas de los titulos
       aTitulo                              // T¡tulos para el informe
       cCodMat                              // C¢digo de la Materia
       cLogros                              // Indicadores a Imprimir
       lIndNiv                              // .T. Indicadores por nivel
       lOficio                              // .F. Tama¤o carta
       lHayNot                              // .T. Hay Nota final
       cClaInd                              // Clase de Indicador de Configuraci¢n
       lEvaInd                              // .T. Evaluar el Indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       cNivInd                              // Nivel del Indicador
       bDerPrn                              // Derechos de Impresi¢n
       bCabBol                              // Encabezados del Boletin
       cNotAcu                              // Notas Acumuladas
       nNroPer                              // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   k,j,p := 0                   // Contador
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL aRegPrn := {}                  // Registro de impresion
       LOCAL cIndExt := ''                  // Indicador Extra

       LOCAL cCodigoTcl := ''               // C¢digo de la Clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Descripci¢n del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS INDICADORES
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/5,0)
       FOR k:= 1 TO nNroInd

***********SEPARACION DEL CODIGO DEL LOGRO
	     cCodInd    := SUBS(cLogros,k*6-5,6)
	     cCodLog    := SUBS(cCodInd,1,4)
	     cCodigoTev := SUBS(cCodInd,5,1)
	     IF EMPTY(cCodInd)
		LOOP
	     ENDIF
***********FIN SEPARACION DEL CODIGO DEL LOGRO

***********LOCALIZACION DEL CODIGO DE EVALUACION
	     IF lEvaInd .AND. lPrnEva
		IF lLocCodigo('cCodigoEva','EVA',;
			      SUBS(cCodigoTev,1,1),;
			      'DE LA EVALUACION '+cCodInd)
		   cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
		ELSE
		   cCodigoTev := 'NO EXISTE'
		ENDIF
	     ELSE
		cCodigoTev += SPACE(03)
	     ENDIF
***********FIN LOCALIZACION DEL CODIGO DE EVALUACION

***********LOCALIZACION DE LA CLASE DE INDICADOR
	     cCodigoTni := SUBS(GRU->cCodigoGru,1,2)

	     IF cCodLog # SPACE(04)
		cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
		IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
			      'DE LA CLASE')

*------------------ANALISIS DEL NIVEL PARA EL INDICADOR
		     IF EMPTY(CLA->cCodigoMat)
			IF EMPTY(cNivInd)
			   cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  *Por nivel
			ELSE
*			   cCodigoTni := SUBS(aNotMat[j,11],1,2)
			   cCodigoTni := cNivInd
			  *Por Niveles
			ENDIF
		     ELSE
			cCodMat := CLA->cCodigoMat
			cCodigoTni := SPACE(02)
		     ENDIF
		   *ÀAsignaci¢n del nivel para usar indicador nivel o materia
*------------------FIN ANALISIS DEL NIVEL PARA EL INDICADOR

		ENDIF
	    ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADOR

***********BUSQUEDA DEL INDICADOR
	     cCodigoTju := IF(lIndNiv,;
			      cCodigoTni+cCodMat+cCodLog,;
			      cCodMat+cCodLog)

	     cNombreTju := 'NO EXISTE EL CODIGO '+cCodInd
	     cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
	     IF lSekCodigo(cCodigoTju,'JUI')
		cNombreTju := JUI->cNombreJui
	     ENDIF
***********FIN BUSQUEDA DEL INDICADOR

***********IMPRESION DEL INDICADOR
	     aRegPrn := {}
	     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
	     AADD(aRegPrn,'- '+cNombreTju)

	     IF lHayNot .OR. lEvaInd
		IF EMPTY(cNotAcu)
		   AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
		ELSE
		   FOR p := 1 TO nNroPer
		       AADD(aRegPrn,SPACE(02))
		   ENDFOR
		ENDIF
	     ENDIF
	     AADD(aRegPrn,SPACE(02))

*	     @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
***********FIN IMPRESION DEL INDICADOR

***********IMPRESION DE LOS INDICADORES EXTRAS
	     aRegPrn := {}
	     AADD(aRegPrn,SPACE(02))

	     FOR j := 1 TO TCO->nJuiExtTbl

		 cIndExt := &('JUI->cExtra'+STR(j,1)+'Jui')

		 cNombreTju += ' '+ALLTRIM(cIndExt)

		 AADD(aRegPrn,'  '+cNombreTju)

		 IF lHayNot .OR. lEvaInd
		    IF EMPTY(cNotAcu)
		       AADD(aRegPrn,SPACE(04))
		    ELSE
		       FOR p := 1 TO nNroPer
			   AADD(aRegPrn,SPACE(02))
		       ENDFOR
		    ENDIF
		 ENDIF
		 AADD(aRegPrn,SPACE(02))

lSaveTxt('<ind>'+cNombreTju+'</ind>',nHanXml,FileXml)

		 IF !EMPTY(cNombreTju)
*		    @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF

	     ENDFOR
***********FIN IMPRESION DE LOS INDICADORES EXTRAS


       ENDFOR
       RETURN NIL
*>>>>FIN IMPRESION DE LOS INDICADORES

/*************************************************************************
* TITULO..: CAMBIAR CARACTERES                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 28/2004 LUN A
       Colombia, Bucaramanga        INICIO: 12:20 PM   JUN 28/2004 LUN

OBJETIVOS:

1- Busca cada uno de los caracteres pasados como parametros y los reemplaza
   en correspondecia uno a uno.

2- Retorna el texto con los caracteres reeplazados

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CambiarChr(cTexto,cChrUno,cChrDos)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTexto                               // @Texto a Cambiar
       cChrUno                              // Caracteres a cambiar
       cChrDos                              // Caracteres para cambiar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroPos := 0                   // N£mero de Posici¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REEMPLAZO DE LOS CARACTERES
       FOR i:=1 TO LEN(cChrUno)

	   nNroPos := -1
	   DO WHILE .NOT. nNroPos == 0

	      nNroPos := AT(SUBS(cChrUno,i,1),cTexto)
	      IF nNroPos == 0
		 EXIT
	      ENDIF
	      cTexto := STUFF(cTexto,nNroPos,1,SUBS(cChrDos,i,1))

	   ENDDO
	   
       NEXT
       RETURN NIL
*>>>>FIN REEMPLAZO DE LOS CARACTERES