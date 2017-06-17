/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : MATRICULAS - INFORMES
SUBMODULO...: HOJAS DE MATRICULAS - POR GRUPOS NUEVOS MODULO No. 6351

**************************************************************************
* TITULO..: IMPRESION DE LAS HOJAS DE MATRICULAS POR GRUPOS. NUEVOS      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 08/96 MIE A
       Colombia, Bucaramanga        INICIO: 01:20 PM   SEP 08/96 MIE

OBJETIVOS:

1- Permite imprimir las Hojas de matr¡culas de los estudiantes nuevos
   por grupos.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matr_6353(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

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

       LOCAL nNroNiv := 0                   // N£mero Nivel
       LOCAL cNivIni := 0                   // Nivel Inicial
       LOCAL cNivFin := 0                   // Nivel Final

       LOCAL lNuevos := .F.                 // .F. Estudiantes Antiguos
       LOCAL cObserv := ''                  // Observaci¢n para la matr¡cula
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL dFecMatTes := CTOD('00/00/00') // Fecha de la Matr¡cula
       LOCAL cHorMatTes := ''               // Hora de la Matr¡cula
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

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
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

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE ANO->nTipMtrAno == 0
	    cError('NO SE HA ESPECIFICADO EL NUMERO DE HOJA DE MATRICULA')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

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

*>>>>LECTURA DE LOS NIVELES A IMPRIMIR
       IF !lLeeNivels(nFilInf+1,nColInf,@cNivIni,@cNivFin,NIL,cMaeAlu)
	  CloseAll()
	  RETURN NIL
       ENDIF
       nNroNiv := VAL(cNivIni)
*>>>>FIN LECTURA DE LOS NIVELES A IMPRIMIR

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
	 FilePrn := 'mtr601'
	 nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,'2',.F.,.F.,bInsIso)
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

*>>>>IMPRESION DEL INFORME
       SET DEVICE TO SCREEN
       SELECT ADM
       DO WHILE nNroNiv <= VAL(cNivFin)

**********FILTRACION DEL MAESTRO
	    SET FILTER TO VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv
	    GO TOP
	    IF EOF()
	       cError('PARA '+cNomNiv(nNroNiv)+' NO HAY INSCRITOS')
	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO NIVEL: '+STR(nNroNiv,2)+'º'+;
			'HASTA NIVEL: '+cNivFin+;
			'ºPOR FAVOR ESPERE ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DE LAS HOJAS DE LA MATRICULA
	    SELECT ADM
	    GO TOP
	    DO WHILE .NOT. EOF()

*--------------IMPRESION DE LA MATRICULA
		 IF ADM->lSiCupoEst

		    SET DEVICE TO PRINT
		    lNuevos := .T.

		    DO CASE
		    CASE ANO->nTipMtrAno == 1
			 HojaMatr01(ADM->cCodigoEst,;
				    lNuevos,;
				    .F.,;
				    VAL(SUBS(ADM->cCodigoGru,1,2)),;
				    ADM->cNombreEst,;
				    ADM->cApelliEst,;
				    ADM->dFecNacEst,;
				    ADM->cLugNacEst,;
				    ADM->cDocNitEst,;
				    ADM->cLugNitEst,;
				    ADM->cDireccEst,;
				    ADM->cBarrioEst,;
				    ADM->cTelefnEst,;
				    ALLTRIM(ADM->cNomPadEst)+' '+;
				    ALLTRIM(ADM->cApePadEst),;
				    ADM->cPadNitEst,;
				    ADM->cPadLugEst,;
				    ADM->cProPadEst,;
				    ADM->cEmpPadEst,;
				    ADM->cCarPadEst,;
				    ADM->cTelPadEst,;
				    ALLTRIM(ADM->cNomMadEst)+' '+;
				    ALLTRIM(ADM->cApeMadEst),;
				    ADM->cMadNitEst,;
				    ADM->cMadLugEst,;
				    ADM->cProMadEst,;
				    ADM->cEmpMadEst,;
				    ADM->cCarMadEst,;
				    ADM->cTelMadEst,;
				    ALLTRIM(ADM->cNomAcuEst)+' '+;
				    ALLTRIM(ADM->cApeAcuEst),;
				    ADM->cAcuNitEst,;
				    ADM->cAcuLugEst,;
				    ADM->cTe1AcuEst,;
				    dFecMatTes,;
				    cHorMatTes,;
				    cObserv,cNomSis,;
				    cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		       *ÀHoja de Matr¡cula por Defecto

		    CASE ANO->nTipMtrAno == 2
			 HojaMatr02(ADM->cCodigoEst,;
				    lNuevos,;
				    .F.,;
				    VAL(SUBS(ADM->cCodigoGru,1,2)),;
				    ADM->cNombreEst,;
				    ADM->cApelliEst,;
				    ADM->dFecNacEst,;
				    ADM->cLugNacEst,;
				    ADM->cDocNitEst,;
				    ADM->cLugNitEst,;
				    ADM->cDireccEst,;
				    ADM->cBarrioEst,;
				    ADM->cTelefnEst,;
				    ALLTRIM(ADM->cNomPadEst)+' '+;
				    ALLTRIM(ADM->cApePadEst),;
				    ADM->cPadNitEst,;
				    ADM->cPadLugEst,;
				    ADM->cProPadEst,;
				    ADM->cEmpPadEst,;
				    ADM->cCarPadEst,;
				    ADM->cTelPadEst,;
				    ALLTRIM(ADM->cNomMadEst)+' '+;
				    ALLTRIM(ADM->cApeMadEst),;
				    ADM->cMadNitEst,;
				    ADM->cMadLugEst,;
				    ADM->cProMadEst,;
				    ADM->cEmpMadEst,;
				    ADM->cCarMadEst,;
				    ADM->cTelMadEst,;
				    ALLTRIM(ADM->cNomAcuEst)+' '+;
				    ALLTRIM(ADM->cApeAcuEst),;
				    ADM->cAcuNitEst,;
				    ADM->cAcuLugEst,;
				    ADM->cTe1AcuEst,;
				    dFecMatTes,;
				    cHorMatTes,;
				    cObserv,cNomSis,;
				    cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		       *ÀHoja de Matr¡cula con Procedencia

		    CASE ANO->nTipMtrAno == 3
			 HojaMatr03(ADM->cCodigoEst,;
				    lNuevos,;
				    .F.,;
				    VAL(SUBS(ADM->cCodigoGru,1,2)),;
				    ADM->cNombreEst,;
				    ADM->cApelliEst,;
				    ADM->dFecNacEst,;
				    ADM->cLugNacEst,;
				    ADM->cDocNitEst,;
				    ADM->cLugNitEst,;
				    ADM->cDireccEst,;
				    ADM->cBarrioEst,;
				    ADM->cTelefnEst,;
				    ADM->cTelCelEst,;
				    ADM->cMaiEstEst,;
				    ALLTRIM(ADM->cNomPadEst)+' '+;
				    ALLTRIM(ADM->cApePadEst),;
				    ADM->cPadNitEst,;
				    ADM->cPadLugEst,;
				    ADM->cProPadEst,;
				    ADM->cEmpPadEst,;
				    ADM->cDirPadEst,;
				    ADM->cBarPadEst,;
				    ADM->cCarPadEst,;
				    ADM->cTelPadEst,;
				    ADM->cCelPadEst,;
				    ADM->cFaxPadEst,;
				    ADM->cBipPadEst,;
				    ADM->cMaiPadEst,;
				    ALLTRIM(ADM->cNomMadEst)+' '+;
				    ALLTRIM(ADM->cApeMadEst),;
				    ADM->cMadNitEst,;
				    ADM->cMadLugEst,;
				    ADM->cProMadEst,;
				    ADM->cEmpMadEst,;
				    ADM->cDirMadEst,;
				    ADM->cBarMadEst,;
				    ADM->cCarMadEst,;
				    ADM->cTelMadEst,;
				    ADM->cCelMadEst,;
				    ADM->cFaxMadEst,;
				    ADM->cBipMadEst,;
				    ADM->cMaiMadEst,;
				    ADM->cParAcuEst,;
				    ALLTRIM(ADM->cNomAcuEst)+' '+;
				    ALLTRIM(ADM->cApeAcuEst),;
				    ADM->cAcuNitEst,;
				    ADM->cAcuLugEst,;
				    ADM->cProAcuEst,;
				    ADM->cEmpAcuEst,;
				    ADM->cDirAcuEst,;
				    ADM->cBarAcuEst,;
				    ADM->cCarAcuEst,;
				    ADM->cTe1AcuEst,;
				    ADM->cCelAcuEst,;
				    ADM->cFaxAcuEst,;
				    ADM->cBipAcuEst,;
				    ADM->cMaiAcuEst,;
				    dFecMatTes,;
				    cHorMatTes,;
				    cObserv,cNomSis,;
				    cNomEmp,cAnoUsr,cJorTxt,cCodIso)
			  *ÀHoja de Matr¡cula La Salle Bogota

		    CASE ANO->nTipMtrAno == 4
			 HojaMatr04(ADM->cCodigoEst,;
				    lNuevos,;
				    .F.,;
				    VAL(SUBS(ADM->cCodigoGru,1,2)),;
				    ADM->cNombreEst,;
				    ADM->cApelliEst,;
				    ADM->dFecNacEst,;
				    ADM->cLugNacEst,;
				    ADM->cDocNitEst,;
				    ADM->cLugNitEst,;
				    ADM->cDireccEst,;
				    ADM->cBarrioEst,;
				    ADM->cTelefnEst,;
				    ALLTRIM(ADM->cNomPadEst)+' '+;
				    ALLTRIM(ADM->cApePadEst),;
				    ADM->cPadNitEst,;
				    ADM->cPadLugEst,;
				    ADM->cProPadEst,;
				    ADM->cEmpPadEst,;
				    ADM->cCarPadEst,;
				    ADM->cTelPadEst,;
				    ALLTRIM(ADM->cNomMadEst)+' '+;
				    ALLTRIM(ADM->cApeMadEst),;
				    ADM->cMadNitEst,;
				    ADM->cMadLugEst,;
				    ADM->cProMadEst,;
				    ADM->cEmpMadEst,;
				    ADM->cCarMadEst,;
				    ADM->cTelMadEst,;
				    ALLTRIM(ADM->cNomAcuEst)+' '+;
				    ALLTRIM(ADM->cApeAcuEst),;
				    ADM->cAcuNitEst,;
				    ADM->cAcuLugEst,;
				    ADM->cTe1AcuEst,;
				    dFecMatTes,;
				    cHorMatTes,;
				    cObserv,cNomSis,;
				    cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		       *ÀHoja de Matr¡cula. Distrito La Salle. Bogota

		    CASE ANO->nTipMtrAno == 5
			 HojaMatr05(ADM->cCodigoEst,;
				    lNuevos,;
				    .F.,;
				    VAL(SUBS(ADM->cCodigoGru,1,2)),;
				    ADM->cNombreEst,;
				    ADM->cApelliEst,;
				    ADM->dFecNacEst,;
				    ADM->cLugNacEst,;
				    ADM->cDocNitEst,;
				    ADM->cLugNitEst,;
				    ADM->cDireccEst,;
				    ADM->cBarrioEst,;
				    ADM->cTelefnEst,;
				    ADM->cTelCelEst,;
				    ADM->cMaiEstEst,;
				    ALLTRIM(ADM->cNomPadEst)+' '+;
				    ALLTRIM(ADM->cApePadEst),;
				    ADM->cPadNitEst,;
				    ADM->cPadLugEst,;
				    ADM->cProPadEst,;
				    ADM->cEmpPadEst,;
				    ADM->cCarPadEst,;
				    ADM->cTelPadEst,;
                                    ADM->cDirPadEst,;
				    ADM->cCelPadEst,;
				    ALLTRIM(ADM->cNomMadEst)+' '+;
				    ALLTRIM(ADM->cApeMadEst),;
				    ADM->cMadNitEst,;
				    ADM->cMadLugEst,;
				    ADM->cProMadEst,;
				    ADM->cEmpMadEst,;
				    ADM->cCarMadEst,;
				    ADM->cTelMadEst,;
                                    ADM->cDirMadEst,;
				    ADM->cCelMadEst,;
				    ALLTRIM(ADM->cNomAcuEst)+' '+;
				    ALLTRIM(ADM->cApeAcuEst),;
				    ADM->cAcuNitEst,;
				    ADM->cAcuLugEst,;
				    ADM->cTe1AcuEst,;
                                    ADM->cDirAcuEst,;
				    ADM->cProAcuEst,;
				    ADM->cCelAcuEst,;
				    dFecMatTes,;
				    cHorMatTes,;
				    cObserv,cNomSis,;
				    cNomEmp,cAnoUsr,cJorTxt,cCodIso)
		       *ÀHoja de Matr¡cula. F-AM-04 30-09-2010

		    ENDCASE
		    SET DEVICE TO SCREEN

		 ENDIF
*--------------FIN IMPRESION DE LA MATRICULA

	       ADM->(DBSKIP())

	    ENDDO
**********FIN IMPRESION DE LAS HOJAS DE LA MATRICULA

	  nNroNiv++

       ENDDO
       SET FILTER TO
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME