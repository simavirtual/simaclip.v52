/*                       SIMA - CONTABILIDAD ACADEMICA
	  BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE CONSTANCIAS

REQUERIMIENTOS:

- Compilar: clipper FuncsCns /w/m/b

OBJETIVOS:

- Funciones aplicadas para los difirentes dise¤os de las Constancias


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CONSTANCIA DE ESTUDIO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 23/97 MIE A
       Colombia, Bucaramanga        INICIO: 01:25 PM   JUL 23/97 MIE

OBJETIVOS:

1- Imprime las constancias de estudio.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Constan01(lShared,cNomSis,cNomEmp,cNomDpt,cNomMun,;
		   cAnoUsr,cPatSis,cMaeAct,cJorTxt,cDocNit,;
		   cLugDoc,cObsEst,cUsoCer,aFirmas,nCopias)

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
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // Path del sistemas
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL       i := 0                   // Contador
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

       LOCAL cDiscip := ''                  // Asignatura de Disciplina
       LOCAL cJuiVal := ''                  // Juicio Valorativo

       LOCAL cNomEst := ''                  // Nombre del Estudiante
       LOCAL lRetEst := .F.                 // .T. Estudiante Retirado
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

*>>>>LOCALIZACION DEL JUICIO VALORATIVO DE LA DISCIPLINA
       cDiscip := ''
       cJuiVal := ''
       IF SUBS(GRU->cMatDisGru,3,2) # '00'

	  FOR i := 1 TO LEN(aNotMat)

	    IF SUBS(aNotMat[i][4],8,4) == GRU->cMatDisGru
	       cDiscip := aNotAre[i,10]
	       cJuiVal := SUBS(&(aNotMat[i,4]),nTotPer*4-3,4)
	       EXIT
	    ENDIF

	  NEXT

       ELSE

	  FOR i := 1 TO LEN(aNotAre)

	    IF SUBS(aNotAre[i][4],7,6) == 'AREN'+SUBS(GRU->cMatDisGru,1,2)
	       cDiscip := aNotAre[i,10]
	       cJuiVal := SUBS(&(aNotAre[i,4]),nTotPer*4-3,4)
	       EXIT
	    ENDIF

	  NEXT
       ENDIF

       IF EMPTY(cDiscip) .OR. EMPTY(cJuiVal)

	  cError('NO SE HA ESPECIFICADO EN EL GRUPO '+;
		 'EL CODIGO DE LA MATERIA DE LA DISCIPLINA')

	  CloseDbf('PLA')
	  CloseDbf('NOT')
	  RETURN NIL
       ENDIF
       cDiscip := ALLTRIM(cDiscip)
*>>>>FIN LOCALIZACION DEL JUICIO VALORATIVO DE LA DISCIPLINA

*>>>>INICIALIZACION DE VARIABLES PARA EL CERTIFICADO
       cNomEst := RTRIM(&cMaeAct->cNombreEst)+' '+;
		  RTRIM(&cMaeAct->cApelliEst)
       lRetEst := &cMaeAct->lRetiroEst

       cFolMat := IF(EMPTY(&cMaeAct->cFolMatEst),;
		     &cMaeAct->cCodigoEst,&cMaeAct->cFolMatEst)
       cResolu := &('SCO->cRel'+cMaeAct+'Con')
       cNomNiv := GRU->cNombreGru
       cNivEdu := GRU->cNivEduGru
       cObserv := ALLTRIM(SCO->cObsCerCon)
       cEspeci := ''
*>>>>FIN INICIALIZACION DE VARIABLES PARA EL CERTIFICADO

*>>>>VALIDACION DE LOS DATOS ESPECIFICOS DEL A¥O DEL CERTIFICADO
       lHayErr := .T.
       DO CASE
       CASE EMPTY(cResolu)
	    cMsgErr := 'FALTA LA RESOLUCION DE APROBACION'
       CASE EMPTY(cNomNiv)
	    cMsgErr := 'PARA '+cAnoUsr+' '+;
		       'FALTA EL NOMBRE DEL NIVEL'
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
	  cError(cMsgErr)
	  RETURN NIL
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

*>>>>LECTURA DE LA OBSERVACION DEL ESTUDIANTE
       IF cObsEst == '.'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  cObsEst := SPACE(150)
	  TitBuscar(70,@nNroFil,@nNroCol,'OBSERVACION:',;
		    'OBSERVACION PARA EL ESTUDIANTE')

	  SETCURSOR(1)
	  @ nNroFil,nNroCol GET cObsEst PICT '@S70!'
	  READ
	  SETCURSOR(0)
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       cObserv += '. '+cObsEst
*>>>>FIN LECTURA DE LA OBSERVACION DEL ESTUDIANTE

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

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseDbf('PLA')
	  CloseDbf('NOT')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL CERTIFICADO
       FOR nNroCop := 1 TO nCopias
	   cSavPan := SAVESCREEN(0,0,24,79)
	   Termometro(0,'IMPRIMIENDO EL CERTIFICADO DEL GRADO '+cNomNiv)
	   Termometro(25)

	   Consta(lShared,SCO->nLinEspCon,cNomSis,cNomEmp,;
		  cNomMun,cNomDpt,SCO->cRegDanCon,;
		  SCO->cRegSecCon,SCO->cTipColCon,;
		  SCO->cCaractCon,SCO->cTipEduCon,;
		  SCO->cSecEduCon,cResolu,cNomNiv,;
		  cFolMat,cNomEst,cDocNit,cLugDoc,;
		  lRetEst,cAnoUsr,cNivEdu,cJorTxt,;
		  GRU->cEntSalGru,ANO->cLeyPlaCoA,;
		  cEspeci,SCO->lOficioCon,cObserv,;
		  cUsoCer,cDiscip,cJuiVal,aFirmas)


	   RESTSCREEN(0,0,24,79,cSavPan)
       NEXT

       CloseDbf('PLA')
       CloseDbf('NOT')
       RETURN NIL
*>>>>FIN IMPRESION DEL CERTIFICADO

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DEL ENCABEZADO DEL CERTIFICADO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 23/97 MIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUL 23/97 MIE

OBJETIVOS:

1- Imprime la constancia

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Consta(lShared,nLinSpa,cNomSis,cNomEmp,cNomMun,cNomDpt,;
		cRegDan,cRegSec,cTipCol,cCaract,cTipEdu,cSecEdu,;
		cResolu,cNomNiv,cFolMat,cNomEst,cDocNit,cLugDoc,;
		lRetEst,cAnoUsr,cNivEdu,cJorTxt,cHorGru,cLeyPla,;
		cEspeci,lOficio,cObserv,cUsoCer,cDiscip,cJuiVal,;
		aFirmas)

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
       cEspeci                              // Especialidad del Estudiante
       lOficio                              // .T. Se imprime en Oficio */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "\EPSONFX.PRG"

       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
       LOCAL nLenLin := 0                   // Longitud en l¡neas
       LOCAL cEstado := ''                  // Estado final del estudiante
       LOCAL cHorari := ''                  // Horario
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       Termometro(50)
       IF !Printer_on()
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

*>>>>DOCUMENTACION DEL JUICIO VALORATIVO
       DO CASE
       CASE 'E' $ cJuiVal
	    cJuiVal := 'EXCELENTE'
       CASE 'B' $ cJuiVal
	    cJuiVal := 'BUENO'
       CASE 'I' $ cJuiVal
	    cJuiVal := 'INSUFICIENTE'
       OTHERWISE
	    cJuiVal := 'SIN NOTA'
       ENDCASE
*>>>>FIN DOCUMENTACION DEL JUICIO VALORATIVO

*>>>>HORARIO DE ASISTENCIA
      cHorari := ''
      IF !EMPTY(cHorGru)

	 cHorari := cHora(SUBS(cHorGru,1,5))+' a '+;
		    cHora(SUBS(cHorGru,6,10))
       *ÀHorario de la primera jornada

	 IF SUBS(cHorGru,11,20) # '  :    :  '
	    cHorari += ' y de '+;
		       cHora(SUBS(cHorGru,11,15))+' a '+;
		       cHora(SUBS(cHorGru,16,20))
	 ENDIF
       *ÀHorario de la segunda jornada

      ENDIF
*>>>>FIN HORARIO DE ASISTENCIA

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
	 SAY 'CONS No.'+;
	      NEGRA_ON+PADL(ANO->nNroCerCoA,7,'0')+NEGRA_OF+;
	     ' Reg.SE:'+;
	      NEGRA_ON+cRegSec+NEGRA_OF+;
	     ' Reg.DANE:'+;
	      NEGRA_ON+cRegDan+NEGRA_OF

       SendCodes(CHR(27)+'a'+CHR(3))

       @ PROW()+2,00;
	 SAY 'EL RECTOR(A) Y SECRETARIA(O) DEL '+;
	      NEGRA_ON+ALLTRIM(cNomEmp)+NEGRA_OF+;
	     ',DEPARTAMENTO DE '+;
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
      @ PROW()+2,00 SAY 'H A C E  C O N S T A R  Q U E:'
      SendCodes(CHR(27)+'a'+CHR(3))

      @ PROW()+2,00;
	SAY NEGRA_ON+ALLTRIM(cNomEst)+NEGRA_OF+;
	    ' con documento de identidad No. '+;
	    NEGRA_ON+ALLTRIM(cDocNit)+NEGRA_OF+;
	    ' DE '+;
	    NEGRA_ON+ALLTRIM(cLugDoc)+NEGRA_OF+;
	    IF (VAL(cAnoUsr) # YEAR(DATE()),;
		',curs¢ '+IF(lRetEst,;
			     NEGRA_ON+'Y NO TERMINO '+NEGRA_OF,;
			     NEGRA_ON+'Y TERMINO '+NEGRA_OF)+;
		'en este plantel en el a¤o '+;
		NEGRA_ON+cAnoUsr+NEGRA_OF,;
		',en '+NEGRA_ON+cAnoUsr+NEGRA_OF+' est  matriculado(a)')+;
	    ' en la jornada '+;
	    NEGRA_ON+cJorTxt+NEGRA_OF+;
	    IF(EMPTY(cHorari),'',;
	       ',en el horario de '+NEGRA_ON+cHorari+NEGRA_OF)+;
	    ',el grado '+;
	    NEGRA_ON+ALLTRIM(cNomNiv)+NEGRA_OF+;
	    ' DE '+NEGRA_ON+ALLTRIM(cNivEdu)+NEGRA_OF+;
	    IF(EMPTY(cEspeci),'',;
	       NEGRA_ON+' EN LA ESPECIALIDAD DE '+ALLTRIM(cEspeci)+NEGRA_OF)+;
	    ',PLAN DE ESTUDIOS DE CONFORMIDAD CON '+;
	    NEGRA_ON+ALLTRIM(cLeyPla)+NEGRA_OF+;
	    IF(lRetEst,'.',;
	       ',SU '+NEGRA_ON+cDiscip+NEGRA_OF+;
	       ' ES '+NEGRA_ON+cJuiVal+NEGRA_OF+'.')

      @ PROW(),00 SAY CHR(27)+'a'+CHR(0)
       SendCodes(DRAFT_ON+CONDEN_ON)
*>>>>FIN IMPRESION DEL ENCABEZADO DEL CERTIFICADO

*>>>>IMPRESION DE LA OBSERVACION
       IF !lRetEst
	  cEstadoz := cAproboJui(NOT->nAproboNot)
	 *Estado final del estudiante

	  @ PROW()+2,00 SAY 'EVALUACION FINAL: '
	*ÀImpresi¢n n£mero del folio del libro final

	  @ PROW()+1,00 SAY NEGRA_ON+cEstado+NEGRA_OF
       ENDIF
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DE LA OBSERVACION
       IF !EMPTY(cObserv)
	  @ PROW()+2,00 SAY 'OBSERVACION:'
	  SendCodes(CHR(27)+'a'+CHR(3))
	  @ PROW(),00 SAY NEGRA_ON+ALLTRIM(cObserv)+NEGRA_OF
	  SendCodes(CHR(27)+'a'+CHR(0))
       ENDIF
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DEL USO DEL CERTIFICADO
       IF !EMPTY(cUsoCer)
	  @ PROW()+2,00 SAY 'ESTE CERTIFICADO ES SOLICITADO PARA: '+;
			    NEGRA_ON+cUsoCer+NEGRA_OF
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
		 '. AUTOR: NELSON FERNANDEZ GOMEZ. TELS: 6422972-932775212 '+;
		  'Instalado para: '+ALLTRIM(UPPER(cNomEmp))

       IF (n20Stan-LEN(cTxtPrn))/2 < 0
	  cError('LA COLUMNA ES NEGATIVA EN DerechosPrn')
       ENDIF

       @ PROW(),00 SAY ELITE+CONDEN_ON
       @ PROW()+3,(n20Stan-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY CONDEN_OF+PICA

       SET FIXED ON
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DERECHOS DE AUTOR