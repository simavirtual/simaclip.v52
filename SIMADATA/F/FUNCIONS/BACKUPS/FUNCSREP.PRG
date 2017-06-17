/*                       SIMA - SISTEMA CENTRAL DE RIESGOS
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE REPORTES REPORTmm

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/2004 MAR A
       Colombia, Bucaramanga        INICIO: 04:30 PM   ENE 20/2004 MAR

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfRep(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'cCodigoEst','Character',06,0}) // C¢digo del Estudiante
       AADD(aDbfStr,{'cCodigoGru','Character',04,0}) // C¢digo del Grupo
       AADD(aDbfStr,{'cAnoSisRep','Character',04,0}) // A¤o de la Novedad
       AADD(aDbfStr,{'cVerSisRep','Character',12,0}) // Versi¢n del Sistema
       AADD(aDbfStr,{'nMesRepRep','Numeric'  ,02,0}) // Mes del Reporte
       AADD(aDbfStr,{'cFecPrnRep','Character',08,0}) // Fecha de Corte
       AADD(aDbfStr,{'nMesIniPag','Numeric'  ,02,0}) // Mes Inicial del Pago
       AADD(aDbfStr,{'nMesFinPag','Numeric'  ,02,0}) // Mes Final del Pago
       AADD(aDbfStr,{'nSdoActRep','Numeric'  ,10,2}) // Saldo Actual
       AADD(aDbfStr,{'nSdoMorRep','Numeric'  ,10,2}) // Valor de la Mora
       AADD(aDbfStr,{'cCodigoRep','Character',18,0}) // N£mero de la Cuenta o Obligaci¢n
       AADD(aDbfStr,{'cDocNitRep','Character',11,0}) // N£mero de Identificaci¢n
       AADD(aDbfStr,{'cNombreRep','Character',45,0}) // Nombre Completo del Reportado
       AADD(aDbfStr,{'cFecNacRep','Character',06,0}) // Fecha de Nacimiento
       AADD(aDbfStr,{'cFecApeRep','Character',06,0}) // Fecha de Apertura
       AADD(aDbfStr,{'cFecVtoRep','Character',06,0}) // Fecha de Vencimiento
       AADD(aDbfStr,{'cVlrMenRep','Character',10,0}) // Valor Couta Mensual
       AADD(aDbfStr,{'cNovedaRep','Character',02,0}) // Novedad
       AADD(aDbfStr,{'cAdjetiRep','Character',02,0}) // Adjetivo
       AADD(aDbfStr,{'cTipNitRep','Character',01,0}) // Tipo de Identificaci¢n
       AADD(aDbfStr,{'cVlrIniRep','Character',10,0}) // Valor Inicial
       AADD(aDbfStr,{'cSdoActRep','Character',10,0}) // Valor Saldo Deuda
       AADD(aDbfStr,{'cSdoMorRep','Character',10,0}) // Valor Saldo Mora
       AADD(aDbfStr,{'cVlrDisRep','Character',10,0}) // Valor Disponible
       AADD(aDbfStr,{'cTipMonRep','Character',01,0}) // Tipo de Moneda
       AADD(aDbfStr,{'cTipCtaRep','Character',01,0}) // Tipo de Obligaci¢n
       AADD(aDbfStr,{'cTipGarRep','Character',01,0}) // Tipo de Garantia
       AADD(aDbfStr,{'cCalifiRep','Character',01,0}) // Calificaci¢n
       AADD(aDbfStr,{'cCiuResRep','Character',15,0}) // Ciudad de Residencia
       AADD(aDbfStr,{'cDirResRep','Character',30,0}) // Direcci¢n de Residencia
       AADD(aDbfStr,{'cTelResRep','Character',10,0}) // Telefono de Residencia
       AADD(aDbfStr,{'cCiuTraRep','Character',15,0}) // Ciudad del Trabajo
       AADD(aDbfStr,{'cTelTraRep','Character',10,0}) // Telefono del Trabajo
       AADD(aDbfStr,{'cCiuEnvRep','Character',15,0}) // Ciudad de Correspondencia
       AADD(aDbfStr,{'cDirEnvRep','Character',30,0}) // Direccion de Correspondencia
       AADD(aDbfStr,{'cCoCiiuRep','Character',06,0}) // C¢digo Internacional Industrial Uniforme
       AADD(aDbfStr,{'cTotCouRep','Character',03,0}) // Total Coutas
       AADD(aDbfStr,{'cCouPagRep','Character',03,0}) // Coutas Canceladas
       AADD(aDbfStr,{'cCouMorRep','Character',03,0}) // Coutas en Mora
       AADD(aDbfStr,{'cFecPagRep','Character',08,0}) // Fecha de Pago
       AADD(aDbfStr,{'cNomEmpRep','Character',15,0}) // Oficina de Radicaci¢n
       AADD(aDbfStr,{'cCiuEmpRep','Character',15,0}) // Ciudad de Radicaci¢n
       AADD(aDbfStr,{'cForPagRep','Character',01,0}) // Forma de Pago
       AADD(aDbfStr,{'cPerPagRep','Character',01,0}) // Periocidad de Pago
       AADD(aDbfStr,{'cEdaMorRep','Character',03,0}) // Edad de Mora o Pago Total
       AADD(aDbfStr,{'cFecActRep','Character',08,0}) // Fecha de Actualizaci¢n
       AADD(aDbfStr,{'cReclamRep','Character',01,0}) // Reclamo
       AADD(aDbfStr,{'cResponRep','Character',02,0}) // Responsable
       AADD(aDbfStr,{'cEstratRep','Character',01,0}) // Estrato
       AADD(aDbfStr,{'cFillerRep','Character',14,0}) // Filler
       AADD(aDbfStr,{'nValidoRep','Numeric'  ,02,0}) // Registro valido
       AADD(aDbfStr,{'nVlrPagRep','Numeric'  ,10,2}) // Valor a pagar o pagado
       AADD(aDbfStr,{'nVlrAboRep','Numeric'  ,10,2}) // Valor de los abonos

       AADD(aDbfStr,{'nRegPagRep','Numeric'  ,04,0}) // Registro del Pago
       AADD(aDbfStr,{'cNomUsrPag','Character',10,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrPag','Date'     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrPag','Character',10,0}) // Hora del Usuario

       AADD(aDbfStr,{'nNroCntDaA','Numeric'  ,01,0}) // N£mero de Contratantes a Reportar
       AADD(aDbfStr,{'nTipRepDaA','Numeric'  ,01,0}) // Tipo de Reporte.
       AADD(aDbfStr,{'nValCntDaA','Numeric'  ,01,0}) // Validar Contrantes
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
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
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/2004 MAR A
       Colombia, Bucaramanga        INICIO: 05:20 PM   ENE 20/2004 MAR

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfRep(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfRep(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/2004 MAR A
       Colombia, Bucaramanga        INICIO: 05:25 PM   ENE 20/2004 MAR

OBJETIVOS:

1- Actualiza la Estructura del Archivo

2- Retorna el N£mero de Error:
   0 => No hay Error
	Estructura Actualizada
	Estructura Sin problemas
   1 => Estructura No Actualizada

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrRep(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ACT',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('ACT')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ACT->(DBSTRUCT())
       CloseDbf('ACT')
       CreaDbfRep(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
	  cError('El Archivo '+cNomArc+' su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfRep(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   AGO 05/2004 JUE

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarRep(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			           // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''                  // C¢digo de b£squeda
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigo := cSpaces('REP','cCodigoEst')
       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '@!';
			 VALID lValRepor(ROW(),COL()-3,@cCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigo == cSpaces('REP','cCodigoEst')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT REP
       IF lBuscar .AND. lLocCodigo('cCodigoEst','REP',cCodigo)
	  nNroReg := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nNroReg
	  oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:10 PM   AGO 05/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValRepor(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // C¢digo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF !lLocCodigo('cCodigoEst','REP',cCodigo)
	  nNroReg := nSelRepor(nNroFil,nNroCol)
	  IF nNroReg == 0
	     cCodigo := cSpaces('REP','cCodigoEst')
	  ELSE
	     GO nNroReg
	     cCodigo := REP->cCodigoEst
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:15 PM   AGO 05/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelRepor(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nNroReg := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF REP->(RECCOUNT()) == 0
	  cError('NO EXISTEN FIADORES GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT REP
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CODIGO
       REP->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||REP->cCodigoEst})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CODIGO

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/2004 MAR A
       Colombia, Bucaramanga        INICIO: 05:30 PM   ENE 20/2004 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManDbfRep(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nMesIni)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

       LOCAL oBrowse := NIL                 // Browse
       LOCAL cMesIni := ''                  // Mes Inicial
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+PathSis+'\'+;
			 FSimCar,'SCA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathTre+'\'+cPatSis+'\'+;
			 FileCnt+ExtFile,'CNT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE SIMACONT')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE SIMACART')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE SDA->(RECCOUNT()) == 0
	    cError('NO SE EXISTE CONFIGURACION GENERAL')

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
       IF !lLocCodigo('nCodigoPrn','PRN',SDA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DEL MES
       IF EMPTY(nMesIni)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
				'Mes del Reporte',.T.)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nMesIni == 0
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni,.T.)
*>>>>FIN CAPTURA DEL MES

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       nActStrRep(lShared,nModCry,cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3),;
		  FileRep+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile)
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)+'\'+;
		       FileRep+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile,;
		       'REP',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwDbfRep(lShared,cAnoUsr,nFilPal+1,00,22,79,nMesIni)

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,cMaeAct,cNomEmp,cNomSis,;
			      REP->cCodigoEst,cMaeAlu,'REP',oBrowse)})

       SETKEY(K_F4,{||RelDesEst(lShared,nModCry,cNomSis,cNomEmp,;
				nFilPal,1,NIL,PathDos+'\'+;
				REP->cAnoSisRep+SUBS(cPatSis,5,4),;
				NIL,REP->cCodigoEst,cMaeAlu,'REP')})

       SETKEY(K_F3,{||EstadoCta(lShared,nModCry,cNomSis,cNomEmp,;
				cNomUsr,REP->cAnoSisRep,PathDos+'\'+;
				REP->cAnoSisRep+SUBS(cPatSis,5,4),;
				cJorTxt,nFilPal,1,NIL,NIL,NIL,;
				REP->cCodigoEst,cMaeAlu,'REP',;
				PathUno+'\'+REP->cAnoSisRep+SUBS(cPatSis,5,4),;
				PathDos+'\'+REP->cAnoSisRep+SUBS(cPatSis,5,4))})

       SETKEY(K_F5,{||BuscarRep(oBrowse)})

       SETKEY(K_F9,{||MenuOtrRep(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				 cJorTxt,nMesIni,oBrowse)})

       REP->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F2,NIL)
       SETKEY(K_F3,NIL)
       SETKEY(K_F9,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/2004 MAR A
       Colombia, Bucaramanga        INICIO: 06:00 PM   ENE 20/2004 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwDbfRep(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,nMesIni)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       nMesIni                              // Mes Inicial */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrowse := NIL	            // Browse de Clientes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<< CONFIGURACION DEL A¥O: '+cAnoUsr+' '+;
			     'MES '+cMes(nMesIni)+' >>',;
			     '<F2>Consultas <F3>Pagos <F9>Otros <ENTER>Modificar  '+;
			     '<ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT REP
       oColumn	:= TBCOLUMNNEW('No.',{||REP->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9999'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('REGISTRO;CONFIRMADO',{||REP->nValidoRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO DEL;ESTUDIANTE',;
			       {||REP->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('GRUPO DEL;ESTUDIANTE',;
			       {||REP->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 4
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('A¥O',{||REP->cAnoSisRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9999'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VERSION',{||REP->cVerSisRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES',{||cMes(REP->nMesRepRep,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FECHA DE;CORTE',{||REP->cFecPrnRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES;INI',{||cMes(REP->nMesIniPag,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES;FIN',{||cMes(REP->nMesFinPag,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR PAGADO', {||REP->nVlrPagRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR ABONOS', {||REP->nVlrAboRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NUMERO DE;LA CUENTA',;
			       {||REP->cCodigoRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NUMERO DE;IDENTIFICACION',;
			       {||REP->cDocNitRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NOMBRE DEL;REPORTADO',;
			       {||REP->cNombreRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FECHA DE;NACIMIENTO',;
			       {||REP->cFecNacRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FECHA DE;APERTURA',;
			       {||REP->cFecApeRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FECHA DE;VENCIMIENTO',;
			       {||REP->cFecVtoRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALOR;COUTA MENSUAL',;
			       {||REP->cVlrMenRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NOVEDAD',{||REP->cNovedaRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('ADJETIVO',{||REP->cAdjetiRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TIPO DE;IDENTIFICACION',;
			       {||REP->cTipNitRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALOR INICIAL',;
			       {||REP->cVlrIniRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALOR;SALDO DEUDA',;
			       {||REP->cSdoActRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALOR;SALDO MORA',;
			       {||REP->cSdoMorRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALOR;DEUDA',;
			       {||REP->nSdoActRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALOR;MORA',;
			       {||REP->nSdoMorRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALOR;DISPONIBLE',;
			       {||REP->cVlrDisRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TIPO;DE MONEDA',;
			       {||REP->cTipMonRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TIPO;DE OBLIGACION',;
			       {||REP->cTipCtaRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TIPO;DE GARANTIA',;
			       {||REP->cTipGarRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CALIFICACION',;
			       {||REP->cCalifiRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CIUDAD;DE RESIDENCIA',;
			       {||REP->cCiuResRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('DIRECCION;DE RESIDENCIA',;
			       {||REP->cDirResRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TELEFONO;DE RESIDENCIA',;
			       {||REP->cTelResRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TELEFONO;DEL TRABAJO',;
			       {||REP->cTelTraRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CIUDAD DE;CORRESPONDENCIA',;
			       {||REP->cCiuEnvRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('DIRECCION DE;CORRESPONDENCIA',;
			       {||REP->cDirEnvRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO INTERNACIONAL;INDUSTRIAL UNIFORME',;
			       {||REP->cCoCiiuRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TOTAL;DE COUTAS',;
			       {||REP->cTotCouRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('COUTAS;CANCELADAS',;
			       {||REP->cCouPagRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('COUTAS;EN MORA',;
			       {||REP->cCouMorRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FECHA;DE PAGO',;
			       {||REP->cFecPagRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('OFICINA;DE RADICACION',;
			       {||REP->cNomEmpRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CIUDAD DE;RADICACION',;
			       {||REP->cCiuEmpRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FORMA;DE PAGO',;
			       {||REP->cForPagRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PERIODICIDAD;DE PAGO',{||REP->cPerPagRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('EDAD;DE MORA',{||REP->cEdaMorRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FECHA LIMITE;DE PAGO',;
			       {||REP->cFecActRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('RECLAMO',{||REP->cReclamRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('REPONSABLE',{||REP->cResponRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('ESTRATO',{||REP->cEstratRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FILLER',{||REP->cFillerRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('REGISTRO EN PAGOS',{||REP->nRegPagRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9999'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||REP->cNomUsrPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(REP->dFecUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(REP->cHorUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CONTRATANTES;A REPORTAR',{||REP->nNroCntDaA})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TIPO DE;REPORTE',{||REP->nTipRepDaA})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALIDAR;CONTRATANTES',{||REP->nValCntDaA})
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: NOVEDADES DE LA CARTERA                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 26/2004 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   MAR 26/2004 VIE

OBJETIVOS:

1- Es el comportamiento que tuvo el manejo del cr‚dito durante el curso
   de los d¡as, comprendidos entre la fecha de corte del mes anterior y
   la fecha de corte actual, correspondiente al mes en que se toma la
   informaci¢n para ser enviada a DataCr‚dito.

   Las novedades permitidas para obligaciones de cartera son las sgtes:

   01 => AL DIA.
	 Este c¢digo de novedad se aplica a todas aquellas cuentas
	 u obligaciones que se encuentran al d¡a en sus pagos en el
	 momento de extractar la informaci¢n que es enviada a DataCr‚dito.
	 Fecha de Corte.

   05 => PAGO TOTAL.
	 Pago total de la deuda o cancelaci¢n final de la obligaci¢n.
	 Esta novedad se debe codificar cuando la obligaci¢n haya llegado
	 a su final y su saldo sea igual a cero.

   06 => MORA DE 30 DIAS.
	 Deudor moroso entre 30 y 59 dias. Se codificar  ‚ste n£mero cuando
	 una obligaci¢n presente atraso en sus pagos en el momento del corte
	 en el n£mero de d¡as indicado.

   07 => MORA DE 60 DIAS.
	 Deudor moroso entre 60 y 89 d¡as. Se codificar  ‚ste n£mero cuando
	 una obligaci¢n presente atraso en sus pagos en el momento del corte
	 en el n£mero de d¡as indicado.

   08 => MORA DE 90 DIAS.
	 Deudor moroso entre 90 y 89 d¡as. Se codificar  ‚ste n£mero cuando
	 una obligaci¢n presente atraso en sus pagos en el momento del corte
	 en el n£mero de d¡as indicado.

   09 => MORA DE 120 DIAS O MAS.
	 Deudor moroso de 120 d¡as o m s. Se codificar  ‚ste n£mero cuando
	 una obligaci¢n presente atraso en sus pagos en el momento del corte
	 en el n£mero de d¡as indicado.

   12 => DUDOSO RECAUDO.
	 Cuando a juicio de la entidad, el tiempo de mora de la deuda sea
	 tan alto que haya pasado a ser considerada una deuda cuya
	 probabilidad de recaudo es totalmente dudosa.

   13 => CARTERA CASTAGADA.
	 Se califica en este estado una cuenta cuando la entidad estima que
	 se trata de una deuda incobrable.

   14 => CARTERA RECUPERADA.
	 Cuando la cancelaci¢n final de la deuda se logr¢ por v¡as anormales
	 como cobro judicial, embargo, arreglo entre deudor y acreedor,etc.
	 Normamente se trata de deudas que han pasado por tiempo de mora
	 muy elevado y/o han estado calificadas como dudosos recaudos o
	 carteras castigadas.

2- Para la Calificaci¢n devuelta en la variable 'cCalifi' que es la
   calificaci¢n que se da a las obligaciones de Cartera seg£n el grado
   de cumplimiento de las obligaciones pactadas y de acuerdo con el criterio
   y evaluaci¢n de la entidad. Existen 3 clases de rangos para la
   clasificacion: Cr‚ditos Comerciales, Cr‚ditos de Consumo, Cr‚ditos
   Hipotecarios. PARA ESTE CASO SE ESCOGIO EL RANGO DE CREDITOS COMERCIALES.

3- Para la Edad de Mora o Pago Total devuelta en la variable 'cEdadNo'
   que corresponde a los d¡as de mora que este registrando la obligaci¢n
   en el corte mensual de la informaci¢n que ser  envidada a DataCredito.

4- La anterior documentaci¢n fue obtenidad del manual de Entrega de
   informaci¢n de Cartera entregado por DATACREDITO.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNovedad(cCodEst,nSdoAct,cNovAct,cAnoUsr,nAnoRep,;
		  aDetPag,nMesIni,cCalifi,cEdadNo,nNroMes)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nSdoAct                              // Saldo Actual
       cNovAct                              // Novedad Actual
       cAnoUsr                              // A¤o del Usuario
       nAnoRep                              // A¤o a Reportar
       aDetPag                              // Detalles del Pago
       nMesIni                              // Mes Inicial
       cCalifi                              // @Calificaci¢n
       cEdadNo                              // @Edad de la Novedad
       nNroMes                              // @Meses de Mora */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNotMor := ''                  // Nota del Moroso
       LOCAL cDesCla := ''                  // Descripci¢n de Clasificaci¢n
       LOCAL nVlrMes := 0                   // Valor del Mes
       LOCAL cTipNov := ''                  // Tipo de Novedad. Cartera Castigada.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TOTALIZACION DE LOS CONCEPTOS DEL MES
       IF nSdoAct == 0
	  nNroMes := 0
       ELSE
	  nVlrMes := nVlrMesPro(aDetPag,nMesIni)
	  nNroMes := nSdoAct / nVlrMes
       ENDIF
*>>>>FIN TOTALIZACION DE LOS CONCEPTOS DEL MES

/*
*>>>>ANALISIS DEL A¥O ANTERIOR
       IF nAnoRep < VAL(cAnoUsr)

	  IF nSdoAct # 0
	     cTipNov := '12'                // Dudoso Recaudo
	     cCalifi := 'E'                 // De 361 o m s d¡as
	     cEdadNo := '360'               // Mora de 360
	  ELSE
	     IF cNovAct == '12'
		cTipNov := '14'                // Cartera Recuperada
		cCalifi := 'E'                 // De 361 o m s d¡as
		cEdadNo := '360'               // Mora de 360
	     ELSE
		cTipNov := '01'                // Al Dia
		cCalifi := 'A'                 // De 0 a 30 d¡as
		cEdadNo := '001'               // Al D¡a
	     ENDIF

	  ENDIF
	  RETURN cTipNov
       ENDIF
*>>>>FIN ANALISIS DEL A¥O ANTERIOR
*/



*>>>>ANALISIS DEL TIPO DE MOROSO
       DO CASE
       CASE nNroMes == 0
	    cTipNov := '01'                 // Al D¡a
	    cCalifi := 'A'                  // De 0 a 30 d¡as
	    cEdadNo := '001'                // Al D¡a

       CASE nNroMes > 0  .AND. nNroMes < 2  // Un Mes. Mora 30 D¡as
	    cTipNov := '06'
	    cCalifi := 'A'                  // De 0 a 30 d¡as.
	    cEdadNo := '030'                // Mora 30 d¡as.


       CASE nNroMes >= 2 .AND. nNroMes < 3   // Dos Meses. Mora 60 D¡as
	    cTipNov := '07'
	    cCalifi := 'B'                   // De 31 a 90 d¡as
	    cEdadNo := '060'                 // Mora 60 d¡as

       CASE nNroMes >= 3 .AND. nNroMes < 4   // Tres Meses. Mora 90 D¡as

	    cTipNov := '08'
	    IF nNroMes == 3
	       cCalifi := 'B'                // De 31 a 90 d¡as
	    ELSE
	       cCalifi := 'C'                // De 91 a 180 d¡as
	    ENDIF
	    cEdadNo := '090'                 // Mora 90 d¡as

       CASE nNroMes >= 4                     // Mas de Cuatro Meses. Mora >= 120

	    cTipNov := '09'
	    IF nNroMes <= 6
	       cCalifi := 'C'                // De 91 a 180.
	    ELSE
	       cCalifi := 'D'                // De 181 a 360
	    ENDIF

	    DO CASE
	    CASE nNroMes >= 4 .AND. nNroMes < 5
		 cEdadNo := '120'            // Mora 120 d¡as. 4 Meses

	    CASE nNroMes >= 5 .AND. nNroMes < 6
		 cEdadNo := '150'            // Mora 150 d¡as. 5 Meses

	    CASE nNroMes >= 6 .AND. nNroMes < 7
		 cEdadNo := '180'            // Mora 180 d¡as. 6 Meses

	    CASE nNroMes >= 7 .AND. nNroMes < 8
		 cEdadNo := '210'            // Mora 210 d¡as. 7 Meses

	    CASE nNroMes >= 8 .AND. nNroMes < 9
		 cEdadNo := '240'            // Mora 240 d¡as. 8 Meses

	    CASE nNroMes >= 9 .AND. nNroMes < 10
		 cEdadNo := '270'            // Mora 270 d¡as. 9 Meses

	    CASE nNroMes >= 10 .AND. nNroMes < 11
		 cEdadNo := '300'            // Mora 300 d¡as. 10 Meses

	    CASE nNroMes >= 11  .AND. nNroMes < 12
		 cEdadNo := '330'            // Mora 330 d¡as. 11 Meses

	    CASE nNroMes >= 12  .AND. nNroMes < 13
		 cEdadNo := '360'            // Mora 330 d¡as. 12 Meses

	    ENDCASE
       ENDCASE
       RETURN cTipNov
*>>>>FIN ANALISIS DEL TIPO DE MOROSO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 27/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   JUL 27/2004 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrRep(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		    cJorTxt,nMesIni,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<INFORME DE REPORTADOS>')
       AADD(aMenus,'2<CONSULTAR EL REPORTE >')
       AADD(aMenus,'3<REPORTES POR NOVEDAD >')
       AADD(aMenus,'4<REPORTES POR SUMAS   >')
       AADD(aMenus,'5<REPORTES POR TOTALES >')
       AADD(aMenus,'6<REPORTES POR GRUPOS  >')
       AADD(aMenus,'7<INCONSISTENCIAS      >')
       AADD(aMenus,'8<NOVEDADES CONFIRMADAS>')

       AADD(aAyuda,'Imprime contratantes reportados')
       AADD(aAyuda,'Permite consultar los detalles del Reporte')
       AADD(aAyuda,'Permite consultar los detalles del Reporte por novedad')
       AADD(aAyuda,'Permite imprimir el reporte por sumatoria de novedades')
       AADD(aAyuda,'Permite imprimir el reporte por totales')
       AADD(aAyuda,'Permite imprimir el reporte por grupos')
       AADD(aAyuda,'Permite imprimir las inconsistencias del reporte')
       AADD(aAyuda,'Permite imprimir el total de novedades confirmadas por grupos')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrRep011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,nMesIni,oBrowse)
	   *Impresi¢n de Reportados

       CASE nNroOpc == 2
	    InfoRep(nFilPal,1,cNomEmp,cNomSis)
	   *Consultar el Reporte

       CASE nNroOpc == 3
	    OtrRep013(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,nMesIni,oBrowse)
	   *Reportes por Novedad

       CASE nNroOpc == 4
	    OtrRep014(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,nMesIni,oBrowse)
	   *Reportes por sumatorias de novedad

       CASE nNroOpc == 5
	    OtrRep015(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,nMesIni,oBrowse)
	   *Reportes por sumatorias


       CASE nNroOpc == 6
	    OtrRep016(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,nMesIni,oBrowse)
	   *Reportes grupos


       CASE nNroOpc == 7
	    OtrRep017(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,nMesIni,oBrowse)
	   *Inconsistencias

       CASE nNroOpc == 8
	    OtrRep018(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,nMesIni,oBrowse)
	   *Novedades confirmadas

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:55 PM   JUN 03/2004 JUE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRep011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nMesIni,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'INFORMDE DE REPORTADOS A DATACREDITO',;
		   'MES '+cMes(nMesIni)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       AADD(aNroCol,18) // cCodigoRep : N£mero de la Cuenta o Obligaci¢n
       AADD(aNroCol,06) // cCodigoGru : C¢digo del Grupo
       AADD(aNroCol,12) // cDocNitRep : N£mero de Identificaci¢n
       AADD(aNroCol,04) // cAnoSisRep : 1. A¤o de la Novedad
       AADD(aNroCol,06) // cFecApeRep : 2. Fecha de Apertura
       AADD(aNroCol,06) // cFecVtoRep : 3. Fecha de Vencimiento
       AADD(aNroCol,10) // cVlrMenRep : 4. Valor Couta Mensual
       AADD(aNroCol,02) // cNovedaRep : 5. Novedad
       AADD(aNroCol,02) // cAdjetiRep : 6. Adjetivo
       AADD(aNroCol,02) // cTipNitRep : 7. Tipo de Identificaci¢n
       AADD(aNroCol,10) // cVlrIniRep : 8. Valor Inicial
       AADD(aNroCol,10) // cSdoActRep : 9. Valor Saldo Deuda
       AADD(aNroCol,10) // cSdoMorRep : 10. Valor Saldo Mora
       AADD(aNroCol,10) // cVlrDisRep : 11. Valor Disponible
       AADD(aNroCol,02) // cTipMonRep : 12.Tipo de Moneda
       AADD(aNroCol,02) // cTipCtaRep : 13.Tipo de Obligaci¢n
       AADD(aNroCol,02) // cTipGarRep : 14.Tipo de Garantia
       AADD(aNroCol,02) // cCalifiRep : 15.Calificaci¢n
       AADD(aNroCol,04) // cTotCouRep : 16.Total Coutas
       AADD(aNroCol,04) // cCouPagRep : 17.Coutas Canceladas
       AADD(aNroCol,04) // cCouMorRep : 18.Coutas Reportadas
       AADD(aNroCol,08) // cFecPagRep : 19.Fecha de Pago
       AADD(aNroCol,02) // cForPagRep : 20.Forma de Pago
       AADD(aNroCol,02) // cPerPagRep : 21.Periocidad de Pago
       AADD(aNroCol,04) // cEdaMorRep : 22.Edad de Mora o Pago Total
       AADD(aNroCol,02) // cResponRep : 23.Responsable

       aTitPrn := {'NUMERO CUENTA','GRUPO','DOCUMENTO',;
		   '1','2','3','4','5','6','7','8','9','10',;
		   '11','12','13','14','15','16','17','18','19','20',;
		   '21','22','24'}

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SDA->lPrnArcDat
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'repormes'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SDA->cOpcPrnDat,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LA NOMENCLATURA
       nAvance := 20
       cTxtPrn := '1. A¤o de la Novedad'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '2. Fecha de Apertura'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '3. Fecha de Vencimiento'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '4. Valor Couta Mensual'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '5. Novedad'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '6. Adjetivo'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '7. Tipo de Identificaci¢n'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '8. Valor Inicial'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '9. Valor Saldo Deuda'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '10. Valor Saldo Mora'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '11. Valor Disponible'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '12.Tipo de Moneda'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '13.Tipo de Obligaci¢n'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '14.Tipo de Garantia'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '15.Calificaci¢n'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '16.Total Coutas'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '17.Coutas Canceladas'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '18.Coutas Reportadas'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '19.Fecha de Pago'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '20.Forma de Pago'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '21.Periocidad de Pago'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '22.Edad de Mora o Pago Total'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := '23.Responsable'
       lPrnReg(01,00,SPACE(nAvance)+cTxtPrn,bPagina,bDerAut,bCabeza)

       EJECT
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>IMPRESION DE LA NOMENCLATURA

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT REP
       GO TOP
       DO WHILE .NOT. REP->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( REP->(RECNO()) / REP->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}

	    AADD(aRegPrn,REP->cCodigoRep) // N£mero de la Cuenta o Obligaci¢n
	    AADD(aRegPrn,REP->cCodigoGru) // C¢digo del Grupo
	    AADD(aRegPrn,REP->cDocNitRep) // N£mero de Identificaci¢n
	    AADD(aRegPrn,REP->cAnoSisRep) // 1. A¤o de la Novedad
	    AADD(aRegPrn,REP->cFecApeRep) // 2. Fecha de Apertura
	    AADD(aRegPrn,REP->cFecVtoRep) // 3. Fecha de Vencimiento
	    AADD(aRegPrn,REP->cVlrMenRep) // 4. Valor Couta Mensual
	    AADD(aRegPrn,REP->cNovedaRep) // 5. Novedad
	    AADD(aRegPrn,REP->cAdjetiRep) // 6. Adjetivo
	    AADD(aRegPrn,REP->cTipNitRep) // 7. Tipo de Identificaci¢n
	    AADD(aRegPrn,REP->cVlrIniRep) // 8. Valor Inicial
	    AADD(aRegPrn,REP->cSdoActRep) // 9. Valor Saldo Deuda
	    AADD(aRegPrn,REP->cSdoMorRep) // 10. Valor Saldo Mora
	    AADD(aRegPrn,REP->cVlrDisRep) // 11. Valor Disponible
	    AADD(aRegPrn,REP->cTipMonRep) // 12.Tipo de Moneda
	    AADD(aRegPrn,REP->cTipCtaRep) // 13.Tipo de Obligaci¢n
	    AADD(aRegPrn,REP->cTipGarRep) // 14.Tipo de Garantia
	    AADD(aRegPrn,REP->cCalifiRep) // 15.Calificaci¢n
	    AADD(aRegPrn,REP->cTotCouRep) // 16.Total Coutas
	    AADD(aRegPrn,REP->cCouPagRep) // 17.Coutas Canceladas
	    AADD(aRegPrn,REP->cCouMorRep) // 18.Coutas Reportadas
	    AADD(aRegPrn,REP->cFecPagRep) // 19.Fecha de Pago
	    AADD(aRegPrn,REP->cForPagRep) // 20.Forma de Pago
	    AADD(aRegPrn,REP->cPerPagRep) // 21.Periocidad de Pago
	    AADD(aRegPrn,REP->cEdaMorRep) // 22.Edad de Mora o Pago Total
	    AADD(aRegPrn,REP->cResponRep) // 24.Responsable

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT REP
	    REP->(DBSKIP())
	    IF REP->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: CONSULTA DEL REPORTE                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   FEB 02/96 VIE

OBJETIVOS:

1)- Debe estar en uso el archivo de admisiones en el registro del aspirante

2)- Visualiza la informaci¢n sobre el aspirante

3)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION InfoRep(nFilInf,nColInf,cNomEmp,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     nFilInf                              // Fila de Impresi¢n
       nColInf                              // Columna de Impresi¢n
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>MENU DE ACTUALIZACION
       AADD(aMenus,'1<REPORTE    >')
       AADD(aMenus,'2<CONTRATANTE>')
       AADD(aMenus,'3<FACTURACION>')
       AADD(aMenus,'4<DEUDA      >')
       AADD(aMenus,'5<PAGO       >')

       AADD(aAyuda,'Detalles Generales del Reporte')
       AADD(aAyuda,'Detalles del Contratante Reportado')
       AADD(aAyuda,'Detalles de la Facturaci¢n')
       AADD(aAyuda,'Detalles de la Deuda')
       AADD(aAyuda,'Detalles del Pago')

       nNroOpc := 1
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,'CONSULTAR',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN MENU DE ACTUALIZACION

*>>>>IMPRESION DE LA LINEA DE ESTADO
       cSavPan := SAVESCREEN(0,0,24,79)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,'MANUAL DATACREDITO.'+;
				   'EMISION: ABR 2000 '+;
				   'ACTUALIZACION: FEB 2003 '+;
				   'VERSION: 3.0',22,'°')
       nNroCol := nColInf

       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+REP->cCodigoEst
       @ nNroFil,nNroCol+15 SAY 'CURSO: '+REP->cCodigoGru
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>IMPRSION DE LOS TITULOS
       DO CASE
       CASE nNroOpc == 1

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+00 SAY 'FECHA DE ACTUALIZACION:'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 17'

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'TIPO DE MONEDA        :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 12'

	    @++nNroFil,nNroCol+00 SAY 'TIPO DE OBLIGACION    :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 12'

	    @++nNroFil,nNroCol+00 SAY 'TIPO DE GARANTIA      :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 13'

	    @++nNroFil,nNroCol+00 SAY 'TOTAL DE COUTAS       :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 15'

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'OFICINA DE RADICACION :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 15'

	    @++nNroFil,nNroCol+00 SAY 'CODIGO CIIU           :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 14'

	    @++nNroFil,nNroCol+00 SAY 'RECLAMO               :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 17'

       CASE nNroOpc == 2

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+00 SAY 'NOMBRE: '
	    @nNroFil++,nNroCol+55 SAY 'REPONSABLE:'

	    @++nNroFil,nNroCol+00 SAY 'DOCUMENTO:'
	    @nNroFil  ,nNroCol+24 SAY 'TIPO:'
	    @nNroFil  ,nNroCol+32 SAY 'FECHA NACIMIENTO:'
	    @nNroFil++,nNroCol+57 SAY 'ESTRATO:'

	    @++nNroFil,nNroCol+00 SAY 'DIRECCION RESIDENCIA:'
	    @nNroFil  ,nNroCol+36 SAY 'CIUDAD:'
	    @nNroFil++,nNroCol+54 SAY 'TELEFONO:'

	    nNroFil++
	    @++nNroFil  ,nNroCol+00 SAY 'CIUDAD LABORAL:'
	    @nNroFil++  ,nNroCol+36 SAY 'TELEFONO LABORAL:'

	    @++nNroFil,nNroCol+00 SAY 'DIRECCION CORRESPONDENCIA:'
	    @nNroFil++,nNroCol+36 SAY 'CIUDAD CORRESPONDENCIA:'

       CASE nNroOpc == 3

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+00 SAY 'FECHA DE APERTURA   :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 08'

	    @++nNroFil,nNroCol+00 SAY 'FECHA DE VENCIMIENTO:'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 08'

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'VALOR INICIAL       :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 11'

	    @++nNroFil,nNroCol+00 SAY 'VALOR COUTA MENSUAL :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 08'

	    @++nNroFil,nNroCol+00 SAY 'VALOR DISPONIBLE    :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 12'

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'PERIOCIDAD DEL PAGO :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 16'

       CASE nNroOpc == 4

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+00 SAY 'NOVEDAD          :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 09'

	    @++nNroFil,nNroCol+00 SAY 'ADJETIVO         :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 10'

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'VALOR SALDO DEUDA:'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 11'

	    @++nNroFil,nNroCol+00 SAY 'VALOR SALDO MORA :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 11'

	    @++nNroFil,nNroCol+00 SAY 'CALIFICACION     :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 13'

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'COUTAS EN MORA   :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 15'

	    @++nNroFil,nNroCol+00 SAY 'EDAD DE LA MORA  :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 17'

       CASE nNroOpc == 5

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+00 SAY 'NOVEDAD          :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 09'

	    @++nNroFil,nNroCol+00 SAY 'ADJETIVO         :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 10'

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'FECHA DE PAGO    :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 15'

	    @++nNroFil,nNroCol+00 SAY 'FORMA DE PAGO    :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 16'

	    @++nNroFil,nNroCol+00 SAY 'CALIFICACION     :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 13'

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'COUTAS CANCELADAS:'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 15'

	    @++nNroFil,nNroCol+00 SAY 'PAGO TOTAL       :'
	    @nNroFil  ,nNroCol+50 SAY 'Pag No. 17'

       ENDCASE
*>>>>FIN IMPRSION DE LOS TITULOS

*>>>>IMPRESION DE LOS DATOS
       SET COLOR TO I
       DO CASE
       CASE nNroOpc == 1

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+24 SAY REP->cFecActRep

	    nNroFil++
	    @++nNroFil,nNroCol+24 SAY REP->cTipMonRep
	    @++nNroFil,nNroCol+24 SAY REP->cTipCtaRep
	    @++nNroFil,nNroCol+24 SAY REP->cTipGarRep
	    @++nNroFil,nNroCol+24 SAY REP->cTotCouRep

	    nNroFil++
	    @++nNroFil,nNroCol+24 SAY REP->cNomEmpRep
	    @++nNroFil,nNroCol+24 SAY REP->cCoCiiuRep
	    @++nNroFil,nNroCol+24 SAY REP->cReclamRep

       CASE nNroOpc == 2

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+09 SAY REP->cNombreRep
	    @nNroFil++,nNroCol+67 SAY REP->cResponRep

	    @++nNroFil,nNroCol+11 SAY REP->cDocNitRep
	    @nNroFil  ,nNroCol+30 SAY REP->cTipNitRep
	    @nNroFil  ,nNroCol+50 SAY REP->cFecNacRep
	    @nNroFil++,nNroCol+66 SAY REP->cEstratRep

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY REP->cDirResRep
	    @nNroFil  ,nNroCol+36 SAY REP->cCiuResRep
	    @nNroFil++,nNroCol+54 SAY REP->cTelResRep

	    @++nNroFil,nNroCol+16 SAY REP->cCiuTraRep
	    @nNroFil++,nNroCol+54 SAY REP->cTelTraRep

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY REP->cDirEnvRep
	    @nNroFil++,nNroCol+36 SAY REP->cCiuEnvRep

       CASE nNroOpc == 3

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+22 SAY REP->cFecApeRep
	    @++nNroFil,nNroCol+22 SAY REP->cFecVtoRep

	    nNroFil++
	    @++nNroFil,nNroCol+22 SAY REP->cVlrIniRep
	    @++nNroFil,nNroCol+22 SAY REP->cVlrMenRep
	    @++nNroFil,nNroCol+22 SAY REP->cVlrDisRep

	    nNroFil++
	    @++nNroFil,nNroCol+22 SAY REP->cPerPagRep

       CASE nNroOpc == 4

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+19 SAY REP->cNovedaRep
	    @++nNroFil,nNroCol+19 SAY REP->cAdjetiRep

	    nNroFil++
	    @++nNroFil,nNroCol+19 SAY REP->cSdoActRep
	    @++nNroFil,nNroCol+19 SAY REP->cSdoMorRep
	    @++nNroFil,nNroCol+19 SAY REP->cCalifiRep

	    nNroFil++
	    @++nNroFil,nNroCol+19 SAY REP->cCouMorRep
	    @++nNroFil,nNroCol+19 SAY REP->cEdaMorRep

       CASE nNroOpc == 5

	    nNroFil := nFilInf+6
	    @nNroFil  ,nNroCol+19 SAY REP->cNovedaRep
	    @++nNroFil,nNroCol+19 SAY REP->cAdjetiRep

	    nNroFil++
	    @++nNroFil,nNroCol+19 SAY REP->cFecPagRep
	    @++nNroFil,nNroCol+19 SAY REP->cForPagRep
	    @++nNroFil,nNroCol+19 SAY REP->cCalifiRep

	    nNroFil++
	    @++nNroFil,nNroCol+19 SAY REP->cCouPagRep
	    @++nNroFil,nNroCol+19 SAY REP->cEdaMorRep

       ENDCASE
       SET COLOR TO

       cPausa()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DATOS

/*************************************************************************
* TITULO..: REPORTES POR NOVEDAD                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 17/2005 VIE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   AGO 17/2005 VIE

OBJETIVOS:

1- Imprime los reportes por c¢digo de novedad.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRep013(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nMesIni,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL aTitulo := {}                  // T¡tulos para impresion
       LOCAL cCodNov := ''                  // C¢digo de la novedad
       LOCAL aCodNov := {}
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL nContar := 0                   // Contador

       LOCAL cGruAnt := ''                  // C¢digo Anterior
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL lValVal := .F.                 // .T. Validar los Valores
       LOCAL nVlrRep := 0                   // Valor del Reporte
       LOCAL nVlrTot := 0                   // Valor Total
       LOCAL nTotNov := 0                   // Total Novedad
       LOCAL aVlrRep := {}                  // Total valores del reporte clasificados
       LOCAL cAnoRep := ''                  // A¤o del reporte

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la Columna

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL dFecPagTpa := CTOD('00/00/00') // Fecha de pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL A¥O DEL REPORTE
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       cAnoRep := STR(YEAR(DATE()),4)
       TitBuscar(14,@nNroFil,@nNroCol,'A¥O','INGRESE EL A¥O')
       @ nNroFil,nNroCol GET cAnoRep PICT '9999'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(cAnoRep)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL A¥O DEL REPORTE

*>>>>MENU DE ACTUALIZACION
       AADD(aMenus,'1<AL DIA            :01>')
       AADD(aMenus,'2<PAGO TOTAL        :05>')
       AADD(aMenus,'3<MORA DE 30 DIAS   :06>')
       AADD(aMenus,'4<MORA DE 60 DIAS   :07>')
       AADD(aMenus,'5<MORA DE 90 DIAS   :08>')
       AADD(aMenus,'6<MORA >=120 DIAS   :09>')
       AADD(aMenus,'7<DUDOSO RECAUDO    :12>')
       AADD(aMenus,'8<CARTERA CASTIGADA :13>')
       AADD(aMenus,'9<CARTERA RECUPERADA:14>')
       AADD(aMenus,'10<MOROSOS             >')

       AADD(aAyuda,'Imprime los reportes con novedad 01')
       AADD(aAyuda,'Imprime los reportes con novedad 05')
       AADD(aAyuda,'Imprime los reportes con novedad 06')
       AADD(aAyuda,'Imprime los reportes con novedad 07')
       AADD(aAyuda,'Imprime los reportes con novedad 08')
       AADD(aAyuda,'Imprime los reportes con novedad 09')
       AADD(aAyuda,'Imprime los reportes con novedad 12')
       AADD(aAyuda,'Imprime los reportes con novedad 13')
       AADD(aAyuda,'Imprime los reportes con novedad 14')
       AADD(aAyuda,'Imprime los reportes con novedades de morosidad')

       nNroOpc := 1
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,08,25,'IMPRIMIR',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
       aCodNov := {'01','05','06','07','08','09','12','13','14',''}
       cCodNov := aCodNov[nNroOpc]

       lValVal := lPregunta('DESEA VALIDAR LOS VALORES DE LA NOVEDAD? Si No')
*>>>>FIN MENU DE ACTUALIZACION

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'INFORME DE REPORTADOS A DATACREDITO',;
		   'MES '+cMes(nMesIni)+'. NOVEDAD='+cCodNov}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,06,04,04,04,04,04,18,18,12}

       aTitPrn := {'No.','CODIGO','GRUPO','A¥O','MES',;
		   'INI','FIN','NOV','CUENTA','DOCUMENTO','VALOR'}

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SDA->lPrnArcDat
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'repornov'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SDA->cOpcPrnDat,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)

       cCodAnt := '1'
     *ÀInicializaci¢n para garantizar c¢digo diferente

       SELECT REP
       REP->(DBGOTOP())
       cGruAnt := REP->cCodigoGru
       DO WHILE .NOT. REP->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('MES : '+cMes(REP->nMesRepRep,3)+;
			'ºGRUPO: '+REP->cCodigoGru+;
			'ºCUENTA: '+REP->cCodigoRep+;
			'ºNo. '+STR(REP->(RECNO()),4)+'/'+;
				STR(REP->(RECCOUNT()),4),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VALIDACION DEL A¥O
	    IF REP->cAnoSisRep # cAnoRep
	       SELECT REP
	       REP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL A¥O

**********ANALISIS DE LA NOVEDAD
	    IF !EMPTY(cCodNov)
	       IF REP->cNovedaRep # cCodNov
		  SELECT REP
		  REP->(DBSKIP())
		  LOOP
	       ENDIF
	    ELSE
	       IF REP->cNovedaRep == '01' .OR. REP->cNovedaRep == '05'
		  SELECT REP
		  REP->(DBSKIP())
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE LA NOVEDAD

**********VALIDACION DEL CODIGO
	    IF lValVal

	       IF REP->cCodigoEst == cCodAnt

		  cGruAnt := REP->cCodigoGru
		  cCodAnt := REP->cCodigoEst
		  SELECT REP
		  REP->(DBSKIP())
		  LOOP

	       ENDIF
	    ENDIF
**********FIN VALIDACION DEL CODIGO

**********TOTAL DE LA NOVEDAD
	    IF REP->cNovedaRep == '01' .OR. REP->cNovedaRep == '05'
	       nVlrRep := REP->nVlrPagRep+REP->nVlrAboRep
	    ELSE
	       nVlrRep := REP->nSdoActRep+REP->nSdoMorRep
	    ENDIF
	    nVlrTot += nVlrRep

	    IF cGruAnt == REP->cCodigoGru
	       nTotNov += nVlrRep
	    ENDIF
**********FIN TOTAL DE LA NOVEDAD

**********CLASIFICACION DE LOS PAGOS
	    dFecPagTpa := CTOD(SUBS(REP->cFecPagRep,5,2)+'/'+;
				SUBS(REP->cFecPagRep,7,2)+'/'+;
				SUBS(REP->cFecPagRep,1,4))
	    DO CASE
	    CASE REP->cNovedaRep == '01'
		 aVlrPagos(dFecPagTpa,;
			   nVlrRep,@aVlrRep,1)  // Pago de Recibos

	    CASE REP->cNovedaRep == '05' .AND. !EMPTY(dFecPagTpa)
		 aVlrPagos(dFecPagTpa,;
			   nVlrRep,@aVlrRep,1)  // Pago de Recibos

	    CASE REP->cNovedaRep == '05' .AND. EMPTY(dFecPagTpa)
		 aVlrPagos(dFecPagTpa,;
			   nVlrRep,@aVlrRep,2)  // Abonos

	    ENDCASE
**********FIN CLASIFICACION DE LOS PAGOS

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}

	    AADD(aRegPrn,STR(++nContar,4)) // Contador
	    AADD(aRegPrn,REP->cCodigoEst)  // C¢digo del Estudiante
	    AADD(aRegPrn,REP->cCodigoGru)  // C¢digo del Grupo
	    AADD(aRegPrn,REP->cAnoSisRep)  // A¤o de la Novedad

	    AADD(aRegPrn,cMes(REP->nMesRepRep,3)) // Mes del Reporte
	    AADD(aRegPrn,cMes(REP->nMesIniPag,3)) // Mes Inicial del Pago
	    AADD(aRegPrn,cMes(REP->nMesFinPag,3)) // Mes Final del Pago
	    AADD(aRegPrn,REP->cNovedaRep)         // Novedad

	    AADD(aRegPrn,REP->cCodigoRep) // N£mero de la Cuenta o Obligaci¢n
	    AADD(aRegPrn,REP->cDocNitRep) // N£mero de Identificaci¢n

	    AADD(aRegPrn,TRANS(nVlrRep,"####,###,###")) // Valor

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
*	    cGruAnt := REP->cCodigoGru
	    cCodAnt := REP->cCodigoEst
	    SELECT REP
	    REP->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

/*

**********IMPRESION DEL REGISTRO
	    IF cGruAnt # REP->cCodigoGru

	       aRegPrn := {}

	       AADD(aRegPrn,'') // Contador
	       AADD(aRegPrn,'')  // C¢digo del Estudiante
	       AADD(aRegPrn,REP->cCodigoGru)  // C¢digo del Grupo
	       AADD(aRegPrn,REP->cAnoSisRep)  // A¤o de la Novedad

	       AADD(aRegPrn,cMes(REP->nMesRepRep,3)) // Mes del Reporte
	       AADD(aRegPrn,'') // Mes Inicial del Pago
	       AADD(aRegPrn,'') // Mes Final del Pago
	       AADD(aRegPrn,'')         // Novedad

	       AADD(aRegPrn,'') // N£mero de la Cuenta o Obligaci¢n
	       AADD(aRegPrn,'') // N£mero de Identificaci¢n

	       AADD(aRegPrn,TRANS(nTotNov,"####,###,###")) // Valor

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	       nTotNov := 0

	    ENDIF
**********FIN IMPRESION DEL REGISTRO

*/

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,11) SAY REPL('-',aNroCol[11])
       @ PROW()+1,00 SAY 'TOTAL'
       @ PROW()  ,nColTxt(aNroCol,11) SAY TRANS(nVlrTot,"####,###,###")
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DEL TOTALES POR MESES
       aNroCol := {}
       aTitulo := {}
       IF nSuma(aVlrRep,3) # 0
	  AADD(aTitulo,'RECIBOS')
	  AADD(aNroCol,16)
       ENDIF

       IF nSuma(aVlrRep,4) # 0
	  AADD(aTitulo,'ABONOS')
	  AADD(aNroCol,16)
       ENDIF

       IF nSuma(aVlrRep,5) # 0
	  AADD(aTitulo,'P PARCIALES')
	  AADD(aNroCol,16)
       ENDIF
       AADD(aTitulo,'TOTALES')
       AADD(aNroCol,16)

       cTxtPrn := 'GRANDES TOTALES '+cRegPrint(aTitulo,aNroCol)
       lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       FOR i := 1 TO LEN(aVlrRep)

	   aTitulo := {}
	   aTitPrn := {}
	   AADD(aTitPrn,STR(aVlrRep[i][1],4)+' '+;
			cMes(aVlrRep[i][2],3))

	   IF nSuma(aVlrRep,3) # 0
	      AADD(aTitulo,TRANS(aVlrRep[i][3],"####,###,###")) // Recibos
	      AADD(aTitPrn,TRANS(aVlrRep[i][3],"####,###,###")) // Recibos
	   ENDIF

	   IF nSuma(aVlrRep,4) # 0
	      AADD(aTitulo,TRANS(aVlrRep[i][4],"####,###,###")) // Abonos
	      AADD(aTitPrn,TRANS(aVlrRep[i][4],"####,###,###")) // Abonos
	   ENDIF

	   IF nSuma(aVlrRep,5) # 0
	      AADD(aTitulo,TRANS(aVlrRep[i][5],"####,###,###")) // Pagos Parciales
	      AADD(aTitPrn,TRANS(aVlrRep[i][5],"####,###,###")) // Pagos Parciales
	   ENDIF
	   AADD(aTitulo,TRANS(aVlrRep[i][3]+aVlrRep[i][4]+;
			      aVlrRep[i][5],"####,###,###")) // Totales
	   AADD(aTitPrn,TRANS(aVlrRep[i][3]+aVlrRep[i][4]+;
			      aVlrRep[i][5],"####,###,###")) // Totales

	   cTxtPrn := STR(aVlrRep[i][1],4)+' '+;
		      cMes(aVlrRep[i][2],3)+SPACE(08)+;
		      cRegPrint(aTitulo,aNroCol)

	   lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       ENDFOR


       aTitulo := {}
       aTitPrn := {}
       AADD(aTitPrn,'TOTALES')

       IF nSuma(aVlrRep,3) # 0
	  AADD(aTitulo,TRANS(nSuma(aVlrRep,3),"####,###,###")) // Recibos
	  AADD(aTitPrn,TRANS(nSuma(aVlrRep,3),"####,###,###")) // Recibos
       ENDIF

       IF nSuma(aVlrRep,4) # 0
	  AADD(aTitulo,TRANS(nSuma(aVlrRep,4),"####,###,###")) // Abonos
	  AADD(aTitPrn,TRANS(nSuma(aVlrRep,4),"####,###,###")) // Abonos
       ENDIF

       IF nSuma(aVlrRep,5) # 0
	  AADD(aTitulo,TRANS(nSuma(aVlrRep,5),"####,###,###")) // Pagos Parciales
	  AADD(aTitPrn,TRANS(nSuma(aVlrRep,5),"####,###,###")) // Pagos Parciales
       ENDIF
       AADD(aTitulo,TRANS(nSuma(aVlrRep,3)+nSuma(aVlrRep,4)+;
			  nSuma(aVlrRep,5),"####,###,###")) // Totales
       AADD(aTitPrn,TRANS(nSuma(aVlrRep,3)+nSuma(aVlrRep,4)+;
			  nSuma(aVlrRep,5),"####,###,###")) // Totales

       cTxtPrn := 'TOTALES         '+cRegPrint(aTitulo,aNroCol)

       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DEL TOTALES POR MESES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: REPORTES POR SUMAS                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/2006 MIE A
       Colombia, Bucaramanga        INICIO: 10:15 PM   MAR 08/2006 MIE

OBJETIVOS:

1- Imprime los totales de cada novedad.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRep014(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nMesIni,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL   i,j,k := 0                   // Contador
       LOCAL aTotPrn := {}                  // Total registros de Impresi¢n
       LOCAL cCodAnt := ''                  // C¢digo Anterior

       LOCAL aRepo01 := {}                  // Al d¡a
       LOCAL aRepo05 := {}                  // Pago Total
       LOCAL aTotPag := {}                  // Total Pagos

       LOCAL nVlrPag := 0                   // Valor Pagado
       LOCAL nVlrMor := 0                   // Valor en mora
       LOCAL nTotSdo := 0                   // Saldo total
       LOCAL nTotAno := 0                   // Total A¤o
       LOCAL nTotPag := 0                   // Total pagos
       LOCAL aNoveda[14]                    // Total de las novedades
       LOCAL aMorAno := {}                  // Mora por a¤os.
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL dFecPagTpa := CTOD('00/00/00') // Fecha de pago
*>>>>FIN DECLARACION DE VARIABLES

LOCAL nTot := 0
LOCAL nVlr := 0

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'VALIDACION DEL REPORTE A DATACREDITO',;
		   'MES '+cMes(nMesIni)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,30)
       AADD(aTitPrn,'DESCRIPCION')

       AADD(aNroCol,16)
       AADD(aTitPrn,'TOTALES')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SDA->lPrnArcDat
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'valrep'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SDA->cOpcPrnDat,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       cCodAnt := '1'
     *ÀInicializaci¢n para garantizar c¢digo diferente

       AFILL(aNoveda,0)
       SELECT REP
       REP->(DBGOTOP())
       DO WHILE .NOT. REP->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( REP->(RECNO()) / REP->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********SUMATORIA POR LA NOVEDAD
	    IF REP->cCodigoEst # cCodAnt

	       nVlrPag := REP->nVlrPagRep
	       nVlrMor := REP->nSdoActRep+REP->nSdoMorRep

	       dFecPagTpa := CTOD(SUBS(REP->cFecPagRep,5,2)+'/'+;
				   SUBS(REP->cFecPagRep,7,2)+'/'+;
				   SUBS(REP->cFecPagRep,1,4))

	       DO CASE
	       CASE REP->cNovedaRep == '01'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrPag

		    aVlrPagos(dFecPagTpa,;
			      nVlrPag,@aRepo01,1)  // Pago de Recibos

		    aVlrPagos(dFecPagTpa,;
			      nVlrPag,@aTotPag,1)  // Total pagos

	       CASE REP->cNovedaRep == '05'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrPag

		    IF EMPTY(dFecPagTpa)
		       aVlrPagos(dFecPagTpa,;
				 nVlrPag,@aRepo05,2)  // Abonos
		    ELSE
		       aVlrPagos(dFecPagTpa,;
				 nVlrPag,@aRepo05,1)  // Pagos de Recibos
		    ENDIF

		    aVlrPagos(dFecPagTpa,;
			      nVlrPag,@aTotPag,1)  // Total pagos

	       CASE REP->cNovedaRep == '06'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrMor

		    k := ASCAN(aMorAno,{|aArr|aArr[1] == REP->cAnoSisRep})
		    IF k == 0
		       AADD(aMorAno,{REP->cAnoSisRep,0})   // A¤o,Mora
		       aMorAno[LEN(aMorAno),2] := nVlrMor
		    ELSE
		       aMorAno[k,2] += nVlrMor
		    ENDIF
		  *ÀMora por a¤os

	       CASE REP->cNovedaRep == '07'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrMor

		    k := ASCAN(aMorAno,{|aArr|aArr[1] == REP->cAnoSisRep})
		    IF k == 0
		       AADD(aMorAno,{REP->cAnoSisRep,0})   // A¤o,Mora
		       aMorAno[LEN(aMorAno),2] := nVlrMor
		    ELSE
		       aMorAno[k,2] += nVlrMor
		    ENDIF
		  *ÀMora por a¤os

	       CASE REP->cNovedaRep == '08'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrMor

		    k := ASCAN(aMorAno,{|aArr|aArr[1] == REP->cAnoSisRep})
		    IF k == 0
		       AADD(aMorAno,{REP->cAnoSisRep,0})   // A¤o,Mora
		       aMorAno[LEN(aMorAno),2] := nVlrMor
		    ELSE
		       aMorAno[k,2] += nVlrMor
		    ENDIF
		  *ÀMora por a¤os

	       CASE REP->cNovedaRep == '09'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrMor

		    k := ASCAN(aMorAno,{|aArr|aArr[1] == REP->cAnoSisRep})
		    IF k == 0
		       AADD(aMorAno,{REP->cAnoSisRep,0})   // A¤o,Mora
		       aMorAno[LEN(aMorAno),2] := nVlrMor
		    ELSE
		       aMorAno[k,2] += nVlrMor
		    ENDIF
		  *ÀMora por a¤os

	       CASE REP->cNovedaRep == '12'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrMor

		    k := ASCAN(aMorAno,{|aArr|aArr[1] == REP->cAnoSisRep})
		    IF k == 0
		       AADD(aMorAno,{REP->cAnoSisRep,0})   // A¤o,Mora
		       aMorAno[LEN(aMorAno),2] := nVlrMor
		    ELSE
		       aMorAno[k,2] += nVlrMor
		    ENDIF
		  *ÀMora por a¤os

	       CASE REP->cNovedaRep == '13'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrMor

		    k := ASCAN(aMorAno,{|aArr|aArr[1] == REP->cAnoSisRep})
		    IF k == 0
		       AADD(aMorAno,{REP->cAnoSisRep,0})   // A¤o,Mora
		       aMorAno[LEN(aMorAno),2] := nVlrMor
		    ELSE
		       aMorAno[k,2] += nVlrMor
		    ENDIF
		  *ÀMora por a¤os

	       CASE REP->cNovedaRep == '14'

		    aNoveda[VAL(REP->cNovedaRep)] += nVlrMor

		    k := ASCAN(aMorAno,{|aArr|aArr[1] == REP->cAnoSisRep})
		    IF k == 0
		       AADD(aMorAno,{REP->cAnoSisRep,0})   // A¤o,Mora
		       aMorAno[LEN(aMorAno),2] := nVlrMor
		    ELSE
		       aMorAno[k,2] += nVlrMor
		    ENDIF
		  *ÀMora por a¤os

	       ENDCASE
	    ENDIF
**********FIN SUMATORIA POR LA NOVEDAD

/*
IF REP->cAnoSisRep  == '2007' .AND. REP->nSdoActRep+REP->nSdoMorRep # 0
   nVlr := REP->nSdoActRep+REP->nSdoMorRep
   nTot += nVlr
   @ PROW()+1,00 SAY REP->cCodigoEst+'='+;
		     STR(nVlr,10,2)
ENDIF
*/

**********AVANCE DEL SIGUIENTE REGISTRO
	    cCodAnt := REP->cCodigoEst
	    SELECT REP
	    REP->(DBSKIP())
	    IF REP->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

IF nTot # 0
   @ PROW()+1,00 SAY 'TOTAL='+STR(nTot,14,2)
ENDIF

*>>>>IMPRESION DEL REGISTRO
       aTotPrn := {}


       nTotPag += aNoveda[1]
       FOR i := 1 TO LEN(aRepo01)
	   AADD(aTotPrn,{STR(aRepo01[i][1],4)+' '+cMes(aRepo01[i][2],3),;
			 TRANS(aRepo01[i][3],"####,###,###")})
       ENDFOR
       AADD(aTotPrn,{'',REPL('-',12)})
       AADD(aTotPrn,{'AL DIA',TRANS(aNoveda[1],"####,###,###")})
       AADD(aTotPrn,{'',''})


       nTotPag += aNoveda[5]

       FOR i := 1 TO LEN(aRepo05)
	   AADD(aTotPrn,{STR(aRepo05[i][1],4)+' '+cMes(aRepo05[i][2],3),;
			 TRANS(aRepo05[i][3],"####,###,###")})
       ENDFOR
       AADD(aTotPrn,{'',REPL('-',12)})
       AADD(aTotPrn,{'PAGO TOTAL',TRANS(aNoveda[5],"####,###,###")})


       AADD(aTotPrn,{'',REPL('=',12)})
       AADD(aTotPrn,{'TOTAL PAGOS',TRANS(nTotPag,"####,###,###")})

       FOR i := 1 TO LEN(aTotPag)
	   AADD(aTotPrn,{STR(aTotPag[i][1],4)+' '+cMes(aTotPag[i][2],3),;
			 TRANS(aTotPag[i][3],"####,###,###")})
       ENDFOR

       AADD(aTotPrn,{'',''})


       AADD(aTotPrn,{'MORA DE 30 DIAS',TRANS(aNoveda[6],"####,###,###")})
       nTotSdo += aNoveda[6]

       AADD(aTotPrn,{'MORA DE 60 DIAS',TRANS(aNoveda[7],"####,###,###")})
       nTotSdo += aNoveda[7]

       AADD(aTotPrn,{'MORA DE 90 DIAS',TRANS(aNoveda[8],"####,###,###")})
       nTotSdo += aNoveda[8]

       AADD(aTotPrn,{'MORA DE 120 DIAS O MAS',TRANS(aNoveda[9],"####,###,###")})
       nTotSdo += aNoveda[9]

       AADD(aTotPrn,{'DUDOSO RECAUDO',TRANS(aNoveda[12],"####,###,###")})
       nTotSdo += aNoveda[12]

       AADD(aTotPrn,{'CARTERA CASTIGADA',TRANS(aNoveda[13],"####,###,###")})
       nTotSdo += aNoveda[13]

       AADD(aTotPrn,{'CARTERA RECUPERADA',TRANS(aNoveda[14],"####,###,###")})
       nTotSdo += aNoveda[14]

       AADD(aTotPrn,{'',REPL('=',12)})
       AADD(aTotPrn,{'MORA TOTAL',TRANS(nTotSdo,"####,###,###")})

       nTotAno := 0
       FOR i := 1 TO LEN(aMorAno)
	   AADD(aTotPrn,{'A¥O:'+aMorAno[i,1],;
			 TRANS(aMorAno[i,2],'####,###,###')})
	   nTotAno += aMorAno[i,2]
       ENDFOR
       AADD(aTotPrn,{'',REPL('=',12)})
       IF nTotSdo == nTotAno
	  AADD(aTotPrn,{'MORA TOTAL',TRANS(nTotAno,"####,###,###")})
       ELSE
	  AADD(aTotPrn,{'ERROR REVISAR',TRANS(nTotAno,"####,###,###")})
       ENDIF

       FOR i := 1 TO LEN(aTotPrn)

	   aRegPrn := {}
	   FOR j := 1 TO LEN(aTotPrn[i])
	       AADD(aRegPrn,aTotPrn[i,j])
	   ENDFOR

	   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		   aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
       ENDFOR


*>>>>FIN IMPRESION DEL REGISTRO

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: REPORTES POR TOTALES                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2009 MIE A
       Colombia, Bucaramanga        INICIO: 08:00 AM   SEP 09/2009 MIE

OBJETIVOS:

1- Imprime los totales de cada novedad.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRep015(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nMesIni,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL    i,x,y := 0                   // Contadores
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL aNoveda := {}                  // Total de las novedades
       LOCAL nVlrRep := 0                   // Valor del Reporte
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>RECORRIDO DEL REPORTE
       cCodAnt := '1'
     *ÀInicializaci¢n para garantizar c¢digo diferente

       SELECT REP
       REP->(DBGOTOP())
       DO WHILE .NOT. REP->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('A¥O : '+REP->cAnoSisRep+;
			'ºNo. '+STR(REP->(RECNO()),4)+'/'+;
				STR(REP->(RECCOUNT()),4),cNomSis)
**********FIN LINEA DE ESTADO

**********VALIDACION DEL CODIGO
	    IF REP->cCodigoEst == cCodAnt
	       cCodAnt := REP->cCodigoEst
	       REP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL CODIGO

***********SELECION DE LAS AREAS DE TRABAJO
	     cPatSis := REP->cAnoSisRep+'.'+SUBS(cJorTxt,1,3)
	     cAnoSis := SUBS(REP->cAnoSisRep,3,2)

	     IF !lUseDbf(.T.,PathDos+'\'+cPatSis+'\'+;
			     fCarAno+REP->cAnoSisRep+ExtFile,'CAA',;
			     NIL,lShared,nModCry)

		CloseDbf('CAA')
		cError('ABRIENDO ARCHIVOS.'+cMaeAct)


		cCodAnt := REP->cCodigoEst
		REP->(DBSKIP())
		LOOP

	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE CAA->(RECCOUNT()) == 0
		  cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE

	     IF lHayErr

		CloseDbf('CAA')

		cCodAnt := REP->cCodigoEst
		REP->(DBSKIP())
		LOOP
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********INICIALIZACION
	    x := ASCAN(aNoveda,{|aArr|aArr[1] == REP->cAnoSisRep})
	    IF x == 0

	       AADD(aNoveda,{REP->cAnoSisRep,;
			     0,0,0,0,0,0,0,0,0,0})

/*                           01=>A¤o
			     02=>Pago Mes
			     03=>Abonos
			     04=>Pago Plazo
			     05=>Anticipos
			     06=>Mora
			     07=>01  = Pago al d¡a
			     08=>5A  = Pago total a fin a¤o
			     09=>5M  = Pago total del mes
			     10=>PLZ = Pago del plazo
			     11=>MORA= Novedades de Mora */

	       x := LEN(aNoveda)
	    ENDIF
**********FIN INICIALIZACION

**********TOTALIZACION DEL GRUPO
	    IF REP->cNovedaRep == '01' .OR.;
	       REP->cNovedaRep == '05'

	       IF REP->nMesRepRep == REP->nMesIniPag
		  aNoveda[x,2] += REP->nVlrPagRep
	       ELSE
		  aNoveda[x,4] += REP->nVlrPagRep
	       ENDIF

	       aNoveda[x,3] += REP->nVlrAboRep

	       DO CASE
	       CASE REP->cNovedaRep == '01'
		    IF REP->nMesRepRep == REP->nMesIniPag
		       aNoveda[x,7]++
		    ELSE
		       aNoveda[x,10]++
		    ENDIF

	       CASE REP->cNovedaRep == '05'

		    IF REP->nMesFinPag == CAA->nMesFinCaA
		       aNoveda[x,5] += REP->nVlrPagRep+REP->nVlrAboRep
		       aNoveda[x,8]++
		    ELSE
		       aNoveda[x,9]++
		    ENDIF

	       ENDCASE

	    ELSE
	       aNoveda[x,6] += REP->nSdoActRep+REP->nSdoMorRep
	       aNoveda[x,11]++
	    ENDIF
**********FIN TOTALIZACION DEL GRUPO

	  cCodAnt := REP->cCodigoEst
	  REP->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO DEL REPORTE

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'REPORTE POR TOTALES',;
		   'MES '+cMes(nMesIni)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,04)
       AADD(aTitPrn,'A¥O')

       AADD(aNroCol,12)
       AADD(aTitPrn,'PAGOS MES')

       AADD(aNroCol,12)
       AADD(aTitPrn,'ABONOS')

       AADD(aNroCol,12)
       AADD(aTitPrn,'PAGO PLAZO')

       AADD(aNroCol,12)
       AADD(aTitPrn,'PAGOS')

       AADD(aNroCol,12)
       AADD(aTitPrn,'ANTICIPOS')

       AADD(aNroCol,12)
       AADD(aTitPrn,'MORA')

       AADD(aNroCol,04)
       AADD(aTitPrn,'01')

       AADD(aNroCol,04)
       AADD(aTitPrn,'5A')

       AADD(aNroCol,04)
       AADD(aTitPrn,'5M')

       AADD(aNroCol,04)
       AADD(aTitPrn,'TPA')

       AADD(aNroCol,04)
       AADD(aTitPrn,'PLZ')

       AADD(aNroCol,04)
       AADD(aTitPrn,'MORA')

       AADD(aNroCol,04)
       AADD(aTitPrn,'TMOR')

       AADD(aNroCol,04)
       AADD(aTitPrn,'ESTU')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SDA->lPrnArcDat
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'totalrep'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SDA->cOpcPrnDat,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL REGISTRO
       FOR i := 1 TO LEN(aNoveda)

	   aRegPrn := {}
	   AADD(aRegPrn,aNoveda[i,1])
	   AADD(aRegPrn,TRANS(aNoveda[i,2],"####,###,###"))
	   AADD(aRegPrn,TRANS(aNoveda[i,3],"####,###,###"))
	   AADD(aRegPrn,TRANS(aNoveda[i,4],"####,###,###"))
	   AADD(aRegPrn,TRANS(aNoveda[i,2]+aNoveda[i,3]+aNoveda[i,4],"####,###,###"))
	   AADD(aRegPrn,TRANS(aNoveda[i,5],"####,###,###"))
	   AADD(aRegPrn,TRANS(aNoveda[i,6],"####,###,###"))
	   AADD(aRegPrn,STR(aNoveda[i,7],4))
	   AADD(aRegPrn,STR(aNoveda[i,8],4))
	   AADD(aRegPrn,STR(aNoveda[i,9],4))
	   AADD(aRegPrn,STR(aNoveda[i,7]+aNoveda[i,8]+aNoveda[i,9],4))
	   AADD(aRegPrn,STR(aNoveda[i,10],4))
	   AADD(aRegPrn,STR(aNoveda[i,11],4))
	   AADD(aRegPrn,STR(aNoveda[i,10]+aNoveda[i,11],4))
	   AADD(aRegPrn,STR(aNoveda[i,7]+aNoveda[i,8]+aNoveda[i,9]+;
			    aNoveda[i,10]+aNoveda[i,11],4))

	   SET DEVICE TO PRINT
	   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		   aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	   SET DEVICE TO SCREEN

       ENDFOR
*>>>>IMPRESION DEL REGISTRO

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: REPORTES POR GRUPOS                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/2009 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 02/2009 MIE

OBJETIVOS:

1- Imprime los reportes grupos.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRep016(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nMesIni,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL     i,k := 0                   // Contador
       LOCAL nLinPrn := 0                   // l¡neas impresas
       LOCAL cTxtTem := ''                  // Texto temporal
       LOCAL cCodAnt := ''                  // C¢digo Anterior

       LOCAL lAllGru := .F.                 // .T. Todos los Grupos
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL nPagGru := 0                   // Pagos Recibos
       LOCAL nTotPag := 0                   // Total Pagos Recibos
       LOCAL nAboGru := 0                   // Abonos del Grupo
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL nAntGru := 0                   // Anticipos del Grupo
       LOCAL nTotAnt := 0                   // Anticipos
       LOCAL nGruPlz := 0                   // Pagos Recibos plazos
       LOCAL nTotPlz := 0                   // Total Recibos plazos
       LOCAL nMorGru := 0                   // Mora del grupo
       LOCAL nTotMor := 0                   // Total Mora del grupo

       LOCAL nNov001 := 0                   // Pago al d¡a del grupo
       LOCAL nTot001 := 0                   // Pago al d¡a total
       LOCAL nNov05A := 0                   // Pago Total anticipado del grupo
       LOCAL nTot05A := 0                   // Pago Total antcipados
       LOCAL nNov05M := 0                   // Pago Total del mes del grupo
       LOCAL nTot05M := 0                   // Pago Toal del Mes
       LOCAL nNroPlz := 0                   // N£mero de pagos con plazo
       LOCAL nPlzNro := 0                   // Total de pagos con plazo
       LOCAL nNovMor := 0                   // Novedades de Mora
       LOCAL nNroMor := 0                   // Total de novedades de mora

       LOCAL cAnoRep := ''                  // A¤o del reporte

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la Columna

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>ANALISIS DE DECISION
       lAllGru := lPregunta('DESEA IMPRIMIR TODOS LOS GRUPOS? Si No')
       IF !lAllGru
	  cMaeAlu := cNivelEst(10,30,cMaeAlu)
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CAPTURA DEL A¥O DEL REPORTE
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       cAnoRep := STR(YEAR(DATE()),4)
       TitBuscar(14,@nNroFil,@nNroCol,'A¥O','INGRESE EL A¥O')
       @ nNroFil,nNroCol GET cAnoRep PICT '9999'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(cAnoRep)
	  RETURN NIL
       ENDIF
       cPatSis := cAnoRep+'.'+SUBS(cJorTxt,1,3)
       cAnoSis := SUBS(cAnoRep,3,2)
*>>>>FIN CAPTURA DEL A¥O DEL REPORTE

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lAllGru

	  IF !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis)
	     cError('ABRIENDO ARCHIVOS.'+cMaeAlu)
	     CloseDbf('GRU')
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF !lAllGru

	  lHayErr := .T.
	  DO CASE
	  CASE GRU->(RECCOUNT()) == 0
	       cError('NO EXISTE GRUPOS GRABADOS')

	  OTHERWISE
	       lHayErr :=.F.
	  ENDCASE
	  IF lHayErr
	     CloseDbf('GRU')
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lAllGru

	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lIntervGru(10,30,@nRegIni,@nRegFin)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     CloseDbf('GRU')
	     RETURN NIL
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDIF
       CloseDbf('GRU')
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'REPORTE POR GRUPOS',;
		   'MES '+cMes(nMesIni)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       IF lAllGru
	  AADD(aNroCol,06)
	  AADD(aTitPrn,'GRUPOS')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'A¥O')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'PAGOS MES')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'ABONOS')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'PAGO PLAZO')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'PAGOS')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'ANTICIPOS')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'MORA')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'01')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'5A')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'5M')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'TPA')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'PLZ')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'MORA')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'TMOR')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'ESTU')
       ENDIF

       IF !lAllGru .AND. nRegIni == nRegFin

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'No.')

	  AADD(aNroCol,06)
	  AADD(aTitPrn,'CODIGO')

	  AADD(aNroCol,06)
	  AADD(aTitPrn,'GRUPOS')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'A¥O')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'INI')

	  AADD(aNroCol,04)
	  AADD(aTitPrn,'FIN')

	  AADD(aNroCol,02)
	  AADD(aTitPrn,'NV')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'PAGO')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'ANTICIPOS')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'PAGO PLAZO')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'MORA')
       ENDIF

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SDA->lPrnArcDat
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'repgru'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SDA->cOpcPrnDat,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ANALISIS PARA CADA NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	     IF !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
		!lUseDbf(.T.,PathDos+'\'+cPatSis+'\'+;
			     fCarAno+cAnoRep+ExtFile,'CAA',;
			     NIL,lShared,nModCry)

		cError('ABRIENDO ARCHIVOS.'+cMaeAct)
		CloseDbf('GRU')
		CloseDbf('CAA')
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTE GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseDbf('GRU')
		CloseDbf('CAA')
		RETURN NIL
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     IF !lAllGru
		GRU->(DBGOTO(nRegIni))
	     ELSE
		GRU->(DBGOTOP())
	     ENDIF
	     DO WHILE .T.

*===============ANALISIS DE DECISION
		  IF lAllGru
		     IF GRU->(EOF())
			EXIT
		     ENDIF
		  ELSE
		     IF GRU->(RECNO()) > nRegFin
			EXIT
		     ENDIF
		  ENDIF
*===============FIN ANALISIS DE DECISION

*===============LINEA DE ESTADO
		  LineaEstado('NIVEL: '+cMaeAct+;
			      'ºGRUPO: '+GRU->cCodigoGru+;
			      'ºNo. '+STR(GRU->(RECNO()),4)+'/'+;
				      STR(GRU->(RECCOUNT()),4),cNomSis)
*===============FIN LINEA DE ESTADO

*===============FILTRACION DEL ARCHIVO
		  SELECT REP
		  SET FILTER TO REP->cAnoSisRep == cAnoRep .AND.;
				REP->cCodigoGru == GRU->cCodigoGru
		  REP->(DBGOTOP())
*===============FIN FILTRACION DEL ARCHIVO

*===============RECORRIDO DEL REPORTE
		  cCodAnt := '1'
		*ÀInicializaci¢n para garantizar c¢digo diferente

		  nPagGru := 0
		  nAboGru := 0
		  nAntGru := 0
		  nGruPlz := 0
		  nMorGru := 0

		  nNov001 := 0
		  nNov05A := 0
		  nNov05M := 0
		  nNroPlz := 0
		  nNovMor := 0

		  SELECT REP
		  REP->(DBGOTOP())
		  DO WHILE .NOT. REP->(EOF())

*::::::::::::::::::::VALIDACION DEL CODIGO
		      IF REP->cCodigoEst == cCodAnt

			 cCodAnt := REP->cCodigoEst
			 SELECT REP
			 REP->(DBSKIP())
			 LOOP

		      ENDIF
*::::::::::::::::::::FIN VALIDACION DEL CODIGO

*::::::::::::::::::::TOTALIZACION DEL GRUPO
		       IF REP->cNovedaRep == '01' .OR.;
			  REP->cNovedaRep == '05'

			  IF REP->nMesRepRep == REP->nMesIniPag
			     nPagGru += REP->nVlrPagRep
			     nTotPag += REP->nVlrPagRep
			  ELSE
			     nGruPlz += REP->nVlrPagRep
			     nTotPlz += REP->nVlrPagRep
			  ENDIF

			  nAboGru += REP->nVlrAboRep
			  nTotAbo += REP->nVlrAboRep

			  DO CASE
			  CASE REP->cNovedaRep == '01'
			       IF REP->nMesRepRep == REP->nMesIniPag
				  ++nNov001
				  ++nTot001
			       ELSE
				  ++nNroPlz
				  ++nPlzNro
			       ENDIF

			  CASE REP->cNovedaRep == '05'

			       IF REP->nMesFinPag == CAA->nMesFinCaA
				  ++nNov05A
				  ++nTot05A
				  nAntGru += REP->nVlrPagRep+REP->nVlrAboRep
				  nTotAnt += REP->nVlrPagRep+REP->nVlrAboRep
			       ELSE
				  ++nNov05M
				  ++nTot05M
			       ENDIF

			  ENDCASE

		       ELSE
			  nMorGru += REP->nSdoActRep+REP->nSdoMorRep
			  nTotMor += REP->nSdoActRep+REP->nSdoMorRep
			  ++nNovMor
			  ++nNroMor
		       ENDIF
*::::::::::::::::::::FIN TOTALIZACION DEL GRUPO

*::::::::::::::::::::IMPRESION DEL REGISTRO
		       IF !lAllGru .AND. nRegIni == nRegFin

			  aRegPrn := {}

			  AADD(aRegPrn,STR(++k,2))
			  AADD(aRegPrn,REP->cCodigoEst)
			  AADD(aRegPrn,REP->cCodigoGru)
			  AADD(aRegPrn,REP->cAnoSisRep)
			  AADD(aRegPrn,STR(REP->nMesIniPag,2))
			  AADD(aRegPrn,STR(REP->nMesFinPag,2))
			  AADD(aRegPrn,REP->cNovedaRep)

			  IF REP->nMesRepRep == REP->nMesIniPag
			     AADD(aRegPrn,TRANS(REP->nVlrPagRep,"####,###,###"))
			  ELSE
			     AADD(aRegPrn,'')
			  ENDIF

			  IF REP->nMesIniPag # REP->nMesFinPag
			     AADD(aRegPrn,TRANS(REP->nVlrPagRep+REP->nVlrAboRep,"####,###,###"))
			  ELSE
			     AADD(aRegPrn,'')
			  ENDIF

			  IF REP->nMesRepRep == REP->nMesIniPag
			     AADD(aRegPrn,'')
			  ELSE
			     AADD(aRegPrn,TRANS(REP->nVlrPagRep,"####,###,###"))
			  ENDIF

			  AADD(aRegPrn,TRANS(REP->nSdoActRep+;
					     REP->nSdoMorRep,"####,###,###"))

			  SET DEVICE TO PRINT
			  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
			  SET DEVICE TO SCREEN

		       ENDIF
*::::::::::::::::::::FIN IMPRESION DEL REGISTRO

		     cCodAnt := REP->cCodigoEst
		     REP->(DBSKIP())

		  ENDDO
*===============FIN RECORRIDO DEL REPORTE

*===============IMPRESION DEL REGISTRO
		  IF lAllGru

		     nLinPrn++
		     DO CASE
		     CASE nLinPrn == 1
			  cTxtTem := 'CONVENCIONES:'
		     CASE nLinPrn == 2
			  cTxtTem := '01=PAGO AL DIA'
		     CASE nLinPrn == 3
			  cTxtTem := '5A=PAGO TOTAL A FIN A¥O'
		     CASE nLinPrn == 4
			 cTxtTem := '5M=PAGO TOTAL DEL MES'
		     CASE nLinPrn == 5
			  cTxtTem := 'TPA=TOTAL PAGOS'
		     CASE nLinPrn == 6
			  cTxtTem := 'PLZ=PAGOS DEL PLAZO'
		     CASE nLinPrn == 7
			  cTxtTem := 'MORA=NOVEDADES DE MORA'
		     CASE nLinPrn == 8
			  cTxtTem := 'TMOR=TOTAL DEUDORES'
		     CASE nLinPrn == 9
			  cTxtTem := 'ESTU=TOTAL ESTUDIANTES'
		     OTHERWISE
			  cTxtTem := ''
		     ENDCASE

		     aRegPrn := {}
		     AADD(aRegPrn,GRU->cCodigoGru)  // C¢digo del Grupo
		     AADD(aRegPrn,cAnoRep)
		     AADD(aRegPrn,TRANS(nPagGru,"####,###,###"))
		     AADD(aRegPrn,TRANS(nAboGru,"####,###,###"))
		     AADD(aRegPrn,TRANS(nGruPlz,"####,###,###"))
		     AADD(aRegPrn,TRANS(nPagGru+nAboGru+nGruPlz,"####,###,###"))
		     AADD(aRegPrn,TRANS(nAntGru,"####,###,###"))
		     AADD(aRegPrn,TRANS(nMorGru,"####,###,###"))
		     AADD(aRegPrn,STR(nNov001,2))
		     AADD(aRegPrn,STR(nNov05A,2))
		     AADD(aRegPrn,STR(nNov05M,2))
		     AADD(aRegPrn,STR(nNov001+nNov05A+nNov05M,2))
		     AADD(aRegPrn,STR(nNroPlz,2))
		     AADD(aRegPrn,STR(nNovMor,2))
		     AADD(aRegPrn,STR(nNroPlz+nNovMor,2))
		     AADD(aRegPrn,STR(nNov001+nNov05A+nNov05M+;
				      nNroPlz+nNovMor,2))

		     SET DEVICE TO PRINT
		     cTxtPrn := cRegPrint(aRegPrn,aNroCol)+' '+cTxtTem
		     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			     aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza,;
			     cTxtPrn)
		     SET DEVICE TO SCREEN

		  ENDIF
*===============FIN IMPRESION DEL REGISTRO

		GRU->(DBSKIP())

		IF !lAllGru
		   IF nRegIni == nRegFin
		      EXIT
		     *Salida por ser un solo grupo a imprimir
		   ENDIF
		ENDIF

	     ENDDO
	     CloseDbf('GRU')
	     CloseDbf('CAA')
***********FIN RECORRIDO POR GRUPOS

       ENDFOR
*>>>>FIN ANALISIS PARA CADA NIVEL

*>>>>IMPRESION TOTALES
       aRegPrn := {}
       IF !lAllGru .AND. nRegIni == nRegFin
	  AADD(aRegPrn,'')
	  AADD(aRegPrn,'')
	  AADD(aRegPrn,'')
	  AADD(aRegPrn,'')
	  AADD(aRegPrn,'')
	  AADD(aRegPrn,'')
	  AADD(aRegPrn,'')
	  AADD(aRegPrn,TRANS(nPagGru,"####,###,###"))
	  AADD(aRegPrn,TRANS(nAntGru,"####,###,###"))
	  AADD(aRegPrn,TRANS(nGruPlz,"####,###,###"))
	  AADD(aRegPrn,TRANS(nMorGru,"####,###,###"))
       ELSE
	  AADD(aRegPrn,'TOT.')
	  AADD(aRegPrn,cAnoRep)
	  AADD(aRegPrn,TRANS(nTotPag,"####,###,###"))
	  AADD(aRegPrn,TRANS(nTotAbo,"####,###,###"))
	  AADD(aRegPrn,TRANS(nTotPlz,"####,###,###"))
	  AADD(aRegPrn,TRANS(nTotPag+nTotAbo+nTotPlz,"####,###,###"))
	  AADD(aRegPrn,TRANS(nTotAnt,"####,###,###"))
	  AADD(aRegPrn,TRANS(nTotMor,"####,###,###"))
	  AADD(aRegPrn,ALLTRIM(STR(nTot001,4)))
	  AADD(aRegPrn,ALLTRIM(STR(nTot05A,4)))
	  AADD(aRegPrn,ALLTRIM(STR(nTot05M,4)))
	  AADD(aRegPrn,ALLTRIM(STR(nTot001+nTot05A+nTot05M,4)))
	  AADD(aRegPrn,ALLTRIM(STR(nPlzNro,4)))
	  AADD(aRegPrn,ALLTRIM(STR(nNroMor,4)))
	  AADD(aRegPrn,ALLTRIM(STR(nPlzNro+nNroMor,4)))
	  AADD(aRegPrn,ALLTRIM(STR(nTot001+nTot05A+nTot05M+;
				   nPlzNro+nNroMor,4)))
       ENDIF
       SET DEVICE TO PRINT
       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: REPORTES DE INCONSISTENCIAS                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2009 JUE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   SEP 03/2009 JUE

OBJETIVOS:

1- Imprime las inconsistencias del reporte.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRep017(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nMesIni,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aErrRep := {}                  // Errores en el reporte

       LOCAL     i,k := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>MES INICIAL
       REP->(DBGOTOP())
       nMesIni := REP->nMesRepRep
*>>>>FIN MES INICIAL

*>>>>ANALISIS PARA CADA NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	     IF !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)
		cError('ABRIENDO ARCHIVOS.'+cMaeAct)
		CloseDbf('GRU')
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTE GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseDbf('GRU')
		RETURN NIL
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     GRU->(DBGOTOP())
	     DO WHILE .NOT. GRU->(EOF())

*===============PREPARACION DE LAS VARIABLES DE ARCHIVO
		  FileCli := PathDos+'\'+cPatSis+'\'+;
			     'CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

		  FilePag := PathDos+'\'+cPatSis+'\'+;
			     'PAGOS\PA'+GRU->cCodigoGru+cAnoSis+ExtFile
*===============FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*===============SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		     cError('ABRIENDO DE CLIENTES Y PAGOS')
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*===============FIN SELECION DE LAS AREAS DE TRABAJO

*===============RECORRIDO POR GRUPO
		  SELECT CLI
		  CLI->(DBGOTOP())
		  DO WHILE .NOT. CLI->(EOF())

*--------------------LINEA DE ESTADO
		       LineaEstado('NIVEL: '+cMaeAct+;
				   'ºGRUPO: '+GRU->cCodigoGru+;
				   'ºNo. '+STR(CLI->(RECNO()),4)+'/'+;
					   STR(CLI->(RECCOUNT()),4),cNomSis)
*--------------------FIN LINEA DE ESTADO

*--------------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		       IF CLI->lRetgruCli
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------------LOCALIZACION DEL PAGO
		       IF !lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN LOCALIZACION DEL PAGO

*--------------------LOCALIZACION DEL REPORTE
		       IF lLocCodigo('cCodigoEst','REP',CLI->cCodigoEst)
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN LOCALIZACION DEL REPORTE

*--------------------REGISTRO DEL ERROR
		       AADD(aErrRep,{CLI->cCodigoEst,;
				     GRU->cCodigoGru+'-'+;
				     STR(CLI->(RECNO()),2),;
				     cAnoUsr,;
				     '',''})
*--------------------FIN REGISTRO DEL ERROR

		     CLI->(DBSKIP())

		  ENDDO
		  CloseDbf('CLI')
		  CloseDbf('PAG')
*===============FIN RECORRIDO POR GRUPO

		GRU->(DBSKIP())

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

       ENDFOR

*>>>>FIN ANALISIS PARA CADA NIVEL

*>>>>IMPRESION DE ERRORES
       IF LEN(aErrRep) # 0

	  PrnErrRep(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,cAnoUsr,;
		    PathSis+'\'+FilePrn,;
		    SDA->nCodigoPrn,SDA->lPrnArcDat,SDA->cOpcPrnDat,;
		    nMesIni,DATE(),aErrRep)
	*ÀImpresi¢n de la inconsistencias

       ELSE
	  cError('NO EXISTEN INCONSITENCIAS')
       ENDIF

       CloseDbf('GRU')
       RETURN NIL
*>>>>FIN IMPRESION DE ERRORES

/*************************************************************************
* TITULO..: REPORTES DE NOVEDADES CONFIRMADAS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2009 JUE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   SEP 03/2009 JUE

OBJETIVOS:

1- Imprime las inconsistencias del reporte.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRep018(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nMesIni,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL lAllGru := .F.                 // .T. Todos los Grupos
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL   i,x,y := 0                   // Contadores
       LOCAL aNoveda := {}                  // Total de las novedades
       LOCAL cCodGru := ''                  // C¢digo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>ANALISIS DE DECISION
       lAllGru := lPregunta('DESEA IMPRIMIR TODOS LOS GRUPOS? Si No')
       IF !lAllGru
	  cMaeAlu := cNivelEst(10,30,cMaeAlu)
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lAllGru

	  IF !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis)
	     cError('ABRIENDO ARCHIVOS.'+cMaeAlu)
	     CloseDbf('GRU')
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF !lAllGru

	  lHayErr := .T.
	  DO CASE
	  CASE GRU->(RECCOUNT()) == 0
	       cError('NO EXISTE GRUPOS GRABADOS')

	  OTHERWISE
	       lHayErr :=.F.
	  ENDCASE
	  IF lHayErr
	     CloseDbf('GRU')
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lAllGru

	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lIntervGru(10,30,@nRegIni,@nRegFin)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     CloseDbf('GRU')
	     RETURN NIL
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDIF
       CloseDbf('GRU')
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DEL MES INICIAL
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIni := nMesano(10,10,'Mes de los recibos',.T.)

       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIni == 0
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES INICIAL

*>>>>ANALISIS PARA CADA NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	     IF !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)
		cError('ABRIENDO ARCHIVOS.'+cMaeAct)
		CloseDbf('GRU')
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTE GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseDbf('GRU')
		RETURN NIL
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     IF !lAllGru
		GRU->(DBGOTO(nRegIni))
	     ELSE
		GRU->(DBGOTOP())
	     ENDIF
	     cCodGru := GRU->cCodigoGru
	     DO WHILE .T.

*===============ANALISIS DE DECISION
		  IF lAllGru
		     IF GRU->(EOF())
			EXIT
		     ENDIF
		  ELSE
		     IF GRU->(RECNO()) > nRegFin
			EXIT
		     ENDIF
		  ENDIF
*===============FIN ANALISIS DE DECISION

*===============PREPARACION DE LAS VARIABLES DE ARCHIVO
		  FileCli := PathDos+'\'+cPatSis+'\'+;
			     'CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

		  FilePag := PathDos+'\'+cPatSis+'\'+;
			     'PAGOS\PA'+GRU->cCodigoGru+cAnoSis+ExtFile
*===============FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*===============SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		     cError('ABRIENDO DE CLIENTES Y PAGOS')
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*===============FIN SELECION DE LAS AREAS DE TRABAJO

*===============RECORRIDO POR GRUPO
		  SELECT CLI
		  CLI->(DBGOTOP())
		  DO WHILE .NOT. CLI->(EOF())

*--------------------LINEA DE ESTADO
		       LineaEstado('NIVEL: '+cMaeAct+;
				   'ºGRUPO: '+GRU->cCodigoGru+;
				   'ºNo. '+STR(CLI->(RECNO()),4)+'/'+;
					   STR(CLI->(RECCOUNT()),4),cNomSis)
*--------------------FIN LINEA DE ESTADO

*--------------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		       IF CLI->lRetgruCli
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------------LOCALIZACION DEL PAGO
		       IF !lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
			  CLI->(DBSKIP())
			  LOOP
		       ENDIF
*--------------------FIN LOCALIZACION DEL PAGO

*--------------------INICIALIZACION
		       IF lAllGru
			  x := ASCAN(aNoveda,{|aArr|aArr[1] == GRU->cCodigoGru})
		       ELSE
			  x := ASCAN(aNoveda,{|aArr|aArr[1] == CLI->cCodigoEst})
		       ENDIF
		       IF x == 0

			  IF lAllGru
			     AADD(aNoveda,{GRU->cCodigoGru,;
					   0,0,0,0,0,0,0})
			  ELSE
			     AADD(aNoveda,{CLI->cCodigoEst,;
					   0,0,0,0,0,0,0})
			  ENDIF
/*
					1=>Grupo
					2=>01 = Pago al d¡a
					3=>05 = Pago total a fin a¤o
					4=>06 = Mora 30 d¡as
					5=>07 = Mora 60 d¡as
					6=>08 = Mora 90 d¡as
					7=>09 = Mora 120 d¡as
					8=>espacios = Por confirmar */

			  x := LEN(aNoveda)
		       ENDIF
*--------------------FIN INICIALIZACION

*--------------------SUMATORIA POR LA NOVEDAD
		       DO CASE
		       CASE ALLTRIM(PAG->cNovRepPag) == ''  // Por confirmar
			    aNoveda[x,8]++

		       CASE PAG->cNovRepPag == '01'  // Pago al d¡a
			    aNoveda[x,2]++

		       CASE PAG->cNovRepPag == '05'  // Pago Total
			    aNoveda[x,3]++

		       CASE PAG->cNovRepPag == '06'  // Mora de 30 d¡as
			    aNoveda[x,4]++

		       CASE PAG->cNovRepPag == '07'  // Mora de 60 d¡as
			    aNoveda[x,5]++

		       CASE PAG->cNovRepPag == '08'  // Mora de 90 d¡as
			    aNoveda[x,6]++

		       CASE PAG->cNovRepPag == '09'  // Mora de 120 d¡as o m s
			    aNoveda[x,7]++

		       CASE PAG->cNovedaRep == '12'  // Dudoso recaudo

		       CASE PAG->cNovedaRep == '13'  // Cartera castigada

		       CASE PAG->cNovedaRep == '14'  // Cartera recuperada

		       ENDCASE
*--------------------FIN SUMATORIA POR LA NOVEDAD

		     CLI->(DBSKIP())

		  ENDDO
		  CloseDbf('CLI')
		  CloseDbf('PAG')
*===============FIN RECORRIDO POR GRUPO

		GRU->(DBSKIP())

		IF !lAllGru
		   IF nRegIni == nRegFin
		      EXIT
		     *Salida por ser un solo grupo a imprimir
		   ENDIF
		ENDIF

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

       ENDFOR
*>>>>FIN ANALISIS PARA CADA NIVEL

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'REPORTE DE NOVEDADES CONFIRMADAS',;
		   'MES '+cMes(nMesIni)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       IF !lAllGru
	  AADD(aNroCol,06)
	  AADD(aTitPrn,'CODIGO')
       ENDIF

       AADD(aNroCol,06)
       AADD(aTitPrn,'GRUPO')

       AADD(aNroCol,14)
       AADD(aTitPrn,'AL DIA')

       AADD(aNroCol,14)
       AADD(aTitPrn,'PAGO TOTAL')

       AADD(aNroCol,14)
       AADD(aTitPrn,'MORA 30 DIAS')

       AADD(aNroCol,14)
       AADD(aTitPrn,'MORA 60 DIAS')

       AADD(aNroCol,14)
       AADD(aTitPrn,'MORA 90 DIAS')

       AADD(aNroCol,14)
       AADD(aTitPrn,'MORA 120 DIAS')

       AADD(aNroCol,14)
       AADD(aTitPrn,'POR CONFIRMAR')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SDA->lPrnArcDat
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'totalrep'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SDA->cOpcPrnDat,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL REGISTRO
       FOR i := 1 TO LEN(aNoveda)+1

	   aRegPrn := {}
	   IF i <= LEN(aNoveda)

	      IF !lAllGru
		 AADD(aRegPrn,aNoveda[i,1])
		 AADD(aRegPrn,cCodGru)
	      ELSE
		 AADD(aRegPrn,aNoveda[i,1])
	      ENDIF

	      AADD(aRegPrn,STR(aNoveda[i,2],2))
	      AADD(aRegPrn,STR(aNoveda[i,3],2))
	      AADD(aRegPrn,STR(aNoveda[i,4],2))
	      AADD(aRegPrn,STR(aNoveda[i,5],2))
	      AADD(aRegPrn,STR(aNoveda[i,6],2))
	      AADD(aRegPrn,STR(aNoveda[i,7],2))
	      AADD(aRegPrn,STR(aNoveda[i,8],2))
	   ELSE
	      IF !lAllGru
		 AADD(aRegPrn,'TOTAL')
		 AADD(aRegPrn,'')
	      ELSE
		 AADD(aRegPrn,'TOTAL')
	      ENDIF
	      AADD(aRegPrn,STR(nSuma(aNoveda,2),4))
	      AADD(aRegPrn,STR(nSuma(aNoveda,3),4))
	      AADD(aRegPrn,STR(nSuma(aNoveda,4),4))
	      AADD(aRegPrn,STR(nSuma(aNoveda,5),4))
	      AADD(aRegPrn,STR(nSuma(aNoveda,6),4))
	      AADD(aRegPrn,STR(nSuma(aNoveda,7),4))
	      AADD(aRegPrn,STR(nSuma(aNoveda,8),4))
	   ENDIF

	   SET DEVICE TO PRINT
	   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		   aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	   SET DEVICE TO SCREEN

       ENDFOR
*>>>>IMPRESION DEL REGISTRO

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


