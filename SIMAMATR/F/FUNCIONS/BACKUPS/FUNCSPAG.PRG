/*                       SIMA - CARTERA ACADEMICA
		BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO PAGOS

REQUERIMIENTOS:

- Compilar: clipper funcsPag /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfPag(PathPag,FilePag,lIntUno,fNtxPag)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfPag(lShared,PathPag,FilePag,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathPag				    // Path del Archivo
       FilePag				    // Nombre del Archivo
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION



*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfStr := {{"cCodigoEst","Character",06,0},; // C¢digo del Estudiante
			 {"cMatricPag","Character",01,0},; // 1->Recibo de Matricula 0->Recibo de Pension
			 {"cCodigoGru","Character",04,0},; // C¢digo del Grupo
			 {"cCodNewGru","Character",04,0},; // C¢digo del Grupo para el sgte a¤o
			 {"nNroFacAno","Numeric"  ,09,0},; // N£mero Consecutivo de la Factura
			 {"cCodigoBan","Character",02,0},; // C¢digo del Banco
			 {"lIntPenPag","Logical"  ,01,0},; //*.T. Utilizar interes por mora y no valor de recargo para lo no pagos o pagos extemporaneos
			 {"nIntMorPag","Numeric"  ,05,2},; // Interes por Mora
			 {"nVlrMorPag","Numeric"  ,10,2},; //*Valor de la mora
			 {"nMesIniPag","Numeric"  ,02,0},; // Mes Inicial del Pago
			 {"nMesFinPag","Numeric"  ,02,0},; // Mes Final del Pago
			 {"nVlrMesPag","Numeric"  ,10,2},; // Valor del Mes
			 {"nVlrPagPag","Numeric"  ,10,2},; // Valor a Pagar
			 {"cConcepPag","Character",16,0},; // Conceptos del Pago
			 {"nVlrCo1Pag","Numeric"  ,10,2},; // Valor del Concepto No. 1
			 {"nVlrCo2Pag","Numeric"  ,10,2},; // Valor del Concepto No. 2
			 {"nVlrCo3Pag","Numeric"  ,10,2},; // Valor del Concepto No. 3
			 {"nVlrCo4Pag","Numeric"  ,10,2},; // Valor del Concepto No. 4
			 {"nVlrCo5Pag","Numeric"  ,10,2},; // Valor del Concepto No. 5
			 {"nVlrCo6Pag","Numeric"  ,10,2},; // Valor del Concepto No. 6
			 {"nVlrCo7Pag","Numeric"  ,10,2},; // Valor del Concepto No. 7
			 {"nVlrCo8Pag","Numeric"  ,10,2},; // Valor del Concepto No. 8
			 {"nVlrDesPag","Numeric"  ,10,2},; // Valor descuento individual
			 {"nPagParPag","Numeric"  ,10,2},; // Valor del pago parcial.
			 {"nVlrRecPag","Numeric"  ,10,2},; // Valor recargo individual
			 {"dFecFacPag","Date"     ,08,0},; // Fecha de Facturaci¢n
			 {"dPagOpoPag","Date"     ,08,0},; // Fecha pago oportuno
			 {"dPagExtPag","Date"     ,08,0},; // Fecha pago extemporaneo
			 {"dFecPagPag","Date"     ,08,0},; // Fecha de pago
			 {"cEstadoPag","Character",01,0},; // Estado de pago o forma de pago
			 {"cObservPag","Character",40,0},; // Observaci¢n
			 {"cNomUsrPag","Character",10,0},; // Nombre del Usuario
			 {"dFecUsrPag","Date"     ,08,0},; // Fecha del Usuario
			 {"cHorUsrPag","Character",10,0}}  // Hora del Usuario
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathPag) == 0
	    DBCREATE(FilePag,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathPag) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathPag)

       CASE DIRCHANGE(PathPag) == -5
	    cError('NO TIENE DERECHOS EN: '+PathPag)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:20 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfPag(lShared,PathPag,FilePag)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathPag			      // Path del Archivo
       FilePag			      // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathPag+'\'+FilePag,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE PAGOS")
       Termometro(100)

       CreaDbfPag(lShared,PathPag,FilePag)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/99 SAB A
       Colombia, Bucaramanga        INICIO: 07:30 PM   SEP 04/99 SAB

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

FUNCTION nActStrPag(lShared,PathArc,cNomArc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       PathArc                              // Path del Archivo
       cNomArc                              // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ACT',NIL,lShared)
          cError('ABRIENDO EL ARCHIVO')
          CloseDbf('ACT')
          RETURN nNroErr := 1
       ENDIF
       aStrOld := ACT->(DBSTRUCT())
       CloseDbf('ACT')
       CreaDbfPag(lShared,PathArc,cNomArc,@aStrNew)
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
*>>>>FIN VALIDACION DE LA ESTRUCTURA

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
			 {||CreaDbfPag(lShared,PathArc,FileTem)})
             cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
             nNroErr := 1
          ENDIF
          RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION......: LOCALIZACION DEL PAGO DE PENSION           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   AGO 09/96 VIE

1- Valida si existe el pago de pension para un mes respectivo

2- Debe estar en uso el archivo de pagos

3- Retorna .T. si ya existe el pago

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocPagPen(cCodigo,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo			            // C¢digo del aspirante
       lMensaj                              // .T. Mostrar mensaje de error*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.         // .T. = Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT PAG
       GO TOP
       LOCATE FOR PAG->cCodigoEst == cCodigo .AND.;
		  PAG->nMesIniPag # 13 .AND.;
		  PAG->nMesFinPag # 13
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('NO SE HA FACTURADO PENSION PARA EL CODIGO: '+cCodigo)
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION......: LOCALIZACION DEL PAGO DE MATRICULA         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 04:20 PM   AGO 09/96 VIE

1- Valida si existe el un pago para un respectiv mes

2- Debe estar en uso el archivo de pagos

3- Retorna .T. si ya existe el pago

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocPagMat(cCodigo,nMesFin,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo			            // C¢digo del aspirante
       nMesFin                              // Mes Final
       lMensaj                              // .T. Mostrar mensaje de error*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.         // .T. = Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT PAG
       GO TOP
       LOCATE FOR PAG->cCodigoEst == cCodigo .AND.;
		  PAG->nMesIniPag == 13 .AND.;
		  PAG->nMesFinPag == nMesFin
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('NO SE HA FACTURADO LA MATRICULA PARA EL CODIGO: '+cCodigo)
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:00 PM   OCT 06/98 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenPag(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		   cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		   cMaeAlu,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path Anterior

       LOCAL oBrowse := NIL                  // Browse de Bancos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       LeePathMaA(lShared,cPatSis,cAnoUsr,;
		  @cIntUno,@cIntDos,@cIntTre,@cIntCua,.F.)
     *ÀLectura de paths

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
       cPatAnt := cIntUno+'\'+cPatAnt
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMaeMtr(lShared,cPatAnt,cMaeAlu,SUBS(cAnoAnt,3,2)) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePag,'PAG',cPatSis+'\'+fNtxPag,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO PAGOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELECT &cMaeAct
       lHayErr := .T.
       DO CASE

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE PAG->(RECCOUNT()) == 0
	    cError('NO EXISTEN PAGOS REGISTRADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS TARIFAS DE PAGO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT PAG
       oBrowse := oDefBrwPag(lShared,nFilPal+1,00,22,79,cMaeAct)

       SETKEY(K_F5,{||BuscarPag(oBrowse,cMaeAct)})

       SETKEY(K_F9,{||MenuOtrPag(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
				 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
				 cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
				 cMaeAlu,cMaeAct,cJorTxt,oBrowse)})

       PAG->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F5,NIL)
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE PAGOS	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:00 PM   OCT 06/98 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo Pagos

SINTAXIS:

 oBrowse := oDefBrwPag(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwPag(lShared,nFilSup,nColSup,nFilInf,nColInf,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAct			            // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Pagos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<MANTENIMIENTO DE PAGOS >>',;
			    '<F5>Buscar <F9>Otros <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PAG
       oColumn	     := TBCOLUMNNEW('CODIGO;ESTUDIANTE', {||PAG->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('GRUPO A¥O;ANTERIOR', {||PAG->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('GRUPO A¥O;SGTE',{||PAG->cCodNewGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)

     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL;ESTUDIANTE',;
				    {||cSekNomAlu(PAG->cCodigoEst,;
						  cMaeAct,'PAG')})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width:= 40
       oBrowse:Freeze:= 3
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF !ANO->lPrePrnAno
	  oColumn	     := TBCOLUMNNEW('RECIBO No',{||PAG->nNroFacAno})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',{||PAG->nMesIniPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',{||PAG->nMesFinPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR MES', {||PAG->nVlrMesPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR PAGADO', {||PAG->nVlrPagPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ESTADO',{||cNomEstado(PAG->cEstadoPag)})
       oColumn:Width := 8
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE PAGO',{||cFecha(PAG->dFecPagPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PAGO OPO',{||cFecha(PAG->dPagOpoPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PAGO EXT',{||cFecha(PAG->dPagExtPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FACTURADO',{||cFecha(PAG->dFecFacPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INTERES%',{||PAG->nIntMorPag})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},;
			{'FIELD','nIntMorPag'}, {'PICTURE','@X'}}
*       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR MORA', {||PAG->nVlrMorPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS COBRADOS',;
			{||PAG->cConcepPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 1', {||PAG->nVlrCo1Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 2', {||PAG->nVlrCo2Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 3', {||PAG->nVlrCo3Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 4', {||PAG->nVlrCo4Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 5', {||PAG->nVlrCo5Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 6', {||PAG->nVlrCo6Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 7', {||PAG->nVlrCo7Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 8', {||PAG->nVlrCo8Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BANCO',{||PAG->cCodigoBan})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||PAG->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('VALOR PAGOS;PARCIALES',;
				   {||PAG->nPagParPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('VALOR DE LOS;DESCUENTOS',;
				   {||PAG->nVlrDesPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR DE LOS;RECARGOS',;
				   {||PAG->nVlrRecPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION',{||PAG->cObservPag})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cObservPag'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('USUARIO', {||PAG->cNomUsrPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(PAG->dFecUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||PAG->cHorUsrPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL CLIENTE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Debe estar en uso los archivos de Pagos

2- Busca el c¢digo del Cliente

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarPag(oBrowse,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse				    // Browse de Pagos
       cMaeAct                              // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegPag := 0                   // Registro del Pago
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''              // C¢digo del cliente
       LOCAL cMatricTpa := ''              // Mes inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTes := cSpaces('PAG','cCodigoEst')
       cMatricTpa := cSpaces('PAG','cMatricPag')
       TitBuscar(LEN(cCodigoTes)+3,@nNroFil,@nNroCol)

       @ nNroFil,nNroCol GET cCodigoTes PICT '999999';
			 VALID lCorrecion(@cCodigoTes)

       @ nNroFil,nNroCol+7 GET cMatricTpa PICT '9' VALID ;
			   lValClaMat(ROW(),COL(),@cMatricTpa)
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
       SELECT PAG
       IF lBuscar .AND. lSekCodigo(cCodigoTes+cMatricTpa,'PAG')
	  nRegPag := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nRegPag
	  oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: NOMBRE DEL ESTADO DEL PAGO            	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Retorna la forma de pago seg£n el c¢digo de la forma de pago

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomEstado(cEstado)

*>>>>PARAMETROS DE LA FUNCION
/*     cEstado                              // C¢digo del Estado del pago */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cEstadoTpa := ''               // Nombre de Estado del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA FORMA DE PAGO
       DO CASE
       CASE cEstado == 'P'
	     cEstadoTpa := 'PAGO OPO'
       CASE cEstado == 'A'
	     cEstadoTpa := 'PAGO EXT'
       CASE cEstado == 'D'
	     cEstadoTpa := 'NO PAGO '
       CASE cEstado == '*'
	     cEstadoTpa := 'DEUDOR  '
       OTHERWISE
	     cEstadoTpa := 'ERROR   '
       ENDCASE
       RETURN cEstadoTpa
*>>>>FIN ANALISIS DE LA FORMA DE PAGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DE LA CLASE DE RECIBO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/95 JUE A
       Colombia, Bucaramanga        INICIO: 11:20 AM   MAY 11/95 JUE

OBJETIVOS:

1- Realiza la validaci¢n del c¢digo

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValClaMat(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<MATRICULA>',;
		  '2<PENSION  >'}

       aAyudas := {'Matr¡cula',;
		   'Pensi¢n'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       IF cCodigo # '0' .AND. cCodigo # '1'

	  SAVE SCREEN
	  nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	  RESTORE SCREEN

	  IF nNroOpc == 0
	     cCodigo := SPACE(01)
	  ELSE
	     cCodigo := SUBS('10',nNroOpc,1)
	  ENDIF

       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: ESTADO DE CUENTA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 14/95 MAR A
       Colombia,Bucaramanga         INICIO: 11:00 AM   MAR 14/95 MAR

OBJETIVOS:

1- Debe estar en uso el maestro de alumnos.

2- Debe estar en uso del archivo de pagos

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EstadoCta(lShared,nFilInf,nColInf,cMaeAct,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila de Impresi¢n
       nColInf                              // Columna de Impresi¢n
       cMaeAct                              // Maestro Actual
       cTitulo                              // T¡tulo de la Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cCodigo := ''                  // Codigo del cliente
       LOCAL nVlrDeu := 0                   // Valor de la Deuda
       LOCAL nVlrInt := 0                   // Valor de los Intereses

       LOCAL bCodF02 := NIL                 // Code Block asignado a F2
       LOCAL bCodF03 := NIL                 // Code Block asignado a F3
       LOCAL bCodF04 := NIL                 // Code Block asignado a F4
       LOCAL bCodF05 := NIL                 // Code Block asignado a F5
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESACTIVACION DE LAS TECLAS DE FUNCION
      bCodF02 := SETKEY(K_F2)
      bCodF03 := SETKEY(K_F3)
      bCodF04 := SETKEY(K_F4)
      bCodF05 := SETKEY(K_F5)

      SETKEY(K_F2,NIL)
      SETKEY(K_F3,NIL)
      SETKEY(K_F4,NIL)
      SETKEY(K_F5,NIL)
*>>>>FIN DESACTIVACION DE LAS TECLAS DE FUNCION

*>>>>IMPRESION DEL NOMBRE
       cSavPan := SAVESCREEN(0,0,24,79)
       cTitulo := IF(cTitulo == NIL,'ESTADO DE CUENTA DEL ESTUDIANTE',cTitulo)
       nNroFil := nMarco(nFilInf+1,cTitulo,22,'°')
       nNroCol := nColInf
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+&cMaeAct->cCodigoEst
       @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+RTRIM(&cMaeAct->cApelliEst)+' '+;
					   &cMaeAct->cNombreEst
       @ nNroFil,nNroCol+65 SAY 'CURSO:'+&cMaeAct->cCodigoGru
*>>>>FIN IMPRESION DEL NOMBRE

*>>>>ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
       IF &cMaeAct->lRetiroEst
	  SET COLOR TO G*
	  @ nNroFil+1,nNroCol+23 SAY 'RETIRADO'
	  SET COLOR TO
       ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*>>>>LOCALIZACION DEL RECIBO DE MATRICULA
       IF !lLocPagMat(&cMaeAct->cCodigoEst)
	  SELECT &cMaeAct
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL RECIBO DE MATRICULA

*>>>>CALCULO DE LOS INTERESES
       IF PAG->lIntPenPag
	  nVlrInt  := ROUND((PAG->nVlrMesPag*;
			     PAG->nIntmorPag)/100,0)
       ELSE
	  nVlrInt := PAG->nVlrMorPag
       ENDIF
*>>>>FIN CALCULO DE LOS INTERESES

*>>>>ANALISIS DE LA FORMA DE PAGO
       DO CASE
       CASE PAG->cEstadoPag == 'P'
	    nVlrInt := 0
	    nVlrDeu := 0

       CASE PAG->cEstadoPag == 'A'
	    nVlrDeu := 0

       CASE PAG->cEstadoPag == 'D'
	    nVlrDeu := PAG->nVlrMesPag
       ENDCASE
*>>>>FIN ANALISIS DE LA FORMA DE PAGO

*>>>>CONSULTA DEL ESTADO DE CUENTA
       nNroFil += 2
       @nNroFil,nNroCol+00 SAY 'SALDO ACTUAL: '+STR(nVlrDeu+nVlrInt,10,2)
       @nNroFil,nNroCol+26 SAY 'DEUDA: '+STR(nVlrDeu,10,2)
       @nNroFil,nNroCol+45 SAY 'MORA: ' +STR(nVlrInt,10,2)


       SET COLOR TO G*
       @nNroFil,nNroCol+63 SAY IF(nVlrDeu == 0,'PAZ Y SALVO','MOROSO')
       SET COLOR TO

       IF !EMPTY(&cMaeAct->cConcepEst)
	  ConsultCon(nNroFil+1,nNroCol+00,&cMaeAct->cConcepEst)
       ENDIF
*>>>>FIN CONSULTA DEL ESTADO DE CUENTA

*>>>>FILTRACION DE LOS PAGOS
       cCodigo := &cMaeAct->cCodigoEst
       SELECT PAG
       SET FILTER TO PAG->cCodigoEst == cCodigo
       IF EOF()
	  cError('NO EXISTEN PAGOS REGISTRADOS PARA EL ESTUDIANTE')
       ELSE
	 PAG->(CtrlBrw(lShared,oConBrwPag(10,01,22,78)))
       ENDIF
*>>>>FIN FILTRACION DE LOS PAGOS

*>>>>ACTIVACION DE LAS TECLAS DE FUNCION
       SETKEY(K_F2,bCodF02)
       SETKEY(K_F3,bCodF03)
       SETKEY(K_F4,bCodF04)
       SETKEY(K_F5,bCodF05)

       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT &cMaeAct
       RETURN NIL
*>>>>FIN ACTIVACION DE LAS TECLAS DE FUNCION

/*************************************************************************
* TITULO DE LA FUNCION..: OBJETO BROWSE CONSULTA DE PAGOS	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 16/95 MIE A
       Colombia,Bucaramanga         INICIO: 12:00 AM   MAR 16/95 MIE

OBJETIVOS:

1- Define el objeto Browse consulta de los detalles del Pago

SINTAXIS:

 oBrowse := oConBrwPag(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oConBrwPag(nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Pagos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<DETALLES DE LOS PAGOS>>',;
			    '<ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PAG
       oColumn	     := TBCOLUMNNEW('MES',;
			{||cMes(PAG->nMesIniPag,03)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',;
			{||cMes(PAG->nMesFinPag,03)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR MES', {||PAG->nVlrMesPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POR PAGAR', {||PAG->nVlrMesPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ESTADO',{||cNomEstado(PAG->cEstadoPag)})
       oColumn:Width := 8
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE PAGO',{||cFecha(PAG->dFecPagPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PAGO OPO',{||cFecha(PAG->dPagOpoPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PAGO EXT',{||cFecha(PAG->dPagExtPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FACTURADO',{||cFecha(PAG->dFecFacPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF PAG->lIntPenPag
	  oColumn	:= TBCOLUMNNEW('INTERES%',{||PAG->nIntMorPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF !PAG->lIntPenPag
	  oColumn	:= TBCOLUMNNEW('VALOR MORA', {||PAG->nVlrMorPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS COBRADOS',;
			{||PAG->cConcepPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||PAG->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('USUARIO', {||PAG->cNomUsrPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 15/2005 JUE A
       Bucaramanga, Colombia        INICIO: 10:00 AM   DIC 15/2005 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrPag(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		    cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		    cMaeAlu,cMaeAct,cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

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
       AADD(aMenus,'1<VALIDAR CONCEPTOS')

       AADD(aAyuda,'Permite Validar los conceptos facturados')

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
	    OtrPag011(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		      nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		      cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		      cMaeAlu,cMaeAct,cJorTxt,oBrowse)
	   *Validar conceptos

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: VALIDAR CONCEPTOS FACTURADOS                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 15/2005 JUE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   DIC 15/2005 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrPag011(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		   cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		   cMaeAlu,cMaeAct,cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cTxtTem := ''                  // Texto Temporal

       LOCAL cNalias := ''                  // Alias Antiguos o nuevos
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL aVlrCon := {}                  // Valor de los Conceptos

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       LOCAL cCodigoTco := ''               // C¢digo del Concpeto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR PAGOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cMsgTxt := 'CONSULTANDO LAS TARIFAS POR CONCEPTOS'
       nNroFil := nMarco(03,cMsgTxt)
       SELECT PAG
       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ºCODIGO: '+PAG->cCodigoEst+;
			'ºNo. '+ALLTRIM(STR(PAG->(RECNO()),6))+'/'+;
				ALLTRIM(STR(PAG->(RECCOUNT()),6)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DEL ESTUDIANTE
	    IF SUBS(PAG->cCodigoEst,1,3) == SUBS(cAnoUsr,1,1)+cAnoSis

*==============ESTUDIANTE NUEVO
		 cNalias := 'ADM'
		 IF !lLocCodigo('cCodigoEst','ADM',PAG->cCodigoEst)

		    cError(PAG->cCodigoEst+' ESTUDIANTE NUEVO NO EXISTE')

		    SELECT PAG
		    PAG->(DBSKIP())
		    LOOP

		 ENDIF
*==============FIN ESTUDIANTE NUEVO

	    ELSE

*==============ESTUDIANTE ANTIGUO
		 IF !lSekCodMae(PAG->cCodigoEst,cMaeAlu,@cMaeAct)

		    cError(PAG->cCodigoEst+' NO EXISTE EN EL MAESTRO')

		    SELECT PAG
		    PAG->(DBSKIP())
		    LOOP

		 ENDIF
		 cNalias := cMaeAct
*==============FIN ESTUDIANTE ANTIGUO

	    ENDIF
	    cTxtTem := PAG->cCodigoEst
**********FIN ANALISIS DEL ESTUDIANTE

**********ANALISIS SI EL ESTUDIANTE ES REPITENTE
	    IF cNalias # 'ADM'
	       IF &cNalias->lRepiteEst
		  IF SUBS(&cNalias->cCodigoGru,1,2) == '17'
		     cCodigoTgr := '0000'
		  ELSE
		     cCodigoTgr := SUBS(&cNalias->cCodigoGru,1,2)+'00'
		  ENDIF
	       ELSE
		  IF SUBS(&cNalias->cCodigoGru,1,2) == '16'
		     cCodigoTgr := '00'
		  ELSE
		     IF SUBS(&cNalias->cCodigoGru,1,2) == '17'
			cCodigoTgr := '01'
		     ELSE
			cCodigoTgr := STR(VAL(SUBS(&cNalias->cCodigoGru,1,2))+1,2)
		     ENDIF
		  ENDIF
		  lCorrecion(@cCodigoTgr)
		  cCodigoTgr += '00'
	       ENDIF
	    ELSE
	       cCodigoTgr := &cNalias->cCodigoGru
	    ENDIF
	    cTxtTem += ' '+cCodigoTgr
**********FIN ANALISIS SI EL ESTUDIANTE ES REPITENTE

**********TARIFA DEL CONCEPTO
	    aVlrCon := {}
	    FOR i := 1 TO LEN(ALLTRIM(PAG->cConcepPag))/2

		cCodigoTco := SUBS(PAG->cConcepPag,i*2-1,2)

		nVlrCon := nValorTar(cCodigoTgr,cCodigoTco)
		AADD(aVlrCon,nVlrCon)

		cTxtTem += ' '+STR(i,1)+':'+STR(nVlrCon)

	    ENDFOR
**********FIN TARIFA DEL CONCEPTO

**********GRABACION DE LOS CONCEPTOS
	    IF PAG->(lRegLock(lShared,.F.))

	       REPL PAG->cCodigoGru WITH &cNalias->cCodigoGru
	       REPL PAG->cCodNewGru WITH cCodigoTgr
	       IF nSuma(aVlrCon) == PAG->nVlrPagPag
		  FOR i := 1 TO LEN(aVlrCon)
		      REPL PAG->&('nVlrCo'+STR(i,1)+'Pag') WITH aVlrCon[i]
		  ENDFOR
	       ELSE
		  REPL PAG->cObservPag WITH STR(nSuma(aVlrCon),10,2)
	       ENDIF
	       PAG->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA LA FORMA DE PAGO')
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS CONCEPTOS

**********VISUALIZACION
	    @ nNroFil,01 SAY cTxtTem
	    nNroFil++
	    IF nNroFil == 21
	       nNroFil := nMarco(03,cMsgTxt)
	    ENDIF
**********FIN VISUALIZACION

	  SELECT PAG
	  PAG->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       PAG->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN RECORRIDO POR PAGOS