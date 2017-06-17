/*                       SIMA - CONTABILIDAD ACADEMICA
	  BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE CERTIFICADOS

REQUERIMIENTOS:

- Compilar: clipper FuncsBol /w/m/b

OBJETIVOS:

- Funciones aplicadas para los diferentes boletines y libro final.


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: OTRA HOJA DEL CERTIFICADO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/97 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   MAY 29/97 JUE

OBJETIVOS:

1- Imprime el Encabezado del Certificado.

2- Imprime el Encabezado del columna del certificado

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtraHoja(cCodIni,cCodFin,bCabeza)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodIni                              // C¢digos de impresi¢n iniciales
       cCodFin                              // C¢digos de impresi¢n finales
       bCabeza                              // Block de Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtPrn := ''                  // Texto de impresion
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL ENCABEZADO
       IF !EMPTY(bCabeza)
	  EVAL(bCabeza)
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL ENCABEZADO DE COLUMNA
       cTxtPrn := 'ASIGNATURAS'+SPACE(73)+'JUICIO VALORATIVO'+SPACE(04)+;
		  'I.H.'
       @ PROW(),00 SAY cCodIni

       @ PROW()+2,00 SAY cTxtPrn

       @ PROW()+1,00 SAY cCodFin

       RETURN NIL
*>>>>FIN IMPRESION DEL ENCABEZADO DE COLUMNA



/*************************************************************************
* TITULO DE LA FUNCION..: CERTIFICADOS DEL ESTUDIANTE POR A¥OS           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 14/97 LUN A
       Colombia, Bucaramanga        INICIO: 11:30 AM   JUL 17/97 JUE

OBJETIVOS:

1- Permite imprimir los certificados por a¤os.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CertsAnos(lShared,cNomSis,cNomEmp,cNomDpt,cNomMun,;
		   cAnoUsr,cMaeAlu,cMaeAct,cJorTxt,cIniJor,;
		   cAnoIni,cAnoFin,cDocNit,cLugDoc,aFirmas,;
		   oBrwCer)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       cAnoUsr                              // A¤o del Usuario
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       cIniJor                              // Iniciales jornada escogida
       cAnoIni                              // A¤o Inicial Habilitado
       cAnoFin                              // A¤o Final Habilitado
       cDocNit                              // Documento de Identidad
       cLugNit                              // Lugar del Documento
       cUsoCer                              // Uso del Certificado
       oBrwCer                              // Browse del certificado
       aFirmas                              // Firmantes del Certificado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar pantalla
       LOCAL       i := 0                   // Contador

       LOCAL cUsoCer := ''                  // Uso del Certificado
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL cPatSis := ''                  // Path del sistema
       LOCAL cAnoSis := ''                  // A¤o del Sistema
       LOCAL nRegAlu := 0                   // Registro del Alumno
       LOCAL nPosBrw := 0                   // Posici¢n del Browse
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL GetList:= {}                   // Variable del sistema


       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cApelliTes := ''               // Apellido del Estudiante
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       SET CURSOR ON
*>>>>FIN DECLARACION DE VARIABLES

*--------------CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA
		 aMezcla := {{'(NROCER)','1111'},;
			     {'(NOMBRE)','NELSON FERNANDEZ'},;
			     {'(NRODOC)','91.229.913'},;
			     {'(LUGDOC)','BUCARAMANGA'}}
*--------------FIN CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA

SET DEVICE TO PRINT

PrnFileTxt("Bases\Certefi",aMezcla)
SET DEVICE TO SCREEN
Return NIL


*>>>>LECTURA DE LOS NIVELES A IMPRIMIR
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lInterAno(12,30,@cAnoIni,@cAnoFin,@nCopias,.T.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN LECTURA DE LOS NIVELES A IMPRIMIR

*>>>>LECTURA DE LA DESTINACION DEL CERTIFICADO
       cSavPan := SAVESCREEN(0,0,24,79)
       cUsoCer := SPACE(70)
       TitBuscar(70,@nNroFil,@nNroCol,'CERTFICADO PARA:',;
		 'USO DEL CERTIFICADO')

       SETCURSOR(1)
       @ nNroFil,nNroCol GET cUsoCer PICT '@S70!'
       READ
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA DESTINACION DEL CERTIFICADO

*>>>>LECTURA DE LOS ESTADOS INICIALES
       SELECT &cMaeAct

       nPosBrw := oBrwCer:ROWPOS()
       nRegAlu := &cMaeAct->(RECNO())

       cNombreTes := &cMaeAct->cNombreEst
       cApelliTes := &cMaeAct->cApelliEst
       cCodigoTes := &cMaeAct->cCodigoEst
       cCodigoTgr := &cMaeAct->cCodigoGru

*       CLOSE ALL
*>>>>FIN LECTURA DE LOS ESTADOS INICIALES

*>>>>IMPRESION DE LOS CERTIFICADOS
       FOR i := VAL(cAnoIni) TO VAL(cAnoFin)

***********INICIALIZACION PARA EL A¥O
	     CloseDbf('JAR')
	     CloseDbf('PRI')
	     CloseDbf('BTO')
	     cAnoSis := SUBS(STR(i,4),3,2)
	     cPatSis := STR(i,4)+'.'+cIniJor
***********FIN INICIALIZACION PARA EL A¥O

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseMae(lShared,cPatSis,cMaeAlu,cAnoSis)
		CloseDbf('JAR')
		CloseDbf('PRI')
		CloseDbf('BTO')
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********LOCALIZACION DEL ESTUDIANTE
	     cNalias := ''
	     IF !lSekCodMae(cCodigoTes,cMaeAlu,@cNalias)
		LOOP
	     ENDIF
***********FIN LOCALIZACION DEL ESTUDIANTE

***********VALIDACION DEL NOMBRE DEL ESTUDIANTE
	     IF &cMaeAct->cNombreEst # cNombreTes .OR.;
		&cMaeAct->cApelliEst # cApelliTes

		cError(cAnoUsr+'=>'+;
		       RTRIM(cNombreTes)+' '+;
		       RTRIM(cApelliTes),;
		       'NOMBRES DIFERENTES',;
		       STR(i,4)+'=>'+;
		       RTRIM(&cMaeAct->cNombreEst)+' '+;
		       RTRIM(&cMaeAct->cApelliEst))

		LOOP

	     ENDIF
***********FIN VALIDACION DEL NOMBRE DEL ESTUDIANTE

***********SELECCION DEL TIPO DE CERTIFICADO
	     DO CASE
	     CASE TCO->nTipCerTbl == 1
		  Certific01(lShared,cNomSis,cNomEmp,cNomDpt,cNomMun,;
			      STR(i,4),cPatSis,cNalias,cJorTxt,cDocNit,;
			      cLugDoc,cUsoCer,aFirmas,nCopias)
	     ENDCASE
***********FIN IMPRESION DEL CERTIFICADO

       NEXT
*>>>>FIN IMPRESION DE LOS CERTIFICADOS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       cPatSis := cAnoUsr+'.'+cIniJor
       cAnoSis := SUBS(cAnoUsr,3,2)

       CloseDbf('JAR')
       CloseDbf('PRI')
       CloseDbf('BTO')

       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO LOS ARCHIVOS MAESTROS')
	  CloseDbf('JAR')
	  CloseDbf('PRI')
	  CloseDbf('BTO')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>RESTAURACION DEL ESTADO INICIAL
       SELECT &cMaeAct
       GO nRegAlu
       oBrwCer:GOTOP()
       oBrwCer:ROWPOS := nPosBrw
       oBrwCer:REFRESHALL()
       oBrwCer:FORCESTABLE()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN RESTAURACION DEL ESTADO INICIAL

/*************************************************************************
* TITULO DE LA FUNCION..: CERTIFICADO DEL ESTUDIANTE                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/97 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   JUL 17/97 JUE

OBJETIVOS:

1- Imprime el certificado del a¤o del estudiante.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Certific01(lShared,cNomSis,cNomEmp,cNomDpt,cNomMun,;
		     cAnoUsr,cPatSis,cMaeAct,cJorTxt,cDocNit,;
		     cLugDoc,cUsoCer,aFirmas,nCopias)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del Usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       cUsoCer                              // Uso del Certificado
       aFirmas                              // Firmantes del Certificado
       nCopias                              // N£meros de copias a imprimir */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // Path del sistemas
       LOCAL cSavPan := ''                  // Salvar Pantalla


       LOCAL bCabeza := NIL                 // Encabezado
       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL lPrnAre := .F.                 // .T. Imprimir el area
       LOCAL lNegAre := .F.                 // .T. En negrilla el area
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la columna

       LOCAL nNroCop := 0                   // N£mero de copia
       LOCAL cFolMat := ''                  // Folio de la matricula
       LOCAL cResolu := ''                  // Resoluci¢n de Aprobaci¢n
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL cNivEdu := ''                  // Nivel de Educaci¢n BP,BS,MV
       LOCAL cEspeci := ''                  // Especialidad del Estudio
       LOCAL cObserv := ''                  // Observaci¢n para el certificado
       LOCAL cMsgErr := ''                  // Mensaje de Error

       LOCAL cNomEst := ''                  // Nombre del Estudiante
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CIERRE DE LOS ARCHIVOS DEL CERTIFICADO
       CloseDbf('SCO')
       CloseDbf('ANO')
       CloseDbf('TCO')
       CloseDbf('GRU')
       CloseDbf('MAT')
       CloseDbf('APR')
*>>>>FIN CIERRE DE LOS ARCHIVOS DEL CERTIFICADO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfCer(lShared,cPatSis,cAnoUsr,cAnoSis,cMaeAct)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       cCodigoTgr := &cMaeAct->cCodigoGru
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		      'PLAN'+SUBS(cCodigoTgr,1,2)+;
		       cAnoSis+ExtFile,'PLA',NIL,lShared)

	  cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		  ALLTRIM(SUBS('JARDIN  PRIMERO SEGUNDO TERCERO '+;
			       'CUARTO  QUINTO  SEXTO   SEPTIMO '+;
			       'OCTAVO  NOVENO  DECIMO  UNDECIMO',;
			    (VAL(SUBS(cCodigoTgr,1,2))+1)*8-7,8)))
	  CloseDbf('PLA')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
		      'NT'+cCodigoTgr+cAnoSis+ExtFile,;
		      'NOT',NIL,lShared)

	  cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		 cCodigoTgr+' DE '+cAnoUsr)

	 CloseDbf('PLA')
	 CloseDbf('NOT')
	 RETURN NIL
      ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS DATOS DEL ESTUDIANTE
      aNotAre := {}
      aNotMat := {}
      cSavPan := SAVESCREEN(0,0,24,79)
      Termometro(0,'ACCESANDO LOS DATOS DEL ESTUDIANTE DE '+cAnoUsr)
      Termometro(50)
      DetAreas(@aNotAre,@aNotMat,TCO->nTotPerTbl)
      Termometro(100)
      RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LOS DATOS DEL ESTUDIANTE

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>LOCALIZACION DEL GRUPO
       IF !lLocCodigo('cCodigoGru','GRU',&cMaeAct->cCodigoGru)
	  cError('EL GRUPO '+&cMaeAct->cCodigoGru+' NO EXISTE')

	  CloseDbf('PLA')
	  CloseDbf('NOT')
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL GRUPO

*>>>>INICIALIZACION DE VARIABLES PARA EL CERTIFICADO
       cNomEst := RTRIM(&cMaeAct->cNombreEst)+' '+;
		  RTRIM(&cMaeAct->cApelliEst)


       cFolMat := IF(EMPTY(&cMaeAct->cFolMatEst),;
		     &cMaeAct->cCodigoEst,&cMaeAct->cFolMatEst)
       cResolu := &('SCO->cRel'+cMaeAct+'Con')
       cNomNiv := GRU->cNombreGru
       cNivEdu := GRU->cNivEduGru
       cObserv := SCO->cObsCerCon
       cEspeci := ''
*>>>>FIN INICIALIZACION DE VARIABLES PARA EL CERTIFICADO

*>>>>VALIDACION DE LOS DATOS ESPECIFICOS DEL A¥O DEL CERTIFICADO
       lHayErr := .T.
       DO CASE
       CASE EMPTY(cResolu)
	    cMsgErr := 'FALTA LA RESOLUCION DE APROBACION'
       CASE EMPTY(cNomNiv)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA EL NOMBRE DEL NIVEL EN EL GRUPO'
       CASE EMPTY(cFolMat)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA EL CODIGO O FOLIO DE LA MATRICULA'
       CASE EMPTY(cNomEst)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA EL NOMBRE DEL ESTUDIANTE'
       CASE EMPTY(cDocNit)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA EL DOCUMENTO DE IDENTIDAD DEL ESTUDIANTE'
       CASE EMPTY(cLugDoc)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA EL LUGAR DEL DOCUMENTO DE IDENTIDAD DEL ESTUDIANTE'
       CASE EMPTY(cAnoUsr)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA EL A¥O PARA EL CERTIFICADO'
       CASE EMPTY(cNivEdu)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA EL NOMBRE DEL NIVEL DE EDUCACION '+;
		       'BASICA SECUNDARIA, ETC'
       CASE EMPTY(ANO->cLeyPlaCoA)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA LA RESOLUCION DEL PLAN ACADEMICO'
       OTHERWISE
	    lHayErr := .F.
       ENDCASE

       IF lHayErr
	  SET DEVICE TO SCREEN
	  cError(cMsgErr)
	  RETURN .F.
	  SET DEVICE TO PRINT
       ENDIF
*>>>>FIN VALIDACION DE LOS DATOS ESPECIFICOS DEL A¥O DEL CERTIFICADO

*>>>>LECTURA DE LA DESTINACION DEL CERTIFICADO
       IF cUsoCer == '.'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  cUsoCer := SPACE(70)
	  TitBuscar(70,@nNroFil,@nNroCol,'CERTFICADO PARA:',;
		    'USO DEL CERTIFICADO')

	  SETCURSOR(1)
	  @ nNroFil,nNroCol GET cUsoCer PICT '@S70!'
	  READ
	  SETCURSOR(0)
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
*>>>>FIN LECTURA DE LA DESTINACION DEL CERTIFICADO

*>>>>LECTURA DEL NUMERO DE COPIA
       IF EMPTY(nCopias)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nCopias := 1
	  TitBuscar(16,@nNroFil,@nNroCol,'NRO COPIAS:','DUPLICADOS')

	  SETCURSOR(1)
	  @ nNroFil,nNroCol GET nCopias PICT '99' VALID nCopias > 0
	  READ
	  SETCURSOR(0)
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>IMPRESION DEL CERTIFICADO
       bCabeza := {||CabezaCert(lShared,SCO->nLinEspCon,cNomEmp,cNomMun,;
				cNomDpt,SCO->cRegDanCon,SCO->cRegSecCon,;
				SCO->cTipColCon,SCO->cCaractCon,;
				SCO->cTipEduCon,SCO->cSecEduCon,;
				cResolu,cNomNiv,cFolMat,cNomEst,;
				cDocNit,cLugDoc,cAnoUsr,cNivEdu,;
				cJorTxt,ANO->cLeyPlaCoA,cEspeci)}

       FOR nNroCop := 1 TO nCopias
	   cSavPan := SAVESCREEN(0,0,24,79)
	   Termometro(0,'IMPRIMIENDO EL CERTIFICADO DEL GRADO '+cNomNiv)
	   Termometro(25)

	   Certifica(cNomEmp,cNomSis,cNomMun,&cMaeAct->lRetiroEst,aNotAre,;
		     aNotMat,nTotPer,lNegAre,bCabeza,SCO->lOficioCon,;
		     SCO->lValAusCon,GRU->cMinClaGru,GRU->cHorSemGru,;
		     GRU->cHorAnoGru,cObserv,cUsoCer,&cMaeAct->cFolFinEst,;
		     aFirmas)
	   RESTSCREEN(0,0,24,79,cSavPan)
       NEXT

       CloseDbf('PLA')
       CloseDbf('NOT')
       RETURN NIL
*>>>>FIN IMPRESION DEL CERTIFICADO

/*************************************************************************
* TITULO DE LA FUNCION..: OTRA HOJA DEL CERTIFICADO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/97 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   MAY 29/97 JUE

OBJETIVOS:

1- Imprime los juicios valorativos finales para cada asignatura

2- Imprime la evaluaci¢n final del estudiante.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Certifica(cNomEmp,cNomSis,cNomMun,lRetEst,aNotAre,;
		   aNotMat,nTotPer,lNegAre,bCabeza,lOficio,;
		   lValAus,cMinCla,cHorSem,cHorAno,cObserv,;
		   cUsoCer,cFolFin,aFirmas)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomMun                              // Nombre del Municipio
       lRetEst                              // .T. Estudiante retirado
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nTotPer                              // Total de periodos
       lNegAre                              // .T. En negrilla el area
       bCabeza                              // Encabezado del informe
       lOficio                              // .T. Se imprime en Oficio
       lValAus                              // Validar las Ausencias
       cMinCla                              // Minutos Clase
       cHorSem                              // Horas semanales
       cHorAno                              // Horas Anuales
       nFalAno                              // Total Ausencias del A¤o
       cFolFin                              // Folios del libro final
       aFirmas                              // Firmas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n

       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL   cNota := ''                  // Nota de area o materia
       LOCAL cIntens := ''                  // Intensidad horaria
       LOCAL nFalAno := 0                   // Total fallas del a¤o.
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL nLenLin := 0                   // Longitud en l¡neas
       LOCAL cFolios := ''                  // Folios del libro final
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONTEO DEL TOTAL DE FALLAS POR AREAS
       nFalAno := 0
       FOR i := 1 TO LEN(aNotAre)

	   IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	      cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
	      FOR k := 1 TO nTotPer
		  nFalAno += VAL(SUBS(&cCamFal,k*2-1,2))
	      NEXT
	   ENDIF

       NEXT
*>>>>FIN CONTEO DEL TOTAL DE FALLAS POR AREAS

*>>>>CONTEO DEL TOTAL DE FALLAS POR MATERIAS
       FOR i := 1 TO LEN(aNotMat)
	   cCamFal := aNotMat[i,6]
	   FOR k := 1 TO nTotPer
	       nFalAno += VAL(SUBS(&cCamFal,k*2-1,2))
	   NEXT
       NEXT
*>>>>FIN CONTEO DEL TOTAL DE FALLAS POR MATERIAS

*>>>>ACTIVACION DE LA IMPRESORA
       Termometro(50)
       IF !Printer_on()
	   SET DEVICE TO SCREEN
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ESPECIFICACION DEL TAMA¥O DEL PAPEL
       IF lOficio
	  SendCodes(CHR(27)+'C'+CHR(78))    // Tama¤o Oficio
       ELSE
	  SendCodes(CHR(27)+'C'+CHR(66))    // Tama¤o Carta
       ENDIF
*>>>>FIN ESPECIFICACION DEL TAMA¥O DEL PAPEL

*>>>>IMPRESION DE LAS NOTAS
       nTotPer := TCO->nTotPerTbl
       FOR i:=1 TO LEN(aNotAre)

***********VALIDACION DE IMPRESION
	     IF !aNotAre[i,9]  // El area se imprime en el certificado
		LOOP
	     ENDIF
***********FIN VALIDACION DE IMPRESION

***********IMPRESION DEL ENCABEZADO
	    IF lPagina
	       OtraHoja(DRAFT_ON+CONDEN_ON,;
			NEGRA_OF+DOBGOL_OF,bCabeza)
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------LECTURA DEL NOMBRE DEL AREA
		 cNomAre := aNotAre[i,10]+REPL('.',80-LEN(aNotAre[i,10]))
		 IF lNegAre
		    cNomAre := NEGRA_ON+cNomAre+NEGRA_OF
		 ENDIF
*--------------FIN LECTURA DEL NOMBRE DEL AREA

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := SUBS(&(aNotAre[i,4]),nTotPer*4-3,4)
		 DO CASE
		 CASE 'E' $ cNota
		      cNota := 'EXCELENTE   '
		 CASE 'B' $ cNota
		      cNota := 'BUENO       '
		 CASE 'I' $ cNota
		      cNota := 'INSUFICIENTE'
		 OTHERWISE
		      cNota := 'SIN NOTA    '
		 ENDCASE
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------LECTURA DE LA INTESINDAD HORARIA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
*--------------FIN LECTURA DE LA INTESINDAD HORARIA

*--------------IMPRESION DEL REGISTRO
		 @PROW()+1,00 SAY cNomAre+;
				   SPACE(04)+cNota+SPACE(09)+cIntens
*--------------FIN IMPRESION DEL REGISTRO

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > 58
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn)
		    EJECT

		    IF !EMPTY(bCabeza)
		       EVAL(bCabeza)
		      *Impresi¢n del Encabezado
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

*---------------VALIDACION DE IMPRESION
		  IF !aNotMat[j,9] // La materia se imprime en el certificado
		     LOOP
		  ENDIF
*---------------FIN VALIDACION DE IMPRESION

*---------------IMPRESION DE LA MATERIA CORRESPONDIENTE AL AREA
		  IF aNotAre[i,2] == aNotMat[j,1]

*                    LECTURA DE NOMBRE DE LA MATERIA
		       cNomMat := aNotMat[j,10]+;
				  REPL('.',80-LEN(aNotMat[j,10]))
		       IF lNegAre
			  cNomMat := NEGRA_ON+cNomMat+NEGRA_OF
		       ENDIF
*                    FIN LECTURA DE NOMBRE DE LA MATERIA

*                    LECTURA DE LA NOTA
		       cNota := SUBS(&(aNotMat[j,4]),nTotPer*4-3,4)

		       DO CASE
		       CASE 'E' $ cNota
			    cNota := 'EXCELENTE   '
		       CASE 'B' $ cNota
			    cNota := 'BUENO       '
		       CASE 'I' $ cNota
			    cNota := 'INSUFICIENTE'
		       OTHERWISE
			    cNota := 'SIN NOTA    '
		       ENDCASE
*                    FIN LECTURA DE LA NOTA

*                    LECTURA DE LA INTESINDAD HORARIA
		       IF VAL(aNotMat[j,3]) == 0
			  cIntens := SPACE(02)
		       ELSE
			  cIntens := aNotMat[j,3]
		       ENDIF
*                    FIN LECTURA DE LA INTESINDAD HORARIA

*                    IMPRESION DEL REGISTRO
		       @PROW()+1,00 SAY cNomMat+;
					SPACE(04)+cNota+SPACE(09)+cIntens
*                    FIN IMPRESION DEL REGISTRO

*                    ANALISIS PARA EL CAMBIO DE PAGINA
		       IF PROW() > 58
			  DerechosPrn(cNomSis,cNomEmp,nLenPrn)
			  EJECT

			  IF !EMPTY(bCabeza)
			     EVAL(bCabeza)
			    *Impresi¢n del Encabezado
			  ENDIF

		       ENDIF
*                    FIN ANALISIS PARA EL CAMBIO DE PAGINA

		  ENDIF
*---------------FIN IMPRESION DE LA MATERIA CORRESPONDIENTE AL AREA

	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 58 - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= 58
		DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	     ENDIF
	     EJECT
	  ENDIF
	  OtraHoja(DRAFT_ON+CONDEN_ON,;
		   NEGRA_OF+DOBGOL_OF,bCabeza)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LA OBSERVACION
       cEstado := ''
       cEstado := IF(lRetEst,'NO TERMINO',cAproboJui(NOT->nAproboNot))
      *Estado final del estudiante

       IF EMPTY(cFolFin)
	  cFolios := REPL('_',20)
       ELSE
	  cFolios := PADL(VAL(SUBS(cFolFin,1,6)),6,'0')
	  IF !EMPTY(VAL(SUBS(cFolFin,7,6)))
	     cFolios += '-'+PADL(VAL(SUBS(cFolFin,7,6)),6,'0')
	  ENDIF
       ENDIF
       @ PROW()+2,00 SAY 'EVALUACION FINAL SEGUN FOLIO(S): '+cFolios
     *ÀImpresi¢n n£mero del folio del libro final

       IF lValAus
	  @ PROW(),70 SAY 'ASISTENCIA('+cMinCla+' Min Clase):'
       ENDIF

       @ PROW()+1,00 SAY NEGRA_ON+cEstado+NEGRA_OF
       IF lValAus

	  @ PROW(),74 SAY 'SEMANALES:'+ALLTRIM(cHorSem)+SPACE(01)+;
			   'ANUALES:' +ALLTRIM(cHorAno)+SPACE(01)+;
			  'RECIBIDAS:'+STR(VAL(cHorAno)-nFalAno,4,0)
       ENDIF
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DE LA OBSERVACION
       IF !EMPTY(cObserv)
	  @ PROW()+2,00 SAY NEGRA_ON+'OBSERVACION:'+NEGRA_OF
	  SendCodes(CHR(27)+'a'+CHR(3))
	  @ PROW(),13 SAY ALLTRIM(cObserv)
	  SendCodes(CHR(27)+'a'+CHR(0))
       ENDIF
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DEL USO DEL CERTIFICADO
       IF !EMPTY(cUsoCer)
	  @ PROW()+2,00 SAY NEGRA_ON+;
			   'ESTE CERTIFICADO ES SOLICITADO PARA: '+NEGRA_OF+;
			   cUsoCer
       ENDIF
*>>>>FIN IMPRESION DEL USO DEL CERTIFICADO

*>>>>FECHA DE EXPEDICION
       @ PROW()+2,00 SAY 'SE EXPIDE EN '+cNomMun+' A LOS '+;
			 STR(DAY(DATE()),2)+' DIAS DEL MES DE '+;
			 cMes(MONTH(DATE()))+' DE '+STR(YEAR(DATE()),4)+'.'
*>>>>FIN FECHA DE EXPEDICION

*>>>>IMPRESION DE LA FIRMA
       IF LEN(aFirmas) == 1
	  cTxtPrn := 'Dir. '+aFirmas[1]
	  @ PROW()+4,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	  @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn
       ELSE
	  nLenLin := 120
	  Firmas(nLenLin,4,aFirmas)
	 *Impresi¢n firmantes del libro
       ENDIF
*>>>>FIN IMPRESION DE LA FIRMA

*>>>>IMPRESION DE LOS DERECHOS DE AUTOR
       cTxtPrn = ALLTRIM(UPPER(cNomSis))+;
		 '. AUTOR: NELSON FERNANDEZ GOMEZ. '+;
		  'Instalado para: '+ALLTRIM(UPPER(cNomEmp))

       IF (n20Stan-LEN(cTxtPrn))/2 < 0
	  cError('LA COLUMNA ES NEGATIVA EN DerechosPrn')
       ENDIF

       @ PROW(),00 SAY ELITE+CONDEN_ON
       @ PROW()+1,(n20Stan-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY CONDEN_OF+PICA

       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DERECHOS DE AUTOR

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DEL ENCABEZADO DEL CERTIFICADO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/97 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   JUL 04/97 VIE

OBJETIVOS:

1- Imprime el encabezado del certificado.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabezaCert(lShared,nLinSpa,cNomEmp,cNomMun,cNomDpt,;
		    cRegDan,cRegSec,cTipCol,cCaract,cTipEdu,;
		    cSecEdu,cResolu,cNomNiv,cFolMat,cNomEst,;
		    cDocNit,cLugDoc,cAnoUsr,cNivEdu,cJorTxt,;
		    cLeyPla,cEspeci)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nLinSpa                              // Espacios para el encabezado
       cNomEmp                              // Nombre de la Empresa
       cNomMun                              // Nombre del Municipio
       cNomDpt                              // Nombre del Departamento
       cRegDan                              // Registro del Dane
       cRegSec                              // Registro Secretaria Educaci¢n
       cTipCol                              // Tipo de Colegio
       cCaract                              // Caracter de la Educacaci¢n. Acad‚mico o T‚cnico
       cTipEdu                              // Tipo de Educaci¢n. Ej: FORMAL
       cSecEdu                              // Secretaria de Educaci¢n que aprob¢
       cResolu                              // Resoluci¢n de Aprobaci¢n
       cNomNiv			            // Nombre del Nivel
       cFolMat			            // Folio de la matricula
       cNomEst                              // Nombre del Estudiante
       cDocNit                              // Documento de Identidad
       cLugDoc                              // Lugar del Documento
       cAnoUsr                              // A¤o del Usuario
       cNivEdu			            // Nivel de Educaci¢n
       cJorTxt                              // Nombre de la Jorndad
       cLeyPla                              // Ley del plan de Estudios
       cEspeci                              // Especialidad del Estudiante */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>ASIGNACION DEL NUMERO DE LA FACTURA
       IF ANO->(lRegLock(lShared,.F.))

	  IF ANO->nNroCerCoA >= 9999999
	     SET DEVICE TO SCREEN
	     cError('SE EXCEDIO EL CONTADOR DE CERTIFICADOS')
	     SET DEVICE TO PRINT
	  ELSE
	     REPL ANO->nNroCerCoA WITH ANO->nNroCerCoA+1
	     ANO->(DBCOMMIT())
	     IF lShared
		ANO->(DBUNLOCK())
	     ENDIF
	   *ÀGrabaci¢n de n£mero asignado
	  ENDIF

       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>IMPRESION DEL ENCABEZADO DEL CERTIFICADO
       SET FIXED OFF
       SendCodes(GRAPHI_ON+CONDEN_OF+PROPOR_OF+;
		 PICA+DRAFT_OF+ROMAN_ON)

       SendCodes(CHR(27)+'Q'+CHR(75))

       @ PROW()+nLinSpa,00;
	 SAY 'CERT No.'+;
	      NEGRA_ON+PADL(ANO->nNroCerCoA,7,'0')+NEGRA_OF+;
	     ' Reg.SE:'+;
	      NEGRA_ON+cRegSec+NEGRA_OF+;
	     ' Reg.DANE:'+;
	      NEGRA_ON+cRegDan+NEGRA_OF+;
	     ' MATRICULA No:'+NEGRA_ON+PADL(VAL(cFolMat),6,'0')+NEGRA_OF

       SendCodes(CHR(27)+'a'+CHR(3))

       @ PROW()+2,00;
	 SAY 'EL RECTOR(A) Y SECRETARIA(O) DEL '+;
	      NEGRA_ON+ALLTRIM(cNomEmp)+NEGRA_OF+;
	     ' DEPARTAMENTO DE '+;
	      NEGRA_ON+cNomDpt+NEGRA_OF+;
	     ',ESTABLECIMIENTO '+;
	      NEGRA_ON+ALLTRIM(cTipCol)+NEGRA_OF+;
	     ',DE CARACTER '+;
	      NEGRA_ON+ALLTRIM(cCaract)+NEGRA_OF+;
	     ',DE EDUCACION '+;
	      NEGRA_ON+ALLTRIM(cTipEdu)+NEGRA_OF+;
	     ',APROBADO OFICIALMENTE POR '+;
	      NEGRA_ON+ALLTRIM(cSecEdu)+NEGRA_OF+;
	     ',PARA '+;
	      NEGRA_ON+ALLTRIM(cResolu)+NEGRA_OF

      SendCodes(CHR(27)+'a'+CHR(1))
      @ PROW()+2,00 SAY 'C E R T I F I C A N  Q U E:'
      SendCodes(CHR(27)+'a'+CHR(3))

      @ PROW()+2,00;
	SAY NEGRA_ON+ALLTRIM(cNomEst)+NEGRA_OF+;
	    ' con documento de identidad No. '+;
	    NEGRA_ON+ALLTRIM(cDocNit)+NEGRA_OF+;
	    ' DE '+;
	    NEGRA_ON+ALLTRIM(cLugDoc)+NEGRA_OF+;
	    ' curs¢ en este plantel en el a¤o '+;
	    NEGRA_ON+cAnoUsr+NEGRA_OF+;
	    ' en la jornada '+;
	    NEGRA_ON+cJorTxt+NEGRA_OF+;
	    ' el grado '+;
	    NEGRA_ON+ALLTRIM(cNomNiv)+NEGRA_OF+;
	    ' DE '+NEGRA_ON+ALLTRIM(cNivEdu)+NEGRA_OF+;
	    IF(EMPTY(cEspeci),'',;
	       NEGRA_ON+' EN LA ESPECIALIDAD DE '+ALLTRIM(cEspeci)+NEGRA_OF)+;
	    ',PLAN DE ESTUDIOS DE CONFORMIDAD CON '+NEGRA_ON+ALLTRIM(cLeyPla)+NEGRA_OF+;
	    ' conforme se detalla:'
      @ PROW(),00 SAY CHR(27)+'a'+CHR(0)

      SET FIXED ON
      RETURN .T.
*>>>>FIN IMPRESION DEL ENCABEZADO DEL CERTIFICADO


/*************************************************************************
* TITULO DEL PROGRAMA..: APERTURA DE LOS ARCHIVOS DEL CERTIFICADO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 18/97 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 PM   JUL 18/97 VIE

OBJETIVOS:

1- Pone en uso los archivos necesarios para el certificado.

2- Retorna .T. si existen problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseDbfCer(lShared,cPatSis,cAnoUsr,cAnoSis,cMaeAct)

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fConAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileApr,'APR',NIL,lShared)
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL DEL SISTEMA')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE APR->(RECCOUNT()) == 0
	    cError('NO EXISTEN LA TABLA DE APROBACIONES')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN .F.
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS
