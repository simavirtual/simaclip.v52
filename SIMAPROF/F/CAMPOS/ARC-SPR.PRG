/*                      SIMA - CONTABILIDAD PROFESORES
		     DECLARACION DE ARCHIVOS DEL SISTEMA

**************************************************************************
* NOMBRE DEL PROGRAMA......: ARC-PROF.PRG                                *
* TITULO DEL PROGRAMA......: DECLARACION DE ARCHIVOS DEL SISTEMAS        *
* PROGRAMAS QUE LO INVOCAN.: La mayoria de funciones del sistema         *
* PROGRAMAS QUE INVOCA.....: Ninguno                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/96 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   MAR 08/96 VIE

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

       LOCAL PathSis := 'BASES'             // Path General del sistema
       LOCAL PathTem := '1FILETEM'          // Paht Temporal
       LOCAL ExtFile := '.DAT'              // Extension para las bases
       LOCAL cExtNtx := '.NEL'              // Extension para indices
       LOCAL lSiRed  := .T.                 // .T. Apertura de Archivos MultiUsuario
       LOCAL lNoRed  := .F.                 // .F. Apertura de Archivo MonoUsuario
       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs

       LOCAL PathDoc := 'c:\misdoc'         // Path de Documentos del sima
       LOCAL PathPrn := 'PRINTER'           // Path para impresiones
       LOCAL cNtxTem := '.TEM'              // Extension indice temporal
       LOCAL FileTem := 'TEMPO'+cNtxTem     // Archivo datos temporal
       LOCAL fNtxTem := 'TEMPO'+cExtNtx     // Archivo Indice temporal
     *ÀArchivo Temporal

       LOCAL PathAaa := ''
       LOCAL FileAaa := PathAaa+'TEMP'+ExtFile
       LOCAL fNtxAaa := ''
     *ÀArchivo de Usuarios

       LOCAL PathErr := ''
       LOCAL fErrSys := PathErr+'ERRORSYS'+ExtFile
       LOCAL fNtxErr := ''

       LOCAL FileClr := 'CFGCOLOR'+ExtFile
     *ÀArchivo de Configuraci¢n del Color

       LOCAL FilePrn := 'DRIVERS'+ExtFile
     *ÀArchivo de Configuraci¢n de Impresoras

       LOCAL FileDat := 'DATO0103'+ExtFile
     *ÀArchivo de Datos del Sistema

       LOCAL FileLog := 'LOGPROFE'+ExtFile
     *ÀArchivo del log del profesor

       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL FileXml := ''                  // Archivo Xml
     *ÀArchivo Xml

       LOCAL FileInf := 'INFORSYS'+ExtFile
     *ÀArchivo de informes del sistema

       LOCAL FileIso := 'FILESISO'+ExtFile
     *ÀArchivo de documentos de Iso
*>>>>FIN DECLARACION DE ARCHIVOS GENERALES

*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA
       LOCAL fSimSpr := 'SIMAPROF'+ExtFile
     *ÀArchivo de Configuraci¢n del sistema

       LOCAL fSprAno := 'PROF'             // Ej: PROF1996.DAT
     *ÀArchivo Tabla del a¤o

       LOCAL PathTbl := ''
       LOCAL fProTbl := PathTbl+'PROF'     // Ej: PROFBTO.DAT
       LOCAL fNtxTbl := ''
     *ÀArchivo Tabla del nivel

       LOCAL PathInd := ''
       LOCAL FileInd := PathInd+'IND'      // Ej: INDBTO.DAT
       LOCAL fNtxInd := PathInd+'IND'      // Ej: INDBTO.NEL
     *ÀArchivo de Indicadores de los profesores

       LOCAL PCarPro := ''
       LOCAL FCarPro := PCarPro+'CARPRO'    // Ej: CARPRO95.DAT
       LOCAL fNtxCap := ''
     *ÀArchivo de carga academica del profesor

       LOCAL PMatPro := ''
       LOCAL FMatPro := PMatPro+'MATPRO'    // Ej: MATPRO95.DAT
       LOCAL fNtxMaP := ''
     *ÀArchivo de Materias que dicta el profesor

       LOCAL PathPro := ''
       LOCAL FilePro := PathPro+'PROFES'    // Ej: PROFES.DAT o PROFES96.DAT
       LOCAL fNtxPro := ''
     *ÀArchivo del Profesor para notas y contabilidad

       LOCAL PNotPro := ''
       LOCAL FNotPro := PNotPro+''          //  Ej: 06011601.DAT
       LOCAL fNtxNop := ''
     *ÀArchivo de notas de un curso
*>>>>FIN DECLARACION DE ARCHIVOS DEL SISTEMA

*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS.SIMACONT
       LOCAL PathSCO := 'SIMACONT'

       LOCAL fSimaCo := 'SIMACONT'+ExtFile
     *ÀArchivo de Configuraci¢n del sistema

       LOCAL fConAno := 'CONT'     // Ej: CONT1996.DAT
     *ÀArchivo Configuraci¢n del a¤o

       LOCAL fConTbl := 'CONT'     // Ej: CONTBTO.DAT
     *ÀArchivo Configuraci¢n del nivel

       LOCAL FileCla := 'CLASEIND'+ExtFile
     *ÀArchivo de Clase de Indicadores

       LOCAL FileEva := 'TABLAEVA'+ExtFile
     *ÀArchivo Tabla de Evaluaci¢n

       LOCAL FileApr := 'TABLAAPR'
     *ÀArchivo Tabla de Aprobaci¢n

       LOCAL FileCar := 'CARGA'     // Ej: CARGABTO.DAT
     *ÀArchivo de Cargas

       LOCAL FileAlu := 'MAE'
       LOCAL fNtxAlu := 'MAE'
     *ÀArchivo de Alumnos

       LOCAL FileGru := 'GRU'
     *ÀArchivo de Grupos

       LOCAL FileNiv := 'NIVELS'            // Ej: NIVELS95.DAT
     *ÀArchivo de Niveles

       LOCAL FileJui := 'IND'               // Ej: JUIBTO95.DAT
     *ÀArchivo de Juicios

       LOCAL FileSin := 'SUB'               // Ej: SUBBTO08.DAT
     *ÀArchivo Clasificaci¢n de Indicadores

       LOCAL FileMat := 'MATERIAS'+ExtFile
     *ÀArchivo de Materias

       LOCAL FileSel := 'SELE'     // Ej: SELEBTO.DAT
       LOCAL fNtxSel := 'SELE'     // Ej: SELEBTO.NEL
     *ÀArchivo de Selecci¢n de Materias

       LOCAL FilePla := 'PL'                // Ej: PLAN0695.DAT  Por Nivel
     *ÀArchivo de Plan de materias a dictar por nivel

       LOCAL FileSuN := 'SUBNIVEL'          // Ej: SUBNIVEL.DAT
     *ÀArchivo de Sub Plan de materias a dictar por nivel

       LOCAL FileSuG := 'SUBGRUPO'          // Ej: SUBGRUPO.DAT
     *ÀArchivo de Sub Plan de materias a dictar por nivel

       LOCAL FileNot := 'NT'               // Ej: NT060195.DAT
     *ÀArchivo de Notas

       LOCAL fPazEst := 'PAZEST'	           // Ej: PAZEST01.DAT
     *ÀArchivo de Paz y Salvos

       LOCAL fDpzEst := 'DEUPAZ'	           // Ej: DEUPAZ01.DAT
     *ÀArchivo de Deudas del Paz y Salvo

       LOCAL FileJvf := 'Juiciosv'+ExtFile
     *ÀArchivo de Juicios Valorativos

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

       LOCAL PathNro := ''
       LOCAL FNroInd := PathNro+'NRO'      // Ej: NROBTO96.DAT
       LOCAL fNtxNro := PathNro+'NRO'      // Ej: NROBTO96.NEL
     *ÀArchivo de Control de los n£mero de Indicadores
*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS.SIMACONT