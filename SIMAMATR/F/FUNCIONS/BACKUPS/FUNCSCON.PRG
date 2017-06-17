/*                       SIMA - CARTERA ACADEMICA
		BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CONCEPTOS

REQUERIMIENTOS:

- Compilar: clipper funcsCon /w/m/b

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

   CreaDbfCon(PathCon,FileCon,lIntUno,fNtxCon)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCon(lShared,PathCon,FileCon,fNtxCon,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathCon				    // Path del Archivo
       FileCon				    // Nombre del Archivo
       fNtxCon				    // Archivo de Indices
       aStrDbf                              // Estructura de Archivos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfCon := {{"cCodigoCon","Character",02,0},;
			 {"cNombreCon","Character",16,0},;
			 {"lBecadoCon","Logical"  ,01,0},;
			 {"nValorCon" ,"Numeric"  ,12,2},;
			 {"nTipoCon"  ,"Numeric"  ,01,0},; // Tipo Concepto 0=>Pensi¢n, 1=>Ruta 2=>Cafeteria
			 {"lSiCertCon","Logical"  ,01,0},; // .T. Si Certificado
			 {"cCodCerCon","Character",02,0},; // C¢digo para el Certificado
			 {"cNomCerCon","Character",16,0},; // Nombre para el Certificado
			 {"lDesEfeDes","Logical"  ,01,0},; // .T. Descuento del Efectivo .F. No Descuento de Efectio implica ingreso
			 {"cNomExtCon","Character",16,0}}  // Nombre Extra
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfCon
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCon) == 0
	    DBCREATE(FileCon,aDbfCon,"DBFNTX")

       CASE DIRCHANGE(PathCon) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCon)

       CASE DIRCHANGE(PathCon) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCon)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathCon+'\'+FileCon,'CON',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO CONCEPTOS EN CREACION DE ESTRUCTURAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF CON->(lRegLock(lShared,.T.))
	  REPL CON->cCodigoCon WITH 'PE'       // Pensi¢n
	  REPL CON->cNombreCon WITH 'PENSION'
	  CON->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL EN CONCEPTOS')
       ENDIF
       IF lShared
	  CON->(DBUNLOCK())
       ENDIF
       CloseDbf('CON')
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

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

FUNCTION RecuDbfCon(lShared,PathCon,FileCon,fNtxCon)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathCon			      // Path del Archivo
       FileCon			      // Nombre del Archivo
       fNtxCon			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCon+'\'+FileCon,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONCEPTOS")
       Termometro(100)

       CreaDbfCon(lShared,PathCon,FileCon,fNtxCon)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2001 LUN A
       Colombia, Bucaramanga        INICIO: 03:45 AM   OCT 08/2001 LUN

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

FUNCTION nActDbfCon(lShared,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'CON',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONCEPTOS')
	  CloseDbf('CON',PathArc+'\'+cNomArc)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := CON->(DBSTRUCT())
       CloseDbf('CON',PathArc+'\'+cNomArc)
       CreaDbfCon(lShared,PathArc,cNomArc,,@aStrNew)
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
	  cError('El Archivo CONCEPTOS su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfCon(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: CONSULTA LOS CONCEPTO A COBRAR                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/94 SAB A
						       AGO 13/94 SAB
OBJETIVOS:

1- Debe estar en uso el archivo de conceptos

2- Visualiza los conceptos por cobrar


SINSTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ConsultCon(nFilPal,nColPal,cConcep)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilPal                              // Fila Superior
       nColPal                              // Columna Superior
       cConcep                              // Conceptos por cobrar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL       i := 0                   // Contador
       LOCAL lHayErr := .T.                 // .T. Hay Error

       LOCAL cCodigoTco := ''               // C¢digo del concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONSULTA DE LOS CONCEPTOS POR COBRAR
       nNroFil := nFilPal
       nNroCol := nColPal
       SELECT CON
       i := 1
       DO WHILE i <= LEN(RTRIM(cConcep))/2

	  cCodigoTco := SUBS(cConcep,i*2-1,2)
	  LOCATE FOR CON->cCodigoCon == cCodigoTco

	  IF FOUND()
	     SET COLOR TO I
	     @ nNroFil,nNroCol  SAY RTRIM(CON->cNombreCon)
	     nNroCol := nNroCol+LEN(RTRIM(CON->cNombreCon))+1

	     IF nNroCol > 62
		SET COLOR TO
		nNroCol := nColPal
		cPausa()
		@ nNroFil,00 CLEAR TO nNroFil,79
	       *Limpia la linea de impresion de los conceptos a cobrar
		SET COLOR TO I
	     ENDIF
	  ELSE
	     cError('EL CODIGO DEL CONCEPTO '+cCodigoTco+' NO SE ENCUENTRA')
	     SET COLOR TO
	     lHayErr := .F.
	  ENDIF

	  i := i + 1

       ENDDO
       SET COLOR TO
       RETURN lHayErr
*>>>>FIN CONSULTA DE LOS CONCEPTOS POR COBRAR

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRIME LOS CONCEPTO A COBRAR                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 04:20 PM   AGO 09/96 VIE

OBJETIVOS:

1- Debe estar en uso el archivo de conceptos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Imprime los conceptos por cobrar del recibo de pago sencillo o por
   adelantado de acuerdo como se pasen los param‚tros de la funci¢n.

4- Esta funci¢n forma parte del funci¢n nVlrRecibo

5- Retorna El valor total de recibo sin intereses

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrConcep(cConcep)

*>>>>PARAMATROS DE LA FUNCION
/*     cConcep                              // Conceptos por cobrar */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cBlanco := ''                  // Linea en Blanco
       LOCAL nValor  := 0                   // Valor del Concepto
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL cNombreTco := ''               // Nombre del concepto
       LOCAL  nValorTco := ''               // Valor del concepto
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       cBlanco := '|                |         |         |         |'
       cConcep += SPACE(02)
       SELECT CON
       i := 1
       DO WHILE i <= (LEN(cConcep)/2)

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SUBS(cConcep,i*2-1,2)
	   *Lectura del concepto a cobrar

	    IF cCodigoTco == SPACE(02)
	       Linea_Recibo(cBlanco)
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LOCALIZACION DEL CONCEPTO
	    nValorTco := 0
	    IF lLocCodigo('cCodigoCon','CON',cCodigoTco)
		nValorTco := CON->nValorCon
	       cNombreTco := CON->cNombreCon
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN LOCALIZACION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       cMsgTxt :='|'+cNombreTco+;
			 '|         |'+STR(nValorTco,9,2)+;
			 '| '+STR(nSubTot,8,2)+'|'
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES DE LOS CONCEPTOS

**********IMPRESION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       Linea_Recibo(cMsgTxt)

	       nVlrTot := nVlrTot + nSubTot
	      *Suma del total a pagar
	    ENDIF
**********FIN IMPRESION DEL VALOR DEL CONCEPTO

	  i := i + 1

       ENDDO
       RETURN nVlrTot
*>>>>IMPRESION DE LOS CONCEPTOS

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CONCEPTO                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/94 VIE A
						       JUL 08/94 VIE
OBJETIVOS:

1- Debe estar en uso el archivo Conceptos

2- Realiza la validaci¢n del c¢digo del concepto de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValConcep(nNroFil,nNroCol,cCodCon)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodCon                              // C¢digo del Concepto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegCon := 0                   // Registro del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       IF !lLocCodigo('cCodigoCon','CON',cCodCon)
	  nRegCon := nSelConcep(nNroFil,nNroCol)
	  IF nRegCon == 0
	     cCodCon := cSpaces('CON','cCodigoCon')
	  ELSE
	     GO nRegCon
	     cCodCon := CON->cCodigoCon
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL CONCEPTO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/94 VIE A
						       JUL 08/94 VIE
OBJETIVOS:
1- Debe estar en uso el archivo de Conceptos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite escoger el registro del archivo de acuerdo al nombre del concepto

4- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelConcep(nNroFil,nNroCol)

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
       LOCAL nRegCon := 0                   // Registro del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF CON->(RECCOUNT()) == 0
	  cError('NO EXISTEN CONCEPTOS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CON
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CONCEPTO
       CON->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nRegCon := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||CON->cNombreCon})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nRegCon
*>>>>FIN SELECCION DEL CONCEPTO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE CONCEPTOS         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 VIE A
						       SEP 02/94 VIE
OBJETIVOS:

1- Permite el mantenimiento del archivo Conceptos

SINTAXIS:

MantenCon()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenCon(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
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
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL oBrwCon := NIL                 // Objeto para el Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO CONCEPTOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwCon := oDefBrwCon(lShared,nFilPal+1,00,22,79)
       SETKEY(K_F5,{||BuscarCon(oBrwCon)})
       CON->(CtrlBrw(lShared,oBrwCon))
       SETKEY(K_F5,NIL)
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE CONCEPTOS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 SAB A
						       SEP 02/94 SAB
OBJETIVOS:

1- Define el objeto Browse del archivo Conceptos

SINTAXIS:

 oBrwCon := oDefBrwCon(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwCon(lShared,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse			    // Browse de Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<MANTENIMIENTO DE CONCEPTOS>>',;
			    '<ENTER>Modificar  <INS>Incluir  <F5>Buscar  '+;
			    '<DEL>Borrar  <ESC>Abandonar',;
			     {||IncluirCon(lShared)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CON
       oColumn	     := TBCOLUMNNEW('CODIGO', {||CON->cCodigoCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL CONCEPTO', {||CON->cNombreCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','cNombreCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTO CON BECA', {||CON->lBecadoCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','lBecadoCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR', {||CON->nValorCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'}, {'FIELD','nValorCon'},;
			 {'PICTURE','999999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO DE CONCEPTO', {||CON->nTipoCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','nTipoCon'},;
			 {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CERTIFICADO', {||CON->lSiCertCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','lSiCertCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;CERTIFICADO', {||CON->cCodCerCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','cCodCerCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL CONCEPTO', {||CON->cNomCerCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','cNomCerCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE EXTRA', {||CON->cNomExtCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','cNomExtCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO DE CONCEPTOS 	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 VIE A
						       SEP 02/94 VIE
OBJETIVOS:

1- Incluye un registro al archivo de Conceptos

SINTAXIS:

  IncluirCon()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirCon(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar el registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTco := ''               // Codigo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
       LOCAL  nValorTco := 0                // Valor del Concepto
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DATOS DEL CONCEPTO',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTco := cSpaces('CON','cCodigoCon')
	       cNombreTco := cSpaces('CON','cNombreCon')
	       nValorTco  := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL CONCEPTO:';
				GET cCodigoTco PICT '@!';
				VALID !lValCodCon(cCodigoTco)
	    @ nNroFil+1,nNroCol SAY 'NOMBRE DEL CONCEPTO:';
				GET cNombreTco PICT '@!'
	    @ nNroFil+2,nNroCol SAY 'VALOR DEL CONCEPTO :';
				GET nValorTco  PICT '9999999.99'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF cCodigoTco # cSpaces('CON','cCodigoCon') .AND.;
	       cNombreTco # cSpaces('CON','cNombreCon')
	       lGrabar := .T.
	    ELSE
	       lGrabar := .F.
	       cError('DEBE DAR LOS DATOS COMPLETOS. NO SE GRABA EL REGISTRO')
	    ENDIF
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
       SELECT CON
       IF lGrabar
	  IF CON->(lRegLock(lShared,.T.))
	     REPL CON->cCodigoCon WITH cCodigoTco
	     REPL CON->cNombreCon WITH cNombreTco
	     REPL CON->nValorCon  WITH nValorTco
	     CON->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA LOS DATOS DEL CONCEPTO')
	  ENDIF
       ENDIF
       IF lShared
	  CON->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL CONCEPTO EN EL BROWSE     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 VIE A
						       SEP 02/94 VIE
OBJETIVOS:

1- Localiza el c¢digo del Concepto dentro del Browse de Conceptos

2- Retorna NIL

SINTAXIS:

  BuscarCon(oBrwCon)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarCon(oBrwCon)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwCon			            // Browse de Conceptos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegCon := 0                   // Registro del Concepto
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTco := ''               // Codigo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTco := cSpaces('CON','cCodigoCon')
       TitBuscar(LEN(cCodigoTco),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTco PICT '@!';
			 VALID lValConcep(ROW(),COL()-2,@cCodigoTco)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigoTco == cSpaces('CON','cCodigoCon')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT CON       
       IF lBuscar .AND. lLocCodigo('cCodigoCon','CON',cCodigoTco)
	   nRegCon := RECNO()
	   GO TOP
	   oBrwCon:GOTOP()
	   GO nRegCon
	   oBrwCon:FORCESTABLE()
       ELSE
	   oBrwCon:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL CONCEPTO		*
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 SAB A
						       SEP 02/94 SAB
OBJETIVOS:
1- Debe estar en uso el archivo Conceptos

2- Realiza la validaci¢n del c¢digo del Concepto

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodCon(cCodCon)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodCon			            // C¢digo del Concepto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       IF cCodCon # cSpaces('CON','cCodigoCon')
	  IF lLocCodigo('cCodigoCon','CON',cCodCon)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE LOS CONCEPTOS A COBRAR              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/94 LUN A
						       SEP 19/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de Conceptos

2- Permite leer los c¢digos de los conceptos a cobrar

3- Retorna los c¢digos de los conceptos le¡dos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeConcep(nNroFil,nNroCol,nFilCon,nColCon,cConVal)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil			            // Fila Principal
       nNroCol			            // Columna Principal
       nFilCon                              // Fila Impresion de Conceptos
       nColCon                              // Columna impresion Conceptos
       cConVal                              // Conceptos a validar*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL lSavPan := .T.                 // .T. Salvar Pantalla

       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL nRegCon := 0                   // N£mero de Registro

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CON
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>LECTURA DE LOS CONCEPTOS
       nNroCon := IF(cConVal == NIL,0,LEN(cConVal)/2)
       cConVal := IF(cConVal == NIL,'',cConVal)
       DO WHILE .T.

**********SELECCION DEL CODIGO DEL CONCEPTO
	    SELECT CON
	    CON->(DBGOTOP())
	    nRegCon := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
				  {||CON->cNombreCon},NIL,lSavPan)
	    IF nRegCon == 0
	       EXIT
	    ENDIF
	    CON->(DBGOTO(nRegCon))
	    nNroCon++
**********FIN SELECCION DEL CODIGO DEL CONCEPTO

**********VALIDACION DEL CODIGO DEL CONCEPTO
	    IF nRegCon <> 0

	       DO CASE
	       CASE nNroCon > 7
		    cError('SOLO SE PUEDEN APLICAR SIETE (7) CONCEPTOS')
		    LOOP

	       CASE CON->cCodigoCon $ cCodigoTco .OR.;
		    CON->cCodigoCon $ cConVal

		    cError('EL CONCEPTO '+ALLTRIM(CON->cNombreCon)+;
			   ' YA LO APLICO')
		    LOOP

	       OTHERWISE
		    cCodigoTco = cCodigoTco + CON->cCodigoCon
		    @ nFilCon,nColCon SAY cCodigoTco
		  *ÀAcumulaci¢n de los c¢digos
	       ENDCASE

	    ENDIF
**********FIN VALIDACION DEL CODIGO DEL CONCEPTO

       ENDDO
       RETURN cCodigoTco
*>>>>FIN LECTURA DE LOS CONCEPTOS

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DE LA LECTURA DE LOS CONCEPTOS      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 11/97 MIE A
       Bucaramanga, Colombia	    INICIO: 02:00 PM   JUN 11/97 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de Conceptos

2- Permite la lectura de los c¢digos de los conceptos

3- Valida los conceptos leidos

4- Retorna .T. para permitir la validaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValLeeCon(nNroFil,nNroCol,nFilCon,nColCon,cConcep)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil			            // Fila Principal
       nNroCol			            // Columna Principal
       nFilCon				    // Fila Impresion de Conceptos
       nColCon				    // Columna impresion Conceptos
       cConcep			            // @Conceptos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL lSavPan := .T.                 // .T. Salvar Pantalla

       LOCAL       i := 0                   // Contador
       LOCAL nNroLee := 1                   // N£mero de Lecturas
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL cCodCon := ''                  // C¢digo del Concepto

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS CONCEPTOS
       IF EMPTY(cConcep)
	  RETURN .T.
       ENDIF

       IF lPar(LEN(ALLTRIM(cConcep)))
	  FOR i := 1 TO LEN(ALLTRIM(cConcep))/2
	      cCodCon := SUBS(cConcep,i*2-1,2)
	      IF !lLocCodigo('cCodigoCon','CON',cCodCon)
		 lHayErr := .T.
		 LOOP
	      ENDIF
	      cCodigoTco += cCodCon
	  NEXT
       ELSE
	  @ nFilCon,nColCon SAY SPACE(LEN(cConcep)) COLOR("I")
	  cCodigoTco := ''
	  lHayErr := .T.
       ENDIF

       IF !lHayErr
	  RETURN .T.
       ENDIF
*>>>>FIN VALIDACION DE LOS CONCEPTOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CON
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+16
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>LECTURA DE LOS CONCEPTOS
       DO WHILE .T.

**********SELECCION DEL CODIGO DEL CONCEPTO
	    SELECT CON
	    CON->(DBGOTOP())
	    nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
				  {||CON->cNombreCon},30,lSavPan)
	    IF nNroReg == 0
	       EXIT
	    ENDIF
**********FIN SELECCION DEL CODIGO DEL CONCEPTO

**********ACUMULACION DEL CODIGO DEL CONCEPTO
	    IF nNroReg <> 0

	       CON->(DBGOTO(nNroReg))
	       IF CON->cCodigoCon $ cCodigoTco
		  cError('EL CONCEPTO '+ALLTRIM(CON->cNombreCon)+;
			 ' YA LO APLICO')
	       ELSE

*--------------ANALISIS PARA EL LIMITE DE LOS CONCEPTOS
		 IF nNroLee <= 7
		    cCodigoTco = cCodigoTco + CON->cCodigoCon
		    @ nFilCon,nColCon SAY cCodigoTco COLOR ("I")
		    nNroLee++
		 ELSE
		    cError('SOLO SE PUEDEN APLICAR SIETE (7) CONCEPTOS')
		    EXIT
		 ENDIF
*--------------FIN ANALISIS PARA EL LIMITE DE LOS CONCEPTOS

	       ENDIF

	    ENDIF
**********FIN ACUMULACION DEL CODIGO DEL CONCEPTO

       ENDDO
       cConcep := cCodigoTco+SPACE(LEN(cConcep)-LEN(cCodigoTco))
       RETURN .T.
*>>>>FIN LECTURA DE LOS CONCEPTOS

