/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 13/2008 DIA A
       Colombia, Bucaramanga        INICIO:  06:36 PM  feb 13/2008 DIA

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarNro(oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodNiv := ''                  // C¢digo de b£squeda
       LOCAL cCodMat := ''                  // C¢digo de la Materia
       LOCAL cCodCla := ''                  // C¢digo de la Clase
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodNiv := cSpaces('NRO','cCodigoNiv')
       cCodMat := cSpaces('NRO','cCodigoMat')
       cCodCla := cSpaces('NRO','cCodigoCla')
       TitBuscar(30,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol SAY 'NIVEL' GET cCodNiv PICT '@!';
			 VALID lValNro(ROW(),COL()-3,@cCodNiv)

       @ nNroFil,nNroCol+09 SAY 'MATERIA' GET cCodMat PICT '@!'

       @ nNroFil,nNroCol+22 SAY 'CLASE'  GET cCodCla PICT '@!'

       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodMat == cSpaces('NRO','cCodigoMat') .OR.;
	  cCodCla == cSpaces('NRO','cCodigoCla')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		 'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT NRO
       IF lBuscar

	  SELECT NRO
	  NRO->(DBGOTOP())
	  LOCATE FOR NRO->cCodigoNiv == cCodNiv .AND.;
		     NRO->cCodigoMat == cCodMat .AND.;
		     NRO->cCodigoCla == cCodCla

	  IF NRO->(FOUND())
	     nNroReg := NRO->(RECNO())
	     NRO->(DBGOTOP())
	     oBrowse:GOTOP()
	     NRO->(DBGOTO(nNroReg))
	     oBrowse:FORCESTABLE()
	  ELSE
	     oBrowse:GOTOP()
	  ENDIF

       ELSE
          oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO