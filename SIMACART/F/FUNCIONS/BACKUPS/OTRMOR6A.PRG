/*************************************************************************
* TITULO ..: BLOQUEAR MOROSOS                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2010 MIE A
       Colombia, Bucaramanga        INICIO: 05:15 PM   ABR 20/2010 MIE

OBJETIVOS:

1- Crea un archivo ASCII con los c¢digos de los estudiantes a Bloquear

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrMor06A(aParam1,aParam2,aParam3,;
		   oBrowse,lPazSav,cMesIni,;
		   lMorAct,dFecDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       lPazSav                              // Paz y Salvo
       cMesIni                              // Mes Inical del pago
       lMorAct                              // .T. Moroso Actual
       dFecDia                              // Fecha del Proceso Diario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL aFecHoy := {}                  // Fecha de Proceso
       LOCAL cFecHoy := ''                  // Fecha del Proceso

       LOCAL lGrabar := .T.                 // Grabar el Archivo ASCII
       LOCAL nNroArc := 0                   // N£mero del Archivo
       LOCAL cRegTxt := ''                  // Texto del registro
       LOCAL nByeWri := 0                   // Bytes Escritos

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAA->nDiaMorCaA == 0
	    cError('NO SE HA DEFINIDO EN NUMERO DE DIAS DE MORA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS


*>>>>ANALISIS DE DECISION
       cError('A '+STR(CAA->nDiaMorCaA,3)+' DIAS','BLOQUEAR MAYORES')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>VALIDACION DE LA CREACION DEL ARCHIVO
       aFecHoy := aFecha(DATE())
       cFecHoy := cMes(VAL(aFecHoy[1]),3)+aFecHoy[2]
     *ÀMMDD

       FileTem := PathDoc+'\NOP'+cFecHoy+'.txt'
       lGrabar := .T.
       IF File(FileTem)
	  lGrabar := .F.
	  cError('EL ARCHIVO:'+FileTem+' YA ESTA CREADO')
	  IF lPregunta('DESEA VOLVER A GRABARLO? Si No')
	     lGrabar := .T.
	  ENDIF
       ENDIF
       IF .NOT. lGrabar
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA CREACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       nNroArc := FCREATE(FileTem,0)
       IF nNroArc == -1
	  cError('NO SE PUEDE CREAR EL ARCHIVO '+FileTem)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>RECORRIDO DEL ARCHIVO
       DO WHILE .NOT. MOR->(EOF())


**********ANALISIS DE DECISION
	    IF MOR->nDiaMorMor <= CAA->nDiaMorCaA
	       MOR->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********GRABACION DEL REGISTRO
	    cRegTxt := MOR->cCodigoEst+CHR(13)+CHR(10)
	    nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
	    IF nByeWri # LEN(cRegTxt)
		cError('GRABACION DE LA CABECERA')
		EXIT
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  MOR->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO DEL ARCHIVO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nNroArc) .AND. lFHayErr(FileTem)
	  cError('ERROR CERRANDO EL ARCHIVO '+FileTem)
       ENDIF
       MOR->(DBGOTOP())
       cError('SE CREO EL ARCHIVO:'+FileTem)
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS


