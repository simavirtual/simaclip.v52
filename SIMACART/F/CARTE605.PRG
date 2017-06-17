/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : OTROS
SUBMODULO...: CONSIGNACIONES

**************************************************************************
* TITULO..: CONSIGNACIONES RECIBOS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2014 MAR A
       Colombia, Bucaramanga        INICIO: 07:30 PM   NOV 18/2014 MAR

OBJETIVOS:

1- Permite imprimir recibos para hacer consignaciones

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_605(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-FACT.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cIntSco := ''                  // Path de SimaCont Principal
       LOCAL cIntMtr := ''                  // Path de SimaMatr Principal
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nOpcion := 0                   // N£mero de Opci¢n.
       LOCAL lNuevos := .F.                 // .T. Matricula para nuevos
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path A¤os anteriores

       LOCAL cNalias := ''                  // Alias Antiguos o nuevos
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cMsgTxt := ''                  // Variable de texto
       LOCAL cTxtTem := ''                  // Texto temporal

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago
       LOCAL dFecOpo := CTOD('00/00/00')    // Fecha de la Consignaci¢n Opo
       LOCAL dFecExt := CTOD('00/00/00')    // Fecha de la Consignaci¢n Ext
       LOCAL nValor  := 0                   // Valor a Consignar
       LOCAL aConRec := {}                  // Conceptos del recibo
       LOCAL aPrmRec := {}                  // Parametros del Recibo
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTni := ''               // C¢digo del Grado

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
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
       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>PATH DE INTEGRACION
       cIntSco := ALLTRIM(CAA->cIntUnoCaA)
       IF !EMPTY(ALLTRIM(CAA->cIntScoCaA))
	  cIntSco := ALLTRIM(CAA->cIntScoCaA)
       ENDIF

       cIntMtr := ALLTRIM(CAA->cIntDosCaA)
       IF !EMPTY(ALLTRIM(CAA->cIntMtrCaA))
	  cIntMtr := ALLTRIM(CAA->cIntMtrCaA)
       ENDIF
       CloseAll()
*>>>>FIN PATH DE INTEGRACION

*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS
       nOpcion := nLeeOpcion('CONSIGNACIONES PARA: '+;
			     '1<NUEVOS> 2<ANTIGUOS> '+;
			     '3<A¥OS ANTERIORES 4<ABANDONAR>?',4,'1')

       IF nOpcion == 4
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF

       lNuevos := .F.
       IF nOpcion == 1
	  lNuevos := .T.
       ENDIF
*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS

*>>>>LECTURA Y VALIDACION DEL A¥O
       IF nOpcion == 3 // A¥OS ANTERIORES

	  cSavPan := SAVESCREEN(0,0,24,79)
	  cAnoAnt := SPACE(04)
	  @ nFilInf+1,nColInf SAY 'A¥O:' GET cAnoAnt PICT '9999'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(cAnoAnt)
	     cError('SE ABANDONA EL PROCESO')
	     CloseAll()
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN LECTURA Y VALIDACION DEL A¥O

*>>>>SELECCION DEL A¥O ANTERIOR
       DO CASE
       CASE nOpcion == 1 // ANTIGUOS

	    cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)

	    cTxtTem := 'NUEVOS'


       CASE nOpcion == 2 // ANTIGUOS

	    cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)

	    cTxtTem := 'ANTIGUOS'

       CASE nOpcion == 3 // A¥OS ANTERIORES

	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)

	    cTxtTem := 'ANTIGUOS A¥OS ANTERIORES'

       ENDCASE
*>>>>FIN SELECCION DEL A¥O ANTERIOR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntMtr+'\'+cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntMtr+'\'+cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntSco+'\'+cPatAnt,;
			 cMaeAlu,SUBS(cAnoAnt,3,2)) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA DEFINIDO EL CODIGO DE LA EMPRESA')

       CASE EMPTY(SCO->cCodEanCon)
	    cError('NO SE HA DEFINIDO EL CODIGO EAN13 PARA EL RECAUDO')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE EMPTY(CAR->cCodFacCar)
	    cError('NO SE HA CONFIRGURADO EL CODIGO DEL SERVICIO FACTURADO')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->nMesIniCaA == 0
	    cError('NO SE HA DEFINIDO EL MES INICIAL DE LA FACTURACION')

       CASE CAA->nMesFinCaA == 0
	    cError('NO SE HA DEFINIDO EL MES FINAL DE LA FACTURACION')

       CASE CAA->nRecNroCaA == 0 .OR. CAA->nRecNroCaA == 10
	    cError('EL RECIBO No.'+STR(CAA->nRecNroCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE CAA->nRecNroCaA == 0 .OR. CAA->nRecNroCaA > 11
	    cError('EL RECIBO No.'+STR(CAA->nRecNroCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE lNuevos .AND. ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin')

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria')

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato')

       CASE !ANO->lHayInsAno
	  cError('Estan Cerradas las Inscripciones para '+cAnoUsr,;
		 '!Atenci¢n!')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CMV->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS DE MOVIMIENTOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO
       IF CAA->cCodigoBan == cSpaces('BAN','cCodigoBan')
	  cError('A CONTINUACION ESCOJA EL BANCO',;
		 'NO SE HA DEFINIDO EL BANCO DONDE SE DEBE PAGAR')
	  CambiaBan(lShared,nFilInf+1,nColInf)
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO

*>>>>FILTRACION DEL ARCHIVO
       SELECT CMV
       SET FILTER TO CMV->lConsigCmv

       CMV->(DBGOTOP())
       IF CMV->(EOF())
	  SET FILTER TO
	  cError('NO EXISTEN CONCEPTOS MARCADOS PARA CONSIGNAR')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>CONCEPTO DE LA CONSIGNACION
       IF nSelCodCmv(nFilInf+1,nColInf) == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONCEPTO DE LA CONSIGNACION

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'consigna'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,.F.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'A¥O:'+cAnoUsr+'.CONSIGNACIONES DE '+;
				    ALLTRIM(CMV->cNombreCmv)+'.'+;
				   'ALUMNOS '+cTxtTem,22,'°')
       nNroCol := 1

       cMsgTxt := cRegPrint({'CODIGO',;
			     'GRADO',;
			     'VALOR',;
			     'INI',;
			     'FIN',;
			     'F.OPO',;
			     'F.EXT'},;
			     {06,06,10,04,04,10,10},@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LAS CONSIGNACIONES
       nNroFil++
       DO WHILE .T.

**********CAPTURA DEL CODIGO DEL ESTUDIANTE
	    SET DEVICE TO SCREEN

	    cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)
	    cCodigoTes := IF(lNuevos,SPACE(04),SPACE(06))

	    DO CASE
	    CASE lNuevos
		 cNalias := 'ADM'
		 IF lLeeCodAdm(nNroFil,aNroCol[1],;
			       @cCodigoTes,{||lLocCodigo('cNumeroAdm',;
					      'ADM',cCodigoTes,;
					      'NUMERO DE INSCRIPCION')})
		     EXIT
		 ENDIF

		 cCodigoTes := ADM->cCodigoEst

	    CASE !lNuevos
		 cCodigoTes := cCodEstMtr(nNroFil,aNroCol[1],;
					  cMaeAlu,@cMaeAct)
		    cNalias := cMaeAct
	    ENDCASE

	    IF LASTKEY() == K_ESC .OR. EMPTY(cCodigoTes) .OR.;
	       EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := ALLTRIM(RTRIM(&cNalias->cApelliEst)+' '+;
				  &cNalias->cNombreEst)

**********FIN CAPTURA DEL CODIGO DEL ESTUDIANTE

**********VALIDACION DEL CODIGO
	    DO CASE
	    CASE lNuevos .AND. &cNalias->lRetiroAdm
		 cError(cNombreTes+ 'ESTA RETIRADO')
		 LOOP

	    CASE !(&cNalias->lSiCupoEst)
		 cError(cNombreTes+' NO TIENE CUPO')
		 LOOP

	    CASE !lNuevos
		 IF SUBS(&cNalias->cCodigoGru,1,2) = '11' .AND.;
		    !&cNalias->lRepiteEst
		    cError(cNombreTes+' ES BACHILLER')
		    LOOP
		 ENDIF
	    ENDCASE
**********FIN VALIDACION DEL CODIGO


**********ANALISIS DEL GRUPO
	    DO CASE
	    CASE !lNuevos

*----------------ANALISIS DEL GRUPO PARA ANTIGUOS
		   IF &cNalias->lRepiteEst

		      IF SUBS(&cNalias->cCodigoGru,1,2) == '17'
			 cCodigoTgr := '00'+SUBS(&cNalias->cCodigoGru,3,2)
		      ELSE
			 cCodigoTgr := &cNalias->cCodigoGru
		      ENDIF

		   ELSE

		      IF SUBS(&cNalias->cCodigoGru,1,2) == '16'
			 cCodigoTgr := '00'
		      ELSE
			 IF SUBS(&cNalias->cCodigoGru,1,2) == '17'
			    cCodigoTgr := '01'
			 ELSE
			    cCodigoTgr := STR(VAL(SUBS(&cNalias->cCodigoGru,1,2))+1,2)
			 ENDIF
		      ENDIF
		      lCorrecion(@cCodigoTgr)
		      cCodigoTgr += SUBS(&cNalias->cCodigoGru,3,2)
		   ENDIF
*----------------FIN ANALISIS DEL GRUPO PARA ANTIGUOS

*----------------LECTURA DEL CODIGO DEL NIVEL
		   IF nOpcion == 3 // A¥OS ANTERIORES

		      DO WHILE .T.
			 IF !lLeeCodNiv(nNroFil,aNroCol[2],@cCodigoTni,;
				      {||lValCodNiv(cCodigoTni,cMaeAlu)})
			    LOOP
			 ENDIF
			 EXIT
		      ENDDO
		      cCodigoTgr := cCodigoTni+'00'

		   ENDIF
*----------------FIN LECTURA DEL CODIGO DEL NIVEL


	    OTHERWISE

*----------------ANALISIS DEL GRUPO PARA NUEVOS
		   cCodigoTgr := &cNalias->cCodigoGru
		   IF SUBS(&cNalias->cCodigoGru,1,2) == '17'
		      cCodigoTgr := '00'
		      cCodigoTgr += SUBS(&cNalias->cCodigoGru,3,2)
		   ENDIF
*----------------FIN ANALISIS DEL GRUPO PARA NUEVOS

	    ENDCASE

	    cSavLin := SAVESCREEN(22,00,22,79)
	    centrar(cNombreTes+' GRADO:'+cNomNiv(SUBS(cCodigoTgr,1,2)),22)
	    @ nNroFil,aNroCol[2] SAY SUBS(cCodigoTgr,1,2)
**********FIN ANALISIS DEL GRUPO

**********LECTURA DETALLES DEL RECIBO
	   nValor := 0
	   @ nNroFil,aNroCol[3] GET nValor PICT '9999999'

	   nMesIni := 0
	   @ nNroFil,aNroCol[4] GET nMesIni PICT '99';
			   VALID lnValMes(ROW(),COL()-2,@nMesIni)

	   nMesFin := 0
	   @ nNroFil,aNroCol[5] GET nMesFin PICT '99';
			   VALID lnValMes(ROW(),COL()-2,@nMesFin)


	   dFecOpo := DATE()
	   @ nNroFil,aNroCol[6] GET dFecOpo PICT '@!D';
				VALID !EMPTY(dFecOpo);
	   WHEN  {||HelpRead('Digite las Fechas en el Formato: MM/DD/AAAA')}

	   dFecExt := dFecOpo
	   @ nNroFil,aNroCol[7] GET dFecExt PICT '@!D';
				VALID !EMPTY(dFecExt);
	   WHEN  {||HelpRead('Digite las Fechas en el Formato: MM/DD/AAAA')}

	   READ
**********FIN LECTURA DETALLES DEL RECIBO

**********VALIDACION DE LA LECTURAS
	   lHayErr := .T.
	   DO CASE
	   CASE nMesIni == 0 .OR. nMesFin == 0 .OR. nValor == 0
		cError('NO SE IMPRIME EL RECIBO')

	   CASE nMesIni < CAA->nMesIniCaA
		cError('EL MES INICIAL NO DEBE SER MENOR A '+;
		       cMes(CAA->nMesIniCaA,3))

	   CASE nMesFin > CAA->nMesFinCaA
		cError('EL MES FINAL NO DEBE SER MAYOR A '+;
		       cMes(CAA->nMesFinCaA,3))

	   CASE nMesIni > nMesFin
		cError('EL MES INICIAL NO DEBE SER MAYOR A '+;
		       cMes(CAA->nMesIniCaA,3))

	   OTHERWISE
		lHayErr :=.F.
	   ENDCASE
	   IF lHayErr
	      RESTSCREEN(22,00,22,79,cSavLin)
	      LOOP
	   ENDIF
**********FIN VALIDACION DE LA LECTURAS

**********VALOR DE LOS CONCEPTOS
	    aConRec := {}
	    AADD(aConRec,{CMV->cNombreCmv,;            // 1. CONCEPTO
			  '',;                         // 2. MORA
			  '',;                         // 3. VALOR MES
			  TRANS(nValor,'9,999,999')})  // 4. TOTAL

/*Prueba de los 8 Conceptos
	    AADD(aConRec,{'MATRICULA',;                // 1. CONCEPTO
			  TRANS(nValor,'9,999,999'),;  // 2. MORA
			  TRANS(nValor,'9,999,999'),;  // 3. VALOR MES
			  TRANS(nValor,'9,999,999')})  // 4. TOTAL

	    AADD(aConRec,{'OTROS COSTOS',;             // 1. CONCEPTO
			  TRANS(nValor,'9,999,999'),;  // 2. MORA
			  TRANS(nValor,'9,999,999'),;  // 3. VALOR MES
			  TRANS(nValor,'9,999,999')})  // 4. TOTAL

	    AADD(aConRec,{'RESTAURANTE',;              // 1. CONCEPTO
			  TRANS(nValor,'9,999,999'),;  // 2. MORA
			  TRANS(nValor,'9,999,999'),;  // 3. VALOR MES
			  TRANS(nValor,'9,999,999')})  // 4. TOTAL

	    AADD(aConRec,{'TRANSPORTE',;               // 1. CONCEPTO
			  TRANS(nValor,'9,999,999'),;  // 2. MORA
			  TRANS(nValor,'9,999,999'),;  // 3. VALOR MES
			  TRANS(nValor,'9,999,999')})  // 4. TOTAL

	    AADD(aConRec,{'AGENDA',;                   // 1. CONCEPTO
			  TRANS(nValor,'9,999,999'),;  // 2. MORA
			  TRANS(nValor,'9,999,999'),;  // 3. VALOR MES
			  TRANS(nValor,'9,999,999')})  // 4. TOTAL

	    AADD(aConRec,{'CARNET',;                   // 1. CONCEPTO
			  TRANS(nValor,'9,999,999'),;  // 2. MORA
			  TRANS(nValor,'9,999,999'),;  // 3. VALOR MES
			  TRANS(nValor,'9,999,999')})  // 4. TOTAL

	    AADD(aConRec,{'GESTION DE COBRANZA',;      // 1. CONCEPTO
			  TRANS(nValor,'9,999,999'),;  // 2. MORA
			  TRANS(nValor,'9,999,999'),;  // 3. VALOR MES
			  TRANS(nValor,'9,999,999')})  // 4. TOTAL
*/
**********FIN VALOR DE LOS CONCEPTOS

**********PARAMETROS DEL RECIBO
	    aP3 := {}

	    AADD(aP3,{'cCodEan',SCO->cCodEanCon})
	    AADD(aP3,{'cCodFac',CAR->cCodFacCar})

	    AADD(aP3,{'cCodIso',''})

	    AADD(aP3,{'cCodEst',cCodigoTes})
	    AADD(aP3,{'cCodGru',cCodigoTgr})
	    AADD(aP3,{'cNomEst',cNombreTes})
	    AADD(aP3,{'nMesIni',nMesIni})
	    AADD(aP3,{'nMesFin',nMesFin})

	    AADD(aP3,{'cRefRec',''})

	    AADD(aP3,{'cNomBan',BAN->cNombreBan})
	    AADD(aP3,{'cCtaBan',BAN->cNroCtaBan})
	    AADD(aP3,{'aConRec',aConRec})

	    AADD(aP3,{'dFecOpo',dFecOpo})
	    AADD(aP3,{'dFecExt',dFecExt})

	    AADD(aP3,{'nVlrOpo',nValor})
	    AADD(aP3,{'nVlrExt',nValor})

	    AADD(aP3,{'cTxtUno',ALLTRIM(CAA->cTxtUnoCaA)})
	    AADD(aP3,{'cTxtDos',ALLTRIM(CAA->cTxtDosCaA)})
**********FIN PARAMETROS DEL RECIBO

**********IMPRISION DEL RECIBO DE PAGO
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE CAA->nRecNroCaA == 1

		*Recibo dise¤o Colegio la Salle.

	    CASE CAA->nRecNroCaA == 2

		*Recibo dise¤o Colegio la Merced y Bethlemitas

	    CASE CAA->nRecNroCaA == 3 .OR. CAA->nRecNroCaA == 4

		*Recibo dise¤o Colegio la Salle con Colilla

	    CASE CAA->nRecNroCaA == 5

		*Recibo c¢digo de Barras la Kiosera con formato. Virrey.

	    CASE CAA->nRecNroCaA == 6


		*Recibo c¢digo de Barras la Kiosera. La Presentaci¢n.

	    CASE CAA->nRecNroCaA == 8

		 nRecOtr08(aP1,aP2,aP3)
		*Recibo c¢digo de Barras la Kiosera. La Salle Formato

	    CASE CAA->nRecNroCaA == 9

		*Recibo c¢digo de Barras la Kiosera. La Salle PreImpreso

	    CASE CAA->nRecNroCaA == 11

		*Recibo Bethlemitas. Iso

	    ENDCASE
	    SET DEVICE TO SCREEN
**********FIN IMPRISION DEL RECIBO DE PAGO

**********INCREMENTO DE LAS FILAS
	    RESTSCREEN(22,00,22,79,cSavLin)
	    nNroFil++
	    IF nNroFil > 19

*--------------ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,ALLTRIM(CAR->cSerFacCar)+'.'+;
				   'A¥O:'+cAnoUsr+;
				   '.CONSIGNACIONES ALUMNOS '+cTxtTem,22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 SET COLOR TO

		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY cCodigoTgr
		 @ nNroFil,aNroCol[4] GET nMesIni
		 @ nNroFil,aNroCol[5] GET nMesFin
		 @ nNroFil,aNroCol[6] GET nValor PICT '9999999'


		 nNroFil++
*--------------FIN ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LAS CONSIGNACIONES