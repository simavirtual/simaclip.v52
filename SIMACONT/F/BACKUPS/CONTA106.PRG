/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INICIO DE A¥O
SUBMODULO...: PLAN ACADEMICO

**************************************************************************
* TITULO..: PLAN ACADEMICO                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/1995 VIE A
       Colombia, Bucaramanga        INICIO: 10:10 AM   MAY 12/1995 VIE


OBJETIVOS:

1- Permite crear o actualizar el plan acad‚mico por niveles

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_106(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n

       LOCAL cPatTem := ''                  // Path temporal
       LOCAL cNroNiv := ''                  // N£mero de nivel
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
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
       IF  !lParam0102(aParams,;
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuN,'SUN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuG,'SUG',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CREACION DE LOS NIVELES
       DO CASE
       CASE 'JAR' $ cMaeAct

	    aMenus := {'1<MATERNALES >',;
		       '2<CAMINADORES>',;
		       '3<PARVULOS   >',;
		       '4<PRE JARDIN >',;
		       '5<JARDIN A   >'}

       CASE 'PRI' $ cMaeAct
	    aMenus := {'1<TRANSCION>',;
		       '2<PRIMERO  >',;
		       '3<SEGUNDO  >',;
		       '4<TERCERO  >',;
		       '5<CUARTO   >',;
		       '6<QUINTO   >'}

       CASE 'BTO' $ cMaeAct
	    aMenus := {'1<SEXTO   >',;
		       '2<SEPTIMO >',;
		       '3<OCTAVO  >',;
		       '4<NOVENO  >',;
		       '5<DECIMO  >',;
		       '6<UNDECIMO>'}
       ENDCASE
*>>>>FIN CREACION DE LOS NIVELES

*>>>>SELECCION Y CREACION DEL PLAN ACADEMICO
       DO WHILE .T.

**********SELECCION DEL NIVEL
	    SAVE SCREEN
	    nNroOpc := nMenu(aMenus,NIL,nFilInf+1,nColInf,NIL,NIL,nNroOpc,.F.)
	    RESTORE SCREEN

	    IF nNroOpc == 0
	       EXIT
	    ENDIF

	    DO CASE
	    CASE 'JAR' $ cMaeAct
		 cNroNiv := SUBS('1213141516',nNroOpc*2-1,2)

	    CASE 'PRI' $ cMaeAct
		 cNroNiv := SUBS('000102030405',nNroOpc*2-1,2)

	    CASE 'BTO' $ cMaeAct
		 cNroNiv := SUBS('060708091011',nNroOpc*2-1,2)
	    ENDCASE
**********FIN SELECCION DEL NIVEL

**********LOCALIZACION DEL NIVEL
	   IF !lLocCodigo('cCodigoNiv','NIV',cNroNiv)
	      cError('EL NIVEL '+cNroNiv+' NO EXISTE')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN LOCALIZACION DEL NIVEL

**********ANALISIS DEL PLAN ACADEMICO POR GRUPO
	    cCodigoTgr := cNroNiv
	    FilePla := 'PLAN'+cNroNiv+cAnoSis+ExtFile
	    IF NIV->lPlaGruNiv

*--------------FILTRACION DEL GRUPO POR NIVELES
		 SELECT GRU
		 SET FILTER TO SUBS(GRU->cCodigoGru,1,2) == cNroNiv
		 GO TOP
		 IF EOF()
		    cError('NO EXISTEN GRUPOS PARA EL NIVEL '+cNroNiv)
		    GRU->(DBCLEARFILTER())
		    CLOSE ALL
		    RETURN NIL
		 ENDIF
*--------------FIN FILTRACION DEL GRUPO POR NIVELES

*--------------LECTURA DEL CODIGO DEL GRUPO
		 cCodigoTgr := cSpaces('GRU','cCodigoGru')
		 @ nFilInf+1,nColInf SAY 'GRUPO:';
				     GET cCodigoTgr PICT '@9';
				     VALID lValGrupo(ROW(),COL()-4,@cCodigoTgr)
		 READ
		 GRU->(DBCLEARFILTER())

		 IF EMPTY(cCodigoTgr)
		    CLOSE ALL
		    RETURN NIL
		 ENDIF
		 FilePla := 'PL'+cCodigoTgr+cAnoSis+ExtFile
*--------------FIN LECTURA DEL CODIGO DEL GRUPO

	    ENDIF
**********FIN ANALISIS DEL PLAN ACADEMICO POR GRUPO

**********FILTRACION DEL GRUPO POR GRUPO O NIVEL
	    SELECT GRU
	    IF NIV->lPlaGruNiv

*--------------FILTRACION DEL GRUPO POR GRUPO ESCOGIDO
		 SET FILTER TO GRU->cCodigoGru == cCodigoTgr
		 GO TOP
		 IF EOF()
		    cError('NO EXISTE GRUPO '+cCodigoTgr)
		    GRU->(DBCLEARFILTER())
		    CLOSE ALL
		    RETURN NIL
		 ENDIF
*--------------FIN FILTRACION DEL GRUPO POR GRUPO ESCOGIDO

	    ELSE

*--------------FILTRACION DEL GRUPO POR GRUPOS DEL NIVEL
		 SET FILTER TO SUBS(GRU->cCodigoGru,1,2) == cNroNiv
		 GO TOP
		 IF EOF()
		    cError('NO EXISTE GRUPOS PARA EL NIVEL '+cNroNiv)
		    GRU->(DBCLEARFILTER())
		    CLOSE ALL
		    RETURN NIL
		 ENDIF
*--------------FIN FILTRACION DEL GRUPO POR GRUPOS DEL NIVEL

	    ENDIF
**********FIN FILTRACION DEL GRUPO POR GRUPO O NIVEL

**********CREACION DEL PLAN ACADEMICO PARA EL NIVEL ESCOGIDO
	    IF !FILE(cPatSis+'\'+cMaeAct+'\'+FilePla)
	       CreaDbfPla(cPatSis+'\'+cMaeAct,FilePla,cCodigoTgr)
	    ENDIF

	    MantenPla(aParam1,aParam2,aParam3,;
		      cCodigoTgr)

**********FIN CREACION DEL PLAN ACADEMICO PARA EL NIVEL ESCOGIDO


       ENDDO
       GRU->(DBCLEARFILTER())
       CloseAll()
       RETURN NIL
*>>>>SELECCION Y CREACION DEL PLAN ACADEMICO

