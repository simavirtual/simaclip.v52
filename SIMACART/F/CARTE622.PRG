/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : OTROS
SUBMODULO...: ASIGNAR RUTAS                            MODULO No. 602

**************************************************************************
* TITULO..: ASIGNACION DE LAS RUTAS                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2001 LUN A
       Bucaramanga, Colombia	    INICIO: 10:20 AM   OCT 08/2001 LUN

OBJETIVOS:

1- Permite Grabar los c¢digos de las Rutas de los Estudiantes.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_622(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
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
       LOCAL lGrabar := ''                  // .T. Graba el Registro
       LOCAL cConRut := ''                  // Conceptos de Rutas

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTru := ''               // Conceptos del Estudiante
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
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileRut,'RUT',NIL,lShared,nModCry})
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

       CASE RUT->(RECCOUNT()) == 0
	    cError('NO EXISTEN RUTAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   'ESTUDIANTES A GRABAR',22,'°')
       aTamCol := {06,06,40,14}
       aTitulo := {'CODIGO','CURSO ','NOMBRE','RUTAS'}
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
	    @ nNroFil,aNroCol[4] SAY ALLTRIM(&cMaeAct->cConcepEst)+;
				     ALLTRIM(&cMaeAct->cCodigoRut)
**********FIN IMPRESION DE LOS DETALLES DEL ESTUDIANTE

**********VALIDACION DE LOS CONCEPTOS DE RUTA
	    cConRut := ''
	    FOR i := 1 TO LEN(ALLTRIM(&cMaeAct->cConcepEst))/2
		cCodigoTco := SUBS(&cMaeAct->cConcepEst,i*2-1,2)
		IF lLocCodigo('cCodigoCon','CON',cCodigoTco) .AND.;
		   CON->nTipoCon == 1
		   cConRut += cCodigoTco
		ENDIF
	    NEXT
	    IF EMPTY(cConRut)
	       cError('EL ESTUDIANTE NO TIENE CONCEPTOS DE RUTAS APLICADOS')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LOS CONCEPTOS DE RUTA

**********LECTURA DE LOS CONCEPTOS
	    cCodigoTru := cLeeRutas(IF(nNroFil==20,21,nNroFil+1),30,;
				    nNroFil,aNroCol[4]+;
				    LEN(ALLTRIM(&cMaeAct->cConcepEst))+;
				    LEN(ALLTRIM(&cMaeAct->cCodigoRut)),;
				    ALLTRIM(&cMaeAct->cCodigoRut),cConRut,;
				    CAA->nRutEstCaA)

	    IF EMPTY(cCodigoTru)
	       @ nNroFil,aNroCol[4]+LEN(ALLTRIM(&cMaeAct->cConcepEst)) CLEAR TO;
		 nNroFil,aNroCol[4]+LEN(ALLTRIM(CAA->cConPenCaA))+;
				    LEN(ALLTRIM(&cMaeAct->cCodigoRut))-1
	     *ÀBorra los conceptos individuales de la pantalla

	    ELSE
	       cCodigoTru := ALLTRIM(&cMaeAct->cCodigoRut)+cCodigoTru
	    ENDIF
**********FIN LECTURA DE LOS CONCEPTOS

**********ANALISIS DE LA GRABACION DEL REGISTRO
	    IF ALLTRIM(cCodigoTru) == ALLTRIM(&cMaeAct->cCodigoRut)
	       lGrabar := .F.
	    ELSE
	       lGrabar := .T.
	    ENDIF
**********FIN ANALISIS DE LA GRABACION DEL REGISTRO

**********GRABACION DEL REGISTRO
	    IF lGrabar

*--------------ANALISIS DE LA GRABACION
		 IF lPregunta('DESEA '+;
			      IF(EMPTY(cCodigoTru),'BORRAR','GRABAR')+' '+;
			      'LAS RUTAS '+;
			      cCodigoTru+'? No Si')

*...................GRABACION
		      SELECT &cMaeAct
		      IF lRegLock(lSiRed,.F.)
			 REPL &cMaeAct->cCodigoRut WITH cCodigoTru
		      ELSE
			  cError('NO SE GRABA EL REGISTRO')
		      ENDIF

		      DBCOMMIT()
		      IF lShared
			 DBUNLOCK()
		      ENDIF
		      @ nNroFil,aNroCol[4] SAY ALLTRIM(&cMaeAct->cConcepEst)+;
					       ALLTRIM(&cMaeAct->cCodigoRut)
*...................FIN GRABACION

		 ELSE
		    @ nNroFil,aNroCol[4]+LEN(ALLTRIM(&cMaeAct->cConcepEst));
		    CLEAR TO;
		    nNroFil,aNroCol[4]+LEN(ALLTRIM(&cMaeAct->cConcepEst))+;
				       LEN(ALLTRIM(cCodigoTru))-1
		  *ÀBorra los conceptos individuales de la pantalla
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
		 @ nNroFil,aNroCol[4] SAY ALLTRIM(&cMaeAct->cConcepEst)+;
					  ALLTRIM(&cMaeAct->cCodigoRut)
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS