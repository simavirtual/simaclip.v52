/* SIMA - CONTABILIDAD PROFESORES

MODULO      : UTILIDADES
SUBMODULO...: ACTUALIZAR CODIGOS

**************************************************************************
* TITULO..: ACTUALIZACION DE CODIGOS                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 29/2002 LUN A
       Colombia, Bucaramanga        INICIO: 06:00 PM   ABR 29/2002 LUN

OBJETIVOS:

1- Actualiza la ubicaci¢n de los c¢digos de los indicadores para permitir
   el control de las recuperaciones.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_745(aP1,aP2,aP3)

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

       LOCAL lTodos  := .F.                 // .T. Procesar todos

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor

       LOCAL GetList := {}                  // Variable del sistema
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
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // .T. SimaProf en Usb. .F. SimaProf en la Red
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>LECTURA DEL USUARIO PROFESOR
       cSavPan := SAVESCREEN(0,0,24,79)
       cPatPro := cUsrPro(lShared,cNomSis,cPatSis,cNomUsr,cAnoUsr,cMaeAct,;
			  lMemUsb,@cCodigoTpr,@cNomPro,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       lTodos := .F.
       IF EMPTY(cPatPro)
	  lTodos := lPregunta('DESEA ACTUALIZAR TODOS LOS PROFESORES? No Si')
	  IF !lTodos
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       CloseDbf('TCO')
*>>>>FIN LECTURA DEL USUARIO PROFESOR

*>>>>ACTUALIZACION DEL REGISTRO
       SELECT PRO
       IF lTodos
	  PRO->(DBGOTOP())
       ENDIF
*>>>>FIN ACTUALIZACION DEL REGISTRO

*>>>>ACTUALIZACION DE LAS ESTRUCTURAS
       DO WHILE .T.

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('PROF:'+ALLTRIM(PRO->cApelliPro)+;
			'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				STR(PRO->(RECCOUNT()),4),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LECTURA DEL PATH DEL PROFESOR
	    IF lTodos
*	       cPatPro := 'c:\'+cPatSis+'\'+cMaeAct+'\'+PRO->cCodigoPro
	       cPatPro := cPatSis+'\'+cMaeAct+'\'+PRO->cCodigoPro
	    ENDIF
**********FIN LECTURA DEL PATH DEL PROFESOR

**********VALIDACION DE EXISTENCIA
	    IF !FILE(cPatPro+'\'+FCarPro+cAnoSis+ExtFile)
	       PRO->(DBSKIP())
	       IF PRO->(EOF())
		  EXIT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN VALIDACION DE EXISTENCIA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			    FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
	       cError('ABRIENDO ARCHIVO CARGAS DEL PROFESOR')
	       CLOSE ALL
	       RETURN .F.
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CAP->(RECCOUNT()) == 0
		 cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR '+;
			'CODIGO: '+PRO->cCodigoPro)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CAP')
	       PRO->(DBSKIP())
	       IF PRO->(EOF())
		  EXIT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********ACTUALIZACION DE LOS ARCHIVOS DE LA CARGA ACADEMICA
	    SELECT CAP
	    GO TOP
	    DO WHILE .NOT. CAP->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('PROF:'+PRO->cApelliPro+;
			     'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				     STR(PRO->(RECCOUNT()),4)+;
			     'ºGRUPO:'+SUBS(CAP->cCodigoCar,5,4)+;
			     'ºNo. '+STR(CAP->(RECNO()),4)+'/'+;
				     STR(CAP->(RECCOUNT()),4),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ACTUALIZACION DE LA ESTRUCTURA
		 IF FILE(cPatPro+'\'+CAP->cCodigoCar+ExtFile)
		    ActCodApl(lShared,cPatPro)
		 ENDIF
*--------------FIN ACTUALIZACION DE LA ESTRUCTURA

	       SELECT CAP
	       CAP->(DBSKIP())

	    ENDDO
	    CloseDbf('CAP')
**********FIN ACTUALIZACION DE LOS ARCHIVOS DE LA CARGA ACADEMICA

**********ANALISIS DE DECISION
	    IF !lTodos
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

**********AVANCE DEL REGISTRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       EXIT
	    ENDIF
**********AVANCE DEL REGISTRO

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LAS ESTRUCTURAS

/*************************************************************************
* TITULO..: ACTUALIZACION DE CODIGOS APLICADOS                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 29/2002 LUN A
       Colombia, Bucaramanga        INICIO: 06:15 PM   ABR 29/2002 LUN

OBJETIVOS:

1- Actualiza los c¢digos aplicados para permitir el control de las
   recuperaciones.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ActCodApl(lShared,cPatPro)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cPatPro                              // Path del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroPer := 0                   // N£mero de Periodos
       LOCAL cLogros := ''                  // Indicadores Anteriores
       LOCAL cIndAct := ''                  // Indicadores Actualizados
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL lRegAct := ''                  // .T. Registro Actualizado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO '+cPatPro)
	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NOP->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'GRUPO:'+SUBS(CAP->cCodigoCar,5,4)+' '+;
				     ALLTRIM(CAP->cNombreMat),22)
       @ nNroFil,01 SAY 'No.'
       @ nNroFil,04 SAY 'CODIGO'
       @ nNroFil,11 SAY 'ESTADO'
       nNroFil++
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>ACTUALIZACION DE LOS CODIGOS
       SELECT NOP
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********VISUALIZACION DEL CODIGO DEL ESTUDIANTE
	    @ nNroFil,01 SAY STR(NOP->(RECNO()),2,0)
	    @ nNroFil,04 SAY NOP->cCodigoEst
**********FIN VISUALIZACION DEL CODIGO DEL ESTUDIANTE

**********ACTUALIZACION POR PERIODOS
	    lRegAct := IF(NOP->nCamTemNoP == 0,.F.,.T.)
	    IF !lRegAct
	       FOR nNroPer := 1 TO 5

*---------------ACTUALIZACION DE LOS INDICADORES
		  cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
		  cLogros := &cCamInd
		  IF EMPTY(cLogros)
		     LOOP
		  ENDIF
		  cIndAct := cLogrosAct(cLogros)
*---------------FIN ACTUALIZACION DE LOS INDICADORES

*---------------GRABACION DE LA ACTUALIZACION
		  SELECT NOP
		  IF NOP->(lRegLock(lShared,.F.))
		     REPLACE &cCamInd WITH cIndAct
		     REPLACE NOP->nCamTemNoP WITH 1
		     NOP->(DBCOMMIT())
		  ELSE
		     cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
		  ENDIF
		  IF lShared
		     NOP->(DBUNLOCK())
		  ENDIF
*---------------FIN GRABACION DE LA ACTUALIZACION

	       ENDFOR
	    ENDIF
**********FIN ACTUALIZACION POR PERIODOS

**********INCREMENTO DE LAS FILAS
	    @ nNroFil,11 SAY IF(lRegAct ,'YA ACTUALIZADO','ACTUALIZADO')
	    nNroFil++
	    IF nNroFil > 21
	       nNroFil := nMarco(03,'GRUPO:'+SUBS(CAP->cCodigoCar,5,4)+' '+;
				      ALLTRIM(CAP->cNombreMat),22)
	       @ nNroFil,01 SAY 'No.'
	       @ nNroFil,04 SAY 'CODIGO'
	       @ nNroFil,11 SAY 'ESTADO'
	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

	  NOP->(DBSKIP())

       ENDDO
       CloseDbf('NOP')
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LOS CODIGOS


/*************************************************************************
* TITULO..: ACTUALIZACION DE LOS LOGROS                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 AM   MAY 28/2002 MAR

OBJETIVOS:

1- Actuliza los c¢digos de los indicadores agregando el espacio para
   el control de las Recuperaciones.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLogrosAct(cLogros)

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cIndAct := ''                  // Indicadores Actualizados
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodLog := ''                  // C¢digo del Logro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTUALIZACION DE LOS INDICADORES
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/5,0)
       FOR i := 1 TO nNroInd

	   cCodLog := SUBS(cLogros,i*5-4,5)
	   IF !LEN(cCodLog) == 5
	      cError('LA LONGITUD DEL CODIGO NO ES IGUAL A 5')
	   ENDIF
	   cIndAct += cCodLog+SPACE(01)

       ENDFOR
       RETURN cIndAct
*>>>>FIN ACTUALIZACION DE LOS INDICADORES
