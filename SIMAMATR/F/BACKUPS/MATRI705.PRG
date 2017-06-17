/* SIMA - MATRICULA ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: MATRICULAS FAC

**************************************************************************
* TITULO..: MATRICULAS DE LOS ESTUDIANTES. OTRA FACTURACION              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 31/2010 LUN A
       Colombia, Bucaramanga        INICIO: 09:00 AM   ENE 31/2010 LUN

OBJETIVOS:

1- Permite matricular a los estudiantes con fines de otra facturaci¢n.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_705(aParam1,aParam2,aParam3,;
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
       #INCLUDE "EPSONFX.PRG"

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lErrUno := .F.                 // Error Archivos Compartidos Uno
       LOCAL lErrDos := .F.                 // Error Archivos Compartidos Dos
       LOCAL lErrTre := .F.                 // Error Archivos Compartidos Tres
       LOCAL lErrCua := .F.                 // Error Archivos Compartidos Cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL     i,j := 0                   // Contadores
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
     *ÀGestion Documental

       LOCAL lMensaj := .T.
       LOCAL lPatSis := .F.                 // .T. Incluir Path del Sistema
       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cMsgTxt := ''                  // Variable de texto
       LOCAL aDatCnt := {}                  // Datos del Contratante

       LOCAL lNuevos := .F.                 // .T. Matricula para nuevos
       LOCAL lMatric := .F.                 // Matr¡cula del estudiante
       LOCAL lGrabar := .F.                 // .T. Grabar el registro
       LOCAL lDuplic := .F.                 // .T. Duplicar hoja matricula

       LOCAL cNalias := ''                  // Alias Antiguos o nuevos
       LOCAL cAliasN := ''                  // Alias para matricular
       LOCAL cObserv := ''                  // Observaci¢n para la matr¡cula
       LOCAL cNivPro := ''                  // Nivel de Procedencia
       LOCAL cCamPro := ''                  // Campo de Procedencia
       LOCAL cNivel  := ''                  // Nivel
       LOCAL cColegi := ''                  // Nombre del Colegio
       LOCAL cCiudad := ''                  // Ciudad del Colegio

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL dFecMatTes := CTOD('00/00/00') // Fecha de la Matr¡cula
       LOCAL cHorMatTes := ''               // Hora de la Matr¡cula
       LOCAL cCodigoTgr := ''               // C¢digo del grupo

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

       LOCAL PathAlu := ''                  // Paht de Alumno
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

*>>>>VALIDACION DEL PATH
       lHayErr := .T.
       DO CASE
       CASE EMPTY(PathCua)
	    cError('NO ESTA CONFIGURADA LAS MATRICULAS FAC')

       CASE UPPER(ALLTRIM(PathUno)) == UPPER(ALLTRIM(PathCua))
	    cError('MAL CONFIGURADO EL PATH.IGUALES')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL PATH

*>>>>VISUALIZACION DE LA FECHA
       FecHorSys(cNomSis)
       SETKEY(K_F10,{||LeerFecHora(cNomSis)})
       cError('LA TECLA <F10> PERMITE MODIFICAR',;
	      'POR FAVOR REVISE LA FECHA Y HORA')
*>>>>FIN VISUALIZACION DE LA FECHA

*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS
       lNuevos := .F.
*>>>>FIN SELECCION DE ALUMNOS NUEVOS O ANTIGUOS

*>>>>SELECION DEL A¥O ANTERIOR
       IF !lNuevos
	  cAnoAnt := cAnoUsr
	  cPatAnt := cPatSis
	  cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	  cPatAnt := PathCua+'\'+cPatAnt
       ELSE
	  cAnoAnt := cAnoUsr
       ENDIF
       PathAlu := PathUno+'\'+cPatSis
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lHayErr := .F.
       DO CASE
       CASE lNuevos
	    IF !lUseDbf(.T.,cPatSis+'\'+;
			FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
	       lHayErr := .T.
	    ENDIF
       CASE !lNuevos
	    IF !lUseMaeMtr(lShared,cPatAnt,cMaeAlu,;
			   SUBS(cAnoAnt,3,2),!lAnoAct)
	       lHayErr := .T.
	    ENDIF

       ENDCASE
       IF lHayErr
	  cError("ABRIENDO ARCHIVOS EN "+IF(lNuevos,"NUEVOS","ANTIGUOS"))
	  CLOSE ALL
	  RETURN NIL
       ENDIF

       IF !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+;
		       FilePer,'PER',NIL,lShared)                  .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared)      .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)      .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared)      .OR.;
	  !lUseMaeMtr(lShared,PathAlu,cMaeAlu,cAnoSis,lAnoAct) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileCnt+ExtFile,'CNT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS EN MATRICULAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE EMPTY(MTR->cNomEmpMtr)
	    cError('NO SE HA ESPECIFICADO EL NOMBRE DEL COLEGIO')

       CASE EMPTY(MTR->cCiuEmpMtr)
	    cError('NO SE HA ESPECIFICADO LA CIUDAD DEL COLEGIO')

       CASE ANO->nTipMtrAno == 0
	    cError('NO SE HA ESPECIFICADO EL NUMERO DE LA HOJA DE MATRICULA')

       CASE EMPTY(ANO->cObsMtrAno)
	    cError('NO SE HA ESPECIFICADO LA OBSERVACION DE LA HOJA DE MATRICULA')

       CASE lNuevos .AND. ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')
/*
       CASE !lNuevos .AND. 'JAR' $ cMaeAlu .AND. JAA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoAnt)

       CASE !lNuevos .AND. 'PRI' $ cMaeAlu .AND. PRA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoAnt)

       CASE !lNuevos .AND. 'BTO' $ cMaeAlu .AND. BTA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoAnt)
*/
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VERIFICACION DE INSCRIPCIONES ABIERTAS
       IF !ANO->lHayMtrAno
	  cError('Estan Cerradas las Matriculas para '+cAnoUsr,;
		 '!Atenci¢n!')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VERIFICACION DE INSCRIPCIONES ABIERTAS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 601
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<MATRICULAS><MATRICULAS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'')                                 // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

*      cPiePag := ALLTRIM(SCO->cPiePagCon)
       cPiePag := ''
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'MATRICULAS DE ALUMNOS '+IF(lNuevos,'NUEVOS ',;
			   'ANTIGUOS '),22,'°')
       nNroCol := 1

       cMsgTxt := cRegPrint({'CODIGO',;
			     'NOMBRE',;
			     'ENTRA A ',;
			     'MATRICULA '},;
			     {06,52,08,10},@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF ANO->lPrnMtrAno

	  IF MTR->lPrnArcMtr
	     SET DEVICE TO PRINT
	  ELSE
	     FilePrn := 'mtr601'
	     nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,'2',.F.,.F.)
	     IF EMPTY(nOpcPrn)
		CloseAll()
		RETURN NIL
	     ENDIF
	     @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
	  ENDIF

       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
*	  cCodIso := 'ISO:'+cCodIso
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
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>ACTUALIZACION DE LOS DATOS DEL ESTUDIANTE
       nNroFil++
       DO WHILE .T.

**********CAPTURA DEL CODIGO DEL ESTUDIANTE
	    SET DEVICE TO SCREEN

	    cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)
	    cCodigoTes := IF(lNuevos,SPACE(04),SPACE(06))

	    DO CASE
	    CASE lNuevos
		 cNalias := 'ADM'
		 IF lLeeCodAdm(nNroFil,aNroCol[1],;
			       @cCodigoTes,{||lLocCodigo('cNumeroAdm',;
					      'ADM',cCodigoTes,;
					      'NUMERO DE INSCRIPCION')})
		     EXIT
		 ENDIF

	    CASE !lNuevos
		 cCodigoTes := cCodEstMtr(nNroFil,aNroCol[1],;
					  cMaeAlu,@cMaeAct,!lAnoAct)
		    cNalias := cMaeAct
	    ENDCASE

	    IF LASTKEY() == K_ESC .OR. EMPTY(cCodigoTes) .OR.;
	       EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := ALLTRIM(RTRIM(&cNalias->cApelliEst)+' '+;
				  &cNalias->cNombreEst)
**********FIN CAPTURA DEL CODIGO DEL ESTUDIANTE

**********SELECCION DE COLEGIO DE PROCEDENCIA
	    cNivPro := SUBS(&cNalias->cCodigoGru,1,2)
	    DO CASE
	    CASE VAL(cNivPro) >= 12 .AND. VAL(cNivPro) <= 16
		 cCamPro := 'cCOLE'+cNivPro+'Est'

	    CASE VAL(cNivPro) >= 0 .AND. VAL(cNivPro) <= 5
		 cCamPro := 'cCOLE'+cNivPro+'Est'

	    OTHERWISE
		 cCamPro := 'cCOLE'+cNivPro+'Est'
	    ENDCASE
**********FIN SELECCION DE COLEGIO DE PROCEDENCIA


**********VALIDACION DEL CODIGO
	    DO CASE
	    CASE lNuevos .AND. &cNalias->lRetiroAdm

		 cError(cNombreTes+ 'ESTA RETIRADO')
		 LOOP

	    ENDCASE
**********FIN VALIDACION DEL CODIGO

/*
**********VALIDACION DE LOS CONTRATANTES
	    aDatCnt := {}
	    aDatCnt := aLocAllCnt(cNalias)
	    IF ANO->lHayCntAno
	       IF LEN(aDatCnt) == 0
		  cError('NO EXISTEN CONTRATANTES GRABADOS')
		  LOOP
	       ENDIF
	    ENDIF
**********FIN VALIDACION DE LOS CONTRATANTES
*/

**********ANALISIS DEL GRUPO
	    cCodigoTgr := &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY SUBS(cCodigoTgr,1,2)

	    IF ANO->lValGruAno
	       IF VAL(SUBS(cCodigoTgr,3,2)) == 0
		  cError('EL ESTUDIANTE NO TIENE ASIGNADO UN GRUPO')
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL GRUPO

**********IMPRESION DE LOS DETALLES DE LA MATRICULA
	    SAVE SCREEN
	    DetalleMat(IF(lNuevos,ADM->cNumeroAdm,&cNalias->cCodigoEst),;
		       VAL(SUBS(cCodigoTgr,1,2)),;
		       &cNalias->cNombreEst,;
		       &cNalias->cApelliEst,;
		       &cNalias->cLugNacEst,;
		       &cNalias->dFecNacEst,;
		       &cNalias->cDocNitEst,;
		       &cNalias->cLugNitEst,;
		       &cNalias->cDireccEst,;
		       &cNalias->cBarrioEst,;
		       &cNalias->cTelefnEst,;
		       RTRIM(&cNalias->cApePadEst)+' '+;
		       RTRIM(&cNalias->cNomPadEst),;
		       &cNalias->cPadNitEst,;
		       &cNalias->cPadLugEst,;
		       &cNalias->cProPadEst,;
		       &cNalias->cEmpPadEst,;
		       &cNalias->cCarPadEst,;
		       &cNalias->cTelPadEst,;
		       RTRIM(&cNalias->cApeMadEst)+' '+;
		       RTRIM(&cNalias->cNomMadEst),;
		       &cNalias->cMadNitEst,;
		       &cNalias->cMadLugEst,;
		       &cNalias->cProMadEst,;
		       &cNalias->cEmpMadEst,;
		       &cNalias->cCarMadEst,;
		       &cNalias->cTelMadEst,;
		       RTRIM(&cNalias->cApeAcuEst)+' '+;
		       RTRIM(&cNalias->cNomAcuEst),;
		       &cNalias->cAcuNitEst,;
		       &cNalias->cAcuLugEst,;
		       &cNalias->cTe1AcuEst,;
		       &cNalias->cTe2AcuEst)
**********FIN IMPRESION DE LOS DETALLES DE LA MATRICULA

**********ASIGNACION DEL CODIGO PARA LOS ALUMNOS NUEVOS
	    IF lNuevos
	       IF lCodEst
		  IF VAL(cAnoUsr) < 2000
		     cCodigoTes := cAnoSis+cCodigoTes
		  ELSE
		     cCodigoTes := SUBS(cAnoUsr,1,1)+cAnoSis+;
				   SUBS(cCodigoTes,2,3)
		  ENDIF

		  IF cCodigoTes # ADM->cCodigoEst
		    cCodigoTes := ADM->cCodigoEst
		  ENDIF
		*ÀAdicionado para inscribir alumnos antiguos

	       ELSE
		  cCodigoTes := ADM->cCodigoEst
		  IF EMPTY(ADM->cCodigoEst)
		     cError('EL ESTUDIANTE NO TIENE ASIGNADO EL CODIGO')
		     RESTORE SCREEN
		     LOOP
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ASIGNACION DEL CODIGO PARA LOS ALUMNOS NUEVOS

**********VALIDACION DEL CODIGO A MATRICULAR
	    lMatric := .F.
	    lDuplic := .F.
	    cAliasN := cAliasNiv(VAL(SUBS(cCodigoTgr,1,2)),lAnoAct)

	    IF lCodMaeMtr(cCodigoTes,cMaeAlu,cAliasN,lAnoAct,!lMensaj)

	       cError(ALLTRIM(RTRIM(&cAliasN->cApelliEst)+' '+;
		      &cAliasN->cNombreEst)+ ' YA ESTA MATRICULADO')
	       RESTORE SCREEN
	       LOOP

*--------------PREGUNTA DE DECISION
		 IF lPregunta('DESEA VOLVER A MATRICULAR EL ESTUDIANTE? No Si')
		    lMatric := .T.
		    lGrabar := .F.
		 ELSE
		    IF ANO->lPrnMtrAno .AND.;
		       lPregunta('DESEA IMPRIMIR UNA COPIA DE LA HOJA '+;
				 'DE MATRICULA? Si No')
		       lDuplic := .T.
		    ENDIF
		 ENDIF
*--------------FIN PREGUNTA DE DECISION

	    ELSE

*--------------PREGUNTA DE DECISION
		 IF lPregunta('DESEA MATRICULAR AL ESTUDIANTE? Si No')
		    lMatric := .T.
		    lGrabar := .T.
		 ENDIF
*--------------FIN PREGUNTA DE DECISION

	    ENDIF
**********FIN VALIDACION DEL CODIGO A MATRICULAR

**********LECTURA DE LAS OBSERVACIONES PARA LA MATRICULA
	    IF lMatric .OR. lDuplic
	       cObserv := SPACE(65)
	       DO WHILE .T.
		  @ 21,01 SAY "OBSERVACION:" GET cObserv PICT "@!X"
		  READ
		  IF !EMPTY(cObserv)
		     IF lPregunta('DESEA CORREGIR LA OBSERVACION? No Si')
			LOOP
		     ELSE
			EXIT
		     ENDIF
		  ELSE
		     EXIT
		  ENDIF
	       ENDDO
	    ENDIF
**********FIN LECTURA DE LAS OBSERVACIONES PARA LA MATRICULA

**********INCLUSION DEL REGISTRO EN BLANCO EN NUEVOS
	    IF lMatric .AND. !lDuplic
	       SELECT &cAliasN
	       lGrabar := lRegLock(lShared,lGrabar)
	    ENDIF
**********FIN INCLUSION DEL REGISTRO EN BLANCO EN NUEVOS

**********GRABACION DE LA MATRICULA
	    DO CASE
	    CASE lMatric .AND. !lDuplic
		 IF lGrabar
		    SELECT &cAliasN
		    REPL &cAliasN->cCodigoEst WITH cCodigoTes
		    REPL &cAliasN->cPasWorEst WITH cCodigoTes
		    REPL &cAliasN->lRetiroEst WITH .F.
		    REPL &cAliasN->cCodigoGru WITH cCodigoTgr
		    REPL &cAliasN->nNomFacEst WITH &cNalias->nNomFacEst
		    REPL &cAliasN->cApelliEst WITH &cNalias->cApelliEst
		    REPL &cAliasN->cNombreEst WITH &cNalias->cNombreEst
		    REPL &cAliasN->cParNitEst WITH &cNalias->cParNitEst
		    REPL &cAliasN->dFecNacEst WITH &cNalias->dFecNacEst
		    REPL &cAliasN->cLugNacEst WITH &cNalias->cLugNacEst
		    REPL &cAliasN->cDocNitEst WITH &cNalias->cDocNitEst
		    REPL &cAliasN->cLugNitEst WITH &cNalias->cLugNitEst
		    REPL &cAliasN->cTipNitEst WITH &cNalias->cTipNitEst
		    REPL &cAliasN->lSexFemEst WITH &cNalias->lSexFemEst
		    REPL &cAliasN->cDireccEst WITH &cNalias->cDireccEst
		    REPL &cAliasN->cBarrioEst WITH &cNalias->cBarrioEst
		    REPL &cAliasN->cCiudadEst WITH &cNalias->cCiudadEst
		    REPL &cAliasN->cTelefnEst WITH &cNalias->cTelefnEst
		    REPL &cAliasN->cTelCelEst WITH &cNalias->cTelCelEst
		    REPL &cAliasN->cMaiEstEst WITH &cNalias->cMaiEstEst
		    REPL &cAliasN->nEstratEst WITH &cNalias->nEstratEst
		    REPL &cAliasN->cNomEpsEst WITH &cNalias->cNomEpsEst
		    REPL &cAliasN->cGrupRhEst WITH &cNalias->cGrupRhEst

		    REPL &cAliasN->cApePadEst WITH &cNalias->cApePadEst
		    REPL &cAliasN->cNomPadEst WITH &cNalias->cNomPadEst
		    REPL &cAliasN->lPadQepEst WITH &cNalias->lPadQepEst
		    REPL &cAliasN->dNacPadEst WITH &cNalias->dNacPadEst
		    REPL &cAliasN->cLugPadEst WITH &cNalias->cLugPadEst
		    REPL &cAliasN->cPadNitEst WITH &cNalias->cPadNitEst
		    REPL &cAliasN->cPadLugEst WITH &cNalias->cPadLugEst
		    REPL &cAliasN->cPadTntEst WITH &cNalias->cPadTntEst
		    REPL &cAliasN->lPadFotEst WITH &cNalias->lPadFotEst
		    REPL &cAliasN->cProPadEst WITH &cNalias->cProPadEst
		    REPL &cAliasN->cEmpPadEst WITH &cNalias->cEmpPadEst
		    REPL &cAliasN->cCarPadEst WITH &cNalias->cCarPadEst
		    REPL &cAliasN->cDirPadEst WITH &cNalias->cDirPadEst
		    REPL &cAliasN->cBarPadEst WITH &cNalias->cBarPadEst
		    REPL &cAliasN->cCiuPadEst WITH &cNalias->cCiuPadEst
		    REPL &cAliasN->cTelPadEst WITH &cNalias->cTelPadEst
		    REPL &cAliasN->cCelPadEst WITH &cNalias->cCelPadEst
		    REPL &cAliasN->cFaxPadEst WITH &cNalias->cFaxPadEst
		    REPL &cAliasN->cBipPadEst WITH &cNalias->cBipPadEst
		    REPL &cAliasN->cMaiPadEst WITH &cNalias->cMaiPadEst

		    REPL &cAliasN->cApeMadEst WITH &cNalias->cApeMadEst
		    REPL &cAliasN->cNomMadEst WITH &cNalias->cNomMadEst
		    REPL &cAliasN->lMadQepEst WITH &cNalias->lMadQepEst
		    REPL &cAliasN->dNacMadEst WITH &cNalias->dNacMadEst
		    REPL &cAliasN->cLugMadEst WITH &cNalias->cLugMadEst
		    REPL &cAliasN->cMadNitEst WITH &cNalias->cMadNitEst
		    REPL &cAliasN->cMadLugEst WITH &cNalias->cMadLugEst
		    REPL &cAliasN->lMadFotEst WITH &cNalias->lMadFotEst
		    REPL &cAliasN->cMadTntEst WITH &cNalias->cMadTntEst
		    REPL &cAliasN->cProMadEst WITH &cNalias->cProMadEst
		    REPL &cAliasN->cEmpMadEst WITH &cNalias->cEmpMadEst
		    REPL &cAliasN->cCarMadEst WITH &cNalias->cCarMadEst
		    REPL &cAliasN->cDirMadEst WITH &cNalias->cDirMadEst
		    REPL &cAliasN->cBarMadEst WITH &cNalias->cBarMadEst
		    REPL &cAliasN->cCiuMadEst WITH &cNalias->cCiuMadEst
		    REPL &cAliasN->cTelMadEst WITH &cNalias->cTelMadEst
		    REPL &cAliasN->cCelMadEst WITH &cNalias->cCelMadEst
		    REPL &cAliasN->cFaxMadEst WITH &cNalias->cFaxMadEst
		    REPL &cAliasN->cBipMadEst WITH &cNalias->cBipMadEst
		    REPL &cAliasN->cMaiMadEst WITH &cNalias->cMaiMadEst

		    REPL &cAliasN->cApeAcuEst WITH &cNalias->cApeAcuEst
		    REPL &cAliasN->cNomAcuEst WITH &cNalias->cNomAcuEst
		    REPL &cAliasN->cAcuNitEst WITH &cNalias->cAcuNitEst
		    REPL &cAliasN->cAcuLugEst WITH &cNalias->cAcuLugEst
		    REPL &cAliasN->cAcuTntEst WITH &cNalias->cAcuTntEst
		    REPL &cAliasN->lAcuFotEst WITH &cNalias->lAcuFotEst
		    REPL &cAliasN->cProAcuEst WITH &cNalias->cProAcuEst
		    REPL &cAliasN->cEmpAcuEst WITH &cNalias->cEmpAcuEst
		    REPL &cAliasN->cCarAcuEst WITH &cNalias->cCarAcuEst
		    REPL &cAliasN->cDirAcuEst WITH &cNalias->cDirAcuEst
		    REPL &cAliasN->cBarAcuEst WITH &cNalias->cBarAcuEst
		    REPL &cAliasN->cCiuAcuEst WITH &cNalias->cCiuAcuEst
		    REPL &cAliasN->cTe1AcuEst WITH &cNalias->cTe1AcuEst
		    REPL &cAliasN->cTe2AcuEst WITH &cNalias->cTe2AcuEst
		    REPL &cAliasN->cParAcuEst WITH &cNalias->cParAcuEst
		    REPL &cAliasN->cCelAcuEst WITH &cNalias->cCelAcuEst
		    REPL &cAliasN->cFaxAcuEst WITH &cNalias->cFaxAcuEst
		    REPL &cAliasN->cBipAcuEst WITH &cNalias->cBipAcuEst
		    REPL &cAliasN->cMaiAcuEst WITH &cNalias->cMaiAcuEst

/*
		    REPL &cAliasN->cNitCo1Est WITH cLocateCnt(cNalias,'C1DOC',aDatCnt)
		    REPL &cAliasN->cTipCo1Est WITH cLocateCnt(cNalias,'C1TIP',aDatCnt)
		    REPL &cAliasN->cNitCo2Est WITH cLocateCnt(cNalias,'C2DOC',aDatCnt)
		    REPL &cAliasN->cTipCo2Est WITH cLocateCnt(cNalias,'C2TIP',aDatCnt)
		    REPL &cAliasN->cNitCo3Est WITH cLocateCnt(cNalias,'C3DOC',aDatCnt)
		    REPL &cAliasN->cTipCo3Est WITH cLocateCnt(cNalias,'C3TIP',aDatCnt)
		    REPL &cAliasN->cNitCo4Est WITH cLocateCnt(cNalias,'C4DOC',aDatCnt)
		    REPL &cAliasN->cTipCo4Est WITH cLocateCnt(cNalias,'C4TIP',aDatCnt)
		  *ÀDatos de los Contrantes 1,2,3,4
*/

		    REPL &cAliasN->lRepiteEst WITH .F.
		    REPL &cAliasN->lSiCupoEst WITH .T.
		    REPL &cAliasN->lSiMatrEst WITH .F.
		    REPL &cAliasN->dFecMatEst WITH DATE()
		    REPL &cAliasN->cHorMatEst WITH TIME()
		    REPL &cAliasN->lEstNewEst WITH IF(cNalias=='ADM',.T.,.F.)
		    REPL &cAliasN->cCole13Est WITH &cNalias->cCole13Est
		    REPL &cAliasN->cCole00Est WITH &cNalias->cCole00Est
		    REPL &cAliasN->cCole01Est WITH &cNalias->cCole01Est
		    REPL &cAliasN->cCole02Est WITH &cNalias->cCole02Est
		    REPL &cAliasN->cCole03Est WITH &cNalias->cCole03Est
		    REPL &cAliasN->cCole04Est WITH &cNalias->cCole04Est
		    REPL &cAliasN->cCole05Est WITH &cNalias->cCole05Est
		    REPL &cAliasN->cCole06Est WITH &cNalias->cCole06Est
		    REPL &cAliasN->cCole07Est WITH &cNalias->cCole07Est
		    REPL &cAliasN->cCole08Est WITH &cNalias->cCole08Est
		    REPL &cAliasN->cCole09Est WITH &cNalias->cCole09Est
		    REPL &cAliasN->cCole10Est WITH &cNalias->cCole10Est
		    REPL &cAliasN->cCole11Est WITH &cNalias->cCole11Est
		    REPL &cAliasN->cCole12Est WITH &cNalias->cCole12Est
		    REPL &cAliasN->cCole14Est WITH &cNalias->cCole14Est
		    REPL &cAliasN->cCole15Est WITH &cNalias->cCole15Est
		    REPL &cAliasN->cCole16Est WITH &cNalias->cCole16Est

		    DBCOMMIT()
		    IF lShared
		       DBUNLOCK()
		    ENDIF
		 ELSE
		    cError('NO SE PUEDE MATRICULAR NUEVOS. '+;
			   'ERRORES EN EL SISTEMA')
		 ENDIF
	    ENDCASE
**********FIN GRABACION DE LA MATRICULA


**********IMPRESION DE LA MATRICULA
	    IF ANO->lPrnMtrAno

	       IF (lMatric .AND. lGrabar) .OR. lDuplic

		  SET DEVICE TO PRINT
		  dFecMatTes := DATE()
		  cHorMatTes := TIME()
		  IF lDuplic
		     dFecMatTes := &cAliasN->dFecMatEst
		     cHorMatTes := &cAliasN->cHorMatEst
		  ENDIF

		  DO CASE
		  CASE ANO->nTipMtrAno == 1
		       HojaMatr01(&cNalias->cCodigoEst,;
				  IF(lNuevos,.T.,.F.),;
				  IF(!lNuevos,&cNalias->lRepiteEst,.F.),;
				  VAL(SUBS(cCodigoTgr,1,2)),;
				  &cAliasN->cNombreEst,;
				  &cAliasN->cApelliEst,;
				  &cAliasN->dFecNacEst,;
				  &cAliasN->cLugNacEst,;
				  &cAliasN->cDocNitEst,;
				  &cAliasN->cLugNitEst,;
				  &cAliasN->cDireccEst,;
				  &cAliasN->cBarrioEst,;
				  &cAliasN->cTelefnEst,;
				  RTRIM(&cAliasN->cApePadEst)+' '+;
				  RTRIM(&cAliasN->cNomPadEst),;
				  &cAliasN->cPadNitEst,;
				  &cAliasN->cPadLugEst,;
				  &cAliasN->cProPadEst,;
				  &cAliasN->cEmpPadEst,;
				  &cAliasN->cCarPadEst,;
				  &cAliasN->cTelPadEst,;
				  RTRIM(&cAliasN->cApeMadEst)+' '+;
				  RTRIM(&cAliasN->cNomMadEst),;
				  &cAliasN->cMadNitEst,;
				  &cAliasN->cMadLugEst,;
				  &cAliasN->cProMadEst,;
				  &cAliasN->cEmpMadEst,;
				  &cAliasN->cCarMadEst,;
				  &cAliasN->cTelMadEst,;
				  RTRIM(&cAliasN->cApeAcuEst)+' '+;
				  RTRIM(&cAliasN->cNomAcuEst),;
				  &cAliasN->cAcuNitEst,;
				  &cAliasN->cAcuLugEst,;
				  &cAliasN->cTe1AcuEst,;
				  dFecMatTes,;
				  cHorMatTes,;
				  cObserv,cNomSis,;
				  cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		     *ÀHoja de Matr¡cula por Defecto

		  CASE ANO->nTipMtrAno == 2
		       HojaMatr02(&cNalias->cCodigoEst,;
				  IF(lNuevos,.T.,.F.),;
				  IF(!lNuevos,&cNalias->lRepiteEst,.F.),;
				  VAL(SUBS(cCodigoTgr,1,2)),;
				  &cAliasN->cNombreEst,;
				  &cAliasN->cApelliEst,;
				  &cAliasN->dFecNacEst,;
				  &cAliasN->cLugNacEst,;
				  &cAliasN->cDocNitEst,;
				  &cAliasN->cLugNitEst,;
				  &cAliasN->cDireccEst,;
				  &cAliasN->cBarrioEst,;
				  &cAliasN->cTelefnEst,;
				  RTRIM(&cAliasN->cApePadEst)+' '+;
				  RTRIM(&cAliasN->cNomPadEst),;
				  &cAliasN->cPadNitEst,;
				  &cAliasN->cPadLugEst,;
				  &cAliasN->cProPadEst,;
				  &cAliasN->cEmpPadEst,;
				  &cAliasN->cCarPadEst,;
				  &cAliasN->cTelPadEst,;
				  RTRIM(&cAliasN->cApeMadEst)+' '+;
				  RTRIM(&cAliasN->cNomMadEst),;
				  &cAliasN->cMadNitEst,;
				  &cAliasN->cMadLugEst,;
				  &cAliasN->cProMadEst,;
				  &cAliasN->cEmpMadEst,;
				  &cAliasN->cCarMadEst,;
				  &cAliasN->cTelMadEst,;
				  RTRIM(&cAliasN->cApeAcuEst)+' '+;
				  RTRIM(&cAliasN->cNomAcuEst),;
				  &cAliasN->cAcuNitEst,;
				  &cAliasN->cAcuLugEst,;
				  &cAliasN->cTe1AcuEst,;
				  dFecMatTes,;
				  cHorMatTes,;
				  cObserv,cNomSis,;
				  cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		     *ÀHoja de Matr¡cula con Procedencia

		  CASE ANO->nTipMtrAno == 3

		       HojaMatr03(&cNalias->cCodigoEst,;
				  IF(lNuevos,.T.,.F.),;
				  IF(!lNuevos,&cNalias->lRepiteEst,.F.),;
				  VAL(SUBS(cCodigoTgr,1,2)),;
				  &cAliasN->cNombreEst,;
				  &cAliasN->cApelliEst,;
				  &cAliasN->dFecNacEst,;
				  &cAliasN->cLugNacEst,;
				  &cAliasN->cDocNitEst,;
				  &cAliasN->cLugNitEst,;
				  &cAliasN->cDireccEst,;
				  &cAliasN->cBarrioEst,;
				  &cAliasN->cTelefnEst,;
				  &cAliasN->cTelCelEst,;
				  &cAliasN->cMaiEstEst,;
				  ALLTRIM(&cAliasN->cNomPadEst)+' '+;
				  ALLTRIM(&cAliasN->cApePadEst),;
				  &cAliasN->cPadNitEst,;
				  &cAliasN->cPadLugEst,;
				  &cAliasN->cProPadEst,;
				  &cAliasN->cEmpPadEst,;
				  &cAliasN->cDirPadEst,;
				  &cAliasN->cBarPadEst,;
				  &cAliasN->cCarPadEst,;
				  &cAliasN->cTelPadEst,;
				  &cAliasN->cCelPadEst,;
				  &cAliasN->cFaxPadEst,;
				  &cAliasN->cBipPadEst,;
				  &cAliasN->cMaiPadEst,;
				  ALLTRIM(&cAliasN->cNomMadEst)+' '+;
				  ALLTRIM(&cAliasN->cApeMadEst),;
				  &cAliasN->cMadNitEst,;
				  &cAliasN->cMadLugEst,;
				  &cAliasN->cProMadEst,;
				  &cAliasN->cEmpMadEst,;
				  &cAliasN->cDirMadEst,;
				  &cAliasN->cBarMadEst,;
				  &cAliasN->cCarMadEst,;
				  &cAliasN->cTelMadEst,;
				  &cAliasN->cCelMadEst,;
				  &cAliasN->cFaxMadEst,;
				  &cAliasN->cBipMadEst,;
				  &cAliasN->cMaiMadEst,;
				  &cAliasN->cParAcuEst,;
				  ALLTRIM(&cAliasN->cNomAcuEst)+' '+;
				  ALLTRIM(&cAliasN->cApeAcuEst),;
				  &cAliasN->cAcuNitEst,;
				  &cAliasN->cAcuLugEst,;
				  &cAliasN->cProAcuEst,;
				  &cAliasN->cEmpAcuEst,;
				  &cAliasN->cDirAcuEst,;
				  &cAliasN->cBarAcuEst,;
				  &cAliasN->cCarAcuEst,;
				  &cAliasN->cTe1AcuEst,;
				  &cAliasN->cCelAcuEst,;
				  &cAliasN->cFaxAcuEst,;
				  &cAliasN->cBipAcuEst,;
				  &cAliasN->cMaiAcuEst,;
				  dFecMatTes,;
				  cHorMatTes,;
				  cObserv,cNomSis,;
				  cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		     *ÀHoja de Matr¡cula La Salle Bogota

		  CASE ANO->nTipMtrAno == 4
		       HojaMatr04(&cNalias->cCodigoEst,;
				  IF(lNuevos,.T.,.F.),;
				  IF(!lNuevos,&cNalias->lRepiteEst,.F.),;
				  VAL(SUBS(cCodigoTgr,1,2)),;
				  &cAliasN->cNombreEst,;
				  &cAliasN->cApelliEst,;
				  &cAliasN->dFecNacEst,;
				  &cAliasN->cLugNacEst,;
				  &cAliasN->cDocNitEst,;
				  &cAliasN->cLugNitEst,;
				  &cAliasN->cDireccEst,;
				  &cAliasN->cBarrioEst,;
				  &cAliasN->cTelefnEst,;
				  RTRIM(&cAliasN->cApePadEst)+' '+;
				  RTRIM(&cAliasN->cNomPadEst),;
				  &cAliasN->cPadNitEst,;
				  &cAliasN->cPadLugEst,;
				  &cAliasN->cProPadEst,;
				  &cAliasN->cEmpPadEst,;
				  &cAliasN->cCarPadEst,;
				  &cAliasN->cTelPadEst,;
				  RTRIM(&cAliasN->cApeMadEst)+' '+;
				  RTRIM(&cAliasN->cNomMadEst),;
				  &cAliasN->cMadNitEst,;
				  &cAliasN->cMadLugEst,;
				  &cAliasN->cProMadEst,;
				  &cAliasN->cEmpMadEst,;
				  &cAliasN->cCarMadEst,;
				  &cAliasN->cTelMadEst,;
				  RTRIM(&cAliasN->cApeAcuEst)+' '+;
				  RTRIM(&cAliasN->cNomAcuEst),;
				  &cAliasN->cAcuNitEst,;
				  &cAliasN->cAcuLugEst,;
				  &cAliasN->cTe1AcuEst,;
				  dFecMatTes,;
				  cHorMatTes,;
				  cObserv,cNomSis,;
				  cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		     *ÀHoja de Matr¡cula. Distrito La Salle. Bogota

		  CASE ANO->nTipMtrAno == 5
		       HojaMatr05(&cNalias->cCodigoEst,;
				  IF(lNuevos,.T.,.F.),;
				  IF(!lNuevos,&cNalias->lRepiteEst,.F.),;
				  VAL(SUBS(cCodigoTgr,1,2)),;
				  &cAliasN->cNombreEst,;
				  &cAliasN->cApelliEst,;
				  &cAliasN->dFecNacEst,;
				  &cAliasN->cLugNacEst,;
				  &cAliasN->cDocNitEst,;
				  &cAliasN->cLugNitEst,;
				  &cAliasN->cDireccEst,;
				  &cAliasN->cBarrioEst,;
				  &cAliasN->cTelefnEst,;
				  &cAliasN->cTelCelEst,;
				  &cAliasN->cMaiEstEst,;
				  RTRIM(&cAliasN->cApePadEst)+' '+;
				  RTRIM(&cAliasN->cNomPadEst),;
				  &cAliasN->cPadNitEst,;
				  &cAliasN->cPadLugEst,;
				  &cAliasN->cProPadEst,;
				  &cAliasN->cEmpPadEst,;
				  &cAliasN->cCarPadEst,;
				  &cAliasN->cTelPadEst,;
				  &cAliasN->cDirPadEst,;
				  &cAliasN->cCelPadEst,;
				  RTRIM(&cAliasN->cApeMadEst)+' '+;
				  RTRIM(&cAliasN->cNomMadEst),;
				  &cAliasN->cMadNitEst,;
				  &cAliasN->cMadLugEst,;
				  &cAliasN->cProMadEst,;
				  &cAliasN->cEmpMadEst,;
				  &cAliasN->cCarMadEst,;
				  &cAliasN->cTelMadEst,;
				  &cAliasN->cDirMadEst,;
				  &cAliasN->cCelMadEst,;
				  RTRIM(&cAliasN->cApeAcuEst)+' '+;
				  RTRIM(&cAliasN->cNomAcuEst),;
				  &cAliasN->cAcuNitEst,;
				  &cAliasN->cAcuLugEst,;
				  &cAliasN->cTe1AcuEst,;
				  &cAliasN->cDirAcuEst,;
				  &cAliasN->cProAcuEst,;
				  &cAliasN->cCelAcuEst,;
				  dFecMatTes,;
				  cHorMatTes,;
				  cObserv,cNomSis,;
				  cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		     *ÀHoja de Matr¡cula.F-AM-04 30-09-2010

		  ENDCASE

	       ENDIF

	    ENDIF
	    RESTORE SCREEN
	    @ nNroFil,aNroCol[4] SAY IF(lMatric,'Si','No')
**********FIN IMPRESION DE LA MATRICULA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE
		 nNroFil := nMarco(nFilPal+1,'MATRICULAS PARA ALUMNOS PARA EL '+;
				     cAnoUsr,22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,01 SAY cCodigoTes
		 SET COLOR TO

		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY cCodigoTgr
		 @ nNroFil,aNroCol[4] SAY IF(lMatric,'Si','No')
		 nNroFil++
*--------------FIN IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       SETKEY(K_F10,NIL)
       SHOWTIME()
       CLOSE ALL
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LOS DATOS DEL ESTUDIANTE