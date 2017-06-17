/*                       SIMA - CONTROL DE ASISTENCIA
		     DECLARACION DE ARCHIVOS DEL SISTEMA

**************************************************************************
* TITULO ..: DECLARACION DE ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   MAY 26/2004 MIE

REQUERIMIENTOS:

1- Para que el programa funcione se debe invocar utilizando la clausula
   #INCLUDE dentro de la funcion que lo va a utilizar.

OBJETIVOS:

1- Declara todas las variables que contiene la declaraci¢n de todos los
   archivos que conforma el sistema.

2- El objetivo principal de esta declaraci¢n es estandarizar el modo
   de acceso a los archivos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE ARCHIVOS GENERALES
       LOCAL PathSys := 'SIMAASIS'          // Path del Sistema
       LOCAL PathSis := 'BASES'             // Path General del sistema
       LOCAL ExtFile := '.DAT'              // Extension para las bases
       LOCAL cExtNtx := '.NEL'              // Extension para indices
       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs
       LOCAL lSiRed  := .T.                 // .T. Apertura de Archivos MultiUsuario
       LOCAL lNoRed  := .F.                 // .F. Apertura de Archivo MonoUsuario

       LOCAL PathPrn := 'PRINTER'           // Path para impresiones
       LOCAL FileTem := 'TEMPO'             // Archivo datos temporal
       LOCAL fNtxTem := 'TEMPO'             // Archivo Indice temporal
       LOCAL cExtTem := '.TEM'              // Extension indice temporal
     *ÀArchivo Temporal

       LOCAL nHanXml := -1                  // Manejador del Archivo
       LOCAL FileXml := ''                  // Archivo Xml
     *ÀArchivo Xml

       LOCAL PathAaa := ''
       LOCAL FileAaa := PathAaa+'TEMP'+ExtFile
       LOCAL fNtxAaa := ''
     *ÀArchivo de Usuarios

       LOCAL FileDbf := 'FILESDAT'+ExtFile
     *ÀArchivo con los Archivo del Sistema

       LOCAL FileStr := 'FILESTR'+ExtFile
     *ÀArchivo Estructuras del Sistema

       LOCAL PathErr := ''
       LOCAL fErrSys := PathErr+'ERRORSYS'+ExtFile
       LOCAL fNtxErr := ''
     *ÀArchivo de Errores

       LOCAL FileClr := 'CFGCOLOR'+ExtFile
     *ÀArchivo de Configuraci¢n del Color

       LOCAL FilePrn := 'DRIVERS'+ExtFile
     *ÀArchivo de Configuraci¢n de Impresoras

       LOCAL FileDat := 'DATO0111'+ExtFile
     *ÀArchivo de Datos del Sistema
*>>>>FIN DECLARACION DE ARCHIVOS GENERALES

*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA
       LOCAL fSimPak := 'SIMAPARK'+ExtFile
     *ÀArchivo de Configuraci¢n del sistema

       LOCAL fPakAno := 'PARK'              // Ej: PARKA¥O.DAT
     *ÀArchivo de Configuraci¢n del a¤o

       LOCAL FileEnt := 'ENTRADAS'+ExtFile
       LOCAL FileTar := 'TARIFAS'+ExtFile
       LOCAL FileTpa := 'TIPPAGO'+ExtFile
       LOCAL FileAut := 'AUTOS'+ExtFile
*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA

*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS
*>>>>FIN DECLARACION DE ARCHIVOS COMPARTIDOS