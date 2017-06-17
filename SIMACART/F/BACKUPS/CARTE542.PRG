/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : DESCUENTOS/RECARGOS
SUBMODULO...: ACTIVAR GENERALES      MODULO No. 542

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI102.PRG                                    *
* TITULO DEL PROGRAMA..: ACTIVAR GENERALES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 19/98 JUE A
       Bucaramanga, Colombia        INICIO: 07:35 PM   FEB 19/98 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite activar los estudiantes para aplicarles descuentos o recargos
   generales para un mes especifico.

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_542(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lGrabar := .F.                 // .T. Grabar el pago

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
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

*>>>>CAPTURA DEL MES A PAGAR
       SAVE SCREEN
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi¢n',.T.)
       RESTORE SCREEN
       IF nMesIniTpa == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct)

	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LOS ESTUDIANTES
       nNroFil := nMarco(nFilPal,'ESTUDIANTES HABILITADOS PARA '+;
			'DESCUENTOS GENERALES EN '+cMes(nMesIniTpa,10))
       nNroCol := 1
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO ARCHIVO')
	       CloseDbf('CLI',FileCli,nModCry)
	       SELECT GRU
	       SKIP
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LOS RECIBOS DE PAGO DEL GRUPO
	    SELECT CLI
	    GO nNroIni
	    DO WHILE .NOT. CLI->(EOF())

*--------------ANALISIS PARA LA SALIDA DEL MODULO
		 SELECT CLI
		 IF nNroFin <> 0
		    IF CLI->(RECNO()) > nNroFin
		       SET DEVICE TO SCREEN
		       CloseDbf('CLI',FileCli,nModCry)
		       CloseAll()
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA DEL MODULO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF !lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias,.F.)

		    SET DEVICE TO SCREEN
		    cError('EL CODIGO:' +CLI->cCodigoEst+' NO EXISTE '+;
			   'EN CLIENTES DEL GRUPO '+GRU->cCodigoGru)
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP

		 ENDIF

		 cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			       RTRIM(&cNalias->cNombreEst)
		 cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF &cNalias->lRetiroEst
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------VERIFICACION DEL GRUPO
		 IF &cNalias->cCodigoGru # GRU->cCodigoGru .AND.;
		    !(CLI->lRetGruCli)

		    SET DEVICE TO SCREEN
		    cError('CLIENTE DEL GRUPO: '+GRU->cCodigoGru+;
			   ' PERTENECE AL GRUPO: '+&cNalias->cCodigoGru,;
			    cNombreTes+' CODIGO: '+&cNalias->cCodigoEst,;
			   'POR FAVOR EJECUTE LA OPCION DE ACTUALIZAR')
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VERIFICACION DEL GRUPO

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('DE '+cMes(nMesIniTpa,3)+;
			     ' A '+cMes(nMesIniTpa,3)+;
			     'ºGRUPO: '+GRU->cCodigoGru+;
			     'ºESTUDIANTE: '+cNombreTes+;
			     'ºNo. '+STR(CLI->(RECCOUNT()),2)+'/'+;
				     STR(CLI->(RECNO()),2),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------GRABACION DE LA ACTIVACION DEL DESCUENTO GENERAL
		 IF CLI->(lRegLock(lShared,.F.))
		    REPL CLI->cHayNovCli WITH STUFF(CLI->cHayNovCli,;
					      nMesIniTpa,1,'1')
		    CLI->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABAN EL REGISTRO')
		 ENDIF
		 IF lShared
		    CLI->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DE LA ACTIVACION DEL DESCUENTO GENERAL

*--------------VISUALIZACION DEL CLIENTE GRABADO
		 nNroFil++
		 @ nNroFil,01 SAY cNombreTes+' ... DE '+GRU->cCodigoGru+;
				  ' MESES ACTIVADOS: '+CLI->cHayNovCli

		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal,'ESTUDIANTES HABILITADOS PARA '+;
			       'APLICARLES DESCUENTOS EN'+cMes(nMesIniTpa,10))
		 ENDIF
*--------------FIN VISUALIZACION DEL CLIENTE GRABADO

	       SELECT CLI
	       SKIP

	    ENDDO
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN IMPRESION DE LOS RECIBOS DE PAGO DEL GRUPO

**********INCREMENTO DEL SIGUIENTE GRUPO
	    nNroIni := 1

	    SELECT GRU
	    SKIP

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS RECIBOS DE PAGO