/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: SIMAVIRTUAL - LISTAS

**************************************************************************
* TITULO..: LISTAS                                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 08/2006 MIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   FEB 08/2006 MIE

OBJETIVOS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_792(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL aMaeAct := {}                  // Dbfs de MaeAct
       LOCAL PathSql := ''                  // Path del Sql
       LOCAL lSiorNo := .F.                 // Control de flujo

       LOCAL cRegTxt := {}                  // Registro de Texto
       LOCAL aRegTxt := {}                  // Registros de Texto

       MEMVA xClrSys			    // Color del Sistema
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
       IF  !lParam0102(aParams,;
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>AREAS DE TRABAJO
       aMaeAct := {}
       AADD(aMaeAct,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aMaeAct)
	  cError('ABRIENDO EL ARCHIVO DE '+UPPER(cMaeAct))
	  CloseAll(aMaeAct)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDOS POR GRUPOS
       PathSql := cPatSis+'\FILEWWW'

       cRegTxt := 'copy '

       SELECT GRU
       GRU->(DBGOTO(nRegIni))
       DO WHILE GRU->(RECNO()) <= nRegFin

	  FileNot := 'NT'+GRU->cCodigoGru+cAnoSis+ExtFile

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			    FileNot,'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	      CloseAll()
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO POR NOTAS
	    SELECT NOT
	    NOT->(DBGOTOP())
	    DO WHILE .NOT. NOT->(EOF())

*==============IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+;
			     'ºNo. '+STR(NOT->(RECNO()),2)+'/'+;
				     STR(NOT->(RECCOUNT()),2),cNomSis)
*==============FIN IMPRESION DE LA LINEA DE ESTADO

*==============ASIGNACION DEL NUMERO DE LISTA
		 IF NOT->(lRegLock(lShared,.F.))
		    REPL NOT->nNroLisEst WITH NOT->(RECNO())
		    NOT->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABA EL REGISTRO')
		 ENDIF

		 IF lShared
		    NOT->(DBUNLOCK())
		 ENDIF
*==============FIN ASIGNACION DEL NUMERO DE LISTA

	       NOT->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR NOTAS

**********TABLA DE NOTAS
	    aDbfStr := {}
	    AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
	    AADD(aDbfStr,{"cCodigoEst","Character",06,0}) // C¢digo del Estudiante.
	    AADD(aDbfStr,{"cCodigoGru","Character",04,0,GRU->cCodigoGru}) // C¢digo del Grupo
	    AADD(aDbfStr,{"nNroLisEst","Numeric"  ,03,0}) // N£mero de lista
	    AADD(aDbfStr,{"lRetGruNot","Logical"  ,01,0}) // .T. Retiro del Grupo
	  *ÀCampos

	    fSqlIns(PathSql,FileNot,'listas',;
		    cCamLecIns(aDbfStr),aDbfStr,'NOT')
	  *ÀDatos

	    IF lSiorNo
	       cRegTxt += '+'
	    ENDIF
	    cRegTxt += SUBS(FileNot,1,AT('.',FileNot)-1)+'.sqr'
	    lSiorNo := .T.
**********FIN TABLA DE NOTAS

	  GRU->(DBSKIP())

       ENDDO
       CloseAll()
*>>>>FIN RECORRIDOS POR GRUPOS

*>>>>CREACION DEL ARCHIVO .BAT
       cRegTxt += ' lista'+LOWER(cMaeAct)+'.sql'
       aRegTxt := {}
       AADD(aRegTxt,{cRegTxt})

       FileChr(PathSql+'\lista'+LOWER(cMaeAct)+'.bat',aRegTxt)
       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO .BAT
