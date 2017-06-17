/*                    SISTEMA CONTABILIDAD ACADEMICA
		BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO LOG


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:00 AM   SEP 26/2002 JUE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaConLog(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'cObservLog','Character',076,0}) // Observaci¢n del Log
       AADD(aDbfStr,{'cMaeActLog','Character',003,0}) // Maestro Actual
       AADD(aDbfStr,{'nNroPerLog','Numeric'  ,001,0}) // N£mero del Periodo

       AADD(aDbfStr,{'cCodigoEst','Character',006,0}) // C¢digo del Estudiante
       AADD(aDbfStr,{'cCodigoGru','Character',004,0}) // C¢digo del Grupo
       AADD(aDbfStr,{'nNroRegEst','Numeric'  ,003,0}) // N£mero del Registro
       AADD(aDbfStr,{'cCodigoPro','Character',006,0}) // C¢digo del Profesor

       AADD(aDbfStr,{'cCodAreSel','Character',002,0})  // C¢digo del Area de la Selecci¢n.
       AADD(aDbfStr,{'cSecMatSel','Character',010,0})  // Secuencial final de la Materia
       AADD(aDbfStr,{'cSecProSel','Character',002,0})  // Secuencial de la Materia del profesor

       AADD(aDbfStr,{'cMatNotLog','Character',004,0}) // Materia en Notas
       AADD(aDbfStr,{'cMatNoPLog','Character',004,0}) // Materia del Profesor

       AADD(aDbfStr,{'cActIndLog','Character'  ,001,0}) // Actualizar Indicadores 1=>SimaCont a SimaProf 2=>SimaProf a SimaCont
       AADD(aDbfStr,{'cIndNotLog','Character',125,0}) // Indicadores en Notas
       AADD(aDbfStr,{'cIndNoPLog','Character',125,0}) // Indicadores en Profesor
       AADD(aDbfStr,{'cIndGraLog','Character',125,0}) // Indicadores en Notas Grabados

       AADD(aDbfStr,{'cActDefLog','Character'  ,001,0}) // Actualizar Definitiva 1=>SimaCont a SimaProf 2=>SimaProf a SimaCont
       AADD(aDbfStr,{'cDefNotLog','Character',022,0}) // Definitivas en Notas
       AADD(aDbfStr,{'cDefNoPLog','Character',004,0}) // Definitiva del Profesor
       AADD(aDbfStr,{'cDefGraLog','Character',022,0}) // Definitivas en Notas Grabadas

       AADD(aDbfStr,{'cActRecLog','Character'  ,001,0}) // Actualizar Recuperaci¢n 1=>SimaCont a SimaProf 2=>SimaProf a SimaCont
       AADD(aDbfStr,{'cRecNotLog','Character',020,0}) // Recuperaciones en Notas
       AADD(aDbfStr,{'cRecNoPLog','Character',004,0}) // Recuperacion en Profesor
       AADD(aDbfStr,{'cRecGraLog','Character',020,0}) // Recuperaciones en Notas Grabadas

       AADD(aDbfStr,{'cNomUsrLog','Character',010,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrLog','Date'     ,008,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrLog','Character',010,0}) // Hora del Usuario
       AADD(aDbfStr,{'cOpcionLog','Character',040,0}) // Opci¢n del Log

       AADD(aDbfStr,{'lRegActLog','Logical'  ,001,0}) // Registro Actualizado
       AADD(aDbfStr,{'cNomArcNot','Character',070,0}) // Nombre del Archivo en Notas
       AADD(aDbfStr,{'cNomArcNop','Character',070,0}) // Nombre del Archivo del Profesor
       AADD(aDbfStr,{'cCamIndNot','Character',015,0}) // Campo destino Juicios
       AADD(aDbfStr,{'cCamIndNoP','Character',015,0}) // Campo Indicadores profesor
       AADD(aDbfStr,{'cCamDefNot','Character',015,0}) // Campo Nota Definitiva en Nota
       AADD(aDbfStr,{'cCamDefNoP','Character',015,0}) // Campo Definitiva profesor
       AADD(aDbfStr,{'cCamRecNot','Character',015,0}) // Campo Recuperaci¢n en Nota
       AADD(aDbfStr,{'cCamRecNoP','Character',015,0}) // Campo Recuperaci¢n profesor
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>VERIFICACION O CREACION DEL DIRECTORIO
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (PathArc) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (PathArc) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathArc)
	    QUIT

       CASE DIRCHANGE(PathArc) == -3
	    DIRMAKE(PathArc)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO

*>>>>CREACION DE LA ESTRUCTURA
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: GRABACION DEL LOG                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:15 AM   SEP 26/2002 JUE

OBJETIVOS:

1- Permite grabar log de actividades

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aGrabarLog(lShared,cNalias,aCamLog,aGenLog,lGraLog)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNalias                              // Alias del Archivo Log
       aCamLog                              // Campos del Log
       aGenLog			            // Campos Generales
       lGraLog                              // .T. Grabar el Log */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                         // Contador
       LOCAL cCamLog := ''                        // Campo del Log
       LOCAL cAliasA := ''                        // Alias Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA GRABACION
       lGraLog := IF(lGraLog == NIL,.T.,lGraLog)
       IF !lGraLog
	  aCamLog := {}
	  RETURN aCamLog
       ENDIF
*>>>>FIN ANALISIS DE LA GRABACION

*>>>>ADICION DE LOS CAMPOS GENERALES
       IF aGenLog # NIL
	  FOR i := 1 TO LEN(aGenLog)
	      AADD(aCamLog,{aGenLog[i,1],aGenLog[i,2]})
	  ENDFOR
       ENDIF
*>>>>FIN ADICION DE LOS CAMPOS GENERALES

*>>>>REGISTRO DE LA FECHA Y HORA
       AADD(aCamLog,{'dFecUsrLog',DATE()})
       AADD(aCamLog,{'cHorUsrLog',TIME()})
*>>>>FIN REGISTRO DE LA FECHA Y HORA

*>>>>GRABACION DEL LOG
       cAliasA := ALIAS(SELECT())
       SELECT &cNalias
       IF lRegLock(lShared,.T.)
	  FOR i := 1 TO LEN(aCamLog)
	      cCamLog := cNalias+'->'+aCamLog[i,1]
	      REPL &cCamLog WITH aCamLog[i,2]
	  ENDFOR
	  DBCOMMIT()
       ELSE
	  cError('NO SE PUEDE GRABAR EL REGISTRO DEL LOG')
       ENDIF
       DBCOMMIT()
       IF lShared
	  DBUNLOCK()
       ENDIF
       aCamLog := {}
       SELECT &cNalias
       RETURN aCamLog
*>>>>FIN GRABACION DEL LOG