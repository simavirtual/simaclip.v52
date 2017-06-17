/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: DEFINIR CONTRANTES

**************************************************************************
* TITULO..: DEFINIR CONTRANTANTES                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 14/2004 MIE A
       Bucaramanga, Colombia	    INICIO: 11:15 PM   JUL 14/2004 MIE

OBJETIVOS:

1- Permite Grabar los contrantes que firma el contrato de servicios
   educativos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_305(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL       i := 0                   // Contador
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL nTipPer := 0                   // Tipo de Persona
       LOCAL cDocNit := ''                  // Documento del Contrante
       LOCAL cTipNit := ''                  // Tipo de Documento
       LOCAL lFotNit := .F.                 // .T. Hay Fotocopia
       LOCAL cNombre := ''                  // Nombres
       LOCAL cApelli := ''                  // Apellidos
       LOCAL cApeUno := ''                  // Primer Apellido
       LOCAL cApeDos := ''                  // Apellido Dos
       LOCAL cNomUno := ''                  // Primer Nombre
       LOCAL cNomDos := ''                  // Segundo Nombre
       LOCAL dFecNac := CTOD('00/00/00')    // Fecha de Nacimiento
       LOCAL cDirecc := ''                  // Direcci¢n de la Casa
       LOCAL cCiuDir := ''                  // Ciudad de la Direcci¢n
       LOCAL cTelefn := ''                  // Telefono
       LOCAL cDirEnv := ''                  // Direccion para la Correspondencia
       LOCAL cCiuEnv := ''                  // Ciudad para la Correspondencia
       LOCAL cTelTra := ''                  // Telefono del Trabajo
       LOCAL cCiuTra := ''                  // Ciudad del Trabajo
       LOCAL cEstrat := ''                  // Estrato

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
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
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoUsr)

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoUsr)

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoUsr)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE LOS CODIGOS '+;
				   'DE LOS ESTUDIANTES ',22,'°')
       aTamCol := {06,06,30}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS REGISTROS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)

	    @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********LECTURA DE LOS CONTRATANTES
	    cSavPan := SAVESCREEN(0,0,24,79)
	    i := 1
	    DO WHILE .T.

*===============GRABACION DEL CONTRATANTE
		  cDocNit := cGraFirCon(lShared,cNomUsr,i,cCodigoTes,;
					cNombreTes,;
					&cMaeAct->cCodigoGru,cMaeAct)
		  RESTSCREEN(0,0,24,79,cSavPan)
*===============FIN GRABACION DEL CONTRATANTE

*===============VALIDACION DEL CONTRATANTE
		  lHayErr := .T.
		  DO CASE
		  CASE EMPTY(&cMaeAct->cNitCo1Est)

		       cError('EL PRIMER CONTRATANTE SE DEBE DEFINIR')
		       IF lPregunta('DESEA ABANDONAR LA GRABACION? No Si')
			  EXIT
		       ENDIF
		       i := 1

		  CASE EMPTY(cDocNit)

***********************ANALISIS DE DECISION
			 IF lPregunta('NO SE GRABA EL CONTRATANTE No.'+;
			    STR(i,1)+'? Si No')
			    lHayErr := .F.
			 ENDIF
***********************FIN ANALISIS DE DECISION

***********************ELIMINACION DEL CONTRATANTE
			 IF !lHayErr

			    SELECT &cMaeAct
			    IF lRegLock(lShared,.F.)
			       REPL &(cMaeAct+'->cNitCo'+STR(i,1)+'Est') WITH ''
			       REPL &(cMaeAct+'->cTipCo'+STR(i,1)+'Est') WITH ''
			       REPL &(cMaeAct+'->lNoRCo'+STR(i,1)+'Est') WITH .F.
			    ELSE
				cError('NO SE GRABA EL REGISTRO')
			    ENDIF
			    DBCOMMIT()
			    IF lShared
			       DBUNLOCK()
			    ENDIF

			 ENDIF
***********************FIN ELIMINACION DEL CONTRATANTE

		  CASE cDocNit == 'NO ELIMINAR'

		  OTHERWISE
		       lHayErr :=.F.
		  ENDCASE

		  IF lHayErr
		     LOOP
		  ENDIF
*===============FIN VALIDACION DEL CONTRATANTE

*===============VALIDACION DEL NUMERO DE CONTRATANTES
		  i++
		  IF i > 4
		     EXIT
		  ENDIF
*===============FIN VALIDACION DEL NUMERO DE CONTRATANTES

	    ENDDO
**********FIN LECTURA DE LOS CONTRATANTES

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE LAS CEDULA '+;
					     'DE LOS CONTRATANTES ',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 SET COLOR TO
		 @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll(aUseDbf)

       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS