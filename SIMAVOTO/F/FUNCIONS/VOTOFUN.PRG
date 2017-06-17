/*                      SIMA - SIMA - SISTEMA DE VOTACION DEL GOBIERNO ESCOLAR
		     BIBLIOTECAS DE FUNCIONES GENERALES

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
*>>>>FIN DECLARACION DE CONSTANTES

/*************************************************************************
* TITULO..: INICIALIZACION PARAMETROS DE LA APLICACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Define por defecto los parametros de la aplicaci¢n

1- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IniSistema(nMemMin,nOpeFil)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMemMin                              // M¡nimo espacio en disco
       nOpeFil                              // M¡nimo archivos abiertos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS PARAMETROS
       nMemMin := IF(nMemMin == NIL,1000000,nMemMin)
       nOpeFil := IF(nOpeFil == NIL,12,nOpeFil)
*>>>>VALIDACION DE LOS PARAMETROS

*>>>>DIRECTORIOS POR DEFECTO
       SET DEFAULT TO                       // Directorio por defecto
       SET PATH    TO                       // Path de Busqueda Auxiliar
*>>>>FIN DIRECTORIOS POR DEFECTO

*>>>>SETS PARA ENTRADA POR DEFECTO
       READEXIT(.T.)                        // Activa flechas salida Gest
       READINSERT(.T.)                      // Activa el modo de inserci¢n
       SET TYPEAHEAD  TO 10                 // Tama¤o del buffer de teclado
       SET ESCAPE     ON                    // Activa <ESC> salida GETS
       SET INTENSITY  ON                    // Activa intensidad Gets
       SET CONFIRM    ON                    // Confirmaci¢n salida Gets
       SET BELL       OFF                   // Activa sonido final Gets
       SET SCOREBOARD OFF                   // Desactiva Inf barra superior
       SET DELIMITERS OFF                   // Desactiva los delimitadores
       SET DELIMITERS TO                    // Delimitador campo por defecto
*>>>>FIN SETS PARA ENTRADA POR DEFECTO

*>>>>SETS PARA LOS PROCESOS POR DEFECTO
       SETCANCEL(.T.)                       // Abortar el programa
       SETCURSOR(1)                         // Activaci¢n del cursor
       SET DECIMALS    TO 2                 // Cifras decimales
       SET FIXED       ON                   // Decimales del SET DECIMALS
*>>>>FIN SETS PARA LOS PROCESOS POR DEFECTO

*>>>>SETS PARA SALIDA POR DEFECTO
       SET WRAP       ON                    // Men£s circulares
       SET CONSOLE    ON                    // Activaci¢n de la pantalla
       SET DEVICE     TO SCREEN             // La Pantalla por defecto
       SET MESSAGE    TO 22 CENTER          // Fila para mensajes
       SET MARGIN     TO 0                  // N£mero del margen
       SET ALTERNATE  OFF                   // Desactiva el ARTERNATE
*>>>>FIN SETS PARA SALIDA POR DEFECTO

*>>>>SETS PARA BASES DE DATOS POR DEFECTO
       SET EXCLUSIVE  ON                    // Archivos no compartidos
       SET DELETED    ON                    // Ignorar registros borrados
       SET EXACT      OFF                   // Busqueda no exacta
       SET SOFTSEEK   OFF                   // Se ubica en el EOF() al buscar
       SET UNIQUE     OFF                   // Llaves de indices no £nicas
*>>>>FIN DESACTIVACION DE PROCEDIMIENTOS SET

*>>>>SETS GENERALES POR DEFECTO
       SETBLINK(.T.)                        // Activado el * como titilante
       SET COLOR       TO                   // Colores por defecto
       SET EPOCH       TO 1900              // A¤o base
       SET DATE        AMERICAN             // Formato de fecha amaricano
       SET DATE FORMAT "MM/DD/YY"           // Formato de fecha
       SET CENTURY     ON                   // OFF = 99 ON = 9999
*>>>>FIN SETS GENERALES POR DEFECTO

*>>>>ANALISIS DEL ESPACIO DISPONIBLE
       IF DISKSPACE() < nMemMin
	  IF cError('Presione "C" para Continuar',;
		    'HAY POCO ESPACIO DISPONIBLE EN EL DISCO',;
		    '<ESC> = Termina el Programa') <> 'C'
	     QUIT
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DEL ESPACIO DISPONIBLE

*>>>>ANALISIS DE LOS MANEJADORES DE DISCO DISPONIBLES
       IF FILESFREE() < nOpeFil
	  cError("Aumente la l¡nea FILES en su CONFIG.SYS"+;
		 " y rearranque el equipo",;
		 "Hay pocos Manejadores de Archivos disponibles = "+;
		 alltrim(Str(filesfree())),;
		 "Al presionar cualquier tecla se termina el programa")
	  CLOSE ALL
	  QUIT
       ENDIF
*>>>>FIN ANALISIS DE LOS MANEJADORES DE DISCO DISPONIBLES

*>>>>ASIGNACION DE FUNCIONES A LAS TECLAS
       SETKEY(K_ALT_A, {|| KEYSEND(" ", .T., .T.)})
       SETKEY(K_ALT_E, {|| KEYSEND("‚", .T., .T.)})
       SETKEY(K_ALT_I, {|| KEYSEND("¡", .T., .T.)})
       SETKEY(K_ALT_O, {|| KEYSEND("¢", .T., .T.)})
       SETKEY(K_ALT_U, {|| KEYSEND("£", .T., .T.)})
       SETKEY(K_ALT_N, {|| KEYSEND("¤", .T., .T.)})
       SETKEY(K_ALT_M, {|| KEYSEND("¥", .T., .T.)})
       SETPOS(24, 0)
       CLOSE ALL
       RETURN NIL
*>>>>FIN ASIGNACION DE FUNCIONES A LAS TECLAS

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Crea el directorio de la aplicaci¢n para el a¤o especificado si
   no existe.

2- Crea las estructuras de los archivos de la aplicaci¢n en caso de no
   existir.

3- Recupera las estructuras de los archivos de la aplicaci¢n en caso
   de p‚rdida.

4- Indexa los archivos de la aplicaci¢n en caso de no existir

5- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevisarDbf(aP1,cSavPan)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       cSavPan                              // Salvar Pantalla */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // Crear Estructuras

       LOCAL       i := 0                   // Contador
       LOCAL bInfSys := NIL                 // Block Informes del Sistema

       LOCAL PathAct := ''                  // Path Actual
       LOCAL PathWww := ''		    // Path del Sitio


       LOCAL lndexar := .F.                 // .T. Indexar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DIRECTORIOS DEL SISTEMA
       PathAct := cPathAct()

       Mdir(cPatSis,PathAct)
     *ÀDirectorio del A¤o. Ej 2007.diu

       Mdir(PathPrn+'\IMG',PathAct)
       InfPrnXsl(PathPrn+'\IMG')
     *ÀPrinter

       Mdir(PathDoc+'\IMG',PathAct)
       InfPrnXsl(PathDoc+'\IMG')
     *ÀMis Documentos

       Mdir(PathWeb+'\img',PathAct)
       Mdir(PathWeb+'\rec',PathAct)
     *ÀSimaWeb. General
*>>>>FIN DIRECTORIOS DEL SISTEMA

*>>>>SITIOS DEL SISTEMA No.1
       PathWww := xParams(aP1,'PathW01')
       IF !('sitio01' $ PathWww)

	  Mdir(PathWww+'\IMG',PathAct)
	*ÀCreaci¢n del Directorio

	  InfPrnXsl(PathWww+'\rec')
	*ÀArchivo XSL informes.
       ENDIF
*>>>>FIN SITIOS DEL SISTEMA No.1

*>>>>CREACION DE ESTRUCTURAS GENERALES
       bInfSys := {||VotInfSys(lShared,cNomUsr,cCodSui)}
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis+'\'+FileInf) .AND.;
	    !FILE(PathSis+'\'+FileIso) .AND.;
	    !FILE(PathSis+'\'+FileClr) .AND.;
	    !FILE(PathSis+'\'+fSimVot)

************CREACION DE ESTRUCTURAS
	      RESTSCREEN(0,0,24,79,cSavPan)
	      CreaDbfSys(lShared,nModCry,cPatSis,cAnoUsr,bInfSys)
************FIN CREACION DE ESTRUCTURAS

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+FilePrn)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPrn(lShared,nModCry,PathSis,FilePrn)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileInf)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfInf(lShared,nModCry,PathSis,FileInf,bInfSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileIso)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfIso(lShared,nModCry,PathSis,FileIso)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileClr)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfClr(lShared,nModCry,PathSis,FileClr)
	      ENDIF

	      IF !FILE(PathSis+'\'+fSimVot)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuSimVot(lShared,nModCry,PathSis,fSimVot)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES

*>>>>CREACION DE ESTRUCTURAS DEL A¥O
       DO CASE
       CASE !FILE(cPatSis+'\'+fVotAno+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FileEle)                 .AND.;
	    !FILE(cPatSis+'\'+fProEle)                 .AND.;
	    !FILE(cPatSis+'\'+FileCnd)                 .AND.;
	    !FILE(cPatSis+'\'+fProCnd)

************CREACION DE ESTRUCTURAS
	      RESTSCREEN(0,0,24,79,cSavPan)
	      CreaDbfAno(lShared,nModCry,cPatSis,cAnoUsr)
************FIN CREACION DE ESTRUCTURAS

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL A¥O
	      IF !FILE(cPatSis+'\'+FileEle)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfEle(lShared,nModCry,cPatSis,FileEle)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fProEle)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfEle(lShared,nModCry,cPatSis,fProEle)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCnd)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCnd(lShared,nModCry,cPatSis,FileCnd)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fProCnd)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCnd(lShared,nModCry,cPatSis,fProCnd)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS DEL A¥O

       ENDCASE
*>>>>CREACION DE ESTRUCTURAS DEL A¥O

*>>>>CREACION DE ESTRUCTURAS ESPECIFICAS
       DO CASE
       CASE .T.

************CREACION DE ESTRUCTURAS
	      RESTSCREEN(0,0,24,79,cSavPan)
	      CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr)
************FIN CREACION DE ESTRUCTURAS

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS ESPECIFICAS
************FIN RECUPERACION DE ESTRUCTURAS ESPECIFICAS

       ENDCASE
*>>>>FIN CREACION DE ESTRUCTURAS ESPECIFICAS

*>>>>ACTUALIZACION DE ESTRUCTURAS GENERALES
       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n. Configuraci¢n de Impresoras

       nActStrInf(lShared,nModCry,PathSis,FileInf)
     *ÀActualizacion. Informes del sistema

       nActStrIso(lShared,nModCry,PathSis,FileIso)
     *ÀActualizacion. Archivos Iso

       nActStrClr(lShared,nModCry,PathSis,FileClr)
     *ÀActualizaci¢n. Configuraci¢n del Color

       nActSimVot(lShared,nModCry,PathSis,fSimVot)
     *ÀActualizaci¢n. Configuraci¢n del Sistema
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS GENERALES

*>>>>ACTUALIZACION DE ESTRUCTURAS DEL A¥O
       nActStrEle(lShared,nModCry,cPatSis,FileEle)
     *ÀActualiaci¢n de Eleciones

       nActStrEle(lShared,nModCry,cPatSis,fProEle)
     *ÀActualiaci¢n de Eleciones de Profesores

       nActStrCnd(lShared,nModCry,cPatSis,FileCnd)
     *ÀActualizaci¢n de Candidatos

       nActStrCnd(lShared,nModCry,cPatSis,fProCnd)
     *ÀActualizaci¢n de Candidatos de Profesores
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS DEL A¥O

*>>>>ACTUALIZACION DE ESTRUCTURAS ESPECIFICAS
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS ESPECIFICAS

*>>>>CREACION INDICES DEL SISTEMA
       IF .F.

	  RESTSCREEN(0,0,24,79,cSavPan)
	  Indexar(aP1)

       ENDIF
*>>>>FIN CREACION INDICES DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE .F.
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       FileTem := cFileTempo(PathPrn+'\','Voto','.PRN')
       IF .F.
	  SET PRINTER TO &FileTem              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF

*      CloseDbf('SPR',PathSis+'\'+fSimPro)
       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO..: CREACION ARCHIVOS GENERALES                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Crea todos los archivos generales del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,nModCry,cPatSis,cAnoUsr,bInfSys)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       bInfSys                              // Block Informes del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS GENERALES DEL SISTEMA")

       Termometro(20)
       CreaDbfPrn(lShared,nModCry,PathSis,FilePrn)

       Termometro(40)
       CreaDbfInf(lShared,nModCry,PathSis,FileInf,,bInfSys)

       Termometro(60)
       CreaDbfIso(lShared,nModCry,PathSis,FileIso)

       Termometro(80)
       CreaDbfClr(lShared,nModCry,PathSis,FileClr)

       Termometro(100)
       CreaSimVot(lShared,nModCry,PathSis,fSimVot)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO..: CREACION ARCHIVOS DEL A¥O                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Crea todos los archivos generales del a¤o del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfAno(lShared,nModCry,cPatSis,cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS DEL A¥O
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS DEL A¥O")


       CreaDbfEle(lShared,nModCry,cPatSis,FileEle)
       Termometro(25)
       CreaDbfEle(lShared,nModCry,cPatSis,fProEle)
       Termometro(50)

       CreaDbfCnd(lShared,nModCry,cPatSis,FileCnd)
       Termometro(75)

       CreaDbfCnd(lShared,nModCry,cPatSis,fProCnd)
       Termometro(100)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS DEL A¥O

/*************************************************************************
* TITULO..: CREACION ARCHIVOS ESPECIFICOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Crea todos los archivos especificos del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS ESPECIFICAS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS ESPECIFICOS")

       Termometro(100)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS ESPECIFICAS

/*************************************************************************
* TITULO..: INDEXAR LOS ARCHIVOS DEL SISTEMA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Coloca en uso todos los archivos de sistema que estan indexados

2- Crea los archivos indices del sistema

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Indexar(aP1)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cPatFil := ''                  // Path de archivo
       LOCAL lIndNiv := ''                  // .T. Indicador de Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       CloseAll()
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CREACION DE INDEXES
       Termometro(0,'INDEXANDO ARCHIVOS')
       Termometro(100)

       CloseAll()
       RETURN NIL
*>>>>FIN CREACION DE INDEXES

/*************************************************************************
* TITULO..: DEFINICION DE LOS MENUS DE LA APLICACION                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Define todos los men£s de la aplicaci¢n

2- Permite escoger un men£ de acuerdo a la opci¢n elegida.

3- Permite seleccionar cada una de las opciones a las cuales tiene
   derecho el usuario.

4- Retorna por referencia los param‚tros de la funci¢n marcados con @

5- Retorna el vector con el men£ escogida de acuerdo a la opci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aMenusSys(nNroOpc,cDerech,aAyudas)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroOpc			            // N£mero de Opci¢n
       cDerech                              // Derechos a los Menus
       aAyudas                              // @Vector de Ayudas escogidas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                    // Declaraci¢n de Men£s
       LOCAL aAyuda  := {}                    // Declaraci¢n de Ayudas
       LOCAL aMenuss := {}                    // Men£ escogido
       LOCAL     i,j := 0                     // Contadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENUS
       DO CASE
       CASE nNroOpc == 0

	    aMenus := {}
	    AADD(aMenus,'1ESTUDIANTES')
	    AADD(aMenus,'2PROFESORES')
	    AADD(aMenus,'7UTILIDADES')

	    aAyuda := {}
	    AADD(aAyuda,'Permite realizar las consultas de las elecciones de los Estudiantes.')
	    AADD(aAyuda,'Permite realizar las consultas de las elecciones de los Profesores.')
	    AADD(aAyuda,'Permite Ejecutar varias utilidades del sistema.')

       CASE nNroOpc == 1

	    aMenus := {}
	    AADD(aMenus,'1<CANDIDATOS>')
	    AADD(aMenus,'2<ELECCIONES >')

	    aAyuda := {}
	    AADD(aAyuda,'Consulta de los Candidatos de los Estudiantes')
	    AADD(aAyuda,'Consulta los Tipos de Elecciones de los Estudiantes')


       CASE nNroOpc == 2

	    aMenus := {}
	    AADD(aMenus,'1<CANDIDATOS>')
	    AADD(aMenus,'2<ELECCIONES >')

	    aAyuda := {}
	    AADD(aAyuda,'Consulta de los Candidatos de los Profesores')
	    AADD(aAyuda,'Consulta los Tipos de Elecciones de los Profesores')

       CASE nNroOpc == 3

	    aMenus := {}
	    AADD(aMenus,'1<SUBMENU>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite ...')


       CASE nNroOpc == 4

	    aMenus := {}
	    AADD(aMenus,'1<SUBMENU>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite ...')


       CASE nNroOpc == 5

	    aMenus := {}
	    AADD(aMenus,'1<SUBMENU>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite ...')

       CASE nNroOpc == 6

	    aMenus := {}
	    AADD(aMenus,'1<SUBMENU>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite ...')

       CASE nNroOpc == 7

	    aMenus := {}
	    AADD(aMenus,'1<USUARIOS      >')
	    AADD(aMenus,'2<CAMBIAR CLAVE >')
	    AADD(aMenus,'3<REINDEXAR     >')
	    AADD(aMenus,'4<ACTUALIZAR    >')
	    AADD(aMenus,'5<MANTENIMIENTO >')
	    AADD(aMenus,'6<CONFIGURACION >')
	    AADD(aMenus,'7<VARIOS        >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
	    AADD(aAyuda,'Permite cambiar la clave')
	    AADD(aAyuda,'Reindexa los archivos del Sistema')
	    AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
	    AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
	    AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
	    AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')

       ENDCASE
*>>>>FIN DECLARACION DEL MENUS

*>>>>SELECCION DEL MENU
       FOR i:= 1 TO LEN(aMenus)
	   IF VAL(SUBS(cDerech,i,1)) == 1
	      j++
	      AADD(aMenuss,j)
	      AADD(aAyudas,j)
	      aMenuss[j] := aMenus[i]
	      aAyudas[j] := aAyuda[i]
	   ENDIF
       NEXT
       RETURN aMenuss
*>>>>FIN SELECCION DEL MENU

/*************************************************************************
* TITULO..: EJECUCION MENUS PRIMER NIVEL                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubMenus(aP1,;
		  nOpcion,nOpcPal,aColSup,cDerech,;
		  nColAno,cSavPan)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       aColSup                              // Columnas para los sub_men£s
       cDerech                              // Derechos en el sistema
       nColAno                              // Columna A¤o del sistema
       cSavPan                              // Salvar Pantalla */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>PARAMETROS GENERALES
       LOCAL aP2 := {}                      // Parametros Generales
       LOCAL aP3 := {}                      // Parametros Generales
*>>>>FIN PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL lSiMenu := .T.                 //.T.Opci¢n principal con SubMen£
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opci¢n
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones

       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£
       LOCAL nPerAct := 0                   // Periodo Actual

       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL cUsrIso := ''                  // Usuario del Iso
       LOCAL nCodXsl := 0                   // C¢digo Xsl informes
       LOCAL cPiePag := ''                  // Pie de p gina informes
       LOCAL aMezIso := {}                  // Campos a Mesclar
     *ÀVariables informes

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
     *ÀVariables archivos

       LOCAL nPrueba := 0                   // Habilitar pruebas
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL bInsReg := NIL                 // Block Insertar registros
     *ÀVariables registros

       LOCAL cPatSim := ''                  // Path del Sima
       LOCAL cLogEmp := ''                  // Logo de la Empresa

       LOCAL lVotEst := .T.                 // Votaciones .T. Estudiantes .F. Profesores */

       MEMVA xClrSys			    // Color del Sistema

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>EJECUCION DEL PRIMER NIVEL
       DO WHILE .T.

	  CloseAll()

**********AREAS DE TRABAJO
	    aUseDbf := {}
	    AADD(aUseDbf,{.T.,PathSis+'\'+fSimVot,'VOT',NIL,lShared,nModCry})
**********FIN AREAS DE TRABAJO

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbfs(aUseDbf)
	       cError('ABRIENDO ARCHIVOS')
	       CloseAll(aUseDbf)
	       QUIT
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE VOT->(RECCOUNT()) == 0
		 cError('NO EXISTE CONFIGURACION DEL SISTEMA')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseAll(aUseDbf)
	       QUIT
	    ENDIF

	    nPrueba := Vot->nPruebaVot
	    lPrnArc := Vot->lPrnArcVot
	    nCodPrn := Vot->nCodigoPrn
	    cOpcPrn := Vot->cOpcPrnVot
	    cUsrIso := Vot->cUsrIsoVot
	    nCodXsl := Vot->nCodXslVot
	    cPiePag := Vot->cPiePagVot
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LECTURA DEL LOGO DE LA EMPRESA
	    cLogEmp := ''
	    IF !EMPTY(VOT->cLogEmpVot)

	       cPatSim := cPathSima()
	       cLogEmp := cPatSim+'\'+'SimaCont\Bases\'+;
			  ALLTRIM(VOT->cLogEmpVot)
	    ENDIF
	    CloseAll()

	    nParameSet(aP1,'cLogEmp',cLogEmp)
**********FIN LECTURA DEL LOGO DE LA EMPRESA

**********PARAMETROS ESPECIFICOS
	    aP2 := {}
**********FIN PARAMETROS ESPECIFICOS

**********DETALLES DEL INFORME
	    aP3 := {}
	    AADD(aP3,{'cPieTre',cPiePag})
	    AADD(aP3,{'cUsrIso',cUsrIso})
	    AADD(aP3,{'nCodXsl',nCodXsl})
**********FIN DETALLES DEL INFORME

**********LECTURA DE PATHS
	    PathVotAno(lShared,nModCry,cAnoUsr,cPatSis,;
		       @PathUno,@PathDos,@PathTre,@PathCua)
	  *ÀLectura de paths

	    nParameSet(aP1,'PathUno',PathUno)
	    nParameSet(aP1,'PathDos',PathDos)
	    nParameSet(aP1,'PathTre',PathTre)
	    nParameSet(aP1,'PathCua',PathCua)
	    CloseAll()
**********FIN LECTURA DE PATHS

**********SELECCION DE LOS SUBMENUS
	    lSiMenu := .T.
	    aDeMenu := aMenusSys(nOpcPal,;
				 SUBS(cDerech,nOpcPal*10-9,10),@aHelp)
	    aMenu := {}
	    FOR i := 1 TO LEN(aDeMenu)
		AADD(aMenu,i)
		aMenu[i] := STR(i,1)+SUBS(aDeMenu[i],2,LEN(aDeMenu[i]))
	    NEXT
**********FIN SELECCION DE LOS SUBMENUS

**********ANALISIS DEL LIMITE DE LA ULTIMA COLUMNA
	    IF lSiMenu

	       ASCAN(aMenu, {|str| nLenOpc := MAX(nLenOpc,LEN(str))})
	      *Longitud mayor de las opciones

	       IF aColSup[nOpcion] + nLenOpc + 2 > 78
		  aColSup[nOpcion] := 78-nLenOpc-1
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL LIMITE DE LA ULTIMA COLUMNA

**********EJECUCION DE LOS SUBMENUS
	    IF lSiMenu

*--------------CAMBIO DEL A¥O DEL SISTEMA
		 LineaEstado('<F2>CAMBIA A¥O. '+;
			     'LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
		 SETKEY(K_F2,{||LeeAnoSys(nColAno,@cAnoUsr,;
					  @cPatSis,cNomEmp,cNomSis)})

		 nParameSet(aP1,'cPatSis',cPatSis)
		 nParameSet(aP1,'cAnoUsr',cAnoUsr)
		 nParameSet(aP1,'cAnoSis',SUBS(cAnoUsr,3,2))
*--------------FIN CAMBIO DEL A¥O DEL SISTEMA

*--------------SELECCION DEL SUBMENU
		 nFilSup := nFilPal+1
		 nColSup := aColSup[nOpcion]
	       *ÀCalculo coordenadas del men£

		 nNroOpc := nMenu(aMenu,aHelp,nFilSup,nColSup,NIL,NIL,;
				  nNroOpc,NIL,;
				  IF(!EMPTY(xClrSys),xClrSys[3],''))

		 SETKEY(K_F2,NIL)
		 lSiMenu := .T.
*--------------FIN SELECCION DEL SUBMENU

	    ENDIF
**********FIN EJECUCION DE LOS SUBMENUS

**********ANALISIS PARA SALIDA
	    IF nNroOpc == 0
	       EXIT
	    ENDIF
	    nNroOpc := VAL(SUBS(aDeMenu[nNroOpc],1,1))
	    cSavLin := SAVESCREEN(0,0,02,79)
	    LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
**********FIN ANALISIS PARA SALIDA

**********PARAMETROS GENERALES
	    nFilInf := nFilSup + LEN(aMenu) + 1
	    nColInf := aColSup[nOpcion]

	    nParameSet(aP1,'nFilInf',nFilInf)
	    nParameSet(aP1,'nColInf',nColInf)
**********FIN PARAMETROS GENERALES

**********ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL
	    DO CASE
	    CASE nOpcPal == 1 // Estudiantes

		 DO CASE
		 CASE nNroOpc == 1  // Candidatos Estudiantes

**********************AREAS DE TRABAJO
			aArchvo := {}

			AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
			AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
			AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
			AADD(aArchvo,{cPatSis+'\'+FileCnd,NIL,'CND'})
			AADD(aArchvo,{cPatSis+'\'+FileEle,NIL,'ELE'})
			FOR i := 1 TO LEN(cMaeAlu)/3
			    cMaeAct := SUBS(cMaeAlu,i*3-2,3)
			    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
					  FileAlu+cMaeAct+cAnoSis+ExtFile,;
					  PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
					  fNtxAlu+cMaeAct+cAnoSis+cExtNtx,cMaeAct})
			ENDFOR
**********************FIN AREAS DE TRABAJO

**********************MANTENIMIENTO DEL ARCHIVO
			lModReg := IF(nPrueba==0,.F.,.T.)
			lDelReg := IF(nPrueba==0,.F.,.T.)
			lInsReg := IF(nPrueba==0,.F.,.T.)
			lHaySql := IF(nPrueba==0,.F.,.T.)
			bInsReg := NIL

			lVotEst := .T.
			MantenCnd(aP1,aP2,aP3,aArchvo,cOpcPrn,;
				  nCodPrn,lModReg,lDelReg,;
				  lInsReg,lHaySql,bInsReg,lVotEst)
**********************FIN MANTENIMIENTO DEL ARCHIVO

		 CASE nNroOpc == 2  // Elecciones Estudiantes

**********************AREAS DE TRABAJO
			aArchvo := {}

			AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
			AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
			AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
			AADD(aArchvo,{cPatSis+'\'+FileEle,NIL,'ELE'})
**********************FIN AREAS DE TRABAJO

**********************MANTENIMIENTO DEL ARCHIVO
			lModReg := IF(nPrueba==0,.F.,.T.)
			lDelReg := IF(nPrueba==0,.F.,.T.)
			lInsReg := IF(nPrueba==0,.F.,.T.)
			lHaySql := IF(nPrueba==0,.F.,.T.)
			bInsReg := NIL

			lVotEst := .T.
			MantenEle(aP1,aP2,aP3,aArchvo,cOpcPrn,;
				  nCodPrn,lModReg,lDelReg,;
				  lInsReg,lHaySql,bInsReg,lVotEst)
**********************FIN MANTENIMIENTO DEL ARCHIVO

		 ENDCASE

	    CASE nOpcPal == 2

		 DO CASE
		 CASE nNroOpc == 1  // Candidatos Profesores

**********************AREAS DE TRABAJO
			aArchvo := {}

			AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
			AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
			AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
			AADD(aArchvo,{cPatSis+'\'+fProCnd,NIL,'CND'})
			AADD(aArchvo,{cPatSis+'\'+fProEle,NIL,'ELE'})
			AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+;
				      FilePro+cAnoSis+ExtFile,NIL,'PRO'})
**********************FIN AREAS DE TRABAJO

**********************MANTENIMIENTO DEL ARCHIVO
			lModReg := IF(nPrueba==0,.F.,.T.)
			lDelReg := IF(nPrueba==0,.F.,.T.)
			lInsReg := IF(nPrueba==0,.F.,.T.)
			lHaySql := IF(nPrueba==0,.F.,.T.)
			bInsReg := NIL

			lVotEst := .F.
			MantenCnd(aP1,aP2,aP3,aArchvo,cOpcPrn,;
				  nCodPrn,lModReg,lDelReg,;
				  lInsReg,lHaySql,bInsReg,lVotEst)
**********************FIN MANTENIMIENTO DEL ARCHIVO

		 CASE nNroOpc == 2   // Elecciones profesores

**********************AREAS DE TRABAJO
			aArchvo := {}

			AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
			AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
			AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
			AADD(aArchvo,{cPatSis+'\'+fProEle,NIL,'ELE'})
**********************FIN AREAS DE TRABAJO

**********************MANTENIMIENTO DEL ARCHIVO
			lModReg := IF(nPrueba==0,.F.,.T.)
			lDelReg := IF(nPrueba==0,.F.,.T.)
			lInsReg := IF(nPrueba==0,.F.,.T.)
			lHaySql := IF(nPrueba==0,.F.,.T.)
			bInsReg := NIL

			lVotEst := .F.
			MantenEle(aP1,aP2,aP3,aArchvo,cOpcPrn,;
				  nCodPrn,lModReg,lDelReg,;
				  lInsReg,lHaySql,bInsReg,lVotEst)
**********************FIN MANTENIMIENTO DEL ARCHIVO

		 ENDCASE

	    CASE nOpcPal == 3

		 DO CASE
		 CASE nNroOpc == 1
		 ENDCASE

	    CASE nOpcPal == 4

		 DO CASE
		 CASE nNroOpc == 1
		 ENDCASE

	    CASE nOpcPal == 5

		 DO CASE
		 CASE nNroOpc == 1
		 ENDCASE

	    CASE nOpcPal == 6

		 DO CASE
		 CASE nNroOpc == 1
		 ENDCASE

	    CASE nOpcPal == 7

		 DO CASE
		 CASE nNroOpc == 1
		      MantenUsr(lShared,PathSis,FileAaa,{|nOpcion,aAyudas|;
				aMenusSys(nOpcion,'1111111111',aAyudas)},;
				cNomSis,.F.)
		     *Mantemiento de usuarios

		 CASE nNroOpc == 2

		      CamPasWor(lShared,nFilInf+1,aColSup[nOpcion],;
				PathSis,FileAaa,cNomUsr)
		     *Cambiar el PassWord del usuario

		 CASE nNroOpc == 5
		      VOTO_705(aP1,aP2,aP3)
		     *Mantenimiento

		 CASE nNroOpc == 6
		      VOTO_706(aP1,aP2,aP3)
		     *Configuraci¢n

		 CASE nNroOpc == 7
		      VOTO_707(aP1,aP2,aP3)
		     *Varios

		 ENDCASE

	    ENDCASE
	    RESTSCREEN(0,0,24,79,cSavPan)
	    RESTSCREEN(0,0,02,79,cSavLin)
	    CloseAll()
**********FIN ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN EJECUCION  DEL PRIMER NIVEL

/*************************************************************************
* TITULO ..: LECTURA DEL COLOR DEL SISTEMA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,PathClr,FileClr,;
		    PathSis,fSimVot)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path del Sistema
       fSimVot				    // Configuraci¢n del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL PathAct := ''                  // Path Actual
       LOCAL xClrSys			    // Color del Sistema
       LOCAL cClrFnd := ''                  // Color del Fondo
       LOCAL cGetsSi := ''                  // Color del Get Selecionados
       LOCAL cGetsNo := ''                  // Color del Get No Seleccionados
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION O CREACION DEL DIRECTORIO BASES
       PathAct := cPathAct()

       Mdir(PathSis,PathAct)
     *ÀDirectorio Bases
*>>>>FIN VERIFICACION O CREACION DE DIRECTORIO BASES

*>>>>VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR
       IF !FILE(PathSis+'\'+fSimVot)
	  CreaSimVot(lShared,nModCry,PathSis,fSimVot)
       ENDIF
       nActSimVot(lShared,nModCry,PathSis,fSimVot)

       IF !FILE(PathClr+'\'+FileClr)
	  CreaDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrClr(lShared,nModCry,PathClr,FileClr)
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysVot(lShared,nModCry)
       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR