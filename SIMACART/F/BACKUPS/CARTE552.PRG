/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : ALUMNOS BECADOS
SUBMODULO...: ELIMINAR BECAS

**************************************************************************
* TITULO..: ELIMINAR LAS BECAS DE LOS ESTUDIANTES                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/2009 MIE
       Colombia, Bucaramanga        INICIO: 01:00 PM   MAR 11/2009 MIE

OBJETIVOS:

1- Permite eliminar las becas de los estudiantes.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_552(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
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
*>>>>FIN DECLARACION PARAMETROS GENERALES

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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
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
	    @ nNroFil,aNroCol[5] SAY nBecIniTcl PICT '99';

	    @ nNroFil,aNroCol[6] SAY nBecFinTcl PICT '99';

	    @ nNroFil,aNroCol[7] SAY nPorBecTcl PICT '999';

	    @ nNroFil,aNroCol[8] SAY nVlrBecTcl PICT '9999999'
**********FIN LECTURA DEL DESCUENTOS

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA ELIMINAR LA BECA? Si No')
	       CloseDbf('CLI',FileCli,nModCry)
	       RESTSCREEN(nNroFil,0,nNroFil,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********ELIMINACION DE LA BECA
	    nBecIniTcl := 0
	    nBecFinTcl := 0
	    nPorBecTcl := 0
	    nVlrBecTcl := 0
**********FIN ELIMINACION DE LA BECA

**********GRABACION DEL REGISTRO
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
**********FIN GRABACION DEL REGISTRO

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
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS

