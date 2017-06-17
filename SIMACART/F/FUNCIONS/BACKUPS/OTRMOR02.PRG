/*************************************************************************
* TITULO ..: DISE¥O DE LA CARTA PARA LOS ESTUDIANTES MOROSOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2001 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 AM   MAY 21/2001 LUN

OBJETIVOS:

1- Permite Crear,modicar el modelo de la Carta para los Estudiantes
   que se encuentra en mora.

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrMor022(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroCar := 1                   // N£mero de la Carta
       LOCAL cNroCar := ''                  // N£mero de la Carta
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL nTipEst := ''                  // Tipo de Estudiante
       LOCAL bCodF02 := NIL                 // Code Block asignado a F2
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cNomFac := ''                  // Nombre de la Factura
       LOCAL lTodos  := .T.                 // .T. Imprime todas las Cartas
       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda
       LOCAL nDiaIni := 0                   // D¡a mora inicial
       LOCAL nDiaFin := 0                   // D¡a mora final

       LOCAL nNroOpc := 0                   // N£mero de opci¢n
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final

       LOCAL nTipPer := 0                   // Tipo persona
       LOCAL cNombre := ''                  // Nombre
       LOCAL cDirecc := ''                  // Direcci¢n
       LOCAL nTipNit := ''                  // Tipo de Documento
       LOCAL cTipNit := ''                  // Tipo de Documento

       LOCAL lPrnCnt := .F.                 // Imprimir Contrantes
       LOCAL aDocNit := {}                  // Documento de los Contrantes
       LOCAL cDocNit := ''                  // Documento del Contratante
       LOCAL cTipDoc := ''                  // Tipo del Documento del Contrante
       LOCAL nNroCnt := 0                   // N£mero de Contratantes
       LOCAL lNoRepo := .T.                 // .F. Reportar al contrante

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL Getlist := {}                  // Variable del sistema
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DESACTIVACION DE LAS TECLAS DE FUNCION
       bCodF02 := SETKEY(K_F2)
       SETKEY(K_F2,NIL)
*>>>>FIN DESACTIVACION DE LAS TECLAS DE FUNCION

*>>>>LECTURA DEL NUMERO DE LA CARTA MODELO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','CARTA MODELO')
       @ nNroFil,nNroCol GET nNroCar PICT '999'
       READ
       IF EMPTY(nNroCar)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cNroCar := STR(nNroCar,3)
       lCorrecion(@cNroCar)
*>>>>FIN LECTURA DEL NUMERO DE LA CARTA MODELO

*>>>>EDICION DE LA CARTA MODELO
       cTxtHlp := 'Inserte el texto: (FECHA) => '+;
		   'para incluir la Fecha del Sistema'+;
		   CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (A¥O) => '+;
		    'para incluir el a¤o del Sistema'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (PADRE) => '+;
		    'para incluir el nombre del padre'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (MADRE) => '+;
		    'para incluir el nombre de la madre'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (ACUDIENTE) => '+;
		    'para incluir el nombre del acudiente'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (CONTRATANTE) => '+;
		    'para incluir el nombre del contratante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (NITCONTRATANTE) => '+;
		    'para incluir el documento del contratante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (NOMFAC) => '+;
		    'para incluir el nombre que se imprime en el Recibo'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (DIRECCION) => '+;
		    'para incluir la Direcci¢n de los Padres'+;
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
		  'Inserte el texto: (DIAMORA) => '+;
		    'para incluir la edad de la cartera en mora'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (RECIMES) => '+;
		    'para incluir el mes del recibo que no pago'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (DEUDA)  => '+;
		    'para incluir la deuda del grupo del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)

       cTitHlp := 'TEXTOS PARA LA SUSTITUCION'

       EditFile(cNomSis,"Bases\Carta"+cNroCar+'.Mor',;
			 "Edite el Texto de la Carta No. "+cNroCar,;
			 cTxtHlp,cTitHlp)

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN EDICION DE LA CARTA MODELO

*>>>>LECTURA DE LA EDAD DE LA CARTERA
       cSavPan := SAVESCREEN(0,0,24,79)
       SETCURSOR(1)
       TitBuscar(20,@nNroFil,@nNroCol,'DIAS',;
				      'EDAD DE LA CARTERA',15)

       DO WHILE .T.
	  nDiaIni := 30
	  nDiaFin := 360
	  @ nNroFil,nNroCol   SAY 'INICIAL :' GET nDiaIni PICT '999'
	  @ nNroFil+1,nNroCol SAY 'FINAL   :' GET nDiaFin PICT '999'
	  READ

	  lHayErr := .T.
	  DO CASE
	  CASE MOD(nDiaIni,30) # 0
	       cError('EL DIA INICIAL DEBE SER MULTIPLO DE 30')

	  CASE MOD(nDiaFin,30) # 0
	       cError('EL DIA FINAL DEBE SER MULTIPLO DE 30')

	  CASE nDiaIni > nDiaFin
	       cError('LOS DIAS INICIALES SON MAYORES A LOS DIAS FINALES')

	  OTHERWISE
	       lHayErr :=.F.
	  ENDCASE

	  IF lHayErr
	     LOOP
	  ENDIF
	  EXIT
       ENDDO
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nDiaIni == 0 .OR. nDiaFin == 0
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LA EDAD DE LA CARTERA

*>>>>TIPO DE IMPRESION
       SETCURSOR(1)
       cSavPan := SAVESCREEN(0,0,24,79)
       TitBuscar(38,@nNroFil,@nNroCol,'IMPRIMIR CARTA PARA:',;
				      'TIPO DE IMPRESION')
       nNroOpc := 0
       @ nNroFil,nNroCol SAY '1<PADRES> 2<CONTRATANES> 3<ABANDONAR>';
			 GET nNroOpc PICT '9';
			 VALID (nNroOpc >=1 .AND. nNroOpc <= 3)
       READ
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 3
	  RETURN NIL
       ENDIF
*>>>>FIN TIPO DE IMPRESION

*>>>>LECTURA NUMERO DE CONTRATANTES
       nNroCnt := 0
       lPrnCnt := .F.

       IF nNroOpc == 2

	  SETCURSOR(1)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  TitBuscar(24,@nNroFil,@nNroCol,'CARTAS','IMPRESION')
	  @ nNroFil,nNroCol SAY 'NUMERO DE CONTRATANES:';
			    GET nNroCnt PICT '9';
			    VALID (nNroCnt >=1 .AND. nNroCnt <= 4)
	  READ
	  SETCURSOR(0)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  lPrnCnt := .T.

       ENDIF
*>>>>FIN LECTURA NUMERO DE CONTRATANTES

*>>>>SELECCION DEL TIPO DE ESTUDIANTE
       nTipEst := nLeeTipEst()
       IF nTipEst == 0
	  nTipEst := 3
       ENDIF
*>>>>FIN SELECCION DEL TIPO DE ESTUDIANTE

*>>>>LECTURA DE LOS REGISTROS DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SETCURSOR(1)
       TitBuscar(30,@nNroFil,@nNroCol,'REGISTROS',;
				      'INTERVALO DE IMPRESION',15)
       nRegIni := 1
       nRegFin := MOR->(RECCOUNT())
       @ nNroFil,nNroCol  SAY 'INICIAL :' GET nRegIni PICT '9999';
			  VALID (nRegIni >=1 .AND. nRegIni <= nRegFin)

       @ nNroFil+1,nNroCol SAY 'FINAL   :' GET nRegFin PICT '9999';
			  VALID (nRegFin >=nRegIni .AND. nRegIni <= MOR->(RECCOUNT()))
       READ
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LOS REGISTROS DE IMPRESION

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA IMPRIMIR LAS CARTAS? Si No')
	  RETURN NIL
       ENDIF
       lTodos := !lPregunta('DESEA IMPRIMIR UNA CARTA DE MUESTRA? No Si')
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL TERMOMETRO
       Termometro(0,'IMPRIMIENDO LAS CARTAS')
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DE LA CARTA
       SELECT MOR
       MOR->(DBGOTO(nRegIni))
       DO WHILE MOR->(RECNO()) <= nRegFin

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('ºNo. '+STR(MOR->(RECNO()),4)+'/'+;
				STR(MOR->(RECCOUNT()),4),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MOR->(RECNO()) / MOR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ANALISIS DE DECISION
	    IF !(MOR->nDiaMorMor >= nDiaIni .AND.;
		 MOR->nDiaMorMor <= nDiaFin)

	       SELECT MOR
	       MOR->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE DECISION

**********BUSQUEDA DEL ESTUDIANTE
	    IF !lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct,.F.)

	       SELECT MOR
	       MOR->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN BUSQUEDA DEL ESTUDIANTE

**********LECTURA DE LOS CONTRATANTES
	    aDocNit := {}

	    IF lPrnCnt

	       FOR i := 1 TO nNroCnt

		   cDocNit := &(cMaeAct+'->cNitCo'+STR(i,1)+'Est')
		   cTipDoc := &(cMaeAct+'->cTipCo'+STR(i,1)+'Est')
		   lNoRepo := &(cMaeAct+'->lNoRCo'+STR(i,1)+'Est')

		   IF !lNoRepo
		      AADD(aDocNit,{cDocNit,cTipDoc})
		   ENDIF

	       ENDFOR

	    ELSE
		AADD(aDocNit,{'0','0'})
	    ENDIF
**********FIN LECTURA DE LOS CONTRATANTES

**********IMPRESION DE LAS CARTAS
	    FOR i := 1 TO LEN(aDocNit)

*===============ANALISIS DE DECISION
		  IF EMPTY(aDocNit[i,1])  // Descartar los no definidos
		     LOOP
		  ENDIF
*===============FIN ANALISIS DE DECISION

*===============TIPO DE PERSONA
		  cDocNit := aDocNit[i,1]
		  cTipNit := aDocNit[i,2]

		  nTipPer := nTipPerMae(cDocNit,;
					&cMaeAct->cPadNitEst,;
					&cMaeAct->cMadNitEst)
		  IF nTipPer == 3
		     lLocNitPer(cDocNit,cTipNit)
		  ENDIF
*===============FIN TIPO DE PERSONA

*===============CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA
		  cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
				RTRIM(&cMaeAct->cApelliEst)

		     cNomFac := cNomFacMae(cMaeAct,CAA->nNomFacCaA)

		  IF lPrnCnt

		      DO CASE
		      CASE nTipPer == 1                    // Padre

			   cNombre := ALLTRIM(&cMaeAct->cApePadEst)+' '+;
				      ALLTRIM(&cMaeAct->cNomPadEst)

			   cDirecc := ALLTRIM(&cMaeAct->cDireccEst)+' '+;
				      ALLTRIM(&cMaeAct->cBarrioEst)


		      CASE nTipPer == 2                    // Madre

			   cNombre := ALLTRIM(&cMaeAct->cApeMadEst)+' '+;
				      ALLTRIM(&cMaeAct->cNomMadEst)

			   cDirecc := ALLTRIM(&cMaeAct->cDireccEst)+' '+;
				      ALLTRIM(&cMaeAct->cBarrioEst)


		      CASE nTipPer == 3                    // Otra Persona

			   cNombre := cNomPer(PER->cApeUnoPer,;
					      PER->cApeDosPer,;
					      PER->cNomUnoPer,;
					      PER->cNomDosPer)

			   cDirecc := ALLTRIM(PER->cDireccPer)
		      ENDCASE

		     aMezcla := {{'(FECHA)'     ,cFecha(DATE(),10)},;
				 {'(PADRE)'     ,ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
						 ALLTRIM(&cMaeAct->cApePadEst)},;
				 {'(MADRE)'     ,ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
						 ALLTRIM(&cMaeAct->cApeMadEst)},;
				 {'(ACUDIENTE)' ,ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
						 ALLTRIM(&cMaeAct->cApeAcuEst)},;
				 {'(CONTRATANTE)',cNombre},;
				 {'(NITCONTRATANTE)',ALLTRIM(cDocNit)},;
				 {'(NOMFAC)'    ,cNomFac},;
				 {'(A¥O)'       ,cAnoUsr},;
				 {'(DIRECCION)' ,cDirecc},;
				 {'(ESTUDIANTE)',cNombreTes},;
				 {'(CODIGO)'    ,MOR->cCodigoEst},;
				 {'(GRUPO)'     ,&cMaeAct->cCodigoGru},;
				 {'(DIAMORA)'   ,ALLTRIM(STR(MOR->nDiaMorMor,4,0))},;
				 {'(RECIMES)'   ,cMes(MOR->nMesMorMor)},;
				 {'(DEUDA)',;
				   ALLTRIM(TRANS(MOR->nSdoActCli+;
						 MOR->nSdoMorCli,;
						 '$#,###,###.##'))}}
		  ELSE
		     aMezcla := {{'(FECHA)'     ,cFecha(DATE(),10)},;
				 {'(PADRE)'     ,ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
						 ALLTRIM(&cMaeAct->cApePadEst)},;
				 {'(MADRE)'     ,ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
						 ALLTRIM(&cMaeAct->cApeMadEst)},;
				 {'(ACUDIENTE)' ,ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
						 ALLTRIM(&cMaeAct->cApeAcuEst)},;
				 {'(NOMFAC)'    ,cNomFac},;
				 {'(A¥O)'       ,cAnoUsr},;
				 {'(DIRECCION)' ,&cMaeAct->cDireccEst+' '+;
						 &cMaeAct->cBarrioEst},;
				 {'(ESTUDIANTE)',cNombreTes},;
				 {'(CODIGO)'    ,MOR->cCodigoEst},;
				 {'(GRUPO)'     ,&cMaeAct->cCodigoGru},;
				 {'(DIAMORA)'   ,ALLTRIM(STR(MOR->nDiaMorMor,4,0))},;
				 {'(RECIMES)'   ,cMes(MOR->nMesMorMor)},;
				 {'(DEUDA)',;
				   ALLTRIM(TRANS(MOR->nSdoActCli+;
						 MOR->nSdoMorCli,;
						 '$#,###,###.##'))}}
		  ENDIF
*===============FIN CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA

*===============IMPRESION DE LA CARTA
		  IF MOR->lCartasMor
		     DO CASE
		     CASE nTipEst == 0 .OR. nTipEst == 3
			  PrnFileTxt("Bases\Carta"+cNroCar+'.Mor',aMezcla)

		     CASE nTipEst == 1 .AND.;
			  lEstNuevo(MOR->cCodigoEst,cAnoUsr)

			  PrnFileTxt("Bases\Carta"+cNroCar+'.Mor',aMezcla)

		     CASE nTipEst == 2 .AND.;
			  !lEstNuevo(MOR->cCodigoEst,cAnoUsr)

			  PrnFileTxt("Bases\Carta"+cNroCar+'.Mor',aMezcla)
		     ENDCASE
		     IF .NOT. lTodos
			EXIT
		     ENDIF
		  ENDIF
*===============FIN IMPRESION DE LA CARTA

	    ENDFOR
	    IF .NOT. lTodos
	       EXIT
	    ENDIF
**********FIN IMPRESION DE LAS CARTAS

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT MOR
	    MOR->(DBSKIP())

	    IF nRegIni == nRegFin

	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT

	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF

	    IF MOR->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
	    LOOP
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       SETKEY(K_F2,bCodF02)
      *Activaci¢n de la Tecla de funci¢n
       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CARTA

/*************************************************************************
* TITULO..: LECTURA DEL TIPO DE MOROSO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2001 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   MAY 21/2001 LUN

OBJETIVOS:

1- Debe estar en uso el archivo de Conceptos

2- Permite leer la Evuluaci¢n de la Clase de Moroso

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeTipMor(nFilPrn,nColPrn,nNroFil,nNroCol,cEvaMor)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilPrn			            // Fila de Impresion
       nColPrn			            // Columna de impresion
       nNroFil                              // Fila de Lectura
       nNroFil                              // Columna de Lectura
       cEvaMor                              // Evaluaci¢n de la Mora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL cCodAcu := ''                  // Codigos de Acumulados
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       cEvaMor := IF(EMPTY(cEvaMor),'RID',cEvaMor)

       nNroOpc := 0
       IF 'E' $ cEvaMor
	  AADD(aMenus,STR(++nNroOpc,1,0)+'<EXCELENTES   >')
	  AADD(aAyuda,'Estudiantes con todos los Pagos Oportunos o Extemporaneos')
       ENDIF

       IF 'B' $ cEvaMor
	  AADD(aMenus,STR(++nNroOpc,1,0)+'<BUENOS       >')
	  AADD(aAyuda,'Estudiantes con Pagos Oportunos y Extemporaneos')
       ENDIF

       IF 'A' $ cEvaMor
	  AADD(aMenus,STR(++nNroOpc,1,0)+'<ACEPTABLES   >')
	  AADD(aAyuda,'Estudiantes a Paz y Salvo que dejaron de pagar alg£n mes')
       ENDIF

       IF 'R' $ cEvaMor
	  AADD(aMenus,STR(++nNroOpc,1,0)+'<REGULARES    >')
	  AADD(aAyuda,'Morosos con 1 o 2 Meses de Atraso')
       ENDIF

       IF 'I' $ cEvaMor
	  AADD(aMenus,STR(++nNroOpc,1,0)+'<INSUFICIENTES>')
	  AADD(aAyuda,'Morosos con 3 o Mas Meses de Atraso con Pagos')
       ENDIF
       IF 'D' $ cEvaMor
	  AADD(aMenus,STR(++nNroOpc,1,0)+'<DEFICIENTES  >')
	  AADD(aAyuda,'Morosos con 3 o Mas Meses de Atraso SIN Pagos')
       ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>LECTURA DE LA TIPO DEL MOROSO
       nNroFil := IF(nNroFil == NIL,10,nNroFil)
       nNroCol := IF(nNroCol == NIL,25,nNroCol)
       DO WHILE .T.

**********SELECCION DEL TIPO
	    nNroOpc := nMenu(aMenus,aAyuda,nNroFil,nNroCol,;
			     'TIPO DE MOROSO',NIL,1,.F.)
	    IF nNroOpc == 0
	       EXIT
	    ENDIF
**********FIN SELECCION DEL TIPO

**********VALIDACION DEL CODIGO DEL CONCEPTO
	    IF nNroOpc # 0

	       IF SUBS(aMenus[nNroOpc],3,1) $ cCodAcu
		  cError('YA LO ESCOGIO')
		  LOOP
	       ELSE
		  cCodAcu := cCodAcu + SUBS(aMenus[nNroOpc],3,1)
		  SET COLOR TO I
		  @ nFilPrn,nColPrn SAY cCodAcu
		  SET COLOR TO
		*ÀAcumulaci¢n
	       ENDIF

	    ENDIF
**********FIN VALIDACION DEL CODIGO DEL CONCEPTO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN cCodAcu
*>>>>FIN LECTURA DE LA EVALUACION DEL MOROSO


/*************************************************************************
* TITULO..: TIPO DE ESTUDIANTE                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2001 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   MAY 21/2001 LUN

OBJETIVOS:

1- Debe estar en uso el archivo de Conceptos

2- Permite escoger el tipo de Estudiante Nuevo o Antiguo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeTipEst(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de Lectura
       nNroCol                              // Columna de Lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<NUEVOS       >')
       AADD(aMenus,'2<ANTIGUOS     >')
       AADD(aMenus,'3<TODOS        >')

       AADD(aAyuda,'Estudiantes Nuevos')
       AADD(aAyuda,'Estudiantes Antiguos')
       AADD(aAyuda,'Estudiantes Nuevos y Antiguos')

       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>SELECCION DEL TIPO DE ESTUDIANTE
       nNroFil := IF(nNroFil == NIL,10,nNroFil)
       nNroCol := IF(nNroCol == NIL,25,nNroCol)
       nNroOpc := nMenu(aMenus,aAyuda,nNroFil,nNroCol,'ESTUDIANTE',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroOpc
*>>>>FIN SELECCION DEL TIPO DE ESTUDIANTE

/*************************************************************************
* TITULO..: ESTUDIANTE NUEVO                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2001 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   MAY 21/2001 LUN

OBJETIVOS:

1- Analiza si el Estudiante es Nuevo o Antiguo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lEstNuevo(cCodEst,cAnoUsr)

*>>>>DESCRIPCION DE VARIABLES
/*     cCodEst                              // C¢digo del Estudiante
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cAnoCod := ''                  // A¤o del Codigo
       LOCAL lNuevos := .F.                 // .T. Estudiante Nuevo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE CODIGO DEL ESTUDIANTE
       IF VAL(cAnoUsr) < 2000
	  cAnoCod := cAnoSis
	  IF SUBS(cCodEst,1,2) == cAnoCod
	     lNuevos := .T.
	  ENDIF
       ELSE
	  cAnoCod := SUBS(cAnoUsr,1,1)+cAnoSis
	  IF SUBS(cCodEst,1,3) == cAnoCod
	     lNuevos := .T.
	  ENDIF
       ENDIF
       RETURN lNuevos
*>>>>FIN ANALISIS DE CODIGO DEL ESTUDIANTE


