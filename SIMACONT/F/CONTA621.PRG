/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : CERTIFICADOS
SUBMODULO...: PAZ Y SALVOS. GRABACION

**************************************************************************
* TITULO..: GRABACION DE PAZ Y SALVOS                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 17/2002 DOM A
       Colombia, Bucaramanga        INICIO: 04:20 PM   NOV 17/2002 DOM

OBJETIVOS:

1- Permite Grabar los paz y Salvos.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_621(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL cPatTem := ''                  // Path Temporal

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL lAgrega := .T.                 // .T. Agregar Registro

       LOCAL nHayPaz := ''                  // 1=>SI Paz y Salvo 2=>NO Paz y Salvo
       LOCAL cCampos := ''                  // Nombre de Campo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL cNombreTes := ''               // Nombre del estudiante

       LOCAL nCodigoTpa := 0                // C¢digo del Paz y Salvo
       LOCAL cDescriTdp := ''               // Descripci¢n del Paz y Salvo
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
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared) .OR.;
	  !lUseXYZ(lShared,cPatSis,cMaeAlu,cAnoSis)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PAZ->(RECCOUNT()) == 0
	    cError('NO EXISTEN ITEMS DE PAZ Y SALVOS CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL NUMERO DEL ITEM DEL PAZ Y SALVO
       @ nFilInf+1,nColInf SAY 'NUMERO ITEM:';
			   GET nCodigoTpa PICT '99'
       READ
       IF EMPTY(nCodigoTpa)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DEL ITEM DEL PAZ Y SALVO

*>>>>LOCALIZACION DEL NUMERO DEL ITEM DEL PAZ Y SALVO
       IF !lLocCodigo('nCodigoPaz','PAZ',nCodigoTpa)
	  cError('EL ITEM No. '+STR(nCodigoTpa,2)+' DE PAZ Y SALVO NO EXISTE')
	  CloseAll()
	  RETURN NIL
       ENDIF

       IF PAZ->nNroTipPaz == 1
	  cError('ESTE ITEM LO PROCESA LA CARTERA SI ESTA CONFIGURADO')
	  CloseAll()
	  RETURN NIL
       ENDIF

       IF !lPregunta('ESCOGIO EL ITEM '+ALLTRIM(PAZ->cNombrePaz)+;
		     '.DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL NUMERO DEL ITEM DEL PAZ Y SALVO

*>>>>LECTURA DEL TIPO DE PAZ Y SALVO
       nHayPaz := nLeeOpcion('TIPO DE GRABACION: '+;
		 '1<NO Paz y Salvo> 2<SI Paz y Salvo> 3<ABANDONAR>?',3,'1')

       IF nHayPaz == 3
	  CloseAll()
	  RETURN NIL
       ENDIF
       IF !lPregunta('Escogio '+IF(nHayPaz==1,'NO','SI')+' Paz y Salvos'+;
		     '.DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE PAZ Y SALVO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'Digite los c¢digos que '+;
				   IF(nHayPaz==1,'NO','SI')+' '+;
				   'estan a Paz y Salvo por '+;
				    ALLTRIM(PAZ->cNombrePaz),22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','DESCRIPCION DE LA DEUDA'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION POR CODIGO
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAct,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DE LA LINEA ESTADO
	    LineaEstado('GRUPO: '+&cNalias->cCodigoGru+;
			'º'+cNombreTes,cNomSis)
**********FIN IMPRESION DE LA LINEA ESTADO

**********LOCALIZACION DESCRIPCION DEUDA
	    lAgrega := .T.
	    cDescriTdp := SPACE(70)
	    SELECT DPZ
	    LOCATE FOR DPZ->cCodigoEst == cCodigoTes .AND.;
		       DPZ->nCodigoPaz == nCodigoTpa
	    IF FOUND()
	       lAgrega := .F.
	       cDescriTdp := DPZ->cDescriDpz
	    ENDIF
**********FIN LOCALIZACION DESCRIPCION DEUDA

**********LECTURA DE LA DESCRIPCION DE LA DEUDA
	    IF nHayPaz == 1
	       DO WHILE .T.
		  @ nNroFil,aNroCol[3] GET cDescriTdp PICT "@s64X"
		  READ
		  IF nHayPaz == 1 .AND. lAgrega .AND.;
		     EMPTY(cDescriTdp)
		     cError('DEBE ESCRIBIR QUE DEBE EL ESTUDIANTE')
		     LOOP
		  ENDIF
		  EXIT
	       ENDDO
	    ENDIF
**********FIN LECTURA DE LA DESCRIPCION DE LA DEUDA

**********ANALISIS DE DECISION
	    IF !lPregunta('DESEA GRABAR? Si No')
	       LOOP
	    ENDIF
	    RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
**********FIN ANALISIS DE DECISION

**********GRABACION DEL PAZ Y SALVO
	    SELECT &cNalias
	    IF lRegLock(lShared,.F.)
	       cCampos := cNalias+'->cPazSdoEst'
	       IF nHayPaz==1
		  REPL &cCampos WITH STUFF(&cCampos,nCodigoTpa,1,'N')
	       ELSE
		  REPL &cCampos WITH STUFF(&cCampos,nCodigoTpa,1,SPACE(01))
	       ENDIF
	       DBCOMMIT()
	    ELSE
	       cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	    ENDIF
	    IF lShared
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DEL PAZ Y SALVO

**********GRABACION DE LA DESCRIPCION DEL PAZ Y SALVO
	    IF DPZ->(lRegLock(lShared,lAgrega))

	       IF lAgrega
		  REPL DPZ->cCodigoEst WITH cCodigoTes
		  REPL DPZ->nCodigoPaz WITH nCodigoTpa
	       ENDIF
	       IF nHayPaz == 1
		  REPL DPZ->cDescriDpz WITH cDescriTdp
	       ENDIF
	       REPL DPZ->lPazSdoDpz WITH IF(nHayPaz==1,.F.,.T.)
	       DPZ->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	    ENDIF
	    IF lShared
	       DPZ->(DBUNLOCK())
	    ENDIF
	    @ nNroFil,aNroCol[1] SAY cCodigoTes
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes+'...'+;
				     IF(nHayPaz==1,'NO Paz y Salvo',;
						   'SI Paz y Salvo')
**********FIN GRABACION DE LA DESCRIPCION DEL PAZ Y SALVO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'Digite los c¢digos que '+;
					     IF(nHayPaz==1,'NO','SI')+' '+;
					     'estan a Paz y Salvo por '+;
					      ALLTRIM(PAZ->cNombrePaz),22,'°')

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

       CloseAll()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION POR CODIGO

