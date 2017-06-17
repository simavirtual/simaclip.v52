/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: CALCULOS - POR PROFESOR

**************************************************************************
* TITULO..: CALCULOS POR PROFESOR                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 18/2008 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 18/2008 VIE

OBJETIVOS:

1- Realiza los calculos de acuerdo al n£mero del m‚todo.

2- El c lculo por grupos puede afectar los c lculos relacionados con los
   dem s estudiantes que NO requieren recalculo y si pueden cambiar la nota
   actual Tener presente esta situaci¢n para resolverla

3- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_253(aP1,aP2,aP3)

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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores

       LOCAL nNroPer := 0                   // N£mero del periodo

       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LOP'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log

       LOCAL nIniPro := 0                   // Registro Inicial del Profesor
       LOCAL nFinPro := 0                   // Registro Final del Profesor

       LOCAL cPatPro := ''                  // Path del Profesor

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL lNotFin := .F.                 // .T. Calcular la nota de fin de a¤o.

       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'DOC',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat+ExtFile,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJui+cMaeAct+cAnoSis+ExtFile,'IND',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxJui+cMaeAct+cAnoSis+cExtNtx,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSin+cMaeAct+cAnoSis+ExtFile,'SIN',NIL,lShared,nModCry})
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

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE DOC->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE EMPTY(TCO->nPerActTbl)
	    cError('DEBE HABILITAR EL PERIODO ACTUAL')

       CASE TCO->nPerActTbl > TCO->nTotPerTbl
	    cError('EL PERIODO ACTUAL NO DEBE SER MAYOR AL TOTAL DE PERIODOS')

       CASE TCO->nTotPerTbl == 0
	    cError('NO SE HAN DEFINIDO EL TOTAL DE PERIODOS'+cMaeAct)

       CASE nNroPer # TCO->nTotPerTbl
	    cError('DEBE DIGITAR EL PERIODO No.'+STR(TCO->nTotPerTbl,1,1))

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

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
			     'LOP'+STR(nNroPer,1,0),ExtFile,.F.)
       CreaConLog(lShared,nModCry,cPatSis+'\'+PathLog,FileLog)

       IF !lUseDbf(.T.,cPatSis+'\'+PathLog+'\'+FileLog,cAliasL,NIL,lShared)
	  cError('ABRIENDO ARCHIVO DEL LOG')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL LOG DEL SISTEMA

*>>>>FILTRACION DEL ARCHIVO
       SELECT DOC
       SET FILTER TO cMaeAct $ DOC->cMaeAluPro .AND.;
		     DOC->lCargasPro .AND. !DOC->lRetiroPro

       DOC->(DBGOTOP())
       IF DOC->(EOF())

	  cTxtLog := 'NO EXISTEN PROFESORES PARA '+cMaeAct
	  cError(cTxtLog)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	*ÀRegistro del Log

	  SET FILTER TO
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>CAPTURA DE LOS PROFESORES POR INTERVALO
       SELECT DOC
       IF !lIntervPro(nFilInf+1,nColInf,@nIniPro,@nFinPro,'DOC')

	  cTxtLog := 'Se Abandono el Proceso. No se realiz¢ la lectura'
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	*ÀRegistro del Log

	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS PROFESORES POR INTERVALO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>REGISTRO DEL LOG
       cHorIni := TIME()
       cTxtLog := 'Inicio de la Lectura. Inicio a las: '+cHorIni
       AADD(aCamLog,{'cObservLog',cTxtLog})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
*>>>>FIN REGISTRO DEL LOG

*>>>>RECORRIDO POR PROFESORES
       SELECT DOC
       DOC->(DBGOTO(nIniPro))
       DO WHILE DOC->(RECNO()) <= nFinPro

**********ANALISIS METODO DEL CALCULO
	    cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)

	    cPatPro := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+DOC->cCodigoPro

	    DO CASE
	    CASE cJvfCal == '102'  // Indice de Cumplimiento

	    CASE cJvfCal == '301'  // Indicadores promocionales. Virrey

*****************INDICADORES PROMOCIONALES
		   AADD(aP2,{'cPatSco',cPatSis})
		   AADD(aP2,{'FCarPro',FCarPro})
		   AADD(aP2,{'FilePro',FilePro})
		   AADD(aP2,{'ExtFile',ExtFile})
		   AADD(aP2,{'nNroPer',nNroPer})
		   AADD(aP2,{'cPatPro',cPatPro})
		   AADD(aP2,{'cCodPro',DOC->cCodigoPro})
		   AADD(aP2,{'nIniPro',nIniPro})
		   AADD(aP2,{'nFinPro',nFinPro})
		 *ÀParametros espec¡ficos

		   CalPro301(aP1,aP2,aP3)
*****************FIN INDICADORES PROMOCIONALES

	    CASE cJvfCal == '302'  // Indicadores promocionales. Virrey

*****************INDICADORES PROMOCIONALES
		   AADD(aP2,{'cPatSco',cPatSis})
		   AADD(aP2,{'FCarPro',FCarPro})
		   AADD(aP2,{'FilePro',FilePro})
		   AADD(aP2,{'ExtFile',ExtFile})
		   AADD(aP2,{'nNroPer',nNroPer})
		   AADD(aP2,{'cPatPro',cPatPro})
		   AADD(aP2,{'cCodPro',DOC->cCodigoPro})
		   AADD(aP2,{'nIniPro',nIniPro})
		   AADD(aP2,{'nFinPro',nFinPro})
		 *ÀParametros espec¡ficos

		   CalPro302(aP1,aP2,aP3)
*****************FIN INDICADORES PROMOCIONALES

	    CASE TCO->nMetodoTbl == 0  // Juicios Valorativos

	    ENDCASE
**********FIN ANALISIS METODO DEL CALCULO

	  DOC->(DBSKIP())

       ENDDO
       cTxtLog := 'Fin '+;
		  'Inicio a las: '+cHorIni+' y termino a las: '+TIME()
       AADD(aCamLog,{'cObservLog',cTxtLog})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

       SELECT &cAliasL
       BROWSE()
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR PROFESORES

/*************************************************************************
* TITULO..: CALCULOS POR PROFESOR. METODO No. 301                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2008 VIE A
       Colombia, Bucaramanga        INICIO: 04:00 AM   SEP 26/2008 VIE

OBJETIVOS:

1- Recorre todos los estudiantes del profesor para realizar los c lculos

2- RETORNA NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalPro301(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL cPatSco := xPrm(aP2,'cPatSco') // Path de la Contabilidad
       LOCAL FCarPro := xPrm(aP2,'FCarPro') // Archivo Carga Academica
       LOCAL FilePro := xPrm(aP2,'FilePro') // Archivo del Profesor
       LOCAL ExtFile := xPrm(aP2,'ExtFile') // Extensi¢n del Archivo
       LOCAL nNroPer := xPrm(aP2,'nNroPer') // N£mero del Periodo
       LOCAL cPatPro := xPrm(aP2,'cPatPro') // Path del Profesor
       LOCAL cCodPro := xPrm(aP2,'cCodPro') // C¢digo del Profesor
       LOCAL nIniPro := xPrm(aP2,'nIniPro') // Registro Inicial del Profesor
       LOCAL nFinPro := xPrm(aP2,'nFinPro') // Registro Final del Profesor
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL       i := 0                   // Contador
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LOP'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log

       LOCAL nIniCaP := 0                   // Registro Inicial Carga Profesor
       LOCAL nFinCaP := 0                   // Registro Final Carga Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FilePro+ExtFile,'PRO',NIL,lShared)

	  cTxtLog := 'ABRIENDO ARCHIVOS PRINCIPALES DEL PROFESOR'
	  cError(cTxtLog)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	*ÀRegistro del Log

	  CloseDbf('CAP')
	  CloseDbf('PRO')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA CARGA DEL PROFESOR
       lHayErr := .T.
       DO CASE
       CASE CAP->(RECCOUNT()) == 0
	    cTxtLog := 'NO APARECE DATOS DE CARGA ACADEMICA DE '+;
		       ALLTRIM(DOC->cNombrePro)

       CASE PRO->(RECCOUNT()) == 0
	    cTxtLog := 'NO APARECE INFORMACION DEL PROFESOR '+;
		       ALLTRIM(DOC->cNombrePro)+' EN SU CARGA '+;
		       'ACADEMICA'

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr

	  cError(cMenTxt)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	*ÀRegistro del Log

	  CloseDbf('CAP')
	  CloseDbf('PRO')
	  RETURN NIL

       ENDIF
*>>>>FIN VALIDACION DE LA CARGA DEL PROFESOR

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF nIniPro == nFinPro
	  IF !lIntervCaP(nFilInf+1,nColInf,@nIniCaP,@nFinCaP)
	     CloseDbf('CAP')
	     CloseDbf('PRO')
	     RETURN NIL
	  ENDIF
       ELSE
	  nIniCaP := 1
	  nFinCaP := CAP->(RECCOUNT())
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDO POR ASIGNACION ACADEMICA
       SELECT CAP
       CAP->(DBGOTO(nIniCaP))
       DO WHILE CAP->(RECNO()) <= nFinCaP

**********ANALISIS DE DECISION
	    aHayErr := {}
	    IF CAP->nTipCarCar == 0
	       CalNoP301(aP1,aP2,aP3,aTotErr)
	    ELSE
	       CalNoP301(aP1,aP2,aP3,aTotErr)
	     *ÀRevisar cuando sea materias variables
	    ENDIF
**********FIN ANALISIS DE DECISION

**********REGISTRO DEL LOG
	    FOR i := 1 TO LEN(aTotErr)

		aHayErr := aTotErr[i]

		AADD(aCamLog,{'cCodigoEst',xPrm(aHayErr,'cCodEst')})
		AADD(aCamLog,{'cCodigoGru',xPrm(aHayErr,'cCodGru')})
		AADD(aCamLog,{'nNroRegEst',VAL(xPrm(aHayErr,'cNroLis'))})
		AADD(aCamLog,{'cCodigoPro',xPrm(aHayErr,'cCodPro')})
		AADD(aCamLog,{'cMatNoPLog',xPrm(aHayErr,'cCodMat')})
		AADD(aCamLog,{'cObservLog',xPrm(aHayErr,'cHayErr')})
	      *ÀCampos del Log

		aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDFOR
**********FIN REGISTRO DEL LOG


	  CAP->(DBSKIP())

       ENDDO
       CloseDbf('CAP')
       CloseDbf('PRO')
       RETURN NIL
*>>>>FIN RECORRIDO POR ASIGNACION ACADEMICA

/*************************************************************************
* TITULO..: CALCULOS POR GRUPOS. METODO No. 301                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 16/2008 MAR A
       Colombia, Bucaramanga        INICIO: 09:00 AM   SEP 16/2008 MAR

OBJETIVOS:

1- Recorre todos los estudiantes del grupo para realizar los c lculos

2- RETORNA NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalNoP301(aP1,aP2,aP3,aTotErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aTotErr			            // Hay Error */
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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL cPatSco := xPrm(aP2,'cPatSco') // Path de la Contabilidad
       LOCAL nNroPer := xPrm(aP2,'nNroPer') // N£mero del Periodo
       LOCAL ExtFile := xPrm(aP2,'ExtFile') // Extensi¢n del Archivo
       LOCAL cPatPro := xPrm(aP2,'cPatPro') // Path del Profesor
       LOCAL cCodPro := xPrm(aP2,'cCodPro') // C¢digo del Profesor
       LOCAL nIniPro := xPrm(aP2,'nIniPro') // Registro Inicial del Profesor
       LOCAL nFinPro := xPrm(aP2,'nFinPro') // Registro Final del Profesor
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cHayErr := ''                  // Hay Error
       LOCAL aHayErr := ''                  // Detalles del Error
     *ÀVariables generales

       LOCAL       i := 0                   // Contador

       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL cCamInd := ''                  // Campo de los indicadores. Marca Error el la Macro al declararse local
       LOCAL cCamNtI := ''                  // Campo de Nota de Indicadores
       LOCAL cCamDef := ''                  // Campo de definitivas

       LOCAL aDetMat := {}                  // Detalle de la Materia
       LOCAL aDbfMat := {}                  // Campos de Materias
       LOCAL aDbfPla := {}                  // Campos del Plan Academico
       LOCAL aDbfNot := {}                  // Campos de Notas
       LOCAL aMatSel := {}                  // Materias Selectivas
       LOCAL aMatVar := {}                  // Materias Variables
       LOCAL aDbfSel := {}                  // Campos de Estudiantes con Materias Selectivas
       LOCAL aDbfVar := {}                  // Campos Materias Variables

       LOCAL nTipPla := 0                   // Tipo del Plan

       LOCAL cCodInd := 0                   // C¢digo del Indicador
       LOCAL nNroInd := 0                   // N£mero de indicadores

       LOCAL cIndica1 := ''                 // Indicadores del Periodo No.1
       LOCAL cIndica2 := ''                 // Indicadores del Periodo No.2
       LOCAL cIndica3 := ''                 // Indicadores del Periodo No.3
       LOCAL cIndica4 := ''                 // Indicadores del Periodo No.4
       LOCAL cIndica5 := ''                 // Indicadores del Periodo No.5

       LOCAL cNotInd1 := ''                 // Nota de Indicadores P1
       LOCAL cNotInd2 := ''                 // Nota de Indicadores P2
       LOCAL cNotInd3 := ''                 // Nota de Indicadores P3
       LOCAL cNotInd4 := ''                 // Nota de Indicadores P4
       LOCAL cNotInd5 := ''                 // Nota de Indicadores P5

       LOCAL cNotDef := ''                  // Nota Definitiva

       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del nivel
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
       cCodigoTni := SUBS(cCodigoTgr,1,2)

       cCodigoTma := SUBS(CAP->cCodigoCar,1,4)
       IF SUBS(cCodigoTma,3,2) == '00' // Descarta el Area.
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LOCALIZACION DE LA MATERIA
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)

	  cHayErr := 'EL CODIGO: '+cCodigoTma+' DE LA MATERIA NO EXISTE'
	  cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	  aHayErr := {}
	  AADD(aHayErr,{'cCodEst',''})         // C¢digo del Estudiante
	  AADD(aHayErr,{'cCodGru',''})         // C¢digo del Grupo
	  AADD(aHayErr,{'cNroLis',''})         // Numero de lista
	  AADD(aHayErr,{'cNomEst',''})         // Nombre del Estudiante
	  AADD(aHayErr,{'cCodMat',cCodigoTma}) // C¢digo de la materia
	  AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	  AADD(aHayErr,{'cHayErr',cHayErr})    // Detalle del Error
	*ÀHay Error

	  AADD(aTotErr,aHayErr)

	  RETURN NIL

       ENDIF
       cCodigoTma := MAT->cCodigoMat
       cNombreTma := MAT->cNombreMat
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>ANALISIS DEL TIPO DE PLAN ACADEMICO
       nTipPla := 0
       IF !('XXXX' $ cCodigoTgr)
	  nTipPla := nTipoPlan(SUBS(cCodigoTgr,1,2))
	  IF nTipPla == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1
	  IF !lUseDbf(.T.,cPatSco+'\'+cMaeAct+'\'+;
			  cFilePlan(cAnoUsr,cCodigoTgr),'PLA',NIL,lShared)
	     cError('ABRIENDO ARCHIVO DEL PLAN DE ESTUDIOS')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)

	  cHayErr := 'ABRIENDO ARCHIVO DE NOTAS '+;
		     'DEL PROFESOR GRUPO '+cCodigoTgr
	  cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	  aHayErr := {}
	  AADD(aHayErr,{'cCodEst',''})         // C¢digo del Estudiante
	  AADD(aHayErr,{'cCodGru',''})         // C¢digo del Grupo
	  AADD(aHayErr,{'cNroLis',''})         // Numero de lista
	  AADD(aHayErr,{'cNomEst',''})         // Nombre del Estudiante
	  AADD(aHayErr,{'cCodMat',cCodigoTma}) // C¢digo de la materia
	  AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	  AADD(aHayErr,{'cHayErr',cHayErr})    // Detalle del Error
	*ÀHay Error

	  AADD(aTotErr,aHayErr)

	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NOP->(RECCOUNT()) == 0
	    cHayErr := 'NO EXISTEN ESTUDIANTES DE '+;
			ALLTRIM(CAP->cNombreMat)+' DE '+cCodigoTgr
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr

	  cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	  aHayErr := {}
	  AADD(aHayErr,{'cCodEst',''})         // C¢digo del Estudiante
	  AADD(aHayErr,{'cCodGru',''})         // C¢digo del Grupo
	  AADD(aHayErr,{'cNroLis',''})         // Numero de lista
	  AADD(aHayErr,{'cNomEst',''})         // Nombre del Estudiante
	  AADD(aHayErr,{'cCodMat',cCodigoTma}) // C¢digo de la materia
	  AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	  AADD(aHayErr,{'cHayErr',cHayErr})    // Detalle del Error
	*ÀHay Error

	  AADD(aTotErr,aHayErr)

	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VARIABLES DE CAMPO
       nNroPer := 5
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamNtI := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
*>>>>FIN VARIABLES DE CAMPO

*>>>>RECORRIDO POR NOTAS DEL PROFESOR
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********RETIRO DEL ESTUDIANTE
	    IF NOP->lRetiroNoP
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN RETIRO DEL ESTUDIANTE

**********BUSQUEDA DEL ESTUDIANTE
	    IF !lSekCodigo(NOP->cCodigoEst,cMaeAct)

	       cHayErr := 'NO EXISTE EL ESTUDIENTE EN MAESTRO DE '+cMaeAct
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',''})         // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',''})         // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',''})         // Numero de lista
	       AADD(aHayErr,{'cNomEst',''})         // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma}) // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})    // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF

	    IF lRetiroTes
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSco+'\'+cMaeAct+'\NOTAS\'+;
			'NT'+&cMaeAct->cCodigoGru+cAnoSis+ExtFile,'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      &cMaeAct->cCodigoGru)
	       CloseDbf('NOT')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',NOP->cCodigoEst)

	       cHayErr := 'NO EXISTE EN EL ARCHIVO DE NOTAS'
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',NOP->cCodigoEst})       // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',&cMaeAct->cCodigoGru})  // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',NOP->(STR(RECNO(),2))}) // Numero de lista
	       AADD(aHayErr,{'cNomEst',cNombreTes})            // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma})            // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})               // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********LOCALIZACION DETALLES DEL AREA O MATERIA
	    aDetMat := aLocAreMat(cCodigoTma,nNroPer)

	    IF LEN(aDetMat) == 0

	       cHayErr := 'NO EXISTE DETELLAS DE LA MATERIA DE NOTAS'
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',NOP->cCodigoEst})       // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',&cMaeAct->cCodigoGru})  // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',NOP->(STR(RECNO(),2))}) // Numero de lista
	       AADD(aHayErr,{'cNomEst',cNombreTes})            // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma})            // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})               // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})               // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DETALLES DEL AREA O MATERIA

**********DETALLES DEL AREA O MATERIA
	    aDbfMat := xPrm(aDetMat,'aDbfMat')
	    aDbfPla := xPrm(aDetMat,'aDbfPla')
	    aDbfNot := xPrm(aDetMat,'aDbfNot')
	    aMatSel := xPrm(aDetMat,'aMatSel')
**********FIN DETALLES DEL AREA O MATERIA

**********VALIDACION DE LA MATERIA
	    IF cCodigoTma # xPrm(aDbfMat,'cCodMat')

	       cHayErr := 'MATERIAS NOT COINCIDEN:'+;
			  cCodigoTma+':'+xPrm(aDbfMat,'cCodMat')
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',NOP->cCodigoEst})       // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',&cMaeAct->cCodigoGru})  // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',NOP->(STR(RECNO(),2))}) // Numero de lista
	       AADD(aHayErr,{'cNomEst',cNombreTes})            // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma})            // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})               // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA MATERIA

**********CALCULO DE LOS LOGROS PROMOCIONALES
	    cIndica1 := &(xPrm(aDbfNot,'cIndica1'))
	    cIndica2 := &(xPrm(aDbfNot,'cIndica2'))
	    cIndica3 := &(xPrm(aDbfNot,'cIndica3'))
	    cIndica4 := &(xPrm(aDbfNot,'cIndica4'))
	  *ÀIndicadores

	    cIndica5 := &(xPrm(aDbfNot,'cIndica5'))
	    cIndica5 := SPACE(LEN(cIndica5))
	  *ÀBorra el Contenido

	    cNotInd1 := &(xPrm(aDbfNot,'cNotInd1'))
	    cNotInd2 := &(xPrm(aDbfNot,'cNotInd2'))
	    cNotInd3 := &(xPrm(aDbfNot,'cNotInd3'))
	    cNotInd4 := &(xPrm(aDbfNot,'cNotInd4'))
	  *ÀNotas de los Indicadores.

	    cNotInd5 := &(xPrm(aDbfNot,'cNotInd5'))
	    cNotInd5 := SPACE(LEN(cNotInd5))
	  *ÀBorra el Contenido

	    cNotDef := cNotSin301(SUBS(&cMaeAct->cCodigoGru,1,2)+'00',;
				  cCodigoTma,nTotPer,;
				  cIndica1,cIndica2,cIndica3,;
				  cIndica4,@cIndica5,;
				  cNotInd1,cNotInd2,cNotInd3,;
				  cNotInd4,@cNotInd5)
**********FIN CALCULO DE LOS LOGROS PROMOCIONALES

**********VALIDACION DE LOS INDICADORES
	    IF EMPTY(cIndica5)

	       cHayErr := 'NO LE FIGURAN ITEMS DE EVALUACION'
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',NOP->cCodigoEst})       // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',&cMaeAct->cCodigoGru})  // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',NOP->(STR(RECNO(),2))}) // Numero de lista
	       AADD(aHayErr,{'cNomEst',cNombreTes})            // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma})            // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})               // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN VALIDACION DE LOS INDICADORES

**********GRABACION DEL REGISTRO
	    SELECT NOP
	    IF NOP->(lRegLock(lShared,.F.))

	       REPL &cCamInd WITH cIndica5
	     *ÀIndicadores

	       REPL &cCamNtI WITH cNotInd5
	     *ÀNota de los Indicadores

	       REPL &cCamDef WITH cNotDef
	     *ÀNota definitiva

	       REPL NOP->cNomUsrNop WITH cNomUsr
	       REPL NOP->dFecUsrNop WITH DATE()
	       REPL NOP->cHorUsrNop WITH TIME()

	       NOP->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       NOP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********TOTAL DE INDICADORES
	    FOR i := 1 TO 20
		cCodInd := SUBS(cIndica5,i*6-5,6)
		IF !EMPTY(cCodInd)
		   IF i > nNroInd
		      nNroInd := i
		   ENDIF
		ENDIF
	    ENDFOR
**********FIN TOTAL DE INDICADORES

***********LINEA DE ESTADO
	     LineaEstado('PROFESOR:'+DOC->(STR(RECNO(),2))+'/'+;
				 DOC->(STR(RECCOUNT(),2))+;
			 'ºGRUPO:'+cCodigoTgr+;
			 'ºNo. '+NOP->(STR(RECNO(),2))+'/'+;
				 NOP->(STR(RECCOUNT(),2))+;
			 'ºCODIGO:'+NOP->cCodigoEst+;
			 'ºNOTA:'+cNotDef+;
			 'ºMATERIA:'+SUBS(cNombreTma,1,25),cNomSis)
***********FIN LINEA DE ESTADO

	  NOP->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR NOTAS DEL PROFESOR

*>>>>GRABACION DEL REGISTRO
       SELECT CAP
       IF CAP->(lRegLock(lShared,.F.))
	  REPL CAP->cNroIndCaP WITH STUFF(CAP->cNroIndCaP,nNroPer*2-1,2,;
				    STR(nNroInd,2,0))
	  CAP->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL NUMERO DE INDICADORES')
       ENDIF
       IF lShared
	  CAP->(DBUNLOCK())
       ENDIF
       CloseDbf('NOP')
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: CALCULOS POR PROFESOR. METODO No. 302                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2009 JUE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   NOV 12/2009 JUE

OBJETIVOS:

1- Recorre todos los estudiantes del profesor para realizar los c lculos

2- RETORNA NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalPro302(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL cPatSco := xPrm(aP2,'cPatSco') // Path de la Contabilidad
       LOCAL FCarPro := xPrm(aP2,'FCarPro') // Archivo Carga Academica
       LOCAL FilePro := xPrm(aP2,'FilePro') // Archivo del Profesor
       LOCAL ExtFile := xPrm(aP2,'ExtFile') // Extensi¢n del Archivo
       LOCAL nNroPer := xPrm(aP2,'nNroPer') // N£mero del Periodo
       LOCAL cPatPro := xPrm(aP2,'cPatPro') // Path del Profesor
       LOCAL cCodPro := xPrm(aP2,'cCodPro') // C¢digo del Profesor
       LOCAL nIniPro := xPrm(aP2,'nIniPro') // Registro Inicial del Profesor
       LOCAL nFinPro := xPrm(aP2,'nFinPro') // Registro Final del Profesor
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL       i := 0                   // Contador
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LOP'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log

       LOCAL nIniCaP := 0                   // Registro Inicial Carga Profesor
       LOCAL nFinCaP := 0                   // Registro Final Carga Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FilePro+ExtFile,'PRO',NIL,lShared)

	  cTxtLog := 'ABRIENDO ARCHIVOS PRINCIPALES DEL PROFESOR'
	  cError(cTxtLog)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	*ÀRegistro del Log

	  CloseDbf('CAP')
	  CloseDbf('PRO')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA CARGA DEL PROFESOR
       lHayErr := .T.
       DO CASE
       CASE CAP->(RECCOUNT()) == 0
	    cTxtLog := 'NO APARECE DATOS DE CARGA ACADEMICA DE '+;
		       ALLTRIM(DOC->cNombrePro)

       CASE PRO->(RECCOUNT()) == 0
	    cTxtLog := 'NO APARECE INFORMACION DEL PROFESOR '+;
		       ALLTRIM(DOC->cNombrePro)+' EN SU CARGA '+;
		       'ACADEMICA'

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr

	  cError(cMenTxt)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	*ÀRegistro del Log

	  CloseDbf('CAP')
	  CloseDbf('PRO')
	  RETURN NIL

       ENDIF
*>>>>FIN VALIDACION DE LA CARGA DEL PROFESOR

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF nIniPro == nFinPro
	  IF !lIntervCaP(nFilInf+1,nColInf,@nIniCaP,@nFinCaP)
	     CloseDbf('CAP')
	     CloseDbf('PRO')
	     RETURN NIL
	  ENDIF
       ELSE
	  nIniCaP := 1
	  nFinCaP := CAP->(RECCOUNT())
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDO POR ASIGNACION ACADEMICA
       SELECT CAP
       CAP->(DBGOTO(nIniCaP))
       DO WHILE CAP->(RECNO()) <= nFinCaP

**********ANALISIS DE DECISION
	    aHayErr := {}
	    IF CAP->nTipCarCar == 0
	       CalNoP302(aP1,aP2,aP3,aTotErr)
	    ELSE
	       CalNoP302(aP1,aP2,aP3,aTotErr)
	     *ÀRevisar cuando sea materias variables
	    ENDIF
**********FIN ANALISIS DE DECISION

**********REGISTRO DEL LOG
	    FOR i := 1 TO LEN(aTotErr)

		aHayErr := aTotErr[i]

		AADD(aCamLog,{'cCodigoEst',xPrm(aHayErr,'cCodEst')})
		AADD(aCamLog,{'cCodigoGru',xPrm(aHayErr,'cCodGru')})
		AADD(aCamLog,{'nNroRegEst',VAL(xPrm(aHayErr,'cNroLis'))})
		AADD(aCamLog,{'cCodigoPro',xPrm(aHayErr,'cCodPro')})
		AADD(aCamLog,{'cMatNoPLog',xPrm(aHayErr,'cCodMat')})
		AADD(aCamLog,{'cObservLog',xPrm(aHayErr,'cHayErr')})
	      *ÀCampos del Log

		aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDFOR
**********FIN REGISTRO DEL LOG


	  CAP->(DBSKIP())

       ENDDO
       CloseDbf('CAP')
       CloseDbf('PRO')
       RETURN NIL
*>>>>FIN RECORRIDO POR ASIGNACION ACADEMICA

/*************************************************************************
* TITULO..: CALCULOS POR GRUPOS. METODO No. 302                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2009 JUE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   NOV 12/2009 JUE

OBJETIVOS:

1- Recorre todos los estudiantes del grupo para realizar los c lculos

2- RETORNA NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalNoP302(aP1,aP2,aP3,aTotErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aTotErr			            // Hay Error */
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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL cPatSco := xPrm(aP2,'cPatSco') // Path de la Contabilidad
       LOCAL nNroPer := xPrm(aP2,'nNroPer') // N£mero del Periodo
       LOCAL ExtFile := xPrm(aP2,'ExtFile') // Extensi¢n del Archivo
       LOCAL cPatPro := xPrm(aP2,'cPatPro') // Path del Profesor
       LOCAL cCodPro := xPrm(aP2,'cCodPro') // C¢digo del Profesor
       LOCAL nIniPro := xPrm(aP2,'nIniPro') // Registro Inicial del Profesor
       LOCAL nFinPro := xPrm(aP2,'nFinPro') // Registro Final del Profesor
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cHayErr := ''                  // Hay Error
       LOCAL aHayErr := ''                  // Detalles del Error
     *ÀVariables generales

       LOCAL       i := 0                   // Contador

       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL cCamInd := ''                  // Campo de los indicadores. Marca Error el la Macro al declararse local
       LOCAL cCamNtI := ''                  // Campo de Nota de Indicadores
       LOCAL cCamDef := ''                  // Campo de definitivas

       LOCAL aDetMat := {}                  // Detalle de la Materia
       LOCAL aDbfMat := {}                  // Campos de Materias
       LOCAL aDbfPla := {}                  // Campos del Plan Academico
       LOCAL aDbfNot := {}                  // Campos de Notas
       LOCAL aMatSel := {}                  // Materias Selectivas
       LOCAL aMatVar := {}                  // Materias Variables
       LOCAL aDbfSel := {}                  // Campos de Estudiantes con Materias Selectivas
       LOCAL aDbfVar := {}                  // Campos Materias Variables

       LOCAL nTipPla := 0                   // Tipo del Plan

       LOCAL aLogInd := {}                  // Logros e Indicadores
       LOCAL cCodInd := 0                   // C¢digo del Indicador
       LOCAL nNroInd := 0                   // N£mero de indicadores

       LOCAL cIndica1 := ''                 // Indicadores del Periodo No.1
       LOCAL cIndica2 := ''                 // Indicadores del Periodo No.2
       LOCAL cIndica3 := ''                 // Indicadores del Periodo No.3
       LOCAL cIndica4 := ''                 // Indicadores del Periodo No.4
       LOCAL cIndica5 := ''                 // Indicadores del Periodo No.5

       LOCAL cNotInd1 := ''                 // Nota de Indicadores P1
       LOCAL cNotInd2 := ''                 // Nota de Indicadores P2
       LOCAL cNotInd3 := ''                 // Nota de Indicadores P3
       LOCAL cNotInd4 := ''                 // Nota de Indicadores P4
       LOCAL cNotInd5 := ''                 // Nota de Indicadores P5

       LOCAL nNroAus := ''                  // N£mero de Ausencias
       LOCAL nTotAus := ''                  // Total de Ausencias
       LOCAL cTotAus := ''                  // Total de Ausencias

       LOCAL cNotDef := ''                  // Nota Definitiva

       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamFalNot := ''               // Campo Fallas en Notas
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
       cCodigoTni := SUBS(cCodigoTgr,1,2)

       cCodigoTma := SUBS(CAP->cCodigoCar,1,4)
       IF SUBS(cCodigoTma,3,2) == '00' // Descarta el Area.
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LOCALIZACION DE LA MATERIA
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)

	  cHayErr := 'EL CODIGO: '+cCodigoTma+' DE LA MATERIA NO EXISTE'
	  cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	  aHayErr := {}
	  AADD(aHayErr,{'cCodEst',''})         // C¢digo del Estudiante
	  AADD(aHayErr,{'cCodGru',''})         // C¢digo del Grupo
	  AADD(aHayErr,{'cNroLis',''})         // Numero de lista
	  AADD(aHayErr,{'cNomEst',''})         // Nombre del Estudiante
	  AADD(aHayErr,{'cCodMat',cCodigoTma}) // C¢digo de la materia
	  AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	  AADD(aHayErr,{'cHayErr',cHayErr})    // Detalle del Error
	*ÀHay Error

	  AADD(aTotErr,aHayErr)

	  RETURN NIL

       ENDIF
       cCodigoTma := MAT->cCodigoMat
       cNombreTma := MAT->cNombreMat
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>ANALISIS DEL TIPO DE PLAN ACADEMICO
       nTipPla := 0
       IF !('XXXX' $ cCodigoTgr)
	  nTipPla := nTipoPlan(SUBS(cCodigoTgr,1,2))
	  IF nTipPla == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1
	  IF !lUseDbf(.T.,cPatSco+'\'+cMaeAct+'\'+;
			  cFilePlan(cAnoUsr,cCodigoTgr),'PLA',NIL,lShared)
	     cError('ABRIENDO ARCHIVO DEL PLAN DE ESTUDIOS')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)

	  cHayErr := 'ABRIENDO ARCHIVO DE NOTAS '+;
		     'DEL PROFESOR GRUPO '+cCodigoTgr
	  cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	  aHayErr := {}
	  AADD(aHayErr,{'cCodEst',''})         // C¢digo del Estudiante
	  AADD(aHayErr,{'cCodGru',''})         // C¢digo del Grupo
	  AADD(aHayErr,{'cNroLis',''})         // Numero de lista
	  AADD(aHayErr,{'cNomEst',''})         // Nombre del Estudiante
	  AADD(aHayErr,{'cCodMat',cCodigoTma}) // C¢digo de la materia
	  AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	  AADD(aHayErr,{'cHayErr',cHayErr})    // Detalle del Error
	*ÀHay Error

	  AADD(aTotErr,aHayErr)

	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NOP->(RECCOUNT()) == 0
	    cHayErr := 'NO EXISTEN ESTUDIANTES DE '+;
			ALLTRIM(CAP->cNombreMat)+' DE '+cCodigoTgr
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr

	  cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	  aHayErr := {}
	  AADD(aHayErr,{'cCodEst',''})         // C¢digo del Estudiante
	  AADD(aHayErr,{'cCodGru',''})         // C¢digo del Grupo
	  AADD(aHayErr,{'cNroLis',''})         // Numero de lista
	  AADD(aHayErr,{'cNomEst',''})         // Nombre del Estudiante
	  AADD(aHayErr,{'cCodMat',cCodigoTma}) // C¢digo de la materia
	  AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	  AADD(aHayErr,{'cHayErr',cHayErr})    // Detalle del Error
	*ÀHay Error

	  AADD(aTotErr,aHayErr)

	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VARIABLES DE CAMPO
       nNroPer := 5
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamNtI := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       aLogInd := aLogIndMat(cCodigoTni,cCodigoTma,TCO->lIndNivTbl)
*>>>>FIN VARIABLES DE CAMPO

*>>>>RECORRIDO POR NOTAS DEL PROFESOR
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********RETIRO DEL ESTUDIANTE
	    IF NOP->lRetiroNoP
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN RETIRO DEL ESTUDIANTE

**********BUSQUEDA DEL ESTUDIANTE
	    IF !lSekCodigo(NOP->cCodigoEst,cMaeAct)

	       cHayErr := 'NO EXISTE EL ESTUDIENTE EN MAESTRO DE '+cMaeAct
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',''})         // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',''})         // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',''})         // Numero de lista
	       AADD(aHayErr,{'cNomEst',''})         // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma}) // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})    // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF

	    IF lRetiroTes
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSco+'\'+cMaeAct+'\NOTAS\'+;
			'NT'+&cMaeAct->cCodigoGru+cAnoSis+ExtFile,'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      &cMaeAct->cCodigoGru)
	       CloseDbf('NOT')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',NOP->cCodigoEst)

	       cHayErr := 'NO EXISTE EN EL ARCHIVO DE NOTAS'
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',NOP->cCodigoEst})       // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',&cMaeAct->cCodigoGru})  // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',NOP->(STR(RECNO(),2))}) // Numero de lista
	       AADD(aHayErr,{'cNomEst',cNombreTes})            // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma})            // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})               // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********LOCALIZACION DETALLES DEL AREA O MATERIA
	    aDetMat := aLocAreMat(cCodigoTma,nNroPer)

	    IF LEN(aDetMat) == 0

	       cHayErr := 'NO EXISTE DETELLAS DE LA MATERIA DE NOTAS'
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',NOP->cCodigoEst})       // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',&cMaeAct->cCodigoGru})  // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',NOP->(STR(RECNO(),2))}) // Numero de lista
	       AADD(aHayErr,{'cNomEst',cNombreTes})            // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma})            // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})               // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})               // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DETALLES DEL AREA O MATERIA

**********DETALLES DEL AREA O MATERIA
	    aDbfMat := xPrm(aDetMat,'aDbfMat')
	    aDbfPla := xPrm(aDetMat,'aDbfPla')
	    aDbfNot := xPrm(aDetMat,'aDbfNot')
	    aMatSel := xPrm(aDetMat,'aMatSel')
**********FIN DETALLES DEL AREA O MATERIA

**********VALIDACION DE LA MATERIA
	    IF cCodigoTma # xPrm(aDbfMat,'cCodMat')

	       cHayErr := 'MATERIAS NOT COINCIDEN:'+;
			  cCodigoTma+':'+xPrm(aDbfMat,'cCodMat')
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',NOP->cCodigoEst})       // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',&cMaeAct->cCodigoGru})  // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',NOP->(STR(RECNO(),2))}) // Numero de lista
	       AADD(aHayErr,{'cNomEst',cNombreTes})            // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma})            // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})               // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA MATERIA

**********CALCULO DE LOS LOGROS PROMOCIONALES
	    cIndica1 := &(xPrm(aDbfNot,'cIndica1'))
	    cIndica2 := &(xPrm(aDbfNot,'cIndica2'))
	    cIndica3 := &(xPrm(aDbfNot,'cIndica3'))
	    cIndica4 := &(xPrm(aDbfNot,'cIndica4'))
	  *ÀIndicadores

	    cIndica5 := &(xPrm(aDbfNot,'cIndica5'))
	    cIndica5 := SPACE(LEN(cIndica5))
	  *ÀBorra el Contenido

	    cNotInd1 := &(xPrm(aDbfNot,'cNotInd1'))
	    cNotInd2 := &(xPrm(aDbfNot,'cNotInd2'))
	    cNotInd3 := &(xPrm(aDbfNot,'cNotInd3'))
	    cNotInd4 := &(xPrm(aDbfNot,'cNotInd4'))
	  *ÀNotas de los Indicadores.

	    cNotInd5 := &(xPrm(aDbfNot,'cNotInd5'))
	    cNotInd5 := SPACE(LEN(cNotInd5))
	  *ÀBorra el Contenido

	    cCamNotDef := xPrm(aDbfNot,'cNotas')
	    cCamFalNot := xPrm(aDbfNot,'cFallas')

	    cNotDef := cNotSin302(SUBS(&cMaeAct->cCodigoGru,1,2)+'00',;
				  cCodigoTma,nTotPer,aLogInd,;
				  cIndica1,cIndica2,cIndica3,;
				  cIndica4,@cIndica5,;
				  cNotInd1,cNotInd2,cNotInd3,;
				  cNotInd4,@cNotInd5,cCamNotDef)
**********FIN CALCULO DE LOS LOGROS PROMOCIONALES

**********VALIDACION DE LOS INDICADORES
	    IF EMPTY(cIndica5)

	       cHayErr := 'NO LE FIGURAN ITEMS DE EVALUACION'
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aHayErr := {}
	       AADD(aHayErr,{'cCodEst',NOP->cCodigoEst})       // C¢digo del Estudiante
	       AADD(aHayErr,{'cCodGru',&cMaeAct->cCodigoGru})  // C¢digo del Grupo
	       AADD(aHayErr,{'cNroLis',NOP->(STR(RECNO(),2))}) // Numero de lista
	       AADD(aHayErr,{'cNomEst',cNombreTes})            // Nombre del Estudiante
	       AADD(aHayErr,{'cCodMat',cCodigoTma})            // C¢digo de la materia
	       AADD(aHayErr,{'cCodPro',cCodPro})    // C¢digo del Profesor
	       AADD(aHayErr,{'cHayErr',cHayErr})               // Detalle del Error
	     *ÀHay Error

	       AADD(aTotErr,aHayErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN VALIDACION DE LOS INDICADORES

**********TOTALIZACION DE AUSENCIAS
	    IF nNroPer == TCO->nTotPerTbl

	       nTotAus := 0
	       FOR i := 1 TO nNroPer-1
		   nNroAus := VAL(SUBS(&cCamFalNot,i*2-1,2))
		   nTotAus += nNroAus
	       ENDFOR

	    ENDIF
	    cTotAus := IF(nTotAus==0,SPACE(02),STR(nTotAus,2))
**********FIN TOTALIZACION DE AUSENCIAS

**********GRABACION DEL REGISTRO
	    SELECT NOP
	    IF NOP->(lRegLock(lShared,.F.))

	       REPL &cCamInd WITH cIndica5
	     *ÀIndicadores

	       REPL &cCamNtI WITH cNotInd5
	     *ÀNota de los Indicadores

	       REPL &cCamDef WITH cNotDef
	     *ÀNota definitiva

	       REPL NOP->cFallasNoP WITH ;
		       STUFF(NOP->cFallasNoP,nNroPer*2-1,2,cTotAus)

	       REPL NOP->cNomUsrNop WITH cNomUsr
	       REPL NOP->dFecUsrNop WITH DATE()
	       REPL NOP->cHorUsrNop WITH TIME()

	       NOP->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       NOP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********TOTAL DE INDICADORES
	    FOR i := 1 TO 20
		cCodInd := SUBS(cIndica5,i*6-5,6)
		IF !EMPTY(cCodInd)
		   IF i > nNroInd
		      nNroInd := i
		   ENDIF
		ENDIF
	    ENDFOR
**********FIN TOTAL DE INDICADORES

***********LINEA DE ESTADO
	     LineaEstado('PROFESOR:'+DOC->(STR(RECNO(),2))+'/'+;
				 DOC->(STR(RECCOUNT(),2))+;
			 'ºGRUPO:'+cCodigoTgr+;
			 'ºNo. '+NOP->(STR(RECNO(),2))+'/'+;
				 NOP->(STR(RECCOUNT(),2))+;
			 'ºCODIGO:'+NOP->cCodigoEst+;
			 'ºNOTA:'+cNotDef+;
			 'ºMATERIA:'+SUBS(cNombreTma,1,25),cNomSis)
***********FIN LINEA DE ESTADO

	  NOP->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR NOTAS DEL PROFESOR

*>>>>GRABACION DEL REGISTRO
       SELECT CAP
       IF CAP->(lRegLock(lShared,.F.))
	  REPL CAP->cNroIndCaP WITH STUFF(CAP->cNroIndCaP,nNroPer*2-1,2,;
				    STR(nNroInd,2,0))
	  CAP->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL NUMERO DE INDICADORES')
       ENDIF
       IF lShared
	  CAP->(DBUNLOCK())
       ENDIF
       CloseDbf('NOP')
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO