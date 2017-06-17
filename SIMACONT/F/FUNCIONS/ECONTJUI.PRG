/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2008 DIA A
       Colombia, Bucaramanga        INICIO:  07:35 AM  feb 16/2008 DIA

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarJui(oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodNiv := ''                  // C¢digo del Nivel
       LOCAL cCodigo := ''                  // C¢digo de b£squeda
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodNiv := cSpaces('JUI','cCodigoNiv')
       cCodigo := cSpaces('JUI','cCodigoJui')

       TitBuscar(30,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol SAY 'NIVEL' GET cCodNiv PICT '@!'
       @ nNroFil,nNroCol+09 SAY 'CODIGO' GET cCodigo PICT '@!'
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigo == cSpaces('JUI','cCodigoJui')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		 'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT JUI
       IF lBuscar

	  SELECT JUI
	  JUI->(DBGOTOP())
	  LOCATE FOR JUI->cCodigoNiv == cCodNiv .AND.;
		     JUI->cCodigoJui == cCodigo

	  IF JUI->(FOUND())
	     nNroReg := JUI->(RECNO())
	     JUI->(DBGOTOP())
	     oBrowse:GOTOP()
	     JUI->(DBGOTO(nNroReg))
	     oBrowse:FORCESTABLE()
	  ELSE
	     oBrowse:GOTOP()
	  ENDIF

       ELSE
          oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT JUI
       IF lBuscar .AND. lLocCodigo('cCodigoNiv','JUI',cCodigo)
	  nNroReg := JUI->(RECNO())
	  JUI->(DBGOTOP())
	  oBrowse:GOTOP()
	  JUI->(DBGOTO(nNroReg))
	  oBrowse:FORCESTABLE()
       ELSE
          oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO