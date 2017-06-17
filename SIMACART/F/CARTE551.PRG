/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : ACTUALIZAR
SUBMODULO...: ALUMNOS BECADOS        MODULO No. 5

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE505.PRG                                    *
* TITULO DEL PROGRAMA..: GRABACION DE LOS ALUMNOS BECADOS                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 26/94 MAR A
						       JUL 26/94 MAR
REQUERIMIENTOS:

1- Ejucutar la funci¢n de acuerdo a su sintaxis

OBJETIVOS:

1- Permite Grabar los alumnos Becados

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_551(aParam1,aParam2,aParam3)

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
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL nBecIniTcl := 0                // Mes inicial de Beca
       LOCAL nBecFinTcl := 0                // Mes final de Beca
       LOCAL nPorBecTcl := 0                // Porcentaje de la Beca
       LOCAL nVlrBecTcl := 0                // Valor de la Beca
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
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DETALLES DE LAS '+;
				 ' LOS ALUMNOS BECADOS',22,'°')
       aTamCol := {06,06,02,30,04,04,06,10}
       aTitulo := {'CODIGO','CURSO ','No','NOMBRE',;
		   'INI','FIN','PORCE%','VALOR'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS BECADOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO EL ARCHIVO CLIENTES EN '+cPatSis)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
		 CloseDbf('CLI',FileCli,nModCry)
		 CloseAll(aUseDbf)
		 RETURN NIL
	    ENDCASE
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LECTURA DE LA BECA ACTUAL
	    IF lLocCodCli(cCodigoTes,.F.)
	       nBecIniTcl := CLI->nBecIniCli
	       nBecFinTcl := CLI->nBecFinCli
	       nPorBecTcl := CLI->nPorBecCli
	       nVlrBecTcl := CLI->nVlrBecCli
	    ELSE
	       cError('EL CODIGO: '+cCodigoTes+' NO EXISTE EL ARCHIVO DE '+;
		      'CLIENTES DEL GRUPO: '+&cNalias->cCodigoGru)
	       LOOP
	    ENDIF
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY STR(CLI->(RECNO()),2)
	    @ nNroFil,aNroCol[4] SAY cNombreTes
**********FIN LECTURA DEL DESCUENTO ACTUAL

**********LECTURA DEL DESCUENTOS
	    DO WHILE .T.
	       @ nNroFil,aNroCol[5] GET nBecIniTcl PICT '99';
			       VALID lnValMes(ROW(),COL()-2,@nBecIniTcl)

	       @ nNroFil,aNroCol[6] GET nBecFinTcl PICT '99';
			       VALID lnValMes(ROW(),COL()-2,@nBecFinTcl)

	       @ nNroFil,aNroCol[7] GET nPorBecTcl PICT '999';
				    VALID nPorBecTcl <= 100

	       @ nNroFil,aNroCol[8] GET nVlrBecTcl PICT '9999999'
	       READ
	       IF !EMPTY(nPorBecTcl) .AND. !EMPTY(nVlrBecTcl)
		  cError('DEBE INGRESAR EL VALOR O '+;
			 'EL INTERES DE LA BECA. NO AMBOS')
		  LOOP
	       ENDIF
	       EXIT
	    ENDDO
**********FIN LECTURA DEL DESCUENTOS

**********VALIDACION DEL REGISTRO
	    lHayErr := .T.
	    DO CASE
	    CASE nBecIniTcl == 0 .AND. nBecFinTcl == 0 .AND. nPorbecTcl == 0
		 lHayErr := .F.

	    CASE (EMPTY(nBecIniTcl)  .OR. EMPTY(nBecFinTcl)) .OR.;
		 (EMPTY(nPorBecTcl) .AND. EMPTY(nVlrBecTcl))
		 cError('DATOS INCOMPLETOS PARA LA BECA')

	    CASE nBecFinTcl < nBecIniTcl
		 cError('EL MES INICIAL NO PUEDE SER MAYOR AL MES FINAL')

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE

	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       RESTSCREEN(nNroFil,0,nNroFil,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA GRABAR? Si No')
	       CloseDbf('CLI',FileCli,nModCry)
	       RESTSCREEN(nNroFil,0,nNroFil,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********GRABACION DEL MES Y VALOR DEL DESCUENTO
	    SELECT CLI
	    IF CLI->(lRegLock(lShared,.F.))
	       REPL CLI->nBecIniCli WITH nBecIniTcl
	       REPL CLI->nBecFinCli WITH nBecFinTcl
	       REPL CLI->nPorBecCli WITH nPorBecTcl
	       REPL CLI->nVlrBecCli WITH nVlrBecTcl
	       CLI->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA LA BECA PARA EL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL MES Y VALOR DEL DESCUENTO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		  nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DETALLES '+;
				    'DE LAS LOS ALUMNOS BECADOS',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 SET COLOR TO
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY STR(CLI->(RECNO()),2)
		 @ nNroFil,aNroCol[4] SAY cNombreTes
		 SET COLOR TO I
		 @ nNroFil,aNroCol[5] SAY nBecIniTcl PICT '99'
		 @ nNroFil,aNroCol[6] SAY nBecFinTcl PICT '99'
		 @ nNroFil,aNroCol[7] SAY nPorbecTcl PICT '999'
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS