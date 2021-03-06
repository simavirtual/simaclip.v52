/* SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : DECLARACION DE ARCHIVOS DEL SISTEMA
SUBMODULO...: DECLARACION DE ARCHIVOS DEL SISTEMA

**************************************************************************
* NOMBRE DEL PROGRAMA......: ARC-CONT.PRG                                *
* TITULO DEL PROGRAMA......: DECLARACION DE ARCHIVOS DEL SISTEMAS        *
* PROGRAMAS QUE LO INVOCAN.: La mayoria de funciones del sistema         *
* PROGRAMAS QUE INVOCA.....: Ninguno                                     *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: MAY 02/95 MAR A
       Colombia, Bucaramanga        INICIO: 10:00 AM   MAY 02/95 MAR

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
       LOCAL PathWeb := '..\simaweb'        // Path del Sitio

       LOCAL PathSys := ''                  // Path del Sistema
       LOCAL PathSis := 'BASES'             // Path General del sistema
       LOCAL ExtFile := '.DAT'              // Extension para las bases
       LOCAL cExtNtx := '.NEL'              // Extension para indices
       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs
       LOCAL lSiRed  := .T.                 // .T. Apertura de Archivos MultiUsuario
       LOCAL lNoRed  := .F.                 // .F. Apertura de Archivo MonoUsuario

       LOCAL PathTem := 'TEMP'              // Path Temporal
       LOCAL PathPrn := 'PRINTER'           // Path para impresiones
       LOCAL PathXls := 'c:\misdoc'         // Path de Documentos del sima
       LOCAL PathDoc := 'c:\misdoc'         // Path de Documentos del sima

       LOCAL FileTem := 'TEMPO'             // Archivo datos temporal
       LOCAL fNtxTem := 'TEMPO'             // Archivo Indice temporal
       LOCAL cExtTem := '.TEM'              // Extension indice temporal

       LOCAL nHanXml := -1                  // Manejador del Archivo
       LOCAL FileXml := ''                  // Archivo Xml
     *�Archivo Temporal

       LOCAL FileAaa := 'TEMP'+ExtFile
     *�Archivo de Usuarios

       LOCAL fTipUsr := 'TIPOUSR'+ExtFile
     *�Archivo de Tipos de Usuarios

       LOCAL FilePrn := 'DRIVERS'+ExtFile
     *�Archivo de Configuraci�n de Impresoras

       LOCAL FileDat := 'DATO0102'+ExtFile
     *�Archivo de Datos del Sistema

       LOCAL fErrSys := 'ERRORSYS'+ExtFile
       LOCAL fNtxErr := ''
     *�Archivo de Errores del Sistema

       LOCAL FileClr := 'CFGCOLOR'+ExtFile
     *�Archivo de Configuraci�n del Color

       LOCAL PathOtr := '1FileTem'
       LOCAL PathLog := 'AFileLog'
       LOCAL FileLog := ''
     *�Archivo de Errores

       LOCAL FileXsl := 'inforprn.www'
     *�Archivo Xsl para los informes.

       LOCAL FileJpg := 'fondoprn.jpg'
     *�Archivo jpg fondo de los informes

       LOCAL FileIso := 'FILESISO'+ExtFile
     *�Archivo de documentos de Iso

       LOCAL FileInf := 'INFORSYS'+ExtFile
     *�Archivo de informes del sistema
*>>>>FIN DECLARACION DE ARCHIVOS GENERALES

*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA
       LOCAL fSimaCo := 'SIMACONT'+ExtFile
       LOCAL fNtxCon := ''
     *�Archivo de Configuraci�n del sistema

       LOCAL fConAno := 'CONT'     // Ej: CONT1996.DAT
       LOCAL fNtxCoA := ''
     *�Archivo Configuraci�n del a�o

       LOCAL fConTbl := 'CONT'     // Ej: CONTBTO.DAT
       LOCAL fNtxTbl := ''
     *�Archivo Configuraci�n del nivel

       LOCAL FileEmp := 'EMPRESAS'+ExtFile
       LOCAL fNtxEmp := ''
     *�Archivo de Empresa

       LOCAL FilePer := 'PERSONAS'+ExtFile
       LOCAL fNtxPer := 'PERSONAS'+cExtNtx
       LOCAL Ntx1Per := 'PERSONIT'+cExtNtx
     *�Archivo de Personas

       LOCAL fPerImp := 'PER'
     *�Archivo de Personas Importar

       LOCAL FileDoc := 'DOCENTES'+ExtFile
       LOCAL fNtxDoc := ''
     *�Archivo de Docentes del Colegio todos los a�os

       LOCAL FilePro := 'PROFES'    // Ej: PROFES95.DAT
       LOCAL fNtxPro := 'PROFES'    // Ej: PROFES95.NEL
     *�Archivo de Profesores del a�o

       LOCAL FileOrg := 'ORGANIZA'+ExtFile
       LOCAL fNtxOrg := 'ORGANIZA'+ExtFile
     *�Archivo de Organizaciones

       LOCAL FileCla := 'CLASEIND'+ExtFile
       LOCAL fNtxCla := 'CLASEIND'+ExtFile
     *�Archivo de Clase de Indicadores

       LOCAL FNroInd := 'NRO'      // Ej: NROBTO96.DAT
       LOCAL fNtxNro := 'NRO'      // Ej: NROBTO96.NEL
     *�Archivo de Control de los n�mero de Indicadores

       LOCAL FileEva := 'TABLAEVA'+ExtFile
       LOCAL fNtxEva := 'TABLAEVA'+ExtFile
     *�Archivo Tabla de Evaluaci�n

       LOCAL FileApr := 'TABLAAPR'+ExtFile
       LOCAL fNtxApr := 'TABLAAPR'+ExtFile
     *�Archivo Tabla de Aprobaci�n

       LOCAL FileCar := 'CARGA'     // Ej: CARGABTO.DAT
       LOCAL fNtxCar := 'CARGA'     //     CARGABTO.NEL
     *�Archivo de Cargas

       LOCAL FileAlu := 'MAE'
       LOCAL fNtxAlu := 'MAE'
     *�Archivo de Alumnos

       LOCAL FMaeBto := 'MAEBTO'            // Ej: MAEBTO95.DAT
       LOCAL fNtxBto := 'MAEBTO'
       LOCAL Ntx1Bto := 'APEBTO'            // Ej: APEBTO95.NEL
       LOCAL Ntx2Bto := 'NOMBTO'            // Ej: NOMBTO95.NEL
     *�Archivo de Alumnos de Bachillerato

       LOCAL FMaePri := 'MAEPRI'            // Ej: MAEPRI94.DAT
       LOCAL fNtxPri := 'MAEPRI'
       LOCAL Ntx1Pri := 'APEPRI'            // Ej: APEPRI95.NEL
       LOCAL Ntx2Pri := 'NOMPRI'            // Ej: NOMPRI95.NEL
     *�Archivo de Alumnos de Primaria

       LOCAL FMaeJar := 'MAEJAR'            // Ej: MAEJAR94.DAT
       LOCAL fNtxJar := 'MAEJAR'
       LOCAL Ntx1Jar := 'APEJAR'            // Ej: APEJAR95.NEL
       LOCAL Ntx2Jar := 'NOMJAR'            // Ej: NOMJAR95.NEL
     *�Archivo de Alumnos de Jard�n

       LOCAL FileGru := 'GRU'
       LOCAL fNtxGru := ''
     *�Archivo de Grupos

       LOCAL FGruBto := 'GRUBTO'            // Ej: GRUBTO94.DAT
       LOCAL NGruBto := ''
     *�Archivo de Grupos de Bachillerato

       LOCAL FGruPri := 'GRUPRI'            // Ej: GRUPRI94.DAT
       LOCAL NGruPri := ''
     *�Archivo de Grupos de Primaria

       LOCAL FGruJar := 'GRUJAR'            // Ej: GRUJAR94.DAT
       LOCAL NGruJar := ''
     *�Archivo de Grupos de Jard�n

       LOCAL FileNiv := 'NIVELS'            // Ej: NIVELS95.DAT
       LOCAL fNtxNiv := 'NIVELS'            // Ej: NIVELS95.NEL
     *�Archivo de Niveles

       LOCAL FileJui := 'IND'               // Ej: JUIBTO95.DAT
       LOCAL fNtxJui := 'IND'               // Ej: JUIBTO95.NEL
     *�Archivo de Juicios

       LOCAL FileInd := 'IND'               // Ej: INDBTO.DAT
       LOCAL fNtxInd := 'IND'               // Ej: INDBTO.NEL

       LOCAL FileSin := 'SUB'               // Ej: SUBBTO08.DAT
     *�Archivo Clasificaci�n de Indicadores

       LOCAL FJuiJar := 'INDJAR'            // Ej: JUIJAR95.DAT
       LOCAL NJuiJar := 'INDJAR'
     *�Archivo de Juicios de Jard�n

       LOCAL FJuiPri := 'INDPRI'            // Ej: JUIPRI95.DAT
       LOCAL NJuiPri := 'INDPRI'
     *�Archivo de Juicios de Primaria

       LOCAL FJuiBto := 'INDBTO'            // Ej: JUIBTO95.DAT
       LOCAL NJuiBto := 'INDBTO'
     *�Archivo de Juicios de Bachillerato

       LOCAL FileMat := 'MATERIAS'+ExtFile
       LOCAL fNtxMat := ''
     *�Archivo de Materias

       LOCAL FileSel := 'SELE'     // Ej: SELEBTO.DAT
       LOCAL fNtxSel := 'SELE'     // Ej: SELEBTO.NEL
     *�Archivo de Selecci�n de Materias

       LOCAL FilePla := 'PL'       // Ej: PLAN0695.DAT  Por Nivel
       LOCAL fNtxPla := ''                 //     PL060195.DAT  Por Grupo
     *�Archivo de Plan de materias a dictar por nivel

       LOCAL FileSuN := 'SUBNIVEL'+ExtFile   // Ej: SUBNIVEL.DAT
       LOCAL fNtxSuN := ''
     *�Archivo de Sub Plan de materias a dictar por nivel

       LOCAL FileSuG := 'SUBGRUPO'+ExtFile   // Ej: SUBGRUPO.DAT
       LOCAL fNtxSuG := ''
     *�Archivo de Sub Plan de materias a dictar por nivel

       LOCAL FileNot := 'NT'               // Ej: NT060195.DAT
       LOCAL fNtxNot := ''
     *�Archivo de Notas

       LOCAL FileHab := 'HABILITA'+ExtFile // Ej: HABILITA.DAT
       LOCAL fNtxHab := ''
     *�Archivo de Habilitaciones o recuperaciones.

       LOCAL FileHra := 'HORAS'+ExtFile	   // Ej: HABILI97.DAT
       LOCAL fNtxHra := ''
     *�Archivo de Horas

       LOCAL FileHor := 'HORARIO'+ExtFile  // Ej: HORARIO.DAT
       LOCAL fNtxHor := ''
     *�Archivo de Horario de Clase

       LOCAL FileFun := 'FUNCION'+ExtFile  // Ej: HABILI97.DAT
       LOCAL fNtxFun := ''
     *�Archivo de Horas

       LOCAL fCorBol := 'CORREBOL'+ExtFile	   // Ej: CORREBOL.DAT
     *�Archivo de Correci�n de Boletines

       LOCAL fPazEst := 'PAZEST'	           // Ej: PAZEST01.DAT
     *�Archivo de Paz y Salvos

       LOCAL fDpzEst := 'DEUPAZ'	           // Ej: DEUPAZ01.DAT
     *�Archivo de Deudas del Paz y Salvo

       LOCAL FileFam := 'FAMILIA'+ExtFile	  // Ej: PAZEST01.DAT
       LOCAL fNtxFam := 'FAMILIA'+cExtNtx
     *�Archivo de Familias

       LOCAL FileJvf := 'Juiciosv'+ExtFile
     *�Archivo de Juicios Valorativos

       LOCAL FileStd := 'Estadist'+ExtFile
     *�Archivo de Estadisticas

       LOCAL FileSti := 'EstaIndi'+ExtFile
     *�Archivo de Estadisticas de indicadores

       LOCAL fColPrc := 'COLEPROC'+ExtFile         // Ej: COLEPROC.DAT
     *�Archivo de Colegios de Procedencia.
*>>>>FIN DECLARACION DE ARCHIVOS DEL SISTEMA

*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS
	LOCAL fProTbl := 'PROF'     // Ej: PROFBTO.DAT
*       LOCAL fNtxTbl := ''
     *�Archivo Tabla del nivel

       LOCAL FCarPro := 'CARPRO'    // Ej: CARPRO95.DAT
       LOCAL fNtxCap := ''
     *�Archivo de carga academica del profesor

       LOCAL FMatPro := 'MATPRO'            // Ej: MATPRO95.DAT

       LOCAL FNotPro := ''          //  Ej: 06011601.DAT
       LOCAL fNtxNop := ''
     *�Archivo de notas de un curso

       LOCAL FileCli := ''
     *�Archivo de Clientes
*>>>>FIN DECLARACION DE ARCHIVOS COMPARTIDOS