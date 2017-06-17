/* SIMA - MATRICULA ACADEMICA

MODULO      : CUPOS
SUBMODULO...: CONTRANTES                               MODULO No. 401

**************************************************************************
* TITULO..: GRABACION DE CONTRATANES                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 17/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   SEP 17/2004 VIE


OBJETIVOS:

1- Permite grabar los contratantes

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_405(aParam1,aParam2,aParam3)

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
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL lNuevos := .F.                 // .T. Matricula para nuevos
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
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL lPagRec := .F.                 // .T. Pago el recibo

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

       LOCAL nOpcion := 0                   // N£mero de Opci¢n.
       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
       LOCAL cJornad := ''                  // Jornadas habilitadas
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
		       @cMaeAlu,@cMaeAct,@cJorTxt,@cJornad)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS
       nOpcion := nLeeOpcion('CONTRATANTES PARA: '+;
			     '1<NUEVOS> 2<ANTIGUOS> '+;
			     '3<A¥OS ANTERIORES 4<ABANDONAR>?',4,'1')

       IF nOpcion == 4
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF

       lNuevos := .F.
       IF nOpcion == 1
	  lNuevos := .T.
       ENDIF
*>>>>FIN SELECCION DE ALUMNOS NUEVOS O ANTIGUOS

*>>>>LECTURA Y VALIDACION DEL A¥O
       IF nOpcion == 3 // A¥OS ANTERIORES

	  cSavPan := SAVESCREEN(0,0,24,79)
	  cAnoAnt := SPACE(04)
	  @ nFilInf+1,nColInf SAY 'A¥O:' GET cAnoAnt PICT '9999'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(cAnoAnt)
	     cError('SE ABANDONA EL PROCESO')
	     CloseAll()
	     RETURN NIL
	  ENDIF

	  MaeHab(lShared,nModCry,;
		 cAnoAnt+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
		 fMtrAno+cAnoAnt+ExtFile,;
		 @cMaeAlu,@cJornad,'ANO->cMaeHabAno','ANO->cJorHabAno')
       *ÀMaestros habilitados.

       ENDIF
*>>>>FIN LECTURA Y VALIDACION DEL A¥O

*>>>>SELECION DEL A¥O ANTERIOR
       DO CASE

       CASE nOpcion == 1 // ANTIGUOS

	    cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)

       CASE nOpcion == 2 // ANTIGUOS

	    cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)

       CASE nOpcion == 3 // A¥OS ANTERIORES

	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)

       ENDCASE
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCnt+ExtFile,'CNT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatAnt,;
			 cMaeAlu,SUBS(cAnoAnt,3,2)) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE lNuevos .AND. ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin')

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria')

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VERIFICACION DE INSCRIPCIONES ABIERTAS
       IF !ANO->lHayMtrAno
	  cError('Estan Cerradas las Matriculas para '+cAnoUsr,;
		 '!Atenci¢n!')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VERIFICACION DE INSCRIPCIONES ABIERTAS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE LOS CODIGOS '+;
				   'DE LOS ESTUDIANTES ',22,'°')
       aTamCol := {06,06,30}
       aTitulo := {'CODIGO','NIVEL ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS REGISTROS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO NUEVO
	    cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)
	    IF lNuevos
	       cNalias := 'ADM'

	       IF lLeeCodAdm(nNroFil,aNroCol[1],;
			     @cCodigoTes,{||lLocCodigo('cNumeroAdm',;
					    'ADM',cCodigoTes,;
					    'NUMERO DE INSCRIPCION')})
		   EXIT
	       ENDIF
	       cCodigoTes := ADM->cCodigoEst
	    ENDIF
**********FIN LECTURA DEL CODIGO NUEVO

**********LECTURA DEL CODIGO ANTIGUO
	    IF !lNuevos
	       cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
		  cNalias := cMaeAct
	    ENDIF
**********FIN LECTURA DEL CODIGO ANTIGUO

**********VALIDACION DEL CODIGO
	    IF LASTKEY() == K_ESC .OR. EMPTY(cCodigoTes) .OR.;
	       EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := ALLTRIM(RTRIM(&cNalias->cApelliEst)+' '+;
				  &cNalias->cNombreEst)
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN VALIDACION DEL CODIGO


**********ANALISIS DE DECISION
	    IF EMPTY(&cNalias->dFecNacEst) .AND. EMPTY(&cNalias->cLugNacEst) .AND.;
	       ANO->lMtrResAno

	       cError(cNombreTes+' LE FALTA REGISTRARLE SUS DATOS PERSONALES')
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := PathDos+'\'+cPatAnt+'\CLIENTES\CL'+;
		       &cNalias->cCodigoGru+SUBS(cAnoAnt,3,2)+ExtFile

	    FilePag := PathDos+'\'+cPatAnt+'\PAGOS\PA'+;
		       &cNalias->cCodigoGru+SUBS(cAnoAnt,3,2)+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !EMPTY(PathDos)  .AND. nOpcion == 2
	       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		  !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
		  cError('ABRIENDO EL ARCHIVO DE CLIENTES')
		  LOOP
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********PAZ Y SALVO
	    IF !EMPTY(PathDos) .AND. nOpcion == 2

	       IF !lLocCodigo('cCodigoEst','CLI',cCodigoTes)
		  cError(cNombreTes+' NO EXISTE EN LOS '+;
			 'CLIENTES DEL GRUPO: '+&cMaeAct->cCodigoGru)
		  LOOP
	       ENDIF

	       IF nUltRecPag(CLI->cCodigoEst) == 0
		  nMesIni := 0
	       ELSE
		  nMesIni := PAG->nMesIniPag
	       ENDIF

	       lPagRec := .T.
	       IF lLocCodPag(cCodigoTes,nMesIni,.F.)

		  lPagRec := CLI->nSdoActCli+CLI->nSdoMorCli == 0 .AND.;
			     !EMPTY(PAG->dFecPagPag)              .AND.;
			     (PAG->cEstadoPag == 'P' .OR.;
			      PAG->cEstadoPag == 'A')
	       ENDIF


	       IF !lPagRec
		  cError(cNombreTes+' NO esta a PAZ Y SALVO')
		  IF !lPregunta('DESEA CONTINUAR? No Si')
		     LOOP
		  ENDIF
	       ENDIF

	    ENDIF
**********FIN PAZ Y SALVO

**********LECTURA DE LOS CONTRATANTES
	    cSavPan := SAVESCREEN(0,0,24,79)
	    i := 1
	    DO WHILE .T.

*===============GRABACION DEL CONTRATANTE
		  cDocNit := cGraCntAdm(lShared,cAnoUsr,i,cCodigoTes,;
					cNombreTes,&cNalias->cCodigoGru,;
					cNalias)
		  RESTSCREEN(0,0,24,79,cSavPan)
*===============FIN GRABACION DEL CONTRATANTE

*===============VALIDACION DEL CONTRATANTE
		  lHayErr := .T.
		  DO CASE
		  CASE !lLocNroCnt(cCodigoTes,1)

		       cError('EL PRIMER CONTRATANTE SE DEBE DEFINIR')
		       IF lPregunta('DESEA ABANDONAR LA GRABACION? No Si')
			  EXIT
		       ENDIF
		       i := 1

		  CASE EMPTY(cDocNit)

		       IF lPregunta('NO SE GRABA EL CONTRATANTE No.'+;
			  STR(i,1)+'? Si No')
			  lHayErr := .F.
		       ENDIF

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

**********ACTUALIZACION DE LA INFORMACION PERSONAL
	    IF !lNuevos .AND. ANO->lActInfAno
	       cError('A CONTINUACION SE ACTUALIZA LA INFORMACION FAMILIAR')
	       cSavPan := SAVESCREEN(0,0,24,79)
	       lDatosEst(lShared,nFilPal,1,cNalias,;
			 cCodigoTes,cNombreTes,&cNalias->cCodigoGru,1)
	       RESTSCREEN(0,0,24,79,cSavPan)
	    ENDIF
**********FIN ACTUALIZACION DE LA INFORMACION PERSONAL

**********ACTUALIZACION DE LA INFORMACION DE LOS PADRES
	    IF !lNuevos .AND. ANO->lActInfAno
	       cSavPan := SAVESCREEN(0,0,24,79)
	       lDatosEst(lShared,nFilPal,1,cNalias,;
			 cCodigoTes,cNombreTes,&cNalias->cCodigoGru,2)
	       RESTSCREEN(0,0,24,79,cSavPan)
	    ENDIF
**********FIN ACTUALIZACION DE LA INFORMACION DE LOS PADRES

**********ACTUALIZACION DE LA INFORMACION DEL ACUDIENTE
	    IF !lNuevos .AND. ANO->lActInfAno
	       cSavPan := SAVESCREEN(0,0,24,79)
	       lDatosEst(lShared,nFilPal,1,cNalias,;
			 cCodigoTes,cNombreTes,&cNalias->cCodigoGru,3)
	       RESTSCREEN(0,0,24,79,cSavPan)
	    ENDIF
**********FIN ACTUALIZACION DE LA INFORMACION DEL ACUDIENTE

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
		 @ nNroFil,aNroCol[2] SAY ADM->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll(aUseDbf)

       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

/*************************************************************************
* TITULO..: GRABACION DE LOS CONTRATANTES                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 17/2004 VIE A
       Colombia, Bucaramanga        INICIO: 12:00 PM   SEP 17/2004 VIE

OBJETIVOS:

1- Graba y actualiza la informaci¢n de los contratantes
   persona.

2- Retorna el documento digitado.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cGraCntAdm(lShared,cAnoUsr,nNroCnt,cCodEst,cNomEst,cCodGru,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       nNroCnt			            // N£mero del Contrante
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // Codigo del Grupo
       cNalias			            // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 3                   // N£mero de la fila
       LOCAL nNroCol := 1                   // N£mero de la Columna
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL lInsPer := .F.                 // .T. Insertar Registro de Personas
       LOCAL lInsCnt := .F.                 // .T. Insertar Registro de Contratantes
       LOCAL lDelCnt := .F.                 // .T. Eliminar el Contratante

       LOCAL lSiQepd := .F.                 // .T. Fallecido
       LOCAL cTxtTip := ''                  // Descripci¢n del Contratante
       LOCAL nTipPer := 0                   // Tipo de Persona

       LOCAL cNroDoc := ''                  // N£mero del Documento digitado
       LOCAL cNroNit := ''                  // Documento del Contratante
       LOCAL cDocNit := ''                  // Documento del Contrante
       LOCAL cTipNit := ''                  // Tipo de Documento
       LOCAL cLugNit := ''                  // Lugar de Nacimiento
       LOCAL lFotNit := .F.                 // .T. Hay Fotocopia
       LOCAL cFotNit := SPACE(01)           // S=> Hay Fotocopia

       LOCAL cNombre := ''                  // Nombres
       LOCAL cApelli := ''                  // Apellidos
       LOCAL cApeUno := ''                  // Primer Apellido
       LOCAL cApeDos := ''                  // Apellido Dos
       LOCAL cNomUno := ''                  // Primer Nombre
       LOCAL cNomDos := ''                  // Segundo Nombre

       LOCAL dFecNac := CTOD('00/00/00')    // Fecha de Nacimiento
       LOCAL cLugNac := ''                  // Lugar de Nacimiento

       LOCAL cDirecc := ''                  // Direcci¢n de la Casa
       LOCAL cCiuDir := ''                  // Ciudad de la Direcci¢n
       LOCAL cTelefn := ''                  // Telefono

       LOCAL cDirEnv := ''                  // Direccion para la Correspondencia
       LOCAL cCiuEnv := ''                  // Ciudad para la Correspondencia

       LOCAL cTelTra := ''                  // Telefono del Trabajo
       LOCAL cCiuTra := ''                  // Ciudad del Trabajo

       LOCAL cEstrat := ''                  // Estrato
       LOCAL cSexFem := ''                  // Sexo de la Persona
       LOCAL lSexFem := .F.                 // Sexo de la Persona

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VISUALIZACION DATOS DEL ESTUDIANTE
       nFilIni := nMarco(nNroFil,'CODIGO:'+cCodEst+' '+;
				 'GRUPO:'+cCodGru+' '+;
				 'NOMBRE:'+ALLTRIM(cNomEst),22,'°')

       @ nFilIni++,nNroCol SAY 'POR FAVOR INGRESE LOS DETALLES '+;
			       'CONTRANTE No.'+STR(nNroCnt,1)
       nFilIni++
*>>>>FIN VISUALIZACION DATOS DEL ESTUDIANTE

*>>>>LOCALIZACION DEL CONTRATANTE
       lInsCnt := !lLocNroCnt(cCodEst,nNroCnt)
       IF lInsCnt

**********ANALISIS DE LA NO EXISTENCIA
	    IF !lLocCodigo('cCodigoEst','CNT',cCodEst)

*==============ANALISIS DE DECISION
		 IF cNalias == 'ADM'

		    cDocNit := cSpaces('CNT','cDocNitPer')
		    cTipNit := cSpaces('CNT','cTipNitPer')
		  *ÀEn blanco para los nuevos

		 ELSE

		    cDocNit := &(cNalias+'->cNitCo'+STR(nNroCnt,1)+'Est')
		    cTipNit := &(cNalias+'->cTipCo'+STR(nNroCnt,1)+'Est')
		  *ÀEl contratante del a¤o anterior

		 ENDIF
*==============FIN ANALISIS DE DECISION

	    ELSE

*==============CONTRATANTE No.X NO DEFINIDO
		 cDocNit := cSpaces('CNT','cDocNitPer')
		 cTipNit := cSpaces('CNT','cTipNitPer')
*==============FIN CONTRATANTE No.X NO DEFINIDO

	    ENDIF
**********FIN ANALISIS DE LA NO EXISTENCIA

       ELSE

**********CONTRATANTE EXISTE
	    cDocNit := CNT->cDocNitPer
	    cTipNit := CNT->cTipNitPer
	  *ÀRecupera el contratante actual
**********FIN CONTRATANTE EXISTE

       ENDIF
       cNroNit := cDocNit
*>>>>FIN LOCALIZACION DEL CONTRATANTE

*>>>>LECTURA DEL DOCUMENTO DE IDENTIFICACION
       DO WHILE .T.

	  cNroDoc := cDocNit
	  @ nFilIni,nNroCol+00 SAY 'DOCUMENTO: ';
			       GET  cNroDoc PICT "@!";
		    WHEN {||HelpRead('DIGITE EL DOCUMENTO DE IDENTIDAD')}
	  READ

	  IF EMPTY(cDocNit) .AND. EMPTY(cNroDoc)
	     RETURN cDocNit
	  ENDIF

	  cDocNit := cNroDoc
	  IF !EMPTY(cDocNit) .AND. LEN(ALLTRIM(cDocNit)) <= 4
	     LOOP
	  ENDIF

	  EXIT
       ENDDO

       IF !EMPTY(cDocNit)
	  @ nFilIni,nNroCol+30 SAY 'TIPO:';
			       GET cTipNit PICT "@!";
		      VALID lValTipDoc(ROW(),COL()-1,@cTipNit,'145') .AND.;
			    !EMPTY(cTipNit);
			    WHEN {||HelpRead('DIGITE EL TIPO DE DOCUMENTO')}
	  READ
       ENDIF
*>>>>FIN LECTURA DEL DOCUMENTO DE IDENTIFICACION

*>>>>ANALISIS DEL CONTRATANTE
       nTipPer := nTipPerMae(cDocNit,;
			     &cNalias->cPadNitEst,;
			     &cNalias->cMadNitEst,;
			     @cTxtTip)
*>>>>FIN ANALISIS DEL CONTRATANTE

*>>>>LECTURA DE LOS DETALLES DEL CONTRATANTE
       SET ESCAPE ON
       lGrabar := .T.
       DO WHILE .T.

**********LECTURA DATOS DE LOS FAMILIARES
	    nNroFil := nFilIni
	    DO CASE
	    CASE nTipPer == 1 .AND. lGrabar // Padre

		 lSiQepd := &cNalias->lPadQepEst

		 cLugNit := &cNalias->cPadLugEst
		 cFotNit := IF(&cNalias->lPadFotEst,'S','N')

		 cNombre := &cNalias->cNomPadEst
		 cApelli := &cNalias->cApePadEst

		 dFecNac := &cNalias->dNacPadEst
		 cLugNac := &cNalias->cLugPadEst

		 cDirecc := &cNalias->cDirPadEst
		 cCiuDir := &cNalias->cCiuPadEst
		 cTelefn := &cNalias->cTelPadEst

		 cDirEnv := cDirecc
		 cCiuEnv := cCiuDir

		 cTelTra := &cNalias->cTelPadEst
		 cCiuTra := &cNalias->cCiuPadEst

		 cEstrat := STR(&cNalias->nEstratEst,1)
		 cSexFem := 'N'

	    CASE nTipPer == 2 .AND. lGrabar // Madre

		 lSiQepd := &cNalias->lMadQepEst

		 cLugNit := &cNalias->cMadLugEst
		 cFotNit := IF(&cNalias->lMadFotEst,'S','N')

		 cNombre := &cNalias->cNomMadEst
		 cApelli := &cNalias->cApeMadEst

		 dFecNac := &cNalias->dNacMadEst
		 cLugNac := &cNalias->cLugMadEst

		 cDirecc := &cNalias->cDirMadEst
		 cCiuDir := &cNalias->cCiuMadEst
		 cTelefn := &cNalias->cTelMadEst

		 cDirEnv := cDirecc
		 cCiuEnv := cCiuDir

		 cTelTra := &cNalias->cTelMadEst
		 cCiuTra := &cNalias->cCiuMadEst

		 cEstrat := STR(&cNalias->nEstratEst,1)
		 cSexFem := 'S'

	    CASE nTipPer == 3 .AND. lGrabar // Otra Persona

		 lInsPer := !lLocNitPer(cDocNit,cTipNit)
		 IF lInsPer

		    lSiQepd := .F.

		    cFotNit := ' '
		    cLugNit := cSpaces('PER','cLugNacPer')

		    cApeUno := cSpaces('PER','cApeUnoPer')
		    cApeDos := cSpaces('PER','cApeDosPer')
		    cNomUno := cSpaces('PER','cNomUnoPer')
		    cNomDos := cSpaces('PER','cNomDosPer')

		    dFecNac := CTOD('00/00/00')
		    cLugNac := cSpaces('PER','cLugNacPer')

		    cDirecc := cSpaces('PER','cDireccPer')
		    cCiuDir := cSpaces('PER','cCiudadPer')
		    cTelefn := cSpaces('PER','cTelefnPer')

		    cDirEnv := cSpaces('PER','cDirEnvPer')
		    cCiuEnv := cSpaces('PER','cBarEnvPer')

		    cTelTra := cSpaces('PER','cTelTraPer')
		    cCiuTra := cSpaces('PER','cCiuTraPer')

		    cEstrat := cSpaces('PER','cEstratPer')
		    cSexFem := ' '

		 ELSE
		    lSiQepd := PER->lSiQepdPer

		    cLugNit := PER->cLugNitPer
		    cFotNit := IF(PER->lFotNitPer,'S','N')

		    cApeUno := PER->cApeUnoPer
		    cApeDos := PER->cApeDosPer
		    cNomUno := PER->cNomUnoPer
		    cNomDos := PER->cNomDosPer

		    dFecNac := PER->dFecNacPer
		    cLugNac := PER->cLugNacPer

		    cDirecc := PER->cDireccPer
		    cCiuDir := PER->cCiudadPer
		    cTelefn := PER->cTelefnPer

		    cDirEnv := PER->cDirEnvPer
		    cCiuEnv := PER->cBarEnvPer

		    cTelTra := PER->cTelTraPer
		    cCiuTra := PER->cCiuTraPer

		    cEstrat := PER->cEstratPer
		    cSexFem := IF(PER->lSexFemPer,'F','M')
		 ENDIF
	    ENDCASE
**********FIN LECTURA DATOS DE LOS FAMILIARES

**********ANALISIS DE DECISION
	    IF nTipPer # 0 .AND. lSiQepd
	       cError('ESTA PERSONA ESTA FALLECIDA')
	       RETURN cDocNit
	    ENDIF
**********FIN ANALISIS DE DECISION

**********LECTURA DE LA FOTOCOPIA DEL DOCUMENTO
	    IF nTipPer # 0
	       @ nNroFil,nNroCol+40 SAY 'DE:';
				    GET cLugNit PICT "@!"

	       @ nNroFil-1,nNroCol+66 SAY 'FOTOCOPIA?'
	       @ nNroFil,nNroCol+66 GET cFotNit ;
				    VALID lValSiNo(ROW(),COL()-1,;
					  @cFotNit,@lFotNit)
	    ENDIF
**********LECTURA DE LA FOTOCOPIA DEL DOCUMENTO

**********LECTURA DEL NOMBRE
	    nNroFil += 2
	    IF nTipPer == 3

	       @nNroFil,nNroCol+0 SAY 'PRIMER APELLIDO:';
				  GET cApeUno PICT "@!" ;
				  VALID !EMPTY(cApeUno);
				  WHEN {||HelpRead('DIGITE EL '+;
						   'PRIMER APELLIDO')}

	       @nNroFil,nNroCol+38 SAY 'SEGUNDO APELLIDO:';
				   GET cApeDos PICT "@!" ;
				   WHEN {||HelpRead('DIGITE EL '+;
						   'SEGUNDO APELLIDO')}

	       nNroFil++
	       @nNroFil,nNroCol+0 SAY 'PRIMER NOMBRE:';
				  GET cNomUno PICT "@!" ;
				  VALID !EMPTY(cNomUno);
				  WHEN {||HelpRead('DIGITE EL '+;
						   'PRIMER NOMBRE')}

	       @nNroFil,nNroCol+38 SAY 'SEGUNDO NOMBRE:';
				   GET cNomDos PICT "@!" ;
				   WHEN {||HelpRead('DIGITE EL '+;
						   'SEGUNDO NOMBRE')}

	    ELSE

	       IF nTipPer # 0
		  SET COLOR TO I
		  @nNroFil,nNroCol+0 SAY cTxtTip+':'
		  SET COLOR TO
		  @nNroFil,nNroCol+LEN(cTxtTip)+2 SAY ALLTRIM(cNombre)+' '+;
						      ALLTRIM(cApelli)
	       ENDIF

	    ENDIF
**********FIN LECTURA DEL NOMBRE

**********ACTUALIZACION DE LA INFORMACION
	    IF nTipPer # 0

	       nNroFil += 2
	       @nNroFil,nNroCol+00 SAY 'FECHA DE NACIMIENTO:';
				     GET dFecNac PICT "@!" ;
				     VALID HelpRead();
				     WHEN {||HelpRead('FECHA')}

	       @nNroFil,nNroCol+33 SAY 'ESTRATO:';
				   GET cEstrat PICT "9";
		 WHEN {||HelpRead('INGRESE EL NUMERO DEL ESTRATO')}


	       IF nTipPer == 3
		  @ nNroFil,nNroCol+46 SAY 'SEXO:';
				       GET cSexFem;
				       VALID lValSexo(ROW(),COL()-1,;
					     @cSexFem,@lSexFem)
	       ENDIF

	       nNroFil++
	       @++nNroFil,nNroCol+00 SAY 'DIRECCION CASA:';
				     GET cDirecc PICT "@!40";
		 WHEN {||HelpRead('INGRESE LA DIRECCION DE LA CASA')}


	       @++nNroFil,nNroCol+00 SAY 'CIUDAD:';
				     GET cCiuDir PICT "@!S30";
		 WHEN {||HelpRead('INGRESE LA CIUDAD DE LA DIRECCION DE LA CASA')}

	       @nNroFil,nNroCol+50 SAY 'TEL CASA:';
				     GET cTelefn PICT "@!S14";
		 WHEN {||HelpRead('INGRESE EL TELEFONO DE LA CASA')}

	       nNroFil += 2
	       @nNroFil,nNroCol+00 SAY 'CIUDAD TRABAJO:';
				   GET cCiuTra PICT "@!S30";
		 WHEN {||HelpRead('INGRESE LA CIUDAD DEL TRABAJO')}

	       @nNroFil,nNroCol+47 SAY 'TEL TRABAJO:';
				   GET cTelTra PICT "@!S14";
		 VALID HelpRead('<ESC> ABANDONA LA GRABACION');
		 WHEN {||HelpRead('INGRESE EL TELEFONO DEL TRABAJO')}

	       IF nTipPer == 3
		  nNroFil += 1
		  @++nNroFil,nNroCol+00 SAY 'DIRECCION CORRESPONDENCIA:';
					GET cDirEnv PICT "@!S50";
			     WHEN {||HelpRead('INGRESE LA DIRECCION PARA '+;
					      'ENVIO DE CORRESPONDENCIA')}

		  @++nNroFil,nNroCol+00 SAY 'CIUDAD CORRESPONDECIA:';
					GET cCiuEnv PICT "@!S30";
					VALID HelpRead();
			     WHEN {||HelpRead('INGRESE LA CIUDAD PARA EL '+;
					      'ENVIO DE CORRESPONDENCIA')}
		  ENDIF
	       READ
	    ENDIF
**********FIN ACTUALIZACION DE LA INFORMACION

**********PREGUNTA DE DECISION
	    DO CASE
	    CASE LASTKEY() # K_ESC

		 IF nTipPer # 0
		    IF !lPregunta('DESEA GRABAR? Si No')
		       lGrabar := .F.
		       LOOP
		    ELSE
		       lGrabar := .T.
		    ENDIF
		 ELSE
		    lDelCnt := lPregunta('DESEA ELIMINAR EL CONTRANTE No.'+;
					 STR(nNroCnt,1)+' '+;
					 'CON DOCUMENTO No.'+;
					 ALLTRIM(cNroNit)+'? Si No')
		    IF !lDelCnt
		       lGrabar := .F.
		       cDocNit := 'NO ELIMINAR'
		       EXIT
		    ELSE
		       lGrabar := .T.
		    ENDIF
		 ENDIF

	    CASE LASTKEY() == K_ESC
		 lGrabar := .F.
		 IF !lPregunta('DESEA ABANDONAR? Si No')
		    LOOP
		 ENDIF
		 EXIT
	    ENDCASE
**********FIN PREGUNTA DE DECISION

**********GRABACION O ACTUALIZACION DEL REGISTRO
	    IF lGrabar

	       DO CASE
	       CASE nTipPer == 1 // Padre

*===================ACTUALIZACION DE LOS DATOS DEL PADRE
		      SELECT &cNalias
		      IF lRegLock(lShared,.F.)

			 IF cNalias # 'ADM'
			    REPL &(cNalias+'->cNitCo'+STR(nNroCnt,1)+'Est') WITH cDocNit
			    REPL &(cNalias+'->cTipCo'+STR(nNroCnt,1)+'Est') WITH cTipNit
			 ENDIF

			 REPL &cNalias->cPadLugEst WITH cLugNit

			 REPL &cNalias->lPadFotEst WITH lFotNit

			 REPL &cNalias->cNomPadEst WITH cNombre
			 REPL &cNalias->cApePadEst WITH cApelli
			 REPL &cNalias->dNacPadEst WITH dFecNac

			 REPL &cNalias->cDirPadEst WITH cDirecc
			 REPL &cNalias->cCiuPadEst WITH cCiuDir
			 REPL &cNalias->cTelPadEst WITH cTelefn

			 REPL &cNalias->cTelPadEst WITH cTelTra
			 REPL &cNalias->cCiuPadEst WITH cCiuTra
			 REPL &cNalias->nEstratEst WITH VAL(cEstrat)

		      ELSE
			  cError('NO SE GRABA EL REGISTRO')
		      ENDIF

		      DBCOMMIT()
		      IF lShared
			 DBUNLOCK()
		      ENDIF
*===================FIN ACTUALIZACION DE LOS DATOS DEL PADRE

	       CASE nTipPer == 2  // Madre

*===================ACTUALIZACION DE LOS DATOS DE LA MADRE
		      SELECT &cNalias
		      IF lRegLock(lShared,.F.)

			 IF cNalias # 'ADM'
			    REPL &(cNalias+'->cNitCo'+STR(nNroCnt,1)+'Est') WITH cDocNit
			    REPL &(cNalias+'->cTipCo'+STR(nNroCnt,1)+'Est') WITH cTipNit
			 ENDIF

			 REPL &cNalias->cMadLugEst WITH cLugNit

			 REPL &cNalias->lMadFotEst WITH lFotNit

			 REPL &cNalias->cNomMadEst WITH cNombre
			 REPL &cNalias->cApeMadEst WITH cApelli

			 REPL &cNalias->dNacMadEst WITH dFecNac

			 REPL &cNalias->cDirMadEst WITH cDirecc
			 REPL &cNalias->cCiuMadEst WITH cCiuDir
			 REPL &cNalias->cTelMadEst WITH cTelefn

			 REPL &cNalias->cTelMadEst WITH cTelTra
			 REPL &cNalias->cCiuPadEst WITH cCiuTra

			 REPL &cNalias->nEstratEst WITH VAL(cEstrat)
		      ELSE
			  cError('NO SE GRABA EL REGISTRO')
		      ENDIF

		      DBCOMMIT()
		      IF lShared
			 DBUNLOCK()
		      ENDIF
*===================FIN ACTUALIZACION DE LOS DATOS DE LA MADRE

	       CASE nTipPer == 3  // Otra Persona

*===================ACTUALIZACION DE LOS DATOS DE LA PERSONA
		      IF PER->(lRegLock(lShared,lInsPer))

			 REPL PER->nIdeCodPer WITH PER->(RECNO())
			 IF lInsPer
			    REPL PER->cDocNitPer WITH cDocNit
			    REPL PER->cTipNitPer WITH cTipNit
			 ENDIF
			 REPL PER->cLugNitPer WITH cLugNit
			 REPL PER->lFotNitPer WITH lFotNit

			 REPL PER->cApeUnoPer WITH cApeUno
			 REPL PER->cApeDosPer WITH cApeDos
			 REPL PER->cNomUnoPer WITH cNomUno
			 REPL PER->cNomDosPer WITH cNomDos

			 REPL PER->dFecNacPer WITH dFecNac

			 REPL PER->cDireccPer WITH cDirecc
			 REPL PER->cCiudadPer WITH cCiuDir
			 REPL PER->cTelefnPer WITH cTelefn

			 IF EMPTY(cDirEnv) .OR. EMPTY(cCiuEnv)
			    cDirEnv := cDirecc
			    cCiuEnv := cCiuDir
			 ENDIF

			 REPL PER->cDirEnvPer WITH cDirEnv
			 REPL PER->cBarEnvPer WITH cCiuEnv

			 REPL PER->cTelTraPer WITH cTelTra
			 REPL PER->cCiuTraPer WITH cCiuTra

			 REPL PER->cEstratPer WITH cEstrat
			 REPL PER->lSexFemPer WITH lSexFem

		      ENDIF

		      PER->(DBCOMMIT())
		      IF lShared
			 PER->(DBUNLOCK())
		      ENDIF
*===================FIN ACTUALIZACION DE LOS DATOS DE LA PERSONA

	       CASE nTipPer == 0  // Eliminar el Registro
		    // No se requiere ning£n proceso.

	       ENDCASE
	       EXIT
	    ENDIF
**********FIN GRABACION O ACTUALIZACION DEL REGISTRO

       ENDDO
*>>>>FIN LECTURA DE LOS DETALLES DEL CONTRATANTE

*>>>>GRABACION DEL CONTRATANTE
       IF lGrabar

	  SELECT CNT
	  IF nTipPer # 0

*************INCLUSION O ACTUALIZACION DEL CONTRATANTE
	       IF CNT->(lRegLock(lShared,lInsCnt))

		  REPL CNT->cCodigoEst WITH cCodEst
		  REPL CNT->cDocNitPer WITH cDocNit
		  REPL CNT->cTipNitPer WITH cTipNit
		  REPL CNT->nNumeroCnt WITH nNroCnt
		  REPL CNT->cAnoCntCnt WITH cAnoUsr

	       ELSE
		   cError('NO SE GRABA EL REGISTRO')
	       ENDIF

	       CNT->(DBCOMMIT())
	       IF lShared
		  CNT->(DBUNLOCK())
	       ENDIF
*************FIN INCLUSION O ACTUALIZACION DEL CONTRATANTE

	  ELSE

*************ELIMINACION DEL CONTRATANTE
	       cDocNit := '*'
	       IF CNT->(lRegLock(lShared,.F.))

		  SELECT CNT
		  CNT->(DBDELETE())

		  cError('SE ELIMINO EL CONTRATANTE No.'+STR(nNroCnt,1)+' '+;
			 'CON DOCUMENTO No.'+ALLTRIM(cNroNit))
	       ELSE
		  cError('NO SE ELIMINO EL CONTRATANTE No.'+;
			 STR(nNroCnt,1)+' '+;
			 'CON DOCUMENTO No.'+ALLTRIM(cNroNit))
	       ENDIF
*************FIN ELIMINACION DEL CONTRATANTE

	  ENDIF

       ENDIF
       SET ESCAPE OFF
       RETURN cDocNit
*>>>>FIN GRABACION DEL CONTRATANTE