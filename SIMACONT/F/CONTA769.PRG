/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : <UTILIDADES><CONFIGURACION>
SUBMODULO...: <PRUEBAS TECNICAS>

**************************************************************************
* TITULO..: PRUEBAS TECNICAS                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/2008 VIE A
       Colombia, Bucaramanga        INICIO: 08:45 PM   NOV 14/2008 VIE

OBJETIVOS:

1- Permite corre pruebas t‚cnicas al sistemas

2- Es una opci¢n temporal no destinada a los usuarios del sistema.

3- Su uso es exclusivo para hacer pruebas en desarrollo.

2- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_769(aP1,aP2,aP3,cSavPan)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales
       cSavPan                        // Salvar Pantalla */
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cHayErr := ''                  // Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL   i,j,k := 0                   // Contador
       LOCAL nNroPer := 0                   // N£mero del Periodo

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL cCodJui := ''                  // C¢digo del juicio

       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       RESTSCREEN(0,0,24,79,cSavPan)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+cAnoSis+ExtFile,'JUI',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxInd+cMaeAct+cAnoSis+cExtNtx,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSel+cMaeAct+ExtFile,'SEL',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxSel+cMaeAct+cExtNtx,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE TCO->nTotPerTbl == 0
	    cError('NO SE HA DEFINIDO EL TOTAL DE PERIODOS')

       CASE TCO->nTotPerTbl > 5
	    cError('EL TOTAL DE PERIODOS NO PUEDE SER MAYOR A CINCO(5)')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lIndNiv := TCO->lIndNivTbl
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTO(nRegIni))
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+'NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)

	      CloseAll()
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO POR NOTAS
	    DetAreas(@aNotAre,@aNotMat,TCO->nTotPerTbl)

	    SELECT NOT
	    NOT->(DBGOTOP())
	    DO WHILE .NOT. NOT->(EOF())

*==============ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*==============BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*==============FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*==============REEMPLAZO DE LAS ASIGNATURAS VARIABLES
		 IF SEL->(RECCOUNT()) # 0
		    lDetAreEst(@aNotAre,@aNotMat,nNroPer,NOT->cCodigoEst)
		 ENDIF
*==============FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

*==============RECORRIDO POR AREAS
		 FOR i := 1 TO LEN(aNotAre)

*--------------------LINEA DE ESTADO
		       LineaEstado('ºGRUPO:'+GRU->cCodigoGru+;
				   'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
					   NOT->(STR(RECCOUNT(),2))+;
				   'ºCODIGO:'+NOT->cCodigoEst+;
				   'ºAREA:'+SUBS(aNotAre[i,6],9,4),cNomSis)
*--------------------FIN LINEA DE ESTADO

*--------------------AREAS NO PROMEDIABLES
		       IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*:::::::::::::::::::::::::RECORRIDO DE ITEMS DE EVALUACION
			    cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
			    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

			    FOR k := 1 TO LEN(aJuicio)

*...............................LECTURA DEL INDICADOR
				  cCodJui := aJuicio[k]
				  cCodLog := SUBS(cCodJui,1,4)
				  IF EMPTY(cCodJui)
				     LOOP
				  ENDIF
*...............................FIN LECTURA DEL INDICADOR

*...............................LOCALIZACION CLASE DE INDICADOR
				  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				  cCodigoTma := SUBS(aNotAre[i,6],9,4)

				  cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
				  IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
						'DE LA CLASE')

				     IF EMPTY(CLA->cCodigoMat)
					cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
					cCodigoTma := SUBS(aNotAre[i,6],9,4)
				     ELSE
					cCodigoTni := SPACE(02)
					cCodigoTma := CLA->cCodigoMat
				     ENDIF
				   *ÀAsignaci¢n del nivel para usar indicador nivel o materia

				  ENDIF
*...............................FIN LOCALIZACION CLASE DE INDICADOR

*...............................BUSQUEDA DEL ITEM DE EVALUACION
				  cCodigoTju := IF(lIndNiv,;
						   cCodigoTni+cCodigoTma+cCodLog,;
						   cCodigoTma+cCodLog)

				  IF lSekCodigo(cCodigoTju,'JUI')

				     IF EMPTY(JUI->cCodLogJui)

					SELECT JUI
					IF JUI->(lRegLock(lShared,.F.))
					   REPL JUI->cCodLogJui WITH '00000000'
					   JUI->(DBCOMMIT())
					ELSE
					   cError('NO SE GRABA EL REGISTRO')
					ENDIF
					IF lShared
					   JUI->(DBUNLOCK())
					ENDIF

				     ENDIF

				  ENDIF
*...............................FIN BUSQUEDA DEL ITEM DE EVALUACION

			    ENDFOR
*:::::::::::::::::::::::::FIN RECORRIDO DE ITEMS DE EVALUACION

		       ENDIF
*--------------------FIN AREAS NO PROMEDIABLES

*--------------------RECORRIDO POR MATERIAS PROMEDIABLES
		       FOR j := 1 TO LEN(aNotMat)

*:::::::::::::::::::::::::MATERIA O AREA PROMEDIABLE
			    IF aNotAre[i,2] == aNotMat[j,1]

*..............................RECORRIDO DE ITEMS DE EVALUACION
				 cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
				 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

				 FOR k := 1 TO LEN(aJuicio)

*                                    LECTURA DEL INDICADOR
				       cCodJui    := aJuicio[k]
				       cCodLog    := SUBS(cCodJui,1,4)
				       IF EMPTY(cCodJui)
					  LOOP
				       ENDIF
*                                    FIN LECTURA DEL INDICADOR

*                                    LOCALIZACION CLASE DE INDICADOR
				       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				       cCodigoTma := SUBS(aNotMat[j,11],3,4)

				       cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
				       IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
						     'DE LA CLASE')

					  IF EMPTY(CLA->cCodigoMat)
					     IF EMPTY(SUBS(aNotMat[j,11],1,2))
						cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
					       *Por nivel
					     ELSE
						cCodigoTni := SUBS(aNotMat[j,11],1,2)
					       *Por Niveles
					     ENDIF
					  ELSE
					     cCodigoTni := SPACE(02)
					     cCodigoTma := CLA->cCodigoMat
					  ENDIF
					*ÀAsignaci¢n del nivel para usar indicador nivel o materia

				       ENDIF
*                                    FIN LOCALIZACION CLASE DE INDICADOR

*                                    BUSQUEDA DEL ITEM DE EVALUACION
				       cCodigoTju := IF(lIndNiv,;
							cCodigoTni+cCodigoTma+cCodLog,;
							cCodigoTma+cCodLog)

				       IF lSekCodigo(cCodigoTju,'JUI')

					  IF EMPTY(JUI->cCodLogJui)

					     SELECT JUI
					     IF JUI->(lRegLock(lShared,.F.))
						REPL JUI->cCodLogJui WITH '00000000'
						JUI->(DBCOMMIT())
					     ELSE
						cError('NO SE GRABA EL REGISTRO')
					     ENDIF
					     IF lShared
						JUI->(DBUNLOCK())
					     ENDIF

					  ENDIF

				       ENDIF
*                                    FIN BUSQUEDA DEL ITEM DE EVALUACION



				 ENDFOR
*..............................FIN RECORRIDO DE ITEMS DE EVALUACION


			    ENDIF
*:::::::::::::::::::::::::FIN MATERIA O AREA PROMEDIABLE

		       ENDFOR
*--------------------FIN RECORRIDO POR MATERIAS PROMEDIABLES

		 ENDFOR
*==============FIN RECORRIDO POR AREAS

	       NOT->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR NOTAS

	  GRU->(DBSKIP())

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: CASOS ESPECIALES DE JUICIOS VALORATIVOS.                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/2008 VIE A
       Colombia, Bucaramanga        INICIO: 08:45 PM   NOV 14/2008 VIE

OBJETIVOS:

1- Relaciona los casos especiales de juicios valorativos. Ej:IIIE

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cHayErr := ''                  // Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL   i,j,k := 0                   // Contador
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL cJuiVal := ''                  // Juicios Valorativos
       LOCAL lJuiVal := .F.                 // Juicios Valorativos iguales

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n

       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'ERR'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL lRetiroTes := .F.              // Retiro del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       RESTSCREEN(0,0,24,79,cSavPan)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>LECTURA JUICIOS VALORATIVOS
       cJuiVal := SPACE(05)
       @ nFilInf+1,nColInf SAY 'JUICIOS:';
			   GET cJuiVal PICT '@!AAAAA'
       READ
       IF EMPTY(cJuiVal)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA JUICIOS VALORATIVOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE TCO->nTotPerTbl == 0
	    cError('NO SE HA DEFINIDO EL TOTAL DE PERIODOS')

       CASE TCO->nTotPerTbl > 5
	    cError('EL TOTAL DE PERIODOS NO PUEDE SER MAYOR A CINCO(5)')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CREACION DEL LOG DEL SISTEMA
       FileLog := cFileTempo(cPatSis+'\'+PathLog+'\',;
			     'E'+cMaeAct+STR(nNroPer,1,0),ExtFile,.F.)
       CreaConLog(lShared,nModCry,cPatSis+'\'+PathLog,FileLog)

       IF !lUseDbf(.T.,cPatSis+'\'+PathLog+'\'+FileLog,cAliasL,NIL,lShared)
	  cError('ABRIENDO ARCHIVO DEL LOG')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL LOG DEL SISTEMA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDO POR GRUPOS
       lRecNot := TCO->lRecNotTbl
       SELECT GRU
       GRU->(DBGOTO(nRegIni))
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+'NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)

	      CloseAll()
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO POR NOTAS
	    DetAreas(@aNotAre,@aNotMat,TCO->nTotPerTbl)

	    SELECT NOT
	    NOT->(DBGOTOP())
	    DO WHILE .NOT. NOT->(EOF())

*==============LINEA DE ESTADO
		 LineaEstado('JUICIOS VALORATIVOS:'+cJuiVal+;
			     'ºGRUPO:'+GRU->cCodigoGru+;
			     'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
				     NOT->(STR(RECCOUNT(),2))+;
			     'ºCODIGO:'+NOT->cCodigoEst,cNomSis)
*==============FIN LINEA DE ESTADO

*==============ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*==============BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*==============FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*==============ANALISIS DEL PERIODO DEL RETIRO
		 lRetiroTes := &cMaeAct->lRetiroEst
		 IF lRetiroTes
		    IF nNroPer <= &cMaeAct->nPerRetEst
		       lRetiroTes := .F.
		    ENDIF
		 ENDIF
*==============FIN ANALISIS DEL PERIODO DEL RETIRO

*==============RECORRIDO POR AREAS
		 FOR i := 1 TO LEN(aNotAre)

*--------------------AREAS NO PROMEDIABLES
		       IF SUBS(aNotAre[i][4],7,4) == 'AREN'

			  cCodigoTma := aNotAre[i,2]+'00'

			  cCamNotDef := aNotAre[i,4]
			  cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

			  lJuiVal := .T.
			  FOR k := 1 TO nNroPer

*                             NOTA DEL AREA
				cNotDef := ALLTRIM(SUBS(&cCamNotDef,k*4-3,4))
				cNotRec := ALLTRIM(SUBS(&cCamNotRec,k*4-3,4))
				IF VAL(cNotDef) > 0
				   cNotDef := cNotDefJvf(VAL(cNotDef))
				ENDIF
				IF VAL(cNotRec) > 0
				   cNotRec := cNotDefJvf(VAL(cNotRec))
				ENDIF

				IF lRecNot .AND. !EMPTY(cNotRec)
				   cNotDef := cNotRec
				ENDIF
*                             FIN NOTA DEL AREA

*                             ANALISIS DE LOS JUICIOS
				IF EMPTY(cNotDef) .OR.;
				   SUBS(cJuiVal,k,1) # cNotDef
				   lJuiVal := .F.
				   EXIT
				ENDIF
*                             FIN ANALISIS DE LOS JUICIOS

			  ENDFOR

*                         ANALISIS DEL ERROR
			    IF lJuiVal

			       cHayErr := 'CASO ESPECIAL'
			       cHayErr := ALLTRIM(aNotAre[i,10])+':'+&cCamNotDef
			       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

			       aHayErr := {}
			       AADD(aHayErr,{'cCodEst',NOT->cCodigoEst})         // C¢digo del Estudiante
			       AADD(aHayErr,{'cCodGru',GRU->cCodigoGru})         // C¢digo del Grupo
			       AADD(aHayErr,{'cNroLis',NOT->(STR(RECNO(),2))})   // Numero de lista
			       AADD(aHayErr,{'cCodMat',cCodigoTma})              // C¢digo de la materia
			       AADD(aHayErr,{'cNotDef',cNotDef})                 // Nota
			       AADD(aHayErr,{'cHayErr',cHayErr})                 // Detalle del Error
			     *ÀHay Error

			       AADD(aTotErr,aHayErr)

			    ENDIF
*                         FIN ANALISIS DEL ERROR

		       ENDIF
*--------------------FIN AREAS NO PROMEDIABLES

*--------------------RECORRIDO POR MATERIAS
		       FOR j := 1 TO LEN(aNotMat)

*:::::::::::::::::::::::::ANALISIS DEL JUICIO VALORATIVO
			    IF aNotAre[i,2] == aNotMat[j,1]

*..............................ANALISIS DE LA MATERIA
				 cCodigoTma := SUBS(aNotMat[j,11],3,4)
*..............................FIN ANALISIS DE LA MATERIA

*..............................ANALISIS DE LAS MATERIAS PROMEDIABLES
				 cCamNotDef := aNotMat[j,4]
				 cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

				 lJuiVal := .T.
				 FOR k := 1 TO nNroPer

*                                    NOTA DE LA MATERIA
				       cNotDef := ALLTRIM(SUBS(&cCamNotDef,k*4-3,4))
				       cNotRec := ALLTRIM(SUBS(&cCamNotRec,k*4-3,4))
				       IF VAL(cNotDef) > 0
					  cNotDef := cNotDefJvf(VAL(cNotDef))
				       ENDIF
				       IF VAL(cNotRec) > 0
					  cNotRec := cNotDefJvf(VAL(cNotRec))
				       ENDIF

				       IF lRecNot .AND. !EMPTY(cNotRec)
					  cNotDef := cNotRec
				       ENDIF
*                                    FIN NOTA DE LA MATERIA

*                                    ANALISIS DE LOS JUICIOS
				       IF EMPTY(cNotDef) .OR.;
					  SUBS(cJuiVal,k,1) # cNotDef
					  lJuiVal := .F.
					  EXIT
				       ENDIF
*                                    FIN ANALISIS DE LOS JUICIOS

				 ENDFOR
*..............................FIN ANALISIS DE LAS MATERIAS PROMEDIABLES

*..............................ANALISIS DEL ERROR
				 IF lJuiVal

				    cHayErr := ALLTRIM(aNotMat[j,10])+':'+&cCamNotDef
				    cHayErr := SUBS(cHayErr+SPACE(80),1,80)

				    aHayErr := {}
				    AADD(aHayErr,{'cCodEst',NOT->cCodigoEst})         // C¢digo del Estudiante
				    AADD(aHayErr,{'cCodGru',GRU->cCodigoGru})         // C¢digo del Grupo
				    AADD(aHayErr,{'cNroLis',NOT->(STR(RECNO(),2))})   // Numero de lista
				    AADD(aHayErr,{'cCodMat',cCodigoTma})              // C¢digo de la materia
				    AADD(aHayErr,{'cNotDef',cNotDef})                 // Nota
				    AADD(aHayErr,{'cHayErr',cHayErr})                 // Detalle del Error
				  *ÀHay Error

				    AADD(aTotErr,aHayErr)

				 ENDIF
*..............................FIN ANALISIS DEL ERROR

			    ENDIF
*:::::::::::::::::::::::::FIN ANALISIS DEL JUICIO VALORATIVO

		       ENDFOR
*--------------------FIN RECORRIDO POR MATERIAS

		 ENDFOR
*==============FIN RECORRIDO POR AREAS

*==============ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF lRetiroTes
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

	       NOT->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR NOTAS

**********REGISTRO DEL LOG
	    FOR i := 1 TO LEN(aTotErr)

		aHayErr := aTotErr[i]

		AADD(aCamLog,{'cCodigoEst',xPrm(aHayErr,'cCodEst')})
		AADD(aCamLog,{'cCodigoGru',xPrm(aHayErr,'cCodGru')})
		AADD(aCamLog,{'nNroRegEst',VAL(xPrm(aHayErr,'cNroLis'))})
		AADD(aCamLog,{'cMatNotLog',xPrm(aHayErr,'cCodMat')})
		AADD(aCamLog,{'cObservLog',xPrm(aHayErr,'cHayErr')})
	      *ÀCampos del Log

		aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDFOR
	    aTotErr := {}
**********FIN REGISTRO DEL LOG

	  GRU->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>CONSULTA DEL LOG
       SELECT &cAliasL
       BROWSE()

       CloseAll()
       RETURN NIL
*>>>>FIN CONSULTA DEL LOG

*/



/*************************************************************************
* TITULO..: VALIDACION CODIGOS DE PROMOCION                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/2008 VIE A
       Colombia, Bucaramanga        INICIO: 08:45 PM   NOV 14/2008 VIE

OBJETIVOS:

1- Permite corre pruebas t‚cnicas al sistemas

2- Es una opci¢n temporal no destinada a los usuarios del sistema.

3- Su uso es exclusivo para hacer pruebas en desarrollo.

2- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cHayErr := ''                  // Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL       i := 0                   // Contador
       LOCAL nNroPer := 0                   // N£mero del Periodo

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'ERR'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log

       LOCAL lRetiroTes := .F.              // Retiro del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       RESTSCREEN(0,0,24,79,cSavPan)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct

       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CREACION DEL LOG DEL SISTEMA
       FileLog := cFileTempo(cPatSis+'\'+PathLog+'\',;
			     'E'+cMaeAct+STR(nNroPer,1,0),ExtFile,.F.)
       CreaConLog(lShared,nModCry,cPatSis+'\'+PathLog,FileLog)

       IF !lUseDbf(.T.,cPatSis+'\'+PathLog+'\'+FileLog,cAliasL,NIL,lShared)
	  cError('ABRIENDO ARCHIVO DEL LOG')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL LOG DEL SISTEMA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTO(nRegIni))
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    PathTem := '\simacole\colsalle\simacont'

	    IF !lUseDbf(.T.,PathTem+'\'+cPatSis+'\'+cMaeAct+'\'+'NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared) .OR.;
	       !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+'NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'TEM',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)

	      CloseAll()
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO POR NOTAS
	    SELECT NOT
	    NOT->(DBGOTOP())
	    DO WHILE .NOT. NOT->(EOF())

*==============LINEA DE ESTADO
		 LineaEstado('VALIDACION CODIGOS DE PROMOCION:'+;
			     'ºGRUPO:'+GRU->cCodigoGru+;
			     'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
				     NOT->(STR(RECCOUNT(),2))+;
			     'ºCODIGO:'+NOT->cCodigoEst,cNomSis)
*==============FIN LINEA DE ESTADO

*==============ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    NOT->(DBSKIP())
		    TEM->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*==============BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*==============FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*==============ANALISIS DEL PERIODO DEL RETIRO
		 lRetiroTes := &cMaeAct->lRetiroEst
		 IF lRetiroTes
		    IF nNroPer <= &cMaeAct->nPerRetEst
		       lRetiroTes := .F.
		    ENDIF
		 ENDIF
*==============FIN ANALISIS DEL PERIODO DEL RETIRO

*==============ANALISIS DE DECISION
		 IF NOT->cCodigoEst # TEM->cCodigoEst
		    wait 'CODIGOS DIFERENTES'
		    wait NOT->cCodigoEst
		    wait TEM->cCodigoEst
		    CloseAll()
		    RETURN NIL
		 ENDIF
*==============FIN ANALISIS DE DECISION

*===============ANALISIS DE EVALUACION
		  IF NOT->nAproboNot # NOT->nAproboNot

		     cHayErr := 'CODIGO DE PROMOCION DIFERENTE'
		     cHayErr := SUBS(cHayErr+SPACE(80),1,80)

		     aHayErr := {}
		     AADD(aHayErr,{'cCodEst',NOT->cCodigoEst})         // C¢digo del Estudiante
		     AADD(aHayErr,{'cCodGru',GRU->cCodigoGru})         // C¢digo del Grupo
		     AADD(aHayErr,{'cNroLis',NOT->(STR(RECNO(),2))})   // Numero de lista
		     AADD(aHayErr,{'cHayErr',cHayErr})                 // Detalle del Error
		   *ÀHay Error

		     AADD(aTotErr,aHayErr)

		  ENDIF
*===============FIN ANALISIS DE EVALUACION

*==============ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF lRetiroTes
		    SELECT NOT
		    NOT->(DBSKIP())
		    TEM->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

	       NOT->(DBSKIP())
	       TEM->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR NOTAS

**********REGISTRO DEL LOG
	    FOR i := 1 TO LEN(aTotErr)

		aHayErr := aTotErr[i]

		AADD(aCamLog,{'cCodigoEst',xPrm(aHayErr,'cCodEst')})
		AADD(aCamLog,{'cCodigoGru',xPrm(aHayErr,'cCodGru')})
		AADD(aCamLog,{'nNroRegEst',VAL(xPrm(aHayErr,'cNroLis'))})
		AADD(aCamLog,{'cMatNotLog',xPrm(aHayErr,'cCodMat')})
		AADD(aCamLog,{'cObservLog',xPrm(aHayErr,'cHayErr')})
	      *ÀCampos del Log

		aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDFOR
**********FIN REGISTRO DEL LOG

	  GRU->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>CONSULTA DEL LOG
       SELECT &cAliasL
       BROWSE()

       CloseAll()
       RETURN NIL
*>>>>FIN CONSULTA DEL LOG
*/
