/*                       SIMA - COLEGIOS
		     DECLARACION DE ARCHIVOS DEL SISTEMA

**************************************************************************
* TITULO ..: DECLARACION DE ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: abr 23/2008 DIA A
       Colombia, Bucaramanga        INICIO:  09:11 AM  abr 23/2008 DIA

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
       LOCAL PathWeb := '..\simaweb'        // Path del Sitio

       LOCAL PathSys := 'simacole'          // Path del Sistema
       LOCAL PathSis := 'BASES'             // Path General del sistema
       LOCAL ExtFile := '.DAT'              // Extension para las bases
       LOCAL cExtNtx := '.NEL'              // Extension para indices
       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs
       LOCAL lSiRed  := .T.                 // .T. Apertura de Archivos MultiUsuario
       LOCAL lNoRed  := .F.                 // .F. Apertura de Archivo MonoUsuario

       LOCAL PathDoc := 'c:\misdoc'         // Path de Documentos del sima
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

       LOCAL PathErr := ''
       LOCAL fErrSys := PathErr+'ERRORSYS'+ExtFile
       LOCAL fNtxErr := ''
     *ÀArchivo de Errores

       LOCAL FileClr := 'CFGCOLOR'+ExtFile
     *ÀArchivo de Configuraci¢n del Color

       LOCAL FilePrn := 'DRIVERS'+ExtFile
     *ÀArchivo de Configuraci¢n de Impresoras

       LOCAL FileDat := 'DATO0110'+ExtFile
     *ÀArchivo de Datos del Sistema

       LOCAL FileInf := 'INFORSYS'+ExtFile
     *ÀArchivo de informes del sistema

       LOCAL FileIso := 'FILESISO'+ExtFile
     *ÀArchivo de documentos de Iso
*>>>>FIN DECLARACION DE ARCHIVOS GENERALES

*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA
       LOCAL fSimCol := 'SIMACOL'+ExtFile
     *ÀArchivo de Configuraci¢n del sistema

       LOCAL fColAno := 'Col'              // Ej: ColANO.DAT
     *ÀArchivo de Configuraci¢n del a¤o
*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA

*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS
       LOCAL fMtrAno := 'MATR'              // Ej: MATR1996.DAT
       LOCAL fConAno := 'CONT'              // Ej: CONT1996.DAT
       LOCAL fProAno := 'PROF'              // Ej: PROF1996.DAT
       LOCAL fCarAno := 'CART'              // Ej: CART1996.DAT
       LOCAL fDatAno := 'DATA'              // Ej: DATA1996.DAT
       LOCAL fSimTol := 'SIMATOOL'+ExtFile  // Ej: SIMATOOL.DAT
       LOCAL FilePro := 'PROFES'            // Ej: PROFES.DAT o PROFES96.DAT
       LOCAL fSimPak := 'SIMAPARK'+ExtFile  // Ej: SIMAPARK.DAT
       LOCAL fAsiAno := 'ASIS'              // Ej: ASIS1996.DAT
       LOCAL fCafAno := 'CAFE'              // Ej: CAFE2007.DAT
*>>>>FIN DECLARACION DE ARCHIVOS COMPARTIDOS
