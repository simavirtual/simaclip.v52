/*                       SIMA - SIMA - SISTEMA DE VOTACION DEL GOBIERNO ESCOLAR
		     DECLARACION DE ARCHIVOS DEL SISTEMA

**************************************************************************
* TITULO ..: DECLARACION DE ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

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

       LOCAL PathSys := 'simavoto'          // Path del Sistema
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

       LOCAL FileDat := 'DATO0101'+ExtFile
     *ÀArchivo de Datos del Sistema

       LOCAL FileInf := 'INFORSYS'+ExtFile
     *ÀArchivo de informes del sistema

       LOCAL FileIso := 'FILESISO'+ExtFile
     *ÀArchivo de documentos de Iso
*>>>>FIN DECLARACION DE ARCHIVOS GENERALES

*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA
       LOCAL fSimVot := 'SIMAVOTO'+ExtFile
     *ÀArchivo de Configuraci¢n del sistema

       LOCAL fVotAno := 'VOTO'              // Ej: VOTOANO.DAT
     *ÀArchivo de Configuraci¢n del a¤o

       LOCAL FileEle := 'ELECCION'+ExtFile
       LOCAL fProEle := 'PROFEELE'+ExtFile
     *ÀArchivo de Eleciones

       LOCAL FileCnd := 'CANDIDTS'+ExtFile
       LOCAL fProCnd := 'PROFECND'+ExtFile
     *ÀArchivo de Candidatos
*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA

*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS
       LOCAL FileAlu := 'MAE'
       LOCAL fNtxAlu := 'MAE'
     *ÀArchivo de Alumnos

       LOCAL FilePro := 'PROFES'            // Ej: PROFES95.DAT
     *ÀArchivo de Profesores

       LOCAL FMaeBto := 'MAEBTO'            // Ej: MAEBTO95.DAT
       LOCAL fNtxBto := 'MAEBTO'
       LOCAL Ntx1Bto := 'APEBTO'            // Ej: APEBTO95.NEL
       LOCAL Ntx2Bto := 'NOMBTO'            // Ej: NOMBTO95.NEL
     *ÀArchivo de Alumnos de Bachillerato

       LOCAL FMaePri := 'MAEPRI'            // Ej: MAEPRI94.DAT
       LOCAL fNtxPri := 'MAEPRI'
       LOCAL Ntx1Pri := 'APEPRI'            // Ej: APEPRI95.NEL
       LOCAL Ntx2Pri := 'NOMPRI'            // Ej: NOMPRI95.NEL
     *ÀArchivo de Alumnos de Primaria

       LOCAL FMaeJar := 'MAEJAR'            // Ej: MAEJAR94.DAT
       LOCAL fNtxJar := 'MAEJAR'
       LOCAL Ntx1Jar := 'APEJAR'            // Ej: APEJAR95.NEL
       LOCAL Ntx2Jar := 'NOMJAR'            // Ej: NOMJAR95.NEL
     *ÀArchivo de Alumnos de Jard¡n

       LOCAL FMaeGua := 'MAEGUA'            // Ej: MAEGUA94.DAT
       LOCAL fNtxGua := 'MAEGUA'
       LOCAL Ntx1Gua := 'APEGUA'            // Ej: APEGUA95.NEL
       LOCAL Ntx2Gua := 'NOMGUA'            // Ej: NOMGUA95.NEL
     *ÀArchivo de Alumnos de Guarderia

       LOCAL FileGru := 'GRU'
     *ÀArchivo de Grupos

       LOCAL FGruGua := 'GRUGUA'            // Ej: GRUGUA94.DAT
     *ÀArchivo de Grupos de Guarder¡a

       LOCAL FGruJar := 'GRUJAR'            // Ej: GRUJAR94.DAT
     *ÀArchivo de Grupos de Jard¡n

       LOCAL FGruPri := 'GRUPRI'            // Ej: GRUPRI94.DAT
     *ÀArchivo de Grupos de Primaria

       LOCAL FGruBto := 'GRUBTO'            // Ej: GRUBTO94.DAT
     *ÀArchivo de Grupos de Bachillerato

       LOCAL FileNiv := 'NIVELS'
     *ÀArchivo de Niveles
*>>>>FIN DECLARACION DE ARCHIVOS COMPARTIDOS