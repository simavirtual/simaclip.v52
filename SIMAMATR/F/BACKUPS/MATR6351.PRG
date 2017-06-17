/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : MATRICULAS - INFORMES
SUBMODULO...: HOJAS DE MATRICULAS - POR GRUPOS. ANTIGUOS  MODULO No. 6351

**************************************************************************
* TITULO..: IMPRESION DE LAS HOJAS DE MATRICULAS POR GRUPOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 07/99 JUE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   SEP 07/99 JUE

OBJETIVOS:

1- Permite imprimir las Hojas de matr¡culas de los estudiantes antiguos
   por grupos.


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matr_6351(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

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

       LOCAL lUseNtx := .F.                 // .T. Poner en Uso lo indices
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL cAnoAnt := .F.                 // A¤o Anterior

       LOCAL nIniReg := 0                   // Registro Inicial
       LOCAL nFinReg := 0                   // Registro Final
       LOCAL nTotReg := 0                   // Total de Registros
       LOCAL nAvance := 0                   // Avance de registros

       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n

       LOCAL cNalias := ''                  // Alias Antiguos o nuevos
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL aFirmas := {}                  // Firmantes del Certificado
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL lNuevos := .F.                 // .F. Estudiantes Antiguos
       LOCAL cObserv := ''                  // Observaci¢n para la matr¡cula
       LOCAL dFecMatTes := CTOD('00/00/00') // Fecha de la Matr¡cula
       LOCAL cHorMatTes := ''               // Hora de la Matr¡cula

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       FIELD cCodigoGru                     // C¢digo del Grupo
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECION DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
       cPatAnt := PathUno+'\'+cPatAnt
       PathAlu := PathUno+'\'+cPatSis
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared)     .OR.;
	  !lUseGru(lShared,cPatAnt,cMaeAct,SUBS(cAnoAnt,3,2),lAnoAct) .OR.;
	  !lUseMaeMtr(lShared,cPatAnt,cMaeAct,SUBS(cAnoAnt,3,2),lAnoAct,lUseNtx)

	  cError('ABRIENDO ARCHIVOS EN MATRICULAS')
	  CLOSE ALL
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

       CASE ANO->nTipMtrAno == 0
	    cError('NO SE HA ESPECIFICADO EL NUMERO DE HOJA DE MATRICULA')

       CASE 'JAA' $ cMaeAlu .AND. JAA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoAnt)

       CASE 'PRA' $ cMaeAlu .AND. PRA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoAnt)

       CASE 'BTA' $ cMaeAlu .AND. BTA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoAnt)

       CASE GRU->(RECCOUNT()) == 0
	    cError('No Existen Grupos Grabados para '+cAnoAnt)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DE LA FECHA DE MATRICULA
       IF ANO->nTipMtrAno == 1 .OR. ANO->nTipMtrAno == 3
	  cSavPan := SAVESCREEN(0,0,24,79)
	  dFecMatTes := DATE()
	  @ 21,20 SAY 'INGRESE LA FECHA DE MATRICULA: (MM/DD/AA)'
	  @ nFilInf+1,nColInf SAY 'FECHA:' GET dFecMatTes PICT '@D'

	  cHorMatTes := TIME()
	  @ nFilInf+2,nColInf SAY "HORA :";
			      GET cHorMatTes PICT "99:99:99" ;
			      VALID TIMEVALID(ALLTRIM(cHorMatTes))
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
*>>>>FIN LECTURA DE LA FECHA DE MATRICULA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       SELECT GRU
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

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

*>>>>ACTIVACION DE LA IMPRESORA
      IF MTR->lPrnArcMtr
	 SET DEVICE TO PRINT
      ELSE
	 FilePrn := 'HojaMatr'
	 nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.,.F.,bInsIso,PathDoc)
	 IF EMPTY(nOpcPrn)
	    CloseAll()
	    RETURN NIL
	 ENDIF
	 @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
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

*>>>>IMPRESION DE LAS ORDENES DE MATRICULA
       SET DEVICE TO SCREEN
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********FILTRACION DEL MAESTRO
	    SELECT &cMaeAct
	    SET FILTER TO cCodigoGru == GRU->cCodigoGru
	    GO TOP
	    IF EOF()
	       cError('NO EXISTEN ESTUDIANTES PARA EL GRUPO '+GRU->cCodigoGru)

*--------------AVANCE DEL SIGUIENTE GRUPO
		 SELECT GRU
		 SKIP

		 IF nRegIni = nRegFin
		    EXIT
		   *Salida por ser un solo grupo a imprimir
		 ENDIF
		 LOOP
*--------------FIN AVANCE DEL SIGUIENTE GRUPO

	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********CALCULO DEL TOTAL DE REGISTROS
		  i := 1
	    nIniReg := RECNO()
	    GO BOTTOM
	    nFinReg := RECNO()
	    nTotReg := (nFinReg-nIniReg)+1
	    Termometro(0,'IMPRIMIENDO LAS ORDENES DEL GRUPO '+GRU->cCodigoGru)
	    Termometro(15)
**********FIN CALCULO DEL TOTAL DE REGISTROS

**********IMPRESION DE LAS HOJAS DE MATRICULAS
	    SELECT &cMaeAct
	    GO TOP

	    DO WHILE .NOT. EOF()

*--------------VALIDACION DEL CODIGO
		 DO CASE
		 CASE &cMaeAct->lRetiroEst

		      SELECT &cMaeAct
		      DBSKIP()
		      Avance(@i,nTotReg)
		      LOOP

		 CASE !(&cMaeAct->lSiCupoEst)

		      SELECT &cMaeAct
		      DBSKIP()
		      Avance(@i,nTotReg)
		      LOOP

		 CASE SUBS(&cMaeAct->cCodigoGru,1,2) = '11' .AND.;
		      !&cMaeAct->lRepiteEst

		      SELECT &cMaeAct
		      DBSKIP()
		      LOOP

		 ENDCASE
*--------------FIN VALIDACION DEL CODIGO

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			     'HASTA EL GRUPO: '+cGruFin+;
			     'ºTOTAL: '+STR(nTotReg,2)+'/'+STR(I,2),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DEL SIGUIENTE NIVEL
		 IF &cMaeAct->lRepiteEst

*...................REPITE EL NIVEL
		      IF SUBS(&cMaeAct->cCodigoGru,1,2) == '17'
			 cCodigoTgr := '00'+SUBS(&cMaeAct->cCodigoGru,3,2)
		      ELSE
			 cCodigoTgr := &cMaeAct->cCodigoGru
		      ENDIF
*...................FIN REPITE EL NIVEL

		 ELSE

*...................PROMOCION AL SIGUIENTE NIVEL
		      IF SUBS(&cMaeAct->cCodigoGru,1,2) == '16'
			 cCodigoTgr := '00'
		      ELSE
			 IF SUBS(&cMaeAct->cCodigoGru,1,2) == '17'
			    cCodigoTgr := '01'
			 ELSE
			    cCodigoTgr := STR(VAL(SUBS(&cMaeAct->cCodigoGru,1,2))+1,2)
			 ENDIF
		      ENDIF
		      lCorrecion(@cCodigoTgr)
		      cCodigoTgr += SUBS(&cMaeAct->cCodigoGru,3,2)
*...................FIN PROMOCION AL SIGUIENTE NIVEL

		 ENDIF
*--------------FIN ANALISIS DEL SIGUIENTE NIVEL

*--------------IMPRESION DE LA MATRICULA
		 SET DEVICE TO PRINT
		 lNuevos := .F.

		 DO CASE
		 CASE ANO->nTipMtrAno == 1
		      HojaMatr01(&cMaeAct->cCodigoEst,;
				 lNuevos,;
				 &cMaeAct->lRepiteEst,;
				 VAL(SUBS(cCodigoTgr,1,2)),;
				 &cMaeAct->cNombreEst,;
				 &cMaeAct->cApelliEst,;
				 &cMaeAct->dFecNacEst,;
				 &cMaeAct->cLugNacEst,;
				 &cMaeAct->cDocNitEst,;
				 &cMaeAct->cLugNitEst,;
				 &cMaeAct->cDireccEst,;
				 &cMaeAct->cBarrioEst,;
				 &cMaeAct->cTelefnEst,;
				 ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				 ALLTRIM(&cMaeAct->cApePadEst),;
				 &cMaeAct->cPadNitEst,;
				 &cMaeAct->cPadLugEst,;
				 &cMaeAct->cProPadEst,;
				 &cMaeAct->cEmpPadEst,;
				 &cMaeAct->cCarPadEst,;
				 &cMaeAct->cTelPadEst,;
				 ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				 ALLTRIM(&cMaeAct->cApeMadEst),;
				 &cMaeAct->cMadNitEst,;
				 &cMaeAct->cMadLugEst,;
				 &cMaeAct->cProMadEst,;
				 &cMaeAct->cEmpMadEst,;
				 &cMaeAct->cCarMadEst,;
				 &cMaeAct->cTelMadEst,;
				 ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				 ALLTRIM(&cMaeAct->cApeAcuEst),;
				 &cMaeAct->cAcuNitEst,;
				 &cMaeAct->cAcuLugEst,;
				 &cMaeAct->cTe1AcuEst,;
				 dFecMatTes,;
				 cHorMatTes,;
				 cObserv,cNomSis,;
				 cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		    *ÀHoja de Matr¡cula por Defecto

		 CASE ANO->nTipMtrAno == 2
		      HojaMatr02(&cMaeAct->cCodigoEst,;
				 lNuevos,;
				 &cMaeAct->lRepiteEst,;
				 VAL(SUBS(cCodigoTgr,1,2)),;
				 &cMaeAct->cNombreEst,;
				 &cMaeAct->cApelliEst,;
				 &cMaeAct->dFecNacEst,;
				 &cMaeAct->cLugNacEst,;
				 &cMaeAct->cDocNitEst,;
				 &cMaeAct->cLugNitEst,;
				 &cMaeAct->cDireccEst,;
				 &cMaeAct->cBarrioEst,;
				 &cMaeAct->cTelefnEst,;
				 ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				 ALLTRIM(&cMaeAct->cApePadEst),;
				 &cMaeAct->cPadNitEst,;
				 &cMaeAct->cPadLugEst,;
				 &cMaeAct->cProPadEst,;
				 &cMaeAct->cEmpPadEst,;
				 &cMaeAct->cCarPadEst,;
				 &cMaeAct->cTelPadEst,;
				 ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				 ALLTRIM(&cMaeAct->cApeMadEst),;
				 &cMaeAct->cMadNitEst,;
				 &cMaeAct->cMadLugEst,;
				 &cMaeAct->cProMadEst,;
				 &cMaeAct->cEmpMadEst,;
				 &cMaeAct->cCarMadEst,;
				 &cMaeAct->cTelMadEst,;
				 ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				 ALLTRIM(&cMaeAct->cApeAcuEst),;
				 &cMaeAct->cAcuNitEst,;
				 &cMaeAct->cAcuLugEst,;
				 &cMaeAct->cTe1AcuEst,;
				 dFecMatTes,;
				 cHorMatTes,;
				 cObserv,cNomSis,;
				 cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		    *ÀHoja de Matr¡cula con Procedencia

	       CASE ANO->nTipMtrAno == 3

		    HojaMatr03(&cMaeAct->cCodigoEst,;
			       lNuevos,;
			       &cMaeAct->lRepiteEst,;
			       VAL(SUBS(cCodigoTgr,1,2)),;
			       &cMaeAct->cNombreEst,;
			       &cMaeAct->cApelliEst,;
			       &cMaeAct->dFecNacEst,;
			       &cMaeAct->cLugNacEst,;
			       &cMaeAct->cDocNitEst,;
			       &cMaeAct->cLugNitEst,;
			       &cMaeAct->cDireccEst,;
			       &cMaeAct->cBarrioEst,;
			       &cMaeAct->cTelefnEst,;
			       &cMaeAct->cTelCelEst,;
			       &cMaeAct->cMaiEstEst,;
			       ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
			       ALLTRIM(&cMaeAct->cApePadEst),;
			       &cMaeAct->cPadNitEst,;
			       &cMaeAct->cPadLugEst,;
			       &cMaeAct->cProPadEst,;
			       &cMaeAct->cEmpPadEst,;
			       &cMaeAct->cDirPadEst,;
			       &cMaeAct->cBarPadEst,;
			       &cMaeAct->cCarPadEst,;
			       &cMaeAct->cTelPadEst,;
			       &cMaeAct->cCelPadEst,;
			       &cMaeAct->cFaxPadEst,;
			       &cMaeAct->cBipPadEst,;
			       &cMaeAct->cMaiPadEst,;
			       ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
			       ALLTRIM(&cMaeAct->cApeMadEst),;
			       &cMaeAct->cMadNitEst,;
			       &cMaeAct->cMadLugEst,;
			       &cMaeAct->cProMadEst,;
			       &cMaeAct->cEmpMadEst,;
			       &cMaeAct->cDirMadEst,;
			       &cMaeAct->cBarMadEst,;
			       &cMaeAct->cCarMadEst,;
			       &cMaeAct->cTelMadEst,;
			       &cMaeAct->cCelMadEst,;
			       &cMaeAct->cFaxMadEst,;
			       &cMaeAct->cBipMadEst,;
			       &cMaeAct->cMaiMadEst,;
			       &cMaeAct->cParAcuEst,;
			       ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
			       ALLTRIM(&cMaeAct->cApeAcuEst),;
			       &cMaeAct->cAcuNitEst,;
			       &cMaeAct->cAcuLugEst,;
			       &cMaeAct->cProAcuEst,;
			       &cMaeAct->cEmpAcuEst,;
			       &cMaeAct->cDirAcuEst,;
			       &cMaeAct->cBarAcuEst,;
			       &cMaeAct->cCarAcuEst,;
			       &cMaeAct->cTe1AcuEst,;
			       &cMaeAct->cCelAcuEst,;
			       &cMaeAct->cFaxAcuEst,;
			       &cMaeAct->cBipAcuEst,;
			       &cMaeAct->cMaiAcuEst,;
			       dFecMatTes,;
			       cHorMatTes,;
			       cObserv,cNomSis,;
			       cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		  *ÀHoja de Matr¡cula La Salle Bogota

		 CASE ANO->nTipMtrAno == 4
		      HojaMatr04(&cMaeAct->cCodigoEst,;
				 lNuevos,;
				 &cMaeAct->lRepiteEst,;
				 VAL(SUBS(cCodigoTgr,1,2)),;
				 &cMaeAct->cNombreEst,;
				 &cMaeAct->cApelliEst,;
				 &cMaeAct->dFecNacEst,;
				 &cMaeAct->cLugNacEst,;
				 &cMaeAct->cDocNitEst,;
				 &cMaeAct->cLugNitEst,;
				 &cMaeAct->cDireccEst,;
				 &cMaeAct->cBarrioEst,;
				 &cMaeAct->cTelefnEst,;
				 ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				 ALLTRIM(&cMaeAct->cApePadEst),;
				 &cMaeAct->cPadNitEst,;
				 &cMaeAct->cPadLugEst,;
				 &cMaeAct->cProPadEst,;
				 &cMaeAct->cEmpPadEst,;
				 &cMaeAct->cCarPadEst,;
				 &cMaeAct->cTelPadEst,;
				 ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				 ALLTRIM(&cMaeAct->cApeMadEst),;
				 &cMaeAct->cMadNitEst,;
				 &cMaeAct->cMadLugEst,;
				 &cMaeAct->cProMadEst,;
				 &cMaeAct->cEmpMadEst,;
				 &cMaeAct->cCarMadEst,;
				 &cMaeAct->cTelMadEst,;
				 ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				 ALLTRIM(&cMaeAct->cApeAcuEst),;
				 &cMaeAct->cAcuNitEst,;
				 &cMaeAct->cAcuLugEst,;
				 &cMaeAct->cTe1AcuEst,;
				 dFecMatTes,;
				 cHorMatTes,;
				 cObserv,cNomSis,;
				 cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		    *ÀHoja de Matr¡cula Distrito Bogota

		 CASE ANO->nTipMtrAno == 5
		      HojaMatr05(&cMaeAct->cCodigoEst,;
				 lNuevos,;
				 &cMaeAct->lRepiteEst,;
				 VAL(SUBS(cCodigoTgr,1,2)),;
				 &cMaeAct->cNombreEst,;
				 &cMaeAct->cApelliEst,;
				 &cMaeAct->dFecNacEst,;
				 &cMaeAct->cLugNacEst,;
				 &cMaeAct->cDocNitEst,;
				 &cMaeAct->cLugNitEst,;
				 &cMaeAct->cDireccEst,;
				 &cMaeAct->cBarrioEst,;
				 &cMaeAct->cTelefnEst,;
				 &cMaeAct->cTelCelEst,;
				 &cMaeAct->cMaiEstEst,;
				 ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				 ALLTRIM(&cMaeAct->cApePadEst),;
				 &cMaeAct->cPadNitEst,;
				 &cMaeAct->cPadLugEst,;
				 &cMaeAct->cProPadEst,;
				 &cMaeAct->cEmpPadEst,;
				 &cMaeAct->cCarPadEst,;
				 &cMaeAct->cTelPadEst,;
				 &cMaeAct->cDirPadEst,;
				 &cMaeAct->cCelPadEst,;
				 ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				 ALLTRIM(&cMaeAct->cApeMadEst),;
				 &cMaeAct->cMadNitEst,;
				 &cMaeAct->cMadLugEst,;
				 &cMaeAct->cProMadEst,;
				 &cMaeAct->cEmpMadEst,;
				 &cMaeAct->cCarMadEst,;
				 &cMaeAct->cTelMadEst,;
				 &cMaeAct->cDirMadEst,;
				 &cMaeAct->cCelMadEst,;
				 ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				 ALLTRIM(&cMaeAct->cApeAcuEst),;
				 &cMaeAct->cAcuNitEst,;
				 &cMaeAct->cAcuLugEst,;
				 &cMaeAct->cTe1AcuEst,;
				 &cMaeAct->cDirAcuEst,;
				 &cMaeAct->cProAcuEst,;
				 &cMaeAct->cCelAcuEst,;
				 dFecMatTes,;
				 cHorMatTes,;
				 cObserv,cNomSis,;
				 cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		    *ÀHoja de Matr¡cula. F-AM-04 30-09-2010

		 ENDCASE
		 SET DEVICE TO SCREEN
*--------------FIN IMPRESION DE LA MATRICULA

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 Avance(@i,nTotReg)
		 SELECT &cMaeAct
		 DBSKIP()
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO


	    ENDDO
**********FIN IMPRESION DE LAS HOJAS DE MATRICULAS

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       SET FILTER TO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS