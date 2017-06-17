/*SIMA - SISTEMA DE CAFETERIA

MODULO      : INGRESO
SUBMODULO...: CAFETERIA              MODULO No. 101

**************************************************************************
* TITULO..: CONTROL DE INGRESO A LA CAFETERIA                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 20/2002 LUN

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Controla el ingreso de los estudiantes y Personal Administrativo
   del Colegio.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

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
       cJorTxt                              // Jornada escogida */
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
       LOCAL lHayCaf := .F.                 // .T. Tiene Servicio de Cafeteria
       LOCAL cMesSer := ''                  // Mes del Servicio de Cafeteria
       LOCAL cDiaSer := ''                  // Dia del Servicio de la Cafeteria
       LOCAL nNroSer := 0                   // N£mero de Servicios de la Cafeteria
       LOCAL cExtCam := ''                  // Extensi¢n del Nombre del Campo
       LOCAL cCampo  := ''                  // Campo
       LOCAL nTipPer := ''                  // Tipo de Personal
       LOCAL cNroDia := ''                  // N£mero del Dia
       LOCAL cNalias := ''                  // Nombre del Alias
       LOCAL nTotDia := ''                  // Total Ingresos del Dia

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTco := ''               // Codigo del Concepto
       LOCAL cCodigoTtp := ''               // C¢digo tipo de personal
       LOCAL cDocNitTpe := ''               // Documento del Personal

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

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCaf,'CAF',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePer,'PER',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FCaFAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FilePrs+cAnoUsr+ExtFile,'PRS',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTip+cAnoUsr+ExtFile,'TIP',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileBol,'BOL',;
			 PathSis+'\'+fNtxBol,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileVbo+cAnoSis+ExtFile,'VBO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
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

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE VAL(SCO->cTipCodSco) # 0 .AND. SCO->nCodEstSco == 0
	    cError('NO HA DEFINIDO LA POSICION DEL CODIGO')

       CASE VAL(SCO->cTipCodSco) # 0 .AND. SCO->nLenCodSco == 0
	    cError('NO HA DEFINIDO LA LONGITUDO DEL CODIGO')

       CASE VAL(SCO->cTipCodSco) # 0 .AND. SCO->nCodTipSco == 0
	    cError('NO HA DEFINIDO LA POSICION DEL TIPO DE PERSONAL')

       CASE VAL(SCO->cTipCodSco) # 0 .AND. SCO->nLenTipSco == 0
	    cError('NO HA DEFINIDO LA LONGITUD DEL TIPO DE PERSONAL')

       CASE CAF->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL SISTEMA')

       CASE !CAF->lHayCafCaF
	    cError('EL SERVICIO DE LA CAFETERIA ESTA CERRADO')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

       CASE SUBS(ANO->cMesSerCfA,MONTH(DATE()),1) # '1'
	    cError('NO ESTA HABILITADO EL SERVICIO DE LA CAFETERIA PARA '+;
		   cMes(MONTH(DATE())))

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE PER->(RECCOUNT()) == 0
	    cError('EL PERSONAL ACTUAL NO HAN SIDO GRABADO')

       CASE VAL(cAnoUsr) # YEAR(DATE())
	    cError('NO SE PERMITE EL INGRESO. '+;
		   'NO COINCIDE EL A¥O ACTUAL CON EL A¥O DEL SISTEMA')

       CASE PRS->(RECCOUNT()) == 0
	    cError('NO EXISTE REGISTROS DE PRESUEPUESTO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>NUMERO DE SERVICIOS HABILITADOS
       IF ANO->nSerEstCfA > 1
	  cError('ESTAN HABILITADOS '+STR(ANO->nSerEstCfA,1)+' '+;
		 'INGRESOS DIARIOS A LA CAFETERIA POR ESTUDIANTE')
       ENDIF
       IF ANO->nSerProCfA > 1
	  cError('ESTAN HABILITADOS '+STR(ANO->nSerProCfA,1)+' '+;
		 'INGRESOS DIARIOS A LA CAFETERIA POR PROFESOR')
       ENDIF
       IF ANO->nSerPerCfA > 1
	  cError('ESTAN HABILITADOS '+STR(ANO->nSerPerCfA,1)+' '+;
		 'INGRESOS DIARIOS A LA CAFETERIA POR PERSONAL')
       ENDIF
*>>>>FIN NUMERO DE SERVICIOS HABILITADOS

*>>>>VALIDACION DEL PRESUPUESTO DIARIO
       IF lLocCodigo('nNroMesPrs','PRS',MONTH(DATE()))

	  cNroDia := STR(DAY(DATE()),2)
	  lCorrecion(@cNroDia)
	  IF EMPTY(&('PRS->nPres'+cNroDia+'Prs'))
	     cError('DEBE INDICACARLE AL SISTEMA '+;
		    'EL PRESUPUESTO DE CONSUMOS DEL DIA')
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF

       ELSE
	  cError('NO EXISTE EL REGISTRO DEL PRESUPUESTO DEL MES')
	   CloseAll(aUseDbf)
	   RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL PRESUPUESTO DIARIO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO.'+;
				   'FECHA: '+cFecha(DATE()),22,'°')
       aTamCol := {20,40,12}
       aTitulo := {'CODIGO','NOMBRE','OBSERVACION'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS BECADOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cCodigoTes := SPACE(20)
	    IF VAL(SCO->cTipCodSco) == 2
	       @ nNroFil,aNroCol[1] GET cCodigoTes PICT '@! XXXXXXXXXXXXXXXXXXX'
	    ELSE
	       @ nNroFil,aNroCol[1] GET cCodigoTes PICT '@! X999999999999999999'
	    ENDIF
	    READ
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
**********LECTURA DEL CODIGO

**********TIPO DE CODIGO
	    DO CASE
	    CASE VAL(SCO->cTipCodSco) == 0  // Por defecto

		 cCodigoTes := SUBS(cCodigoTes,1,8)
		 DO CASE
		 CASE LEN(ALLTRIM(cCodigoTes)) == 6
		      DO CASE
		      CASE SUBS(cCodigoTes,1,2) == '10'  // Profesor
			   cCodigoTes := '2'+cCodigoTes

		      OTHERWISE
			   cCodigoTes := '1'+cCodigoTes
		      ENDCASE

		 CASE LEN(ALLTRIM(cCodigoTes)) == 7

		      IF !ISALPHA(SUBS(cCodigoTes,1,1))
			 cCodigoTtp := STR(VAL(SUBS(cCodigoTes,1,1)),1,0)
			 cCodigoTes := SUBS(cCodigoTes,1,7)
		      ENDIF

		 CASE LEN(ALLTRIM(cCodigoTes)) == 8

		      IF !ISALPHA(SUBS(cCodigoTes,1,1))
			 cCodigoTtp := STR(VAL(SUBS(cCodigoTes,7,2)),1,0)
			 cCodigoTes := cCodigoTtp + SUBS(cCodigoTes,1,6)
		      ENDIF

		 OTHERWISE

		      IF !ISALPHA(SUBS(cCodigoTes,1,1))
			 cCodigoTtp := STR(VAL(SUBS(cCodigoTes,7,2)),1,0)
			 cCodigoTes := cCodigoTtp + SUBS(cCodigoTes,1,6)
		      ENDIF

		 ENDCASE

	    CASE VAL(SCO->cTipCodSco) == 1  // Por Analizar

		 cCodigoTes := SUBS(cCodigoTes,1,8)
		 IF !ISALPHA(SUBS(cCodigoTes,1,1))
		    cCodigoTtp := SUBS(cCodigoTes,SCO->nCodTipSco,SCO->nLenTipSco)
		    cCodigoTtp := STR(VAL(cCodigoTtp),1,0)
		    cCodigoTes := SUBS(cCodigoTes,SCO->nCodEstSco,SCO->nLenCodSco)
		    cCodigoTes := cCodigoTtp+cCodigoTes
		 ENDIF

	    CASE VAL(SCO->cTipCodSco) == 2  // C¢digo Estudiante + C‚dula

		 cCodigoTes := ALLTRIM(cCodigoTes)
		 IF UPPER(SUBS(cCodigoTes,1,2)) == 'CC' .OR.;
		    UPPER(SUBS(cCodigoTes,1,2)) == 'CE'
		    cCodigoTtp := '3'
		    cCodigoTes := SUBS(cCodigoTes,3,LEN(cCodigoTes))
		 ELSE
		    cCodigoTtp := '1'
		 ENDIF
		 cCodigoTes := cCodigoTtp+cCodigoTes

	    ENDCASE
**********FIN TIPO DE CODIGO

**********LOCALIZACION DEL TIPO DE PERSONAL
	    IF !lLocCodigo('cCodigoTip','TIP',SUBS(cCodigoTes,1,1))
	       cError('EL CODIGO DEL TIPO '+SUBS(cCodigoTes,1,1)+' '+;
		      'NO EXISTE')
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL TIPO DE PERSONAL

**********VALIDACION DEL CODIGO DE LA BOLETA
	    IF TIP->lBoletaTip

*--------------BUSQUEDA DEL CODIGO
		 lValCodBol(@cCodigoTes,2)
		 IF !lSekCodigo(cCodigoTes,'BOL','DE LA BOLETA')
		    LOOP
		 ENDIF
*--------------FIN BUSQUEDA DEL CODIGO

*--------------VALIDACION DE LA BOLETA
		 lHayErr := .T.
		 DO CASE
		 CASE EMPTY(BOL->dFecVenBol)
		      cError('LA BOLETA No.'+cCodigoTes+' NO HA SIDO VENDIDA')

		 CASE !EMPTY(BOL->dFecCnsBol)
		      cError('LA BOLETA YA FUE UTILIZADA')

		 OTHERWISE
		      lHayErr := .F.
		 ENDCASE

		 IF lHayErr
		    LOOP
		 ENDIF
		 cNombreTes := ALLTRIM(TIP->cNombreTip)
		 @ nNroFil,aNroCol[2] SAY 'BOLETA DE '+cNombreTes
*--------------FIN VALIDACION DE LA BOLETA
	    ENDIF
**********FIN VALIDACION DEL CODIGO DE LA BOLETA

**********VALIDACION DEL INGRESO
	    nTipPer := VAL(SUBS(cCodigoTes,1,1))
	    lHayErr := .T.
	    DO CASE
	    CASE nTipPer == 1 .AND. !TIP->lBoletaTip .AND.;
		 SUBS(ANO->cAutIngCfA,nTipPer,1) # '1'
		 cError('NO ESTA AUTORIZADO EL INGRESO DE LOS ESTUDIANTES')

	    CASE nTipPer == 2 .AND. !TIP->lBoletaTip .AND.;
		 SUBS(ANO->cAutIngCfA,nTipPer,1) # '1'
		 cError('NO ESTA AUTORIZADO EL INGRESO DE LOS PROFESORES')

	    CASE nTipPer > 2  .AND. !TIP->lBoletaTip .AND.;
		 SUBS(ANO->cAutIngCfA,nTipPer,1) # '1'
		 cError('NO ESTA AUTORIZADO EL INGRESO DEL PERSONAL')

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE
	    IF lHayErr
	       LOOP
	    ENDIF
**********VALIDACION DEL INGRESO

**********ANALISIS DEL TIPO DE PERSONAL
	    DO CASE
	    CASE TIP->lBoletaTip

	    CASE nTipPer == 1 .AND. !TIP->lBoletaTip
		 cExtCam := 'Est'
	    CASE nTipPer == 2 .AND. !TIP->lBoletaTip
		 cExtCam := 'Pro'
	    CASE nTipPer > 2  .AND. !TIP->lBoletaTip
		 cExtCam := 'Per'
	    OTHERWISE
		 cError('ERROR EN TIPO DE PERSONAL','FAVOR INFORMAR')
		 EXIT
	    ENDCASE
**********FIN ANALISIS DEL TIPO DE PERSONAL

**********LOCALIZACION DE CODIGO
	   DO CASE
	   CASE nTipPer == 1 .AND. !TIP->lBoletaTip

		IF !lSekCodMae(SUBS(cCodigoTes,2,6),cMaeAlu,@cMaeAct)
		   LOOP
		ENDIF

		cNalias := cMaeAct
		cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
			      RTRIM(&cMaeAct->cApelliEst)
		cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(40),1,40))
		@ nNroFil,aNroCol[2] SAY cNombreTes

		IF &cMaeAct->lRetiroEst
		   cError('EL ESTUDIANTE CON CODIGO: '+;
			  cCodigoTes+' ESTA RETIRADO')
		   LOOP
		ENDIF

	   CASE nTipPer == 2 .AND. !TIP->lBoletaTip

		cNalias := 'PRO'
		IF !lLocCodigo('cCodigoPro','PRO',SUBS(cCodigoTes,2,6))
		   cError('EL CODIGO: '+cCodigoTes+' NO EXISTE')
		   LOOP
		ENDIF
		cNombreTes := RTRIM(PRO->cNombrePro)+' '+;
			      RTRIM(PRO->cApelliPro)
		cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(40),1,40))
		@ nNroFil,aNroCol[2] SAY cNombreTes

	   CASE nTipPer > 2  .AND. !TIP->lBoletaTip

		cNalias := 'PER'

		IF VAL(SCO->cTipCodSco) == 2  // C¢digo Estudiante o Cedula

		   cDocNitTpe := SUBS(cCodigoTes,2,LEN(cCodigoTes))+SPACE(16)
		   cDocNitTpe := SUBS(cDocNitTpe,1,16)

		   IF !lLocCodigo('cDocNitPer','PER',cDocNitTpe)
		      cError('EL DOCUMENTO: '+SUBS(cCodigoTes,2,LEN(cCodigoTes))+' NO EXISTE')
		      LOOP
		   ENDIF

		ELSE

		   IF !lLocCodigo('cCodigoPer','PER',cCodigoTes)
		      cError('EL CODIGO: '+cCodigoTes+' NO EXISTE')
		      LOOP
		   ENDIF

		ENDIF
		cNombreTes := RTRIM(PER->cNombrePer)+' '+;
			      RTRIM(PER->cApelliPer)
		cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(40),1,40))
		@ nNroFil,aNroCol[2] SAY cNombreTes

	   ENDCASE
**********FIN LOCALIZACION DE CODIGO

**********VALIDACION DEL ACCESO A LA CAFETERIA
	    lHayCaf := .T.
	    DO CASE
	    CASE nTipPer == 1 .AND. !TIP->lBoletaTip

		 lHayCaf := .F.
		 IF !EMPTY(&cMaeAct->cConcepEst)

		    FOR i := 1 TO LEN(ALLTRIM(&cMaeAct->cConcepEst))/2
			cCodigoTco := SUBS(&cMaeAct->cConcepEst,i*2-1,2)
			IF lLocCodigo('cCodigoCon','CON',cCodigoTco) .AND.;
			   CON->nTipoCon == 2  // Cafeteria
			   lHayCaf := .T.
			ENDIF
		    ENDFOR

		 ENDIF

	    CASE nTipPer == 2 .AND. !TIP->lBoletaTip

		 IF SUBS(PRO->cSerHabPro,1,1) # '1'
		    lHayCaf := .F.
		 ELSE
		    IF (DATE() < PRO->dResIniPro .OR. DATE() > PRO->dResFinPro)
		       lHayCaf := .F.
		    ENDIF
		 ENDIF

	    CASE nTipPer > 2  .AND. !TIP->lBoletaTip

		 IF SUBS(PER->cSerHabPer,1,1) # '1'
		    lHayCaf := .F.
		 ELSE
		    IF (DATE() < PER->dResIniPer .OR. DATE() > PER->dResFinPer)
		       lHayCaf := .F.
		    ENDIF
		 ENDIF

	    ENDCASE

	    IF !lHayCaf
	       cError(cNombreTes+' NO TIENE SERVICIO DE CAFETERIA')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL ACCESO A LA CAFETERIA

**********VALIDACION DEL SERVICIO
	    IF !TIP->lBoletaTip
	       cCampo := cNalias+'->cRes'+cMes(MONTH(DATE()),3)+cExtCam
	       cMesSer := &cCampo
	       cDiaSer := SUBS(cMesSer,DAY(DATE()),1)
	       nNroSer := VAL(cDiaSer)

	       DO CASE
	       CASE nTipPer == 1   .AND. nNroSer >= ANO->nSerEstCfA
		    lHayCaf := .F.

	       CASE nTipPer == 2   .AND. nNroSer >= ANO->nSerProCfA
		    lHayCaf := .F.

	       CASE nTipPer > 2 .AND. nNroSer >= ANO->nSerPerCfA
		    lHayCaf := .F.
	       ENDCASE

	       IF !lHayCaf
		  @ nNroFil,aNroCol[2] SAY cNombreTes
		  cError(cNombreTes+' YA TOMO EL SERVICIO DE CAFETERIA')

		  SET COLOR TO R*
		  @ nNroFil,aNroCol[3] SAY 'INTENTO REINGRESAR'
		  SET COLOR TO

*-----------------INCREMENTO DE LAS FILAS
		    nNroFil++
		    IF nNroFil > 19

*......................IMPRESION DEL ULTIMO REGISITRO
			 nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO.'+;
						     'FECHA: '+cFecha(DATE()),22,'°')
			 @ nNroFil,nNroCol SAY cMsgTxt

			 nNroFil++
			 SET COLOR TO I
			 @ nNroFil,aNroCol[1] SAY cCodigoTes
			 @ nNroFil,aNroCol[2] SAY cNombreTes
			 SET COLOR TO

			 nNroFil++
*......................FIN IMPRESION DEL ULTIMO REGISITRO

		    ENDIF
*-----------------FIN INCREMENTO DE LAS FILAS

		  LOOP

	    ENDIF
	    nNroSer++
	    cDiaSer := STR(nNroSer,1)
	    cMesSer := STUFF(cMesSer,DAY(DATE()),1,cDiaSer)
	    ENDIF
**********FIN VALIDACION DEL SERVICIO

**********CONSULTA DEL SERVICIO DE CAFETERIA
	    IF nTipPer == 1
	       @ nNroFil,aNroCol[3] SAY &cMaeAct->cConcepEst
	    ENDIF
**********FIN CONSULTA DEL SERVICIO DE CAFETERIA

**********GRABACION DEL SERVICIO DE LA CAFETERIA
	    IF !TIP->lBoletaTip
	       SELECT &cNalias
	       IF lRegLock(lShared,.F.)
		  REPL &cCampo WITH cMesSer
	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF

	       DBCOMMIT()
	       IF lShared
		  DBUNLOCK()
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL SERVICIO DE LA CAFETERIA

**********GRABACION DEL CONSUMO DE LA BOLETA
	    IF TIP->lBoletaTip

*--------------REGISTRO DEL CONSUMO
		 IF BOL->(lRegLock(lShared,.F.))
		    REPL BOL->dFecCnsBol WITH DATE()
		    BOL->(DBCOMMIT())
		    IF lShared
		       BOL->(DBUNLOCK())
		    ENDIF
		 ENDIF
*--------------FIN REGISTRO DEL CONSUMO

*--------------GRABACION DEL CONTADOR DE CONSUMOS
		 IF TIP->(lRegLock(lShared,.F.))
		    REPL TIP->nTotCnsTip WITH TIP->nTotCnsTip+1
		    TIP->(DBCOMMIT())
		    IF lShared
		       TIP->(DBUNLOCK())
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DEL CONTADOR DE CONSUMOS

*--------------GRABACION DEL CONSUMO EN VENTAS
		 IF VBO->(lRegLock(lShared,.T.))
		    REPL VBO->cCodigoBol WITH cCodigoTes
		    REPL VBO->cCodigoTip WITH BOL->cCodigoTip
		    REPL VBO->dFecVenBol WITH BOL->dFecVenBol
		    REPL VBO->dFecCnsBol WITH BOL->dFecCnsBol
		    REPL VBO->nVlrBolBol WITH BOL->nVlrBolBol
		    REPL VBO->lImpPrnBol WITH BOL->lImpPrnBol
		    VBO->(DBCOMMIT())
		    IF lShared
		       VBO->(DBUNLOCK())
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DEL CONSUMO EN VENTAS

	    ENDIF
**********FIN GRABACION DEL CONSUMO DE LA BOLETA

**********GRABACION DEL TOTAL DE CONSUMOS
	    SELECT PRS
	    IF PRS->(lRegLock(lShared,.F.))
	       nTotDia := &('PRS->nCnsm'+cNroDia+'Prs')
	       REPL &('PRS->nCnsm'+cNroDia+'Prs') WITH nTotDia+1
	       PRS->(DBCOMMIT())
	    ENDIF
	    IF lShared
	       PRS->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL TOTAL DE CONSUMOS

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO.'+;
					     'FECHA: '+cFecha(DATE()),22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS




