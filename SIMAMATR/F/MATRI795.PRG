/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: MEZCLAR GRUPOS                           MODULO No. 661

**************************************************************************
* TITULO..: MEZCLAR LOS GRUPOS DE LOS ESTUDIANTES                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 05/97 DOM A
       Colombia, Bucaramanga        INICIO: 04:25 PM   ENE 05/97 DOM


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Cambia de grupo a los estudiantes en forma a la aleatoria

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_795(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL  cOrden := ''                  // Orden de Ejecutar
       LOCAL       i := 0                   // Contador
       LOCAL       k := 0                   // Contador
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cNueGru := ''                  // Nuevo Grupo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       FIELD cCodigoGru                     // C¢digo del Grupo
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

*>>>>LECTURA DEL COMANDO DE EJECUCION
       SET FIXED OFF

       cSavPan := SAVESCREEN(0,0,24,79)
       cOrden := SPACE(10)
       @ nFilInf+1,nColInf SAY 'ORDEN: ' GET cOrden PICT "@!"
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(cOrden) .OR. UPPER(cOrden) # 'MEZCLAR'
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL COMANDO DE EJECUCION

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL


*>>>>SELECCION DE LAS AREAS DE TRABAJO
       lShared := .F.
       IF !lUseNiv(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)

	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct

       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES MATRICULADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

CloseAll()
RETURN NIL

*>>>>ANALISIS DE DECISION
       IF lPregunta('DESEA MEZCLAR LOS GRUPOS DE LOS ESTUDIANTES? No Si')

	  cError('SE RECOMIENDA HACER COPIA DE RESPALDO '+;
		 'ANTES DE MEZCLAR GRUPOS')

	  IF !lPregunta('¨ESTA SEGURO DE MEZCLAR LOS GRUPOS '+;
			'DE LOS ESTUDIANTES? No Si')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ELSE
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       IF !lPregunta('SE VAN A MEZCLAR LOS GRUPOS. DESEA CONTINUAR? No Si')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>PREPARACION DE LOS ARCHIVOS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'PREPARANDO ARCHIVOS')
       Termometro(10)

       SELECT &cMaeAct
       REPL ALL lGrupOkEst WITH .F.
       GO TOP
       Termometro(50)

       SELECT GRU
       REPL ALL GRU->nNroAluGru WITH 0
       GO TOP
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN PREPARACION DE LOS ARCHIVOS

*>>>>ASIGNACION DE LOS GRUPOS POR NIVELES
       SELECT NIV
       GO TOP
       DO WHILE .NOT. NIV->(EOF())

**********ASIGNACION DE LOS GRUPOS
	    FOR i := 0 TO NIV->nNroGruNiv

*---------------FILTRACION DEL MAESTRO
		  cCodigoTgr := NIV->cCodigoNiv+PADL(i,2,'0')

		  SELECT &cMaeAct
		  SET FILTER TO cCodigoGru == cCodigoTgr
		  GO TOP
		  IF EOF()
*		     cError('NO EXISTEN ESTUDIANTES PARA EL GRUPO '+;
*			    cCodigoTgr)
		     LOOP
		  ENDIF
*---------------FIN FILTRACION DEL MAESTRO

*---------------CAMBIO DE LOS GRUPOS EN LOS ESTUDIANTES
		  SELECT &cMaeAct
		  GO TOP
		  k := 1
		  nNroFil := nMarco(nFilPal+1,'ASIGNACION DE GRUPOS',22,' ')
		  DO WHILE .NOT. EOF()

*                    VALIDACION DEL ESTUDIANTE
		       cNombreTes := ALLTRIM(&cMaeAct->cApelliEst)+' '+;
					     &cMaeAct->cNombreEst
		       cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		       cCodigoTgr := &cMaeAct->cCodigoGru

		       DO CASE
		       CASE &cMaeAct->lRetiroEst

			    SELECT &cMaeAct
			    DBSKIP()
			    LOOP

		       CASE &cMaeAct->lGrupOkEst

			    SELECT &cMaeAct
			    DBSKIP()
			    LOOP

		       ENDCASE
*                    FIN VALIDACION DEL ESTUDIANTE

*                    GRABACION DEL NUEVO GRUPO
		       SELECT &cMaeAct
		       IF lRegLock(lShared,.F.)
			  cNueGru := cNuevoGru(NIV->nNroGruNiv,;
					       &cMaeAct->cCodigoGru,@k)

			  REPL &cMaeAct->cCodigoGru WITH cNueGru
			  REPL &cMaeAct->lGrupOkEst WITH .T.

			  IF k > NIV->nNroGruNiv
			     k := 1
			  ENDIF

			  DBCOMMIT()
		       ELSE
			  cError("NO SE GRABA EL CONTROL DE MATRICULA ")
		       ENDIF
		       IF lShared
			  DBUNLOCK()
		       ENDIF
*                    FIN GRABACION DEL NUEVO GRUPO

*                    ACUMULACION DEL TOTAL DE ALUMNOS
		       IF lLocCodigo('cCodigoGru','GRU',cNueGru)
			  IF GRU->(lRegLock(lShared,.F.))
			     REPL GRU->nNroAluGru WITH GRU->nNroAluGru+1
			     GRU->(DBCOMMIT())
			  ELSE
			     cError('NO SE GRABA EL REGISTRO DEL GRUPO')
			  ENDIF
			  IF lShared
			     GRU->(DBUNLOCK())
			  ENDIF
		       ENDIF
*                    FIN ACUMULACION DEL TOTAL DE ALUMNOS

*                    INCREMENTO DE LAS FILAS
		       @ nNroFil,nNroCol SAY cNombreTes+' DEL GRUPO: '+;
					     cCodigoTgr+' PASA AL GRUPO: '+;
					     cNueGru
		       nNroFil++
		       IF nNroFil > 19
			  nNroFil := nMarco(nFilPal+1,;
					    'ASIGNACION DE GRUPOS',22,' ')
		       ENDIF
*                    FIN INCREMENTO DE LAS FILAS

		     SELECT &cMaeAct
		     DBSKIP()

		  ENDDO
*---------------FIN CAMBIO DE LOS GRUPOS EN LOS ESTUDIANTES

	    ENDFOR
**********FIN ASIGNACION DE LOS GRUPOS

	  SELECT NIV
	  DBSKIP()

       ENDDO
       SELECT &cMaeAct
       SET FILTER TO
       CLOSE ALL
       SET FIXED ON
       RETURN NIL
*>>>>ASIGNACION DE LOS GRUPOS POR NIVELES

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: ASIGNACION DEL NUEVO GRUPO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 05/97 DOM A
       Colombia, Bucaramanga        INICIO: 05:05 PM   ENE 05/97 DOM

OBJETIVOS:

1- Asigna un nuevo grupo al estudiante

2- Retorna el nuevo grupo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNuevoGru(nTotGru,cCodGru,nNroGru)

*>>>>PARAMETROS DE LA FUNCION
/*     nTotGru                              // Total de Grupos
       cCodGru                              // C¢digo del grupo a cambiar
       nNroGru                              // @N£mero secuencial del grupo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNueGru := ''                  // Nuevo Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS PARA LA ASIGNACION DEL GRUPO
       DO CASE
       CASE nNroGru < nTotGru
	    IF VAL(SUBS(cCodGru,3,2)) == nNroGru
	       cNueGru := SUBS(cCodGru,1,2)+;
			  PADL(VAL(SUBS(cCodGru,3,2))+1,2,'0')
	       nNroGru := nNroGru+2
	    ELSE
	       cNueGru := SUBS(cCodGru,1,2)+;
			  PADL(nNroGru,2,'0')
	       nNroGru++
	    ENDIF

       CASE nNroGru == nTotGru
	    IF VAL(SUBS(cCodGru,3,2)) == nNroGru
	       cNueGru := SUBS(cCodGru,1,2)+;
			  PADL(VAL(SUBS(cCodGru,3,2))-1,2,'0')
	       nNroGru++
	    ELSE
	       cNueGru := SUBS(cCodGru,1,2)+;
			  PADL(nNroGru,2,'0')
	       nNroGru++
	    ENDIF
       ENDCASE
       RETURN cNueGru
*>>>>FIN ANALISIS PARA LA ASIGNACION DEL GRUPO