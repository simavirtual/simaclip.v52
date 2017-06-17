/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : OTROS
SUBMODULO...: CONCEPTOS ALUMNOS                        MODULO No. 601

**************************************************************************
* TITULO..: CONCEPTOS INDIVIDUALES DE LOS ESTUDIANTES                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 05/2001 VIE A
       Bucaramanga, Colombia	    INICIO: 03:00 PM   OCT 05/2001 VIE

OBJETIVOS:

1- Permite Grabar los conceptos individuales de los estudiantes de un
   solo tipo de concepto.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_621(aParam1,aParam2,aParam3,;
		   nTipCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       nTipCon                              // Tipo de Concepto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
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
       LOCAL lGrabar := .F.                 // .T. Graba el Registro
       LOCAL cCodRut := ''                  // C¢digos de las Rutas
       LOCAL cConRut := ''                  // Conceptos de Rutas
       LOCAL nNroPos := 0                   // N£mero de la Posici¢n

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
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

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE LEN(ALLTRIM(CAA->cConPenCaA))/2 >= 7
	    cError('YA ESTAN APLICADOS TODOS LOS (7) CONCEPTOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DEL ARCHIVO
       nTipCon := IF(EMPTY(nTipCon),9,nTipCon)
       SELECT CON
       SET FILTER TO CON->nTipoCon == nTipCon
       CON->(DBGOTOP())
       IF CON->(EOF())
	  SET FILTER TO
	  CloseAll()
	  cError('NO EXISTEN CONCEPTOS')
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS'+;
				   ' ESTUDIANTES A GRABAR',22,'°')
       aTamCol := {06,06,40,14}
       aTitulo := {'CODIGO','CURSO ','NOMBRE','CONCEPTOS'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS BECADOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes) .OR. EMPTY(cMaeAct)
	       EXIT
	    ENDIF
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DE LOS DETALLES DEL ESTUDIANTE
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(40),1,40))
	    @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
	    @ nNroFil,aNroCol[4] SAY ALLTRIM(CAA->cConPenCaA)+;
				     ALLTRIM(&cMaeAct->cConcepEst)
**********FIN IMPRESION DE LOS DETALLES DEL ESTUDIANTE

**********CONCEPTOS DE RUTA ASIGNADOS
	    cConRut := ''
	    FOR i := 1 TO LEN(ALLTRIM(&cMaeAct->cConcepEst))/2

		cCodigoTco := SUBS(&cMaeAct->cConcepEst,i*2-1,2)

*===============LOCALIZACION DEL CODIGO
		  SELECT CON
		  CON->(DBGOTOP())
		  LOCATE FOR CON->cCodigoCon == cCodigoTco .AND.;
			     CON->nTipoCon   == nTipCon

		  IF .NOT. FOUND()
		     LOOP
		  ENDIF
		  cConRut += cCodigoTco
*===============FIN LOCALIZACION DEL CODIGO

	    ENDFOR
**********FIN CONCEPTOS DE RUTA ASIGNADOS

**********LECTURA DE LOS CONCEPTOS
	    cCodRut := cLeeConcep(IF(nNroFil==20,21,nNroFil+1),30,;
				     nNroFil,aNroCol[4]+;
				     LEN(ALLTRIM(CAA->cConPenCaA))+;
				     LEN(ALLTRIM(&cMaeAct->cConcepEst))+;
				     LEN(ALLTRIM(cConRut)),;
				     ALLTRIM(CAA->cConPenCaA)+;
				     ALLTRIM(&cMaeAct->cConcepEst)+;
				     ALLTRIM(cConRut))
**********FIN LECTURA DE LOS CONCEPTOS

**********ANALISIS DE LA GRABACION DEL REGISTRO
	    IF ALLTRIM(cCodRut) == ALLTRIM(cConRut)
	       lGrabar := .F.
	    ELSE
	       lGrabar := .T.
	    ENDIF
**********FIN ANALISIS DE LA GRABACION DEL REGISTRO

**********GRABACION DEL REGISTRO
	    IF lGrabar

*--------------ANALISIS DE LA GRABACION
		 IF lPregunta('DESEA '+;
			      IF(EMPTY(cCodRut),'BORRAR','GRABAR')+' '+;
			      'LOS CONCEPTOS INDIVIDUALES '+;
			      IF(EMPTY(cCodRut),cConRut,cCodRut)+'? No Si')

*...................GRABACION
		      SELECT &cMaeAct
		      IF lRegLock(lShared,.F.)

			 nNroPos := AT(cConRut,&cMaeAct->cConcepEst)

			 IF EMPTY(cConRut)
			    REPL &cMaeAct->cConcepEst WITH ALLTRIM(&cMaeAct->cConcepEst)+cCodRut
			 ELSE
			    REPL &cMaeAct->cConcepEst WITH;
				 STUFF(&cMaeAct->cConcepEst,nNroPos,;
				       LEN(cConRut),cCodRut)
			 ENDIF
		      ELSE
			  cError('NO SE GRABA EL REGISTRO')
		      ENDIF

		      DBCOMMIT()
		      IF lShared
			 DBUNLOCK()
		      ENDIF
		      @ nNroFil,aNroCol[4] SAY ALLTRIM(CAA->cConPenCaA)+;
					       &cMaeAct->cConcepEst
*...................FIN GRABACION

		 ELSE
		    cError('NO SE MODIFICO NINGUN CONCEPTO INDIVIDUAL')
		 ENDIF
*--------------FIN ANALISIS DE LA GRABACION

	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO '+;
			    'DE LOS ESTUDIANTES A GRABAR',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 @ nNroFil,aNroCol[4] SAY ALLTRIM(CAA->cConPenCaA)+;
					  ALLTRIM(&cMaeAct->cConcepEst)
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS