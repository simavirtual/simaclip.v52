/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : IMPRESIONES
SUBMODULO...: LISTAS GENERALES       MODULO No. 404

**************************************************************************
* TITULO..: LISTAS DE USO GENERAL. CARTA                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/95 MAR A
       Bucaramanga, Colombia        INICIO: 10:45 PM   FEB 28/95 MAR


OBJETIVOS:

1- Permite imprimir las listas generales de clase tama¤o carta

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_405(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nOpcion := 0                   // N£mero de la Opci¢n

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL cIntCaf := ''                  // Path Integraci¢n del restaurante
       LOCAL cIntRut := ''                  // Path Integraci¢n del rutas
       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>PATH DE INTEGRACION
       cIntCaf := ALLTRIM(CAA->cIntCafCaA)
       IF !EMPTY(cIntCaf)
	  cIntCaf := ALLTRIM(CAA->cIntCafCaA)+'\simacont'
       ENDIF

       cIntRut := ALLTRIM(CAA->cIntRutCaA)
       IF !EMPTY(cIntRut)
	  cIntRut := ALLTRIM(CAA->cIntRutCaA)+'\simacont'
       ENDIF
       CloseAll()
*>>>>FIN PATH DE INTEGRACION

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       IF !EMPTY(cIntCaf)
	  AADD(aUseDbf,{.T.,cIntCaf+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    FileAlu+cMaeAct+cAnoSis+ExtFile,'CAF',;
			    cIntCaf+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})
       ENDIF

       IF !EMPTY(cIntRut)
	  AADD(aUseDbf,{.T.,cIntRut+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    FileAlu+cMaeAct+cAnoSis+ExtFile,'RUT',;
			    cIntRut+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})
       ENDIF
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)

	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn = 'carta'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TIPO DE INFORME
       nOpcion := nLeeOpcion('TIPO DE INFORME: '+;
			     '1<INDEPENDIENTE> 2<INTEGRADO>>?',2,'0')
*>>>>FIN TIPO DE INFORME

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    DO CASE
	    CASE nOpcion == 1
		 ListasCarta(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct,lAnoAct)
		*Lista de Clase Independiente

*	         ListaDane(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct,lAnoAct)
*	         Anuario(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct,lAnoAct)

	    CASE nOpcion == 2
		 ListaInteg(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct,lAnoAct)
		*Lista de Clase Integrada
	    ENDCASE
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************


/*************************************************************************
* TITULO DEL PROGRAMA..: INFORME DE PAGOS EFECTUADOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/95 MAR A
       Bucaramanga, Colombia        INICIO: 10:50 PM   FEB 28/95 MAR

OBJETIVOS:

1- Imprime la lista general de clientes

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ListasCarta(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       lAnoAct                              // .T. A¤o Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aNroCol := {}                  // Columnas para el informe
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nNumero := 1                   // Contador de alumnos
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL cTotPag := 0                   // Total p ginas a imprimir
       LOCAL lPagina := .T.                 // .T. Cambio de p gina

       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL cObsCaf := ''                  // Observaci¢n Restaurantes
       LOCAL cObsRut := ''                  // Observaci¢n Rutas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL cConcepTpa := ''               // Conceptos pagados
       LOCAL cEstadoTpa := ''               // Estado del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))
*       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'LISTAS DE USO GENERAL',;
			    'A¥O: '+cAnoUsr,;
			    'GRUPO: '+cConverNiv(SUBS(GRU->cCodigoGru,1,2))+;
						 SUBS(GRU->cCodigoGru,3,2)+;
			    ' JORNADA: '+cJorTxt,;
			    nNroPag++,;
			    cTotPagina(CLI->(RECCOUNT())))
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {02,06,50,06,06,06,06,06,06,06,06,06,06}
		 aTitulo := {'No',;
			     'CODIGO',;
			     'APELLIDOS Y NOMBRES ',;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06)}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
*		 @ PROW(),00 SAY CONDEN_ON+DRAFT_ON+PICA
		 SendCodes(PCL({'DraftOn','Pica','CondenOn'}))
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
*		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		 SendCodes(PCL({'NegraOf','DobGolOf'}))
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    IF &cNalias->lRetiroEst .AND. lHayAlu
	       cNombreTes := 'RETIRADO '+SUBS(cNombreTes,1,26)
	    ENDIF
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {STR(CLI->(RECNO()),2),;
			CLI->cCodigoEst,;
			cNombreTes,;
			IF(CLI->lRetGruCli,'OTRO',SPACE(06)),;
			IF(CLI->lRetGruCli,'GRUPO',SPACE(06)),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06)}

	    SendCodes(PCL('SubryOn'))
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
	    SendCodes(PCL('SubryOf'))
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SELECT CLI
	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,n17Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: INFORME DE PAGOS EFECTUADOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 27/2012 VIE A
       Bucaramanga, Colombia        INICIO: 01:15 PM   JUL 27/2012 VIE

OBJETIVOS:

1- Imprime la lista de clase integrada con los servicios de Cafeteria,
   restaurante.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ListaInteg(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aNroCol := {}                  // Columnas para el informe
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nNumero := 1                   // Contador de alumnos
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL cTotPag := 0                   // Total p ginas a imprimir
       LOCAL lPagina := .T.                 // .T. Cambio de p gina

       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrInt := 0                   // Valor de los intereses

       LOCAL cObsCaf := ''                  // Observaci¢n de Restaurante
       LOCAL cObsRut := ''                  // Observaci¢n de Transporte

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL cConcepTpa := ''               // Conceptos pagados
       LOCAL cEstadoTpa := ''               // Estado del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
*       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
       SendCodes(PCL('Reset'))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'LISTAS DE USO GENERAL INTEGRADA',;
			    'A¥O: '+cAnoUsr,;
			    'GRUPO: '+cConverNiv(SUBS(GRU->cCodigoGru,1,2))+;
						 SUBS(GRU->cCodigoGru,3,2)+;
			    ' JORNADA: '+cJorTxt,;
			    nNroPag++,;
			    cTotPagina(CLI->(RECCOUNT())))
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {02,06,50,06,06,06,06,06,06,06,06,06,06}
		 aTitulo := {'No',;
			     'CODIGO',;
			     'APELLIDOS Y NOMBRES ',;
			     'RESTA ',;
			     'TRANS ',;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06)}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
*		 @ PROW(),00 SAY CONDEN_ON+DRAFT_ON+PICA
		 SendCodes(PCL({'DraftOn','Pica','CondenOn'}))
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
*		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		 SendCodes(PCL({'NegraOf','DobGolOf'}))
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    IF &cNalias->lRetiroEst .AND. lHayAlu
	       cNombreTes := 'RETIRADO '+SUBS(cNombreTes,1,26)
	    ENDIF
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********ESTUDIANTE EN RESTAURANTE
	    cObsCaf := ''
	    IF lHayAlu
	       IF CAF->(DBSEEK(CLI->cCodigoEst))
		  IF CAF->lRetiroEst
		     cObsCaf := 'RETI'
		  ELSE
		     cObsCaf := ALLTRIM(CAF->cConcepEst)
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ESTUDIANTE EN RESTAURANTE

**********ESTUDIANTE EN TRANSPORTE
	    cObsRut := ''
	    IF lHayAlu
	       IF RUT->(DBSEEK(CLI->cCodigoEst))
		  IF RUT->lRetiroEst
		     cObsRut := 'RETI'
		  ELSE
		     cObsRut := ALLTRIM(RUT->cConcepEst)
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ESTUDIANTE EN TRANSPORTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {STR(CLI->(RECNO()),2),;
			CLI->cCodigoEst,;
			cNombreTes,;
			IF(CLI->lRetGruCli,'OTRO',cObsCaf),;
			IF(CLI->lRetGruCli,'GRUPO',cObsRut),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06),;
			SPACE(06)}

	    SendCodes(PCL('SubryOn'))
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
	    SendCodes(PCL('SubryOf'))
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SELECT CLI
	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
      SendCodes(PCL('SubryOf'))
       DerechosPrn(cNomSis,cNomEmp,n17Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO DEL PROGRAMA..: INFORME DE PAGOS EFECTUADOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/95 MAR A
       Bucaramanga, Colombia        INICIO: 10:50 PM   FEB 28/95 MAR

OBJETIVOS:

1- Imprime la lista general de clientes

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Anuario(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       lAnoAct                              // .T. A¤o Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aNroCol := {}                  // Columnas para el informe
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nNumero := 1                   // Contador de alumnos
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL cTotPag := 0                   // Total p ginas a imprimir
       LOCAL lPagina := .T.                 // .T. Cambio de p gina

       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrInt := 0                   // Valor de los intereses

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL cConcepTpa := ''               // Conceptos pagados
       LOCAL cEstadoTpa := ''               // Estado del pago
*>>>>FIN DECLARACION DE VARIABLES
SET DEVICE TO PRINT
*>>>>ACTIVACION DE LA IMPRESORA
/*
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*/
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    IF &cNalias->lRetiroEst .AND. lHayAlu
	       cNombreTes := 'RETIRADO '+SUBS(cNombreTes,1,26)
	    ENDIF
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    @ PROW()+1,00 SAY 'ALUMNO: '+cNombreTes
	    @ PROW()+1,00 SAY 'CODIGO: '+CLI->cCodigoEst+SPACE(02)+;
			      'GRUPO: '+&cNalias->cCodigoGru+SPACE(02)+' '+;
			      'NRO LISTA: '+STR(CLI->(RECNO()),2)
	    @ PROW()+1,00 SAY ''
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

	  SELECT CLI
	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,n17Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

FUNCTION ListaDane(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       lAnoAct                              // .T. A¤o Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aNroCol := {}                  // Columnas para el informe
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nNumero := 1                   // Contador de alumnos
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL cTotPag := 0                   // Total p ginas a imprimir
       LOCAL lPagina := .T.                 // .T. Cambio de p gina

       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrInt := 0                   // Valor de los intereses

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL cConcepTpa := ''               // Conceptos pagados
       LOCAL cEstadoTpa := ''               // Estado del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,'INFORMACION PARA EL DANE',;
			    'DIRECTORIO DE ESTUDIANTES',;
			    'A¥O: '+cAnoUsr,;
			    'GRUPO: '+cConverNiv(SUBS(GRU->cCodigoGru,1,2))+;
						 SUBS(GRU->cCodigoGru,3,2)+;
			    ' JORNADA: '+cJorTxt,;
			    nNroPag++,;
			    cTotPagina(CLI->(RECCOUNT())))
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {06,26,26,40,40,10,06,10}
		 aTitulo := {'CODIGO',;
			     'APELLIDOS',;
			     'NOMBRES ',;
			     'DOCUMENTO',;
			     'DIRECCION',;
			     'TELEFONO',;
			     'GRADO',;
			     'FEC NAC'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n17Stan
		 @ PROW(),00 SAY CONDEN_ON+DRAFT_ON+PICA
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    IF &cNalias->lRetiroEst .AND. lHayAlu
	       cNombreTes := 'RETIRADO '+SUBS(cNombreTes,1,26)
	    ENDIF
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aNroCol := {06,26,26,40,40,10,06,10}
	    aTitulo := {CLI->cCodigoEst,;
			&cNalias->cApelliEst,;
			&cNalias->cNombreEst,;
			&cNalias->cDocNitEst+' DE '+&cNalias->cLugNitEst,;
			&cNalias->cDireccEst,;
			&cNalias->cTelefnEst,;
			&cNalias->cCodigoGru,;
			cFecha(&cNalias->dFecNacEst)}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    @ PROW()+1,00 SAY cTxtPrn
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SELECT CLI
	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,n17Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS