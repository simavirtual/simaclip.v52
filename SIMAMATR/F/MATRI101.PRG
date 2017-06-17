/* SIMA - MATRICULA ACADEMICA

MODULO      : INSCRIPCIONES
SUBMODULO...: INSCRIPCION            MODULO No. 101

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI101.PRG                                    *
* TITULO DEL PROGRAMA..: INSCRIPCION DE CANDIDATOS                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 02/96 MAR


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite inscribir los aspirantes a ingresar en la instituci¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_101(aParam1,aParam2,aParam3,;
		   lCodEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lCodEst                              // .T. C¢digo Generado por el Sistema .F. C¢digo Generado Externamente */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀGestion Documental

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL lGrabar := .F.                 // .T. Grabar el Registro
       LOCAL lRapido := .T.                 // .T. Impresi¢n r pida
       LOCAL cObsInc := ''                  // Observaci¢n para la Inscripci¢n.

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNumeroTad := ''               // N£mero de Admision
       LOCAL cCodigoTni := ''               // Codigo del nivel
       LOCAL cNombreTes := ''               // Nombres del Aspirante
       LOCAL cApelliTes := ''               // Apellidos del Aspirante
       LOCAL lExAlumTad := .T.              // .T. ExAlumno

       LOCAL cApePadTes := ''               // Apellidos del Padre
       LOCAL cNomPadTes := ''               // Nombres del Padre
       LOCAL cApeMadTes := ''               // Apellidos de la Madre
       LOCAL cNomMadTes := ''               // Nombres de la Madre
       LOCAL cTelefnTes := ''               // Telefono de la Casa

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0101(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE INF->(RECCOUNT()) == 0
	    cError('NO SE HAN CREADO LOS INFORMES DEL SISTEMA')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE ANO->lPrnAdmAno .AND. ANO->nTipAdmAno == 0
	    cError('NO SE HA ESPECIFICADO EL NUMERO DE HOJA DE INSCRIPCION')

       CASE ANO->lPrnAdmAno .AND. ANO->nTipAdmAno > 10 .AND.;
	    ANO->nTipAdmAno # 99

	    cError('NUMERO DE HOJA DE INSCRIPCION NO HABILITADO')

       CASE ANO->nNroAdmAno == 999
	    cError('LA CAPACIDAD MAXIMA DE INSCRIPCIONES ES DE 999 CANDIDATOS',;
		   'CERRADAS LAS INSCRIPCIONES')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nPrnCerPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>VERIFICACION DE INSCRIPCIONES ABIERTAS
       IF !ANO->lHayInsAno
	  cError('Estan Cerradas las Inscripciones para '+cAnoUsr,;
		 '!Atenci¢n!')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VERIFICACION DE INSCRIPCIONES ABIERTAS

*>>>>PREGUNTA DE DECISION
       lRapido := .F.
       IF ANO->lPrnAdmAno
	  IF lPregunta('DESEA IMPRIMIR EN FORMA RAPIDA? Si No')
	     lRapido := .T.
	  ENDIF
       ENDIF
*>>>>FIN PREGUNTA DE DECISION

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 101
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<INSCRIPCIONES><INSCRIPCION>'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'MTR00101'
       AADD(aMarInf,{8,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID
       nNroDoc := 0
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'')                                 // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'NOTA: LA PRESENTE SOLICITUD NO REPRESENTA NINGUN TIPO '+;
			   'DE COMPROMISO POR PARTE DE LA INSTITUCION Y NO '+;
			   'HABRA DEVOLUCION DE DINERO')
       AADD(aObsIso,'      LA POSIBLE ASIGNACION DE CUPO DEPENDERA DE LA '+;
			   'DISPONIBILIDAD DE LOS MISMOS.')
       AADD(aObsIso,'      POR POLITICA INSTITUCIONAL, NO SE RECIBEN '+;
			   'ESTUDIANTES NUEVOS PARA LOS GRADOS UNDECIMO')

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroInf,aTitIso[1],cOpcSys,MTR->cUsrIsoMtr,;
				cCodInf,aMarInf,nNroDoc,aObsIso)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF ANO->lPrnAdmAno

	  nRegPrn := PRN->(RECNO())

	  IF MTR->lPrnArcMtr
	     SET DEVICE TO PRINT
	  ELSE
	     FilePrn := 'mtr001'
	     nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,'2',.T.,.T.,bInsIso)

	     IF EMPTY(nOpcPrn)
		RETURN NIL
	     ENDIF
	  ENDIF

       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       IF ANO->lPrnAdmAno

	  fDocPrn := 'Bases\FrmAdmXX.Txt'
	  IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
			@cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
			@fDocPrn)

	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF

	  FOR i := 1 TO LEN(aTitIso)
	      FOR j := 1 TO LEN(aMezIso)
		  aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	      ENDFOR
	  ENDFOR

	  nTotPie := 0
	  FOR i := 1 TO LEN(aPieIso)
	      IF EMPTY(aPieIso[i])
		 LOOP
	      ENDIF
	      nTotPie++
	  ENDFOR

       ENDIF
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DATOS DEL '+;
				   'ASPIRANTE PARA LA JORNADA: '+cJorTxt,22,'°')
       aTamCol := {04,02,26,26,16}
       aTitulo := {'No. ','NI','APELLIDOS ','NOMBRES ','PADRES EXALUMNOS'}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,01 SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS ASPIRANTES
       nNroFil++
       lHayErr := .F.
       DO WHILE .T.

**********INICIALIZACION DE VARIABLES
	    IF !lHayErr
	       cCodigoTni := SPACE(02)
	       cNombreTes := cSpaces('ADM','cNombreEst')
	       cApelliTes := cSpaces('ADM','cApelliEst')
	       cApePadTes := cSpaces('ADM','cApePadEst')
	       cNomPadTes := cSpaces('ADM','cNomPadEst')
	       cApeMadTes := cSpaces('ADM','cApeMadEst')
	       cNomMadTes := cSpaces('ADM','cNomMadEst')
	       cTelefnTes := cSpaces('ADM','cTelefnEst')
	    ENDIF
**********FIN INICIALIZACION DE VARIABLES

**********LECTURA DEL CODIGO DEL NIVEL
	    IF !lLeeCodNiv(nNroFil,aNroCol[2],@cCodigoTni,;
			 {||lValCodNiv(cCodigoTni,cMaeAlu)})
	       EXIT
	    ENDIF
**********FIN LECTURA DEL CODIGO DEL NIVEL

**********CONVERSION DEL NIVEL PARA GUARDERIA O JARDIN
	    IF ('JAR' $ cMaeAlu .OR. 'PRI' $ cMaeAlu) .AND.;
	       (ISALPHA(cCodigoTni) .OR. cCodigoTni == '00')
	       cCodigoTni := cConverNiv(cCodigoTni)
	    ENDIF
**********FIN CONVERSION DEL NIVEL PARA GUARDERIA O JARDIN

**********LECTURA DEL NOMBRE Y APELLIDO DEL ASPIRANTE
	    @ nNroFil,aNroCol[3] GET cApelliTes PICT "@!S26";
			  VALID cApelliTes # cSpaces('ADM','cNombreEst')
	    @ nNroFil,aNroCol[4] GET cNombreTes PICT "@!S26";
			  VALID cNombreTes # cSpaces('ADM','cNombreEst')
	    READ

	    lExAlumTad := .F.
	    IF lPregunta('No Si',nNroFil,aNroCol[5])
	       lExAlumTad := .T.
	    ENDIF
	    @ nNroFil,aNroCol[5] SAY IF(lExAlumTad,'SI','NO')
**********FIN LECTURA DEL NOMBRE Y APELLIDO DEL ASPIRANTE

**********LECTURA DE LA OBSERVACION INDIVIDUAL
	    IF ANO->lLeeObsAno
	       IF !lHayErr
		  cObsInc := ANO->cMenIncAno
	       ENDIF
	       @ ++nNroFil,aNroCol[2] GET cObsInc PICT "@S73!"
	       READ
	    ELSE
	       cObsInc := ANO->cMenIncAno
	    ENDIF
**********FIN LECTURA DE LA OBSERVACION INDIVIDUAL

**********GRABACION DE LA INFORMACION PERSONAL
	    IF ANO->lLeeInfAno
	       contacto(@cApePadTes,@cNomPadTes,;
			@cApeMadTes,@cNomMadTes,;
			@cTelefnTes)
	    ENDIF
**********FIN GRABACION DE LA INFORMACION PERSONAL

**********PREGUNTA DE DECISION
	    lHayErr := .F.
	    IF !lPregunta('DESEA GRABAR? Si No')
	       lHayErr := .T.
	       IF ANO->lLeeObsAno
		  nNroFil--
	       ENDIF
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********ASIGNACION DEL NUMERO DE INSCRIPCION
	    lGrabar := ADM->(lRegLock(lShared,.T.))
	   *Bloqueo de admisiones para grabaci¢n

	    IF lGrabar
	       IF ANO->(lRegLock(lShared,.F.))

		  cNumeroTad := STR(ANO->nNroAdmAno+1,4)
		 *Lectura del n£mero de inscripci¢n

		  REPL ANO->nNroAdmAno WITH ANO->nNroAdmAno+1
		  ANO->(DBCOMMIT())
		  IF lShared
		     ANO->(DBUNLOCK())
		  ENDIF
		*ÀGrabaci¢n de n£mero asignado
	       ENDIF
	    ENDIF
	    lCorrecion(@cNumeroTad)
	    @ IF(ANO->lLeeObsAno,nNroFil-1,nNroFil),aNroCol[1] SAY cNumeroTad
	  *ÀImpresi¢n del n£mero asignado
**********FIN ASIGNACION DEL NUMERO DE INSCRIPCION

**********ASIGNACION DEL CODIGO PARA LOS ALUMNOS NUEVOS
	    DO CASE
	    CASE cCodEmp == 'COLBOL001001' .AND. cAnoUsr == '2010'

		 cCodigoTes := '999'+SUBS(cNumeroTad,2,3)
	       *ÀColegio la Salle. Cartagena

	    CASE cCodEmp == 'COLBOL001002' .AND. cAnoUsr == '2010'

		 cCodigoTes := '999'+SUBS(cNumeroTad,2,3)
	       *ÀInst. Educ. Hno Antonio Ramos. Cartagena

	    OTHERWISE
		 IF VAL(cAnoUsr) < 2000
		    cCodigoTes := cAnoSis+cNumeroTad
		 ELSE
		    cCodigoTes := SUBS(cAnoUsr,1,1)+cAnoSis+;
				  SUBS(cNumeroTad,2,3)
		 ENDIF
	    ENDCASE
**********FIN ASIGNACION DEL CODIGO PARA LOS ALUMNOS NUEVOS

**********GRABACION DE LOS DATOS DEL ASPIRANTE
	    IF lGrabar
	       REPL ADM->cNumeroAdm WITH cNumeroTad
	       IF lCodEst
		  REPL ADM->cCodigoEst WITH cCodigoTes
	       ENDIF
	       REPL ADM->lExAlumAdm WITH lExAlumTad
	       REPL ADM->lRetiroAdm WITH .F.        // No retirado
	       REPL ADM->dFecInsAdm WITH DATE()
	       REPL ADM->lExamenAdm WITH .F.        // No Pasa el Examen
	       REPL ADM->lEntrevAdm WITH .F.        // No citado a entrevista
	       REPL ADM->cNombreEst WITH cNombreTes
	       REPL ADM->cApelliEst WITH cApelliTes
	       REPL ADM->cCodigoGru WITH IF(UPPER(cCodigoTni)=='TR','00',cCodigoTni)+'00'
	       REPL ADM->lSiCupoEst WITH .F.        // Sin Cupo
	       REPL ADM->lSiMatrESt WITH .F.        // No matriculado
	       REPL ADM->cApePadEst WITH cApePadTes
	       REPL ADM->cNomPadEst WITH cNomPadTes
	       REPL ADM->cApeMadEst WITH cApeMadTes
	       REPL ADM->cNomMadEst WITH cNomMadTes
	       REPL ADM->cTelefnEst WITH cTelefnTes

	       ADM->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       ADM->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS DATOS DEL ASPIRANTE

**********IMPRESION INFORME DEL SISTEMA
	    IF ANO->lPrnAdmAno
	       DO CASE
	       CASE cCodInf == 'MTR00101'

		    Mtr_001_01(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		   *Solicitud de Cupo por defecto

	       CASE cCodInf == 'MTR00102'

		    Mtr_001_02(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		   *Formulario del Virrey Solis

	       CASE cCodInf == 'MTR00103'

		    Mtr_001_03(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		   *Formulario de Instituto San Bernardo y la Merced

	       CASE cCodInf == 'MTR00104'

		    Mtr_001_04(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		   *Formulario con firma de Rectoria Psicoorientadora

	       CASE cCodInf == 'MTR00105'

		    Mtr_001_05(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		   *Formulario con foto,tiempo de servicio,etc

	       CASE cCodInf == 'MTR00106'

		    Mtr_001_06(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)

	       CASE cCodInf == 'MTR00107'
		    Mtr_001_07(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		   *Formulario Enfermedades y Religi¢n. Virres

	       CASE cCodInf == 'MTR00108'
		    Mtr_001_08(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		   *Formulario por Defecto alternativo

	       CASE cCodInf == 'MTR00109'
		    Mtr_001_09(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		  *ÀSugerido por el colegio la presentaci¢n.

	       CASE cCodInf == 'MTR00110'
		    Mtr_001_10(cNumeroTad,cCodigoTni,cNombreTes,cApelliTes,;
			       lExAlumTad,cNomSis,cNomEmp,cAnoUsr,lRapido,;
			       ANO->cObsUnoAno,ANO->cObsDosAno,;
			       ANO->cObsTreAno,cJorTxt,cObsInc,;
			       aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
		   *Formulario 5 con foto,modificado.

	       CASE cCodInf == 'MTR00199'
		    Mtr_001_99(ADM->cNumeroAdm,;
			       SUBS(ADM->cCodigoGru,1,2),;
			       ADM->cNombreEst,;
			       ADM->cApelliEst,;
			       ADM->lExAlumAdm,;
			       cAnoUsr,cJorTxt,;
			       cObsInc,nNroDoc)
		   *Formulario tomado de un archivo texto

	       OTHERWISE
		    cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
	       ENDCASE
	    ENDIF
**********FIN IMPRESION INFORME DEL SISTEMA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DATOS DEL '+;
					   'ASPIRANTE PARA LA JORNADA: '+;
					   cJorTxt,22,'°')
		 @ nNroFil,01 SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cNumeroTad
		 @ nNroFil,aNroCol[2] SAY cCodigoTni
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 @ nNroFil,aNroCol[4] SAY cApelliTes
		 @ nNroFil,aNroCol[5] SAY IF(lExAlumTad,'SI','NO')
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN GRABACION DE LOS ASPIRANTES


/*************************************************************************
* TITULO..: INFORMACION PARA EL CONTACTO                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 29/2003 MAR A
       Colombia, Bucaramanga        INICIO: 05:30 PM   JUL 29/2003 MAR

OBJETIVOS:

1- Permite leer la informaci¢n para el contacto

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION contacto(cApePad,cNomPad,cApeMad,cNomMad,cTelefn)

*>>>>PARAMETROS DE LA FUNCION
/*     cApePad                              // @Apellido del Padre
       cNomPad                              // @Nombre del Padre
       cApeMad                              // @Apellido de la Madre
       cNomMad                              // @Nombre de la Madre
       cTelefn                              // @Telefono de la Casa */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 1                   // N£mero de la Columna
       LOCAL GetList    := {}               // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nFilInf := nMarco(11,;
		  'POR FAVOR DIGITE LA INFORMACION PARA EL CONTACTO',22,'°')
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       nNroFil := nFilInf
       DO WHILE .T.

**********LECTURA DE LA INFORMACION PARA EL CONTACTO
	    @++nNroFil,nNroCol+00 SAY 'APELLIDOS PADRE:';
				  GET cApePad PICT "@!S20"

	    @nNroFil++,nNroCol+38 SAY 'NOMBRES PADRE:';
				  GET cNomPad PICT "@!S25"

	    @++nNroFil,nNroCol+00 SAY 'APELLIDOS MADRE:';
				  GET cApeMad PICT "@!S20"

	    @nNroFil++,nNroCol+38 SAY 'NOMBRES MADRE:';
				  GET cNomMad PICT "@!S25"

	    @nNroFil++,nNroCol+00 SAY 'TELEFONO:';
				  GET cTelefn PICT "@!9"
	    READ
**********FIN LECTURA DE LA INFORMACION PARA EL CONTACTO

**********PREGUNTA DE DECISION
	    IF lPregunta('DESEA CORREGIR? No Si')
	       nNroFil := nFilInf
	       LOOP
	    ELSE
	       EXIT
	    ENDIF
**********FIN PREGUNTA DE DECISION

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN LECTURA Y GRABACION DE LA HOJA DE VIDA

