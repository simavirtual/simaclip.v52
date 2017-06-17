/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LOGROS
SUBMODULO...: AUSENCIAS

**************************************************************************
* TITULO..: GRABACION DE LAS AUSENCIAS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 28/1996 JUE A
       Colombia, Bucaramanga        INICIO: 01:15 PM   MAR 28/1996 JUE

OBJETIVOS:

1- Permite la grabaci¢n de las Ausencias

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_205(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual

       LOCAL cSavCab := ''                  // Salvar Encabezado
       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nPerAct := 0                   // Periodo Actual
       LOCAL nIndTot := 20                  // Total de Indicadores
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL cClaInd := ''                  // Clase del Indicador

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cNroAus := ''                  // N£mero de Ausencias
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL cNroLis := ''                  // N£mero de Lista
       LOCAL lOtrEst := .F.                 // .T. Otro Estudiante

       LOCAL cCamNot := ''                  // Campo de Notas
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL cCamDef := ''                  // Campo de Definitiva
       LOCAL cCamObs := ''                  // Campo de Observacion

       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nColIni := 0                   // Columna Inicial
       LOCAL nFilFin := 0                   // Fila Final
       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cSecInd := 0                   // Secuencial del Indicador
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL nTipCarTca := 0                // Tipo de carga
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)     .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)               .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileInd+cMaeAct+cAnoSis+ExtFile,'IND',;
		       PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES DE LA CONTABILIDAD')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       lHayErr := .F.
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DEL GRUPO
       cCodigoTpr := SUBS(cPatPro,LEN(cPatPro)-5,6)
       IF !lLocCodigo('cCodigoPro','PRO',cCodigoTpr,'DEL PROFESOR')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL GRUPO

*>>>>SELECCION DE LA MATERIA DEL GRUPO
       SELECT CAP
       IF CAP->(RECCOUNT()) # 0

**********INICIALIZACION DE LAS COORDENADAS
	    nFilSup := nFilInf+2
	    nColSup := nColInf
	    IF nFilSup+RECCOUNT() > 22
	       nInfFil := 21
	    ELSE
	       nInfFil := nFilSup + RECCOUNT()-1
	    ENDIF
	    nInfCol := nColSup+LEN(CAP->cNombreMat)+2
**********FIN INICIALIZACION DE LAS COORDENADAS

**********BROWSE DE SELECCION
	    DO WHILE .T.

*--------------SELECCION DEL REGISTRO
		 SELECT CAP
		 IF nBrowseDbf(nFilSup,02,nInfFil,78,;
			      {||SUBS(CAP->cCodigoCar,5,4)+' '+;
			       Materia()}) == 0
		    CLOSE ALL
		    RETURN NIL
		 ENDIF
		 lLocCodigo('cCodigoMat','MAT',SUBS(CAP->cCodigoCar,1,4))
*--------------FIN SELECCION DEL REGISTRO

*--------------PREGUNTA DE DECISION
		 cMsgTxt := 'ESCOGIO '+ALLTRIM(CAP->cNombreMat)+' '+;
			    'DEL GRUPO: '+SUBS(CAP->cCodigoCar,5,4)
		 cMsgTxt := SUBS(cMsgTxt,1,50)

		 IF lPregunta(cMsgTxt+' DESEA CONTINUAR? Si No')
		    EXIT
		 ENDIF
*--------------FIN PREGUNTA DE DECISION

	    ENDDO
**********FIN BROWSE DE SELECCION

       ENDIF
       cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
       cCodigoTni := SUBS(cCodigoTgr,1,2)
       cCodigoTma := MAT->cCodigoMat
       nTipCarTca := CAP->nTipCarCar
*>>>>FIN SELECCION DE LA MATERIA DEL GRUPO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	  cError('ABRIENDO ARCHIVO DE NOTAS DEL PROFESOR GRUPO '+cCodigoTgr)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NOP->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DEL GRUPO: '+cCodigoTgr)
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       nPerAct := IF(EMPTY(PRO->nNroPerPro),TCO->nPerActTbl,PRO->nNroPerPro)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,nTotPer,nPerAct,.T.)
       IF nNroPer == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       cCamNot := 'NOP->cNotas'+STR(nNroPer,1,0)+'NoP'
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       cCamObs := 'NOP->cObsev'+STR(nNroPer,1,0)+'NoP'
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>DETERMINACION DE COLS Y LONGITUD DE NOMBRE
       nFilIni := 06
       nFilFin := 19
       nNroFil := nFilIni
       nColIni := 60
       nNroCol := nColIni
*>>>>FIN DETERMINACION DE COLS Y LONGITUD DE NOMBRE

*>>>>IMPRESION DE LOS ENCABEZADOS
       LineaEstado('GRUPO: '+cCodigoTgr,cNomSis)
       nNroFil := nMarco(nFilPal+1,;
			 ALLTRIM(MAT->cNombreMat),22,'°')
       @ nNroFil,01 SAY 'NRO'
       @ nNroFil,05 SAY 'NOMBRE'
       @ nNroFil,60 SAY 'AUSENCIAS'
       nNroFil = nNroFil + 1
      *Ubica la fila primera de grabacion
       cSavCab := SAVESCREEN(nNroFil-1,0,nNroFil-1,79)
       cSavLin := SAVESCREEN(21,0,22,79)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LAS NOTAS DE LOS ESTUDIANTES
       lOtrEst := .T.
       DO WHILE lOtrEst

**********CAPTURA DEL NUMERO DE LA LISTA
	    Centrar('ENTRE EL NUMERO DE LISTA DEL ESTUDIANTE '+;
		    'A MODIFICAR',21)
	    cNroLis := SPACE(03)
	    @ nNroFil,01 GET cNroLis  PICT "999"
	    READ
	    RESTSCREEN(21,0,22,79,cSavLin)

	    IF EMPTY(cNroLis)
	       lOtrEst := .F.
	       LOOP
	    ENDIF
**********FIN CAPTURA DEL NUMERO DE LA LISTA

**********VALIDACION DEL NUMERO DE LA LISTA
	    SELECT NOP
	    IF VAL(cNroLis) > NOP->(RECCOUNT())
	       cError('NO HAY NINGUN ESTUDIANTE CON ESTE NUMERO '+;
		      'DE LISTA')
	       LOOP
	    ENDIF
	    GO VAL(cNroLis)
	   *Ubicacion en el registro del estudiante a modificar
**********FIN VALIDACION DEL NUMERO DE LA LISTA

**********VISUALIZACION DATOS DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cError('No Existe Estudiante Cod: '+cCodigoTes)
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
**********FIN VISUALIZACION DATOS DEL ESTUDIANTE

**********VALIDACION DEL ESTUDIANTE SI ESTA RETIRADO
	    lHayErr := .T.
	    DO CASE
	    CASE nTipCarTca == 0  .AND. NOP->lRetiroNoP
		 cError(cNombreTes+' PERTENECE A OTRO GRUPO')

	    CASE nTipCarTca # 0 .AND. NOP->lRetiroNoP
		 cError(cNombreTes+' FUE RETIRADO DE LA LISTA')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       LOOP
	    ENDIF
	    @ nNroFil,05 SAY SUBS(cNombreTes,1,50)  PICT '@A'
**********FIN VALIDACION DEL ESTUDIANTE SI ESTA RETIRADO

**********CAPTURA DE LA AUSENCIA
	    SELECT NOP
	    cNroAus := SUBS(NOP->cFallasNop,nNroPer*2-1,2)
	    @ nNroFil,nNroCol GET cNroAus PICT '99'
	    READ
	    IF VAL(cNroAus) == 0
	       cNroAus := SPACE(02)
	    ENDIF
**********FIN CAPTURA DE LA AUSENCIA

**********GRABAR LAS NOTAS
	    SELECT NOP
	    IF NOP->(lRegLock(lShared,.F.))
	       REPLACE NOP->cFallasNoP WITH ;
		       STUFF(NOP->cFallasNoP,nNroPer*2-1,2,cNroAus)
	       NOP->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       NOP->(DBUNLOCK())
	    ENDIF
**********FIN GRABAR LAS NOTAS

**********INCREMENTO DE LAS FILAS
	    nNroFil = nNroFil + 1
	    IF nNroFil > nFilFin

*--------------IMPRESION DE LOS ENCABEZADOS
		 nNroFil := nMarco(nFilPal+1,;
				   ALLTRIM(MAT->cNombreMat),22,'°')
		 @ nNroFil,01 SAY 'NRO'
		 @ nNroFil,05 SAY 'NOMBRE'
		 @ nNroFil,60 SAY 'AUSENCIAS'
		 RESTSCREEN(nNroFil,0,nNroFil,79,cSavCab)
*--------------IMPRESION DE LOS ENCABEZADOS

*--------------IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE
		 nNroFil = nFilIni + 1
		 @ nNroFil,01 SAY STR(NOP->(RECNO()),3) PICT '999'
		 @ nNroFil,05 SAY SUBS(cNombreTes,1,50) PICT '@A'
		 @ nNroFil,60 SAY cNroAus PICT '99'
		 nNroFil = nNroFil + 1
		 SELECT NOP
*--------------FIN IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LAS NOTAS DE LOS ESTUDIANTES