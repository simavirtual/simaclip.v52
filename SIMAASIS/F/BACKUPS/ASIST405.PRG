/* SIMA - CONTROL DE ASISTENCIA

MODULO      : INFORMES
SUBMODULO...: AUSENCIAS ASIGNATURAS

**************************************************************************
* TITULO..: IMPRESION DE LAS AUSENCIAS POR ASIGNATURA                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 04/2007 MIE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   JUN 04/2007 MIE

OBJETIVOS:

1- Permite Imprimir los Estudiantes con novedades de asistencia por
   materia


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_405(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL     i,j := 0                   // Contador
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL nNroPer := 0                   // N£mero del bimestre
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL lPrnMat := .F.                 // Imprimir materia
       LOCAL PathNot := ''                  // Path del Archivo de Notas
       LOCAL FileNot := ''                  // Archivo de notas

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema

*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimAsi,'SAS',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+FileHra,'HRA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+FileHor,'HOR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+cMaeAct+'\'+;
			 fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FAsiAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+fTipAus,'TAU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+fCtrAsi,'ASI',NIL,lShared,nModCry})

*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SELECT &cMaeAct
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE HRA->(RECCOUNT()) == 0
	    cError('NO SE HA DEFINIDO LA DIVISION DE LAS HORAS')

       CASE SAS->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

       CASE TAU->(RECCOUNT()) == 0
	    cError('NO ESTAN CREADOS LOS TIPOS DE AUSENCIAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE HRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN NOVEDADES DE ASISTENCIA')

       CASE HOR->(RECCOUNT()) == 0
	    cError('NO SE HA DEFINIDO EL HORARIO DE LOS CURSOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,;
			     TCO->nTotPerTbl,TCO->nPerActTbl,.T.)
       IF nNroPer == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SAS->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')

       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA INICIAL:' GET dFecIni PICT '@D'
       @ nFilInf+2,nColInf SAY 'FECHA FINAL  :' GET dFecFin PICT '@D'
       READ

       IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALSIS DE DECISION
       cError('LAS AUSENCIAS QUE NO ESTEN EN EL INTERVALO SE BORRAN',;
	      cFecha(dFecIni,3)+ ' A '+cFecha(dFecFin,3) )
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALSIS DE DECISION

*>>>>RECORRIDO DE LOS REGISTROS
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    PathNot := cIntUno+'\'+cMaeAct+'\NOTAS\'
	    FileNot := 'NT'+GRU->cCodigoGru+cAnoSis+ExtFile
	    IF !lUseDbf(.T.,PathNot+FileNot,'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS')
	    ELSE
	       GraAusBol(lShared,cNomSis,cNomEmp,cAnoUsr,cMaeAlu,cMaeAct,;
			 nNroPer,dFecIni,dFecFin)
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

	  GRU->(DBSKIP())

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS REGISTROS

/*************************************************************************
* TITULO..: AUSENCIAS POR ASIGNATURA                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2007 LUN A
       Colombia, Bucaramanga        INICIO: 01:10 PM   JUN 05/2007 LUN

OBJETIVOS:

1- Permite grabar las ausencias en el boletin.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraAusBol(lShared,cNomSis,cNomEmp,cAnoUsr,cMaeAlu,cMaeAct,;
		   nNroPer,dFecIni,dFecFin)


*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       nNroPer                              // N£mero del periodo
       dFecIni                              // Fecha Inicial
       dFecFin                              // Fecha Final  */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aMatAus := {}                  // Materias del curso
       LOCAL nDiaSem := 0                   // D¡a de la semana
       LOCAL nTotAus := 0                   // Total de Ausencias
       LOCAL cTotAus := ''                  // Total Ausencias

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCamFalNot := ''               // Campo destino fallas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DEL HORARIO
       SELECT HOR
       HOR->(DBGOTOP())
       DO WHILE .NOT. HOR->(EOF())

**********MATERIAS DEL CURSO
	    IF GRU->cCodigoGru == HOR->cCodGruHor

*==============INICIALIZACION DE LA MATERIA
		 IF LEN(aMatAus) # 0
		    i := ASCAN(aMatAus,{|aMat|aMat[1] == HOR->cCodMatHor})
		    IF i == 0
		       AADD(aMatAus,{HOR->cCodMatHor,0})
		    ENDIF
		 ELSE
		    AADD(aMatAus,{HOR->cCodMatHor,0})
		 ENDIF
*==============FIN INICIALIZACION DE LA MATERIA

	    ENDIF
**********FIN MATERIAS DEL CURSO

	  HOR->(DBSKIP())

       ENDDO
       IF LEN(aMatAus) == 0
	  cError('NO SE HA GRABADO EL HORARIO DEL GRUPO:'+GRU->cCodigoGru)
	  RETURN NIL
       ENDIF
*>>>>FIN RECORRIDO DEL HORARIO

*>>>>RECORRIDO POR ALUMNOS
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('CODIGO:'+NOT->cCodigoEst+;
			'ºNo.:'+ALLTRIM(STR(NOT->(RECNO()),2))+'/'+;
				ALLTRIM(STR(NOT->(RECCOUNT()),2))+;
			'ºGRUPO: '+GRU->cCodigoGru+;
			'ºFECHA: '+cFecha(dFecIni,3)+' A '+;
				   cFecha(dFecFin),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********INICIALIZACION DE LAS AUSENCIAS
	    FOR i := 1 TO LEN(aMatAus)
		aMatAus[i,2] := 0
	    ENDFOR
**********FIN INICIALIZACION DE LAS AUSENCIAS

**********FILTRACION DEL ARCHIVO
	    cCodigoTes := NOT->cCodigoEst

	    SELECT ASI
	    SET FILTER TO ASI->cCodigoEst == cCodigoTes .AND.;
			  dFecIni <= ASI->dFecAsiCtr    .AND.;
			  dFecFin >= ASI->dFecAsiCtr

	    ASI->(DBGOTOP())
	    IF ASI->(EOF())

	       GraAusNot(lShared,aMatAus,nNroPer)
	     *ÀBorrado de las ausencias
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO

**********RECORRIDO POR CONTROL DE ASISTENCIA
	    SELECT ASI
	    ASI->(DBGOTOP())
	    DO WHILE .NOT. ASI->(EOF())

*==============ANALISIS DE DECISION
		 IF ASI->cCodigoTau # ANO->cCodTauAsA
		    ASI->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS DE DECISION

*==============FILTRACION DEL ARCHIVO
		 nDiaSem := DOW(ASI->dFecAsiCtr)
		 SELECT HOR
		 SET FILTER TO HOR->nDiaSemHor == nDiaSem .AND.;
			       HOR->cCodGruHor == GRU->cCodigoGru

		 HOR->(DBGOTOP())

		 IF HOR->(EOF())
		    SELECT HOR
		    SET FILTER TO
		    ASI->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN FILTRACION DEL ARCHIVO

*==============SUMA DE LA AUSENCIA TOTAL DEL DIA
		 IF ASI->cCodigoHra == ANO->cCodHraAsA
		    HOR->(DBGOTOP())
		    DO WHILE .NOT. HOR->(EOF())
		       i := ASCAN(aMatAus,{|aMat|aMat[1] == HOR->cCodMatHor})
		       IF i # 0
			  aMatAus[i,2]++
		       ENDIF
		       HOR->(DBSKIP())
		    ENDDO
		 ENDIF
*==============FIN SUMA DE LA AUSENCIA TOTAL DEL DIA

*==============SUMA DE LA AUSENCIA POR HORAS
		 IF ASI->cCodigoHra # ANO->cCodHraAsA
		    HOR->(DBGOTOP())
		    DO WHILE .NOT. HOR->(EOF())

		       IF ASI->cCodigoHra == HOR->cCodHraHor

			  i := ASCAN(aMatAus,{|aMat|aMat[1] == HOR->cCodMatHor})
			  IF i # 0
			     aMatAus[i,2]++
			     EXIT
			  ENDIF

		       ENDIF
		       HOR->(DBSKIP())
		    ENDDO
		 ENDIF
		 SELECT HOR
		 SET FILTER TO
*==============FIN SUMA DE LA AUSENCIA POR HORAS

	       ASI->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR CONTROL DE ASISTENCIA

**********GRABACION DE LAS AUSENCIAS
	    GraAusNot(lShared,aMatAus,nNroPer)
**********FIN GRABACION DE LAS AUSENCIAS

	  NOT->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>RECORRIDO POR ALUMNOS

/*************************************************************************
* TITULO..: GRABACION DE LAS AUSENCIAS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 24/2007 LUN A
       Colombia, Bucaramanga        INICIO: 05:30 PM   SEP 24/2007 LUN

OBJETIVOS:

1- Graba las ausencias de las asignaturas.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraAusNot(lShared,aMatAus,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // Archivos Compartidos
       aMatAus                              // Materias del curso
       nNroPer                              // Numero del periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nTotAus := 0                   // Total de Ausencias
       LOCAL cTotAus := ''                  // Total Ausencias

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCamFalNot := ''               // Campo destino fallas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DE LAS AUSENCIAS
       SELECT NOT
       IF NOT->(lRegLock(lShared,.F.))

	  FOR i := 1 TO LEN(aMatAus)

	      nTotAus := aMatAus[i,2]
	      IF nTotAus > 0
		 cTotAus := STR(nTotAus,2)
	      ELSE
		 cTotAus := SPACE(02)
	      ENDIF

	      cCodigoTma := aMatAus[i,1]
	      cCamFalNot := 'NOT->cFa'+cCodigoTma+'Not'

	      REPL &cCamFalNot WITH;
		   STUFF(&cCamFalNot,nNroPer*2-1,2,cTotAus)
	      NOT->(DBCOMMIT())

	  ENDFOR

       ELSE
	  cError('NO SE PUEDE GRABAR LAS NOTAS')
       ENDIF

       IF lShared
	  NOT->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LAS AUSENCIAS
