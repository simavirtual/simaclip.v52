/*                       SIMA - SISTEMA DE CAFETERIA
		     DECLARACION DE ARCHIVOS DEL SISTEMA

**************************************************************************
* TITULO..: DECLARACION DE ARCHIVOS DEL SISTEMAS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:05 AM   MAY 20/2002 LUN

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

       LOCAL PathSys := 'SIMACAFE'          // Path del Sistema
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

       LOCAL FileDat := 'DATO0106'+ExtFile
     *ÀArchivo de Datos del Sistema

       LOCAL FileInf := 'INFORSYS'+ExtFile
     *ÀArchivo de informes del sistema

       LOCAL FileIso := 'FILESISO'+ExtFile
     *ÀArchivo de documentos de Iso
*>>>>FIN DECLARACION DE ARCHIVOS GENERALES

*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA
       LOCAL fSimCaF := 'SIMACAFE'+ExtFile
     *ÀArchivo de Configuraci¢n del sistema

       LOCAL FilePer := 'PERSONAL'+ExtFile
     *ÀArchivo de Personal

       LOCAL FileTip := 'TIPO'              // Ej: TIPO2002.DAT
     *ÀArchivo de Tipo de Personal

       LOCAL FCaFAno := 'CAFE'              // Ej: CAFE2002.DAT
     *ÀArchivo de Configuraci¢n del a¤o

       LOCAL FilePrs := 'PRSP'              // Ej: PRSP2002.DAT
     *ÀArchivo de Configuraci¢n del a¤o

       LOCAL FileBol := 'BOLETAS'+ExtFile   // Ej: BOLETAS.DAT
       LOCAL fNtxBol := 'BOLETAS'+cExtNtx
     *ÀArchivo de Boletas

       LOCAL FileVbo := 'VENTAS'             // Ej: VENTAS02.DAT
     *ÀArchivo de Boletas
*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA

*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS
       LOCAL fSimaCo := 'SIMACONT'+ExtFile
     *ÀArchivo de Configuraci¢n del sistema

       LOCAL fConAno := 'CONT'              // Ej: CONT2002.DAT
     *ÀArchivo Configuraci¢n del a¤o de la Contabilidad

       LOCAL FileCon := 'CONCEPTO'+ExtFile
     *ÀArchivo de Concepto

       LOCAL FilePro := 'PROFES'           // Ej: PROFES95.DAT
     *ÀArchivo de Profesores

       LOCAL PathAlu := ''
       LOCAL FileAlu := PathAlu+'MAE'
       LOCAL fNtxAlu := PathAlu+'MAE'
     *ÀArchivo de Alumnos

       LOCAL fPazEst := 'PAZEST'	           // Ej: PAZEST01.DAT
     *ÀArchivo de Paz y Salvos

       LOCAL fDpzEst := 'DEUPAZ'	           // Ej: DEUPAZ01.DAT
     *ÀArchivo de Deudas del Paz y Salvo

       LOCAL PathBto := ''
       LOCAL FMaeBto := 'MAEBTO'            // Ej: MAEBTO95.DAT
       LOCAL fNtxBto := 'MAEBTO'
       LOCAL Ntx1Bto := 'APEBTO'            // Ej: APEBTO95.NEL
       LOCAL Ntx2Bto := 'NOMBTO'            // Ej: NOMBTO95.NEL
     *ÀArchivo de Alumnos de Bachillerato

       LOCAL PathPri := ''
       LOCAL FMaePri := 'MAEPRI'            // Ej: MAEPRI94.DAT
       LOCAL fNtxPri := 'MAEPRI'
       LOCAL Ntx1Pri := 'APEPRI'            // Ej: APEPRI95.NEL
       LOCAL Ntx2Pri := 'NOMPRI'            // Ej: NOMPRI95.NEL
     *ÀArchivo de Alumnos de Primaria

       LOCAL PathJar := ''
       LOCAL FMaeJar := 'MAEJAR'            // Ej: MAEJAR94.DAT
       LOCAL fNtxJar := 'MAEJAR'
       LOCAL Ntx1Jar := 'APEJAR'            // Ej: APEJAR95.NEL
       LOCAL Ntx2Jar := 'NOMJAR'            // Ej: NOMJAR95.NEL
     *ÀArchivo de Alumnos de Jard¡n

       LOCAL PathGua := ''
       LOCAL FMaeGua := 'MAEGUA'            // Ej: MAEGUA94.DAT
       LOCAL fNtxGua := 'MAEGUA'
       LOCAL Ntx1Gua := 'APEGUA'            // Ej: APEGUA95.NEL
       LOCAL Ntx2Gua := 'NOMGUA'            // Ej: NOMGUA95.NEL
     *ÀArchivo de Alumnos de Guarderia

       LOCAL PathGru := ''
       LOCAL FileGru := 'GRU'
     *ÀArchivo de Grupos

       LOCAL PGruGua := ''
       LOCAL FGruGua := 'GRUGUA'            // Ej: GRUGUA94.DAT
       LOCAL NGruGua := ''
     *ÀArchivo de Grupos de Guarder¡a

       LOCAL PGruJar := ''
       LOCAL FGruJar := 'GRUJAR'            // Ej: GRUJAR94.DAT
       LOCAL NGruJar := ''
     *ÀArchivo de Grupos de Jard¡n

       LOCAL PGruPri := ''
       LOCAL FGruPri := 'GRUPRI'            // Ej: GRUPRI94.DAT
       LOCAL NGruPri := ''
     *ÀArchivo de Grupos de Primaria

       LOCAL PGruBto := ''
       LOCAL FGruBto := 'GRUBTO'            // Ej: GRUBTO94.DAT
       LOCAL NGruBto := ''
     *ÀArchivo de Grupos de Bachillerato

       LOCAL FileCli := ''                            // Ej: CLI1101.094
     *ÀArchivo de Clientes

*>>>>FIN DECLARACION DE ARCHIVOS COMPARTIDOS