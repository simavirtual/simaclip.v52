/* SIMA - MATRICULA ACADEMICA

MODULO      : HOJA DE VIDA
SUBMODULO...: INFORMACION ADICIONAL

**************************************************************************
* TITULO..: GRABACION INFORMACION ADICIONAL                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 28/2006 MAR A
       Colombia, Bucaramanga        INICIO: 03:30 PM   NOV 28/2006 MAR


OBJETIVOS:

1- Permite grabar informaci¢n adicional sobre el estudiante.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_373(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNumeroTad := ''               // N£mero de Inscripci¢n
       LOCAL cNombreTes := ''               // Nombre del estudiante
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
			 FileToG,'TOG',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FileSoG,'SOG',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FileObG,'OBG',;
			 PathUno+'\'+PathSis+'\'+;
			 fNtxObG,lShared,nModCry})

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
       CASE TOG->(RECCOUNT()) == 0
	    cError('No Existen Tipos de Observaciones Generales')

       CASE SOG->(RECCOUNT()) == 0
	    cError('No existen Clasificaci¢n Tipos de Observaciones Generales')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DEL TIPO DE OBSERVACION
       IF EMPTY(nSelSoG(nFilInf+1,nColInf))
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DEL TIPO DE OBSERVACION

*>>>>FILTRACION DEL ARCHIVO
       SELECT TOG
       SET FILTER TO TOG->cCodigoSoG == SOG->cCodigoSoG
       TOG->(DBGOTOP())
       IF TOG->(EOF())
	  cError('NO EXISTEN TIPOS DE OBSERVACIONES GENERALES PARA GRABAR')
	  SET FILTER TO
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES A ACTUALIZAR',22,'°')
       aTamCol := {06,06,50}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LAS OBSERVACIONES GENERALES
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)
	    IF lLeeCodAdm(nNroFil,aNroCol[1],;
			  @cNumeroTad,{||lLocCodigo('cNumeroAdm',;
					 'ADM',cNumeroTad,;
					 'NUMERO DE INSCRIPCION')})
		EXIT
	    ENDIF
	    cNombreTes := RTRIM(SUBS(RTRIM(ADM->cNombreEst)+;
				     ' '+ADM->cApelliEst,1,50))
**********FIN LECTURA DEL CODIGO

**********ANALISIS SI EL CANDIDATO ESTA RETIRADO
	    IF ADM->lRetiroAdm
	       cError(cNombreTes+ ' ESTA RETIRADO')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL CANDIDATO ESTA RETIRADO

**********GRABACION DE LA INFORMACION ADICIONAL
	    @ nNroFil,aNroCol[2] SAY ADM->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes+' '+ADM->cCodigoEst

	    cSavPan := SAVESCREEN(0,0,24,79)
	    lInfAdiEst(lShared)
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN GRABACION DE LA INFORMACION ADICIONAL

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LAS OBSERVACIONES GENERALES

/*************************************************************************
* TITULO..: GRABACION DE LA INFORMACION ADICIONAL                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2006 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   DIC 06/2006 MIE

OBJETIVOS:

1- Permite grabar la informaci¢n adicional de los estudiantes.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lInfAdiEst(lShared,cCodEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cCodEst                              // C¢digo del Estudiante */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aLeeGet := {}                  // Lectura de las observaciones
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(03,'POR FAVOR ACTUALICE LA INFORMACION DEL '+;
			    'ESTUDIANTE',22,'°')
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>RECORRIDO POR SUB OBSERVACIONES GENERALES
       SELECT TOG
       TOG->(DBGOTOP())
       DO WHILE .NOT. TOG->(EOF())

	  AADD(aLeeGet,{ALLTRIM(TOG->cNombreTog),;
			SPACE(256),;
			ALLTRIM(TOG->Field_Pic),;
			ALLTRIM(TOG->cGetHlpTog)})
	  TOG->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR SUB OBSERVACIONES GENERALES

*>>>>LECTURA DE LAS SUB OBSERVACIONES GENERALES
       SELECT TOG
       TOG->(DBGOTOP())
       FOR i := 1 TO LEN(aLeeGet)

	   @ nNroFil++,01 SAY aLeeGet[i,1]
	   @ nNroFil++,01 GET aLeeGet[i,2] PICT aLeeGet[i,3];
			  WHEN {||HelpRead(aLeeGet[i,4])}
	   READ
       ENDFOR
*>>>>FIN LECTURA DE LAS SUB OBSERVACIONES GENERALES

cPausa()
RETURN NIL