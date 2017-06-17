/* SIMA - CONTROL DE ASISTENCIA

MODULO      : ASISTENCIA
SUBMODULO...: PERSONAL

**************************************************************************
* TITULO..: LECTURA DE LAS NOVEDADES DE ASISTENCIA DEL PERSONAL          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 13/2007 MAR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   NOV 13/2007 MAR

OBJETIVOS:

1- Permite leer las novedades de asistencia del personal.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_102(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales No. 1
       aParam2                              // Parametros Generales No. 2
       aParam3                              // Parametros Generales No. 3 */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>PARAMETROS DE LA FUNCION
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cPatSis := ''                  // Path del sistema
       LOCAL nFilPal := ''                  // Fila Inferior Men£ principal
       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀParametros Generales No.1

       LOCAL nFilInf := ''                  // Fila Inferior del SubMen£
       LOCAL nColInf := ''                  // Columna Inferior del SubMen£
     *ÀParametros Generales No.2

       LOCAL nTipLec := ''                  // Tipo de Lectura
     *ÀParametros Generales No.3
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nNroKey := 0                   // Tecla pulsada
       LOCAL nFilTem := 0                   // Fila Temporal
       LOCAL nColTem := 0                   // Columna Temporal

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos
       LOCAL cTexto  := ''                  // Texto temporal
       LOCAL cCodigo := ''                  // C¢digo de la lectura
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL nHraIni := 0                   // Registro inicial de la Hora
       LOCAL nHraFin := 0                   // Registro Final de la Hora
       LOCAL lIniCla := .F.                 // Hora de clase inicial
       LOCAL lFinCla := .F.                 // Hora de clase final

       LOCAL cCodPnl := ''                  // C¢digo del personal
       LOCAL cNomPnl := ''                  // Nombre del personal
       LOCAL aTiempo := {}                  // Tiempo Transcurrido
       LOCAL lInsReg := .F.                 // .T. Insertar Registro

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTtp := ''               // C¢digo tipo personal
       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE PARAMETROS
       lShared := xParametro(aParam1,aParam2,aParam3,'lShared')
       nModCry := xParametro(aParam1,aParam2,aParam3,'nModCry')
       cNomSis := xParametro(aParam1,aParam2,aParam3,'cNomSis')
       cEmpPal := xParametro(aParam1,aParam2,aParam3,'cEmpPal')
       cNitEmp := xParametro(aParam1,aParam2,aParam3,'cNitEmp')
       cNomEmp := xParametro(aParam1,aParam2,aParam3,'cNomEmp')
       cNomSec := xParametro(aParam1,aParam2,aParam3,'cNomSec')
       cCodEmp := xParametro(aParam1,aParam2,aParam3,'cCodEmp')
       cNomUsr := xParametro(aParam1,aParam2,aParam3,'cNomUsr')
       cAnoUsr := xParametro(aParam1,aParam2,aParam3,'cAnoUsr')
       cPatSis := xParametro(aParam1,aParam2,aParam3,'cPatSis')
       nFilPal := xParametro(aParam1,aParam2,aParam3,'nFilPal')
       cMaeAlu := xParametro(aParam1,aParam2,aParam3,'cMaeAlu')
       cMaeAct := xParametro(aParam1,aParam2,aParam3,'cMaeAct')
       cJorTxt := xParametro(aParam1,aParam2,aParam3,'cJorTxt')
     *ÀParametros Generales No.1

       nFilInf := xParametro(aParam1,aParam2,aParam3,'nFilInf')
       nColInf := xParametro(aParam1,aParam2,aParam3,'nColInf')
     *ÀParametros Generales No.2

       nTipLec := xParametro(aParam1,aParam2,aParam3,'nTipLec')
     *ÀParametros Generales No.3

       cAnoSis := SUBS(cAnoUsr,3,2)
*>>>>FIN INICIALIZACION DE PARAMETROS

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fPerso1,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePnl,'PNL',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FileTpe,'TPE',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FAsiAno+cAnoUsr+ExtFile,'ASA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+fAsiNov,'NOV',NIL,lShared,nModCry})
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
       CASE ASA->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

       CASE ASA->nCodEstAsA == 0
	    cError('DEBE DEFINIR LA POSICION DEL CODIGO DEL ESTUDIANTE')

       CASE ASA->nLenCodAsA == 0
	    cError('DEBE DEFINIR LA LONGITUD DEL CODIGO DEL ESTUDIANTE')

       CASE ASA->nTipPnlAsA == 0
	    cError('DEBE DEFINIR LA POSICION DEL TIPO DE PERSONAL')

       CASE ASA->nLenPnlAsA == 0
	    cError('DEBE DEFINIR LA LONGITUD DEL TIPO DE PERSONAL')

       CASE EMPTY(ASA->cTipEstAsA)
	    cError('NO SE HA DEFINIDO EL CODIGO TIPO DEL ESTUDIANTE')

       CASE EMPTY(ASA->cTipProAsA)
	    cError('NO SE HA DEFINIDO EL CODIGO TIPO DEL PROFESOR')

       CASE PER->(RECCOUNT()) == 0
	    cError('NO SE EXISTEN PERSONAS GRABADAS EN PERSONAL')

       CASE PNL->(RECCOUNT()) == 0
	    cError('NO SE EXISTE PERSONAL GRABADOS')

       CASE TPE->(RECCOUNT()) == 0
	    cError('NO SE EXISTEN TIPOS DE PERSONAL GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DE LA FECHA Y HORA
       IF !lPregunta('HOY ES '+cFecha(DATE())+' Y LA HORA ESTA CORRECTA? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA FECHA Y HORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'DIGITE LOS CODIGOS.',22,'°')

       aTamCol := {20,40}
       aTitulo := {'CODIGO','NOMBRE'}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>LECTURA Y GRABACION DE LOS CODIGOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cCodigo := cLeeCodigo(lShared,cAnoUsr,cMaeAct,cIntUno,;
				  nNroFil,aNroCol[1],nTipLec,oBrowse)
	    IF EMPTY(cCodigo)
	       EXIT
	    ENDIF
**********FIN LECTURA DEL CODIGO

**********ANALISIS DEL CODIGO
	    DO CASE
	    CASE nTipLec == 2  // C¢digo de barras
		    cCodPnl := SUBS(cCodigo,ASA->nCodEstAsA,ASA->nLenCodAsA)
		 cCodigoTtp := SUBS(cCodigo,ASA->nTipPnlAsA,ASA->nLenPnlAsA)
	    ENDCASE
**********FIN ANALISIS DEL CODIGO

**********LOCALIZACION TIPO DE PERSONAL
	    IF !lLocCodigo('cCodigoTpe','TPE',cCodigoTtp)
	       cError(cCodigoTtp,'NO EXISTE EL CODIGO DEL TIPO DE PERSONAL')
	       LOOP
	    ENDIF
**********FIN LOCALIZACION TIPO DE PERSONAL

**********VALIDACION DEL INGRESO
	    IF !TPE->lCtrIngTpe
	       cError('EL CODIGO: '+cCodPnl+' NO ES PERMITIDO')
	       LOOP
	    ENDIF

	    IF cCodigoTtp == ASA->cTipEstAsA
	       cError('PARA LOS ESTUDIANTES',;
		      'NO ESTA PERMITIDO EL CONTROL DE INGRESO')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL INGRESO

**********LOCALIZACION DEL PROFESOR
	    cNomPnl := ''
	    IF cCodigoTtp == ASA->cTipProAsA

	       IF !lLocCodigo('cCodigoPro','PRO',cCodPnl)
		  cError('EL CODIGO '+cCodPnl+' '+;
			 'NO EXISTE EN PROFESORES')
		  LOOP
	       ENDIF
	       cNomPnl := ALLTRIM(PRO->cNombrePro)+' '+;
			  ALLTRIM(PRO->cApelliPro)
	    ENDIF
**********FIN LOCALIZACION DEL PROFESOR

**********LOCALIZACION DEL PERSONAL
	    IF cCodigoTtp # ASA->cTipProAsA

	       SELECT PNL
	       PNL->(DBGOTOP())
	       LOCATE FOR PNL->cCodigoPnl == cCodPnl .AND.;
			  PNL->cTipPerPnl == cCodigoTtp

	       IF .NOT. PNL->(FOUND())
		  cError('EL CODIGO '+cCodPnl+' '+;
			 'NO EXISTE EN PERSONAL')
		  LOOP
	       ENDIF

	       cNomPnl := ALLTRIM(cLocNomPer(PNL->nIdePerPnl,'PNL'))

	    ENDIF
**********FIN LOCALIZACION DEL PERSONAL

**********ANALISIS DE DECISION
	    IF !lPregunta('USTED ES '+cNomPnl+'? Si No')
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********CONSULTA DEL NOMBRE
	    @ nNroFil,aNroCol[1] SAY cCodPnl
	    @ nNroFil,aNroCol[2] SAY cNomPnl
**********CONSULTA DEL NOMBRE

**********LOCALIZACIN DEL INGRESO
	    SELECT NOV
	    NOV->(DBGOTOP())

	    lInsReg := .F.   // Personal Registrado
	    LOCATE FOR NOV->nIdePerNov == PNL->nIdePerPnl .AND.;
		       NOV->dFecIngNov == DATE() .AND.;
		       NOV->dFecOutNov == CTOD('00/00/00')

	    IF .NOT. FOUND()
	       lInsReg := .T.  // Persona no registrada no esta.
	    ENDIF
**********FIN LOCALIZACIN DEL INGRESO

**********GRABACION DEL INGRESO O SALIDA
	    SELECT NOV
	    IF NOV->(lRegLock(lShared,lInsReg))

	       IF lInsReg

		  REPL NOV->nIdeCodNov WITH NOV->(RECNO())

		  REPL NOV->cCodPnlNov WITH cCodPnl
		  REPL NOV->cTipPerNov WITH cCodigoTtp
		  REPL NOV->nIdePerNov WITH PNL->nIdePerPnl
		  REPL NOV->dFecIngNov WITH DATE()
		  REPL NOV->cHorIngNov WITH TIME()

	       ELSE

		  REPL NOV->dFecOutNov WITH DATE()
		  REPL NOV->cHorOutNov WITH TIME()

	       ENDIF

	       REPL NOV->cNomUsrNov WITH 'system'
	       REPL NOV->dFecUsrNov WITH DATE()
	       REPL NOV->cHorUsrNov WITH TIME()

	       NOV->(DBCOMMIT())
	    ENDIF

	    IF lShared
	       NOV->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL INGRESO O SALIDA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'DIGITE LOS CODIGOS.',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodPnl
		 @ nNroFil,aNroCol[2] SAY cNomPnl
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS


       ENDDO
       CloseAll()
       SETKEY(K_F10,NIL)
       SHOWTIME()
       RETURN NIL
*>>>>FIN LECTURA Y GRABACION DE LOS CODIGOS

/*************************************************************************
* TITULO..: LECTURA DE LOS PARAMETROS GENERALES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/2007 MIE A
       Colombia, Bucaramanga        INICIO: 09:30 AM   NOV 14/2007 MIE

OBJETIVOS:

1- Permite leer un parametro de los parametros genereles especificados.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION xParametro(aParam1,aParam2,aParam3,cParams)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1			       // Parametrso Generales No.1
       aParam2			       // Parametrso Generales No.2
       aParam3			       // Parametrso Generales No.3
       cParams			       // Parametro de la funci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       k := 0                         // Contador
       LOCAL aParams := {}                        // Parametrso Generales
       LOCAL xParams := NIL                       // xParametro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PARAMETROS GENERALES
       aParams := {}

       IF !EMPTY(aParam1) .AND. LEN(aParam1) > 0
	  FOR k := 1 TO LEN(aParam1)
	      AADD(aParams,{aParam1[k,1],aParam1[k,2]})
	  ENDFOR
       ENDIF

       IF !EMPTY(aParam2) .AND. LEN(aParam2) > 0
	  FOR k := 1 TO LEN(aParam2)
	      AADD(aParams,{aParam2[k,1],aParam2[k,2]})
	  ENDFOR
       ENDIF

       IF !EMPTY(aParam3) .AND. LEN(aParam3) > 0
	  FOR k := 1 TO LEN(aParam3)
	      AADD(aParams,{aParam3[k,1],aParam3[k,2]})
	  ENDFOR
       ENDIF
*>>>>FIN PARAMETROS GENERALES

*>>>>LECTURA DEL PARAMETRO
       k := ASCAN(aParams,{|aArray|aArray[1] == cParams})
       IF k # 0
	  xParams := aParams[k,2]
       ELSE
	  cError(cParams+' NO SE ENCONTRO')
	  cParams := NIL
       ENDIF
       RETURN xParams
*>>>>FIN LECTURA DEL PARAMETRO

