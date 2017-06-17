/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: ACTUALIZAR

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE506.PRG                                    *
* TITULO DEL PROGRAMA..: GRABACION DE LOS ALUMNOS DEL FONDO              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 26/94 MAR A
						       JUL 26/94 MAR
REQUERIMIENTOS:

1- Ejucutar la funci¢n de acuerdo a su sintaxis

OBJETIVOS:

1- Permite Grabar los alumnos del fondo de la asociaci¢n de padres de familia

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_506(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // Codigo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lFondosTcl := .F.              // .T. Pertenece al fondo
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

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS ALUMNOS QUE '+;
				   ' PERTENECEN AL FONDO',22,'°')
       aTamCol := {06,06,02,40,06}
       aTitulo := {'CODIGO','CURSO ','No','NOMBRE','FONDO '}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS ALUMNOS DEL FONDO
       nNroFil++
       DO WHILE .T.

**********CAPTURA DEL CODIGO DEL CLIENTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := SPACE(04)
	    @ nNroFil,aNroCol[1] GET cCodigoTes PICT '9999';
				 VALID lCorrecion(@cCodigoTes)
	    READ
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
**********FIN CAPTURA DEL CODIGO DEL CLIENTE

***********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	     IF !lSekCodMae(cCodigoTes,cMaeAlu,@cNalias)
		CloseDbf(cNalias)
		LOOP
	     ENDIF
	     cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+&cNAlias->cNombreEst
	     cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
***********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\CLIENTES\CLI'+;
			    &cNalias->cCodigoGru+cAnoSis+ExtFile,'CLI')
	       cError('ABRIENDO EL ARCHIVO CLIENTES EN '+cPatSis)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
		 CloseAll(aUseDbf)
		 RETURN NIL
	    ENDCASE
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LECTURA DEL FONDO ACTUAL
	    IF lLocCodCli(cCodigoTes,.F.)
	       lFondosTcl := CLI->lFondosCli
	    ELSE
	       cError('EL CODIGO: '+cCodigoTes+' NO EXISTE EL ARCHIVO DE '+;
		      'CLIENTES DEL GRUPO: '+&cNalias->cCodigoGru+'. ERROR GRAVE')
	       CloseDbf(cNalias)
	       LOOP
	    ENDIF
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY STR(CLI->(RECNO()),2)
	    @ nNroFil,aNroCol[4] SAY cNombreTes
	    @ nNroFil,aNroCol[5] SAY IF(lFondosTcl,'SI','NO')
**********FIN LECTURA DEL FONDO ACTUAL

**********LECTURA DEL FONDO
	    IF lPregunta('Si No',nNroFil,aNroCol[5]+4)
	       lFondosTcl := .T.
	    ELSE
	       lFondosTcl := .F.
	    ENDIF
	    @ nNroFil,aNroCol[5] SAY IF(lFondosTcl,'SI','NO')
**********FIN LECTURA DEL FONDO

**********GRABACION DEL MES Y VALOR DEL DESCUENTO
	    SELECT CLI
	    IF CLI->(lRegLock(lShared,.F.))
	       REPL CLI->lFondosCli WITH lFondosTcl
	    ELSE
	       cError('NO SE GRABA EL FONDO PARA EL ESTUDIANTE')
	    ENDIF
**********FIN GRABACION DEL MES Y VALOR DEL DESCUENTO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS ALUMNOS QUE '+;
					   ' PERTENECEN AL FONDO',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 SET COLOR TO
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY STR(CLI->(RECNO()),2)
		 @ nNroFil,aNroCol[4] SAY cNombreTes
		 SET COLOR TO I
		 @ nNroFil,aNroCol[5] SAY IF(lFondosTcl,'SI','NO')
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
	    CloseDbf('CLI')
	    CloseDbf(cNalias)
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>GRABACION DE LOS ALUMNOS DEL FONDO