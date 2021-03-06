/*                       SIMA - CONTROL DE ASISTENCIA
		     DECLARACION DE ARCHIVOS DEL SISTEMA

**************************************************************************
* TITULO ..: DECLARACION DE ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   MAY 26/2004 MIE

REQUERIMIENTOS:

1- Para que el programa funcione se debe invocar utilizando la clausula
   #INCLUDE dentro de la funcion que lo va a utilizar.

OBJETIVOS:

1- Declara todas las variables que contiene la declaraci�n de todos los
   archivos que conforma el sistema.

2- El objetivo principal de esta declaraci�n es estandarizar el modo
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
     *�Archivo Temporal

       LOCAL nHanXml := -1                  // Manejador del Archivo
       LOCAL FileXml := ''                  // Archivo Xml
     *�Archivo Xml

       LOCAL PathAaa := ''
       LOCAL FileAaa := PathAaa+'TEMP'+ExtFile
       LOCAL fNtxAaa := ''
     *�Archivo de Usuarios

       LOCAL FileDbf := 'FILESDAT'+ExtFile
     *�Archivo con los Archivo del Sistema

       LOCAL FileStr := 'FILESTR'+ExtFile
     *�Archivo Estructuras del Sistema

       LOCAL PathErr := ''
       LOCAL fErrSys := PathErr+'ERRORSYS'+ExtFile
       LOCAL fNtxErr := ''
     *�Archivo de Errores

       LOCAL FileClr := 'CFGCOLOR'+ExtFile
     *�Archivo de Configuraci�n del Color

       LOCAL FilePrn := 'DRIVERS'+ExtFile
     *�Archivo de Configuraci�n de Impresoras

       LOCAL FileDat := 'DATO0109'+ExtFile
     *�Archivo de Datos del Sistema
*>>>>FIN DECLARACION DE ARCHIVOS GENERALES

*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA
       LOCAL fSimCxP := 'SIMAPAGO'+ExtFile
     *�Archivo de Configuraci�n del sistema

       LOCAL fCxPAno := 'PAGO'              // Ej: PAGO1996.DAT
     *�Archivo de Configuraci�n del a�o

       LOCAL FilePer := 'PERSONAS'+ExtFile
       LOCAL fNtxPer := 'PERSONAS'+cExtNtx
       LOCAL Ntx1Per := 'PERSONIT'+cExtNtx
     *�Archivo de Personas

       LOCAL FileEmp := 'EMPRESAS'+ExtFile
       LOCAL fNtxEmp := 'EMPRESAS'+cExtNtx
     *�Archivo de Empresa

       LOCAL FilePrv := 'PROV'
       LOCAL fNtxPrv := 'PROVEDOR'+cExtNtx
     *�Archivo de Proveedores

       LOCAL FilePuc := 'FILEPUC'+ExtFile
     *�Archivo del Plan Unico de Cuentas

       LOCAL FilePrS := 'PRES'               // Ej: PRES2004.DAT
     *�Archivo del Presupuesto

       LOCAL FileFac := 'FACT'
       LOCAL fNtxFac := 'FACTURAS'+cExtNtx
     *�Archivo de Facturas

       LOCAL FileRtf := 'TABLARTF'+ExtFile
     *�Tabla de Retenci�n en la fuente

       LOCAL FileCpb := 'COMP'
       LOCAL fNtxCpb := 'COMPROBA'+cExtNtx
     *�Tabla de Comprobantes

       LOCAL FileCpI := 'ICPB'
     *�Tabla de Items de Comprobantes

       LOCAL FileCuC := 'CTASCTES'+ExtFile
     *�Tabla de Cuenta Corrientes

       LOCAL FileChe := 'CHEQUES'+ExtFile
     *�Tabla de Cuenta Corrientes
*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA

*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS
*>>>>FIN DECLARACION DE ARCHIVOS COMPARTIDOS