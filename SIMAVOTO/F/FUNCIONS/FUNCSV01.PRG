/*************************************************************************
* TITULO..: ELECCIONES DEL GOBIERNO ESCOLAR                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 19/2000 LUN A
       Colombia, Bucaramanga        INICIO: 02:30 PM   FEB 19/2000 LUN

OBJETIVOS:

2- Permite las elecciones del Gobierno Escolar.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Voto01(aP1)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nLenCod := 0                   // L¢ngitud del C¢digo
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL cCodGru := ''                  // Codigo del Grupo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTcn := ''               // C¢digo del Candidato
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cVotEstTes := ''               // Voto Escolar del Estudiante
       LOCAL cCodigoTel := ''               // C¢digo de la Elecci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCnd,'CND',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileEle,'ELE',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ELE->(RECCOUNT()) == 0
	    cError('NO EXISTEN ELECCCIONES GRABADAS')

       CASE CND->(RECCOUNT()) == 0
	    cError('NO EXISTEN CANDIDATOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DISE¥O DE LA PANTALLA INICIAL
       IF ISCOLOR()
	   SetColor("W+/B,N/W,B")
	   CLEAR
       ENDIF
       DISPBOX(01,00,05,78,'ÉÍ»º¼ÍÈº')
       Centrar(cNomEmp,02)
       Centrar(cNomSis+' A¥0:'+cAnoUsr,03)
       Centrar('ELECCION DEL GOBIERNO ESCOLAR',04)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
*>>>>FIN DISE¥O DE LA PANTALLA INICIAL

*>>>>CAPTURA DE LOS VOTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nLenCod := 8
       nNroFil := 07
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    SET COLOR TO I
	    DISPBOX(10,30,15,52,"ÉÍ»º¼ÍÈº")
	    SET COLOR TO
	    @ 11,37 SAY 'POR FAVOR'
	    @ 12,33 SAY 'INGRESE SU CODIGO'
	    cCodigoTes := cLeeCodEst(13,38,cMaeAlu,@cMaeAct,nLenCod)
	    DO CASE
	    CASE LASTKEY() == K_ESC
		 EXIT
	    CASE EMPTY(cCodigoTes)
		 LOOP
	    ENDCASE
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN LECTURA DEL CODIGO

**********VALIDACION DEL VOTO
	    SELECT &cMaeAct
	    cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
			  RTRIM(&cMaeAct->cApelliEst)
	    cCodigoTgr := &cMaeAct->cCodigoGru
	       nNroReg := RECNO()

	    IF !EMPTY(&cMaeAct->cVotEscEst)
	       cError(cNombreTes+' YA VOTO')
	       LOOP
	    ENDIF
	    cVotEstTes := ''
**********FIN VALIDACION DEL VOTO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF &cMaeAct->lRetiroEst
	       cError(cNombreTes+' ESTA RETIRADO(A)')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********VALIDACION DEL COLOR
	    IF ISCOLOR()
	       SetColor("W+/B,N/W,B")
	    ENDIF
**********FIN VALIDACION DEL COLOR

**********VALIDACION DEL NOMBRE
	    cError('USTED ES '+cNombreTes)
	    IF !lPregunta('DESEA VOTAR? Si No')
	       LOOP
	    ENDIF
	    DISPBOX(06,00,22,78,'ÉÍ»º¼ÍÈº')
	    @ 07,01 SAY 'POR FAVOR '+cNombreTes+' INGRESE SU VOTO'
**********FIN VALIDACION DEL NOMBRE

**********LECTURA Y VALIDACION DEL VOTO
	    SELECT ELE
	    nNroFil := 09
	    GO TOP
	    DO WHILE .NOT. ELE->(EOF())

*--------------VALIDACION DE LA ELECION
		 IF !EMPTY(ELE->cNivIniEle) .OR. !EMPTY(ELE->cNivFinEle)

		    IF VAL(ELE->cNivIniEle) <= 11
		       IF !(VAL(SUBS(cCodigoTgr,1,2)) >= VAL(ELE->cNivIniEle) .AND.;
			    VAL(SUBS(cCodigoTgr,1,2)) <= VAL(ELE->cNivFinEle))
			  SELECT ELE
			  ELE->(DBSKIP())
			  LOOP
		       ENDIF
		    ELSE
		       IF VAL(SUBS(cCodigoTgr,1,2)) <= 11
			  IF !(VAL(SUBS(cCodigoTgr,1,2)) <= VAL(ELE->cNivIniEle) .AND.;
			       VAL(SUBS(cCodigoTgr,1,2)) <= VAL(ELE->cNivFinEle))
			     SELECT ELE
			     ELE->(DBSKIP())
			     LOOP
			  ENDIF
		       ELSE
			  IF !(VAL(SUBS(cCodigoTgr,1,2)) >= VAL(ELE->cNivIniEle) .AND.;
			       VAL(SUBS(cCodigoTgr,1,2)) >= VAL(ELE->cNivFinEle))
			     SELECT ELE
			     ELE->(DBSKIP())
			     LOOP
			  ENDIF
		       ENDIF
		    ENDIF

		 ENDIF
*--------------FIN VALIDACION DE LA ELECION

*--------------LECTURA DEL VOTO
		 cCodigoTcn := cSpaces('CND','cCodigoCnd')
		 cCodigoTel := ELE->cCodigoEle

		 @ nNroFil,01 SAY 'VOTO PARA '+ELE->cNombreEle;
			      GET cCodigoTcn PICT "999";
			      VALID cCodigoTcn # SPACE(03)
		 READ
		 cVotEstTes += cCodigoTcn
*--------------FIN LECTURA DEL VOTO

*--------------LOCALIZACION DEL CANDIDATO
		 SELECT CND
		 IF VAL(cCodigoTcn) # 0 .OR.;
		    (VAL(cCodigoTcn) == 0 .AND. ELE->nValidaEle == 0)

		    LOCATE FOR CND->cCodigoCnd == cCodigoTcn .AND.;
			       CND->cCodigoEle == ELE->cCodigoEle
		 ELSE
		    IF ELE->nValidaEle == 1
		       LOCATE FOR CND->cCodigoCnd == cCodigoTcn .AND.;
				  CND->cCodigoEle == ELE->cCodigoEle .AND.;
				  CND->cCodigoGru == SUBS(cCodigoTgr,1,2)+'00'
		    ELSE
		       LOCATE FOR CND->cCodigoCnd == cCodigoTcn .AND.;
				  CND->cCodigoEle == ELE->cCodigoEle .AND.;
				  CND->cCodigoGru == cCodigoTgr
		    ENDIF
		  *ÀVoto en Blanco
		 ENDIF

		 IF .NOT. FOUND()
		    cError('NO EXISTE CANDIDATO PARA '+;
			   ALLTRIM(ELE->cNombreEle)+' CON EL VOTO No. '+;
			   cCodigoTcn)
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DEL CANDIDATO

*--------------VALIDACCION DEL ELECTOR
		 IF VAL(CND->cCodigoCnd) # 0 .AND. ELE->nValidaEle # 0

		    cCodGru := ''
		    IF lSekCodMae(CND->cCodigoEst,cMaeAlu,@cMaeAct)
		       cCodGru := &cMaeAct->cCodigoGru
		    ENDIF

		    lHayErr := .T.
		    DO CASE
		    CASE ELE->nValidaEle == 1 .AND.;
			 SUBS(cCodigoTgr,1,2) # SUBS(cCodGru,1,2)
			 cError('DEBE VOTAR POR UN CANDIDATO DEL NIVEL '+;
				SUBS(cCodigoTgr,1,2))

		    CASE ELE->nValidaEle == 2 .AND. cCodigoTgr # cCodGru
			 cError('DEBE VOTAR POR UN CANDIDATO DEL GRUPO '+;
				cCodigoTgr)
		    OTHERWISE
			 lHayErr := .F.
		    ENDCASE
		    IF lHayErr
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN VALIDACCION DEL ELECTOR

*--------------ACUMULACION DEL VOTO
		 SELECT CND
		 IF CND->(lRegLock(lShared,.F.))
		    REPL CND->nTotVotEle WITH ++CND->nTotVotEle
		    CND->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
		 ENDIF
		 IF lShared
		    CND->(DBUNLOCK())
		 ENDIF
*--------------FIN ACUMULACION DEL VOTO

*--------------CONTROL DEL VOTO
		 SELECT &cMaeAct
		 GO nNroReg
		 IF lRegLock(lShared,.F.)
		    REPL &cMaeAct->cVotEscEst WITH cVotEstTes
		    DBCOMMIT()
		 ELSE
		    cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
		 ENDIF
		 IF lShared
		    DBUNLOCK()
		 ENDIF
*--------------FIN CONTROL DEL VOTO

	       nNroFil++
	       SELECT ELE
	       ELE->(DBSKIP())

	    ENDDO
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN LECTURA Y VALIDACION DEL VOTO

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN CAPTURA DE LOS VOTOS