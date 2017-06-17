/*               	 SISTEMA CARTERA ACADEMICA
	     BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE MOROSOS

REQUERIMIENTOS:

- Compilar: clipper FuncsMor /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Morosos

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2001 LUN A
       Colombia, Bucaramanga        INICIO: 05:00 PM   ABR 02/2001 LUN

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfMor(lShared,nModCry,PathMor,FileMor,lIntUno,fNtxMor,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathMor				    // Path del Archivo
       FileMor				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxMor				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfMor := {{"cCodigoEst","Character",06,0},; // C¢digo del Estudiante
			 {"nMesIniPag","Numeric"  ,02,0},; // Mes Inicial de pago
			 {"nMesFinPag","Numeric"  ,02,0},; // Mes Final del pago
			 {"nSdoAntPag","Numeric"  ,10,2},; // Saldo Anterior
			 {"nMorAntPag","Numeric"  ,10,2},; // Valor Mora Anterior
			 {"nVlrMesPag","Numeric"  ,10,2},; // Valor del Mes
			 {"nVlrPagPag","Numeric"  ,10,2},; // Valor a pagar
			 {"nSdoActCli","Numeric"  ,12,2},; // Saldo Actual
			 {"nSdoMorCli","Numeric"  ,12,2},; // Valor de la Mora
			 {"cMesPagCli","Character",12,0},; // Control de meses pagados
			 {"cHayRepCli","Character",05,0},; // Detalles del Reporte
			 {"nMesMorMor","Numeric"  ,02,0},; // Mes de la Mora
			 {"nDiaMorMor","Numeric"  ,04,0},; // D¡as en mora
			 {"cConcepMor","Character",16,0},; // Conceptos del Pago
			 {"nVlrCo1Mor","Numeric"  ,12,2},; // Valor del Concepto No. 1
			 {"nVlrCo2Mor","Numeric"  ,12,2},; // Valor del Concepto No. 2
			 {"nVlrCo3Mor","Numeric"  ,12,2},; // Valor del Concepto No. 3
			 {"nVlrCo4Mor","Numeric"  ,12,2},; // Valor del Concepto No. 4
			 {"nVlrCo5Mor","Numeric"  ,12,2},; // Valor del Concepto No. 5
			 {"nVlrCo6Mor","Numeric"  ,12,2},; // Valor del Concepto No. 6
			 {"nVlrCo7Mor","Numeric"  ,12,2},; // Valor del Concepto No. 7
			 {"nVlrCo8Mor","Numeric"  ,12,2},; // Valor del Concepto No. 8
			 {"dFecRepMor","Date"     ,08,0},; // Fecha de Reporte
			 {"dFecRetMor","Date"     ,08,0},; // Fecha de Retiro del Reporte
			 {"lPagRecMor","Logical"  ,01,0},; // .T. Pago el Recibo
			 {"lSiRepoMor","Logical"  ,01,0},; // .T. Reportar el Estudiante .F. No Reportar
			 {"lHayRepMor","Logical"  ,01,0},; // .T. Reportado .F. No Reportado
			 {"lCartasMor","Logical"  ,01,0},; // .T. Imprimir la Carta
			 {"lInfActMor","Logical"  ,01,0},; // .T. Registro grabado en ASCII
			 {"lNtfCobCar","Logical"  ,01,0},; // La Empresa de Cobro SI/NO envia Cartas de Notificaci¢n a los reportados
			 {"cTipNtfCar","Character",20,0},; // Tipo de Notificaci¢n. Ej: INSTITUCION - CORREO
			 {"cObservMor","Character",40,0},; // Registro para Exportar
			 {"cMesMorMor","Character",48,0},; // Meses en Atraso
			 {"cNomEstMor","Character",60,0},; // Nombre del Estudiante
			 {"cAnoDeuMor","Character",04,0},; // A¤o de la Deuda
			 {"cNomPadEst","Character",60,0},; // Nombre del Padre
			 {"cPadNitEst","Character",40,0},; // Documento del Padre.
			 {"cDirPadEst","Character",80,0},; // Direcci¢n del Padre
			 {"cTelPadEst","Character",20,0},; // Telefono del Padre
			 {"cNomMadEst","Character",60,0},; // Nombre de la Madre
			 {"cMadNitEst","Character",40,0},; // Documento de la Madre
			 {"cDirMadEst","Character",80,0},; // Direcci¢n de la Madre
			 {"cTelMadEst","Character",20,0},; // Telefono de la Madre
			 {"cNomCo3Est","Character",60,0},; // Nombre del Contratante No.3
			 {"cCo3NitEst","Character",40,0},; // Documento del Contratante No.3
			 {"cDirCo3Est","Character",80,0},; // Direcci¢n del Contratante No.3
			 {"cTelCo3Est","Character",20,0},; // Telefono del Contratante No.3
			 {"cNomCo4Est","Character",60,0},; // Nombre del Contratante No.4
			 {"cCo4NitEst","Character",40,0},; // Documento del Contratante No.4
			 {"cDirCo4Est","Character",80,0},; // Direcci¢n del Contratante No.4
			 {"cTelCo4Est","Character",20,0},; // Telefono del Contratante No.4
			 {"cNomUsrMor","Character",10,0},; // Nombre del Usuario
			 {"dFecUsrMor","Date"     ,08,0},; // Fecha del Usuario
			 {"cHorUsrMor","Character",10,0}}  // Hora del Usuario
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfMor
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathMor) == 0
	    DBCREATE(FileMor,aDbfMor,"DBFNTX")
	    Proteger(FileMor,nModCry)

       CASE DIRCHANGE(PathMor) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathMor)

       CASE DIRCHANGE(PathMor) == -5
	    cError('NO TIENE DERECHOS EN: '+PathMor)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2001 LUN A
       Colombia, Bucaramanga        INICIO: 05:05 PM   ABR 02/2001 LUN

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

FUNCTION nActStrMor(lShared,nModCry,PathMor,FileMor)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCar				    // Path del Archivo
       FileMor				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('MOR')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathMor+'\'+FileMor,'MOR',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE MOROSOS')
	  CloseDbf('MOR',PathMor+'\'+FileMor,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := MOR->(DBSTRUCT())
       CloseDbf('MOR',PathMor+'\'+FileMor,nModCry)
       CreaDbfMor(lShared,nModCry,PathMor,FileMor,,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
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
	  cError('El Archivo MOROSOS su Estructura Esta DesActualizada.',;
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
	  FileTem := SUBS(FileMor,1,AT('.',FileMor))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathMor+'\'+FileMor,;
			 PathMor+'\'+FileTem,;
			 {||CreaDbfMor(lShared,nModCry,PathMor,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO 		                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2001 LUN A
       Colombia, Bucaramanga        INICIO: 05:10 PM   ABR 02/2001 LUN

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenMor(aParam1,aParam2,aParam3,;
		   cEmpCob,lMorAct,dFecDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro
       lMorAct                              // .T. Morosos Actuales
       dFecDia                              // Fecha del Proceso Diario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nMesIni := 0                   // Mes Inicial del pago
       LOCAL cMesIni := ''                  // Mes Inicial del pago
       LOCAL lSiLeer := .F.                 // .T. Leer Archivo
       LOCAL lMorDia := .F.                 // .T. Mora por Dias
       LOCAL lProDia := .F.                 // Fecha del Proceso Diario
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL nTotMor := 0                   // Total de la Mora
       LOCAL lAllGru := .F.                 // .T. Todos los Grupos
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // Codigo del grupo
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
       SET DECIMAL TO
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>ANALISIS DE LA CLASE DE ARCHIVO
       lMorDia := IF(VALTYPE(lMorAct) == 'C',.T.,.F.)
       lProDia := IF(dFecDia == NIL,.F.,.T.)
       IF !lMorDia
	  lMorAct := IF(lMorAct == NIL,.F.,lMorAct)
       ELSE
	  lMorAct := .T.
       ENDIF
*>>>>FIN ANALISIS DE LA CLASE DE ARCHIVO

*>>>>CAPTURA DEL MES
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lMorAct
	  nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
				'Por Favor Seleccione el Mes',.T.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nMesIni == 0
	     CloseAll()
	     RETURN NIL
	  ENDIF
	  cMesIni := STR(nMesIni,2)
	  lCorrecion(@cMesIni)
       ENDIF
*>>>>FIN CAPTURA DEL MES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DEL SISTEMA.')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DEL COLEGIO')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE !(lMorAct .OR. lProDia) .AND.;
	    (SCA->cTipNtfCar # 'INSTITUCION' .AND. SCA->cTipNtfCar # 'CORREO')
	    cError('EL TIPO DE NOTIFICACION DEBE SER: INSTITUCION o CORREO')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

/*
*>>>>VALIDACION PARA REPORTAR
       IF CAA->nNomRepCaA == 0
	  cError('LA OPCION PARA REPORTAR ESTA DESHABILITADA')
       ENDIF
*>>>>FIN VALIDACION PARA REPORTAR
*/

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF !lMorDia
	  IF !lMorAct
	     FileMor := FileMor+cMesIni+ExtFile
	     fNtxMor := fNtxMor+cMesIni+cExtNtx
	  ELSE
	     FileMor := FileMor+ExtFile
	     fNtxMor := fNtxMor+cExtNtx
	  ENDIF
       ELSE
	  FileMor := 'MORADIAS'+ExtFile
	  fNtxMor := 'MORADIAS'+cExtNtx
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>CREACION DEL ARCHIVO PARA LOS SALDOS DIARIOS
       IF lMorDia .AND. !FILE(cPatSis+'\COBROS\'+FileMor)
	  CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
	  CreaDbfMor(lShared,nModCry,cPatSis+'\COBROS',FileMor)
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO PARA LOS SALDOS DIARIOS

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF FILE(cPatSis+'\COBROS\'+FileMor)
	  IF nActStrMor(lShared,nModCry,cPatSis+'\COBROS',FileMor) == 1
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

*>>>>ANALISIS DE DECISION
       IF !lMorDia
	  lSiLeer := .F.
	  IF lMorAct
	     IF FILE(cPatSis+'\COBROS\'+FileMor)

		IF !lProDia
		   lUseDbf(.T.,cPatSis+'\COBROS\'+FileMor,;
			      'MOR',NIL,lShared,nModCry)

		   cError(cFecha(MOR->dFecUsrMor),;
			  'EL SALDO ACTUAL ESTA A:',;
			  'A LAS '+cHoraSys(MOR->cHorUsrMor))

		   lSiLeer := lPregunta('DESEA ACTUALIZAR EL SALDO '+;
					'DE LA CARTERA? Si No')

		   CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
		ENDIF
	     ENDIF
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DEL ARCHIVO DEL ARCHIVO
       IF ((!FILE(cPatSis+'\COBROS\'+FileMor) .OR.;
	   (lMorAct .AND. lSiLeer)) .AND. !lMorDia) .OR. lProDia

**********ANALISIS DE DECISION
	    IF !lProDia
	       IF !lPregunta('DESEA RELACIONAR LOS ESTUDIANTES MOROSOS? Si No')
		  CloseAll(aUseDbf)
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE DECISION

**********LECTURA DEL ARCHIVO
	    lAllGru := OtrMor066(aParam1,aParam2,aParam3,;
				 oBrowse,.F.,cMesIni,lMorAct,dFecDia)
	    RESTSCREEN(0,0,24,79,cSavPan)
	    CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
**********FIN LECTURA DEL ARCHIVO

       ENDIF
*>>>>FIN LECTURA DEL ARCHIVO DEL ARCHIVO

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(cPatSis+'\COBROS\'+FileMor)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>VALIDACION DEL ARCHIVO INDICE
       IF !FILE(cPatSis+'\COBROS'+fNtxMor)

***********SELECCION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\COBROS\'+FileMor,'MOR',NIL,lShared,nModCry)
		cError('ABRIENDO EL ARCHIVO DE COBROS')
		CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECCION DE LAS AREAS DE TRABAJO

************INDEXACION DEL ARCHIVO
	      SELECT MOR
	      IF lMorDia
		 INDEX ON MOR->dFecUsrMor;
		       TO &(cPatSis+'\COBROS\'+fNtxMor) DESCENDING
	      ELSE
		 INDEX ON MOR->cCodigoEst;
		       TO &(cPatSis+'\COBROS\'+fNtxMor)
	      ENDIF
	      CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
************FIN INDEXACION DEL ARCHIVO

       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO INDICE

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\COBROS\'+FileMor,'MOR',IF(lMorDia,;
		       cPatSis+'\COBROS\'+fNtxMor,NIL),lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE COBROS')
	  CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>CALCULO DEL TOTAL DE LA CARTERA
       IF !lMorDia
	  nTotMor := cDeuActMor()
	  IF lMorAct .AND. lAllGru

	     GraSdoDia(lShared,nModCry,cPatSis+'\COBROS',;
		       MOR->dFecUsrMor,nTotMor)
	  ENDIF
       ENDIF
*>>>>FIN CALCULO DEL TOTAL DE LA CARTERA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT MOR

       oBrowse := oDefBrwMor(nFilPal+1,00,22,79,cMaeAlu,nMesIni,;
			     lMorAct,lMorDia,nTotMor)
       IF !lMorDia

	  SETKEY(K_F2,{||InfoAlu(nFilPal,1,'MOR',cNomEmp,cNomSis,;
				 MOR->cCodigoEst,cMaeAlu,'MOR',oBrowse)})

	  SETKEY(K_F3,{||EstadoCta(lShared,nModCry,cNomSis,cNomEmp,;
				   cNomUsr,cAnoUsr,cPatSis,cJorTxt,;
				   nFilPal,1,cMaeAct,NIL,.F.,;
				   MOR->cCodigoEst,cMaeAlu,'MOR')})

	  SETKEY(K_F4,{||RelDesEst(lShared,nModCry,cNomSis,cNomEmp,;
				   nFilPal,1,cMaeAct,cPatSis,.F.,;
				   MOR->cCodigoEst,cMaeAlu,'MOR')})

	  SETKEY(K_F5,{||BuscarMor(lShared,oBrowse,cMaeAlu,;
				   cPatSis+'\COBROS\'+fNtxMor)})


	  SETKEY(K_F7,{||lDatosEst(lShared,nFilPal,1,;
				   MOR->cCodigoEst,cMaeAlu,NIL,'MOR')})

       ENDIF

       SETKEY(K_F9,{||MenuOtrMor(aParam1,aParam2,aParam3,;
				 cEmpCob,oBrowse,cMesIni,lMorAct,;
				 lMorDia,nTotMor)})
       MOR->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F2,NIL)
       SETKEY(K_F3,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F6,NIL)
       SETKEY(K_F7,NIL)
       SETKEY(K_F9,NIL)

       SET DECIMAL TO 2
       CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE 		                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2001 LUN A
       Colombia, Bucaramanga        INICIO: 05:15 PM   ABR 02/2001 LUN

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

 oBrowse := oDefBrwMor(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwMor(nFilSup,nColSup,nFilInf,nColInf,cMaeAlu,;
		    nMesIni,lMorAct,lMorDia,nTotMor,cTitSup,cTitInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maestros habilitados
       nMesIni			            // Mes Inicial del pago
       lMorAct                              // Mora Actual
       lMorDia                              // Mora por Dias
       nTotMor                              // Total Mora
       cTitSup                              // T¡tulo Superior
       cTitInf                              // T¡tulo Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       IF lMorDia
	  cTitSup := IF(EMPTY(cTitSup),;
		     '<<CARTERA POR DIAS>>',cTitSup)
	  cTitInf := IF(EMPTY(cTitInf),;
		     '<F9>Otros <ESC>Abandonar',cTitInf)
       ELSE
	  IF lMorAct
	     cTitSup := IF(EMPTY(cTitSup),;
			'<<MOROSOS A '+cFecha(MOR->dFecUsrMor)+' '+;
			 cHoraSys(MOR->cHorUsrMor)+;
			' TOTAL DEUDA '+;
			TRANS(nTotMor,"$###,###,###")+' >>',cTitSup)
	     cTitInf := IF(EMPTY(cTitInf),;
			'<F2>Personal <F3>Pagos <F4>Decuentos '+;
			'<F7>Actualizar <F5>Buscar <F9>Otros',cTitInf)
	  ELSE
	     cTitSup := IF(EMPTY(cTitSup),;
			'<<ESTUDIANTES MOROSOS. RECIBOS DE '+;
			cMes(nMesIni,10)+;
			'.TOTAL DEUDA '+;
			TRANS(nTotMor,"$###,###,###")+' >>',cTitSup)

	     cTitInf := IF(EMPTY(cTitInf),;
			'<F2>Personal <F3>Pagos <F4>Decuentos '+;
			'<F7>Actualizar <F5>Buscar <F9>Otros',cTitInf)
	  ENDIF
       ENDIF
       oBrowse:Cargo     := {cTitSup,cTitInf}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT MOR
       IF !lMorDia
	  oColumn := TBCOLUMNNEW('No.', {||TRANS(MOR->(RECNO()),'####')})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('CODIGO', {||MOR->cCodigoEst})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('NOMBRE DEL;ESTUDIANTE',;
				 {||cSekNomAlu(MOR->cCodigoEst,cMaeAlu,'MOR')})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF lMorDia
	  oColumn := TBCOLUMNNEW('FECHA',;
				 {||cFecha(MOR->dFecUsrMor)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	     := TBCOLUMNNEW('SALDO ACTUAL',;
				    {||TRANS(MOR->nSdoActCli+;
					     MOR->nSdoMorCli,;
					     "$###,###,###.99")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DEUDA ACTUAL',;
				    {||TRANS(MOR->nSdoActCli,;
					     "$###,###,###.99")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA ACTUAL',;
				    {||TRANS(MOR->nSdoMorCli,;
					     "$###,###,###.99")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF !lMorDia

	  oColumn := TBCOLUMNNEW('PAGO',{||IF(MOR->lPagRecMor,'SI','NO')})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('DIAS EN MORA',{||MOR->nDiaMorMor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('MES DEL SALDO',{||MOR->nMesMorMor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('CONCEPTOS',{||MOR->cConcepMor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VLR CON No. 1', {||MOR->nVlrCo1Mor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VLR CON No. 2', {||MOR->nVlrCo2Mor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VLR CON No. 3', {||MOR->nVlrCo3Mor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VLR CON No. 4', {||MOR->nVlrCo4Mor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VLR CON No. 5', {||MOR->nVlrCo5Mor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VLR CON No. 6', {||MOR->nVlrCo6Mor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VLR CON No. 7', {||MOR->nVlrCo7Mor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VLR CON No. 8', {||MOR->nVlrCo8Mor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('REPORTAR',{||MOR->lSiRepoMor})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MOR'},;
			    {'FIELD','lSiRepoMor'}, {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('REPORTADO',;
				 {||IF(MOR->lHayRepMor,'SI','NO')})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('IMPRIMIR CARTA',{||MOR->lCartasMor})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MOR'},;
			    {'FIELD','lCartasMor'}, {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('INFORMACION;ACTUALIZADA',;
				 {||IF(MOR->lInfActMor,'SI','NO')})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('OBSERVACION',{||MOR->cObservMor})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MOR'},;
			    {'FIELD','cObservMor'}, {'PICTURE','@S40!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	 oColumn := TBCOLUMNNEW('FECHA DEL;REPORTE',;
				{||cFecha(MOR->dFecRepMor)})
	 oColumn:Cargo := {{'MODI',.F.}}
	 oBrowse:ADDCOLUMN(oColumn)
       *ÀDefinici¢n Columna

	 oColumn := TBCOLUMNNEW('FECHA RETIRO;REPORTE',;
			       {||cFecha(MOR->dFecRetMor)})
	 oColumn:Cargo := {{'MODI',.F.}}
	 oBrowse:ADDCOLUMN(oColumn)
       *ÀDefinici¢n Columna

	 oColumn := TBCOLUMNNEW('NOTIFICAR;POR ESCRITO',{||MOR->lNtfCobCar})
	 oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MOR'},;
			   {'FIELD','lNtfCobCar'},{'PICTURE','@!'}}
	 oBrowse:ADDCOLUMN(oColumn)
       *ÀDefinici¢n Columna

	 oColumn := TBCOLUMNNEW('TIPO DE;NOTIFICACION',{||MOR->cTipNtfCar})
	 oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MOR'},;
			   {'FIELD','cTipNtfCar'},{'PICTURE','@!'}}
	 oBrowse:ADDCOLUMN(oColumn)
       *ÀDefinici¢n Columna

       ENDIF

       IF !lMorDia .AND. !lMorAct
	  oColumn := TBCOLUMNNEW('MES',{||cMes(MOR->nMesIniPag,3)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('MES',{||cMes(MOR->nMesFinPag,3)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('DEUDA;ANTERIOR',{||MOR->nSdoAntPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('MORA;ANTERIOR', {||MOR->nMorAntPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VALOR;DEL MES', {||MOR->nVlrMesPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('VALOR;A PAGAR', {||MOR->nVlrPagPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('MESES PAGOS', {||MOR->cMesPagCli})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

       ENDIF

       IF !lMorDia

	  oColumn := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||MOR->cNomUsrMor})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('FECHA DE;PROCESO',;
				 {||cFecha(MOR->dFecUsrMor)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('HORA DE;PROCESO',;
				 {||cHoraSys(MOR->cHorUsrMor)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2001 LUN A
       Colombia, Bucaramanga        INICIO: 05:20 PM   ABR 02/2001 LUN

OBJETIVOS:

1- Debe estar en uso el archivo

2- Busca el c¢digo

3- Retorna NIL

SINTAXIS:

  BuscarMor(oBrowse,cMaeAlu)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarMor(lShared,oBrowse,cMaeAlu,fNtxMor)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       oBrowse				    // Browse del Archivo
       cMaeAlu                              // Maestros Habilitados
       fNtxMor                              // Indexe del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegMor := 0                   // Registro del Trao
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL nMesIniTpa := 0                // Mes inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTes := cSpaces('MOR','cCodigoEst')
       TitBuscar(LEN(cCodigoTes)+3,@nNroFil,@nNroCol)

       @ nNroFil,nNroCol GET cCodigoTes PICT '999999';
			 VALID lCorrecion(@cCodigoTes)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       DO CASE
       CASE VAL(cCodigoTes) == 0

	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT MOR
       DBSETINDEX(fNtxMor)
       IF lBuscar .AND. lSekCodigo(cCodigoTes,'MOR',cMsgTxt)
	  nRegMor := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nRegMor
	  oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MENU DE OTROS PARA EL ARCHIVO                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2001 LUN A
       Colombia, Bucaramanga        INICIO: 05:25 PM   ABR 02/2001 LUN

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrMor(aParam1,aParam2,aParam3,;
		    cEmpCob,oBrowse,cMesIni,;
		    lMorAct,lMorDia,nTotMor)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro
       oBrowse                              // Browse del Archivo
       cMesIni				    // Mes Inicial
       lMorAct                              // Morosos Actual
       lMorDia                              // Mora por Dias
       nTotMor                              // Total Mora */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL cTxtTem := ''                  // Texto Temporal

       LOCAL nOpcion := 0                   // N£mero de la Opci¢n

       LOCAL GetList := {}                  // Variable del Sistema
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO DE DESCUENTOS')
	  CloseDbf('DES',cPatSis+'\'+FileDes,nModCry)
	  CloseDbf('TAR',cPatSis+'\'+FileTar,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>DECLARCION Y EJECUCION DEL MENU
       IF lMorDia

	  aMenus := {'1<CARTERA POR DIAS>'}
	  aAyuda := {'Imprime la Cartera de los diferentes d¡ias.'}

       ELSE
	  aMenus := {}
	  aAyuda := {}
	  AADD(aMenus,'1<INFORME DE LOS MOROSOS  >')
	  AADD(aMenus,'2<CARTA PARA LOS MOROSOS  >')
	  AADD(aMenus,'3<FORMATO DE ACTUALIZACION>')
	  AADD(aMenus,'4<CARTERA POR EDADES      >')
	  AADD(aMenus,'5<VALIDAR PAZ Y SALVOS    >')
	  AADD(aMenus,'6<BLOQUEAR MOROSOS        >')

	  AADD(aAyuda,'Imprime la Relaci¢n de los Morosos')
	  AADD(aAyuda,'Permite Imprimir la Carta para los Estudiantes Morosos')
	  AADD(aAyuda,'Imprime el Formato para Actualizar la Informaci¢n')
	  AADD(aAyuda,'Imprime la relaci¢n de los Morosos de acuerdo a la edad del saldo actual')
	  AADD(aAyuda,'Permite validar los Paz y Salvos Acad‚micos')
	  AADD(aAyuda,'Crea un archivo plano con los c¢digos de estudiantes a bloquear')


	  IF .NOT. lMorAct

	     IF CAA->nNomRepCaA # 0

		IF EMPTY(cEmpCob)
		   cTxtTem := 'CREAR ARCHIVO ASCII'
		ELSE
		   cTxtTem := 'REPORTE A '+cEmpCob
		ENDIF
		cTxtTem := SUBS(cTxtTem+SPACE(24),1,24)

		AADD(aMenus,'6<LECTURA DE LOS MOROSOS  >')
		AADD(aMenus,"7<"+cTxtTem+">")
		AADD(aMenus,'8<MOROSOS REPORTADOS      >')

		AADD(aAyuda,'Permite Leer Nuevamente los Estudiantes Morosos')
		AADD(aAyuda,'Crea el Archivo ASCII con los Estudiantes Morosos')
		AADD(aAyuda,'Imprime la Relaci¢n de los Morosos Reportados')

	     ENDIF
	  ENDIF
	  AADD(aMenus,'9<MOROSOS DETALLADO       >')
	  AADD(aAyuda,'Imprime los Morosos con informaci¢n detallada')
       ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  CloseDbf('DES',cPatSis+'\'+FileDes,nModCry)
	  CloseDbf('TAR',cPatSis+'\'+FileTar,nModCry)
	  RETURN NIL
       ENDIF
       nNroOpc := VAL(SUBS(aMenus[nNroOpc],1,1))
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1

	    OtrMor011(aParam1,aParam2,aParam3,;
		      oBrowse,cMesIni,lMorAct,lMorDia)
	   *Informe de los morosos

       CASE nNroOpc == 2
	    OtrMor022(aParam1,aParam2,aParam3)
	   *Dise¤o de la Carta para los Morosos

       CASE nNroOpc == 3
	    OtrMor033(aParam1,aParam2,aParam3,;
		      oBrowse)
	   *Formato de Actualizaci¢n

       CASE nNroOpc == 4
	    OtrMor044(aParam1,aParam2,aParam3,;
		      oBrowse,.F.,cMesIni,.F.)
	   *Cartera por edades

       CASE nNroOpc == 5
	    OtrMor055(aParam1,aParam2,aParam3,;
		      cEmpCob,oBrowse,cMesIni)
	   *Verificaci¢n de Saldos

       CASE nNroOpc == 6 .AND. lMorAct
	    OtrMor06A(aParam1,aParam2,aParam3,;
		      cEmpCob,oBrowse,cMesIni)
	   *Creaci¢n del archivo ASCII. Morosos

       CASE nNroOpc == 6 .AND. !lMorAct
	    OtrMor066(aParam1,aParam2,aParam3,;
		      oBrowse,.F.,cMesIni,.F.)
	   *Lectura de los morosos

       CASE nNroOpc == 7
	    OtrMor077(aParam1,aParam2,aParam3,;
		      cEmpCob,oBrowse,cMesIni)
	   *Creaci¢n del archivo ASCII

       CASE nNroOpc == 8
	    OtrMor088(aParam1,aParam2,aParam3,;
		      cEmpCob,oBrowse,cMesIni)
	   *Informe de los morosos reportados

       CASE nNroOpc == 9

	    nOpcion := nLeeOpcion('TIPO DE INFORME: '+;
			'1<DETALLADO> 2<RESUMIDO> 3<COLUMNAS>?',3,'0')
	      *Lee la forma de pago

	    DO CASE
	    CASE nOpcion == 1
	       OtrMor099(aParam1,aParam2,aParam3,;
			 oBrowse,cMesIni,lMorAct,lMorDia)
	      *Informe morosos detallado

	    CASE nOpcion == 2
	       OtrMor09B(aParam1,aParam2,aParam3,;
			 oBrowse,cMesIni,lMorAct,lMorDia)
	      *Informe morosos resumido.


	    CASE nOpcion == 3
	       OtrMor09A(aParam1,aParam2,aParam3,;
			 oBrowse,cMesIni,lMorAct,lMorDia)
	      *Informe morosos detallado columna
	    ENDCASE

       ENDCASE
       CloseDbf('DES',cPatSis+'\'+FileDes,nModCry)
       CloseDbf('TAR',cPatSis+'\'+FileTar,nModCry)
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: VALIDA LOS DATOS DE LOS ESTUDIANTES A REPORTAR               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 23/2000 MIE A
       Colombia, Bucaramanga        INICIO: 10:30 PM   FEB 23/2000 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lInfActMor(lShared,cNomSis,cMaeAlu,nNomRep)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomSis                              // Nombre del Sistema
       cMaeAlu                              // Maestros Habilitados
       nNomRep                              // Nombre a Reportar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL lInfAct := .F.                 // .T. Informaci¢n Actualizada
       LOCAL lInfoOk := .F.                 // .T. Informaci¢n Actualicada
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL nNomFac := 0                   // Nombre de la Factura
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       lInfoOk := .T.
       nRegAct := MOR->(RECNO())
       Termometro(0,'REVISANDO LA INFORMACION ACTUALIZADA')
       Termometro(10)
       SELECT MOR
       GO TOP
       DO WHILE .NOT. MOR->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ºNo. '+STR(MOR->(RECNO()),4)+'/'+;
				STR(MOR->(RECCOUNT()),4),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MOR->(RECNO()) / MOR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********BUSQUEDA DEL ESTUDIANTE
	    lInfAct := .T.
	    IF lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct)

	       DO CASE
	       CASE nNomRep == 1  // Padre,Madre,Acudiente

		    nNomFac := &cMaeAct->nNomFacEst
		    DO CASE
		    CASE nNomFac == 0 .OR. nNomFac == 1  // Padre

			 IF EMPTY(&cMaeAct->cApePadEst) .OR.;
			    EMPTY(&cMaeAct->cNomPadEst) .OR.;
			    EMPTY(&cMaeAct->cPadTntEst) .OR.;
			    EMPTY(&cMaeAct->cPadNitEst) .OR.;
			    EMPTY(&cMaeAct->cDireccEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cDireccEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cBarrioEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cBarrioEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cCiudadEst) .OR.;
			    EMPTY(&cMaeAct->cTelefnEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cTelefnEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cCodigoGru) .OR.;
			    EMPTY(&cMaeAct->cApelliEst) .OR.;
			    EMPTY(&cMaeAct->cNombreEst)
			    lInfAct := .F.
			    lInfoOk := .F.
			 ENDIF

		    CASE nNomFac == 2  // Madre

			 IF EMPTY(&cMaeAct->cApeMadEst) .OR.;
			    EMPTY(&cMaeAct->cNomMadEst) .OR.;
			    EMPTY(&cMaeAct->cMadTntEst) .OR.;
			    EMPTY(&cMaeAct->cMadNitEst) .OR.;
			    EMPTY(&cMaeAct->cDireccEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cDireccEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cBarrioEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cBarrioEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cCiudadEst) .OR.;
			    EMPTY(&cMaeAct->cTelefnEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cTelefnEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cCodigoGru) .OR.;
			    EMPTY(&cMaeAct->cApelliEst) .OR.;
			    EMPTY(&cMaeAct->cNombreEst)
			    lInfAct := .F.
			    lInfoOk := .F.
			 ENDIF

		    CASE nNomFac == 3  // Acudiente

			 IF EMPTY(&cMaeAct->cApeAcuEst) .OR.;
			    EMPTY(&cMaeAct->cNomAcuEst) .OR.;
			    EMPTY(&cMaeAct->cAcuTntEst) .OR.;
			    EMPTY(&cMaeAct->cAcuNitEst) .OR.;
			    EMPTY(&cMaeAct->cDireccEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cDireccEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cBarrioEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cBarrioEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cCiudadEst) .OR.;
			    EMPTY(&cMaeAct->cTelefnEst) .OR.;
			    LEN(ALLTRIM(&cMaeAct->cTelefnEst)) == 1 .OR.;
			    EMPTY(&cMaeAct->cCodigoGru) .OR.;
			    EMPTY(&cMaeAct->cApelliEst) .OR.;
			    EMPTY(&cMaeAct->cNombreEst)
			    lInfAct := .F.
			    lInfoOk := .F.
			 ENDIF

		    ENDCASE

	       CASE nNomRep == 2                    // Primer Fiador
	       CASE nNomRep == 3                    // Segundo Fiador
	       ENDCASE

	    ENDIF
**********FIN BUSQUEDA DEL ESTUDIANTE

**********GRABACION DE LA ACTUALIZACION DE LA INFORMACION
	    IF MOR->(lRegLock(lShared,.F.))
	       REPL MOR->lInfActMor WITH lInfAct
	       MOR->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       MOR->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA ACTUALIZACION DE LA INFORMACION

**********AVANCE DEL SIGUIENTE REGISTRO
	    MOR->(DBSKIP())
	    IF MOR->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DE LA INFORMACION ACTUALIZADA
       IF .NOT. lInfoOk
/*
	  cError('LA INFORMACION DE LOS MOROSOS ESTA DESACTUALIZADA',;
		 'FAVOR ACTUALIZAR LOS DATOS DE LOS ESTUDIANTES')
*/
       ENDIF
       nRegAct := MOR->(DBGOTO(nRegAct))
       RETURN lInfoOk
*>>>>FIN VALIDACION DE LA INFORMACION ACTUALIZADA


/*************************************************************************
* TITULO DE LA FUNCION..: MOROSO POR NUMERO DE DEUDAS                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 07/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   AMY 07/96 MAR

OBJETIVOS:

1- Se debe estar ubicado en registro del Cliente y en registro del pago
   respectivo

2- Analiza si un estudiante es moroso de acuerdo a intervalo de decisi¢n
   y el n£mero de meses de atraso.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lMorosoLex(nMesIni,nMesDeu,nTotMes,nVlrInf,nVlrSup)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMesIni                              // Mes Inicial del Pago
       nMesDeu			            // N£mero de Meses de atraso
       nTotMes                              // Total del Meses de atraso
       nVlrInf                              // Valor Inferior
       nVlrSup                              // Valor Superior */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroMes := 0                   // N£mero de Meses Facturados
       LOCAL nTotDeu := 0                   // Saldo Actual
       LOCAL lMoroso := .F.                 // .T. Estudiante moroso
       LOCAL cForPag := ''                  // Forma de pago
       LOCAL nVlrInt := 0
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA DEUDA
       cForPag := RTRIM(CLI->cMesPagCli)
       nNroMes := LEN(cForPag)

       IF (PAG->cEstadoPag == 'D' .AND.;
	   (nMesIni+1 == nNroMes .OR. nMesIni == nNroMes)) .OR.;
	  (PAG->cEstadoPag == 'D' .AND.;
	   (SUBS(cForPag,nNroMes,1) == '*' .AND. nMesIni+1 == nNroMes))

**********VALIDACION DEL VALOR DE LA DEUDA
	    nTotDeu := CLI->nSdoActCli+CLI->nSdoMorCli
	    nVlrInt := nIntMes(PAG->nSdoAntPag+PAG->nVlrMesPag)

	    IF PAG->nVlrPagPag+nVlrInt == nTotDeu


	       IF EMPTY(nVlrSup)
		  lMoroso := nTotDeu >= nVlrInf
	       ELSE
		  lMoroso := nTotDeu >= nVlrInf .AND. nTotDeu <= nVlrSup
	       ENDIF

	       IF lMoroso
		  FOR i := LEN(cForPag) TO 0 STEP -1
		      IF SUBS(cForPag,i,1) == '*' .OR. SUBS(cForPag,i,1) == 'D'
			 IF SUBS(cForPag,i,1) == 'D'
			    nTotMes++
			 ENDIF
		      ELSE
			 EXIT
		      ENDIF
		  ENDFOR

		  IF nTotMes < nMesDeu
		     lMoroso := .F.
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN VALIDACION DEL VALOR DE LA DEUDA
       ENDIF
       RETURN lMoroso
*>>>>FIN ANALISIS DE LA DEUDA

/*************************************************************************
* TITULO..: TOTAL DE LA DEUDA SEGUN ESTUDIANTES MOROSOS                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 26/2001 MIE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   FEB 26/2001 MIE

OBJETIVOS:

1- Calcula el total de la Deuda seg£n los Estudiantes morosos a la Fecha.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDeuActMor()

*>>>>DECLARACION DE VARIABLES
       LOCAL nTotSdo := 0                   // Total del Saldo Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL SALDO ACTUAL A LA FECHA
       SELECT MOR
       GO TOP
       DO WHILE .NOT. MOR->(EOF())
	  nTotSdo += MOR->nSdoActCli+MOR->nSdoMorCli
	  MOR->(DBSKIP())
       ENDDO
       GO TOP
       RETURN nTotSdo
*>>>>FIN CALCULO DEL SALDO ACTUAL A LA FECHA

/*************************************************************************
* TITULO ..: GRABACION DEL SALDO DIARIO                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 26/2001 MIE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   FEB 26/2001 MIE

OBJETIVOS:

1- Graba el saldo de la Cartera del d¡a

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraSdoDia(lShared,nModCry,cPatSis,dFecUsr,nTotMor)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       dFecUsr                              // Fecha del Usuario
       nTotMor  			    // Total Mora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lGrabar := .F.                 // .T. Grabar el Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       FileMor := cPatSis+'\MORADIAS'+ExtFile
       fNtxMor := cPatSis+'\MORADIAS'+cExtNtx
       IF !lUseDbf(.T.,FileMor,'DIA',fNtxMor,lShared,nModCry)
	  cError('GRABANDO LA CARTERA DEL DIA',;
		 'ERROR ABRIENDO EL ARCHIVO')
	  CloseDbf('DIA',FileMor,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>BUSQUEDA DE LA FECHA
       lGrabar := .T.
       IF lSekCodigo(dFecUsr,'DIA')
	  lGrabar := .F.
       ENDIF
*>>>>FIN BUSQUEDA DE LA FECHA

*>>>>GRABACION DE LA DEUDA DIARIA
       SELECT DIA
       IF DIA->(lRegLock(lShared,lGrabar))
	  REPL DIA->dFecUsrMor WITH dFecUsr
	  REPL DIA->nSdoActCli WITH nTotMor
	  DIA->(DBCOMMIT())
       ELSE
	  cError('NO SE PUEDE GRABAR EL REGISTRO')
       ENDIF
       IF lShared
	  DIA->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LA DEUDA DIARIA


/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO RETIRO DE REPORTADOS               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 11/2001 LUN A
       Colombia, Bucaramanga        INICIO: 03:30 PM   JUN 11/2001 LUN

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManRetMor(aParam1,aParam2,aParam3,;
		   cEmpCob)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro */
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

       LOCAL nMesIni := 0                   // Mes Inicial del pago
       LOCAL cMesIni := ''                  // Mes Inicial del pago
       LOCAL lSiLeer := .F.                 // .T. Leer Archivo
       LOCAL lMorDia := .F.                 // .T. Mora por Dias
       LOCAL lProDia := .F.                 // Fecha del Proceso Diario
       LOCAL nTotMor := 0                   // Total de la Mora
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // Codigo del grupo
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
       SET DECIMAL TO
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DEL SISTEMA.')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DEL COLEGIO')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       FileMor := 'RETIMORA'+ExtFile
       fNtxMor := 'RETIMORA'+cExtNtx
       CreaDbfMor(lShared,nModCry,cPatSis+'\COBROS',FileMor)
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF FILE(cPatSis+'\COBROS\'+FileMor)
	  IF nActStrMor(lShared,nModCry,cPatSis+'\COBROS',FileMor) == 1
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

*>>>>LECTURA DEL ARCHIVO DEL ARCHIVO
       OtrMor066(aParam1,aParam2,aParam3,;
		 oBrowse,.T.)
       CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
*>>>>FIN LECTURA DEL ARCHIVO DEL ARCHIVO

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(cPatSis+'\COBROS\'+FileMor)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>VALIDACION DEL ARCHIVO INDICE
       IF !FILE(cPatSis+'\COBROS'+fNtxMor)

***********SELECCION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\COBROS\'+FileMor,'MOR',NIL,lShared,nModCry)
		cError('ABRIENDO EL ARCHIVO DE COBROS')
		CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECCION DE LAS AREAS DE TRABAJO

************INDEXACION DEL ARCHIVO
	      SELECT MOR
	      INDEX ON MOR->cCodigoEst TO &(cPatSis+'\COBROS\'+fNtxMor)
	      CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
************FIN INDEXACION DEL ARCHIVO

       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO INDICE

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\COBROS\'+FileMor,'MOR',IF(lMorDia,;
		       cPatSis+'\COBROS\'+fNtxMor,NIL),lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE COBROS')
	  CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MOR->(RECCOUNT()) == 0
	    cError('NO EXISTEN REPORTADOS A PAZ Y SALVO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT MOR

       oBrowse := oDefRetMor(nFilPal+1,00,22,79,cMaeAlu)
       IF !lMorDia

	  SETKEY(K_F2,{||InfoAlu(nFilPal,1,'MOR',cNomEmp,cNomSis)})

	  SETKEY(K_F3,{||EstadoCta(lShared,nModCry,cNomSis,cNomEmp,;
				   cNomUsr,cAnoUsr,cPatSis,nFilPal,1,;
				   cMaeAct,NIL,.F.,MOR->cCodigoEst,;
				   cMaeAlu,'MOR')})

	  SETKEY(K_F4,{||RelDesEst(lShared,nModCry,cNomSis,cNomEmp,;
				   nFilPal,1,cMaeAct,cPatSis,.F.,;
				   MOR->cCodigoEst,cMaeAlu,'MOR')})

	  SETKEY(K_F5,{||BuscarMor(lShared,oBrowse,cMaeAlu,;
				   cPatSis+'\COBROS\'+fNtxMor)})


	  SETKEY(K_F7,{||lDatosEst(lShared,nFilPal,1,;
				   MOR->cCodigoEst,cMaeAlu,NIL,'MOR')})

       ENDIF

       SETKEY(K_F9,{||MenuOtrRet(aParam1,aParam2,aParam3,;
				 cEmpCob,oBrowse)})
       MOR->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F2,NIL)
       SETKEY(K_F3,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F6,NIL)
       SETKEY(K_F7,NIL)
       SETKEY(K_F9,NIL)

       SET DECIMAL TO 2
       CloseDbf('MOR',cPatSis+'\COBROS\'+FileMor,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE DE RETIRO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 11/2001 LUN A
       Colombia, Bucaramanga        INICIO: 03:45 PM   JUN 11/2001 LUN

OBJETIVOS:

1- Define el objeto Browse

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefRetMor(nFilSup,nColSup,nFilInf,nColInf,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del archivo
       LOCAL cTitSup := ''                  // T¡tulo Superior
       LOCAL cTitInf := ''                  // T¡tulo Inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       cTitSup := '<< REPORTADOS A PAZ Y SALVO >>'
       cTitInf := '<F2>Personal <F3>Pagos <F4>Decuentos '+;
		  '<F7>Actualizar <F5>Buscar <F9>Otros'

       oBrowse:Cargo := {cTitSup,cTitInf}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT MOR
       oColumn := TBCOLUMNNEW('No.', {||TRANS(MOR->(RECNO()),'####')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CODIGO', {||MOR->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NOMBRE DEL;ESTUDIANTE',;
			      {||cSekNomAlu(MOR->cCodigoEst,cMaeAlu,'MOR')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PAGO',{||IF(MOR->lPagRecMor,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('REPORTAR',{||MOR->lSiRepoMor})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MOR'},;
			 {'FIELD','lSiRepoMor'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('REPORTADO',;
			      {||IF(MOR->lHayRepMor,'SI','NO')+;
						    MOR->cHayRepCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('IMPRIMIR CARTA',{||MOR->lCartasMor})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MOR'},;
			 {'FIELD','lCartasMor'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('OBSERVACION',{||MOR->cObservMor})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MOR'},;
			 {'FIELD','cObservMor'}, {'PICTURE','@S40!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

      oColumn := TBCOLUMNNEW('FECHA RETIRO;REPORTE',;
			    {||cFecha(MOR->dFecRetMor)})
      oColumn:Cargo := {{'MODI',.F.}}
      oBrowse:ADDCOLUMN(oColumn)
    *ÀDefinici¢n Columna

      oColumn := TBCOLUMNNEW('MES',{||cMes(MOR->nMesIniPag,3)})
      oColumn:Cargo := {{'MODI',.F.}}
      oBrowse:ADDCOLUMN(oColumn)
    *ÀDefinici¢n Columna

      oColumn := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||MOR->cNomUsrMor})
      oColumn:Cargo := {{'MODI',.F.}}
      oBrowse:ADDCOLUMN(oColumn)
    *ÀDefinici¢n Columna

      oColumn := TBCOLUMNNEW('FECHA DE;PROCESO',;
			     {||cFecha(MOR->dFecUsrMor)})
      oColumn:Cargo := {{'MODI',.F.}}
      oBrowse:ADDCOLUMN(oColumn)
    *ÀDefinici¢n Columna

      oColumn := TBCOLUMNNEW('HORA DE;PROCESO',;
			     {||cHoraSys(MOR->cHorUsrMor)})
      oColumn:Cargo := {{'MODI',.F.}}
      oBrowse:ADDCOLUMN(oColumn)
    *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MENU PARA EL RETIRO DE REPORATOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 11/2001 LUN A
       Colombia, Bucaramanga        INICIO: 03:45 PM   JUN 11/2001 LUN

OBJETIVOS:

1- Menu para el Retiro de Reportaos

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrRet(aParam1,aParam2,aParam3,;
		    cEmpCob,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL cTxtTem := ''                  // Texto Temporal

       LOCAL GetList := {}                  // Variable del Sistema
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO DE DESCUENTOS')
	  CloseDbf('DES',cPatSis+'\'+FileDes,nModCry)
	  CloseDbf('TAR',cPatSis+'\'+FileTar,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>DECLARCION Y EJECUCION DEL MENU
	  aMenus := {}
	  aAyuda := {}
	  AADD(aMenus,'1<INFORME DE LOS RETIROS  >')
	  AADD(aMenus,'2<CARTA DE AUTORIZACION   >')
	  AADD(aMenus,'3<ANEXO A LA CARTA        >')
	  AADD(aMenus,'4<CARTA PARA LOS RETIRADOS>')

	  AADD(aAyuda,'Imprime la Relaci¢n de todos los Retirados')
	  AADD(aAyuda,'Imprime la Carta de Autorizaci¢n de Retiros')
	  AADD(aAyuda,'Imprime el Anexo de las Personas a Retirar')
	  AADD(aAyuda,'Permite Imprimir la Carta para los Retirados')

	  IF CAA->nNomRepCaA # 0

	     IF EMPTY(cEmpCob)
		cTxtTem := 'CREAR ARCHIVO ASCII'
	     ELSE
		cTxtTem := 'REPORTE A '+cEmpCob
	     ENDIF
	     cTxtTem := SUBS(cTxtTem+SPACE(24),1,24)

	     AADD(aMenus,"5<"+cTxtTem+">")
	     AADD(aAyuda,'Crea el Archivo ASCII con los Retiros')

	  ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  CloseDbf('DES',cPatSis+'\'+FileDes,nModCry)
	  CloseDbf('TAR',cPatSis+'\'+FileTar,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Ot1Mor011(aParam1,aParam2,aParam3,;
		      oBrowse)
	   *Informe de los morosos

       CASE nNroOpc == 2
	    Ot1Mor022(aParam1,aParam2,aParam3)
	   *Carta de Autorizaci¢n

       CASE nNroOpc == 3
	    Ot1Mor033(aParam1,aParam2,aParam3,;
		      cEmpCob,oBrowse)
	   *Anexo a la Carta

       CASE nNroOpc == 4
/*
	    Ot1Mor044(aParam1,aParam2,aParam3,;
		      oBrowse) */
	   *Dise¤o de la Carta para los Retirados

       CASE nNroOpc == 5
	    cError('PENDIENTE')
	   *Creaci¢n del archivo ASCII

       ENDCASE
       CloseDbf('DES',cPatSis+'\'+FileDes,nModCry)
       CloseDbf('TAR',cPatSis+'\'+FileTar,nModCry)
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA