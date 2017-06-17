/*                     BIBLIOTECAS DE FUNCIONES
		     FUNCIONES PARA EL ARCHIVO CVS

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: APERTURA DEL ARCHIVO CSV                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2014 MAR A
       Colombia, Bucaramanga        INICIO: 03:40 PM   OCT 21/2014 MAR

OBJETIVOS:

1- Apertura del Archivo para csv

2- Retorna el manejador del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nOpenCsv(fArchvo,aCabPrn,aTitPrn,lValida,aPrnCsv)

*>>>>DESCRIPCION DE PARAMETROS
/*     fArchvo                              // Archivo a Crear
       aCabPrn			            // Encabezado del Informe
       aTitPrn                              // Titulos de Impresion
       lValida                              // .T. Validar la Existencia del Archivo
       aPrnCsv				    // Csv del informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL cRegCsv := ''                  // Registro Cvs

       LOCAL PathWeb := ''                  // Path del sistio
       LOCAL nCodXsl := ''                  // C¢digo Xsl de los informes
       LOCAL cCodXsl := ''                  // C¢digo Xsl de los informes
       LOCAL FileXsl := ''                  // Archivo Xsl

       LOCAL cCodInf := ''                  // C¢digo del informe
       LOCAL cCodIso := ''                  // C¢digo Iso
       LOCAL cFecIso := ''                  // Fecha de Aprobaci¢n
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL cPieUno := ''                  // Pie de P gina uno
       LOCAL cPieDos := ''                  // Pie de P gina dos
       LOCAL cPieTre := ''                  // Pie de P gina tres
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO
       lValida := IF(EMPTY(lValida),.F.,lValida)
       IF lValida .AND. File(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','YA EXISTE')
	  IF !lPregunta('DESEA REESCRIBIR EL ARCHIVO? No Si')
	     RETURN 0
	  ENDIF
       ENDIF
       IF FCREATE(fArchvo,0) == -1
	   cError(fArchvo,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN 0
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN 0
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>IMPRESION DE LA CABECERA
       FOR i := 1 TO LEN(aTitPrn)
	   cRegCsv += aTitPrn[i]+IF(i < LEN(aTitPrn),';','')
       ENDFOR
       lSaveTxt(cRegCsv,nHandle,fArchvo)

       RETURN nHandle
*>>>>FIN IMPRESION DE LA CABECERA

/*************************************************************************
* TITULO..: GRABAR REGISTRO CSV                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2014 MAR A
       Colombia, Bucaramanga        INICIO: 04:15 PM   OCT 21/2014 MAR

OBJETIVOS:

1- Grabaci¢n del Campo Csv

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SaveRegCsv(fArchvo,nHandle,aRegPrn)

*>>>>DECLARACION DE VARIABLES
/*     fArchvo                              // Archivo a Crear
       nHandle                              // Manejador Archivo Binario
       aRegPrn				    // Registro de Impresi¢n */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contadores
       LOCAL cRegCsv := ''                  // Registro Csv
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DEL REGISTRO
       FOR i := 1 TO LEN(aRegPrn)
	   cRegCsv += aRegPrn[i]+IF(i < LEN(aRegPrn),';','')
       ENDFOR
       lSaveTxt(cRegCsv,nHandle,fArchvo)
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: CERRAR EL ARCHIVO CSV                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 22/2014 MIE A
       Colombia, Bucaramanga        INICIO: 02:40 PM   OCT 22/2014 MIE

OBJETIVOS:

1- Cierra el archivo CSV

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CloseCsv(fArchvo,nHandle)

*>>>>DECLARACION DE VARIABLES
/*     fArchvo                              // Archivo a Crear
       nHandle                              // Manejador Archivo Binario */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS