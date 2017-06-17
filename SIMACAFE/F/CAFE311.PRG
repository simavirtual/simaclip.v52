/*SIMA - SISTEMA DE CAFETERIA

MODULO      : INFORMES
SUBMODULO...: ETIQUETAS - POR GRUPOS                   MODULO No. 311

**************************************************************************
* TITULO..: IMPRESION DE ETIQUETAS POR GRUPOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 24/2002 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 AM   JUN 24/2002 LUN

OBJETIVOS:

1- Imprime las etiquetas por grupos para anexar a los carnets

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_311(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL cNalias := ''                  // Nombre del Alias
       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
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
       IF nTipPer == 1
	  cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePer,'PER',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCaf,'CAF',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FCaFAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTip+cAnoUsr+ExtFile,'TIP',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileBol,'BOL',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseGru(lShared,cIntUno,cMaeAct,cAnoUsr) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE CAF->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL SISTEMA')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTE PROFESORES GRABADOS')

       CASE PER->(RECCOUNT()) == 0
	    cError('EL PERSONAL ACTUAL NO HAN SIDO GRABADOS')

       CASE TIP->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS TIPOS DE PERSONAL GRABADOS')

       CASE BOL->(RECCOUNT()) == 0
	    cError('NO EXISTEN BOLETAS EMITIDAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
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

*>>>>FILTRACION DEL ARCHIVO
       IF nTipPer == 4
	  Termometro(0,'LOCALIZANDO BOLETAS POR IMPRIMIR')
	  Termometro(25)
	  SELECT BOL
	  SET FILTER TO .NOT. BOL->lImpPrnBol
	  Termometro(50)
	  GO TOP
	  IF EOF()
	     SET FILTER TO
	  ENDIF
	  Termometro(100)
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF nTipPer == 1
	  IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ELSE
	  nRegIni := 1
	  nRegFin := 1
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF nTipPer == 1
	  IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ELSE
	  nNroIni := 1
	  nNroFin := 1
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAF->cOpcPrnCaF,.F.)
       IF EMPTY(nOpcPrn)
*      IF !Printer_on(CAF->lPrnArcCaF)
	   CloseAll()
	   RETURN NIL
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ANALISIS DE DECISION
       DO CASE
       CASE nTipPer == 1
	    cNalias := 'CLI'

       CASE nTipPer == 2
	    cNalias := 'PRO'

       CASE nTipPer == 3
	    cNalias := 'PER'

       CASE nTipPer == 4
	    cNalias := 'BOL'
       ENDCASE
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE CARNETS PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cIntDos+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO EL ARCHIVO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE nTipPer == 1 .AND. CLI->(RECCOUNT()) == 0
		 cError('PARA IMPRIMIR CARNETS POR GRUPOS '+;
			'DEBEN ESTAR CREADOS LOS CLIENTES DE LA CARTERA')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT &cNalias
	    IF nTipPer # 4
	       GO nNroIni
	    ENDIF
	    DO WHILE .NOT. EOF()

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SELECT &cNalias
		 IF nTipPer == 1
		    LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+;
				 cGruFin+'ºNo. '+CLI->(STR(RECNO(),2))+'/'+;
				 CLI->(STR(RECCOUNT(),2)),cNomSis)
		 ELSE
		    LineaEstado('No. '+STR(RECNO(),4)+'/'+;
				 STR(RECCOUNT(),4),cNomSis)
		 ENDIF
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------VALIDACION DE LA BOLETA IMPRESA
		 IF nTipPer == 4 .AND. BOL->lImpPrnBol
		    SELECT &cNalias
		    DBSKIP()
		    LOOP
		 ENDIF
*--------------FIN VALIDACION DE LA BOLETA IMPRESA

*--------------ANALISIS PARA LA SALIDA
		 IF nNroFin <> 0
		    IF CLI->(RECNO()) > nNroFin
		       VerPrn(nOpcPrn,FilePrn)
		       CloseDbf('CLI',FileCli,nModCry)
		       CloseAll(aUseDbf)
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA DEL MODULO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF nTipPer == 1
		    IF CLI->lRetGruCli
		       SELECT CLI
		       CLI->(DBSKIP())
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF nTipPer == 1
		    IF lSekCodigo(CLI->cCodigoEst,cMaeAct)
		       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				     RTRIM(&cMaeAct->cNombreEst)
		    ELSE
		       SELECT CLI
		       CLI->(DBSKIP())
		       LOOP
		    ENDIF
		    cNombreTes := SUBS(cNombreTes+SPACE(32),1,32)
		 ENDIF
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF nTipPer == 1
		    IF &cMaeAct->lRetiroEst
		       SELECT CLI
		       CLI->(DBSKIP())
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------LOCALIZACION DE LOS CONCEPTOS
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
*--------------FIN LOCALIZACION DE LOS CONCEPTOS

*--------------IMPRESION DE LA ETIQUETA
*		 nPrinter_On(cNomUsr,@FilePrn,STR(nOpcPrn,1),.F.)
		 SET DEVICE TO PRINT

		 DO CASE
		 CASE nTipPer == 1
		      cConRut := ''
		      cConCaf := ''
		      cCodigoTes := '1'+CLI->cCodigoEst+'000000'

		 CASE nTipPer == 2
		      cConRut := ''
		      cConCaf := ''
		      cCodigoTes := '2'+PRO->cCodigoPro+'000000'

		 CASE nTipPer == 3
		      cConRut := ''
		      cConCaf := ''
		      cCodigoTes := PER->cCodigoPer+'000000'

		 CASE nTipPer == 4
		      cConCaf := 'BOLETA'
		      cConRut := ''
		      cCodigoTes := BOL->cCodigoBol+'000000'
		      IF lLocCodigo('cCodigoTip','TIP',SUBS(cCodigoTes,1,1))
			 cConCaf := ALLTRIM(TIP->cNombreTip)
		      ENDIF

		 ENDCASE
		 Etiqueta(cCodigoTes,cConCaf,cConRut)
		 SET DEVICE TO SCREEN
*--------------FIN IMPRESION DE LA ETIQUETA

*--------------REGISTRO DE LA BOLETA IMPRESA
		 IF nTipPer == 4

		    IF BOL->(lRegLock(lShared,.F.))
		       REPL BOL->lImpPrnBol WITH .T.
		       BOL->(DBCOMMIT())
		       IF lShared
			  BOL->(DBUNLOCK())
		       ENDIF
		    ENDIF

		 ENDIF
*--------------FIN REGISTRO DE LA BOLETA IMPRESA

	       SELECT &cNalias
	       DBSKIP()

	    ENDDO
	    nNroIni := 1
**********FIN IMPRESION DEL CUERPO DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    CloseDbf('CLI',FileCli,nModCry)
	    SELECT GRU
	    GRU->(DBSKIP())

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE CARNETS PARA CADA GRUPO