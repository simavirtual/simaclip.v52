/*                     BIBLIOTECAS DE FUNCIONES
		     FUNCIONES PARA EL ARCHIVO XML

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: GRABACION DE UN ARCHIVO DE XML                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 29/2002 VIE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   MAR 29/2002 VIE

OBJETIVOS:

1- Crea un archivo texto con campos delimitados.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FileXml(fArchvo,aVlrReg,aTitPrn,aCabPrn,lValida,aPrnXsl)

*>>>>DESCRIPCION DE PARAMETROS
/*     fArchvo                              // Archivo a Crear
       aVlrReg                              // Valor de los Registros
       aTitPrn                              // Nombre de las columnas de los campo
       aCabPrn			            // Encabezado del Informe
       lValida                              // .T. Validar la Existencia del Archivo
       aPrnXsl			            // Xsl del informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL cTxtReg := ''                  // Texto del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>APERTURA DEL ARCHIVO
       nHandle := nOpenXml(fArchvo,aCabPrn,aTitPrn,lValida,aPrnXsl)
       IF EMPTY(nHandle)
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO

*>>>>GRABACION DEL REGISTRO
       FOR i := 1 TO LEN(aVlrReg)
	   SaveRegXml(fArchvo,nHandle,aVlrReg[i])
       ENDFOR
       lSaveTxt('</registros>',nHandle,fArchvo)
*>>>>FIN GRABACION DEL REGISTRO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: APERTURA DEL ARCHIVO XML                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2003 LUN A
       Colombia, Bucaramanga        INICIO: 01:00 PM   MAR 01/2003 LUN

OBJETIVOS:

1- Apertura del Archivo para xml

2- Retorna el manejador del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nOpenXml(fArchvo,aCabPrn,aTitPrn,lValida,aPrnXsl)

*>>>>DESCRIPCION DE PARAMETROS
/*     fArchvo                              // Archivo a Crear
       aCabPrn			            // Encabezado del Informe
       aTitPrn                              // Titulos de Impresion
       lValida                              // .T. Validar la Existencia del Archivo
       aPrnXsl			            // Xsl del informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL cRegXml := ''                  // Registro Xml

       LOCAL PathWeb := ''                  // Path del sistio
       LOCAL nCodXsl := ''                  // C¢digo Xsl de los informes
       LOCAL cCodXsl := ''                  // C¢digo Xsl de los informes
       LOCAL FileXsl := ''                  // Archivo Xsl

       LOCAL cCodInf := ''                  // C¢digo del informe
       LOCAL cCodIso := ''                  // C¢digo Iso
       LOCAL cFecIso := ''                  // Fecha de Aprobaci¢n
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL cPieUno := ''                  // Pie de P gina uno
       LOCAL cPieDos := ''                  // Pie de P gina dos
       LOCAL cPieTre := ''                  // Pie de P gina tres
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO
       lValida := IF(EMPTY(lValida),.F.,lValida)
       IF lValida .AND. File(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','YA EXISTE')
	  IF !lPregunta('DESEA REESCRIBIR EL ARCHIVO? No Si')
	     RETURN 0
	  ENDIF
       ENDIF
       IF FCREATE(fArchvo,0) == -1
	   cError(fArchvo,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN 0
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN 0
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>PATH DE SIMAWEB
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'PathWeb'})
       IF k == 0
	  PathWeb := ''
       ELSE
	  PathWeb := aPrnXsl[k,2]+'\'
       ENDIF
*>>>>FIN PATH DE SIMAWEB

*>>>>XSL DE LOS INFORMES
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'nCodXsl'})
       IF k == 0
	  nCodXsl := 0
       ELSE
	  nCodXsl := aPrnXsl[k,2]
       ENDIF

       cCodXsl := STR(nCodXsl,2)
       lCorrecion(@cCodXsl)
       FileXsl := PathWeb+'IMG\INFHTM'+cCodXsl+'.WWW'
*>>>>FIN XSL DE LOS INFORMES

*>>>>CODIGO DEL INFORME
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'cCodInf'})
       IF k == 0
	  cCodInf := ''
       ELSE
	  cCodInf := aPrnXsl[k,2]
       ENDIF
*>>>>CODIGO DEL INFORME

*>>>>CODIGO ISO DEL INFORME
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'cCodIso'})
       IF k == 0
	  cCodIso := ''
       ELSE
	  cCodIso := aPrnXsl[k,2]
       ENDIF
*>>>>FIN CODIGO ISO DEL INFORME

*>>>>FECHA DE APROBACION ISO
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'cFecIso'})
       IF k == 0
	  cFecIso := ''
       ELSE
	  cFecIso := aPrnXsl[k,2]
       ENDIF
*>>>>FIN FECHA DE APROBACION ISO

*>>>>VERSION DEL INFORME
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'cVerIso'})
       IF k == 0
	  cVerIso := ''
       ELSE
	  cVerIso := aPrnXsl[k,2]
       ENDIF
*>>>>FIN VERSION DEL INFORME

*>>>>PIE DE PAGINA UNO
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'cPieUno'})
       IF k == 0
	  cPieUno := ''
       ELSE
	  cPieUno := aPrnXsl[k,2]
       ENDIF
*>>>>FIN PIE DE PAGINA UNO

*>>>>PIE DE PAGINA DOS
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'cPieDos'})
       IF k == 0
	  cPieDos := ''
       ELSE
	  cPieDos := aPrnXsl[k,2]
       ENDIF
*>>>>FIN PIE DE PAGINA DOS

*>>>>PIE DE PAGINA TRES
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'cPieTre'})
       IF k == 0
	  cPieTre := ''
       ELSE
	  cPieTre := aPrnXsl[k,2]
       ENDIF
*>>>>FIN PIE DE PAGINA TRES

*>>>>VALIDACION DE ENCABEZADO
       DO CASE
       CASE LEN(aCabPrn) == 7
	    AADD(aCabPrn,'')
       ENDCASE
*>>>>FIN VALIDACION DE ENCABEZADO

*>>>>IMPRESION DE LA CABECERA
     lSaveTxt('<?xml version="1.0" encoding="iso-8859-1"?>',nHandle,fArchvo)
     lSaveTxt('<?xml-stylesheet type="text/xsl" href="'+FileXsl+'"?>',nHandle,fArchvo)
     lSaveTxt('<registros '+CHR(13)+CHR(10)+;
		SPACE(03)+'codiinf = "'+lower(cCodInf)+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'pathweb = "'+PathWeb   +'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'empresa = "'+aCabPrn[1]+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'sistema = "'+aCabPrn[2]+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'titulo1 = "'+aCabPrn[3]+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'titulo2 = "'+aCabPrn[4]+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'titulo3 = "'+aCabPrn[5]+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'fechprn = "'+aCabPrn[6]+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'horaprn = "'+aCabPrn[7]+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'fdiaprn = "'+aCabPrn[8]+'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'codiiso = "'+cCodIso   +'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'fechiso = "'+cFecIso   +'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'versiso = "'+cVerIso   +'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'piepag1 = "'+cPieUno   +'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'piepag2 = "'+cPieDos   +'"'+CHR(13)+CHR(10)+;
		SPACE(03)+'piepag3 = "'+cPieTre   +'">'+;
		CHR(13)+CHR(10),nHandle,fArchvo)

       lSaveTxt(SPACE(02)+'<cabecera>',nHandle,fArchvo)
       FOR i := 1 TO LEN(aTitPrn)
	   cRegXml := SPACE(04)+'<columna>'+aTitPrn[i]+'</columna>'
	   lSaveTxt(cRegXml,nHandle,fArchvo)
       ENDFOR
       lSaveTxt(SPACE(02)+'</cabecera>'+CHR(13)+CHR(10),nHandle,fArchvo)

     RETURN nHandle
*>>>>FIN IMPRESION DE LA CABECERA

/*************************************************************************
* TITULO..: CAMPO XML                                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2003 LUN A
       Colombia, Bucaramanga        INICIO: 01:10 PM   MAR 01/2003 LUN

OBJETIVOS:

1- Crea el campo para el archivo Xml

2- Retorna el campo armado para el Xml

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCampoXml(xCampo,cUrlCam)

*>>>>DESCRIPCION DE PARAMETROS
/*     xCampo                               // Campo del Archivo
       cUrlCam			            // Url del Campo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCamXml := ''                 // Campo Xml
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CAMPO
       IF VALTYPE(xCampo) == 'N'
	  xCampo := STR(xCampo,16,2)
       ENDIF
*>>>>FIN VALIDACION DEL CAMPO

*>>>>CREACION DEL CAMPO
       cUrlCam := IF(EMPTY(cUrlCam),' url="no"',' url="'+cUrlCam+'"')
       IF xCampo == NIL
	  cCamXml := ""
       ELSE
	  cCamXml := SPACE(04)+;
		     '<campo'+cUrlCam+'>'+ALLTRIM(xCampo)+'</campo>'
       ENDIF
       RETURN cCamXml
*>>>>FIN CREACION DEL CAMPO

/*************************************************************************
* TITULO..: GRABAR REGISTRO XML                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2003 LUN A
       Colombia, Bucaramanga        INICIO: 02:20 PM   MAR 01/2003 LUN

OBJETIVOS:

1- Grabaci¢n del Campo Xml

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SaveRegXml(fArchvo,nHandle,aRegXml)

*>>>>DECLARACION DE VARIABLES
/*     fArchvo                              // Archivo a Crear
       nHandle                              // Manejador Archivo Binario
       aRegXml                              // Registro Xml */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cRegXml := ''                  // Registro Xml
       LOCAL cUrlReg := ''                  // Url del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DEL REGISTRO
       lSaveTxt('  <registro>',nHandle,fArchvo)

       cRegXml := ''
       FOR i := 1 TO LEN(aRegXml) - 1  // No incluir el campo de Url

	   IF i == 1 .AND. 'XML' $ UPPER(aRegXml[LEN(aRegXml)])
	      cUrlReg := aRegXml[LEN(aRegXml)]
	   ELSE
	      cUrlReg := ''
	   ENDIF
	 *ÀUrl del Campo

	   cRegXml += cCampoXml(aRegXml[i],cUrlReg)

	   IF i < LEN(aRegXml)
	      cRegXml += CHR(13)+CHR(10)
	   ENDIF

       ENDFOR
       lSaveTxt(cRegXml,nHandle,fArchvo)
       lSaveTxt('  </registro>'+CHR(13)+CHR(10),nHandle,fArchvo)
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: GRABAR REGISTRO XML DE EXCEL                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2007 LUN A
       Colombia, Bucaramanga        INICIO: 05:00 PM   ABR 20/2007 LUN

OBJETIVOS:

1- Grabaci¢n del Campo Xml

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RgExcelXml(fArchvo,nHandle,aRegXml)

*>>>>DECLARACION DE VARIABLES
/*     fArchvo                              // Archivo a Crear
       nHandle                              // Manejador Archivo Binario
       aRegXml                              // Registro Xml */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCampo := ''                   // Campo
       LOCAL cType  := ''                   // Tipo de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DEL REGISTRO
       lSaveTxt('   <Row>',nHandle,fArchvo)
       FOR i := 1 TO LEN(aRegXml)
	   cCampo := ALLTRIM(aRegXml[i])
	   IF lCampoNum(cCampo)
	      cType := 'Number'
	   ELSE
	      cType := 'String'
	   ENDIF
	   lSaveTxt('    <Cell><Data ss:Type="'+cType+'">'+cCampo+;
			      '</Data></Cell>',nHandle,fArchvo)
       ENDFOR
       lSaveTxt('   </Row>',nHandle,fArchvo)
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: CERRAR EL ARCHIVO XML                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2003 LUN A
       Colombia, Bucaramanga        INICIO: 02:40 PM   MAR 01/2003 LUN

OBJETIVOS:

1- Grabaci¢n del Campo Xml

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CloseXml(fArchvo,nHandle)

*>>>>DECLARACION DE VARIABLES
/*     fArchvo                              // Archivo a Crear
       nHandle                              // Manejador Archivo Binario */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CERRANDO ARCHIVOS
       lSaveTxt('</registros>',nHandle,fArchvo)
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: APERTURA DEL ARCHIVO XML DE EXCEL 2003                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2007 LUN A
       Colombia, Bucaramanga        INICIO: 04:25 PM   ABR 20/2007 LUN

OBJETIVOS:

1- Apertura del Archivo para xml de Excel 2003

2- Retorna el manejador del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nExcelXml(fArchvo,aCabPrn,aTitPrn,aNroCol,lValida)

*>>>>DESCRIPCION DE PARAMETROS
/*     fArchvo                              // Archivo a Crear
       aCabPrn			            // Encabezado del Informe
       aTitPrn                              // Titulos de Impresion
       aNroCol                              // N£mero de Columnas
       lValida                              // .T. Validar la Existencia del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL cRegXml := ''                  // Registro Xml
       LOCAL nNroCol := 0                   // N£mero de Columnas
       LOCAL nLenTit := ''                  // Longitud del T¡tulo
       LOCAL nNroPos := ''                  // N£mero de la posici¢n
       LOCAL cCodIso := ''                  // C¢digo Iso

       LOCAL cNomEmp := ''                  // Nombre de la empresa
       LOCAL cNomSis := ''                  // Nombre del Sistema
       LOCAL cTitUno := ''                  // T¡tulo Uno
       LOCAL cTitDos := ''                  // T¡tulo Dos
       LOCAL cTitTre := ''                  // T¡tulo Tres
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO
       lValida := IF(EMPTY(lValida),.F.,lValida)
       IF lValida .AND. File(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','YA EXISTE')
	  IF !lPregunta('DESEA REESCRIBIR EL ARCHIVO? No Si')
	     RETURN 0
	  ENDIF
       ENDIF
       IF FCREATE(fArchvo,0) == -1
	   cError(fArchvo,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN 0
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN 0
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>CABECERA DEL ARCHIVO
       lSaveTxt('<?xml version="1.0" encoding="iso-8859-1"?>',nHandle,fArchvo)
       lSaveTxt('<?mso-application progid="Excel.Sheet"?>',nHandle,fArchvo)
       lSaveTxt('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"',nHandle,fArchvo)
       lSaveTxt(' xmlns:o="urn:schemas-microsoft-com:office:office"',nHandle,fArchvo)
       lSaveTxt(' xmlns:x="urn:schemas-microsoft-com:office:excel"',nHandle,fArchvo)
       lSaveTxt(' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"',nHandle,fArchvo)
       lSaveTxt(' xmlns:html="http://www.w3.org/TR/REC-html40">',nHandle,fArchvo)

       lSaveTxt('',nHandle,fArchvo)
       lSaveTxt(' <Styles>',nHandle,fArchvo)
       lSaveTxt('  <Style ss:ID="s21">',nHandle,fArchvo)
       lSaveTxt('   <Font x:Family="Swiss" ss:Bold="1"/>',nHandle,fArchvo)
       lSaveTxt('  </Style>',nHandle,fArchvo)
       lSaveTxt('  <Style ss:ID="s22">',nHandle,fArchvo)
       lSaveTxt('   <Font x:Family="Swiss" ss:Size="7" />',nHandle,fArchvo)
       lSaveTxt('  </Style>',nHandle,fArchvo)
       lSaveTxt(' </Styles>',nHandle,fArchvo)

       nNroCol := LEN(aTitPrn)
       lSaveTxt('',nHandle,fArchvo)
       lSaveTxt(' <Worksheet ss:Name="Hoja1">',nHandle,fArchvo)
       lSaveTxt('',nHandle,fArchvo)
       lSaveTxt('  <Table',nHandle,fArchvo)
       lSaveTxt('    ss:ExpandedColumnCount="'+;
		     ALLTRIM(STR(nNroCol,4))+'"',nHandle,fArchvo)
       lSaveTxt('    ss:ExpandedRowCount="1000"',nHandle,fArchvo)
       lSaveTxt('    x:FullColumns="1"',nHandle,fArchvo)
       lSaveTxt('    x:FullRows="1"',nHandle,fArchvo)
       lSaveTxt('    ss:DefaultColumnWidth="60">',nHandle,fArchvo)
*>>>>FIN CABECERA DEL ARCHIVO

*>>>>TAMA¥O DE LAS COLUMNAS
       lSaveTxt('',nHandle,fArchvo)
       FOR i := 1 TO LEN(aNroCol)
	   nLenTit := aNroCol[i]
	   IF nLenTit < 11
	      nLenTit := 10
	   ENDIF
	   nLenTit := nLenTit*6
	   lSaveTxt('    <Column ss:AutoFitWidth="0" ss:Width="'+;
				 ALLTRIM(STR(nLenTit,6))+'"/>',nHandle,fArchvo)
       ENDFOR
*>>>>FIN TAMA¥O DE LAS COLUMNAS

*>>>>ENCABEZADO DEL INFORME
       cNomEmp := aCabPrn[1]
       lSaveTxt('   <Row>',nHandle,fArchvo)
       lSaveTxt('    <Cell ss:StyleID="s21"><Data ss:Type="String">'+cNomEmp+'</Data></Cell>',nHandle,fArchvo)
       lSaveTxt('   </Row>',nHandle,fArchvo)
       lSaveTxt('',nHandle,fArchvo)

       cNomSis := aCabPrn[2]
       nNroPos := AT('ISO:',cNomSis)
       IF nNroPos # 0
	  cCodIso := ALLTRIM(SUBS(cNomSis,nNroPos,LEN(cNomSis)))
	  cNomSis := ALLTRIM(SUBS(cNomSis,1,nNroPos-1))
       ENDIF
       lSaveTxt('   <Row>',nHandle,fArchvo)
       lSaveTxt('    <Cell ss:StyleID="s21"><Data ss:Type="String">'+cNomSis+'</Data></Cell>',nHandle,fArchvo)
       lSaveTxt('   </Row>',nHandle,fArchvo)
       lSaveTxt('',nHandle,fArchvo)

       lSaveTxt('',nHandle,fArchvo)
       lSaveTxt('   <Row>',nHandle,fArchvo)
       lSaveTxt('    <Cell ss:StyleID="s21"><Data ss:Type="String">'+SPACE(01)+'</Data></Cell>',nHandle,fArchvo)
       lSaveTxt('   </Row>',nHandle,fArchvo)
       lSaveTxt('',nHandle,fArchvo)
     *ÀEspacio en Blanco

       cTitUno := aCabPrn[3]
       IF !EMPTY(cTitUno)
	  lSaveTxt('',nHandle,fArchvo)
	  cTitUno := aCabPrn[3]
	  lSaveTxt('   <Row>',nHandle,fArchvo)
	  lSaveTxt('    <Cell ss:StyleID="s21"><Data ss:Type="String">'+cTitUno+'</Data></Cell>',nHandle,fArchvo)
	  lSaveTxt('   </Row>',nHandle,fArchvo)
	  lSaveTxt('',nHandle,fArchvo)
       ENDIF

       cTitDos := aCabPrn[4]
       IF !EMPTY(cTitDos)
	  lSaveTxt('   <Row>',nHandle,fArchvo)
	  lSaveTxt('    <Cell ss:StyleID="s21"><Data ss:Type="String">'+cTitDos+'</Data></Cell>',nHandle,fArchvo)
	  lSaveTxt('   </Row>',nHandle,fArchvo)
	  lSaveTxt('',nHandle,fArchvo)
       ENDIF

       cTitTre := aCabPrn[5]
       IF !EMPTY(cTitTre)
	  lSaveTxt('   <Row>',nHandle,fArchvo)
	  lSaveTxt('    <Cell ss:StyleID="s21"><Data ss:Type="String">'+cTitTre+'</Data></Cell>',nHandle,fArchvo)
	  lSaveTxt('   </Row>',nHandle,fArchvo)
	  lSaveTxt('',nHandle,fArchvo)
       ENDIF
*>>>>FIN ENCABEZADO DEL INFORME

*>>>>FECHA DEL INFORME
       lSaveTxt('',nHandle,fArchvo)
       lSaveTxt('   <Row>',nHandle,fArchvo)
       lSaveTxt('    <Cell ss:StyleID="s21"><Data ss:Type="String">'+SPACE(01)+'</Data></Cell>',nHandle,fArchvo)
       lSaveTxt('   </Row>',nHandle,fArchvo)
       lSaveTxt('',nHandle,fArchvo)
     *ÀEspacio en Blanco

       cCampo := 'Generado:'+cDia(DOW(DATE()),9)+' '+;
		 cFecha(DATE(),10)+' '+;
		 'HORA:'+cHoraSys()+' '+;
		 cCodIso
       lSaveTxt('',nHandle,fArchvo)
       lSaveTxt('   <Row>',nHandle,fArchvo)
       lSaveTxt('    <Cell ss:StyleID="s22"><Data ss:Type="String">'+cCampo+'</Data></Cell>',nHandle,fArchvo)
       lSaveTxt('   </Row>',nHandle,fArchvo)
       lSaveTxt('',nHandle,fArchvo)
*>>>>FIN FECHA DEL INFORME

*>>>>ENCABEZADOS DE COLUMNA
       lSaveTxt('   <Row>',nHandle,fArchvo)
       FOR i := 1 TO LEN(aTitPrn)
	   lSaveTxt('    <Cell ss:StyleID="s21"><Data ss:Type="String">'+aTitPrn[i]+'</Data></Cell>',nHandle,fArchvo)
       ENDFOR
       lSaveTxt('   </Row>',nHandle,fArchvo)
       lSaveTxt('',nHandle,fArchvo)
       RETURN nHandle
*>>>>FIN ENCABEZADOS DE COLUMNA

/*************************************************************************
* TITULO..: CERRAR EL ARCHIVO XML DE EXCEL 2003                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2007 LUN A
       Colombia, Bucaramanga        INICIO: 06:30 PM   ABR 20/2007 LUN

OBJETIVOS:

1- Grabaci¢n del Campo Xml

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CloseXls(fArchvo,nHandle)

*>>>>DECLARACION DE VARIABLES
/*     fArchvo                              // Archivo a Crear
       nHandle                              // Manejador Archivo Binario */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CERRANDO ARCHIVOS
       lSaveTxt('  </Table>',nHandle,fArchvo)
       lSaveTxt(' </Worksheet>',nHandle,fArchvo)
       lSaveTxt('</Workbook>',nHandle,fArchvo)
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: ANALISIS DEL CAMPO NUMUERICO                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2007 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 PM   ABR 20/2007 LUN

OBJETIVOS:

1- Analiza si el campo es numerico

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lCampoNum(cCampo)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCampo                               // Campo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL lCamNum := .T.                 // .T. Campo numerico
*>>>>FINDECLARACION DE VARIABLES

*>>>>ANALISIS SI EL CAMPO ES NUMERICO
       FOR i := 1 TO LEN(cCampo)
	   IF !SUBS(cCampo,i,1) $ '1234567890'
	      lCamNum := .F.
	      EXIT
	   ENDIF
       ENDFOR
       RETURN lCamNum
*>>>>FIN ANALISIS SI EL CAMPO ES NUMERICO