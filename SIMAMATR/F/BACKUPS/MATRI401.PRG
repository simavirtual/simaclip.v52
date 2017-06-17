/* SIMA - MATRICULA ACADEMICA

MODULO      : CUPOS
SUBMODULO...: CUPOS                  MODULO No. 401

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI401.PRG                                    *
* TITULO DEL PROGRAMA..: ASIGNACION DE CUPOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   FEB 02/96 VIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite grabar las notas parciales de las entrevistas

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_401(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL lPatSis := .F.                 // .T. Incluir Path del Sistema
       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL cAnoAnt := .F.                 // A¤o Anterior
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lNuevos := .F.                 // .T. Matricula para nuevos
       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL nNroCup := 0                   // N£mero de Cupos
       LOCAL nNroNiv := 0                   // N£mero del Nivel

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lSiCupoTes := .F.              // .T. Cupo en el colegio

       LOCAL GetList := {}                  // Variable del Sistema
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
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
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS
       lNuevos := .F.
       IF nLeeOpcion('VA ASIGNAR CUPOS PARA: '+;
		     '1<NUEVOS> 2<ANTIGUOS>?',2,'1') == 1
	  lNuevos := .T.
       ENDIF
*>>>>FIN SELECCION DE ALUMNOS NUEVOS O ANTIGUOS

*>>>>SELECION DEL A¥O ANTERIOR
       IF !lNuevos
	  cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	  cPatAnt := cPatSis
	  cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	  cPatAnt := PathUno+'\'+cPatAnt
       ENDIF
       PathAlu := PathUno+'\'+cPatSis
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lHayErr := .F.
       DO CASE
       CASE lNuevos
	    IF !lUseDbf(.T.,cPatSis+'\'+;
			FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
	       lHayErr := .T.
	    ENDIF

       CASE !lNuevos
	    IF !lUseMaeMtr(lShared,cPatAnt,cMaeAlu,SUBS(cAnoAnt,3,2))
	       lHayErr := .T.
	    ENDIF
       ENDCASE
       IF lHayErr
	  cError("ABRIENDO ARCHIVOS EN "+IF(lNuevos,"NUEVOS","ANTIGUOS"))
	  CLOSE ALL
	  RETURN NIL
       ENDIF

       IF !lUseDbf(.T.,cPatSis+'\'+fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO EMPRESA')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE lNuevos .AND. ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       CASE lNuevos .AND. EMPTY(ANO->cNroCupAno)
	    cError('NO SE HA DEFINIDO LA CANTIDAD DE CUPOS DISPONIBLES')
/*
       CASE !lNuevos .AND. 'JAR' $ cMaeAlu .AND. JAA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoAnt)

       CASE !lNuevos .AND. 'PRI' $ cMaeAlu .AND. PRA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoAnt)

       CASE !lNuevos .AND. 'BTO' $ cMaeAlu .AND. BTA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoAnt)
*/
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS DE LOS '+;
				   'ASPIRANTES CON CUPO EN EL COLEGIO',22,'°')
       nNroCol := 1
       aTamCol := {06,06,40,08,08}
       aTitulo := {'CODIGO','GRUPO ','NOMBRE','CUPO? ','PADRES'}

       IF lNuevos
	  AADD(aTamCol,06)
	  AADD(aTitulo,'CUPOS ')
       ENDIF

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
*	       nNroNiv := VAL(cConverNiv(SUBS(ADM->cCodigoGru,1,2)))
	       nNroNiv := VAL(SUBS(ADM->cCodigoGru,1,2))
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

**********FIN VALIDACION DEL CODIGO

**********VALIDACION DEL CODIGO
	    IF lNuevos
	       DO CASE
	       CASE &cNalias->lRetiroAdm
		    cError(cNombreTes+' ESTA RETIRADO')
		    LOOP

	       CASE ((ANO->lHayExaAno .AND. ANO->lHayEntAno)  .OR.;
		    (!ANO->lHayExaAno .AND. ANO->lHayEntAno)) .AND.;
		     &cNalias->nDefEntAdm == 0

		    cError(cNombreTes+' NO SE LE HA REGISTRADO LA ENTREVISTA')
		    LOOP

	       CASE ANO->lHayExaAno .AND. !ANO->lHayEntAno .AND.;
		    &cNalias->nDefExaAdm == 0

		    cError(cNombreTes+' NO SE LE HA REGISTRADO EL EXAMEN')
		    LOOP

	       CASE ANO->lHayExaAno .AND. !ANO->lHayEntAno .AND.;
		    !(&cNalias->lExamenAdm)

		    cError(cNombreTes+' NO APROBO LA EVALUACION')
		    LOOP
	       ENDCASE

	    ELSE
	       DO CASE
	       CASE &cNalias->lRetiroEst
/*
		    cError(cNombreTes+' ESTA RETIRADO')
		    LOOP
*/
	       ENDCASE
	    ENDIF

/*
	    IF EMPTY(&cNalias->dFecNacEst) .AND. EMPTY(&cNalias->cLugNacEst) .AND.;
	       ANO->lMtrResAno

	       cError(cNombreTes+' LE FALTA REGISTRARLE SUS DATOS PERSONALES')
	       LOOP
	    ENDIF
*/
**********FIN VALIDACION DEL CODIGO

**********IMPRESION DE LA LINEA DE ESTADO
	     IF ANO->lHayExaAno .OR. ANO->lHayEntAno
		LineaEstado('<F2>INFORMACION PERSONAL'+;
		     IF(lNuevos,'. <F3>RESULTADOS <F4>CUPOS',''),cNomSis)
	     ELSE
		LineaEstado('<F2>INFORMACION PERSONAL'+;
		     IF(lNuevos,'. <F4>CUPOS',''),cNomSis)
	     ENDIF
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LECTURA DE LOS CUPOS DISPONIBLES
	    IF lNuevos
	       nNroCup := VAL(SUBS(ANO->cNroCupAno,(nNroNiv+1)*4-3,4))
	       IF nNroCup == 0 .AND. !&cNalias->lSiCupoEst
		  cError(cNombreTes+ ' VA PARA '+cNomNiv(STR(nNroNiv,2))+;
			 ' Y NO HAY CUPOS')
		  LOOP
	       ENDIF
	       @ nNroFil,aNroCol[6] SAY nNroCup PICT '9999'
	    ENDIF
**********FIN LECTURA DE LOS CUPOS DISPONIBLES

**********LECTURA CUPO
	    SETKEY(K_F2,{||InfoAlu(nFilPal,1,cNalias,cNomEmp,cNomSis)})
	    IF lNuevos
	       IF ANO->lHayExaAno .OR. ANO->lHayEntAno
		  SETKEY(K_F3,{||ResultaAlu(nFilPal,1,cNomEmp,cNomSis,;
					    ANO->lHayExaAno,;
					    ANO->lHayEntAno)})
	       ENDIF
	       SETKEY(K_F4,{||CuposDispi(lShared,cNomEmp,;
					 cNomSis,nFilPal,cMaeAlu)})
	    ENDIF
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes

	    IF lNuevos
	       @ nNroFil,aNroCol[5] SAY IF(ADM->lExAlumAdm,'EXALUMNO','')
	    ENDIF

	    @ nNroFil,aNroCol[4] SAY IF(&cNalias->lSiCupoEst,'SI','NO')
	    lSiCupoTes := .F.
	    IF lPregunta('Si No',nNroFil,aNroCol[4]+3)
	       lSiCupoTes := .T.
	    ENDIF
	    @ nNroFil,aNroCol[4] SAY IF(lSiCupoTes,'SI','NO')
	    SETKEY(K_F2,NIL)
	    IF lNuevos
	       SETKEY(K_F3,NIL)
	       SETKEY(K_F4,NIL)
	    ENDIF
**********FIN LECTURA CUPO

**********IMPRESION DE LA LINEA DE ESTADO
	     LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DEL  CUPO ASIGNADO
	    IF lNuevos
	       IF ADM->lSiCupoEst
		  IF !lSiCupoTes
		     nNroCup++
		    *Cancelaci¢n del cupo
		  ENDIF
	       ELSE
		  IF lSiCupoTes
		     nNroCup--
		    *Asignado el cupo
		  ENDIF
	       ENDIF
	       nNroCup := STR(nNroCup,4)
	    ENDIF
**********FIN ANALISIS DEL  CUPO ASIGNADO

**********GRABACION DEL NUMERO DE CUPOS
	    IF lNuevos
	       IF ANO->(lRegLock(lShared,.F.))

		  REPL ANO->cNroCupAno WITH STUFF(ANO->cNroCupAno,;
						  (nNroNiv+1)*4-3,4,nNroCup)
		  ANO->(DBCOMMIT())

	       ELSE
		  cError('NO SE GRABAN LOS CUPOS PARA JARDIN')
	       ENDIF
	       IF lShared
		  ANO->(DBUNLOCK())
	       ENDIF
	       @ nNroFil,aNroCol[6] SAY nNroCup
	    ENDIF
**********FIN GRABACION DEL NUMERO DE CUPOS

**********GRABACION DEL CUPO
	    SELECT &cNalias
	    IF lRegLock(lShared,.F.)
	       REPL &cNalias->lSiCupoEst WITH lSiCupoTes
	    ELSE
		cError('NO SE GRABA EL CUPO')
	    ENDIF
	    DBCOMMIT()
	    IF lShared
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DEL CUPO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
			    'DE LOS ASPIRANTES CON CUPO EN EL COLEGIO',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 @ nNroFil,aNroCol[4] SAY IF(lSiCupoTes,'SI','NO')

		 IF lNuevos
		    @ nNroFil,aNroCol[5] SAY IF(ADM->lExAlumAdm,'EXALUMNO','')
		    @ nNroFil,aNroCol[6] SAY nNroCup
		 ENDIF
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS RESULTADOS                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   FEB 02/96 VIE

OBJETIVOS:

1)- Debe estar en uso el archivo de admisiones en el registro del aspirante

2)- Visualiza la informaci¢n los resultados de entrevista y examen

3)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ResultaAlu(nFilInf,nColInf,cNomEmp,cNomSis,lHayExa,lHayEnt)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilInf                              // Fila de Impresi¢n
       nColInf                              // Columna de Impresi¢n
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       lHayExa                              // .T. Hay Examenes
       lHayEnt                              // .T. Hay Entrevistas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cNotas  := ''                  // Notas
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LA LINEA DE ESTADO
       cSavPan := SAVESCREEN(0,0,24,79)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,'RESULTADOS',22,'°')
       nNroCol := nColInf
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+ADM->cNumeroAdm
       @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+RTRIM(ADM->cNombreEst)+' '+;
					   ADM->cApelliEst
       @ nNroFil,nNroCol+65 SAY 'CURSO : '+ADM->cCodigoGru
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>IMPRESION ENCABEZADOS DEL EXAMEN
       IF lHayExa
	  nNroFil+=2
	  @ nNroFil++,nNroCol SAY 'RESULTADOS DEL EXAMEN'

	  FOR i := 1 TO ANO->nNroExaAno
	      @ nNroFil,nNroCol SAY 'NOT'+IF(i<10,STR(i,1),STR(i,2))
	      nNroCol += 5
	  NEXT
	  @ nNroFil++,nNroCol+1 SAY 'DEFINITIVA'
       ENDIF
*>>>>FIN IMPRESION ENCABEZADOS DEL EXAMEN

*>>>>IMPRESION RESULTADOS DEL EXAMEN
       IF lHayExa
	  cNotas  := SUBS(ADM->cNotExaAdm,1,ANO->nNroExaAno*4)
	  nNroCol := nColInf
	  SET COLOR TO I
	  FOR i=1 TO ANO->nNroExaAno
	     @ nNroFil,nNroCol SAY SUBS(cNotas,i*4-3,4)
	     nNroCol += 5
	  NEXT
	  @ nNroFil++,nNroCol+1 SAY ADM->nDefExaAdm
	  SET COLOR TO
       ENDIF
*>>>>FIN IMPRESION RESULTADOS DEL EXAMEN

*>>>>IMPRESION ENCABEZADOS DE LA ENTREVISTA
       IF lHayEnt
	  nNroFil+=2
	  nNroCol := nColInf
	  @ nNroFil++,nNroCol SAY 'RESULTADOS DE LA ENTREVISTA'

	  FOR i := 1 TO ANO->nNroEntAno
	      @ nNroFil,nNroCol SAY 'NOT'+IF(i<10,STR(i,1),STR(i,2))
	      nNroCol += 5
	  NEXT
	  @ nNroFil++,nNroCol+1 SAY 'DEFINITIVA'
       ENDIF
*>>>>FIN IMPRESION ENCABEZADOS DEL ENTREVISTA

*>>>>IMPRESION RESULTADOS DEL ENTREVISTA
       IF lHayEnt
	  cNotas  := SUBS(ADM->cNotEntAdm,1,ANO->nNroEntAno*4)
	  nNroCol := nColInf
	  SET COLOR TO I
	  FOR i=1 TO ANO->nNroEntAno
	     @ nNroFil,nNroCol SAY SUBS(cNotas,i*4-3,4)
	     nNroCol += 5
	  NEXT
	  @ nNroFil++,nNroCol+1 SAY ADM->nDefEntAdm
	  SET COLOR TO
       ENDIF

       cPausa()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION RESULTADOS DEL ENTREVISTA