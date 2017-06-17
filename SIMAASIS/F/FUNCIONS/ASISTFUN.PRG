/*                     SISTEMA CONTROL DE ASISTENCIA
		     BIBLIOTECAS DE FUNCIONES GENERALES


OBJETIVOS:

- Funciones generales para el sistema

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
*>>>>FIN DECLARACION DE CONSTANTES

/*************************************************************************
* TITULO..: INICIALIZACION PARAMETROS DE LA APLICACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 03:35 PM   MAY 26/2004 MIE

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   MAY 26/2004 MIE

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

FUNCTION RevisarDbf(aParam1,cSavPan)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1			            // Parametros Generales No.1
       cSavPan                              // Salvar pantalla */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL PathAct := ''                  // Path Actual

       LOCAL lPrnArc := .F.                 // .T. Imprimir en Archivo
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL lndexar := .F.                 // .T. Indexar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida */
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParam1
       IF !lParam0108(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,NIL,NIL,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       nActStrAno(lShared,nModCry,cPatSis,fAsiAno+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Configuraci¢n del A¤o.

       IF FILE(cPatSis+'\'+fAsiAno+cAnoUsr+ExtFile)
	  PathAsiAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		     @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>VALIDACION DEL MODO DE APERTURA DE LOS ARCHIVOS
       IF nModCry # 0 .AND. lShared
	  cError('LA APLICACION NO PUEDE SER MULTIUSUARIO')
	  CloseAll()
	  QUIT
       ENDIF
*>>>>FIN VALIDACION DEL MODO DE APERTURA DE LOS ARCHIVOS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO PRINCIPAL
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis) == -3
	    DIRMAKE(cPatSis)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO PRINCIPAL

*>>>>VERIFICACION O CREACION DEL DIRECTORIO DE IMPRESION
       DO CASE
       CASE DIRCHANGE (PathPrn) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (PathPrn) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathPrn)
	    QUIT

       CASE DIRCHANGE(PathPrn) == -3
	    DIRMAKE(PathPrn)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO DE IMPRESION

*>>>>VERIFICACION O CREACION DEL DIRECTORIO DE IMPRESION
       DO CASE
       CASE DIRCHANGE ('printer') == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE ('printer') == -5
	    cError('NO HAY DERECHOS EN EL DIRECTORIO printer')
	    QUIT

       CASE DIRCHANGE('printer') == -3
	    DIRMAKE('printer')
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO DE IMPRESION

*>>>>VERIFICACION O CREACION DEL DIRECTORIO FILEWWW
       DO CASE
       CASE DIRCHANGE (cPatSis+'\FILEWWW') == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\FILEWWW') == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\FILEWWW') == -3
	    DIRMAKE(cPatSis+'\FILEWWW')
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO FILEWWW

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+fErrSys) .AND.;
	    !FILE(PathSis+'\'+fSimAsi) .AND.;
	    !FILE(PathSis+'\'+FileClr) .AND.;
	    !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis+'\'+FileIso)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,cPatSis,cAnoUsr)

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+fSimAsi)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfAsi(lShared,nModCry,PathSis,fSimAsi)
	      ENDIF

	      IF !FILE(PathSis+'\'+fErrSys)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuErrSys(lShared,nModCry,PathSis,fErrSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FilePrn)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPrn(lShared,nModCry,PathSis,FilePrn)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileIso)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfIso(lShared,nModCry,PathSis,FileIso)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathUno+'\'+cPatSis+'\'+fPerso1)     .AND.;
	    !FILE(PathUno+'\'+cPatSis+'\'+FilePnl)     .AND.;
	    !FILE(PathUno+'\'+cPatSis+'\'+FileTpe)     .AND.;
	    !FILE(PathUno+'\'+cPatSis+'\'+FileHor)     .AND.;
	    !FILE(cPatSis+'\'+fAsiAno+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+fCtrAsi)                 .AND.;
	    !FILE(cPatSis+'\'+fTipAus)                 .AND.;
	    !FILE(cPatSis+'\'+fAsiNov)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,cMaeAlu,PathUno)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL SISTEMA
	      IF !FILE(PathUno+'\'+cPatSis+'\'+fPerso1)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPer(lShared,nModCry,PathUno+'\'+cPatSis,fPerso1)
		 lndexar := .F.
	      ENDIF

	      IF !FILE(PathUno+'\'+cPatSis+'\'+FilePnl)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPnl(lShared,nModCry,PathUno+'\'+cPatSis,FilePnl)
	      ENDIF

	      IF !FILE(PathUno+'\'+cPatSis+'\'+FileTpe)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTpe(lShared,nModCry,PathUno+'\'+cPatSis,FileTpe)
	      ENDIF

	      IF !FILE(PathUno+'\'+cPatSis+'\'+FileHor)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfHor(lShared,nModCry,PathUno+'\'+cPatSis,FileHor)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fAsiAno+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuAsiAno(lShared,nModCry,cPatSis,;
			    fAsiAno+cAnoUsr+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fCtrAsi)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCtr(lShared,nModCry,cPatSis,fCtrAsi)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fTipAus)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTau(lShared,nModCry,cPatSis,fTipAus)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fAsiNov)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfNov(lShared,nModCry,cPatSis,fAsiNov)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS DEL SISTEMA

       ENDCASE
*>>>>FIN CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA

*>>>>CREACION INDICES DEL SISTEMA
       IF (!FILE(PathUno+'\'+cPatSis+'\JAR\'+fNtxJar+cAnoSis+cExtNtx);
			       .AND. 'JAR' $ cMaeAlu) .OR.;
	  (!FILE(PathUno+'\'+cPatSis+'\JAR\'+Ntx1Jar+cAnoSis+cExtNtx);
			       .AND. 'JAR' $ cMaeAlu) .OR.;
	  (!FILE(PathUno+'\'+cPatSis+'\JAR\'+Ntx2Jar+cAnoSis+cExtNtx);
			       .AND. 'JAR' $ cMaeAlu) .OR.;
	  (!FILE(PathUno+'\'+cPatSis+'\PRI\'+fNtxPri+cAnoSis+cExtNtx);
			       .AND. 'PRI' $ cMaeAlu) .OR.;
	  (!FILE(PathUno+'\'+cPatSis+'\PRI\'+Ntx1Pri+cAnoSis+cExtNtx);
			       .AND. 'PRI' $ cMaeAlu) .OR.;
	  (!FILE(PathUno+'\'+cPatSis+'\PRI\'+Ntx2Pri+cAnoSis+cExtNtx);
			       .AND. 'PRI' $ cMaeAlu) .OR.;
	  (!FILE(PathUno+'\'+cPatSis+'\BTO\'+fNtxBto+cAnoSis+cExtNtx);
			       .AND. 'BTO' $ cMaeAlu) .OR.;
	  (!FILE(PathUno+'\'+cPatSis+'\BTO\'+Ntx1Bto+cAnoSis+cExtNtx);
			       .AND. 'BTO' $ cMaeAlu) .OR.;
	  (!FILE(PathUno+'\'+cPatSis+'\BTO\'+Ntx2Bto+cAnoSis+cExtNtx);
			       .AND. 'BTO' $ cMaeAlu)
/*
	  !FILE(PathUno+'\'+cPatSis+'\'+fNtxPe1) .OR.;
	  !FILE(PathUno+'\'+cPatSis+'\'+Ntx1Pe1)
*/
	  lndexar := .T.

       ENDIF
       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CREACION INDICES DEL SISTEMA

*>>>>ACTUALIZACION DE ESTRUCTURAS
       SET EXACT      ON                    // Busqueda Exacta
       nActStrErr(lShared,nModCry,PathSis,fErrSys)
     *ÀActualizaci¢n de los Errores del Sistema

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActStrIso(lShared,nModCry,PathSis,FileIso)
     *ÀActualizacion de Archios de documentos a imprimir

       nActStrAsi(lShared,nModCry,PathSis,fSimAsi)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrHra(lShared,nModCry,PathUno+'\'+cPatSis,FileHra)
     *ÀActualizaci¢n de Horas de Clase

       nActStrPer(lShared,nModCry,PathUno+'\'+cPatSis,fPerso1)
     *ÀActualizaci¢n archivos de personas de la empresa

       nActStrPnl(lShared,nModCry,PathUno+'\'+cPatSis,FilePnl)
     *ÀActualizaci¢n archivos personal de la empresa

       nActStrTpe(lShared,nModCry,PathUno+'\'+cPatSis,FileTpe)
     *ÀActualizaci¢n archivo tipo de personal

       nActStrHor(lShared,nModCry,PathUno+'\'+cPatSis,FileHor)
    *ÀActualizaci¢n del horario de clase

       nActStrAno(lShared,nModCry,cPatSis,fAsiAno+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Configuraci¢n del A¤o.

       nActStrCtr(lShared,nModCry,cPatSis,fCtrAsi)
     *ÀActualiaci¢n Control de asistencia

       nActStrTau(lShared,nModCry,cPatSis,fTipAus)
     *ÀActualiaci¢n de tipo de ausencias

       nActStrNov(lShared,nModCry,cPatSis,fAsiNov)
     *ÀActualiaci¢n novedades de asistencia.
       SET EXACT      OFF                   // Busqueda no exacta
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS

*>>>>INDEXAR LOS ARCHIVOS
       IF lndexar
	  Indexar(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu)
       ENDIF
*>>>>FIN INDEXAR LOS ARCHIVOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnArc := .F.
       IF !lUseDbf(.T.,PathSis+'\'+fSimAsi,'ASI',NIL,lShared,nModCry)
	  CloseDbf('ASI',PathSis+'\'+fSimAsi,nModCry)
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ASI->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       lPrnArc := ASI->lPrnArcAsi
       CloseDbf('ASI',PathSis+'\'+fSimAsi,nModCry)
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 26/2004 MIE

OBJETIVOS:

1)- Crea todos los archivos generales del sistema

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,nModCry,cPatSis,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS GENERALES DEL SISTEMA")

       Termometro(50)
       CreaErrSys(lShared,nModCry,PathSis,fErrSys)

       Termometro(60)
       CreaDbfClr(lShared,nModCry,PathSis,FileClr)

       Termometro(75)
       CreaDbfPrn(lShared,nModCry,PathSis,FilePrn)

       Termometro(80)
       CreaDbfIso(lShared,nModCry,PathSis,FileIso)

       Termometro(100)
       CreaDbfAsi(lShared,nModCry,PathSis,fSimAsi)

       RESTSCREEN(0,0,24,79,cSavPan)

       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:05 PM   MAY 26/2004 MIE

OBJETIVOS:

1- Crea todos los archivos de la aplicaci¢n o del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,cMaeAlu,cPatCon)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       cMaeAlu                              // Maestros habilitados
       cPatCon                              // Path de la Contabilidad */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE  ESTRUCTURAS DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO LOS ARCHIVOS DEL SISTEMA")

       Termometro(15)
       CreaDbfPer(lShared,nModCry,cPatCon+'\'+cPatSis,fPerso1)

       Termometro(30)
       CreaDbfPnl(lShared,nModCry,cPatCon+'\'+cPatSis,FilePnl)

       Termometro(45)
       CreaDbfTpe(lShared,nModCry,cPatCon+'\'+cPatSis,FileTpe)

       Termometro(60)
       CreaDbfHor(lShared,nModCry,cPatCon+'\'+cPatSis,FileHor)

       Termometro(75)
       CreaAsiAno(lShared,nModCry,cPatSis,fAsiAno+cAnoUsr+ExtFile)

       Termometro(90)
       CreaDbfCtr(lShared,nModCry,cPatSis,fCtrAsi)

       Termometro(95)
       CreaDbfTau(lShared,nModCry,cPatSis,fTipAus)

       Termometro(100)
       CreaDbfNov(lShared,nModCry,cPatSis,fAsiNov)

       RETURN NIL
*>>>>FIN CREACION DE  ESTRUCTURAS DEL SISTEMA

/*************************************************************************
* TITULO..: INDEXAR LOS ARCHIVOS DEL SISTEMA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:10 PM   MAY 26/2004 MIE

OBJETIVOS:

1- Pone en uso todos los archivos de sistema que estan indexados

2- Crea los archivos indices del sistema

3- Retorna NIL


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Indexar(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"      // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       CloseAll()                           // Cierre de Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

/*
*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fPerso1,'PE1',NIL,lShared,nModCry})
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
       Termometro(10)

       SELECT PE1
       fNtxTem := PathUno+'\'+cPatSis+'\'+fNtxPe1
       INDEX ON PE1->nIdeCodPer TO &fNtxTem
       Termometro(75)

       fNtxTem := PathUno+'\'+cPatSis+'\'+Ntx1Pe1
       INDEX ON PE1->cDocNitPer+PE1->cTipNitPer TO &fNtxTem
*>>>>FIN CREACION DEL INDICES DEL SISTEMA
*/

*>>>>CREACION DE LOS INDICES COMPARTIDOS
       IndexarAlu(lShared,PathUno+'\'+cPatSis,cAnoSis,cMaeAlu)
       CloseAll()

       RETURN NIL
*>>>>FIN CREACION DE LOS INDICES COMPARTIDOS

/*************************************************************************
* TITULO..: DEFINICION DE LOS MENUS DE LA APLICACION                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:20 PM   MAY 26/2004 MIE

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

	    aMenus := {}
	    AADD(aMenus,'1ASISTENCIA')   // 1
	    AADD(aMenus,'2CONSULTAS')    // 3
	    AADD(aMenus,'3INFORMES')     // 4
	    AADD(aMenus,'4UTILIDADES')   // 7

	    aAyuda := {}
	    AADD(aAyuda,'Permite Controlar la Asistencia al Colegio')
	    AADD(aAyuda,'Permite realizar las Consultas del Sistema')
	    AADD(aAyuda,'Permite imprimir los informes del Sistema')
	    AADD(aAyuda,'Permite Ejecutar varias utilidades del sistema')

       CASE nNroOpc == 1

	    aMenus := {}
	    AADD(aMenus,'1<ESTUDIANTE POR CODIGO>')
	    AADD(aMenus,'2<ESTUDIANTE POR BARRAS>')
	    AADD(aMenus,'3<ESTUDIANTE POR NOMBRE>')
	    AADD(aMenus,'4<PERSONAL POR CODIGO  >')
	    AADD(aMenus,'5<CONTROL DE INGRESO   >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite leer c¢digo del estudiante manualmente')
	    AADD(aAyuda,'Permite leer c¢digo del estudiante por el c¢digo de Barras')
	    AADD(aAyuda,'Permite leer el estudiante por el nombre')
	    AADD(aAyuda,'Permite leer c¢digo del personal por el c¢digo')
	    AADD(aAyuda,'Permite registrar el control de ingresos y salidas del personal de la Instituci¢n')


       CASE nNroOpc == 2   // 3

	    aMenus := {}
	    AADD(aMenus,'1<POR ESTUDIANTES>')
	    AADD(aMenus,'2<POR PROFESORES >')
	    AADD(aMenus,'3<POR PERSONAL   >')
	    AADD(aMenus,'4<POR FECHA      >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite consultar las novedades de los Estudiantes')
	    AADD(aAyuda,'Permite consultar las novedades por Profesor')
	    AADD(aAyuda,'Permite consultar las novedades por Personal')
	    AADD(aAyuda,'Permite consultar las novedades por fechas')

       CASE nNroOpc == 3  // 4

	    aMenus := {}
	    AADD(aMenus,'1<NOVEDADES ESTUDIANTE>')
	    AADD(aMenus,'2<AUSENCIAS ASIGNATURA>')
	    AADD(aMenus,'3<NOVEDADES MESES     >')
	    AADD(aMenus,'4<AUSENCIAS ESTUDIANTE>')
	    AADD(aMenus,'5<AUSENCIAS BOLETINES >')
	    AADD(aMenus,'6<AUSENCIAS AREAS     >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite imprimir los estudiantes con novedades de asistencia')
	    AADD(aAyuda,'Las ausencias de los estudiantes por asignaturas')
	    AADD(aAyuda,'Las ausencias de los estudiantes por meses')
	    AADD(aAyuda,'Permite imprimir los estudiantes con ausencias')
	    AADD(aAyuda,'Graba las ausencias al boletin')
	    AADD(aAyuda,'Totaliza las ausencias de las asignaturas en las areas')

       CASE nNroOpc == 4  // 7

	    aMenus := {}
	    AADD(aMenus,'1<USUARIOS      >')
	    AADD(aMenus,'2<CAMBIAR CLAVE >')
	    AADD(aMenus,'3<REINDEXAR     >')
	    AADD(aMenus,'4<INTEGRIDAD    >')
	    AADD(aMenus,'5<EJECUTAR      >')
	    AADD(aMenus,'6<ACTUALIZAR    >')
	    AADD(aMenus,'7<MANTENIMIENTO >')
	    AADD(aMenus,'8<CONFIGURACION >')
	    AADD(aMenus,'9<VARIOS        >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
	    AADD(aAyuda,'Permite cambiar la clave')
	    AADD(aAyuda,'Reindexa los archivos del Sistema')
	    AADD(aAyuda,'Elimina los registros marcados como borrados.')
	    AADD(aAyuda,'Permite Ejecutar un programa Externo.')
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAY 26/2004 MIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubMenus(aParam1,;
		  nOpcion,nOpcPal,aColSup,cDerech,nColAno,cSavPan)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       aColSup                              // Columnas para los sub_men£s
       cDerech                              // Derechos en el sistema
       nColAno                              // Columna A¤o del sistema
       cSavPan                              // Salvar Pantalla */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>PARAMETROS GENERALES
       LOCAL aParam2 := {}                  // Parametros Generales
       LOCAL aParam3 := {}                  // Parametros Generales
*>>>>FIN PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL nPrueba := .F.                 // Activar Pruebas

       LOCAL lSiMenu := .T.                 //.T.Opci¢n principal con SubMen£
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opci¢n
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones

       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£
       LOCAL       i := 0                   // Contador
       LOCAL cOrden  := ''                  // Orden para Ejecutar
       MEMVA xClrSys			    // Color del Sistema

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida */
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0108(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,NIL,NIL,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  cError('ERROR DE PARAMETROS GENERALES')
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DESARROLLO DEL PRIMER NIVEL
       DO WHILE .T.

**********LECTURA DE PATHS
	    PathAsiAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		       @PathDos,@PathTre,@PathCua,nModCry,.F.)
**********FIN LECTURA DE PATHS

**********SELECCION DE LOS SUBMENUS
	    @ 100,100 SAY ""
	    CloseAll()
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

	       nFilSup := nFilPal+1
	       nColSup := aColSup[nOpcion]
	     *ÀCalculo coordenadas del men£

*--------------CAMBIA EL A¥O DEL SISTEMA
		 LineaEstado('<F2>CAMBIA A¥O. '+;
			     'LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
		 SETKEY(K_F2,{||LeeAnoSys(nColAno,@cAnoUsr,;
					  @cPatSis,cNomEmp,cNomSis)})

		 SETKEY(K_F10,{||LeerFecHora(cNomSis)})
*--------------FIN CAMBIA EL A¥O DEL SISTEMA

	       nNroOpc := nMenu(aMenu,aHelp,nFilSup,nColSup,NIL,NIL,;
				nNroOpc,NIL,;
				IF(!EMPTY(xClrSys),xClrSys[3],''))


	       SETKEY(K_F2,NIL)
	       SETKEY(K_F10,NIL)
	       lSiMenu := .T.

	    ENDIF

	    IF nNroOpc == 0
	       EXIT
	    ENDIF
	    nNroOpc := VAL(SUBS(aDeMenu[nNroOpc],1,1))
	    cSavLin := SAVESCREEN(0,0,02,79)
	    LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
**********FIN EJECUCION DE LOS SUBMENUS

**********PARAMETROS GENERALES
	    nFilInf := nFilSup + LEN(aMenu) + 1
	    nColInf := aColSup[nOpcion]

	    aParam2 := {}
	    AADD(aParam2,{'nFilInf',nFilInf})
	    AADD(aParam2,{'nColInf',nColInf})
**********FIN PARAMETROS GENERALES

**********ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL
	    DO CASE
	    CASE nOpcPal == 1

		 DO CASE
		 CASE nNroOpc == 1

		      AADD(aParam2,{'nTipLec',1})

		      Asist_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt,1)
		     *Lectura de Asistentencia manualmente

		 CASE nNroOpc == 2

		      AADD(aParam2,{'nTipLec',2})

		      Asist_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt,2)
		     *Lectura de Asistentencia por c¢digo de Barras

		 CASE nNroOpc == 3

		      AADD(aParam2,{'nTipLec',3})

		      Asist_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt,3)
		     *Lectura de Asistentencia por nonbre

		 CASE nNroOpc == 4

		      AADD(aParam2,{'nTipLec',2})

		      Asist_102(aParam1,aParam2)
		     *Lectura de Asistentencia por c¢digo de Barras. Personal

		 CASE nNroOpc == 5

		      AADD(aParam2,{'nTipLec',2})

		      Asist_103(aParam1,aParam2)
		     *Control de Ingreso General

		 ENDCASE

	    CASE nOpcPal == 2   // 3

		 DO CASE
		 CASE nNroOpc == 1
		      Asist_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Consultas por estudiante.

		 CASE nNroOpc == 2

		      Asist_302(aParam1,aParam2,aParam3)
		     *Consultas por profesor

		 CASE nNroOpc == 3

*---------------------AREAS DE TRABAJO
			aArchvo := {}
			AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
			AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+fPerso1,NIL,'PER'})
			AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+FilePnl,NIL,'PNL'})
			AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+FileTpe,NIL,'TPE'})
			AADD(aArchvo,{cPatSis+'\'+FAsiAno+cAnoUsr+ExtFile,;
						  NIL,'ASA'})
			AADD(aArchvo,{cPatSis+'\'+fAsiNov,NIL,'NOV'})
*---------------------FIN AREAS DE TRABAJO

*---------------------MANTENIMIENTO DEL ARCHIVO
			lModReg := .F.
			lDelReg := .F.
			lInsReg := .F.
			lHaySql := .F.

			MantenPnl(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
				  cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
				  cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
				  PathUno,cPatSis,cMaeAlu,cMaeAct,nFilInf,nColInf)
*---------------------FIN MANTENIMIENTO DEL ARCHIVO

		 CASE nNroOpc == 4
		      MantenCtr(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt,.T.)
		     *Novedades de Asistencia por fecha

		 OTHERWISE
		     cError('PENDIENTE')

		 ENDCASE


	    CASE nOpcPal == 3   // 4

		 DO CASE
		 CASE nNroOpc == 1
		      Asist_401(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Impresiones

		 CASE nNroOpc == 2
		      Asist_402(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Impresiones por materia

		 CASE nNroOpc == 3
		      Asist_403(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Impresiones por mes

		 CASE nNroOpc == 4
		      Asist_404(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Estudiantes con novedades de asistencia

		 CASE nNroOpc == 5
		      Asist_405(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Impresiones por materia

		 CASE nNroOpc == 6
		      Asist_406(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Totalizar ausencias de asignaturas en areas.


		 ENDCASE

	    CASE nOpcPal == 4   //
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
		      Indexar(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu)
		     *Indexa los archivos del sistema

		 CASE nNroOpc == 5
		      cOrden := SPACE(150)
		      @nFilInf+1,01 SAY 'ORDEN:' GET cOrden PICT '@S70'
		      READ
		      IF !SWPRUNCMD(cOrden,0,"","")
			 cError('DE EJECUCION')
		      ENDIF
		      cPausa()


		 CASE nNroOpc == 6



		 CASE nNroOpc == 7
		      Asist_707(aParam1,aParam2,aParam3)
		     *Mantenimiento archivos del sistema

		 CASE nNroOpc == 8
		      Asist_708(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Configuraciones

		 CASE nNroOpc == 9


		 ENDCASE

	    ENDCASE

	    RESTSCREEN(0,0,24,79,cSavPan)
	    RESTSCREEN(0,0,02,79,cSavLin)
	    CloseAll()
**********FIN ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN DESARROLLO DEL PRIMER NIVEL

/*************************************************************************
* TITULO ..: LECTURA DEL COLOR DEL SISTEMA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:45 PM   MAY 26/2004 MIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
		    PathClr,FileClr,PathSis,fSimAsi)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path General del sistema
       fSimAsi			            // Configuraci¢n del Sistema */
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
       IF !FILE(PathSis+'\'+fSimAsi)
	  RecuDbfAsi(lShared,nModCry,PathSis,fSimAsi)
       ENDIF
       IF !FILE(PathClr+'\'+FileClr)
	  RecuDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrAsi(lShared,nModCry,PathSis,fSimAsi)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrClr(lShared,nModCry,PathClr,FileClr)
     *ÀActualizaci¢n de la Configuraci¢n del Colo
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysAsi(lShared,nModCry)

       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR

/*************************************************************************
* TITULO..: PARAMETOS GENERALES DEL SISTEMA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2007 MIE A
       Bucaramanga, Colombia        INICIO: 08:00 PM   NOV 12/2007 MIE

OBJETIVOS:

1- Lee los parametros generales del sistema en variables locales.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lParam0108(aParams,;
		    lShared,nModCry,cNomSis,;
		    cEmpPal,cNitEmp,cNomEmp,cNomSec,cCodEmp,;
		    cNomUsr,cAnoUsr,cAnoSis,cPatSis,;
		    nFilPal,nFilInf,nColInf,;
		    PathW01,;
		    cMaeAlu,cMaeAct,cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParams                              // Parametros Generales

       lShared                              // @.T. Sistema Compartido
       nModCry                              // @Modo de Protecci¢n
       cNomSis                              // @Nombre del Sistema
     *ÀDetalles del Sistema

       cEmpPal                              // @Nombre de la Empresa principal
       cNitEmp                              // @Nit de la Empresa
       cNomEmp                              // @Nombre de la Empresa
       cNomSec                              // @Nombre de la Empresa Secundario
       cCodEmp                              // @C¢digo de la Empresa
     *ÀDetalles de la Empresa

       cNomUsr                              // @Nombre del Usuario
       cAnoUsr                              // @A¤o del Usuario
       cAnoSis                              // @A¤o del Sistema
       cPatSis                              // @Path del sistema
     *ÀDetalles del Usuario

       nFilPal                              // @Fila Inferior Men£ principal
       nFilInf                              // @Fila Inferior del SubMen£
       nColInf                              // @Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       PathW01                              // @Sitio No.01 del Sistema
     *ÀSitios del Sistema

       cMaeAlu                              // @Maestros habilitados
       cMaeAct                              // @Maestro Activo
       cJorTxt                              // @Jornada escogida */
     *ÀDetalles Acad‚micos
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DEL SISTEMA
       lShared := xParams(aParams,'lShared')
       nModCry := xParams(aParams,'nModCry')
       cNomSis := xParams(aParams,'cNomSis')

       IF lShared == NIL .OR.;
	  nModCry == NIL .OR.;
	  cNomSis == NIL
	  lHayErr := .T.
       ENDIF
*>>>>FIN DETALLES DEL SISTEMA

*>>>>DETALLES DE LA EMPRESA
       cEmpPal := xParams(aParams,'cEmpPal')
       cNitEmp := xParams(aParams,'cNitEmp')
       cNomEmp := xParams(aParams,'cNomEmp')
       cNomSec := xParams(aParams,'cNomSec')
       cCodEmp := xParams(aParams,'cCodEmp')

       IF cEmpPal == NIL .OR.;
	  cNitEmp == NIL .OR.;
	  cNomEmp == NIL .OR.;
	  cNomSec == NIL .OR.;
	  cCodEmp == NIL
	  lHayErr := .T.
       ENDIF
*>>>>FIN DETALLES DE LA EMPRESA

*>>>>DETALLES DEL USUARIO
       cNomUsr := xParams(aParams,'cNomUsr')
       cAnoUsr := xParams(aParams,'cAnoUsr')
       cAnoSis := xParams(aParams,'cAnoSis')
       cPatSis := xParams(aParams,'cPatSis')

       IF cNomUsr == NIL .OR.;
	  cAnoUsr == NIL .OR.;
	  cAnoSis == NIL .OR.;
	  cPatSis == NIL
	  lHayErr := .T.
       ENDIF
*>>>>FIN DETALLES DEL USUARIO

*>>>>DETALLES TECNICOS
       nFilPal := xParams(aParams,'nFilPal')
       IF nFilInf # NIL
	  nFilInf := xParams(aParams,'nFilInf')
       ENDIF
       IF nColInf # NIL
	  nColInf := xParams(aParams,'nColInf')
       ENDIF

       IF nFilPal == NIL
	  lHayErr := .T.
       ENDIF
*>>>>FIN DETALLES TECNICOS

*>>>>SITIOS DEL SISTEMA
       PathW01 := xParams(aParams,'PathW01')

       IF PathW01 == NIL
	  lHayErr := .T.
       ENDIF
*>>>>FIN SITIOS DEL SISTEMA

*>>>>DETALLES ACADEMICOS
       cMaeAlu := xParams(aParams,'cMaeAlu')
       cMaeAct := xParams(aParams,'cMaeAct')
       cJorTxt := xParams(aParams,'cJorTxt')

       IF cMaeAlu == NIL .OR.;
	  cMaeAct == NIL .OR.;
	  cJorTxt == NIL
	  lHayErr := .T.
       ENDIF
       RETURN !lHayErr
*>>>>FIN DETALLES ACADEMICOS

/*************************************************************************
* TITULO DE LA FUNCION..: APERTURA DE LOS ARCHIVOS DE GRUPOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:50 PM   FEB 02/96 VIE

OBJETIVOS:

1)- Pone en uso los archivos de grupos

2)- Retorna por referencia los param‚tros de la funci¢n marcados con @

3)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseGru(lShared,cPatSis,cMaeAlu,cAnoSis,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cPatSis			            // Path del Sistema
       cMaeAlu                              // Maestros habilitados
       cAnoSis                              // A¤o del sistema
       lAnoAct                              // .F. A¤o Anteriores */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                // .T. Hay Error
       LOCAL PathGru := ''                 // Path del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lAnoAct := IF(lAnoAct == NIL,.T.,lAnoAct)

       IF 'JAR' $ cMaeAlu

	  PathGru := cPatSis+'\JAR\'
	  IF !lUseDbf(.T.,PathGru+FGruJar+cAnoSis+ExtFile,;
			  IF(lAnoAct,'GRU','GRU'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE JARDIN EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu

	  PathGru := cPatSis+'\PRI\'
	  IF !lUseDbf(.T.,PathGru+FGruPri+cAnoSis+ExtFile,;
			  IF(lAnoAct,'GRU','GRU'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE PRIMARIA EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu

	  PathGru := cPatSis+'\BTO\'
	  IF !lUseDbf(.T.,PathGru+FGruBto+cAnoSis+ExtFile,;
			  IF(lAnoAct,'GRU','GRU'),NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE BACHILLERATO EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO