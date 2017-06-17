/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : OTROS
SUBMODULO...: RESTAURANTE PERSONAL                     MODULO No. 606

**************************************************************************
* TITULO..: HABILITAR SERVICIO DE CAFETERIA PERSONAL                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Bucaramanga, Colombia	    INICIO: 10:30 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Permite Habilitar los servicios de Cafeteria para el Personal del
   Colegio

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_633(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n Uno
       LOCAL cIntUno := ''                  // Path de integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntDos := ''                  // Path de integraci¢n Dos
       LOCAL PathTre := ''                  // Path de integraci¢n Tres
       LOCAL cIntTre := ''                  // Path de integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cTipPer := ''                  // Tipo de Personal
       LOCAL lHayRes := .F.                 // .T. Servicio de Restaurante
       LOCAL dFecIni := CTOD('00/00/0000')  // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/0000')  // Fecha Final
       LOCAL cExtCam := ''                  // Extensi¢n del Nombre del Campo
       LOCAL cCampo  := ''                  // Campo

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
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
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>ANALISIS DE DECISION
       IF EMPTY(PathTre)
	  cError('NO EXISTE EL PATH DE INTEGRACION CON LA CAFETERIA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathTre+'\'+PathSis+'\'+;
			 FPerCaF,'PER',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathTre+'\'+cPatSis+'\'+;
			 FCaFAno+cAnoUsr+ExtFile,'CFA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTE PROFESORES GRABADOS')

       CASE CFA->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O DE LA CAFETERIA')

       CASE !CFA->lHayNovCfA
	    cError('NO SE PERMITEN APLICAR NOVEDADES PARA EL A¥O:'+cAnoUsr)

       CASE PER->(RECCOUNT()) == 0
	    cError('EL PERSONAL ACTUAL NO HAN SIDO GRABADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO',22,'°')
       aTamCol := {08,30,14,10,10}
       aTitulo := {'CODIGO','NOMBRE','RESTAURANTE','F.INICIAL','F.FINAL'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS BECADOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cCodigoTes := SPACE(07)
	    @ nNroFil,aNroCol[1] GET cCodigoTes PICT '9999999'
	    READ
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
**********LECTURA DEL CODIGO

**********BUSQUEDA O LOCALIZACION DEL CODIGO
	    cExtCam := ''
	    cTipPer := SUBS(cCodigoTes,1,1)
	    DO CASE
	    CASE cTipPer == '1'
		 cError('LOS ESTUDIANTES NO SE HABILITAN POR ESTA OPCION')
		 LOOP

	    CASE cTipPer == '2'

		 cExtCam := 'Pro'
		 IF !lLocCodigo('cCodigoPro','PRO',SUBS(cCodigoTes,2,6))
		    cError('EL CODIGO: '+cCodigoTes+' NO EXISTE')
		    LOOP
		 ENDIF
		 cNombreTes := RTRIM(PRO->cApelliPro)+' '+;
			       RTRIM(PRO->cNombrePro)

		 dFecIni := PRO->dResIniPro
		 dFecFin := PRO->dResFinPro
		 IF EMPTY(dFecIni)
		    dFecIni := DATE()
		    dFecFin := CTOD('11/30/'+cAnoUsr)
		 ENDIF

	    CASE VAL(cTipPer) > 2

		 cExtCam := 'Per'
		 IF !lLocCodigo('cCodigoPer','PER',cCodigoTes)
		    cError('EL CODIGO: '+cCodigoTes+' NO EXISTE')
		    LOOP
		 ENDIF
		 cNombreTes := RTRIM(PER->cApelliPer)+' '+;
			       RTRIM(PER->cNombrePer)

		 dFecIni := PER->dResIniPer
		 dFecFin := PER->dResFinPer
		 IF EMPTY(dFecIni)
		    dFecIni := DATE()
		    dFecFin := CTOD('11/30/'+cAnoUsr)
		 ENDIF

	    ENDCASE
	    cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(30),1,30))
	    @ nNroFil,aNroCol[1] SAY cCodigoTes
	    @ nNroFil,aNroCol[2] SAY cNombreTes
**********FIN BUSQUEDA O LOCALIZACION DEL CODIGO

**********HABILITACION DEL SERVICION DE RESTAURANTE
	    cCampo := cExtCam+'->cSerHab'+cExtCam
	    @ nNroFil,aNroCol[3] SAY IF(EMPTY(SUBS(&cCampo,1,1)),'NO','SI')

	    lHayRes := .F.
	    IF lPregunta('Si No',nNroFil,aNroCol[3]+3)
	       lHayRes := .T.
	    ENDIF
	    @ nNroFil,aNroCol[3] SAY IF(lHayRes,'SI','NO')

	    IF lHayRes
	       cSavLin := SAVESCREEN(22,00,22,79)
	       centrar('Digite las Fechas en el Formato: MM/DD/AAAA',22)
	       DO WHILE .T.
		  @ nNroFil,aNroCol[4] GET dFecIni PICT '@D';
				       VALID !EMPTY(dFecIni)
		  @ nNroFil,aNroCol[5] GET dFecFin PICT '@D';
				       VALID !EMPTY(dFecFin)
		  READ
		  IF dFecIni > dFecFin
		     cError('LA FECHA INICIAL DEBE SER MENOR A LA FECHA FINAL')
		     LOOP
		  ELSE
		     EXIT
		  ENDIF
	       ENDDO
	       RESTSCREEN(22,00,22,79,cSavLin)
	    ENDIF
**********FIN HABILITACION DEL SERVICION DE RESTAURANTE

**********ANALISIS DE DECISION
	    IF !lPregunta('DESEA GRABAR LA NOVEDAD? Si No')
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********GRABACION DE LA NOVEDAD
	    IF lRegLock(lShared,.F.)
	       REPL &cCampo WITH  STUFF(&cCampo,1,1,IF(lHayRes,'1',''))
	       IF cTipPer == '2'
		  REPL PRO->dResIniPro WITH dFecIni
		  REPL PRO->dResFinPro WITH dFecFin
	       ELSE
		  REPL PER->dResIniPer WITH dFecIni
		  REPL PER->dResFinPer WITH dFecFin
	       ENDIF
	    ELSE
		cError('NO SE GRABA EL CUPO')
	    ENDIF
	    DBCOMMIT()
	    IF lShared
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DEL CUPO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY cFecha(dFecIni)
		 @ nNroFil,aNroCol[4] SAY cFecha(dFecFin)
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS