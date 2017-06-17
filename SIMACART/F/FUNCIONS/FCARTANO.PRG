/*                       SIMA - CARTERA ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION CART19xx

REQUERIMIENTOS:

- Compilar: clipper FCartAno /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:05 PM   SEP 26/96 JUE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaCarAno(lShared,nModCry,PathCaA,FileCaA,fNtxCaA,lGrabar,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCaA				    // Path del Archivo
       FileCaA				    // Nombre del Archivo
       fNtxCaA				    // Archivo de Indices
       lGrabar                              // Grabar parametros
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfCaA := {{"cIntUnoCaA","Character",70,0},; // Path de Integraci¢n No. 1
			 {"cIntDosCaA","Character",70,0},; // Path de Integraci¢n No. 2
			 {"cIntTreCaA","Character",70,0},; // Path de Integraci¢n No. 3
			 {"cIntCuaCaA","Character",70,0},; // Path de Integraci¢n No. 4
			 {"cIntCafCaA","Character",70,0},; // Path de Integraci¢n para la Cafeteria
			 {"cIntRutCaA","Character",70,0},; // Path de Integraci¢n para la Rutas
			 {"cIntScoCaA","Character",70,0},; // Path de Integraci¢n para el SimaCont Principal
			 {"cIntMtrCaA","Character",70,0},; // Path de Integraci¢n para el SimaMatr Principal
			 {"cMaeHabCaA","Character",09,0},; //* Maestros Habilitados para el A¤o
			 {"cJorHabCaA","Character",04,0},; //* Jornadas Habilitadas
			 {"lHayCliCaA","Logical"  ,01,0},; // .T. Hay Clientes
			 {"lRevisaCaA","Logical"  ,01,0},; // .T. Revisar Clientes
			 {"nRecNroCaA","Numeric"  ,02,0},; // Clase de Recibo identificado por c¢digo
			 {"nOtrRecCaA","Numeric"  ,02,0},; // Clase de Recibo para otra facturaci¢n
			 {"nRecPazCaA","Numeric"  ,02,0},; // Tipo de Recibo para el paz y salvo
			 {"nMesActCaA","Numeric"  ,02,0},; // Mes Actual de la facturaci¢n.
			 {"nMesIniCaA","Numeric"  ,02,0},; // Mes Inicial del Recibo
			 {"nMesFinCaA","Numeric"  ,02,0},; // Mes Final del Recibo. 11 Noviembre
			 {"cCodigoBan","Character",02,0},; // C¢digo del Banco por defecto para el pago
			 {"cConPenCaA","Character",14,0},; // Conceptos de Pension por defecto para el pago
			 {"cConMatCaA","Character",28,0},; // Conceptos de la Matricula para el Certificado
			 {"cConPrnCaA","Character",32,0},; //*Conceptos a imprimir en los reportes
			 {"lIntPenCaA","Logical"  ,01,0},; // .T. Utilizar interes por mora y no valor de recargo para lo no pagos o pagos extemporaneos
			 {"nIntPenCaA","Numeric"  ,05,2},; // Intereses por mora para la pensi¢n extemporaneo
			 {"nIntDeuCaA","Numeric"  ,05,2},; // Interes por Mora para el no pago
			 {"nVlrMorCaA","Numeric"  ,10,2},; // Valor recargo por pago extemporaneo
			 {"nVlrDeuCaA","Numeric"  ,10,2},; // Valor recargo por no pago
			 {"lForPagCaA","Logical"  ,01,0},; // .T. Habilitar la forma de pago. Por Caja, Por Banco, Por Tarjeta de Cr‚dito, Etc.
			 {"lNomConDes","Logical"  ,01,0},; // .T. Habilitar el Concepto para Descuentos y Recargos en la facturaci¢n
			 {"dOpoPenCaA","Date"     ,08,0},; // Fecha para pago oportuno
			 {"dExtPenCaA","Date"     ,08,0},; // Fecha para pago extemparane.
			 {"dFecRecCaA","Date"     ,08,0},; // Fecha para el recibo.
			 {"lLeeFecCaA","Logical"  ,01,0},; // .T. Leer Fecha de pago .F. Leer forma de pago
			 {"lPrnFecCaA","Logical"  ,01,0},; // .T. Informes por Fecha.
			 {"lPrnConCaA","Logical"  ,01,0},; // .T. Informes Discriminados por Conceptps.
			 {"lPagExtCaA","Logical"  ,01,0},; // Visualizar Fecha Extemporanea
			 {"cMensajCaA","Character",100,0},; // Mensaje para la facturaci¢n
			 {"cTxtUnoCaA","Character",300,0},; // Texto Uno para la Facturaci¢n
			 {"cTxtDosCaA","Character",300,0},; // Texto Dos para la Facturaci¢n
			 {"cCodeQrCaA","Character",250,0},; // C¢digo QR para el recibo.
			 {"lPrePrnCaA","Logical"  ,01,0},; // .T. Imprimir Forma Preimpresa
			 {"nNomFacCaA","Numeric"  ,01,0},; // C¢digo del Nombre de la Factura 0=>Alumno 1=>Alumno/Padre 2=>Alumno/Madre 3=>Alumno/Acudiente 4=>Padre 5=>Madre 6=>Acudiente
			 {"nNomRepCaA","Numeric"  ,01,0},; // Nombre a Reportar. 0=>No Reportar 1=>Padre,Madre o Acudiente, 2=>Fiador Uno 3=>Fiador Dos
			 {"nNroFacCaA","Numeric"  ,12,0},; // N£mero Consecutivo de la Factura
			 {"nRutEstCaA","Numeric"  ,01,0},; // Rutas por Estudiante
			 {"lHayNroCaA","Logical"  ,01,0},; // .T. Controlar N£mero Consecutivo
			 {"nMesAmnCaA","Numeric"  ,02,0},; // Mes de Amnist¡a para la facturaci¢n
			 {"nDesGenCaA","Numeric"  ,10,2},; // Valor Descuento para aplicar general
			 {"nRecGenCaA","Numeric"  ,10,2},; // Valor Recargo para aplica general
			 {"cConGenCaA","Character",02,0},; // C¢digo del concepto para el descuento o recargo general
			 {"cAnoMtrCaA","Character",04,0},; // A¤o para procesar las matr¡culas
			 {"cCodPazCaA","Character",40,0},; // C¢digo de Item de Paz y Salvo
			 {"cAnoAluCaA","Character",04,0},; // A¤o para el Maestro de Estudiantes
			 {"cValConCaA","Character",14,0},; // Validaci¢n de la Contabilidad
			 {"nDiaConCaA","Numeric"  ,02,0},; // D¡a para conciliar la contabilidad.
			 {"nMtdFacCaA","Numeric"  ,02,0},; // M‚todo de facturaci¢n. 0=Por defecto. 1=Virrey 2010. 2=Tabla de Tarifas por meses.
			 {"nMtdSdoCaA","Numeric"  ,02,0},; // M‚todo para el c lculo de Saldos. 00=Por defecto se acumala el saldo. 98=No se acumula saldo por no pago.
			 {"nDiaMorCaA","Numeric"  ,03,0},; // D¡as en Mora para Bloquear estudiantes
			 {"nImpIcaCaA","Numeric"  ,05,2}}  // Porcentaje Impuesto del Ica
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfCaA
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCaA) == 0
	    DBCREATE(FileCaA,aDbfCaA,"DBFNTX")
	    Proteger(FileCaA,nModCry)

       CASE DIRCHANGE(PathCaA) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCaA)

       CASE DIRCHANGE(PathCaA) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCaA)
       ENDCASE

       DIRCHANGE(PathAct)
       lGrabar := IF(lGrabar == NIL,.T.,lGrabar)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF lGrabar
	  IF !lUseDbf(.T.,PathCaA+'\'+FileCaA,'CAA',NIL,lShared,nModCry)
	     cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	     CloseDbf('CAA',PathCaA+'\'+FileCaA,nModCry)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF lGrabar
	  IF CAA->(lRegLock(lShared,.T.))
	     REPL CAA->lPrePrnCaA WITH .F.  // .T. Imprimir Forma Preimpresa
	     REPL CAA->lHayCliCaA WITH .F.  // .T. Ya Creados los Clientes
	     REPL CAA->lRevisaCaA WITH .F.  // .T. Actualizar Estudiantes
	     REPL CAA->cMensajCaA WITH 'RECONSTRUYENDO EL PRESENTE PARA '+;
				       'LA SOCIEDAD DEL FUTURO'
	     REPL CAA->cIntUnoCaA WITH '\Sima\SimaCont'
	     REPL CAA->cIntDosCaA WITH '\Sima\SimaMatr'
	     REPL CAA->cIntTreCaA WITH '\Sima\SimaCafe'
	     REPL CAA->cIntCuaCaA WITH '\Sima\SimaData'
	     REPL CAA->nMesIniCaA WITH 2    // Nomviebre mes inicial de facturaci¢n
	     REPL CAA->nMesFinCaA WITH 11   // Nomviebre mes final de facturaci¢n
	     REPL CAA->nRecNroCaA WITH 01   // Tipo de Recibo para facturar
	     REPL CAA->nOtrRecCaA WITH 01   // Clase de Recibo para otra facturaci¢n
	     REPL CAA->nRecPazCaA WITH 01   // Tipo de Recibo para Paz y Salvo
	     REPL CAA->lPrePrnCaA WITH .F.  // Imprimir recibo todo impreso
	     REPL CAA->lLeeFecCaA WITH .T.  // .F. Leer forma de pago.
	     REPL CAA->lPrnFecCaA WITH .F.  // .T. Informes por Fecha
	     REPL CAA->lPrnConCaA WITH .F.  // * .T. Informes por Conceptos
	     REPL CAA->lPagExtCaA WITH .T.  // Visualizar Fecha Extemporanea
	     REPL CAA->nNroFacCaA WITH 0    // N£mero Consecutivo en Cero
	     REPL CAA->lHayNroCaA WITH .F.  // No controlar consecutivo
	     REPL CAA->lIntPenCaA WITH .T.  // .T. Interes por mora .F. Valor por Mora
	     REPL CAA->lForPagCaA WITH .F.  // .T. Habilitar la forma de pago. Por Caja, Por Banco, Por Tarjeta de Cr‚dito, Etc.
	     REPL CAA->lNomConDes WITH .F.  // .T. Habilitar el Concepto para Descuentos y Recargos en la facturaci¢n

	     REPL CAA->nVlrMorCaA WITH 0    // Valor por mora
	     REPL CAA->nDesGenCaA WITH 0    // Descuento General a aplicar
	     REPL CAA->nRecGenCaA WITH 0    // Recargo General a aplicar
	     REPL CAA->cConGenCaA WITH ''   // Concepto General

	     CAA->(DBCOMMIT())
	     IF lShared
		CAA->(DBUNLOCK())
	     ENDIF
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	  ENDIF
       ENDIF
       CloseDbf('CAA',PathCaA+'\'+FileCaA,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:25 PM   SEP 26/96 JUE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuCarAno(lShared,nModCry,PathCaA,FileCaA,fNtxCaA)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathCaA			      // Path del Archivo
       FileCaA			      // Nombre del Archivo
       fNtxCaA			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCaA+'\'+FileCaA,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DEL A¥O")
       Termometro(100)

       CreaCarAno(lShared,nModCry,PathCaA,FileCaA,fNtxCaA)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/99 VIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   AGO 13/99 VIE

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

FUNCTION nActStrAno(lShared,nModCry,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ANO',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION GENERAL')
	  CloseDbf('ANO',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ANO->(DBSTRUCT())
       CloseDbf('ANO',PathArc+'\'+cNomArc,nModCry)
       CreaCarAno(lShared,nModCry,PathArc,cNomArc,,.F.,@aStrNew)
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
       IF lCambio
	  cError('El Archivo CONFIG DEL A¥O su Estructura Esta DesActualizada.',;
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
			 {||CreaCarAno(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURAS PATHS DE INTEGRACION                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:27 PM   SEP 26/96 JUE

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathCarAno(lShared,cPatSis,cAnoUsr,cIntUno,;
		    cIntDos,cIntTre,cIntCua,nModCry,lPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del sistema
       cAnoUsr                              // A¤o del Usuario
       cIntUno                              // @Path de Integraci¢n uno
       cIntDos                              // @Path de Integraci¢n dos
       cIntTre                              // @Path de Integraci¢n tres
       cIntCua                              // @Path de Integraci¢n cuatro
       nModCry                              // Modo de Protecci¢n
       lPatSis                              // .T. Incluir Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cNalias := ''                  // Nombre del Alias
       LOCAL nNroMes := 0                   // Mes para conciliar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       IF VALTYPE(nModCry) != 'N'
	  cError('NO ES NUMERICO EL PARAMETRO EN LOS PATHS DE INTEGRACCION')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>ANALISIS DEL ALIAS
       IF ALIAS(SELECT('CAA')) == 'CAA'
	  cNalias := 'CAA'
       ELSE
	  cNalias := 'ANO'
       ENDIF
*>>>>FIN ANALISIS DEL ALIAS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF cNalias == 'ANO'
	  IF !lUseDbf(.T.,cPatSis+'\'+;
			  FCarAno+cAnoUsr+ExtFile,cNalias,NIL,lShared,nModCry)
	     cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	     CloseDbf(cNalias,cPatSis+'\'+FCarAno+cAnoUsr+ExtFile,nModCry)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT &cNalias
       GO TOP
       lPatSis := IF(lPatSis == NIL,.T.,lPatSis)
       cIntUno := ALLTRIM(&cNalias->cIntUnoCaA)+IF(lPatSis,'\'+cPatSis,'')
       cIntDos := ALLTRIM(&cNalias->cIntDosCaA)+IF(lPatSis,'\'+cPatSis,'')
       cIntTre := ALLTRIM(&cNalias->cIntTreCaA)+IF(lPatSis,'\'+cPatSis,'')
       cIntCua := ALLTRIM(&cNalias->cIntCuaCaA)+IF(lPatSis,'\'+cPatSis,'')
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION

*>>>>VALIDACION DE LA CONCILIACION CON LA CONTABILIDAD
       IF &cNalias->nDiaConCaA # 0 .AND. DAY(DATE()) > &cNalias->nDiaConCaA

	  nNroMes := MONTH(DATE())
	  DO CASE
	  CASE VAL(cAnoUsr) == YEAR(DATE()) .AND. nNroMes > 1
	       nNroMes--
	  CASE VAL(cAnoUsr) # YEAR(DATE())
	       nNroMes := 12
	  ENDCASE

	  FOR i := 1 TO nNroMes
	      IF SUBS(&cNalias->cValConCaA,i,1) # '1'
		 cError('DEBE CONFIRMAR LA CONCILIACION DE LA'+' '+;
			'CONTABILIDAD DEL MES DE '+cMes(i))
	      ENDIF
	  ENDFOR

       ENDIF
       IF cNalias == 'ANO'
	  CloseDbf(cNalias,cPatSis+'\'+FCarAno+cAnoUsr+ExtFile,nModCry)
       ENDIF
       RETURN NIL
*>>>>FIN VALIDACION DE LA CONCILIACION CON LA CONTABILIDAD

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:28 PM   SEP 26/96 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManCarAno(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL oBrwCaA := NIL                 // Browse
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseDbf('CAA',cPatSis+'\'+FCarAno+cAnoUsr+ExtFile,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwCaA := oBrwCarAno(lShared,cAnoUsr,nFilPal+1,00,22,79)
       CAA->(CtrlBrw(lShared,oBrwCaA))
       CloseDbf('CAA',cPatSis+'\'+FCarAno+cAnoUsr+ExtFile,nModCry)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   SEP 26/96 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwCarAno(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrwCaA := NIL	            // Browse de Clientes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwCaA := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwCaA:ColSep    := '³'
       oBrwCaA:HeadSep   := 'Ä'
       oBrwCaA:Cargo     := {'<< CONFIGURACION DE LA CARTERA PARA '+;
			     cAnoUsr+' >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CAA
       oColumn	:= TBCOLUMNNEW('PATH DE SIMACONT',;
				    {||CAA->cIntUnoCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cIntUnoCaA'},{'PICTURE','@X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE SIMAMATR',{||CAA->cIntDosCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cIntDosCaA'},{'PICTURE','@X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE SIMACAFE',{||CAA->cIntTreCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cIntTreCaA'},{'PICTURE','@X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE SIMADATA',{||CAA->cIntCuaCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cIntCuaCaA'},{'PICTURE','@X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE CAFETERIA',{||CAA->cIntCafCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cIntCafCaA'},{'PICTURE','@X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE RUTAS',{||CAA->cIntRutCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cIntRutCaA'},{'PICTURE','@X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH REAL;SIMACONT',{||CAA->cIntScoCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cIntScoCaA'},{'PICTURE','@X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH REAL;SIMAMATR',{||CAA->cIntMtrCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cIntMtrCaA'},{'PICTURE','@X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MAESTROS;HABILITADOS',{||CAA->cMaeHabCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cMaeHabCaA'}, {'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('JORNADAS;HABILITADAS',{||CAA->cJorHabCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cJorHabCaA'}, {'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REVISAR;ALUMNOS', {||CAA->lRevisaCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lRevisaCaA'}, {'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('HAY CLIENTES;CREADOS',;
				    {||CAA->lHayCliCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lHayCliCaA'}, {'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO;DEL BANCO',;
				    {||CAA->cCodigoBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cCodigoBan'}, {'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES ACTUAL DE;FACTURACION',;
				    {||CAA->nMesActCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nMesActCaA'}, {'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES INICIAL DE;FACTURACION',;
				    {||CAA->nMesIniCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nMesIniCaA'}, {'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES FINAL DE;FACTURACION',;
				    {||CAA->nMesFinCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nMesFinCaA'}, {'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('No. RECIBO;PARA FACTURACION',;
				    {||CAA->nRecNroCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nRecNroCaA'}, {'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('No. DE RECIBO;OTRA FACTURACION',;
				    {||CAA->nOtrRecCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nOtrRecCaA'}, {'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FACTURA;PREIMPRESA', {||CAA->lPrePrnCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lPrePrnCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HAY NUMERO;DE FACTURA',;
				   {||CAA->lHayNroCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lHayNroCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO;FACTURA', {||CAA->nNroFacCaA})
       IF CAA->lHayNroCaA
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			    {'FIELD','nNroFacCaA'},{'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('UTILIZAR INTERES;POR MORA',;
				    {||CAA->lIntPenCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lIntPenCaA'}, {'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INTERESES;POR MORA',{||CAA->nIntPenCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nIntPenCaA'},{'PICTURE','99.99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR DEL;RECARGO',{||CAA->nVlrMorCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nVlrMorCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INTERESES;NO PAGO',{||CAA->nIntDeuCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nIntDeuCaA'},{'PICTURE','99.99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LEER FECHA;DE PAGO',;
				   {||CAA->lLeeFecCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lLeeFecCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF CAA->lLeeFecCaA
	  oColumn := TBCOLUMNNEW('INFORMES;POR FECHA',{||CAA->lPrnFecCaA})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			    {'FIELD','lPrnFecCaA'},{'PICTURE','@!'}}
	  oBrwCaA:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	     := TBCOLUMNNEW('HABILITAR;FORMA DE PAGO',;
				   {||CAA->lForPagCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lForPagCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VISUALIZAR;FECHA EXTEMPORANEA',;
				   {||CAA->lPagExtCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lPagExtCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCUENTO;GENERAL',{||CAA->nDesGenCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nDesGenCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECARGO;GENERAL',{||CAA->nRecGenCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nRecGenCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS;DES/REC',{||CAA->cConGenCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cConGenCaA'},{'PICTURE','XX'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HABILITAR CONCEPTO;DES/REC RECIBO',;
				   {||CAA->lNomConDes})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lNomConDes'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	:= TBCOLUMNNEW('No. DE RECIBO;PARA PAZ Y SALVO',;
				    {||CAA->nRecPazCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nRecPazCaA'}, {'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TOTAL RUTAS;POR ESTUDIANTE',;
			       {||CAA->nRutEstCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nRutEstCaA'}, {'PICTURE','9'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS MATRICULAS;CERTIFICADOS',;
				    {||CAA->cConMatCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cConMatCaA'},{'PICTURE','@X!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('A¥O PROCESAR;LAS MATRICULAS',;
			       {||CAA->cAnoMtrCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cAnoMtrCaA'}, {'PICTURE','9999'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('A¥O DEL MAESTRO;DE ESTUDIANTES',;
			       {||CAA->cAnoAluCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cAnoAluCaA'}, {'PICTURE','9999'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE PARA;EL RECIBO',;
				    {||CAA->nNomFacCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nNomFacCaA'},{'PICTURE','9'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE PARA;REPORTAR',{||CAA->nNomRepCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nNomRepCaA'},{'PICTURE','9'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES DE;AMNISTIA',;
				   {||CAA->nMesAmnCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nMesAmnCaA'},{'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('ITEM;PAZ Y SALVO',{||CAA->cCodPazCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cCodPazCaA'},{'PICTURE','@S76X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MENSAJE DE;LA FACTURACION',;
				    {||CAA->cMensajCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cMensajCaA'},{'PICTURE','@S76X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TEXTO UNO DE;LA FACTURACION',;
				    {||CAA->cTxtUnoCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cTxtUnoCaA'},{'PICTURE','@S76X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TEXTO DOS DE;LA FACTURACION',;
				    {||CAA->cTxtDosCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cTxtDosCaA'},{'PICTURE','@S76X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO QR DE;LA FACTURACION',;
				    {||CAA->cCodeQrCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cCodeQrCaA'},{'PICTURE','@S76X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


/*
       oColumn	:= TBCOLUMNNEW('MENSAJE PARA;EL RECIBO DE PAGO',;
				    {||CAA->cMenFacCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cMenFacCaA'},{'PICTURE','@S76X'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn := TBCOLUMNNEW('INFORMES;CONCEPTOS',{||CAA->lPrnConCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lPrnConCaA'},{'PICTURE','@!'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CONCILIACION;CON CONTABILIDAD.',;
			      {||CAA->cValConCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','cValConCaA'},{'PICTURE','99999999999999'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DIA PARA CONCILIAR;LA CONTABILIDAD',;
			      {||CAA->nDiaConCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nDiaConCaA'},{'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('METODO DE;FACTURACION',;
			      {||CAA->nMtdFacCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nMtdFacCaA'},{'PICTURE','99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DIAS EN MORA;BLOQUEAR ESTUDIANTES',;
			      {||CAA->nDiaMorCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nDiaMorCaA'},{'PICTURE','999'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPUESTO;ICA %',{||CAA->nImpIcaCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','nImpIcaCaA'},{'PICTURE','99.99'}}
       oBrwCaA:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwCaA
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIO DE LA FECHA PARA PAGO EXTEMPORANEO      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   AGO 09/96 VIE

OBJETIVOS:

1- Debe estar en uso el archivo de Tablas

2- Permite visualizar y cambiar la fecha para pago extemporaneo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION dFecExt(lShared,nNroFil,nNroCol,dFecha)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil				    // Fila de impresi¢n
       nNroCol				    // Columna de impresi¢n
       dFecha			            // Fecha a cambiar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARCION DE VARIABLES
       LOCAL cMsgTxt                        // Texto Variable
       LOCAL cNroMes			    // N£mero del mes
       LOCAL cAnoSys                        // Ano del sistema
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL dOpoPenTan := CTOD('00/00/00') // Fecha Exteporaneo Pension
*>>>>FIN DECLARCION DE VARIABLES

*>>>>INICIALIZACION DE LA FECHA PARA EL DIA 10 DEL MES
       dOpoPenTan := IF(EMPTY(&(dFecha)),DATE(),&(dFecha))
       IF DAY(DATE()) > 20

	  cNroMes = STR(MONTH(DATE()+30),2)
	  IF MONTH(DATE()) = 12
	     cAnoSys = STR(YEAR(DATE())+1,4)
	  ELSE
	     cAnoSys = STR(YEAR(DATE()),4)
	  ENDIF
	*ÀInicializa para el d¡a 10 del siguiente mes

	  dOpoPenTan := CTOD(cNroMes+'/15/'+cAnoSys)

       ENDIF
*>>>>FIN INICIALIZACION DE LA FECHA PARA EL DIA 10 DEL MES

*>>>>LECTURA Y VALIDACION DE LA FECHA PARA EL PAGO OPORTUNO
       DO WHILE .T.

**********LECTURA DE LA FECHA PARA PAGO OPORTUNO
	    @ nNroFil,nNroCol GET dOpoPenTan
	    READ
	    EXIT
**********FIN CAPTURA DE LOS DETALLES DE LA DEUDA

/*
**********VALIDACION DE LA FECHA POR PAGO OPORTUNO
	    DO CASE
	    CASE MONTH(dOpoPenTan) < MONTH(DATE()) .AND.;
		  YEAR(dOpoPenTan) <=  YEAR(DATE())
		  cError('EL MES DEL PAGO NO DEBE SER MENOR AL MES ACTUAL')

	    CASE YEAR(dOpoPenTan) < YEAR(DATE())
		 cError('EL A¥O DEL PAGO NO DEBE SER MENOR AL A¥O ACTUAL')

	    OTHERWISE
		EXIT
	    ENDCASE
**********FIN VALIDACION DE LA FECHA POR PAGO OPORTUNO
*/

       ENDDO
*>>>>FIN LECTURA Y VALIDACION DE LA FECHA PARA EL PAGO OPORTUNO

*>>>>GRABACION DE LA FECHA
       SELECT CAA
       IF CAA->(lRegLock(lShared,.F.))
	  REPL &dFecha WITH dOpoPenTan     // Graba la fecha
	  CAA->(DBCOMMIT())
	  IF lShared
	     CAA->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR LA FECHA')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LA FECHA

/*************************************************************************
* TITULO DE LA FUNCION..: GRABACION DE LOS CONCEPTOS A COBRAR            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:35 PM   AGO 09/96 VIE

OBJETIVOS:

1- Debe estar en uso el archivo de Configuraci¢n del A¤o

2- Permite visualizar y cambiar los conceptos por cobar de la matricula
   o la pension

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GrabarCon(lShared,nNroFil,nNroCol,nFilCon,nColCon,cConcep)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil			            // Fila Principal
       nNroCol			            // Columna Principal
       nFilCon                              // Fila Impresion de Conceptos
       nColCon                              // Columna impresion Conceptos
       cConcep                              // Campo del concepto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>GRABACION DE LOS CONCEPTOS A COBRAR
       SELECT CAA
       IF CAA->(lRegLock(lShared,.F.))
	  REPL &cConcep WITH cLeeConcep(nNroFil,nNroCol,;
				       nFilCon,nColCon)
	  CAA->(DBCOMMIT())
	  IF lShared
	     CAA->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR LOS CONCEPTOS')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LOS CONCEPTOS A COBRAR

/*************************************************************************
* TITULO..: LECTURA DE LOS INTERESES POR PAGO EXTEMPORANEO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:50 PM   AGO 09/96 VIE


1- Permite Consultar y cambiar los intereses por mora que se cobrar  por
   pago extemporaneo.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeIntExt(lShared,nNroFil,nNroCol,lIntPen)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil				    // Fila de lectura
       nNroCol				    // Columna de lectura
       lIntPen                              // .T. Utilizar interes por mora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList:= {}                   // Variable del sistema

       LOCAL nIntMorTan := 0                // Intereses o recargo por mora
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS INTERESES POR MORA
       nIntMorTan := CAA->nIntPenCaA
       @ nNroFil,nNroCol GET nIntMorTan;
			 PICT IF(lIntPen,'99.99','9999999.99')
       READ
*>>>>FIN LECTURA DE LOS INTERESES POR MORA

*>>>>GRABACION DE LOS INTERESES
       SELECT CAA
       IF CAA->(lRegLock(lShared,.F.))
	  IF lIntPen
	     REPL CAA->nIntPenCaA WITH nIntMorTan
	     IF !EMPTY(nIntMorTan)
		REPL CAA->nVlrMorCaA WITH 0
	     ENDIF
	  ELSE
	     REPL CAA->nVlrMorCaA WITH nIntMorTan
	     IF !EMPTY(nIntMorTan)
		REPL CAA->nIntPenCaA WITH 0
	     ENDIF
	  ENDIF
	  CAA->(DBCOMMIT())
	  IF lShared
	     CAA->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL VALOR DE LOS INTERESES')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LOS INTERESES

/*************************************************************************
* TITULO..: LECTURA DE LOS INTERESES NO PAGO.                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2010 LUN A
       Colombia, Bucaramanga        INICIO: 03:50 PM   MAR 01/2010 LUN


1- Permite Consultar y cambiar los intereses por mora que se cobrar  por
   pago atrasado

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeIntMor(lShared,nNroFil,nNroCol,lIntPen)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil				    // Fila de lectura
       nNroCol				    // Columna de lectura
       lIntPen                              // .T. Utilizar interes por mora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList:= {}                   // Variable del sistema

       LOCAL nIntMorTan := 0                // Intereses o recargo por mora
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS INTERESES POR MORA
       nIntMorTan := CAA->nIntDeuCaA
       @ nNroFil,nNroCol GET nIntMorTan;
			 PICT IF(lIntPen,'99.99','9999999.99')
       READ
*>>>>FIN LECTURA DE LOS INTERESES POR MORA

*>>>>GRABACION DE LOS INTERESES
       SELECT CAA
       IF CAA->(lRegLock(lShared,.F.))
	  IF lIntPen
	     REPL CAA->nIntDeuCaA WITH nIntMorTan
	     IF !EMPTY(nIntMorTan)
		REPL CAA->nVlrDeuCaA WITH 0
	     ENDIF
	  ELSE
	     REPL CAA->nVlrDeuCaA WITH nIntMorTan
	     IF !EMPTY(nIntMorTan)
		REPL CAA->nIntPenCaA WITH 0
	     ENDIF
	  ENDIF
	  CAA->(DBCOMMIT())
	  IF lShared
	     CAA->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL VALOR DE LOS INTERESES')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LOS INTERESES

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL MENSAJE PARA LA FACTURACION        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 04:55 PM   AGO 09/96 VIE

1- Permite Consultar y cambiar el mensaje de la facturacion

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeMensaj(lShared,nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil				    // Fila de lectura
       nNroCol				    // Columna de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList:= {}                   // Variable del sistema

       LOCAL cMensajTan := 0                // Mensaje para facturacion
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL MENSAJE
       cMensajTan := CAA->cMensajCaA
       @ nNroFil,nNroCol GET cMensajTan PICT '@!S78'
       READ
*>>>>FIN LECTURA DEL MENSAJE

*>>>>GRABACION DEL MENSAJE
       SELECT CAA
       IF CAA->(lRegLock(lShared,.F.))
	  REPL CAA->cMensajCaA WITH cMensajTan
	  CAA->(DBCOMMIT())
	  IF lShared
	     CAA->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL MENSAJE PARA LA FACTURACION')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL MENSAJE

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIO DEL BANCO PARA EL PAGO DE LOS RECIBOS   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   AGO 09/96 VIE


OBJETIVOS:

1- Debe estar en uso los archivos de Configuraci¢n del a¤o y Bancos

2- Permite establecer el c¢digo del banco para la facturaci¢n

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CambiaBan(lShared,nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup                        // Fila Superior
       LOCAL nColSup                        // Columna Superior
       LOCAL nFilInf                        // Fila Inferior
       LOCAL nColInf                        // Columna Inferior
       LOCAL cSavPan                        // Salvar Pantalla
       LOCAL nRegBan                        // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT BAN
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+LEN(BAN->cNombreBan)-1
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CODIGO DEL BANCO
       cSavPan := SAVESCREEN(0,0,24,79)
       BAN->(DBGOTOP())

       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nRegBan := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||BAN->cNombreBan})
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nRegBan == 0
	  RETURN NIL
       ENDIF
       BAN->(DBGOTO(nRegBan))
*>>>>FIN SELECCION DEL CODIGO DEL BANCO

*>>>>GRABACION DEL CODIGO DEL BANCO
       SELECT CAA
       IF CAA->(lRegLock(lShared,.F.))
	  REPL CAA->cCodigoBan WITH BAN->cCodigoBan
	  CAA->(DBCOMMIT())
	  IF lShared
	     CAA->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL BANCO DONDE SE DEBE PAGAR')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: ULTIMO MES CONCILIADO CON LA CONTABILIDAD                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 07/2006 MAR A
       Colombia, Bucaramanga        INICIO: 12:15 AM   MAR 07/2006 MAR


OBJETIVOS:

1- Calcula el £ltimo mes conciliado con la contabilidad.

2- Revisar si sirve para implemtar. OJO

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMesVal()

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nMesVal := 0                   // Ultimo mes validado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL ULTIMO MES CONCILIADO
       FOR i := 1 TO 12
	   nMesVal += VAL(SUBS(CAA->cValConCaA,i,1))
       ENDFOR
       IF VAL(SUBS(CAA->cValConCaA,13,2)) # nMesVal
	  nMesVal := 12
       ENDIF
       RETURN nMesVal
*>>>>FIN LECTURA DEL ULTIMO MES CONCILIADO

