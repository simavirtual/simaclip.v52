/*               	  SISTEMA DE CAFETERIA
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Define por defecto los parametros de la aplicaci¢n

1- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IniSistema(nModCry,lShared,nMemMin,nOpeFil)

*>>>>PARAMETROS DE LA FUNCION
/*     nModCry                              // Modo de Protecci¢n
       nMemMin                              // M¡nimo espacio en disco
       nOpeFil                              // M¡nimo archivos abiertos */
*>>>>PARAMETROS DE LA FUNCION

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
*      SET PRINTER TO SIMATEMP              // Archivo salida impresora
*      SET ALTERNATE  TO NELSON             // Archivo salida pantalla
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
       SET EPOCH       TO 2000              // A¤o base
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
	  CloseAll()
	  QUIT
       ENDIF
*>>>>FIN ANALISIS DE LOS MANEJADORES DE DISCO DISPONIBLES

*>>>>VALIDACION SI EXISTE RED DISPONIBLE
/*
       IF lShared
	  IF !NNETWORK()
	     cError('NO EXISTE RED DISPONIBLE')
	     CloseAll()
	     QUIT
	  ENDIF
       ENDIF
*/
*>>>>FIN VALIDACION SI EXISTE RED DISPONIBLE

*>>>>ACTIVACION DE LA AYUDA
*       SETKEY(K_F1,{|A,B,C,D|;
*	      Ayuda(nModCry,A,B,C,D,,.T.)})
*>>>>FIN ACTIVACION DE LA AYUDA

*>>>>ASIGNACION DE FUNCIONES A LAS TECLAS
       SETKEY(K_ALT_A, {|| KEYSEND(" ", .T., .T.)})
       SETKEY(K_ALT_E, {|| KEYSEND("‚", .T., .T.)})
       SETKEY(K_ALT_I, {|| KEYSEND("¡", .T., .T.)})
       SETKEY(K_ALT_O, {|| KEYSEND("¢", .T., .T.)})
       SETKEY(K_ALT_U, {|| KEYSEND("£", .T., .T.)})
       SETKEY(K_ALT_N, {|| KEYSEND("¤", .T., .T.)})
*       SETKEY(K_ALT_M, {|| KEYSEND("¥", .T., .T.)})
       SETPOS(24, 0)
       CloseAll()
       RETURN NIL
*>>>>FIN ASIGNACION DE FUNCIONES A LAS TECLAS

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:35 PM   MAY 20/2002 LUN

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
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // Crear Estructuras

       LOCAL bInfSys := NIL                 // Block Informes del Sistema

       LOCAL PathAct := ''                  // Path Actual
       LOCAL PathWww := ''		    // Path del Sitio

       LOCAL lndexar := .F.                 // .T. Indexar Archivos

       LOCAL lPrnArc := .F.                 // .T. Imprimir en Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL MODO DE APERTURA DE LOS ARCHIVOS
       IF nModCry # 0 .AND. lShared
	  cError('LA APLICACION NO PUEDE SER MULTIUSUARIO')
	  CloseAll()
	  QUIT
       ENDIF
*>>>>FIN VALIDACION DEL MODO DE APERTURA DE LOS ARCHIVOS

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

/*
*>>>>BUILD DEL ANT PDF
      FileXml := PathPrn+'\'+'build.xml'
      IF !FILE(FileXml)
	 fBuild00(FileXml)
      ENDIF

      FileXml := PathPrn+'\'+'build.pro'
      IF !FILE(FileXml)
	 fBuild00pr(FileXml)
      ENDIF
*>>>>FIN BUILD DEL ANT PDF
*/

*>>>>SITIOS DEL SISTEMA No.1
       PathWww := xParams(aP1,'PathW01')
       IF !('sitio01' $ PathWww)

	  Mdir(PathWww+'\IMG',PathAct)
	*ÀCreaci¢n del Directorio

	  InfPrnXsl(PathWww+'\rec')
	*ÀArchivo XSL informes.
       ENDIF
*>>>>FIN SITIOS DEL SISTEMA No.1

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       bInfSys := {||CaFInfSys(lShared,cNomUsr,cCodSui)}
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+fErrSys) .AND.;
	    !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis+'\'+FileInf) .AND.;
	    !FILE(PathSis+'\'+FileIso) .AND.;
	    !FILE(PathSis+'\'+FileClr) .AND.;
	    !FILE(PathSis+'\'+fSimCaF) .AND.;
	    !FILE(PathSis+'\'+FilePer) .AND.;
	    !FILE(PathSis+'\'+FileBol)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,nModCry,cPatSis,cAnoUsr,bInfSys)

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+fErrSys)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuErrSys(lShared,nModCry,PathSis,fErrSys)
	      ENDIF

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

	      IF !FILE(PathSis+'\'+fSimCaF)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuSimCaF(lShared,nModCry,PathSis,fSimCaF)
	      ENDIF

	      IF !FILE(PathSis+'\'+FilePer)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPer(lShared,nModCry,PathSis,FilePer)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileBol)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfBol(lShared,nModCry,PathSis,FileBol)
		 lndexar := .T.
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(cPatSis+'\'+fCaFAno+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FileTip+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FilePrs+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FileVbo+cAnoSis+ExtFile)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,cMaeAlu)

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL SISTEMA
	      IF !FILE(cPatSis+'\'+fCaFAno+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuCaFAno(lShared,nModCry,cPatSis,;
			    fCaFAno+cAnoUsr+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileTip+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTip(lShared,nModCry,cPatSis,;
			    FileTip+cAnoUsr+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FilePrs+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPrs(lShared,nModCry,cPatSis,;
			    FilePrs+cAnoUsr+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileVbo+cAnoSis+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfBol(lShared,nModCry,cPatSis,;
			    FileVbo+cAnoSis+ExtFile)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS DEL SISTEMA

       ENDCASE
       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA

*>>>>ACTUALIZACION DE ESTRUCTURAS
       SET EXACT      ON                    // Busqueda Exacta
       nActStrErr(lShared,nModCry,PathSis,fErrSys)
     *ÀActualizaci¢n de los Errores del Sistema

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActSimCaF(lShared,nModCry,PathSis,fSimCaF)
     *ÀActualizaci¢n. Configuraci¢n del Sistema

       nActStrPer(lShared,nModCry,PathSis,FilePer)
     *ÀActualizaci¢n del Personal

       nActStrAno(lShared,nModCry,cPatSis,fCaFAno+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Configuraci¢n del A¤o.

       nActStrTip(lShared,nModCry,cPatSis,FileTip+cAnoUsr+ExtFile)
     *ÀActualizaci¢n del Personal

       nActStrPrs(lShared,nModCry,cPatSis,FilePrs+cAnoUsr+ExtFile)
     *ÀActualizaci¢n del Presupuesto

       IF nActStrBol(lShared,nModCry,PathSis,FileBol) == 0
	  lndexar := .T.
       ENDIF
     *ÀActualizaci¢n de las Boletas

       nActStrBol(lShared,nModCry,cPatSis,FileVbo+cAnoSis+ExtFile)
     *ÀActualizaci¢n de las Ventas de las Boletas

       SET EXACT      OFF                   // Busqueda no exacta
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS

*>>>>INDEXAR ARCHIVOS DEL SISTEMA
       IF !FILE(PathSis+'\'+fNtxBol) .OR. lndexar
	  Indexar(lShared,nModCry,cAnoUsr,cPatSis)
       ENDIF
*>>>>FIN INDEXAR ARCHIVOS DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnArc := .F.
       IF !lUseDbf(.T.,PathSis+'\'+fSimCaF,'CAF',NIL,lShared,nModCry)
	  CloseDbf('CAF',PathSis+'\'+fSimCaF,nModCry)
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAF->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       lPrnArc := CAF->lPrnArcCaF
       CloseDbf('CAF',PathSis+'\'+fSimCaF,nModCry)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF lPrnArc
	  SET PRINTER TO SIMATEMP              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO..: CREACION ARCHIVOS GENERALES DEL SISTEMA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:35 PM   MAY 20/2002 LUN

OBJETIVOS:

1)- Crea todos los archivos generales del sistema

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,nModCry,cPatSis,cAnoUsr,bInfSys)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       bInfSys                              // Block Informes del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS GENERALES DEL SISTEMA")

       Termometro(20)
       CreaErrSys(lShared,nModCry,PathSis,fErrSys)

       Termometro(40)
       CreaDbfInf(lShared,nModCry,PathSis,FileInf,,bInfSys)

       Termometro(60)
       CreaDbfIso(lShared,nModCry,PathSis,FileIso)

       Termometro(40)
       CreaDbfClr(lShared,nModCry,PathSis,FileClr)

       Termometro(60)
       CreaDbfPrn(lShared,nModCry,PathSis,FilePrn)

       Termometro(80)
       CreaDbfPer(lShared,nModCry,PathSis,FilePer)

       Termometro(95)
       CreaSimCaF(lShared,nModCry,PathSis,fSimCaF)

       Termometro(100)
       CreaDbfBol(lShared,nModCry,PathSis,FileBol)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:40 PM   MAY 20/2002 LUN

OBJETIVOS:

1)- Crea todos los archivos de la aplicaci¢n o del sistema

2)- Retorna NIL

SINTAXIS:
  CreaDbfs(cAnoUsr)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       cAnoSis                              // A¤o del sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE  ESTRUCTURAS DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO LOS ARCHIVOS DEL SISTEMA")

       Termometro(50)
       CreaCaFAno(lShared,nModCry,cPatSis,fCaFAno+cAnoUsr+ExtFile)

       Termometro(60)
       CreaDbfTip(lShared,nModCry,cPatSis,FileTip+cAnoUsr+ExtFile)

       Termometro(75)
       CreaDbfPrs(lShared,nModCry,cPatSis,FilePrs+cAnoUsr+ExtFile)

       Termometro(100)
       CreaDbfBol(lShared,nModCry,cPatSis,FileVbo+cAnoSis+ExtFile)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE  ESTRUCTURAS DEL SISTEMA

/*************************************************************************
* TITULO..: INDEXAR LOS ARCHIVOS DEL SISTEMA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 07/2002 LUN A
       Colombia, Bucaramanga        INICIO: 09:00 PM   OCT 07/2002 LUN

OBJETIVOS:

1- Pone en uso todos los archivos de sistema que estan indexados

2- Crea los archivos indices del sistema

3- Retorna NIL


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Indexar(lShared,nModCry,cAnoUsr,cPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       CloseAll()                           // Cierre de Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FileBol,'BOL',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CREACION DEL INDICES DEL SISTEMA
       Termometro(0,'INDEXANDO ARCHIVOS DEL SISTEMA')
       Termometro(50)

       Termometro(100)
       SELECT BOL
       INDEX ON BOL->cCodigoBol TO &(PathSis+'\'+fNtxBol)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN CREACION DEL INDICES DEL SISTEMA

/*************************************************************************
* TITULO..: DEFINICION DE LOS MENUS DE LA APLICACION                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:45 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Define todos los men£s de la aplicaci¢n

2- Permite escoger un men£ de acuerdo a la opci¢n elegida.

3- Permite seleccionar cada una de las opciones a las cuales tiene
   derecho el usuario.

4- Retorna por referencia los param‚tros de la funci¢n marcados con @

5- Retorna el vector con el men£ escogida de acuerdo a la opci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aMenusSys(nNroOpc,cDerech,aAyudas)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroOpc			            // N£mero de Opci¢n
       cDerech                              // Derechos a los Menus
       aAyudas                              // @Vector de Ayudas escogidas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                    // Declaraci¢n de Men£s
       LOCAL aAyuda  := {}                    // Declaraci¢n de Ayudas
       LOCAL aMenuss := {}                    // Men£ escogido
       LOCAL     i,j := 0                     // Contadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENUS
       DO CASE
       CASE nNroOpc == 0

	    aMenus := {'1CAFETERIA',;
		       '2CONSULTAS',;
		       '3INFORMES',;
		       '4BOLETAS',;
		       '5UTILIDADES'}

	    aAyuda := {'Permite Hacer Control Sobre la Cafeteria',;
		       'Permite la Consulta',;
		       'Permite Imprimir Informes',;
		       'Permite el Control de las Boletas',;
		       'Permite Ejecutar varias utilidades del sistema.'}

       CASE nNroOpc == 1

	    aMenus := {'1<INGRESO>'}

	    aAyuda := {'Permite el Control de Acceso a la Cafeteria'}

       CASE nNroOpc == 2

	    AADD(aMenus,'1<ALUMNOS    >')
	    AADD(aMenus,'2<PROFESORES >')
	    AADD(aMenus,'3<PERSONAL   >')
	    AADD(aMenus,'4<PRESUPUESTO>')

	    AADD(aAyuda,'Permite Consultar la informaci¢n de los Estudiantes')
	    AADD(aAyuda,'Permite Consultar la informaci¢n de los Profesores')
	    AADD(aAyuda,'Permite Consultar la informaci¢n del Personal')
	    AADD(aAyuda,'Permite Consultar el Presupuesto de los Consumos')

       CASE nNroOpc == 3

	    AADD(aMenus,'1<ETIQUETAS        >')
	    AADD(aMenus,'2<CARNETS          >')
	    AADD(aMenus,'3<CONSUMOS DIARIOS >')
	    AADD(aMenus,'4<CONSUMOS FECHAS  >')
	    AADD(aMenus,'5<SERVICIOS ACTIVOS>')
	    AADD(aMenus,'6<PAZ Y SALVOS     >')

	    AADD(aAyuda,'Permite imprimir la Estiquetas de C¢digo de Barras')
	    AADD(aAyuda,'Permite imprimir los Carnets')
	    AADD(aAyuda,'Imprime los ingresos diarios a la Cafeteria')
	    AADD(aAyuda,'Imprime los ingresos por fechas a la Cafeteria')
	    AADD(aAyuda,'Imprime los Servicios Activos de Cafeteria')
	    AADD(aAyuda,'Permite Grabar los Paz y Salvos Acad‚micos')

       CASE nNroOpc == 4

	    AADD(aMenus,'1<VENTAS DE BOLETAS    >')
	    AADD(aMenus,'2<DEVOLUCION DE BOLETAS>')
	    AADD(aMenus,'3<BOLETAS CONSUMIDAS   >')
	    AADD(aMenus,'4<BOLETAS EMITIDAS     >')

	    AADD(aAyuda,'Permite vender las boletas')
	    AADD(aAyuda,'Permite vender las boletas')
	    AADD(aAyuda,'Permite Consultar los Consumos de las Boletas Vendidas')
	    AADD(aAyuda,'Permite Consultar las Boletas Disponibles')


       CASE nNroOpc == 5

	    aMenus := {'1<USUARIOS      >',;
		       '2<CAMBIAR CLAVE >',;
		       '3<REINDEXAR     >',;
		       '4<INTEGRIDAD    >',;
		       '5<EJECUTAR      >',;
		       '6<ACTUALIZAR    >',;
		       '7<MANTENIMIENTO >',;
		       '8<CONFIGURACION >',;
		       '9<VARIOS        >'}

	    aAyuda := {'Permite Crear usuarios y Asignar sus derechos.',;
		       'Permite cambiar la clave. ',;
		       'Reindexa los archivos del Sistema.',;
		       'Elimina los registros marcados como borrados.',;
		       'Permite Ejecutar un programa Externo.',;
		       'Permite Actualizar las estructuras de los Archivos del Sistema',;
		       'Permite el Mantenimiento de los Archivos del Sistema',;
		       'Permite definir las diferentes Configuraciones del Sistema',;
		       'Men£ con otros procesos utilitarios del Sistema'}
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:50 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

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
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

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

       LOCAL nPrueba := 0                   // Habilitar pruebas
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL bInsReg := NIL                 // Block Insertar registros
     *ÀVariables registros

       LOCAL cPatSim := ''                  // Path del Sima
       LOCAL cLogEmp := ''                  // Logo de la Empresa

       LOCAL  cOrden := ''                  // Orden

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
	    AADD(aUseDbf,{.T.,PathSis+'\'+fSimCaF,'CAF',NIL,lShared,nModCry})
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
	    CASE CAF->(RECCOUNT()) == 0
		 cError('NO EXISTE CONFIGURACION DEL SISTEMA')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseAll(aUseDbf)
	       QUIT
	    ENDIF

	    nPrueba := CaF->nPruebaCaF
	    lPrnArc := CaF->lPrnArcCaF
	    nCodPrn := CaF->nCodigoPrn
	    cOpcPrn := CaF->cOpcPrnCaF
	    cUsrIso := CaF->cUsrIsoCaF
	    nCodXsl := CaF->nCodXslCaF
	    cPiePag := CaF->cPiePagCaF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LECTURA DEL LOGO DE LA EMPRESA
	    cLogEmp := ''
	    IF !EMPTY(CAF->cLogEmpCaF)

	       cPatSim := cPathSima()
	       cLogEmp := cPatSim+'\'+'SimaCont\Bases\'+;
			  ALLTRIM(CAF->cLogEmpCaF)
	    ENDIF
	    CloseDbf('CAF')

	    nParameSet(aP1,'cLogEmp',cLogEmp)
**********FIN LECTURA DEL LOGO DE LA EMPRESA

**********DETALLES DEL INFORME
	    aP3 := {}
	    AADD(aP3,{'cPieTre',cPiePag})
	    AADD(aP3,{'cUsrIso',cUsrIso})
	    AADD(aP3,{'nCodXsl',nCodXsl})
**********FIN DETALLES DEL INFORME

**********LECTURA DE PATHS
	    PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		       @PathDos,@PathTre,@PathCua,nModCry,.F.)
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
	    FOR i:= 1 TO LEN(aDeMenu)
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
	    CASE nOpcPal == 1

		 DO CASE
		 CASE nNroOpc == 1
		      Cafe_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			       cJorTxt)
		     *Contro de Ingreso a la Biblioteca

		 ENDCASE

	    CASE nOpcPal == 2
		 DO CASE
		 CASE nNroOpc == 1
		      MantenAlu(aP1,aP2,aP3)
		     *Mantenimiento de Estudiantes

		 CASE nNroOpc == 2
		      MantenPro(aP1,aP2,aP3)
		     *Mantenimiento de Profesores

		 CASE nNroOpc == 3
		      MantenPer(aP1,aP2,aP3)
		     *Mantenimiento del Personal

		 CASE nNroOpc == 4
		      MantenPrs(aP1,aP2,aP3)
		     *Mantenimiento del Presupuesto

		 ENDCASE

	    CASE nOpcPal == 3
		 DO CASE
		 CASE nNroOpc == 1
		      Cafe_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			       cJorTxt)
		     *Etiquetas

		 CASE nNroOpc == 2
		      Cafe_302(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			       cJorTxt)
		     *Carnets

		 CASE nNroOpc == 3
		      Cafe_303(aP1,aP2,aP3)
		     *Consumos Diarios

		 CASE nNroOpc == 4
		      Cafe_304(aP1,aP2,aP3)
		     *Consumos por fechas

		 CASE nNroOpc == 5
		      Cafe_305(aP1,aP2,aP3)
		     *Servicios Activos

		 CASE nNroOpc == 6
		      Cafe_306(aP1,aP2,aP3)
		     *Control de Paz y Salvos

		 ENDCASE

	    CASE nOpcPal == 4

		 DO CASE
		 CASE nNroOpc == 1
		      Cafe_401(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			       cJorTxt)
		     *Ventas

		 CASE nNroOpc == 2
		      Cafe_402(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			       cJorTxt)
		     *Devoluci¢n de Boletas Vendidas

		 CASE nNroOpc == 3
		      MantenBol(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt,.T.)
		     *Mantenimiento de Boletas Consumidas

		 CASE nNroOpc == 4
		      MantenBol(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Mantenimiento de Boletas Imitidas
		 ENDCASE

	    CASE nOpcPal == 5
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

		 CASE nNroOpc == 3
		     *Indexa los archivos del sistema

		 CASE nNroOpc == 5
		      cOrden := SPACE(150)
		      @nFilInf+1,01 SAY 'ORDEN:' GET cOrden PICT '@S70'
		      READ
		      IF !SWPRUNCMD(cOrden,0,"","")
			 cError('DE EJECUCION')
		      ENDIF
		      cPausa()

		 CASE nNroOpc == 7
		      Cafe_507(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Mantenimientos

		 CASE nNroOpc == 8
		      CAFE_508(aP1,aP2,aP3)
		     *Configuraci¢n

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 02:10 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
		    PathClr,FileClr,PathSis,fSimCaF)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path General del sistema
       fSimCaF			            // Configuraci¢n del Sistema */
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
       DO CASE
       CASE DIRCHANGE (PathSis) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (PathSis) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathSis)
	    QUIT

       CASE DIRCHANGE(PathSis) == -3
	    DIRMAKE(PathSis)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DE DIRECTORIO BASES

*>>>>VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR
       IF !FILE(PathSis+'\'+fSimCaF)
	  RecuSimCaF(lShared,nModCry,PathSis,fSimCaF)
       ENDIF
       IF !FILE(PathClr+'\'+FileClr)
	  RecuDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActSimCaF(lShared,nModCry,PathSis,fSimCaF)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrClr(lShared,nModCry,PathClr,FileClr)
     *ÀActualizaci¢n de la Configuraci¢n del Colo
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysCaF(lShared,nModCry)
       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO DE BARRAS                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 07/2002 LUN A
       Colombia, Bucaramanga        INICIO: 10:40 PM   OCT 07/2002 LUN

OBJETIVOS:

1- Permite validar el c¢digo de barras

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el c¢digo de barras validado

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lInsCeros(cCodigo,nColIni)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // @C¢digo a Validar
       nColIni			            // Columna Inicial */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nLenCod := 0                   // Longitud del C¢digo
       LOCAL cCodUno := ''                  // C¢digo Parte Uno
       LOCAL cCodDos := ''                  // C¢digo Parte Dos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       nLenCod := LEN(cCodigo)
       nColIni := IF(EMPTY(nColIni),1,nColIni)
       cCodDos := SUBS(cCodigo,nColIni,nLenCod)
       lCorrecion(@cCodDos)
       IF nColIni == 1
	  cCodUno := ''
       ELSE
	  cCodUno := SUBS(cCodigo,1,nColIni-1)
       ENDIF
       cCodigo := cCodUno+cCodDos
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO
