/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : ACTUALIZAR
SUBMODULO...: CREAR CLIENTES       MODULO No. 502

**************************************************************************
* NOMBRE DEL PROGRAMA......: CARTE502.PRG                                *
* TITULO DEL PROGRAMA......: CREACION DE CLIENTES Y PAGOS                *
* PROGRAMAS QUE LO INVOCAN.: Pendiente                                   *
* PROGRAMAS QUE INVOCA.....: Ninguno                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 09/94 JUE
						       JUN 09/94 JUE

REQUERIMIENTOS

1- Para que la funci¢n es necesario ejecutarla con los param‚tros correctos

OBJETIVOS:

1- Crea las estructuras de los archivos de clientes y pagos.

2- Graba los clientes actuales

 SINTAXIS

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_502(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL lOrdMae := .F.                 // .T. Ordenar los Maestros
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
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

*>>>>ANALISIS DE DECISION
       cError('DEBE GARANTIZAR QUE NINGUN USUARIO ESTE '+;
	      'UTILIZANDO EL SIMA')

       IF !lPregunta('ESTA SEGURO QUE NINGUN USUARIO '+;
		     'ESTA UTILIZANDO EL SIMA?No Si')
	  CloseAll()
	  RETURN NIL
       ENDIF

       IF !lPregunta('REALIZO COPIA DE SEGURIDAD? No Si')
	  cError('DEBE SACAR COPIA DE TODOS LOS A¥OS A ACTUALIZAR')
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ANALISIS DE DECISION
       lOrdMae := lPregunta('DESEA ORDENAR EL MAESTRO No Si')
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CREACION DE LOS CLIENTES
       IF 'JAR' $ cMaeAlu

	  CrearCli(lShared,nModCry,cIntUno+'\JAR',nFilPal+1,;
			   cIntUno+'\JAR\'+;
			   FMaeJar+cAnoSis+ExtFile,'JAR',;
			   cIntUno+'\JAR\'+;
			   FGruJar+cAnoSis+ExtFile,;
		   'JARDIN',cNomSis,cAnoUsr,cPatSis,lOrdMae)
       ENDIF

       IF 'PRI' $ cMaeAlu

	  CrearCli(lShared,nModCry,cIntUno+'\PRI',nFilPal+1,;
			   cIntUno+'\PRI\'+;
			   FMaePri+cAnoSis+ExtFile,'PRI',;
			   cIntUno+'\PRI\'+;
			   FGruPri+cAnoSis+ExtFile,;
		   'PRIMARIA',cNomSis,cAnoUsr,cPatSis,lOrdMae)
       ENDIF

       IF 'BTO' $ cMaeAlu

	  CrearCli(lShared,nModCry,cIntUno+'\BTO',nFilPal+1,;
			   cIntUno+'\BTO\'+;
			   FMaeBto+cAnoSis+ExtFile,'BTO',;
			   cIntUno+'\BTO\'+;
			   FGruBto+cAnoSis+ExtFile,;
		   'BACHILLERATO',cNomSis,cAnoUsr,cPatSis,lOrdMae)
       ENDIF
       CloseAll()
       Indexar(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu)
      *Indexa los archivos del sistema
       RETURN NIL
*>>>>FIN CREACION DE LOS CLIENTES


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************


/*************************************************************************
* TITULO DEL PROGRAMA..: CREACION DE LOS CLIENTES                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 09/94 JUE
						       JUN 09/94 JUE
OBJETIVOS:

1- Crae los clientes de un nivel Jardin, Primaria, Bachillerato

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearCli(lShared,nModCry,cIntUno,nFilPal,ArchAlu,cNalias,;
		  ArchGru,cNomNiv,cNomSis,cAnoUsr,cPatSis,lOrdMae)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cIntUno                              // Path de Integracion Uno
       nFilPal                              // Fila principal de impresi¢n
       ArchAlu                              // Archivo de alumnos
       cNalias                              // Alias del maestro
       ArchGru			            // Archivo de Grupos
       cNomNiv                              // Nombre del nivel
       cNomSys                              // Nombre del sistema
       cAnoUsr				    // A¤o del sistema
       cPatSis                              // Path del sistema
       lOrdMae                              // .T. Ordenar el Mestro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .T.                 // Hay Error
       LOCAL cFilter := ''                  // Condici¢n del filtro
       LOCAL lExiste := .F.                 // .T. = Existe configuraci¢n
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE AREAS DE TRABAJO
       IF !lUseDbf(.T.,ArchGru,'GRU',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,ArchAlu,cNalias,NIL,lShared) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS DE ALUMNOS Y GRUPOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE (RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS EN '+cNomNiv)

       CASE GRU->(RECCOUNT()) == 0
	    cError('LOS GRUPOS NO ESTAN GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DE EXISTENCIA DE LOS CLIENTES
       IF lFilesCli(cPatSis,cAnoSis)
	  cError('LOS CLIENTES DE LA CARTERA DE '+cNomNiv+' YA ESTAN CREADOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       nNroFil := nMarco(nFilPal,'POR FAVOR ESPERE MIENTRAS SE CREAN '+;
				 'LOS CLIENTES DE '+cNomNiv)
*>>>>FIN VALIDACION DE EXISTENCIA DE LOS CLIENTES

*>>>>ORDENANDO EL MAESTRO
       CloseAll(aUseDbf)
       lOrdMae := IF(lOrdMae == NIL,.F.,lOrdMae)
       IF lOrdMae
	  IF !lOrdMae(lShared,cIntUno,cNalias,cAnoSis)
	     cError('NO SE ORDENO EL MAESTRO')
	  ENDIF
       ENDIF
       CloseAll(aUseDbf)
*>>>>FIN ORDENANDO EL MAESTRO

*>>>>SELECION DE AREAS DE TRABAJO
       IF !lUseDbf(.T.,ArchGru,'GRU',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,ArchAlu,cNalias,NIL,lShared) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS DE ALUMNOS Y GRUPOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE (RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS EN '+cNomNiv)

       CASE GRU->(RECCOUNT()) == 0
	    cError('LOS GRUPOS NO ESTAN GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CREACION DE LOS GRUPOS Y GRABACION DE LOS CLIENTES Y PAGOS
       SELECT GRU
       GO TOP
       DO WHILE .NOT. EOF()

**********CREACION DE LAS ESTRUCTURAS DE CLIENTES Y PAGOS
	     CreaDbfCli(lShared,nModCry,cPatSis+"\CLIENTES",;
			'CL'+GRU->cCodigoGru+cAnoSis+ExtFile)
	     CreaDbfPag(lShared,nModCry,cPatSis+"\PAGOS",;
			'PA'+GRU->cCodigoGru+cAnoSis+ExtFile)
**********FIN CREACION DE LAS ESTRUCTURAS DE CLIENTES Y PAGOS

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       GRU->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
		cError('ABRIENDO ARCHIVOS DE CLIENTES')
		CloseDbf('CLI',FileCli,nModCry)
		EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********BLOQUE DEL ARCHIVO MAESTRO
	    SELECT &cNalias
	    IF lFileLock()
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN BLOQUE DEL ARCHIVO MAESTRO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('CREANDO LOS CLIENTES DEL GRUPO: '+GRU->cCodigoGru+;
			' ...copiando en el disco',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********FILTRACION DEL ARCHIVO DE ALUMNOS
	    DO CASE
	    CASE cNalias == 'JAR'
	       SELECT JAR
	       SET FILTER TO JAR->cCodigoGru == GRU->cCodigoGru

	    CASE cNalias == 'PRI'
	       SELECT PRI
	       SET FILTER TO PRI->cCodigoGru == GRU->cCodigoGru

	    CASE cNalias == 'BTO'
	       SELECT BTO
	       SET FILTER TO BTO->cCodigoGru == GRU->cCodigoGru
	    ENDCASE
	    GO TOP
**********FIN FILTRACION DEL ARCHIVO DE ALUMNOS

**********GRABACION DE LOS CLIENTES DEL RESPECTIVO GRUPO
	    DO WHILE .NOT. EOF()

*--------------GRABACION DEL CLIENTE EN EL DISCO
		 SELECT CLI
		 IF CLI->(lRegLock(lShared,.T.))
		    REPL CLI->cCodigoEst WITH &cNalias->cCodigoEst
		    REPL CLI->lRetGruCli WITH .F. // .F. Pertenece al grupo.
		    REPL CLI->lFondosCli WITH .F. // .T. Pertenece al fondo.
		    REPL CLI->cHayNovCli WITH '111111111111' // Aplicar novedad general de descuento o recargo.
		    CLI->(DBCOMMIT())
		 ELSE
		    cError('NO SE CREA EL CLIENTE CON CODIGO: '+;
			   &cNalias->cCodigoEst)
		 ENDIF
		 IF lShared
		    CLI->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DEL CLIENTE EN EL DISCO

*--------------VISUALIZACION DEL CLIENTE GRABADO
		 nNroFil++
		 cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			       RTRIM(&cNalias->cNombreEst)
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)

		 @ nNroFil,01 SAY cNombreTes+' ... DE '+GRU->cCodigoGru

		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal,'POR FAVOR ESPERE MIENTRAS '+;
				      'SE CREAN LOS CLIENTES DE '+cNomNiv)
		 ENDIF
*--------------FIN VISUALIZACION DEL CLIENTE GRABADO

	       SELECT &cNalias
	       SKIP
	    ENDDO
	    SET FILTER TO
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN GRABACION DE LOS CLIENTES DEL RESPECTIVO GRUPO

	  SELECT GRU
	  SKIP

       ENDDO
       SELECT &cNalias
       DBUNLOCKALL()
       SET FILTER TO
*>>>>FIN CREACION DE LOS GRUPOS Y GRABACION DE LOS CLIENTES Y PAGOS

*>>>>GRABACION DE LA CREACION DE LOS CLIENTES
       IF CAA->(lRegLock(lShared,.F.))
	  REPL CAA->lHayCliCaA WITH .T.
	  CAA->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL SWICTH DE LA CREACION DE CLIENTES')
       ENDIF
       IF lShared
	  CAA->(DBUNLOCK())
       ENDIF
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN GRABACION DE LA CREACION DE LOS CLIENTES

FUNCTION lOrdMae(lShared,cPatSis,cMaeAct,cAnoSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Activo
       cAnoSis                              // A¤o del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>COPIA DEL MAESTRO PARA EL ORDENAMIENTO
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'ORDENANDO EL MAESTRO')
       Termometro(10)

       FILECOPY(cPatSis+'\'+FileAlu+cMaeAct+cAnoSis+ExtFile,;
		cPatSis+'\'+FileAlu+cMaeAct+cAnoSis+'.TEM')
       Termometro(40)
*>>>>FIN COPIA DEL MAESTRO PARA EL ORDENAMIENTO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		      FileAlu+cMaeAct+cAnoSis+'.TEM','ALU',NIL,lShared)
	  cError('ABRIENDO ARCHIVO MAESTRO TEMPORAL EN '+cPatSis)
	  CloseDbf('ALU')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseDbf('ALU')
	  RETURN .F.
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ORDENAMIENTO DEL MAESTRO
       Termometro(50)
       SORT TO &(cPatSis+'\'+FileAlu+cMaeAct+cAnoSis+ExtFile) ;
	    ON cCodigoGru,cApelliEst,cNombreEst

       CloseDbf('ALU')
       IF !lFileDelete(cPatSis+'\'+FileAlu+cMaeAct+cAnoSis+'.TEM')
	  cError('NO SE BORRO EL MAESTRO TEMPORAL')
       ENDIF
       Termometro(100)
       SAVESCREEN(0,0,24,79,cSavPan)
       RETURN .T.
*>>>>FIN ORDENAMIENTO DEL MAESTRO