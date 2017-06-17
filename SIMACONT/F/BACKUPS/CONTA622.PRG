/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : CERTIFICADOS
SUBMODULO...: PAZ Y SALVOS. IMPRESION

**************************************************************************
* TITULO..: IMPRESION DE PAZ Y SALVOS                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2002 LUN A
       Colombia, Bucaramanga        INICIO: 08:00 PM   NOV 18/2002 LUN

OBJETIVOS:

1- Permite imprimir los paz y Salvos.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_622(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #DEFINE  PAGINA33 CHR(27)+'C'+CHR(33)// P gina de 33 l¡neas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀVariables de informe

       LOCAL dFecPaz := CTOD('00/00/00')    // Fecha del Paz y Salvo
       LOCAL cTitulo := ''                  // T¡tulo para el Paz y Salvo

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>DECLARACION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<POR GRUPOS    >')
       AADD(aMenus,'2<POR ESTUDIANTE>')

       AADD(aAyuda,'Imprime los Paz y Salvos por Grupos')
       AADD(aAyuda,'Imprime los Pay y Salvos por Estudiante')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE PAZ->(RECCOUNT()) == 0
	    cError('NO EXISTEN ITEMS DE PAZ Y SALVOS CREADOS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE COA->nNroPazCoA > 3
	    cError('EL TIPO DE PAZ Y SALVO No. '+STR(COA->nNroPazCoA,2)+' '+;
		   'NO ESTA DISPONIBLE')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DE LA FECHA
       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'FECHA DEL PAZ Y SALVO: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA:' GET dFecPaz PICT '@D'
       READ
       IF EMPTY(dFecPaz)
	  CloseAll()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA FECHA

*>>>>LECTURA DEL TITULO
       IF COA->nNroPazCoA <= 2
	  cSavPan := SAVESCREEN(0,0,24,79)
	  cTitulo := SPACE(40)
	  @ nFilInf+1,nColInf SAY 'TITULO:' GET cTitulo PICT '@S14'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
*>>>>FIN LECTURA DEL TITULO

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 622
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '[CERTIFICADOS][PAZ Y SALVOS][IMPRESION]'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'Sco62200'
       AADD(aMarInf,{75,78})  // MS:ID C¢digo Iso,Versi¢n Iso
       AADD(aMarInf,{77,120}) // MI:ID Fecha Iso, PiePag Uno
       AADD(aMarInf,{0,0})    // M1:ID
       AADD(aMarInf,{0,0})    // M2:ID

       nNroDoc := 0
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'PAZ Y SALVO FI¥AL DE A¥O')  // T¡tulo Uno
       AADD(aTitIso,'')	                         // T¡tulo Dos
       AADD(aTitIso,'')                          // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')

       cUsrIso := SCO->cUsrIsoSco
       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroInf,aTitIso[1],cOpcSys,;
				cUsrIso,;
				cCodInf,aMarInf,nNroDoc,aObsIso)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>CONTROL DE DOCUMENTOS
       IF nNroInf # 0
	  cCodIso := ALLTRIM(ISO->cCodigoIso)
	  cFecIso := ALLTRIM(ISO->cFecAprIso)
	  cVerIso := ALLTRIM(ISO->cNroVerIso)
       ENDIF
*>>>>FIN CONTROL DE DOCUMENTOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF nNroInf == 0
	  FilePrn := 'PazSalvo'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.,.T.)
       ELSE
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.,2,bInsIso)
       ENDIF
       IF EMPTY(nOpcPrn)
	  CloseAll()
	  RETURN NIL
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       fDocPrn := ''
       IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
		      @cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
		      @fDocPrn)
	  CloseAll()
	  RETURN NIL
       ENDIF
       ReplTitIso(@aTitIso,aMezIso)
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>PARAMETROS ESPECIFICOS
       AADD(aP2,{'dFecPaz',dFecPaz})
       AADD(aP2,{'cTitulo',cTitulo})
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>PARAMETROS DEL INFORME
       AADD(aP3,{'nCodXsl',SCO->nCodXslSco})
       AADD(aP3,{'nOpcPrn',nOpcPrn})
       AADD(aP3,{'FilePrn',FilePrn})

       AADD(aP3,{'nLenPrn',nLenPrn})
       AADD(aP3,{'nNroInf',nNroInf})
       AADD(aP3,{'cOpcSys',cOpcSys})
       AADD(aP3,{'cCodInf',cCodInf})
       AADD(aP3,{'aMarInf',aMarInf})
       AADD(aP3,{'nNroDoc',nNroDoc})
       AADD(aP3,{'aTitIso',aTitIso})
       AADD(aP3,{'aPieIso',aPieIso})
       AADD(aP3,{'aObsIso',aObsIso})
       AADD(aP3,{'cUsrIso',cUsrIso})
       AADD(aP3,{'cLogEmp',cPathSima()+'\SIMACONT\BASES\'+SCO->cLogEmpSco})
       AADD(aP3,{'cCodIso',cCodIso})
       AADD(aP3,{'cFecIso',cFecIso})
       AADD(aP3,{'cVerIso',cVerIso})
*>>>>FIN PARAMETROS DEL INFORME

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Cont_6221(aP1,aP2,aP3)
	   *Paz y Salvos por Grupos

       CASE nNroOpc == 2
	    Cont_6222(aP1,aP2,aP3)
	   *Paz y Salvos por Estudiante

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION DE PAZ Y SALVOS POR GRUPOS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2002 LUN A
       Colombia, Bucaramanga        INICIO: 08:00 PM   NOV 18/2002 LUN

OBJETIVOS:

1- Imprime por grupos y n£mero de lista los paz y salvos de los estudiantes

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cont_6221(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARCION PARAMETROS ESPECIFICOS
       LOCAL dFecPaz := xPrm(aP2,'dFecPaz') // Fecha del Paz y Salvo
       LOCAL cTitulo := xPrm(aP2,'cTitulo') // T¡tulo del Paz y Salvo
*>>>>FIN DECLARCION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cPatTem := ''                  // Path Temporal

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL nOpcPrn := xPrm(aP3,'nOpcPrn') // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL cNombreTes := ''               // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('GRU')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseDbf('GRU')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseDbf('GRU')
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseDbf('GRU')
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>INICIALIZACION DE LA IMPRESORA
       FilePrn := xPrm(aP3,'FilePrn')

       SET DEVICE TO PRINT
       SendCodes(PCL({'Reset','ProporOf'}))
       SendCodes(PCL({'CondenOf','Pica','NegraOn','DraftOn','Mcarta'}))
       SET DEVICE TO SCREEN
*>>>>FIN INICIALIZACION DE LA IMPRESORA

*>>>>IMPRESION POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\'+cMaeAct+'\NOTAS')

	       CloseDbf('GRU')
	       CloseDbf('NOT')
	       RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT NOT
	    GO nNroIni
	    DO WHILE .NOT. EOF()

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			      cGruFin+'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			      NOT->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS PARA LA SALIDA DEL MODULO
		 SELECT NOT
		 IF nNroFin <> 0
		    IF NOT->(RECNO()) > nNroFin
		       VerPrn(nOpcPrn,FilePrn,nHanXml)
		       CloseDbf('GRU')
		       CloseDbf('NOT')
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA DEL MODULO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF &cMaeAct->lRetiroEst
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------IMPRESION DEL PAZ Y SALVO
		 SET DEVICE TO PRINT
		 DO CASE
		 CASE COA->nNroPazCoA == 0 .OR. COA->nNroPazCoA == 1

		       PazSalvo01(cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
				  &cMaeAct->cCodigoEst,cNombreTes,;
				  &cMaeAct->cCodigoGru,dFecPaz,;
				  cTitulo)

		 CASE COA->nNroPazCoA == 2

		       PazSalvo02(cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
				  &cMaeAct->cCodigoEst,cNombreTes,;
				  &cMaeAct->cCodigoGru,dFecPaz,;
				  cTitulo)

		 CASE COA->nNroPazCoA == 3

		       PazSalvo03(aP3,cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
				  &cMaeAct->cCodigoEst,cNombreTes,;
				  &cMaeAct->cCodigoGru,dFecPaz,;
				  cTitulo)

		 ENDCASE
		 SET DEVICE TO SCREEN
*--------------FIN IMPRESION DEL PAZ Y SALVO

	       SELECT NOT
	       NOT->(DBSKIP())

	    ENDDO
	    CloseDbf('NOT')
**********FIN IMPRESION DEL CUERPO DEL INFORME

	  nNroIni := 1
	  SELECT GRU
	  GRU->(DBSKIP())

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       CloseDbf('GRU')
       RETURN NIL
*>>>>FIN IMPRESION POR GRUPOS

/*************************************************************************
* TITULO..: IMPRESION DEL PAZ Y SALVO POR ESTUDIANTE                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:30 PM   NOV 18/2002 LUN

OBJETIVOS:

1- Imprime los Paz y Salvos por c¢digo del Estudiante.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cont_6222(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARCION PARAMETROS ESPECIFICOS
       LOCAL dFecPaz := xPrm(aP2,'dFecPaz') // Fecha del Paz y Salvo
       LOCAL cTitulo := xPrm(aP2,'cTitulo') // T¡tulo del Paz y Salvo
*>>>>FIN DECLARCION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL cPatTem := ''                  // Path Temporal

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL nOpcPrn := xPrm(aP3,'nOpcPrn') // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL cNombreTes := ''               // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LA IMPRESORA
       FilePrn := xPrm(aP3,'FilePrn')

       SET DEVICE TO PRINT
       SendCodes(PCL({'Reset','ProporOf'}))
       SendCodes(PCL({'CondenOf','Pica','NegraOn','DraftOn','Mcarta'}))
       SET DEVICE TO SCREEN
*>>>>FIN INICIALIZACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION POR CODIGO
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    CloseDbf('NOT')
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAct,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+&cNalias->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      &cNalias->cCodigoGru)
	       LOOP
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',&cNalias->cCodigoEst)

	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO EXISTE EN NOTAS DEL GRUPO '+&cNalias->cCodigoGru)
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado(cNombreTes+' '+&cNalias->cCodigoGru+;
			'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO PERTENECE AL GRUPO '+&cNalias->cCodigoGru)

	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********IMPRESION DEL TIPO DE BOLETIN
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE COA->nNroPazCoA == 0 .OR. COA->nNroPazCoA == 1

		 PazSalvo01(cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
			    &cNalias->cCodigoEst,cNombreTes,;
			    &cNalias->cCodigoGru,dFecPaz,;
			    cTitulo)

	    CASE COA->nNroPazCoA == 2

		 PazSalvo02(cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
			    &cNalias->cCodigoEst,cNombreTes,;
			    &cNalias->cCodigoGru,dFecPaz,;
			    cTitulo)

	    CASE COA->nNroPazCoA == 3

		  PazSalvo03(aP3,cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
			     &cMaeAct->cCodigoEst,cNombreTes,;
			     &cMaeAct->cCodigoGru,dFecPaz,;
			     cTitulo)
	    ENDCASE

	    SET DEVICE TO SCREEN
	    @ nNroFil,aNroCol[1] SAY cCodigoTes
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN IMPRESION DEL TIPO DE BOLETIN

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,;
				   'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION POR CODIGO

/*************************************************************************
* TITULO..: FORMATO DE PAZ Y SALVO No. 01                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2002 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 PM   NOV 18/2002 LUN

OBJETIVOS:

1- Imprime el recibo de paz y salvo seg£n el archivo de Paz y Salvo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION PazSalvo01(cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
		    cCodEst,cNomEst,cCodGru,dFecPaz,;
		    cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del Grupo
       dFecPaz                              // Fecha del Paz y Salvo
       cTitulo                              // T¡tulo del Paz y Salvo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nLinFec := 4                   // L¡neas para la fecha
       LOCAL nNroCol := 0                   // N£mero de Columnas
       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL TITULO
       nNroCol := ((40-LEN(ALLTRIM(cNomEmp))))/2
       SendCodes(DOBANC_ON)
       @ PROW()+1,nNroCol SAY cNomEmp

       cTxtPrn := 'COMPROBANTE DE PAZ Y SALVO'
       nNroCol := ((40-LEN(ALLTRIM(cTxtPrn))))/2
       SendCodes(DOBANC_ON)
       @ PROW()+1,nNroCol SAY cTxtPrn
       SendCodes(DOBANC_OF)

       cTxtPrn := 'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt
       nNroCol := ((80-LEN(cTxtPrn)))/2
       @ PROW()+1,nNroCol SAY cTxtPrn

       IF !EMPTY(cTitulo)
	  cTitulo := ALLTRIM(ctitulo)
	  nNroCol := ((80-LEN(cTitulo)))/2
	  @ PROW()+1,nNroCol SAY cTitulo

	  cTxtPrn := 'ALUMNO(A): '+cNomEst
	  @ PROW()+1,02 SAY cTxtPrn
       ELSE
	  cTxtPrn := 'ALUMNO(A): '+cNomEst
	  @ PROW()+2,02 SAY cTxtPrn
       ENDIF
*>>>>FIN IMPRESION DEL TITULO

*>>>>DATOS DEL ESTUDIANTE
       @ PROW()+1,02 SAY 'CODIGO: '+cCodEst+;
			 ' CURSO: '+cCodGru+SPACE(20)+;
			 ' FECHA DEL PAZ Y SALVO:'+cFecha(dFecPaz)
     *ÀImpresi¢n del encabezado.
*>>>>FIN DATOS DEL ESTUDIANTE

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {24,12,30,10}
       aTitulo := {'DEPENDENCIA ','PAZ Y SALVO','FIRMAS PENDIENTE','FECHA'}
       cTxtPrn := cRegPrint(aTitulo,@aNroCol)
       @ PROW()+1,02 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+1,02 SAY cTxtPrn
       @ PROW()+1,02 SAY REPL('-',LEN(cTxtPrn))
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION ITEMS DE PAZ Y SALVOS
       PAZ->(DBGOTOP())
       DO WHILE .NOT. PAZ->(EOF())
	  aTitulo := {}
	  AADD(aTitulo,STR(PAZ->nCodigoPaz,2)+' '+PAZ->cNombrePaz)
	  IF SUBS(&cMaeAct->cPazSdoEst,PAZ->nCodigoPaz,1) == SPACE(01)
	     AADD(aTitulo,'AL DIA')
	     AADD(aTitulo,SPACE(10))
	     AADD(aTitulo,SPACE(10))
	  ELSE
	     AADD(aTitulo,'EN DEUDA')
	     AADD(aTitulo,REPL('.',30))
	     AADD(aTitulo,'__/__/____')
	  ENDIF
	  cTxtPrn := cRegPrint(aTitulo,@aNroCol)
	  @ PROW()+1,02 SAY cTxtPrn
	  PAZ->(DBSKIP())
       ENDDO
       IF PAZ->(RECCOUNT()) <= 17
	  SendCodes(CONDEN_ON)
	  @ PROW()+2,02 SAY ALLTRIM(COA->cTitPazCoA)
	  SendCodes(CONDEN_OF)
       ENDIF
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION ITEMS DE PAZ Y SALVOS

/*************************************************************************
* TITULO..: FORMATO DE PAZ Y SALVO No. 02                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2003 MAR A
       Colombia, Bucaramanga        INICIO: 09:00 PM   OCT 21/2003 MAR

OBJETIVOS:

1- Imprime el recibo de paz y salvo sin firmas particulares

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION PazSalvo02(cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
		    cCodEst,cNomEst,cCodGru,dFecPaz,;
		    cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del Grupo
       dFecPaz                              // Fecha del Paz y Salvo
       cTitulo                              // Titulo de Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nLinFec := 4                   // L¡neas para la fecha
       LOCAL nNroCol := 0                   // N£mero de Columnas
       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n
       LOCAL nNroIte := 0                   // N£mero del Item
       LOCAL cDepen1 := ''                  // Dependencia No.1
       LOCAL cPazNo1 := ''                  // Paz y Salvo No.1
       LOCAL cDepen2 := ''                  // Dependencia No.2
       LOCAL cPazNo2 := ''                  // Paz y Salvo No.2

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL TITULO
       nNroCol := ((40-LEN(ALLTRIM(cNomEmp))))/2
       SendCodes(DOBANC_ON)
       @ PROW()+1,nNroCol SAY cNomEmp

       cTxtPrn := 'COMPROBANTE DE PAZ Y SALVO'
       nNroCol := ((40-LEN(ALLTRIM(cTxtPrn))))/2
       SendCodes(DOBANC_ON)
       @ PROW()+1,nNroCol SAY cTxtPrn
       SendCodes(DOBANC_OF)

       cTxtPrn := 'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt
       nNroCol := ((80-LEN(cTxtPrn)))/2
       @ PROW()+1,nNroCol SAY cTxtPrn

       IF !EMPTY(cTitulo)
	  cTitulo := ALLTRIM(ctitulo)
	  nNroCol := ((80-LEN(cTitulo)))/2
	  @ PROW()+1,nNroCol SAY cTitulo

	  cTxtPrn := 'ALUMNO(A): '+cNomEst
	  @ PROW()+1,02 SAY cTxtPrn
       ELSE
	  cTxtPrn := 'ALUMNO(A): '+cNomEst
	  @ PROW()+2,02 SAY cTxtPrn
       ENDIF
*>>>>FIN IMPRESION DEL TITULO

*>>>>DATOS DEL ESTUDIANTE
       @ PROW()+1,02 SAY 'CODIGO: '+cCodEst+;
			 ' CURSO: '+cCodGru+SPACE(20)+;
			 ' FECHA DEL PAZ Y SALVO:'+cFecha(dFecPaz)
     *ÀImpresi¢n del encabezado.
*>>>>FIN DATOS DEL ESTUDIANTE

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {24,12,24,12}
       aTitulo := {'DEPENDENCIA ','PAZ Y SALVO','DEPENDENCIA','PAZ Y SALVO'}
       cTxtPrn := cRegPrint(aTitulo,@aNroCol)
       @ PROW()+1,02 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+1,02 SAY cTxtPrn
       @ PROW()+1,02 SAY REPL('-',LEN(cTxtPrn))
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION ITEMS DE PAZ Y SALVOS
       PAZ->(DBGOTOP())
       DO WHILE .NOT. PAZ->(EOF())

	  nNroIte++
	  IF nNroIte == 1
	     cDepen1 := STR(PAZ->nCodigoPaz,2)+' '+PAZ->cNombrePaz
	     IF SUBS(&cMaeAct->cPazSdoEst,PAZ->nCodigoPaz,1) == SPACE(01)
		cPazNo1 := 'AL DIA'
	     ELSE
		cPazNo1 := 'EN DEUDA'
	     ENDIF
	  ENDIF

	  IF nNroIte == 2
	     cDepen2 := STR(PAZ->nCodigoPaz,2)+' '+PAZ->cNombrePaz
	     IF SUBS(&cMaeAct->cPazSdoEst,PAZ->nCodigoPaz,1) == SPACE(01)
		cPazNo2 := 'AL DIA'
	     ELSE
		cPazNo2 := 'EN DEUDA'
	     ENDIF
	  ENDIF

	  IF nNroIte == 2
	     aTitulo := {}
	     AADD(aTitulo,cDepen1)
	     AADD(aTitulo,cPazNo1)
	     AADD(aTitulo,cDepen2)
	     AADD(aTitulo,cPazNo2)

	     cTxtPrn := cRegPrint(aTitulo,@aNroCol)
	     @ PROW()+1,02 SAY cTxtPrn

	     cDepen1 := ''
	     cPazNo1 := ''
	     cDepen2 := ''
	     cPazNo2 := ''
	     nNroIte := 0
	  ENDIF

	  PAZ->(DBSKIP())

	  IF PAZ->(EOF()) .AND. nNroIte == 1
	     aTitulo := {}
	     AADD(aTitulo,cDepen1)
	     AADD(aTitulo,cPazNo1)
	     AADD(aTitulo,cDepen2)
	     AADD(aTitulo,cPazNo2)

	     cTxtPrn := cRegPrint(aTitulo,@aNroCol)
	     @ PROW()+1,02 SAY cTxtPrn
	  ENDIF
       ENDDO

       Firmas1(PCL('n17Stan'),6,;
		  {{'Tesorer¡a','',''},;
		   {'Coordinaci¢n','',''}},.F.,30,07)

       EJECT
       RETURN NIL
*>>>>FIN IMPRESION ITEMS DE PAZ Y SALVOS

/*************************************************************************
* TITULO..: FORMATO DE PAZ Y SALVO No. 03                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2002 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 PM   NOV 18/2002 LUN

OBJETIVOS:

1- Imprime el recibo de paz y salvo seg£n el archivo de Paz y Salvo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PazSalvo03(aP3,cNomEmp,cAnoUsr,cJorTxt,cMaeAct,;
		    cCodEst,cNomEst,cCodGru,dFecPaz,;
		    cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     aP3                                  // Parametros Generales
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del Grupo
       dFecPaz                              // Fecha del Paz y Salvo
       cTitulo                              // T¡tulo del Paz y Salvo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,x := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cLogEmp := ''                  // Logo de la Empresa
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n

       LOCAL nLinFec := 4                   // L¡neas para la fecha
       LOCAL nNroCol := 0                   // N£mero de Columnas
       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := xPrm(aP3,'nLenPrn')

       nNroInf := xPrm(aP3,'nNroInf')
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := xPrm(aP3,'cOpcSys')
     *ÀOpci¢n del sistema del informe

       cLogEmp := xPrm(aP3,'cLogEmp')
       cCodInf := xPrm(aP3,'cCodInf')
       aMarInf := xPrm(aP3,'aMarInf')
       nNroDoc := xPrm(aP3,'nNroDoc')
     *ÀInforme por defecto

       aTitIso := xPrm(aP3,'aTitIso')
     *ÀT¡tulos del Informe por defecto

       aPieIso := xPrm(aP3,'aPieIso')
     *ÀPie de p ginas por defecto

       aObsIso := xPrm(aP3,'aObsIso')

       cUsrIso := xPrm(aP3,'cUsrIso')
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>CONTROL DE DOCUMENTOS
       cLogEmp := xPrm(aP3,'cLogEmp')
       cCodIso := xPrm(aP3,'cCodIso')
       cFecIso := xPrm(aP3,'cFecIso')
       cVerIso := xPrm(aP3,'cVerIso')
*>>>>FIN CONTROL DE DOCUMENTOS

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {24,12,30,10}
       aTitulo := {'DEPENDENCIA ','PAZ Y SALVO','FIRMAS PENDIENTE','FECHA'}
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DEL TITULO
       SETPRC(PROW(),0)

       SendCodes(PCL({'NegraOn','CondenOn'}))

       cTxtPrn := REPL('_',LEN(cCabCol)+60)
       nNroCol := 03
       @ PROW(),nNroCol SAY cTxtPrn
     *ÀL¡nea del encabezado

       @ PROW()+2,004 SAY '"'+cLogEmp+'"'

       IF !EMPTY(cCodIso)
	  nNroCol := aMarInf[1,1]
	  @ PROW(),nNroCol SAY 'C¢digo: '+cCodIso
       ENDIF
       SendCodes(PCL('CondenOf'))

       cTxtPrn := aTitIso[1]
       nNroCol := ((80-LEN(ALLTRIM(cTxtPrn))))/2
       @ PROW()+1,nNroCol SAY cTxtPrn
     *ÀT¡tulo

       IF !EMPTY(cVerIso)
	  SendCodes(PCL('CondenOn'))
	  nNroCol := aMarInf[1,2]
	  @ PROW(),nNroCol SAY 'Versi¢n: '+cVerIso
	  SendCodes(PCL('CondenOf'))
       ENDIF

       IF !EMPTY(cFecIso)
	  SendCodes(PCL('CondenOn'))
	  nNroCol := aMarInf[2,1]
	  @ PROW()+1,nNroCol SAY 'Fecha: '+cFecIso
	  SendCodes(PCL('CondenOf'))
       ENDIF

       cTxtPrn := REPL('_',LEN(cCabCol))
       nNroCol := 02
       @ PROW()+1,nNroCol SAY cTxtPrn
     *ÀL¡nea del encabezado

       IF !EMPTY(cTitulo)
	  cTitulo := ALLTRIM(ctitulo)
	  nNroCol := ((80-LEN(cTitulo)))/2
	  @ PROW()+1,nNroCol SAY cTitulo

	  cTxtPrn := 'ALUMNO(A): '+cNomEst
	  @ PROW()+1,02 SAY cTxtPrn
       ELSE
	  cTxtPrn := 'ALUMNO(A): '+cNomEst
	  @ PROW()+2,02 SAY cTxtPrn
       ENDIF
*>>>>FIN IMPRESION DEL TITULO

*>>>>DATOS DEL ESTUDIANTE
       SendCodes(PCL('NegraOf'))
       @ PROW()+1,02 SAY 'CODIGO: '+cCodEst+;
			 ' CURSO: '+cCodGru+SPACE(20)+;
			 ' FECHA DEL PAZ Y SALVO:'+cFecha(dFecPaz)
     *ÀImpresi¢n del encabezado.
*>>>>FIN DATOS DEL ESTUDIANTE

*>>>>ENCABEZADOS DE COLUMNA
       cTxtPrn := cCabCol
       @ PROW()+1,02 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+1,02 SAY cTxtPrn
       @ PROW()+1,02 SAY REPL('-',LEN(cTxtPrn))
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION ITEMS DE PAZ Y SALVOS
       PAZ->(DBGOTOP())
       DO WHILE .NOT. PAZ->(EOF())
	  aTitulo := {}
	  AADD(aTitulo,STR(PAZ->nCodigoPaz,2)+' '+PAZ->cNombrePaz)
	  IF SUBS(&cMaeAct->cPazSdoEst,PAZ->nCodigoPaz,1) == SPACE(01)
	     AADD(aTitulo,'AL DIA')
	     AADD(aTitulo,SPACE(10))
	     AADD(aTitulo,SPACE(10))
	  ELSE
	     AADD(aTitulo,'EN DEUDA')
	     AADD(aTitulo,REPL('.',30))
	     AADD(aTitulo,'__/__/____')
	  ENDIF
	  cTxtPrn := cRegPrint(aTitulo,@aNroCol)
	  @ PROW()+1,02 SAY cTxtPrn
	  PAZ->(DBSKIP())
       ENDDO
       IF PAZ->(RECCOUNT()) <= 17
	  SendCodes(PCL('CondenOn'))
	  @ PROW()+2,02 SAY ALLTRIM(COA->cTitPazCoA)
	  SendCodes(PCL('CondenOf'))
       ENDIF
*>>>>FIN IMPRESION ITEMS DE PAZ Y SALVOS

*>>>>IMPRESION DEL PIE DE PAGINA
       IF !EMPTY(aPieIso[1])
	  SendCodes(PCL('CondenOn'))
	  nNroCol := aMarInf[2,2]
	  @ PROW()+1,nNroCol SAY ALLTRIM(aPieIso[1])
	  SendCodes(PCL('CondenOf'))
       ENDIF
*       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL PIE DE PAGINA