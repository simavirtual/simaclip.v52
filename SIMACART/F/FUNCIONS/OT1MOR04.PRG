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

FUNCTION OtrMor044(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL cSavPan := ''
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroCar := 1                   // N£mero de la Carta
       LOCAL cNroCar := ''                  // N£mero de la Carta
       LOCAL cTipMor := ''                  // Tipo de Moroso
       LOCAL cNotMor := ''                  // Nota del Moroso
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL nTipEst := ''                  // Tipo de Estudiante
       LOCAL bCodF02 := NIL                 // Code Block asignado a F2
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cNomFac := ''                  // Nombre de la Factura
       LOCAL lTodos  := .T.                 // .T. Imprime todas las Cartas
       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda

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
		  'Inserte el texto: (PADRE) => '+;
		    'para incluir el nombre del padre'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (MADRE) => '+;
		    'para incluir el nombre de la madre'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (ACUDIENTE) => '+;
		    'para incluir el nombre del acudiente'+;
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
		  'Inserte el texto: (DEUDA)  => '+;
		    'para incluir la deuda del grupo del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)

       cTitHlp := 'TEXTOS PARA LA SUSTITUCION'

       EditFile(cNomSis,"Bases\Carta"+cNroCar+'.Mor',;
			 "Edite el Texto de la Carta No. "+cNroCar,;
			 cTxtHlp,cTitHlp)

       IF !lPregunta('DESEA CONTINUAR? No Si')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN EDICION DE LA CARTA MODELO

*>>>>SELECCION DE TIPO DE MOROSO
       TitBuscar(10,@nNroFil,@nNroCol,,'EVALUACION')
       cTipMor := cLeeTipMor(nNroFil,nNroCol,nNroFil+2,nNroCol-2)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(cTipMor)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE TIPO DE MOROSO

*>>>>SELECCION DEL TIPO DE ESTUDIANTE
       nTipEst := nLeeTipEst()
       IF nTipEst == 0
	  nTipEst := 3
       ENDIF

       IF !lPregunta('DESEA IMPRIMIR LAS CARTAS? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       lTodos := !lPregunta('DESEA IMPRIMIR UNA CARTA DE MUESTRA? No Si')
*>>>>FIN SELECCION DEL TIPO DE ESTUDIANTE

*>>>>IMPRESION DEL TERMOMETRO
       Termometro(0,'IMPRIMIENDO LAS CARTAS')
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DE LA CARTA
       SELECT MOR
       GO TOP
       DO WHILE .NOT. MOR->(EOF())

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

**********BUSQUEDA DEL ESTUDIANTE
	    cNotMor := ''
	    IF lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct,.F.)

*--------------ANALISIS DEL TIPO DE MOROSO
		 cNotMor := cNotaCli(MOR->cCodigoEst,;
				     &cMaeAct->cCodigoGru,;
				     ALLTRIM(CAA->cConPenCaA)+;
				     ALLTRIM(&cMaeAct->cConcepEst),;
				     MOR->nSdoActCli+MOR->nSdoMorCli,;
				     TipoMora(MOR->cMesPagCli),;
				     MOR->cMesPagCli)
*--------------FIN ANALISIS DEL TIPO DE MOROSO

*--------------CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA
		 cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
			       RTRIM(&cMaeAct->cApelliEst)

		    cNomFac := cNomFacMae(cMaeAct,CAA->nNomFacCaA)

		 aMezcla := {{'(FECHA)'     ,cFecha(DATE(),10)},;
			     {'(PADRE)'     ,&cMaeAct->cNomPadEst},;
			     {'(MADRE)'     ,&cMaeAct->cNomMadEst},;
			     {'(ACUDIENTE)' ,&cMaeAct->cNomAcuEst},;
			     {'(NOMFAC)'    ,cNomFac},;
			     {'(DIRECCION)' ,&cMaeAct->cDireccEst},;
			     {'(ESTUDIANTE)',cNombreTes},;
			     {'(CODIGO)'    ,MOR->cCodigoEst},;
			     {'(GRUPO)'     ,&cMaeAct->cCodigoGru},;
			     {'(DEUDA)',;
			       ALLTRIM(TRANS(MOR->nSdoActCli+;
					     MOR->nSdoMorCli,;
					     '$#,###,###.##'))}}
*--------------FIN CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA

*--------------IMPRESION DE LA CARTA
		 IF cNotMor $ cTipMor .AND. MOR->lCartasMor
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
		    EJECT
		    IF .NOT. lTodos
		       EXIT
		    ENDIF
		 ENDIF
*--------------FIN IMPRESION DE LA CARTA

	    ENDIF
**********FIN BUSQUEDA DEL ESTUDIANTE

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT MOR
	    MOR->(DBSKIP())
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