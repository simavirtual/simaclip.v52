/* SIMA - CONTABILIDAD PROFESORES

MODULO      : INDICADORES
SUBMODULO...: GRABAR

**************************************************************************
* TITULO..: TRASLADO DE INDICADORES A LA CONTABILIDAD                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/1996 MAR A
       Colombia, Bucaramanga        INICIO: 09:30 PM   AGO 20/1996 MAR

OBJETIVOS:

1- Permite grabar los indicadores de los profesores en la contabilidad
   acad‚mica.

2- Deja en blanco el archivo de indicadores de los profesores.

3- Ordena los indicadores de la contabilidad

4- Crea el subdirectorio de LOGROS en la contabilidad academica para
   almacenar los BACKUPS de los indicadores antes del traslado.

5- Realiza el BACKUPS de los archivos INDBTO96,NROBTO96,INDBTO, renombrandolos
   con la fecha y hora del traslado

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_771(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL PathAct := ''                  // Path Actual
       LOCAL cNroMes := ''                  // N£mero del mes
       LOCAL cNroDia := ''                  // N£mero del d¡a
       LOCAL cHorMin := ''                  // Hora y minuto
       LOCAL nNroFil := 0                   // N£mero de la fila

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>ANALISIS DE DECISION
       IF !lPregunta('ESTA SEGURO QUE DESEA TRASLADAR LOS LOGROS? No Si')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileInd+cMaeAct+ExtFile,'IND',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE INDICADORES DE LOS PROFESORES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES GRABADOS POR LOS PROFESORES')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       IF !lPregunta('SE VAN A TRASLADAR '+ALLTRIM(STR(IND->(RECCOUNT()),6))+;
		    ' INDICADORES. DESEA CONTINUAR? No Si')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO NOTAS
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (PathUno+'\'+cPatSis+'\'+cMaeAct+"\LOGROS") == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (PathUno+'\'+cPatSis+'\'+cMaeAct+"\LOGROS") == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO LOGROS")
	    QUIT

       CASE DIRCHANGE(PathUno+'\'+cPatSis+'\'+cMaeAct+"\LOGROS") == -3
	    DIRMAKE(PathUno+'\'+cPatSis+'\'+cMaeAct+"\LOGROS")
       ENDCASE
       DIRCHANGE(PathAct)
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO NOTAS

*>>>>BACKUPS DE LOS INDICADORES DE CONTABILIDAD
       cNroMes := STR(MONTH(DATE()),2)
       cNroDia := STR(DAY(DATE()),2)
       cHorMin := SUBS(TIME(),1,2)+SUBS(TIME(),4,2)
       lCorrecion(@cNroMes)
       lCorrecion(@cNroDia)

       Termometro(0,'COPIA DE SEGURIDAD. INDICADORES DE LA CONTABILIDAD')
       Termometro(25)
       FILECOPY(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    FileInd+cMaeAct+cAnoSis+ExtFile,;
		cFileTempo(PathUno+'\'+cPatSis+'\'+cMaeAct+'\LOGROS\','INDC',ExtFile))
       Termometro(50)
     *ÀCopia de los indicadores

       FILECOPY(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    FNroInd+cMaeAct+cAnoSis+ExtFile,;
		cFileTempo(PathUno+'\'+cPatSis+'\'+cMaeAct+'\LOGROS\','NROS',ExtFile))
       Termometro(100)
     *ÀCopia control secuencial de logros
*>>>>FIN BACKUPS DE LOS INDICADORES DE CONTABILIDAD

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileInd+cMaeAct+cAnoSis+ExtFile,'JUI',;
		       PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO EL ARCHIVO DE INDICADORES DE LA CONTABILIDAD')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>TRASLADO DE LOS INDICADORES
       nNroFil := nMarco(nFilPal+1,'TRASLANDO LOS INDICADORES DE LOS '+;
				   'PROFESORES A LA CONTABILIDAD')
       GO TOP
       DO WHILE .NOT. IND->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('INDICADORES DE LOGRO =>'+;
			 IND->(STR(RECNO(),7))+'/'+;
			 IND->(STR(RECCOUNT(),7)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DE LOS INDICADORES
	    IF JUI->(lRegLock(lShared,.T.))

	       REPL JUI->cCodigoNiv WITH IND->cCodigoNiv
	       REPL JUI->cCodigoJui WITH IND->cCodigoJui

	       REPL JUI->cCodLogJui WITH IND->cCodLogJui
	       REPL JUI->cIdeCodJui WITH IND->cIdeCodJui

	       REPL JUI->cCodigoPro WITH IND->cCodigoPro
	       REPL JUI->nNroPerJui WITH IND->nNroPerJui

	       REPL JUI->cNombreJui WITH IND->cNombreJui
	       REPL JUI->cExtra1Jui WITH IND->cExtra1Jui

	       REPL JUI->cNomUsrJui WITH IND->cNomUsrJui
	       REPL JUI->dFecUsrJui WITH IND->dFecUsrJui
	       REPL JUI->cHorUsrJui WITH IND->cHorUsrJui
	       JUI->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL INDICADOR')
	    ENDIF
	    IF lShared
	       JUI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS INDICADORES

**********VISUALIZACION DEL ESTUDIANTE GRABADO
	    nNroFil++
	    @ nNroFil,01 SAY SUBS(IND->cCodigoJui,5,4)+' '+;
			     SUBS(IND->cNombreJui,1,60)+'...'
	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal+1,'TRASLANDO LOS INDICADORES '+;
					   'DE LOS PROFESORES A LA '+;
					   'CONTABILIDAD')
	    ENDIF
**********FIN VISUALIZACION DEL ESTUDIANTE GRABADO

	  IND->(DBSKIP())

       ENDDO
       CloseAll()
*>>>>FIN TRASLADO DE LOS INDICADORES

*>>>>TRASLADO DEL ARCHIVO DE LOS INDICADORES DE LOS PROFESORES
       Termometro(0,'COPIA DE SEGURIDAD. INDICADORES DE LOS PROFESORES')
       Termometro(50)
       IF FILEMOVE(cPatSis+'\'+cMaeAct+'\'+;
			    FileInd+cMaeAct+ExtFile,;
		   cFileTempo(PathUno+'\'+cPatSis+'\'+cMaeAct+'\LOGROS\',;
			    'INDP',ExtFile)) == 0

	    CreaDbfInd(lShared,nModCry,cPatSis+'\'+cMaeAct,;
		       FileInd+cMaeAct+ExtFile)
	   *Crea el archivo del indicador del profesor sin registros

       ENDIF
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       Indexar(aP1)
       RETURN NIL
*>>>>FIN TRASLADO DEL ARCHIVO DE LOS INDICADORES DE LOS PROFESORES