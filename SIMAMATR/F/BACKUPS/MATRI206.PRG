/* SIMA - MATRICULA ACADEMICA

MODULO      : EVALUACION
SUBMODULO...: OBSERVACIONES

**************************************************************************
* TITULO..: GRABACION DE LAS OBSERVACIONES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 08/2006 MAR A
       Colombia, Bucaramanga        INICIO: 04:45 PM   AGO 08/2006 MAR

OBJETIVOS:

1- Permite grabar, consultar e imprimir las observaciones del proceso
   de admisi¢n del aspirante

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_206(aParam1,aParam2,aParam3)

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
       LOCAL cSavLin := ''                  // Salvar linea

       LOCAL lNewReg := .F.                 // .T. Crear el registro
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       MEMVA xClrSys			    // Color del Sistema

       LOCAL cTexto  := ''                  // Contenido del texto
       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda
       LOCAL lSiorNo := ''                  // Variable l¢gica

       LOCAL     i,j := 0                   // Contadores

       LOCAL aTitulo[12]                    // Titulos de las Columnas
       LOCAL aTamCol[12]                    // Tama¤o de las Columnas
       LOCAL aNroCol[12]                    // N£meros de Columnas
       LOCAL cNumeroTad := ''               // N£mero de Inscripci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante


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
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTob,'TOB',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileObs,'OBS',NIL,lShared,nModCry})
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
       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       CASE TOB->(RECCOUNT()) == 0
	    cError('No existen los Tipos de Observaciones')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DEL TIPO DE OBSERVACION
       IF EMPTY(nUsrSelTob(nFilInf+1,nColInf,cNomUsr))
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DEL TIPO DE OBSERVACION

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,ALLTRIM(TOB->cNombreTob),22,'°')

       nNroCol := 1
       aTamCol := {06,12,30}
       aTitulo := {'CODIGO','GRADO','NOMBRE'}

       AADD(aTitulo,'APROBO')
       AADD(aTamCol,06)

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LAS NOTAS
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
				     ' '+ADM->cApelliEst,1,30))

	    @ nNroFil,aNroCol[2] SAY cNomNiv(SUBS(ADM->cCodigoGru,1,2))
	    @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN LECTURA DEL CODIGO

**********ANALISIS SI EL CANDIDATO ESTA RETIRADO
	    IF ADM->lRetiroAdm
	       cError(cNombreTes+ ' ESTA RETIRADO')
	       LOOP
	    ENDIF

	    lNewReg := !lLocCodObs(TOB->cCodigoTob,ADM->cCodigoEst)
	   *Localizaci¢n de la observacion
**********FIN ANALISIS SI EL CANDIDATO ESTA RETIRADO

*********PREGUNTA DE DECISION
	    cSavLin := SAVESCREEN(nNroFil,aNroCol[4],nNroFil,79)
	    lSiorNo := IF('SI' $ ALLTRIM(OBS->cNotaObs),.T.,.F.)
	    @ nNroFil,aNroCol[4]+6 SAY IF(lSiorNo,'SI','NO')

	    lSiorNo := .F.
	    IF lPregunta('Si No',nNroFil,aNroCol[4])
	       lSiorNo := .T.
	    ENDIF
	    RESTSCREEN(nNroFil,aNroCol[4],nNroFil,79,cSavLin)
	    @ nNroFil,aNroCol[4] SAY IF(lSiorNo,'SI','NO')
*********FIN PREGUNTA DE DECISION

**********EDICION DEL CAMPO MEMO
	    cTexto := OBS->mObservObs

	    EditarMemo(cNomSis,@cTexto,;
		       cNombreTes+':'+ALLTRIM(TOB->cNombreTob),;
		       cTxtHlp,cTitHlp)
**********FIN EDICION DEL CAMPO MEMO

**********GRABACION DE LA OBSERVACION
	    IF OBS->(lRegLock(lShared,lNewReg))

	       REPL OBS->nIdeCodObs WITH OBS->(RECNO())

	       REPL OBS->cCodigoTob WITH TOB->cCodigoTob
	       REPL OBS->cCodEstObs WITH ADM->cCodigoEst
	       REPL OBS->cNotaObs   WITH IF(lSiorNo,'SI','NO')
	       REPL OBS->mObservObs WITH cTexto

	       REPL OBS->cNomUsrObs WITH cNomUsr
	       REPL OBS->dFecUsrObs WITH DATE()
	       REPL OBS->cHorUsrObs WITH TIME()

	    ELSE
		cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    OBS->(DBCOMMIT())
	    IF lShared
	       OBS->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA OBSERVACION

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE
		 nNroFil := nMarco(nFilPal+1,ALLTRIM(TOB->cNombreTob),22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,01 SAY cNumeroTad
		 SET COLOR TO

		 @ nNroFil,aNroCol[2] SAY cNomNiv(SUBS(ADM->cCodigoGru,1,2))
		 @ nNroFil,aNroCol[3] SAY cNombreTes
*--------------FIN IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LAS NOTAS DE LOS ESTUDIANTES


/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DEL MES DE ACUERDO A UN ARREGLO      *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 11/94 LUN A
						       JUL 11/94 LUN
1- Permite escoger un mes de acuerdo a un Browse de un arreglo con los
   meses del a¤o.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el n£mero del mes escogido en tipo caracter

SINTAXIS:

  cNroMes := ''
  lSelMes(nFilInf,nColInf,@cNroMes)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSelMes(nNroFil,nNroCol,cNroMes)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de Impresi¢n
       nNroCol                              // Columna de Impresi¢n
       cNroMes                              // @N£mero del Mes */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oBrwArr := NIL                 // Browse de Arreglos
       LOCAL oColumn := NIL                 // Columna del Objetos
       LOCAL aVector := NIL                 // Arreglo para el Browse
       LOCAL nIndice := 1                   // N£mero del indice
       LOCAL nLenEle := 0                   // Elementos del Arreglo

       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DEL VECTOR
       aVector := {'ENE','FEB','MAR','ABR','MAY','JUN',;
			 'JUL','AGO','SEP','OCT','NOV','DIC'}
       nLenEle := LEN(aVector)
*>>>>FIN INICIALIZACION DEL VECTOR

*>>>>INICIALIZACION DE LAS COORDENADAS
       nFilSup := nNroFil
       nColSup := nNroCol
       nFilInf := nFilSup+nLenEle+2
       IF nFilInf > 22
	  nFilInf := 22
       ENDIF
       nColInf := nFilSup+6
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>DEFINICION DEL OBJETO BROWSE
       @ nFilSup,nColSup TO nFilInf,nColInf DOUBLE
       oBrwArr := TBrowseNew(nFilSup,nColSup,nFilInf,nColInf)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwArr:skipBlock     := {|n|nSkipArray(n,@nIndice,nLenEle,oBrwArr)}
       oBrwArr:GoTopBlock    := {||nIndice:= 1}
       oBrwArr:GoBottomBlock := {||nIndice:= nLenEle}
     *ÀEspecificaciones del Objeto

       oColumn         := TBColumnNew()
       oColumn:Heading := 'MES'
       oColumn:Block   := {||aVector[nIndice]}
       oBrwArr:addColumn(oColumn)
     *ÀDefinici¢n Columna No. 1
*>>>>FIN DEFINICION DEL OBJETO BROWSE

*>>>>BROWSE DEL ARREGLO
      BrwArray(oBrwArr, aVector, @nIndice)
      cNroMes := STR(nIndice,2)
      RETURN .T.
*>>>>FIN BROWSE DEL ARREGLO