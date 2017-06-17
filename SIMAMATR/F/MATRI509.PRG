/* SIMA - MATRICULA ACADEMICA

MODULO      : PAGOS
SUBMODULO...: FACTURACION

**************************************************************************
* TITULO..: FACTURACION                                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2014 MAR A
       Colombia, Bucaramanga        INICIO: 07:30 PM   NOV 18/2014 MAR

OBJETIVOS:

1- Permite imprimir recibos para hacer consignaciones

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_509(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
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
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL nOpcion := 0                   // N£mero de Opci¢n.
       LOCAL lNuevos := .F.                 // .T. Matricula para nuevos
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path A¤os anteriores

       LOCAL cNalias := ''                  // Alias Antiguos o nuevos
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cMsgTxt := ''                  // Variable de texto

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL dFecOpo := CTOD('00/00/00')    // Fecha de la Consignaci¢n Opo
       LOCAL dFecExt := CTOD('00/00/00')    // Fecha de la Consignaci¢n Ext
       LOCAL nValor  := 0                   // Valor a Consignar

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTni := ''               // C¢digo del Grado
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

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

       CASE nOpcion == 2 // ANTIGUOS

	    cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)

       CASE nOpcion == 3 // A¥OS ANTERIORES

	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)

       ENDCASE
*>>>>FIN SELECCION DEL A¥O ANTERIOR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatAnt,;
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

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'CONSIGNACIONES ALUMNOS '+;
				   IF(lNuevos,'NUEVOS ','ANTIGUOS '),22,'°')
       nNroCol := 1

       cMsgTxt := cRegPrint({'CODIGO',;
			     'VALOR',;
			     'INI',;
			     'FIN',;
			     'F.OPO',;
			     'F.EXT'},;
			     {06,10,04,04,10,10},@aNroCol)
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
			 IF !lLeeCodNiv(nNroFil,aNroCol[3],@cCodigoTni,;
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
**********FIN ANALISIS DEL GRUPO

**********LECTURA DETALLES DEL RECIBO
	   nValor := 0
	   @ nNroFil,aNroCol[2] GET nValor PICT '9999999'

	   nMesIni := 0
	   @ nNroFil,aNroCol[3] GET nMesIni PICT '99';
			   VALID lnValMes(ROW(),COL()-2,@nMesIni)

	   nMesFin := 0
	   @ nNroFil,aNroCol[4] GET nMesFin PICT '99';
			   VALID lnValMes(ROW(),COL()-2,@nMesFin)


	   dFecOpo := DATE()
	   @ nNroFil,aNroCol[5] GET dFecOpo PICT '@!D';
				VALID !EMPTY(dFecOpo);
	   WHEN  {||HelpRead('Digite las Fechas en el Formato: MM/DD/AAAA')}

	   dFecExt := dFecOpo
	   @ nNroFil,aNroCol[6] GET dFecExt PICT '@!D';
				VALID !EMPTY(dFecExt);
	   WHEN  {||HelpRead('Digite las Fechas en el Formato: MM/DD/AAAA')}

	   READ

	   lHayErr := .T.
	   DO CASE
	   CASE nMesIni == 0 .OR. nMesFin == 0 .OR. nValor == 0
		cError('NO SE IMPRIME EL RECIBO')

	   CASE nMesIni == 1
		cError('Enero Pendiente')

	   CASE nMesFin == 12
		cError('Diciembre Pendiente')

	   OTHERWISE
		lHayErr :=.F.
	   ENDCASE
	   IF lHayErr
	      RESTSCREEN(22,00,22,79,cSavLin)
	      LOOP
	   ENDIF
**********FIN LECTURA DETALLES DEL RECIBO

**********VALIDACION DE LA LECTURAS
	   lHayErr := .T.
	   DO CASE
	   CASE nMesIni == 0 .OR. nMesFin == 0 .OR. nValor == 0
		cError('NO SE IMPRIME EL RECIBO')

	   CASE nMesIni == 1
		cError('Enero Pendiente')

	   CASE nMesFin == 12
		cError('Diciembre Pendiente')

	   OTHERWISE
		lHayErr :=.F.
	   ENDCASE
	   IF lHayErr
	      LOOP
	   ENDIF
**********FIN VALIDACION DE LA LECTURAS

**********INCREMENTO DE LAS FILAS
	    RESTSCREEN(22,00,22,79,cSavLin)
	    nNroFil++
	    IF nNroFil > 19

*--------------ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'CONSIGNACIONES ALUMNOS '+;
				   IF(lNuevos,'NUEVOS ','ANTIGUOS '),22,'°')

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
*>>>>FIN IMPRESION DE LAS CONSIGNACIONES


