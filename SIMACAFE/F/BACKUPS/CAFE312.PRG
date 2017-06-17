/*SIMA - SISTEMA DE CAFETERIA

MODULO      : INFORMES
SUBMODULO...: ETIQUETAS - POR ESTUDIANTE               MODULO No. 312

**************************************************************************
* TITULO..: IMPRESION DE ETIQUETAS POR ESTUDIANTE                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 24/2002 LUN A
       Colombia, Bucaramanga        INICIO: 11:30 AM   JUN 24/2002 LUN

OBJETIVOS:

1- Imprime las etiquetas por estudiante para anexar a los carnets

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_312(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt,nTipPer)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nTipPer                              // Tipo de Personal */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL       i := 0                   // Contador
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cConCaf := ''                  // Concepto de la Cafeteria
       LOCAL cConRut := ''                  // Concepto de la Ruta
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTco := ''               // Codigo del Concepto

       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePer,'PER',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCaf,'CAF',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FCaFAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTip+cAnoUsr+ExtFile,'TIP',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileBol,'BOL',;
			 PathSis+'\'+fNtxBol,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoUsr)

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoUsr)

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoUsr)

       CASE CAF->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL SISTEMA')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTE PROFESORES GRABADOS')

       CASE PER->(RECCOUNT()) == 0
	    cError('EL PERSONAL ACTUAL NO HAN SIDO GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ACTIVACION DE LA IMPRESORA
       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAF->cOpcPrnCaF,.F.)
       IF EMPTY(nOpcPrn)
*      IF !Printer_on(CAF->lPrnArcCaF)
	   CloseAll()
	   RETURN NIL
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO.'+;
				   'FECHA: '+cFecha(DATE()),22,'°')

       IF nTipPer == 1
	  aTamCol := {06,40,06,14}
	  aTitulo := {'CODIGO','NOMBRE','CURSO ','CONCEPTOS'}
       ELSE
	  aTamCol := {06,40,}
	  aTitulo := {'CODIGO','NOMBRE'}
       ENDIF

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS BECADOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    DO CASE
	    CASE nTipPer == 1
		 cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
					  cMaeAlu,@cMaeAct)
		 IF EMPTY(cCodigoTes) .OR. EMPTY(cMaeAct)
		    EXIT
		 ENDIF

	    CASE nTipPer == 2
		 cCodigoTes := SPACE(06)
		 @ nNroFil,aNroCol[1] GET cCodigoTes PICT '999999'
		 READ
		 IF EMPTY(cCodigoTes)
		    EXIT
		 ENDIF

	    CASE nTipPer == 3
		 cCodigoTes := SPACE(07)
		 @ nNroFil,aNroCol[1] GET cCodigoTes PICT '9999999'
		 READ
		 IF EMPTY(cCodigoTes)
		    EXIT
		 ENDIF

	    CASE nTipPer == 4
		 cCodigoTes := SPACE(07)
		 @ nNroFil,aNroCol[1] GET cCodigoTes PICT '@! X999999'
		 READ
		 IF EMPTY(cCodigoTes)
		    EXIT
		 ENDIF
		 lValCodBol(@cCodigoTes,2)

	    ENDCASE
**********FIN LECTURA DEL CODIGO

**********LOCALIZACION DE CODIGO
	   DO CASE
	   CASE nTipPer == 2
		IF !lLocCodigo('cCodigoPro','PRO',cCodigoTes)
		   cError('EL CODIGO: '+cCodigoTes+' NO EXISTE')
		   LOOP
		ENDIF

	   CASE nTipPer == 3
		IF !lLocCodigo('cCodigoPer','PER',cCodigoTes)
		   cError('EL CODIGO: '+cCodigoTes+' NO EXISTE')
		   LOOP
		ENDIF

	   CASE nTipPer == 4
		 IF !lSekCodigo(cCodigoTes,'BOL','DE LA BOLETA')
		    LOOP
		 ENDIF
	   ENDCASE
**********FIN LOCALIZACION DE CODIGO

**********IMPRESION DE LOS DETALLES
	    DO CASE
	    CASE nTipPer == 1
		 cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
			       RTRIM(&cMaeAct->cApelliEst)
		 cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(40),1,40))
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY &cMaeAct->cCodigoGru
		 @ nNroFil,aNroCol[4] SAY ALLTRIM(&cMaeAct->cConcepEst)

	    CASE nTipPer == 2
		 cNombreTes := RTRIM(PRO->cNombrePro)+' '+;
			       RTRIM(PRO->cApelliPro)
		 cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(40),1,40))
		 @ nNroFil,aNroCol[2] SAY cNombreTes

	    CASE nTipPer == 3
		 cNombreTes := RTRIM(PER->cNombrePer)+' '+;
			       RTRIM(PER->cApelliPer)
		 cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(40),1,40))
		 @ nNroFil,aNroCol[2] SAY cNombreTes

	    CASE nTipPer == 4
		 @ nNroFil,aNroCol[2] SAY 'BOLETA No. '+cCodigoTes

	    ENDCASE
**********FIN IMPRESION DE LOS DETALLES

**********VALIDACION DEL ACCESO A LA CAFETERIA
	    cConRut := ''
	    cConCaf := ''
	    IF nTipPer == 1
	       IF !EMPTY(&cMaeAct->cConcepEst)
		  FOR i := 1 TO LEN(ALLTRIM(&cMaeAct->cConcepEst))/2

		      cCodigoTco := SUBS(&cMaeAct->cConcepEst,i*2-1,2)
		      IF lLocCodigo('cCodigoCon','CON',cCodigoTco)

			 DO CASE
			 CASE CON->nTipoCon == 1  // Ruta
			      cConRut := ALLTRIM(CON->cNombreCon)

			 CASE CON->nTipoCon == 2  // Cafeteria
			      cConCaf := ALLTRIM(CON->cNombreCon)
			 ENDCASE

		      ENDIF
		  ENDFOR
	       ENDIF
	    ENDIF
**********FIN VALIDACION DEL ACCESO A LA CAFETERIA

**********IMPRESION DE LA ETIQUETA
*	    SET DEVICE TO PRINT
	    nPrinter_On(cNomUsr,@FilePrn,STR(nOpcPrn,1),.F.)
	    DO CASE
	    CASE nTipPer == 1
		 cConRut := ''
		 cConCaf := ''
		 Etiqueta('1'+cCodigoTes+'000000',cConCaf,cConRut)

	    CASE nTipPer == 2
		 cConRut := ''
		 cConCaf := ''
		 Etiqueta('2'+cCodigoTes+'000000',cConCaf,cConRut)

	    CASE nTipPer == 3
		 cConRut := ''
		 cConCaf := ''
		 Etiqueta(cCodigoTes+'000000',cConCaf,cConRut)

	    CASE nTipPer == 4
		 cConCaf := 'BOLETA'
		 cConRut := ''
		 IF lLocCodigo('cCodigoTip','TIP',SUBS(cCodigoTes,1,1))
		    cConCaf := ALLTRIM(TIP->cNombreTip)
		 ENDIF
		 Etiqueta(cCodigoTes+'000000',cConCaf,cConRut)
	    ENDCASE
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DE LA ETIQUETA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO.'+;
					     'FECHA: '+cFecha(DATE()),22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 IF nTipPer == 1
		      @ nNroFil,aNroCol[1] SAY cCodigoTes
		      @ nNroFil,aNroCol[2] SAY cNombreTes
		      @ nNroFil,aNroCol[3] SAY &cMaeAct->cCodigoGru
		      @ nNroFil,aNroCol[4] SAY ALLTRIM(&cMaeAct->cConcepEst)
		 ELSE
		      @ nNroFil,aNroCol[1] SAY cCodigoTes
		      @ nNroFil,aNroCol[2] SAY cNombreTes
		 ENDIF
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
	    VerPrn(nOpcPrn,FilePrn)
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS


/*************************************************************************
* TITULO..: IMPREION DE LA ETIQUETAS                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 24/2002 LUN A
       Colombia, Bucaramanga        INICIO: 11:40 AM   JUN 24/2002 LUN

OBJETIVOS:

1- Imprime la etiqueta de cafeteria

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Etiqueta(cCodigo,cConCaf,cConRut,cDescri)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo del Acceso
       cCodCon                              // C¢digo del Concepto
       cDescri                              // Descripci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DESCRIPCION DE VARIABLES
       LOCAL cTxtEti := ''                  // Texto para la Etiqueta
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>ANALISIS DEL TEXTO DE LA ETIQUETA
       DO CASE
       CASE EMPTY(cConCaf) .AND. EMPTY(cConRut)
	    cTxtEti := SPACE(01)
       CASE !EMPTY(cConCaf) .AND. !EMPTY(cConRut)
	    cTxtEti := cConCaf+','+cConRut
       CASE !EMPTY(cConCaf)
	    cTxtEti := cConCaf
       CASE !EMPTY(cConRut)
	    cTxtEti := cConRut
       OTHERWISE
	    cTxtEti := 'ERROR'
       ENDCASE
*>>>>FIN ANALISIS DEL TEXTO DE LA ETIQUETA

*>>>>IMPRESION DE LA ETIQUETA
       IF EMPTY(cTxtEti)
	  @ PROW(),PCOL() SAY '{F,1,A,R,M,381,381,"1aa"|'+;
			       'B,1,13,F,90,39,7,2,150,1,L,0|'+;
			       'R,1,"'+cCodigo+'"|'+;
			       'C,111,39,0,2,1,1,B,L,0,0,""|}'
       ELSE
	  @ PROW(),PCOL() SAY '{F,1,A,R,M,381,381,"1aa"|'+;
			       'B,1,13,F,90,39,7,2,150,1,L,0|'+;
			       'R,1,"'+cCodigo+'"|'+;
			       'C,111,39,0,2,1,1,B,L,0,0,"'+cTxtEti+'"|}'
       ENDIF
       @ PROW(),PCOL() SAY '{B,1,N,1|E,0,0,1,1,0,1|}'

       RETURN NIL
*>>>>FIN IMPRESION DE LA ETIQUETA
