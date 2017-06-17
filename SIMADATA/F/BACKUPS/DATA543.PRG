/* SIMA - CENTRAL DE RIESGOS

MODULO      : UTILIDADES
SUBMODULO...: MANTENIMIENTO - RESTAURAR

**************************************************************************
* TITULO..: RESTAURAR NOVEDADES                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2009 JUE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   SEP 03/2009 JUE

OBJETIVOS:

1- Permite restaurar el reporte actual y cual consiste en dejar en blanco
   el campo de la novedad en el archivo de pagos, la diferencia es que lo
   hace en todos los registros, sin importar la novedad confirmada.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_543(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
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
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual

       LOCAL       i := 0                   // Contador
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FDatAno+cAnoUsr+ExtFile,'ANO',;
			 NIL,lShared,nModCry})
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
       CASE SDA->(RECCOUNT()) == 0
	    cError('NO SE EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SDA->nMesRepDat)
	    cError('NO FIGURA EL MES DEL ULTIMO REPORTE')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DEL ARCHIVO
       nMesIni := SDA->nMesRepDat
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni,.T.)

       IF !FILE(cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)+'\'+;
		FileRep+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile)

	  cError('NO EXISTE EL ARCHIVO DE '+cMes(nMesIni)+;
		 ' DEL REPORTE')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>VALIDACION DEL MES DEL REPORTE
       lHayErr := .T.
       DO CASE
       CASE SUBS(ANO->cValRepDaA,nMesIni,1) # '1'
	    cError('EL REPORTE DE '+cMes(VAL(cMesIni))+' '+;
		   'FIGURA COMO CONFIRMADO')

       CASE LEN(RTRIM(ANO->cValRepDaA)) # nMesIni
	    cError('NO SE PUEDE RESTUARAR UN MES'+' '+;
		   'ANTERIOR AL ULTIMO REPORTADO')

       CASE VAL(SUBS(ANO->cValRepDaA,nMesIni,1)) # 1
	    cError('EL ARCHIVO DEL REPORTE DE '+cMes(nMesIni)+' '+;
		   'NO HA SIDO RESTAURADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       IF !lPregunta('DESEA RESTAURAR EL MES DE '+cMes(nMesIni)+'? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL MES DEL REPORTE

*>>>>ANALISIS PARA CADA NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	     IF !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)
		cError('ABRIENDO ARCHIVOS.'+cMaeAct)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTE GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     GRU->(DBGOTOP())
	     DO WHILE .NOT. GRU->(EOF())

*===============PREPARACION DE LAS VARIABLES DE ARCHIVO
		  FileCli := PathDos+'\'+cPatSis+'\'+;
			     'CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

		  FilePag := PathDos+'\'+cPatSis+'\'+;
			     'PAGOS\PA'+GRU->cCodigoGru+cAnoSis+ExtFile
*===============FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*===============SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		     cError('ABRIENDO DE CLIENTES Y PAGOS')
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*===============FIN SELECION DE LAS AREAS DE TRABAJO

*===============RECORRIDO POR GRUPO
		  SELECT CLI
		  CLI->(DBGOTOP())
		  DO WHILE .NOT. CLI->(EOF())

*--------------------LINEA DE ESTADO
		       LineaEstado('NIVEL: '+cMaeAct+;
				   'ºGRUPO: '+GRU->cCodigoGru+;
				   'ºNo. '+STR(CLI->(RECNO()),4)+'/'+;
					   STR(CLI->(RECCOUNT()),4),cNomSis)
*--------------------FIN LINEA DE ESTADO

*--------------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		       IF CLI->lRetgruCli
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------------LOCALIZACION DEL PAGO
		       IF !lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN LOCALIZACION DEL PAGO

*--------------------RESTAURAR NOVEDAD
		       IF PAG->(lRegLock(lShared,.F.))

			  REPL PAG->cNovAntPag WITH PAG->cNovRepPag
			  REPL PAG->dRepAntPag WITH PAG->dFecRepPag

			  REPL PAG->cNovRepPag WITH ''
			  REPL PAG->dFecRepPag WITH CTOD('00/00/00')

			  PAG->(DBCOMMIT())

		       ELSE
			  cError('NO SE GRABO EL REGISTRO EN PAGOS')
		       ENDIF

		       IF lShared
			  PAG->(DBUNLOCK())
		       ENDIF
*--------------------FIN RESTAURAR NOVEDAD

		     CLI->(DBSKIP())

		  ENDDO
		  CloseDbf('CLI')
		  CloseDbf('PAG')
*===============FIN RECORRIDO POR GRUPO

		GRU->(DBSKIP())

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

       ENDFOR
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN ANALISIS PARA CADA NIVEL

