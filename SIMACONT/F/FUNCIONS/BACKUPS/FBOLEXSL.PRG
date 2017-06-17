/*                    SIMA - CONTABILIDAD ACADEMICA
       BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE BOLETINES POR INTERNET

OBJETIVOS:

- Funciones para generar los archivos xsl para los diferentes boletines
  del sima.


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: ARCHIVO XSL PARA EL BOLETIN No. 07                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2007 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   SEP 28/2007 VIE

OBJETIVOS:

1- Crea el archivo XSL para el boletin No. 07

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoleXsl07(aPrnXsl)

*>>>>DESCRIPCION DE PARAMETROS
/*     aPrnXsl			           // Xsl del informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathWeb := ''                  // Path del sistio
       LOCAL FileImg := ''                  // Archivo de imagen
       LOCAL FileXsl := ''                  // Archivo Xsl

       LOCAL       k := 0                   // Contador
       LOCAL cTxtPrn := ''                  // Texto a imprimir
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION
       PathWeb := '..\simaweb'
       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'FileXsl'})
       IF k == 0
	  FileXsl := PathWeb+'\img\boleti07.www'
       ELSE
	  FileXsl := aPrnXsl[k,2]
       ENDIF

       k := ASCAN(aPrnXsl,{|aXls|aXls[1] == 'fondoimg'})
       IF k == 0
	  PathWeb := '..\..\..\..\..\simaweb\img\'
	  FileImg := 'boletin.jpg'
       ELSE
	  FileImg := aPrnXsl[k,2]
       ENDIF
*>>>>FIN INICIALIZACION

*>>>>VALIDACION DEL ARCHIVO
       IF FILE(FileXsl)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       SET DEVICE TO PRINT
       SET PRINTER TO &FileXsl
*>>>>FIN CREACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
Prn("<xsl:transform",0)
Prn("  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'")
Prn("  version='1.0'")
Prn(">")

Prn("<xsl:template match='boletin'>",2)

Prn("<html>",2)

Prn("  <title>Sima.Boletin</title>",2)
Prn("  <style type='text/css'>")

Prn('    <xsl:if test="'+"@urlbol != ''"+'">',2)
Prn("       body {font-family: Verdana, Times, Serif;")
Prn("	          background-image: url(<xsl:value-of select='@urlbol'/>"+FileImg+");}")
Prn("    </xsl:if>")

Prn('    <xsl:if test="'+"@urlbol = ''"+'">',2)
Prn("      body {font-family: Verdana, Times, Serif;")
Prn("	         background-image: url("+PathWeb+"boletin.jpg);}")
Prn("    </xsl:if>")

Prn("  </style>")

Prn("<body>",2)

Prn('<xsl:if test="'+"@foto != ''"+'">',2)
Prn("<img align='center'")
Prn("     width='168'")
Prn("     height='248'>")
Prn("  <xsl:attribute name='src'>")
Prn("    <xsl:value-of select='@urlfot'/>")
Prn("    <xsl:value-of select='@foto'/>")
Prn("    <xsl:value-of select='@extfot'/>")
Prn("  </xsl:attribute>")
Prn("</img>")
Prn("</xsl:if>")

Prn("<br/>",2)

Prn('<xsl:if test="'+"@logo != ''"+'">',2)
Prn("<img align='top'")
Prn("     width='780'")
Prn("     height='130'>")
Prn("  <xsl:attribute name='src'>")
Prn("    <xsl:value-of select='@urlbol'/>")
Prn("    <xsl:value-of select='@logo'/>")
Prn("  </xsl:attribute>")
Prn("</img>")
Prn("</xsl:if>")

Prn("<table width='900'",2)
Prn("       border='2'")
Prn("       cellspacing='2'")
Prn("       cellpadding='1'>")

Prn("  <tr>",2)

Prn("    <td width='698'>",2)

Prn("      <strong>NOMBRE:</strong>",2)
Prn("      <xsl:value-of select='@nombre'/>",2)

Prn("      <strong> PERIODO:</strong>")
Prn("      <xsl:value-of select='@periodo'/><br/>")

Prn("      <strong>CODIGO:</strong>",2)
Prn("      <xsl:value-of select='@codigo'/>",2)

Prn("      <strong> GRUPO:</strong>",2)
Prn("      <xsl:value-of select='@grupo'/>-<xsl:value-of select='@lista'/>",2)

Prn("      <strong> ANO:</strong>",2)
Prn("      <xsl:value-of select='@year'/>")

Prn("      <strong> JORNADA:</strong>",2)
Prn("      <xsl:value-of select='@jornada'/><br/><br/>")

Prn("      <table width='900'",2)
Prn("	          border='1'>")
Prn("	     <tr>")
Prn("	       <td width='20'")
Prn("	           valign='top'>")
Prn("	         <strong>")
Prn("	         <font size='2'")
Prn("		       color='#000066'")
Prn("		       face='Arial, Helvetica, sans-serif'>")
Prn("	           IH")
Prn("	         </font>")
Prn("	         </strong>")
Prn("	       </td>")

Prn("	       <td width='860'",2)
Prn("	           valign='top'>")
Prn("	         <strong>")
Prn("	         <font size='2'")
Prn("		       color='#000066'")
Prn("		       face='Arial, Helvetica, sans-serif'>")
Prn("	           <xsl:value-of select='@titulo'/>")
Prn("		 </font>")
Prn("		 </strong>")
Prn("	       </td>")

Prn("	       <xsl:for-each select='materia[1]/juicio'>",2)
Prn("	         <td width='20'")
Prn("		     valign='top'>")
Prn("		   <strong>")
Prn("		   <font size='2'")
Prn("			 color='#000066'")
Prn("			 face='Arial, Helvetica, sans-serif'>")
Prn("		     <xsl:value-of select='@p'/>")
Prn("		   </font>")
Prn("		   </strong>")
Prn("		 </td>")
Prn("	       </xsl:for-each>")

Prn("	       <td width='20' valign='top'>",2)
Prn("		 <strong>")
Prn("		 <font size='2'")
Prn("		       color='#000066'")
Prn("		       face='Arial, Helvetica, sans-serif'>")
Prn("		   AUS")
Prn("		 </font>")
Prn("		 </strong>")
Prn("	       </td>")
Prn("	     </tr>")
Prn("	   </table>")

Prn("	   <xsl:for-each select='materia'>",2)
Prn("	     <table width='900'")
Prn("		    border='2'")
Prn("		    cellspacing='1'")
Prn("		    cellpadding='1'>")
Prn("	     <tr>")

Prn("	     <xsl:for-each select='ih'>",2)
Prn("	       <td width='20'")
Prn("		   valign='top'>")
Prn("		 <strong>")
Prn("		 <font size='3'")
Prn("		       color='#000066'")
Prn("		       face='Arial, Helvetica, sans-serif'>")
Prn("		   <xsl:value-of select='.'/>")
Prn("		 </font>")
Prn("		 </strong>")
Prn("	       </td>")
Prn("	     </xsl:for-each>")

Prn("	      <td width='860'>",2)

Prn("		<strong>")
Prn("		<font size='3'")
Prn("		      color='#000066'")
Prn("		      face='Arial, Helvetica, sans-serif'>")
Prn("		  <xsl:value-of select='text()'/>")
Prn("		</font>")
Prn("		</strong>")

Prn("		<xsl:for-each select='clase'><br/>",2)

Prn("		  <strong>",2)
Prn("		  <font size='2'")
Prn("			color='#000066'")
Prn("			face='Arial, Helvetica, sans-serif'>")
Prn("		    <xsl:value-of select='text()'/>")
Prn("		  </font>")
Prn("		  </strong>")

Prn("		  <xsl:for-each select='ind'><br/>",2)
Prn("		    <font size='2'")
Prn("			  color='#000066'")
Prn("			  face='Arial, Helvetica, sans-serif'>")
Prn("		      <xsl:value-of select='.'/>")
Prn("		    </font><br/>")
Prn("		  </xsl:for-each>")

Prn("		</xsl:for-each>",2)

Prn("	      </td>",2)

Prn("	 <xsl:for-each select='juicio'>",2)
Prn("	   <td width='22'")
Prn("	       valign='top'>")
Prn("	     <xsl:value-of select='.'/>")
Prn("	   </td>")
Prn("	 </xsl:for-each>")

Prn("	 <xsl:for-each select='aus'>",2)
Prn("	   <td width='20' valign='top'>")
Prn("	     <strong>")
Prn("	     <font size='3'")
Prn("		   color='#000066'")
Prn("		   face='Arial, Helvetica, sans-serif'>")
Prn("	       <xsl:value-of select='.'/>")
Prn("	     </font>")
Prn("	     </strong>")
Prn("	   </td>")
Prn("	 </xsl:for-each>")

Prn("	</tr>",2)
Prn("	</table>")
Prn("   </xsl:for-each>")

Prn("  </td>",2)
Prn("  </tr>")
Prn("</table>")

Prn("</body>",2)
Prn("</html>")
Prn("</xsl:template>")
Prn("</xsl:transform>")

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO

/*************************************************************************
* TITULO ..: INDEX PARA LOS BOLETINES EN HTML                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/2007 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   SEP 28/2007 VIE

OBJETIVOS:

1- Crea el archivo index.html para los boletines.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoletinHtm(lShared,nModCry,cNomEmp,cAnoUsr,cPatSis,cMaeAlu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de protecci¢n
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del Sistema
       cPatSis                              // Path del Sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL PathAct := ''                  // Path Actual
       LOCAL FileHtm := ''                  // Archivo Html
       LOCAL nHanHtm := 0                   // Manejador Archivo Binario
       LOCAL cLinkWw := ''                  // Link del Grupo
       LOCAL cLinkB1 := ''                  // Link del Boletin P1
       LOCAL cLinkB2 := ''                  // Link del Boletin P2
       LOCAL cLinkB3 := ''                  // Link del Boletin P3
       LOCAL cLinkB4 := ''                  // Link del Boletin P4
       LOCAL cLinkB5 := ''                  // Link del Boletin P5
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION RECURSOS DEL SITIO
       BoleXsl07()
*>>>>FIN CREACION RECURSOS DEL SITIO

*>>>>VERIFICACION O CREACION DEL DIRECTORIO
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+'\sitios\boletin') == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\sitios\boletin') == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\sitios\boletin') == -3
	    DIRMAKE(cPatSis+'\sitios\boletin')
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO

*>>>>VERIFICACION O CREACION DEL DIRECTORIO
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+'\sitios\boletin\boleestu') == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\sitios\boletin\boleestu') == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\sitios\boletin\boleestu') == -3
	    DIRMAKE(cPatSis+'\sitios\boletin\boleestu')
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO

*>>>>VALIDACION DEL ARCHIVO
       FileHtm := cPatSis+'\sitios\boletin\index.html'
       IF FILE(FileHtm)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       IF FCREATE(FileHtm,0) == -1
	   cError(FileHtm,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHanHtm := FOPEN(FileHtm,2)) = -1 .AND. lFHayErr(FileHtm)
	  cError(FileHtm,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>ENCABEZADO DE LA PAGINA
       lSaveTxt('<html>',nHanHtm,FileHtm)
       lSaveTxt('<head>',nHanHtm,FileHtm)
       lSaveTxt('<TITLE>SIMA. BOLETINES. A¥O:'+cAnoUsr+'</TITLE>',nHanHtm,FileHtm)
       lSaveTxt('</head>',nHanHtm,FileHtm)
       lSaveTxt('<body background="..\..\..\..\simaweb\img\boletin.jpg">',nHanHtm,FileHtm)
*>>>>FIN ENCABEZADO DE LA PAGINA

*>>>>CUERPO DE LA PAGINA
       lSaveTxt('<div align="center">',nHanHtm,FileHtm)
       lSaveTxt('<h1>'+cNomEmp+'</h1>',nHanHtm,FileHtm)
       lSaveTxt('<h2>BOLETINES DEL A¥O:'+cAnoUsr+'</h2>',nHanHtm,FileHtm)
       lSaveTxt('</div>',nHanHtm,FileHtm)

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf(cMaeAct)

***********AREAS DE TRABAJO
	     aUseDbf := {}
	     AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			       lShared,nModCry})

	     AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			       cPatSis+'\'+cMaeAct+'\'+;
			       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,;
			       lShared,nModCry})
***********FIN AREAS DE TRABAJO

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbfs(aUseDbf)
		cError('ABRIENDO ARCHIVOS')
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTEN GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE

	     IF lHayErr
		LOOP
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********RECORRIDO POR CURSOS
	     SELECT GRU
	     GRU->(DBGOTOP())
	     DO WHILE .NOT. GRU->(EOF())

*===============CREACION DEL LINK DEL GRUPO
		  cLinkWw := 'bole'+GRU->cCodigoGru+'.htm'

		  lSaveTxt('<p><a href="'+cLinkWw+'">'+;
			   'GRUPO '+GRU->cCodigoGru+;
			   '</a></p>',nHanHtm,FileHtm)
*===============FIN CREACION DEL LINK DEL GRUPO

*==============INICIALIZACION DEL PATH DE NOTAS
		 FileNot := cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			    'NT'+GRU->cCodigoGru+cAnoSis+ExtFile
*==============FIN INICIALIZACION DEL PATH DE NOTAS

*==============SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,FileNot,'NOT',NIL,lShared)
		    cError('ABRIENDO EL ARCHIVO DE NOTAS')
		    GRU->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN SELECION DE LAS AREAS DE TRABAJO

*==============PAGINA. GRUPOS BOLETINES
		 SET DEVICE TO PRINT
		 SET PRINTER TO &(cPatSis+'\sitios\boletin\'+cLinkWw)

Prn('<html>')
Prn('<head>')
Prn('<TITLE>SIMA. BOLETINES A¥O:'+cAnoUsr+'</TITLE>')
Prn('</head>')
Prn('<body background="..\..\..\..\simaweb\img\boletin.jpg">')

Prn('<div align="center">')
Prn('<h1>'+cNomEmp+'</h1>')
Prn('<h2>GRUPO:'+GRU->cCodigoGru+'</h2>')
Prn('</div>')

Prn("<table width='700'",2)
Prn("       border='2'")
Prn("       cellspacing='2'")
Prn("       cellpadding='1'>")

Prn("  <tr>",2)
Prn("     <td><strong>CODIGO</strong></td>")
Prn("     <td><strong>NOMBRE:</strong></td>")
Prn("     <td><strong>P1</strong></td>")
Prn("     <td><strong>P2</strong></td>")
Prn("     <td><strong>P3</strong></td>")
Prn("     <td><strong>P4</strong></td>")
Prn("  </tr>")

*==============FIN PAGINA. GRUPOS BOLETINES

*==============RECORRIDO POR NOTAS
		 SELECT NOT
		 NOT->(DBGOTOP())
		 DO WHILE .NOT. NOT->(EOF())

*-------------------ANALISIS RETIRO DEL GRUPO
		      IF NOT->lRetGruNot
			 NOT->(DBSKIP())
		      ENDIF
*-------------------FIN ANALISIS RETIRO DEL GRUPO

*-------------------BUSQUEDA DEL ESTUDIANTE
		      IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
			 cNombreTes := 'Estudiante No Existe'
		      ENDIF
		      cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				    RTRIM(&cMaeAct->cNombreEst)
		      cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
*-------------------FIN BUSQUEDA DEL ESTUDIANTE

*-------------------LINK DEL ESTUDIANTE
		      cLinkB1 :=  'boleestu\'+'P1'+NOT->cCodigoEst+'.xml'
		      cLinkB2 :=  'boleestu\'+'P2'+NOT->cCodigoEst+'.xml'
		      cLinkB3 :=  'boleestu\'+'P3'+NOT->cCodigoEst+'.xml'
		      cLinkB4 :=  'boleestu\'+'P4'+NOT->cCodigoEst+'.xml'
		      cLinkB5 :=  'boleestu\'+'P5'+NOT->cCodigoEst+'.xml'

Prn("  <tr>",2)
Prn("      <td><strong>"+NOT->cCodigoEst+"</strong></td>")
Prn("      <td><strong>"+cNombreTes+"</strong></td>")
Prn('      <td><p><a href="'+cLinkB1+'">'+'1</a></p></td>')
Prn('      <td><p><a href="'+cLinkB2+'">'+'2</a></p></td>')
Prn('      <td><p><a href="'+cLinkB3+'">'+'3</a></p></td>')
Prn('      <td><p><a href="'+cLinkB4+'">'+'4</a></p></td>')
Prn("	 </td>",2)
Prn(" </tr>",2)


*-------------------FIN LINK DEL ESTUDIANTE

		    NOT->(DBSKIP())

		 ENDDO
Prn("	</table>")
Prn('</body>')
Prn('</html>')
		 SET DEVICE TO SCREEN
*==============FIN RECORRIDO POR NOTAS

	       GRU->(DBSKIP())

	     ENDDO
	     CloseDbf('GRU')
***********FIN RECORRIDO POR CURSOS


       ENDFOR
*>>>>FIN CUERPO DE LA PAGINA

*>>>>CERRANDO ARCHIVOS
       lSaveTxt('</body>',nHanHtm,FileHtm)
       lSaveTxt('</html>',nHanHtm,FileHtm)

       IF !FCLOSE(nHanHtm) .AND. lFHayErr(FileHtm)
	  cError('ERROR CERRANDO EL ARCHIVO '+FileHtm)
       ENDIF
       CloseAll()
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS