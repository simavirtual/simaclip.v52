/*               	 SISTEMA CARTERA ACADEMICA
	  BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CONTROL DE RECIBOS

REQUERIMIENTOS:

- Compilar: clipper FuncsRec /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Control de Recibos

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2000 MIE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   AGO 09/2000 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfRec(lShared,nModCry,PathRec,FileRec,fNtxRec,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathRec				    // Path del Archivo
       FileRec				    // Nombre del Archivo
       fNtxRec				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfRec := {{"cAnoUsrRec","Character",04,0},; // A¤o del Recibo
			 {"nNumeroRec","Numeric"  ,09,0},; // N£mero del Recibo
			 {"cCodigoEst","Character",06,0},; // C¢digo del Estudiante
			 {"nMesIniPag","Numeric"  ,02,0},; // Mes Inicial del Pago
			 {"nMesFinPag","Numeric"  ,02,0},; // Mes Final del Pago
			 {"nVlrPagPag","Numeric"  ,12,2},; // Valor a pagar o pagado
			 {"nEstadoRec","Numeric"  ,01,0},; // Estado del Recibo. O=>Original D=>Duplicado A=>Anulado X=>No Impreso Total de Duplicados
			 {"cObservRec","Character",80,0},; // Observaci¢n sobre el recibo.
			 {"cNomUsrRec","Character",10,0},; // Nombre del Usuario
			 {"dFecUsrRec","Date"     ,08,0},; // Fecha del Usuario
			 {"cHorUsrRec","Character",10,0},; // Hora del Usuario
			 {"cCodigoBan","Character",02,0},; // C¢digo del Banco
			 {"cCodEmpCon","Character",03,0}}  // C¢digo de la Empresa
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfRec
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathRec) == 0
	    DBCREATE(FileRec,aDbfRec,"DBFNTX")
	    Proteger(FileRec,nModCry)

       CASE DIRCHANGE(PathRec) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathRec)

       CASE DIRCHANGE(PathRec) == -5
	    cError('NO TIENE DERECHOS EN: '+PathRec)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2000 MIE A
       Colombia, Bucaramanga        INICIO: 05:35 PM   AGO 09/2000 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfRec(lShared,nModCry,PathRec,FileRec,fNtxRec)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathRec			      // Path del Archivo
       FileRec			      // Nombre del Archivo
       fNtxRec			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathRec+'\'+FileRec,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CLASES")
       Termometro(100)

       CreaDbfRec(lShared,nModCry,PathRec,FileRec,fNtxRec)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2000 MIE A
       Colombia, Bucaramanga        INICIO: 05:40 PM   AGO 09/2000 MIE

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

FUNCTION nActStrRec(lShared,nModCry,PathRec,FileRec)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathRec				    // Path del Archivo
       FileRec				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('REC')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathRec+'\'+FileRec,'REC',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE FORMA DE PAGO')
	  CloseDbf('REC',PathRec+'\'+FileRec,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := REC->(DBSTRUCT())
       CloseDbf('REC',PathRec+'\'+FileRec,nModCry)
       CreaDbfRec(lShared,nModCry,PathRec,FileRec,,@aStrNew)
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
	  cError('El Archivo CONTROL DE RECIBOS su Estructura Esta DesActualizada.',;
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
	  nNroErr := 0
	  FileTem := SUBS(FileRec,1,AT('.',FileRec))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathRec+'\'+FileRec,;
			 PathRec+'\'+FileTem,;
			 {||CreaDbfRec(lShared,nModCry,PathRec,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO 		         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2000 MIE A
       Colombia, Bucaramanga        INICIO: 05:45 PM   AGO 09/2000 MIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenRec(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,PathUno,PathDos,;
		   PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt)

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
       PathUno                              // Primera Intergraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro


       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL GetList := {}                  // Variable del Sistema
       SET DECIMALS TO
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PATHS DEL SISTEMA
       PathSys := SUBS(PathUno,1,RAT('\',PathUno))+PathSys
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
       cIntTre := PathTre+'\'+cPatSis
       cIntCua := PathCua+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
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

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT REC

       oBrowse := oDefBrwRec(lShared,nFilPal+1,00,22,79,cNomUsr,cAnoUsr)
       SETKEY(K_F5,{||BuscarRec(oBrowse,cAnoUsr)})
       SETKEY(K_F9,{||MenuOtrRec(lShared,nModCry,cNomSis,cEmpPal,;
				 cNitEmp,cNomEmp,cNomSec,nFilInf,;
				 nColInf,nFilPal,cNomUsr,cAnoUsr,;
				 cPatSis,PathUno,PathDos,PathTre,;
				 PathCua,cMaeAlu,cMaeAct,cJorTxt,;
				 oBrowse)})
       REC->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CloseAll(aUseDbf)
       SET DECIMALS TO 2
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE 		         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2000 MIE A
       Colombia, Bucaramanga        INICIO: 05:50 PM   AGO 09/2000 MIE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

 oBrowse := oDefBrwRec(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwRec(lShared,nFilSup,nColSup,nFilInf,;
		    nColInf,cNomUsr,cAnoUsr,lTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       lTitulo                              // .T. Imprimir el Titulo */
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
       lTitulo := IF(lTitulo==NIL,.T.,lTitulo)
       IF lTitulo
	  oBrowse:Cargo := {'<<MANTENIMIENTO CONTROL DE RECIBOS>>',;
			    '<ENTER>Modificar  <INS>Incluir  <F5>BUSCAR  '+;
			    '<ESC>Abandonar',{||IncluirRec(lShared,cNomUsr,cAnoUsr)}}
       ELSE
	  oBrowse:Cargo := {'<<MANTENIMIENTO CONTROL DE RECIBOS>>',;
			    '<ENTER>Modificar <ESC>Abandonar'}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT REC
       oColumn	     := TBCOLUMNNEW('NUMERO;RECIBO', {||REC->nNumeroRec})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;ESTUDIANTE', {||REC->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',{||REC->nMesIniPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',{||REC->nMesFinPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;A PAGAR',{||REC->nVlrPagPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ESTADO;DEL RECIBO',{||REC->nEstadoRec})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','REC'},{'FIELD','nEstadoRec'},;
			 {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ESTADO;DEL RECIBO',{||cSekEstRec('REC')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION;DEL RECIBO',{||REC->cObservRec})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','REC'},{'FIELD','cObservRec'},;
			 {'PICTURE','@!S76}'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('USUARIO', {||REC->cNomUsrRec})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA',{||cFecha(REC->dFecUsrRec)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA', {||REC->cHorUsrRec})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BANCO',{||REC->cCodigoBan})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('EMPRESA', {||REC->cCodEmpCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O', {||REC->cAnoUsrRec})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2000 MIE A
       Colombia, Bucaramanga        INICIO: 05:55 PM   AGO 09/2000 MIE

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirRec(lShared,cNomUsr,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nNumeroTre := ''               // N£mero del Recibo
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL nMesIniTpa := 0                // Mes Inicial del Pago
       LOCAL nMesFinTpa := 0                // Mes Final del Pago
       LOCAL nVlrPagTpa := 0                // Valor a pagar o pagado
       LOCAL nEstadoTre := 0                // Estado del Recibo.
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR LOS DETALLES DEL RECIBO',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       nNumeroTre := 0
	       cCodigoTes := cSpaces('REC','cCodigoEst')
	       nVlrPagTpa := 0
	       nEstadoTre := 1
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'NUMERO DEL RECIBO    :';
				GET nNumeroTre PICT '999999999';
				VALID !lValCodRec(cAnoUsr,nNumeroTre)

	    @ nNroFil+1,nNroCol SAY 'CODIGO DEL ESTUDIANTE:';
				GET cCodigoTes PICT '@!'

	    @ nNroFil+2,nNroCol SAY 'MES INICIAL          :';
				GET nMesIniTpa PICT '99';
				VALID nMesIniTpa > 0

	    @ nNroFil+3,nNroCol SAY 'MES FINAL            :';
				GET nMesFinTpa PICT '99';
				VALID nMesFinTpa > 0

	    @ nNroFil+4,nNroCol SAY 'VALOR A PAGAR OPO    :';
				GET nVlrPagTpa PICT '9999999';

	    @ nNroFil+5,nNroCol SAY 'ESTADO DEL RECIBO    :';
				GET nEstadoTre PICT '9';
				VALID lValEstRec(ROW(),COL()-1,@nEstadoTre)
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE EMPTY(nNumeroTre) .OR. EMPTY(cCodigoTes)

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE GRABA EL REGISTRO')
	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT REC
       IF lGrabar
	  SaveRegRec(lShared,cNomUsr,cAnoUsr,;
		     nNumeroTre,cCodigoTes,nMesIniTpa,;
		     nMesFinTpa,nVlrPagTpa,nEstadoTre,;
		     CAA->cCodigoBan,SCO->cCodEmpCon)
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 05/2000 DOM A
       Colombia, Bucaramanga        INICIO: 05:20 PM   MAR 05/2000 DOM

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodRec(cAnoUsr,nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cAnoUsr                              // A¤o del Usuario
       nCodigo				    // C¢digo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF lSeekRec(cAnoUsr,nCodigo) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 05/2000 DOM A
       Colombia, Bucaramanga        INICIO: 05:25 PM   MAR 05/2000 DOM

OBJETIVOS:

1- Debe estar en uso los archivo.

2- Busca el c¢digo.

3- Retorna NIL

SINTAXIS:

  BuscarRec(oBrowse)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarRec(oBrowse,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			      // Browse
       cAnoUsr                        // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nCodigo := 0                   // C¢digo a Buscar
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''                  // C¢digo de Buscar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       nCodigo := 0
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET nCodigo PICT '@!';
			 VALID lValidaRec(ROW(),COL()-1,@nCodigo,cAnoUsr)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(nCodigo)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT REC
       IF lBuscar .AND. lSeekRec(cAnoUsr,nCodigo)
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
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 05/2000 DOM A
       Colombia, Bucaramanga        INICIO: 05:30 PM   MAR 05/2000 DOM

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValidaRec(nNroFil,nNroCol,nCodigo,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nCodigo	    			    // C¢digo a Validar
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lSeekRec(cAnoUsr,nCodigo)
	  nNroReg := nSelCodRec(nNroFil,nNroCol)
	  IF nNroReg == 0
	     nCodigo := 0
	  ELSE
	     GO nNroReg
	     nCodigo := REC->nNumeroRec
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL CODIGO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 05/2000 DOM A
       Colombia, Bucaramanga        INICIO: 05:35 PM   MAR 05/2000 DOM

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger el registro del archivo de acuerdo al nombre.

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelCodRec(nNroFil,nNroCol)

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
       IF REC->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT REC
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL REGISTRO
       REC->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||REC->nNumeroRec})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL REGISTRO

/*************************************************************************
* TITULO..: VALIDACION DEL ESTADO DEL RECIBO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2000 MIE A
       Colombia, Bucaramanga        INICIO: 05:55 PM   AGO 09/2000 MIE

OBJETIVOS:

1- Realiza la validaci¢n del c¢digo

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValEstRec(nNroFil,nNroCol,nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nCodigo			            // @Codigo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<NO IMPRESO>',;
		  '2<ORIGINAL  >',;
		  '3<DUPLICADO >',;
		  '4<ANULADO   >'}

       aAyudas := {'Recibo No Impreso',;
		   'Recibo Original',;
		   'Recibo Duplicado',;
		   'Recibo Anulado'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       IF nCodigo # 0 .AND. nCodigo # 1 .AND.;
	  nCodigo # 2 .AND. nCodigo # 3

	  SAVE SCREEN
	  nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	  RESTORE SCREEN

	  IF nNroOpc == 0
	     nCodigo := 0
	  ELSE
	     nCodigo := nNroOpc-1
	  ENDIF

       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MENU DE OTROS PARA EL ARCHIVO                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 05/2000 DOM A
       Colombia, Bucaramanga        INICIO: 05:40 PM   MAR 05/2000 DOM

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrRec(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,PathUno,PathDos,;
		    PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt,;
		    oBrowse)

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
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
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
       aMenus := {'1<RECIBOS ORIGINALES >',;
		  '2<RECIBOS DUPLICADOS >',;
		  '3<RECIBOS ANULADOS   >',;
		  '4<RECIBOS NO IMPRESOS>'}

       aAyuda := {'Imprime los n£meros de los recibos impresos Originales.',;
		  'Imprime los n£meros de los recibos impresos Duplicados.',;
		  'Imprime los n£meros de los recibos impresos Anulados.',;
		  'Imprime los n£meros de los recibos que no fueron impresos.'}

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
/*
	    OtrRec011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,PathUno,PathDos,;
		      PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt,;
		      oBrowse)
*/
	   *Impresi¢n de las formas de pago.

       ENDCASE

       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION CAMPOS DEL MANTENIMIENTO             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRec011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,PathUno,PathDos,;
		   PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt,;
		   oBrowse)

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
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF REC->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := REC->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'FORMA DE PAGO DISPONIBLES',;
		   'A¥O: '+cAnoUsr,;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,20,08}
       aTitulo := {'CODIGO',;
		   'DESCRIPCION','LEER NRO'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n10Stan
       lCentra := .T.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       ActivaPrn(lShared,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT REC
       GO TOP
       DO WHILE .NOT. REC->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( REC->(RECNO()) / REC->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aTitulo := {REC->cCodigoRec,;
			REC->cNombreRec,;
			IF(REC->lLeeNroRec,'SI','NO')}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT REC
	    REC->(DBSKIP())
	    IF REC->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: GRABACION DE UN REGISTRO          	                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2000 MIE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   AGO 14/2000 MIE

OBJETIVOS:

1- Graba un registro del Archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SaveRegRec(lShared,cNomUsr,cAnoUsr,nNroRec,;
		    cCodEst,nMesIni,nMesFin,nVlrPag,;
		    nEstRec,cCodBan,cCodEmp,cObserv)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       nNroRec                              // N£mero del Recibo
       cCodEst                              // C¢digo del Estudiante
       nMesIni                              // Mes Inicial del pago
       nMesFin                              // Mes Final del pago
       nVlrPag                              // Valor pagado
       nEstRec                              // Estado del Recibo
       cCodBan                              // C¢digo del Banco
       cCodEmp                              // C¢digo de la Empresa
       cObserv                              // Observaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>GRABACION DEL REGISTRO
       SELECT REC
       IF REC->(lRegLock(lShared,.T.))
	  REPL REC->cAnoUsrRec WITH cAnoUsr
	  REPL REC->nNumeroRec WITH nNroRec
	  REPL REC->cCodigoEst WITH cCodEst
	  REPL REC->nMesIniPag WITH nMesIni
	  REPL REC->nMesFinPag WITH nMesFin
	  REPL REC->nVlrPagPag WITH nVlrPag
	  REPL REC->nEstadoRec WITH nEstRec
	  REPL REC->cCodigoBan WITH cCodBan
	  REPL REC->cCodEmpCon WITH cCodEmp
	  REPL REC->cNomUsrRec WITH cNomUsr
	  REPL REC->dFecUsrRec WITH DATE()
	  REPL REC->cHorUsrRec WITH TIME()
	  REPL REC->cObservRec WITH IF(cObserv==NIL,'',cObserv)
	  REC->(DBCOMMIT())
       ENDIF
       IF lShared
	  REC->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO DEL NUMERO DEL RECIBO                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 05/2000 DOM A
       Colombia, Bucaramanga        INICIO: 05:30 PM   MAR 05/2000 DOM

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite buscadro el c¢digo del recibo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSeekRec(cAnoUsr,nNroRec)

*>>>>PARAMETROS DE LA FUNCION
/*     cAnoUsr                              // A¤o del Usuario
       nNroRec                              // N£mero del Recibo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayReg := .F.                 // .T. Hay Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL CODIGO
       IF REC->(DBSEEK(VAL(cAnoUsr)+nNroRec))
	  IF REC->nEstadoRec # 0
	     lHayReg := .T.
	  ENDIF
       ENDIF
       RETURN lHayReg
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: BUSQUEDA DE LA DESCRIPCION DEL ESTADO DEL RECIBO             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 05/2000 DOM A
       Colombia, Bucaramanga        INICIO: 05:30 PM   MAR 05/2000 DOM

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite buscar el c¢digo del Estado del recibo

3- Retorna la Descripci¢n del Estado del Recibo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSekEstRec(cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     cNalias                              // Alias del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cDescri := ''                  // Descripci¢n del Estado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       DO CASE
       CASE REC->nEstadoRec == 0
	    cDescri := 'NO IMPRESO'

       CASE REC->nEstadoRec == 1
	    cDescri := 'ORIGINAL  '

       CASE REC->nEstadoRec == 2
	    cDescri := 'DUPLICADO '

       CASE REC->nEstadoRec == 3
	    cDescri := 'ANULADO   '
       OTHERWISE
	    cDescri := 'ERROR     '
       ENDCASE
       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       RETURN cDescri
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: RELACION DE RECIBOS PARA UN ESTUDIANTE                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 30/2000 MAR A
       Colombia,Bucaramanga         INICIO: 11:00 AM   AGO 30/2000 MAR

OBJETIVOS:

1)- Visualiza un Browse con todos los Recibos de impresos y no impresos
    de un estudiante.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RelRecibo(lShared,nModCry,cNomUsr,cAnoUsr,;
		   PathUno,nFilInf,nColInf,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry			            // Modo de Proteci¢n Dbf
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       PathUno			            // Path del Sistema
       nFilInf                              // Fila de Impresi¢n
       nColInf                              // Columna de Impresi¢n
       cNalias                              // Alias del Maestro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL bCodF02 := NIL                 // Code Block asignado a F2
       LOCAL bCodF03 := NIL                 // Code Block asignado a F3
       LOCAL bCodF04 := NIL                 // Code Block asignado a F4
       LOCAL bCodF05 := NIL                 // Code Block asignado a F5
       LOCAL bCodF06 := NIL                 // Code Block asignado a F6

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cCodigo := ''                  // Codigo del cliente
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESACTIVACION DE LAS TECLAS DE FUNCION
       bCodF02 := SETKEY(K_F2)
       bCodF03 := SETKEY(K_F3)
       bCodF04 := SETKEY(K_F4)
       bCodF05 := SETKEY(K_F5)
       bCodF06 := SETKEY(K_F6)

       SETKEY(K_F2,NIL)
       SETKEY(K_F3,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F6,NIL)
*>>>>FIN DESACTIVACION DE LAS TECLAS DE FUNCION

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('REC',PathUno+'\'+PathSis+'\'+FileRec,nModCry)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT &cNalias
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>FILTRACION DE LOS DESCUENTOS DEL ESTUDIANTE
       cCodigo := &cNalias->cCodigoEst
       SELECT REC
       SET FILTER TO REC->cCodigoEst == cCodigo .AND.;
		     REC->cAnoUsrRec == cAnoUsr
       IF EOF()
	  cError('NO EXISTEN RECIBOS FACTURADOS EL ESTUDIANTE')
       ELSE
	  REC->(CtrlBrw(lShared,;
			oDefBrwRec(lShared,nFilInf,nColInf,22,79,;
				   cNomUsr,cAnoUsr,.F.)))
       ENDIF
*>>>>FIN FILTRACION DE LOS DESCUENTOS DEL ESTUDIANTE

*>>>>ACTIVACION DE LAS TECLAS DE FUNCION
       SETKEY(K_F2,bCodF02)
       SETKEY(K_F3,bCodF03)
       SETKEY(K_F4,bCodF04)
       SETKEY(K_F5,bCodF05)
       SETKEY(K_F6,bCodF06)

       SET FILTER TO
       CloseDbf('REC',PathUno+'\'+PathSis+'\'+FileRec,nModCry)
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT &cNalias
       RETURN NIL
*>>>>FIN ACTIVACION DE LAS TECLAS DE FUNCION