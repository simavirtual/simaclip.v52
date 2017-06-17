/*                      SIMASOFT - SISTEMA ADMINISTRADOR
		       FUNCIONES DEL ARCHIVO DE COMUNIDAD

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:00 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCmd(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL     i,j := 0                   // Contadores
       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL aRegIni := {}                  // Registros Iniciales
       LOCAL cCampo  := ''                  // Nombre del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoCmd","Character",04,0})  // C¢digo de la Comunidad
       AADD(aDbfStr,{"cNombreCmd","Character",60,0})  // Nombre de la Comunidad
       AADD(aDbfStr,{"cCodigoCiu","Character",03,0})  // Pais de la Comunidad
       AADD(aDbfStr,{"cNomZonCmd","Character",40,0})  // Nombre de la Zona de la Comunidad
       AADD(aDbfStr,{"cTituloCmd","Character",30,0})  // T¡tulo de la Comunidad
       AADD(aDbfStr,{"cNroNitCmd","Character",12,0})  // N£mero del Nit de la Comunidad
     *ÀDetalles de la Comunidad
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := DIRNAME()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'ARC',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL SISTEMA')
	  CloseDbf('ARC',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>REGISTROS POR DEFECTO
       aRegIni := {}

       AADD(aRegIni,{{'ARC->cCodigoCmd','9999'},;
		     {'ARC->cNombreCmd','COMUNIDAD DEMO'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','PENDIENTE ZONA'},;
		     {'ARC->cTituloCmd','DEMO'},;
		     {'cNroNitCmd','NIT'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0001'},;
		     {'ARC->cNombreCmd','CONGREGACION DE LOS HERMANOS DE LAS ESCUELAS CRISTIANAS'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','DISTRITO DE BOGOTA'},;
		     {'ARC->cTituloCmd','HERMANOS DE LA SALLE'},;
		     {'cNroNitCmd','8600099850'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0002'},;
		     {'ARC->cNombreCmd','CONGREGACION DE LOS HERMANOS DE LAS ESCUELAS CRISTIANAS'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','DISTRITO DE PANAMA'},;
		     {'ARC->cTituloCmd','HERMANOS DE LA SALLE'},;
		     {'cNroNitCmd','NIT'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0003'},;
		     {'ARC->cNombreCmd','HERMANAS BETHLEMITAS'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','PENDIENTE ZONA'},;
		     {'ARC->cTituloCmd','HERMANAS BETHLEMITAS'},;
		     {'cNroNitCmd','NIT'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0004'},;
		     {'ARC->cNombreCmd','COMUNIDAD FRANCISCANA'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','PENDIENTE ZONA'},;
		     {'ARC->cTituloCmd','COMUNIDAD FRANCISCANA'},;
		     {'cNroNitCmd','860020342-1'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0005'},;
		     {'ARC->cNombreCmd','CONGREGACION HNAS DE CARIDAD DOMINICAS DE LA PRESENTACION'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','PENDIENTE ZONA'},;
		     {'ARC->cTituloCmd','DOMINICAS DE LA PRESENTACION'},;
		     {'cNroNitCmd','860006745-6'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0006'},;
		     {'ARC->cNombreCmd','SAN CARLOS'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','PENDIENTE ZONA'},;
		     {'ARC->cTituloCmd','SAN CARLOS'},;
		     {'cNroNitCmd','NIT'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0007'},;
		     {'ARC->cNombreCmd','ASOPAF - INSTITUTO SAN BERNARDO DE LA SALLE'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','PENDIENTE ZONA'},;
		     {'ARC->cTituloCmd','ASOPAF-ISB'},;
		     {'cNroNitCmd','NIT'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0008'},;
		     {'ARC->cNombreCmd','INSTITUCION EDUCATIVA DISTRITAL'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','PENDIENTE ZONA'},;
		     {'ARC->cTituloCmd','IED'},;
		     {'cNroNitCmd','NIT'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0009'},;
		     {'ARC->cNombreCmd','HIJAS DE LA SABIDURIA'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','BOGOTA'},;
		     {'ARC->cTituloCmd','HIJAS DE LA SABIDURIA'},;
		     {'cNroNitCmd','NIT'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0010'},;
		     {'ARC->cNombreCmd','COMUNIDAD MONTESSORI'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','CARTAGENA'},;
		     {'ARC->cTituloCmd','COMUNIDAD MONTESSORI'},;
		     {'cNroNitCmd','NIT'}})

       AADD(aRegIni,{{'ARC->cCodigoCmd','0011'},;
		     {'ARC->cNombreCmd','PARQUEADEROS'},;
		     {'ARC->cCodigoCiu','COL'},;
		     {'ARC->cNomZonCmd','LOCAL'},;
		     {'ARC->cTituloCmd',''},;
		     {'cNroNitCmd','NIT'}})
*>>>>FIN REGISTROS POR DEFECTO

*>>>>GRABACION DE LOS REGISTROS
       FOR i := 1 TO LEN(aRegIni)

	   IF ARC->(lRegLock(lShared,.T.))
	      FOR j := 1 TO LEN(aRegIni[i])
		  cCampo := aRegIni[i][j][1]
		  REPL &cCampo WITH aRegIni[i][j][2]
		  ARC->(DBCOMMIT())
	      ENDFOR
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	   ENDIF
	   IF lShared
	      ARC->(DBUNLOCK())
	   ENDIF

       ENDFOR
       CloseDbf('ARC',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:05 PM   SEP 09/2002 LUN

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCmd(lShared,nModCry,PathArc,fArchvo,fNtxArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc			            // Path del Archivo
       fArchvo			            // Nombre del Archivo
       fNtxArc			            // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfCmd(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:10 PM   SEP 09/2002 LUN

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

FUNCTION nActStrCmd(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ARC',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('ARC')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ARC->(DBSTRUCT())
       CloseDbf('ARC')
       CreaDbfCmd(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
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
	  cError('El Archivo COMUNIDADES su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfCmd(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:15 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenCmd(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"        // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL bCodIns := NIL                 // CodeBlock Inserci¢n de Registros
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSof,'SOF',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileCmd,'ARC',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SOF->(RECCOUNT()) == 0
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
       IF !lLocCodigo('nCodigoPrn','PRN',SOF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DEFINICION DEL BROWSE
       SELECT ARC
       cTitSup := '<< MANTENIMIENTO DE COMUNIDADES >>'
      *ÀT¡tulo Superior del Browse

       aCampos := {}
       AADD(aCampos,{{"CODIGO","cCodigoCmd"},;
		     {{'MODI',.F.}}})

       AADD(aCampos,{{"TIPO DE EMPRESA","cNombreCmd"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cNombreCmd'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PAIS","cCodigoCiu"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cCodigoCiu'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"ZONA DE LA COMUNIDAD","cNomZonCmd"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cNomZonCmd'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"TITULO DE COMUNIDAD","cTituloCmd"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cTituloCmd'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"NIT DE LA COMUNIDAD","cNroNitCmd"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cNroNitCmd'},{'PICTURE','@!'}}})

       cTitInf := '<INS>Incluir <F5>Buscar <F9>Otros <ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       bCodIns := {||IncluirCmd(lShared)}

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos,bCodIns)
     *Creaci¢n del Browse
*>>>>FIN DEFINICION DEL BROWSE

*>>>>BROWSE DEL ARCHIVO
       SELECT ARC

       SETKEY(K_F5,{||BuscarCmd(oBrowse)})
       SETKEY(K_F9,{||MenuOtrCmd(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
				 cAnoUsr,cPatSis,oBrowse)})
       CtrlBrw(lShared,oBrowse)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DEL ARCHIVO

/*************************************************************************
* TITULO..: INCLUCION DE UN REGISTRO          	                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:20 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirCmd(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTti := ''               // C¢digo del Concepto
       LOCAL cNombreTti := ''               // Nombre del Concepto

       LOCAL cCodigoTcm := ''               // C¢digo de la Comunidad
       LOCAL cNombreTcm := ''               // Nombre de la Comunidad
       LOCAL cCodigoTci := ''               // C¢digo de la Ciudad
       LOCAL cNomZonTcm := ''               // Nombre de la Zona
       LOCAL cTituloTcm := ''               // T¡tulo de la Comunidad
       LOCAL cNroNitTcm := ''               // N£mero del Nit de la Comunidad
*>>>>FIN DECLARACION DE VARIABLES



*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR DIGITE LOS TIPOS '+;
			 'DE EMPRESAS',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE VARIABLES
	    IF !lHayErr
	       cCodigoTcm := cSpaces('ARC','cCodigoCmd')
	       cNombreTcm := cSpaces('ARC','cNombreCmd')
	       cCodigoTci := cSpaces('ARC','cCodigoCiu')
	       cNomZonTcm := cSpaces('ARC','cNomZonCmd')
	       cTituloTcm := cSpaces('ARC','cTituloCmd')
	       cNroNitTcm := cSpaces('ARC','cNroNitCmd')
	    ENDIF
**********FIN INICIALIZACION DE VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DE COMUNIDAD   :';
				GET cCodigoTcm PICT '9999';
				VALID !lValCodCmd(cCodigoTcm)

	    @ nNroFil+1,nNroCol SAY 'NOMBRE DE LA COMUNIDAD:';
				GET cNombreTcm PICT '@!'

	    @ nNroFil+2,nNroCol SAY 'CODIGO DEL PAIS       :';
				GET cCodigoTci PICT '@!'

	    @ nNroFil+3,nNroCol SAY 'NOMBRE DE LA ZONA     :';
				GET cNomZonTcm PICT '@!'

	    @ nNroFil+4,nNroCol SAY 'TITULO DE COMUNIDAD   :';
				GET cTituloTcm PICT '@!'

	    @ nNroFil+5,nNroCol SAY 'NIT DE LA COMUNIDAD   :';
				GET cNroNitTcm PICT '@!'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE EMPTY(cCodigoTcm) .OR. EMPTY(cNombreTcm) .OR.;
		 EMPTY(cCodigoTci) .OR. EMPTY(cNomZonTcm) .OR.;
		 EMPTY(cTituloTcm) .OR. EMPTY(cNroNitTcm)

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
       SELECT ARC
       IF lGrabar
	  IF ARC->(lRegLock(lShared,.T.))
	     REPL ARC->cCodigoCmd WITH cCodigoTcm
	     REPL ARC->cNombreCmd WITH cNombreTcm
	     REPL ARC->cCodigoCiu WITH cCodigoTci
	     REPL ARC->cNomZonCmd WITH cNomZonTcm
	     REPL ARC->cTituloCmd WITH cTituloTcm
	     REPL ARC->cNroNitCmd WITH cNroNitTcm
	     ARC->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  ARC->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:25 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodCmd(cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				    // C¢digo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF lLocCodigo('cCodigoCmd','ARC',cCodigo) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: BUSCAR EL CODIGO                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:30 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Debe estar en uso los archivo.

2- Busca el c¢digo.

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarCmd(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			            // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''                  // C¢digo de Buscar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigo := cSpaces('ARC','cCodigoCmd')
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '9999';
			 VALID lValidaCmd(ROW(),COL()-1,@cCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(cCodigo)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT ARC
       IF lBuscar .AND. lLocCodigo('cCodigoCmd','ARC',cCodigo)
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:35 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValidaCmd(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo				    // C¢digo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('cCodigoCmd','ARC',cCodigo)
	  nNroReg := nSelCodCmd(nNroFil,nNroCol)
	  IF nNroReg == 0
	     cCodigo := 0
	  ELSE
	     GO nNroReg
	     cCodigo := ARC->cCodigoCmd
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:40 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger el registro del archivo de acuerdo al nombre.

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelCodCmd(nNroFil,nNroCol)

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
       IF ARC->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT ARC
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
       ARC->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||ARC->cNombreCmd})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL REGISTRO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:45 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrCmd(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,;
		    oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
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
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<COMUNIDADES>')

       AADD(aAyuda,'Imprime los C¢digos de las Comunidades')

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
	    OtrCmd011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		      nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,;
		      oBrowse)
	   *Impresi¢n de las Comunidades

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:50 PM   SEP 09/2002 LUN

OBJETIVOS:

1- Imprime los campos del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrCmd011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,;
		   oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
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
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

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

       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF ARC->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := ARC->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'COMUNIDADES',;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO



*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,60}
       aTitulo := {'CODIGO','COMUNIDAD'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .T.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       ActivaPrn(lShared,cNomSis,PathSis,fSimSof,'cColaAcSof','Sof')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(SOF->lPrnArcSof)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY PCL({"Reset"})
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT ARC
       GO TOP
       DO WHILE .NOT. ARC->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( ARC->(RECNO()) / ARC->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aTitulo := {ARC->cCodigoCmd,;
			ARC->cNombreCmd}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ARC
	    ARC->(DBSKIP())
	    IF ARC->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS