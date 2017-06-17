/*                       SIMA - CONTABILIDAD ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION DEL NIVEL

REQUERIMIENTOS:

- Compilar: clipper FContTbl /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de configuraci¢n del nivel JAR,PRI,BTO

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/96 JUE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   SEP 05/96 JUE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaConTbl(lShared,PathTbl,FileTbl,lIntUno,fNtxTbl,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathTbl				    // Path del Archivo
       FileTbl				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxTbl				    // Archivo de Indices
       aStrDbf                              // Structura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfTbl := {}                  // Tabla de Configuraci¢n
       LOCAL GetList := {}                  // Variable del sistema

       AADD(aDbfTbl,{"nTotPerTbl","Numeric"  ,002,0}) // Total de Periodos en el a¤o.
       AADD(aDbfTbl,{"nPerActTbl","Numeric"  ,002,0}) // Periodo Actual
       AADD(aDbfTbl,{"nTipBolTbl","Numeric"  ,002,0}) // Tipo de Boletin
       AADD(aDbfTbl,{"cTipBolTbl","Character",010,0}) // Tipo de Boletin. Tres posiciones por periodo.
       AADD(aDbfTbl,{"nTipLibTbl","Numeric"  ,002,0}) // Tipo de Libro Final.
       AADD(aDbfTbl,{"nTipRecTbl","Numeric"  ,002,0}) // Tipo de Libro Recuperaci¢n.
       AADD(aDbfTbl,{"lHabObsTbl","Logical"  ,001,0}) // .T. Habilitaci¢n como Observaci¢n .F. Observaci¢n en Columna
       AADD(aDbfTbl,{"nTipCerTbl","Numeric"  ,002,0}) // Tipo de Certificado.
       AADD(aDbfTbl,{"nTipConTbl","Numeric"  ,002,0}) // Tipo de Constancia.
       AADD(aDbfTbl,{"lOficioTbl","Logical"  ,001,0}) // Tama¤o del Papel. Carta o Oficio
       AADD(aDbfTbl,{"nLinEspTbl","Numeric"  ,002,0}) // N£mero de l¡neas del encabezado del boletin
       AADD(aDbfTbl,{"nTotLinTbl","Numeric"  ,002,0}) // N£mero de l¡neas del encabezado del boletin
       AADD(aDbfTbl,{"nColEncTbl","Numeric"  ,002,0}) // N£mero de Columnas para el encabezado del Boletin
       AADD(aDbfTbl,{"nColBolTbl","Numeric"  ,002,0}) // N£mero de Columnas para el cuerpo del Boletin
       AADD(aDbfTbl,{"nCo1LibTbl","Numeric"  ,002,0}) // N£mero de Columnas para el encabezado del libro final
       AADD(aDbfTbl,{"nCo2LibTbl","Numeric"  ,002,0}) // N£mero de Columnas para el cuerpo del libro final
       AADD(aDbfTbl,{"lPrnEmpTbl","Logical"  ,001,0}) // .T. Imprimir la Empresa en el Boletin
       AADD(aDbfTbl,{"nMetodoTbl","Numeric"  ,004,1}) // Metodo para los calculos de los promedios. Por defecto 0
       AADD(aDbfTbl,{"cPorcenTbl","Character",008,0}) // Porcentajes de los periodos
       AADD(aDbfTbl,{"nProMinTbl","Numeric"  ,004,1}) // Promedio M¡nimo para Habilitar
       AADD(aDbfTbl,{"nPorNotTbl","Numeric"  ,003,0}) // Factor de Porcentaje para multiplicar las notas
       AADD(aDbfTbl,{"cMinHabTbl","Character",004,0}) // Nota minima para habilitar
       AADD(aDbfTbl,{"nJuiExtTbl","Numeric"  ,002,0}) // N£mero de Logros Extras
       AADD(aDbfTbl,{"cClaIndTbl","Character",009,0}) // Iniciales de la Clase de Indicadores
       AADD(aDbfTbl,{"lNoSortTbl","Logical"  ,001,0}) // .T. Indicadores Ordenados .F. Indicadores Desordenados
       AADD(aDbfTbl,{"lIndNivTbl","Logical"  ,001,0}) // .T. Indicadores de nivel
       AADD(aDbfTbl,{"cEvaIndTbl","Character",007,0}) // Evaluar el Indicador.  Ej: '0000000' (5)Periodos  1:Si  0:No  (£ltimos 00=>No Visualiza XX=>Longitud del nombre a visualizar)
       AADD(aDbfTbl,{"lNotPlaTbl","Logical"  ,001,0}) // .T. Control de Notas desde el Plan Acad‚mico.
       AADD(aDbfTbl,{"cHayNotTbl","Character",005,0}) // Hay notas en el periodo. Ej: '0001' 1:Hay 0:No Hay
       AADD(aDbfTbl,{"cNotNumTbl","Character",005,0}) // Nota N£merica. Ej: '0000'  1:Nota N£merica 0: Nota Cualitativa
       AADD(aDbfTbl,{"cPrnNotTbl","Character",005,0}) // Imprimir la Nota en el Boletin. Ej: '0000'  1:Si  0:No
       AADD(aDbfTbl,{"cPrnVarTbl","Character",005,0}) // Imprimir la Materia Variable o Materia Certificado Ej: '0000'  1:Si  0:No
       AADD(aDbfTbl,{"cNotAcuTbl","Character",010,0}) // Columnas para las Notas Acumuladas
       AADD(aDbfTbl,{"lPrnCodTbl","Logical"  ,001,0}) // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       AADD(aDbfTbl,{"cValNotTbl","Character",010,0}) // Validaci¢n de la Nota Cualitativa. Ej: 10.0 ¢ 'IABE'
       AADD(aDbfTbl,{"cValNumTbl","Character",010,0}) // Validaci¢n de la Nota Cuantitativa. Ej: 10.0
       AADD(aDbfTbl,{"lRecNotTbl","Logical"  ,001,0}) // .T. Recuperar el Juicio Valorativo
       AADD(aDbfTbl,{"nRecPerTbl","Numeric"  ,001,0}) // 0=>No Recuperar 1=>Recuperar sin Borrar 2=>Recuperar Borrando
       AADD(aDbfTbl,{"nAprAutTbl","Numeric"  ,002,0}) // C¢digo de Promoci¢n automatico
       AADD(aDbfTbl,{"cTotAusTbl","Character",005,0}) // Totalizar Ausencias Ej: '0000'  1:Si  No => Diferente de 1
       AADD(aDbfTbl,{"cJvfCalTbl","Character",015,0}) // Juicio Valorativo Calculado. Tres digitos por periodo. 101 =>1:Clase 01:Metodo
       AADD(aDbfTbl,{"cCalHabTbl","Character",003,0}) // Juicio Valorativo Calculado para la Habilitaciones
       AADD(aDbfTbl,{"cReeUnoTbl","Character",020,0}) // Primer reemplazo para el logro de acuerdo a la evaluaci¢n del Indicador
       AADD(aDbfTbl,{"cReeDosTbl","Character",020,0}) // Segundo reemplazo para el logro de acuerdo a la evaluaci¢n del Indicador
       AADD(aDbfTbl,{"nNroDifTbl","Numeric"  ,001,0}) // N£mero de Dificultades asociadas al logro
       AADD(aDbfTbl,{"cUnidadTbl","Character",001,0}) // Unidad de Lectura de los Juicios. Ej: 'A:' ¢ 'B:' por disketes
       AADD(aDbfTbl,{"lPrnAreTbl","Logical"  ,001,0}) // .T. Imprimir las areas de las materias
       AADD(aDbfTbl,{"nPrnAreTbl","Numeric"  ,002,0}) // 0=No imprime areas 1=Areas con materias anidadas 2=Araes+Materias en el mismo reglon
       AADD(aDbfTbl,{"lNegAreTbl","Logical"  ,001,0}) // .T. Imprimir en negrilla el area
       AADD(aDbfTbl,{"dFecRecTbl","Date"     ,008,0}) // Fecha de la acta de recuperaci¢n
       AADD(aDbfTbl,{"cActRecTbl","Character",006,0}) // N£mero de Acta de recuperacion por defecto
       AADD(aDbfTbl,{"cSpaBolTbl","Character",002,0}) // Indentar el Boletin
       AADD(aDbfTbl,{"cTitBolTbl","Character",080,0}) // Titulo Top del Boletin o libro
       AADD(aDbfTbl,{"cTi1BolTbl","Character",080,0}) // Titulo Top del Boletin para periodos
       AADD(aDbfTbl,{"cTi2BolTbl","Character",080,0}) // Titulo Top del Boletin para recuperaciones
       AADD(aDbfTbl,{"cTi3BolTbl","Character",080,0}) // Titulo Top del Boletin informe final
       AADD(aDbfTbl,{"cTi4BolTbl","Character",080,0}) // Titulo Top del Libro
       AADD(aDbfTbl,{"cTitRecTbl","Character",080,0}) // Titulo para las Recuperaciones
       AADD(aDbfTbl,{"cMsgBolTbl","Character",100,0}) // Mensaje para el Boletin
       AADD(aDbfTbl,{"cBolFinTbl","Character",100,0}) // Mensaje para el Informe Final
       AADD(aDbfTbl,{"cMsgLibTbl","Character",100,0}) // Mensaje para el Libro final
       AADD(aDbfTbl,{"cTitReSTbl","Character",108,0}) // T¡tulo para las SI Recuperaciones
       AADD(aDbfTbl,{"cTitReNTbl","Character",108,0}) // T¡tulo para las NO Recuperaciones
       AADD(aDbfTbl,{"cObsBolTbl","Character",060,0}) // Titulo para Observaci¢n del Boletin
       AADD(aDbfTbl,{"cOb1BolTbl","Character",250,0}) // Observaci¢n del Boletin para periodos
       AADD(aDbfTbl,{"cOb2BolTbl","Character",250,0}) // Observaci¢n del Boletin para recuperaciones
       AADD(aDbfTbl,{"cOb3BolTbl","Character",250,0}) // Observaci¢n del Boletin informe final
       AADD(aDbfTbl,{"cOb4BolTbl","Character",250,0}) // Observaci¢n del Libro
       AADD(aDbfTbl,{"cNroMatTbl","Character",020,0}) // N£mero de la Matricula
       AADD(aDbfTbl,{"cCfgBolTbl","Character",010,0}) // Otra Configuraci¢n Boletin:
	    // 1=>Nro de l¡neas
	    // 2=>Caracter Separdor de Materias
	    // 3=>Caracter de Dificultades en SimaProf
	    // 4=>Imprimir los indicadores Recuperados
	    // 5=>Imprimir los Indicadores NO Recuperados
	    // 6=>Imprimir Recuperaciones como Observaciones en Boletines
	    // 7=>N£mero de Firmas
       AADD(aDbfTbl,{"cUrlBolTbl","Character",060,0}) // Url para el Boletin
       AADD(aDbfTbl,{"cLogBolTbl","Character",060,0}) // Logo para el boletin
       AADD(aDbfTbl,{"cUrlFotTbl","Character",060,0}) // Url para la Foto
       AADD(aDbfTbl,{"cExtFotTbl","Character",004,0}) // Extension de la Foto
       AADD(aDbfTbl,{"cTitAreTbl","Character",200,0}) // Titulo del area para el Certificado.
       AADD(aDbfTbl,{"cIndUnoTbl","Character",005,0}) // Pendiente Documentaci¢n. No se para que la utilizo
       AADD(aDbfTbl,{"cIndDosTbl","Character",005,0}) //   ''
       AADD(aDbfTbl,{"cIndTreTbl","Character",005,0}) //   ''
       AADD(aDbfTbl,{"cIndCuaTbl","Character",005,0}) //   ''
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfTbl
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathTbl) == 0
	    DBCREATE(FileTbl,aDbfTbl,"DBFNTX")

       CASE DIRCHANGE(PathTbl) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathTbl)

       CASE DIRCHANGE(PathTbl) == -5
	    cError('NO TIENE DERECHOS EN: '+PathTbl)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathTbl+'\'+FileTbl,'TBL',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO TABLA DEL NIVEL EN CREACION DE ESTRUCTURAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF TBL->(lRegLock(lShared,.T.))
	  REPL TBL->nTotPerTbl WITH 4   // Cuatro periodos
	  REPL TBL->nTipBolTbl WITH 7   // Tipo de Boletin
	  REPL TBL->nTipLibTbl WITH 1   // Tipo de Libro final.
	  REPL TBL->nTipCerTbl WITH 1   // Tipo de Certificado
	  REPL TBL->nTipConTbl WITH 1   // Tipo de Constancia.
	  REPL TBL->lOficioTbl WITH .F. // Por defecto tama¤o carta.
	  REPL TBL->nLinEspTbl WITH 7   // L¡neas en Blanco para el encabezado Boletin
	  REPL TBL->lPrnEmpTbl WITH .F. // No imprimir la Empresa en el encabezado
	  REPL TBL->cPorcenTbl WITH '10203040' // Porcentajes para Boletin con solo notas y juicios
	  REPL TBL->nProMinTbl WITH 2.0 // 7.0 Promedio m¡nimo para habilitar
	  REPL TBL->cMinHabTbl WITH "I" // 4.0 Nota m¡nima para habilitar
	  REPL TBL->lNoSortTbl WITH .F. // .T. Indicadores Ordenados
	  REPL TBL->lIndNivTbl WITH .T. // .T. Indicadores de Nivel
	  REPL TBL->cEvaIndTbl WITH '0000000' // 1=Si 0=No (£ltimos 00=>No Visualiza XX=>Longitud del nombre a visualizar)
	  REPL TBL->cReeUnoTbl WITH 'DIFICULTADES'
	  REPL TBL->cReeDosTbl WITH ''
	  REPL TBL->nNroDifTbl WITH 0   // N£mero de Dificultades asociadas al logro
	  REPL TBL->cUnidadTbl WITH ''  // Lectura por Disco Duro
	  REPL TBL->lNotPlaTbl WITH .F. // .T. Control de Notas por Plan Acad‚mico
	  REPL TBL->cHayNotTbl WITH "00000" // 1=Si 0=No
	  REPL TBL->cNotNumTbl WITH "00000" // 1=N£merica 0=Cualitativa
	  REPL TBL->cValNotTbl WITH "ESAID" // Juicios permitidos
	  REPL TBL->lRecNotTbl WITH .F.     // .T. Permite hacer recuperaciones en el mismo periodo
	  REPL TBL->nRecPerTbl WITH 0       // 0=>No Recuperar 1=>Recuperar no borrar 2=>Recuperar con borrar
	  REPL TBL->cPrnNotTbl WITH "00000" // 1=Imprime la Nota 0=No imprime
	  REPL TBL->cPrnVarTbl WITH '00001' // 1=Imprime Materia Variable o Certificado 0=Materia Variable o SubNivel de acuerdo a la configuraci¢n.
	  REPL TBL->lPrnAreTbl WITH .F. // Imprimir las  reas en el Boletin
	  REPL TBL->lNegAreTbl WITH .F. // .T. Imprimir en Negrilla
	  REPL TBL->lHabObsTbl WITH .T. // .T. Habilitaciontes como Observaciones.
	  REPL TBL->cMsgBolTbl WITH 'ASPECTOS QUE SE OBSERVAN: LOGROS Y DIFICULTADES'
	  REPL TBL->cBolFinTbl WITH 'ASPECTOS QUE SE OBSERVAN: LOGROS Y DIFICULTADES'
	  REPL TBL->cMsgLibTbl WITH 'AREAS O ASIGNATURAS'
	  REPL TBL->cTitRecTbl WITH 'ACTIVIDADES DE RECUPERACION DE:'
	  REPL TBL->cTitBolTbl WITH 'INFORME FINAL'
	  REPL TBL->cTi3BolTbl WITH 'INFORME FINAL'
	  REPL TBL->cCfgBolTbl WITH ' =*'

	  TBL->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA TABLA')
       ENDIF
       IF lShared
	  TBL->(DBUNLOCK())
       ENDIF
       CLOSE TBL
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 17/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:45 AM   MAY 17/96 VIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuConTbl(lShared,PathTbl,FileTbl,lIntUno,fNtxTbl)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathTbl			      // Path del Archivo
       FileTbl			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxTbl			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathTbl+'\'+FileTbl,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE LA TABLA DE NIVEL")
       Termometro(100)

       CreaConTbl(lShared,PathTbl,FileTbl,lIntUno,fNtxTbl)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 04/99 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   NOV 04/99 JUE

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrTbl(lShared,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'TBL',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DE NIVEL')
	  CloseDbf('TBL')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := TBL->(DBSTRUCT())
       CloseDbf('TBL')
       CreaConTbl(lShared,PathArc,cNomArc,,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio .AND. lShared
	  cError('El Archivo CONFIG DE NIVEL su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaConTbl(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/96 JUE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   SEP 05/96 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManConTbl(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL oBrwTbl := NIL                 // Browse de Archivo
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   FConTbl+cMaeAct+ExtFile,'TBL',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL NIVEL DE '+cMaeAct)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwTbl := oDefConTbl(lShared,cAnoUsr,nFilPal+1,00,22,79,cMaeAct)
       SETKEY(K_F9,{||MenuOtrTbl(aParam1,aParam2,aParam3,oBrwTbl)})
       TBL->(CtrlBrw(lShared,oBrwTbl))
       SETKEY(K_F9,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/96 JUE A
       Colombia, Bucaramanga        INICIO: 11:20 AM   SEP 05/96 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefConTbl(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAct                              // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrwTbl := NIL	            // Browse de Clientes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwTbl := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwTbl:ColSep    := '³'
       oBrwTbl:HeadSep   := 'Ä'
       oBrwTbl:Cargo     := {'<< CONFIGURACION DEL NIVEL DE '+;
			     cMaeAct+' >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT TBL
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TOTAL;PERIODOS', {||TBL->nTotPerTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nTotPerTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PERIODO;ACTUAL',{||TBL->nPerActTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nPerActTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO;BOLETIN', {||TBL->nTipBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nTipBolTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO;LIBRO', {||TBL->nTipLibTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nTipLibTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO LIBRO;RECUPERACIONES', {||TBL->nTipRecTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nTipRecTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO;CERTIFICADO', {||TBL->nTipCerTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nTipCerTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO;CONSTANCIA', {||TBL->nTipConTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nTipConTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TAMA¥O;OFICIO', {||TBL->lOficioTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lOficioTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR;EMPRESA', {||TBL->lPrnEmpTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lPrnEmpTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LINEAS DE;ESPACIADO',{||TBL->nLinEspTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nLinEspTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INDENTAR;BOLETIN',{||TBL->cSpaBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cSpaBolTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn       := TBCOLUMNNEW('COL ENCABEZADO;BOLETIN',{||TBL->nColEncTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nColEncTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn       := TBCOLUMNNEW('COL CUERPO;BOLETIN',{||TBL->nColBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nColBolTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn       := TBCOLUMNNEW('COL ENCABEZADO;LIBRO',{||TBL->nCo1LibTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nCo1LibTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn       := TBCOLUMNNEW('COL CUERPO;LIBRO',{||TBL->nCo2LibTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nCo2LibTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF .T.

	  oColumn	:= TBCOLUMNNEW('METODO PARA;LOS CALCULOS',{||TBL->nMetodoTbl})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			    {'FIELD','nMetodoTbl'}, {'PICTURE','99.9'}}
	  oBrwTbl:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	:= TBCOLUMNNEW('PORCENTAJES;PERIODOS',{||TBL->cPorcenTbl})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			    {'FIELD','cPorcenTbl'}, {'PICTURE','99999999'}}
	  oBrwTbl:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	:= TBCOLUMNNEW('PROMEDIO MINIMO;DE RECUPERACION',{||TBL->nProMinTbl})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			    {'FIELD','nProMinTbl'}, {'PICTURE','99.9'}}
	  oBrwTbl:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	:= TBCOLUMNNEW('NOTA MINIMA DE;RECUPERACION',{||TBL->cMinHabTbl})
	  IF '0000' $ TBL->cNotNumTbl
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			       {'FIELD','cMinHabTbl'}, {'PICTURE','AAAA'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			       {'FIELD','cMinHabTbl'}, {'PICTURE','99.9'}}
	  ENDIF
	  oBrwTbl:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	:= TBCOLUMNNEW('PORCENTAJE;PARA LA NOTA',{||TBL->nPorNotTbl})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			    {'FIELD','nPorNotTbl'}, {'PICTURE','999'}}
	  oBrwTbl:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

       ENDIF

       oColumn	     := TBCOLUMNNEW('INDICADORES;DE NIVEL', {||TBL->lIndNivTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lIndNivTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CLASE DE;INDICADORES', {||TBL->cClaIndTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cClaIndTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INDICADORES;ORDENADOS', {||TBL->lNoSortTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lNoSortTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOTAS POR;PLAN ACADEMICO', {||TBL->lNotPlaTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lNotPlaTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HAY NOTAS;DEFINITIVAS', {||TBL->cHayNotTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cHayNotTbl'}, {'PICTURE','99999'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOTA;NUMERICA', {||TBL->cNotNumTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cNotNumTbl'}, {'PICTURE','99999'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR NOTA;DEFINITIVA', {||TBL->cPrnNotTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cPrnNotTbl'}, {'PICTURE','99999'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR MATERIA;VARIABLE', {||TBL->cPrnVarTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cPrnVarTbl'}, {'PICTURE','99999'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOTAS;ACUMULADAS', {||TBL->cNotAcuTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cNotAcuTbl'}, {'PICTURE','@X'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PRN CODIGO;JUICIO', {||TBL->lPrnCodTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lPrnCodTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALIDACION;JUICIOS', {||TBL->cValNotTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cValNotTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALIDACION;NUMERICA', {||TBL->cValNumTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cValNumTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECUPERAR;NOTA', {||TBL->lRecNotTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lRecNotTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECUPERAR;EN PERIODO', {||TBL->nRecPerTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nRecPerTbl'}, {'PICTURE','9'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('EVALUAR;INDICADOR', {||TBL->cEvaIndTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cEvaIndTbl'}, {'PICTURE','9999999'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TOTALIZAR;AUSENCIAS', {||TBL->cTotAusTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTotAusTbl'}, {'PICTURE','99999'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TOTAL;INDICADORES', {||TBL->nJuiExtTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nJuiExtTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('METODO PROMOCION;AUTOMATICA', {||TBL->nAprAutTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nAprAutTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JUICIO VALORATIVO;CALCULADO', {||TBL->cJvfCalTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cJvfCalTbl'}, {'PICTURE','999999999999999'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JUICIO VALORATIVO;CALCULADO HABILITACIONES', {||TBL->cCalHabTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cCalHabTbl'}, {'PICTURE','999'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REEMPLAZO UNO', {||TBL->cReeUnoTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cReeUnoTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REEMPLAZO DOS', {||TBL->cReeDosTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cReeDosTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DIFICULTADES;ASOCIADAS', {||TBL->nNroDifTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nNroDifTbl'}, {'PICTURE','9'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('UNIDAD;DE DISCO', {||TBL->cUnidadTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cUnidadTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MENSAJE BOLETINES PERIODOS', {||TBL->cMsgBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cMsgBolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MENSAJE INFORME FINAL', {||TBL->cBolFinTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cBolFinTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MENSAJE LIBRO FINAL', {||TBL->cMsgLibTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cMsgLibTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR;EL AREA', {||TBL->lPrnAreTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lPrnAreTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR;EL AREA', {||TBL->nPrnAreTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nPrnAreTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR;EN NEGRILLA', {||TBL->lNegAreTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lNegAreTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO DE;LAS RECUPERACIONES',;
				   {||TBL->cTitRecTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTitRecTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECUPERACIONES;COMO OBSERVACIONES',;
				   {||TBL->lHabObsTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','lHabObsTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO PARA;SI RECUPERACIONES',;
				   {||TBL->cTitReSTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTitReSTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO PARA;NO RECUPERACIONES',;
				   {||TBL->cTitReNTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTitReNTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO BOLETIN PERIODOS',{||TBL->cTitBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTitBolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       oColumn	     := TBCOLUMNNEW('TITULO BOLETIN PERIODOS',{||TBL->cTi1BolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTi1BolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn	     := TBCOLUMNNEW('TITULO RECUPERACIONES PERIODOS',{||TBL->cTi2BolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTi2BolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO BOLETINES INFORME FINAL',{||TBL->cTi3BolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTi3BolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO LIBRO FINAL',{||TBL->cTi4BolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTi4BolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION;BOLETIN',{||TBL->cObsBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cObsBolTbl'}, {'PICTURE','@!S60'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION BOLETIN PERIODOS',{||TBL->cOb1BolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cOb1BolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION RECUPERACIONES PERIODOS',{||TBL->cOb2BolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cOb2BolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION BOLETINES INFORME FINAL',{||TBL->cOb3BolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cOb3BolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION LIBRO FINAL',{||TBL->cOb4BolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cOb4BolTbl'}, {'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATRICULA No.;_______',{||TBL->cNroMatTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cNroMatTbl'}, {'PICTURE','@S20'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OTRA CONFIGURACION;1234567890',{||TBL->cCfgBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cCfgBolTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO DEL AREA;PARA EL CERTIFICADO',;
				    {||TBL->cTitAreTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTitAreTbl'},{'PICTURE','@!S76'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('FECHA ACTA;RECUPERACIONES',;
				   {||TBL->dFecRecTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','dFecRecTbl'}, {'PICTURE','@D'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('NUMERO ACTA;RECUPERACIONES',;
				   {||TBL->cActRecTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cActRecTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('URL PARA;EL BOLETIN',{||TBL->cUrlBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cUrlBolTbl'},{'PICTURE','@S60'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LOGO PARA;EL BOLETIN',{||TBL->cLogBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cLogBolTbl'},{'PICTURE','@S60'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('URL PARA;LA FOTO',{||TBL->cUrlFotTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cUrlFotTbl'},{'PICTURE','@S60'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('EXTENSION;DE LA FOTO',{||TBL->cExtFotTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cExtFotTbl'},{'PICTURE','@S04'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TOTAL LINEAS;BOLETIN',{||TBL->nTotLinTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','nTotLinTbl'}, {'PICTURE','99'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO;BOLETIN', {||TBL->cTipBolTbl})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TBL'},;
			 {'FIELD','cTipBolTbl'}, {'PICTURE','@!'}}
       oBrwTbl:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwTbl
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MENU OTROS PROCESOS PARA EL BROWSE DEL ARCHIVO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/2002 MAR A
       Colombia, Bucaramanga        INICIO: 09:30 AM   AGO 20/2002 MAR

OBJETIVOS:

1- Menu de otros procesos para el Browse del Archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrTbl(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'1<TITULO RECUPERACIONES>'}

       aAyuda := {'Titulo para el Control de las Recuperaciones'}

       SAVE SCREEN
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTORE SCREEN
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    TituloRec(aParam1,aParam2,aParam3,oBrowse)
	   *T¡tulo para las Recuperaciones

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: TITULO PARA LAS RECUPERACIONES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/2002 MAR A
       Colombia, Bucaramanga        INICIO: 10:30 AM   AGO 20/2002 MAR

OBJETIVOS:

1- Menu de otros procesos para el Browse del Archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION TituloRec(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>ANALISIS DE DECISION
       IF !EMPTY(TBL->cTitReSTbl) .OR. !EMPTY(TBL->cTitReNTbl)
	  IF !lPregunta('YA EXISTE INFORMACION. DESEA REEMPLAZARLA? No Si')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>GRABACION DE LOS TITULOS PARA EL CONTROL DE RECUPERACIONES
       IF TBL->(lRegLock(lShared,.F.))
	  REPL TBL->cTitReSTbl WITH REPL('-',34)+'<INDICADORES RECUPERADOS '+;
				    'DEL PERIODO NO.#>'+REPL('-',32)

	  REPL TBL->cTitReNTbl WITH REPL('-',33)+'<INDICADORES POR RECUPERAR '+;
				    'DEL PERIODO NO.#>'+REPL('-',33)

	  TBL->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA TABLA')
       ENDIF
       IF lShared
	  TBL->(DBUNLOCK())
       ENDIF
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN GRABACION DE LOS TITULOS PARA EL CONTROL DE RECUPERACIONES

/*************************************************************************
* TITULO..: INTERVALO DE JUICIO VALORATIVO                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2005 VIE A
       Colombia, Bucaramanga        INICIO: 07:45 PM   OCT 14/2005 VIE

OBJETIVOS:

1- Determina si debe exisitr intervalo de equivalencia para los juicios
   valorativos.

2- Retorna .T. si debe existir intervalo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lHayItvTco()

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayItv := .F.                 // .T. Hay Intervalo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF !EMPTY(TCO->cValNotTbl) .AND. !EMPTY(TCO->cValNumTbl)
	  lHayItv := .T.
       ENDIF
       RETURN lHayItv
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: EXISTENCIA DE JUICIO VALORATIVO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2005 VIE A
       Colombia, Bucaramanga        INICIO: 08:10 PM   OCT 14/2005 VIE

OBJETIVOS:

1- Determina si debe existir la descripci¢n de los juicios valorativos.

2- Retorna .T. si debe existir la descripci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lHayJvfTco()

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayJvf := .F.                 // .T. Hay Intervalo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF !EMPTY(TCO->cValNotTbl)
	  lHayJvf := .T.
       ENDIF
       RETURN lHayJvf
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: IMPRIMIR NOTA DEFINITIVA SEGUN PLAN ACADEMICO                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 11/2007 MIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   ABR 11/2007 MIE

OBJETIVOS:

1- Determina si se debe imprimir la nota definitiva de acuerdo a la
   configuraci¢n del plan acad‚mico.

2- Retorna .T. si se debe imprimir la materia.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnNotPla(lPrnMat,cPrnNot,nNroPer)

IF SUBS(TCO->cPrnNotTbl,nNroPer,1) == '2'
   lPrnMat := IF(SUBS(cPrnNot,nNroPer,1) == '1',.T.,.F.)
ENDIF
RETURN lPrnMat
