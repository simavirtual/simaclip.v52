/*                 SIMA - SISTEMA PARA INTRANET E INTERNET
			    FUNCIONES GENERALES

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Define por defecto los parametros de la aplicaci¢n

2- Retorna NIL

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
       SETKEY(K_ALT_M, {|| KEYSEND("¥", .T., .T.)})
       SETPOS(24, 0)
       CloseAll()
       RETURN NIL
*>>>>FIN ASIGNACION DE FUNCIONES A LAS TECLAS

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:05 AM   OCT 01/2004 VIE

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

FUNCTION RevisarDbf(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,cNomUsr,cAnoUsr,cPatDat,;
		    cPatSys,cPatSis,cSavPan,cMaeAlu,cMaeAct,;
		    cIniJor)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del usuario
       cAnoUsr			            // A¤o del usuario
       cPatDat                              // @Path para Datos
       cPatSys                              // @Path del Sistema
       cPatSis                              // Path del sistema
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activado
       cIniJor                              // Iniciales de la jornada */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL PathAct := ''                  // Path Actual

       LOCAL lPrnArc := .F.                 // .T. Imprimir en Archivo
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL lndexar := .F.                 // .T. Indexar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL MODO DE APERTURA DE LOS ARCHIVOS
       IF nModCry # 0 .AND. lShared
	  cError('LA APLICACION NO PUEDE SER MULTIUSUARIO')
	  CloseAll()
	  QUIT
       ENDIF
*>>>>FIN VALIDACION DEL MODO DE APERTURA DE LOS ARCHIVOS

*>>>>CREACION DE DIRECTORIOS
       PathAct := cPathAct()

       IF !EMPTY(cPatDat)
	  Mdir(cPatDat+'\'+'BASES',PathAct)
	  Mdir(cPatDat+'\'+cPatSis,PathAct)
       ELSE
	  Mdir('BASES',PathAct)
	  Mdir(cPatSis,PathAct)
       ENDIF
     *ÀDatos del Sistema

       Mdir(PathPrn,PathAct)
     *ÀDirectorio de Impresi¢n

       Mdir(cPatSis(cPatDat,cPatSys,cPatSis)+'\FILEWWW',PathAct)
     *ÀDirectorio del A¤o,FileWww
*>>>>FIN CREACION DE DIRECTORIOS

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+FileDbf)                  .AND.;
	    !FILE(PathSis+'\'+FileStr)                  .AND.;
	    !FILE(PathSis+'\'+fErrSys) .AND.;
	    !FILE(PathSis+'\'+FileClr) .AND.;
	    !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+FilePer) .AND.;
	    !FILE(PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+FileEmp) .AND.;
	    !FILE(PathSis+'\'+fSimPak)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,nModCry,cPatDat,cPatSys,cAnoUsr)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+FileDbf)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfFsy(lShared,nModCry,PathSis,FileDbf)
		 DbfSysPak(cPatDat)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileStr)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfStr(lShared,nModCry,PathSis,FileStr)
		 DbfStrPak(cAnoUsr)
	      ENDIF

	      IF !FILE(PathSis+'\'+fErrSys)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuErrSys(lShared,nModCry,PathSis,fErrSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FilePrn)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPrn(lShared,nModCry,PathSis,FilePrn)
	      ENDIF

	      IF !FILE(PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+FilePer)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPer(lShared,nModCry,;
			    PathSis(cPatDat+'\'+cPatSys,PathSis),FilePer)
	      ENDIF

	      IF !FILE(PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+FileEmp)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfEmp(lShared,nModCry,;
			    PathSis(cPatDat+'\'+cPatSys,PathSis),FileEmp)
	      ENDIF

	      IF !FILE(PathSis+'\'+fSimPak)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPak(lShared,nModCry,PathSis,fSimPak)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		  fPakAno+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		  FileReg) .AND.;
	    !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		  FileCat) .AND.;
	    !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		  FileTar) .AND.;
	    !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		  FileVeh) .AND.;
	    !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		  FileCaj) .AND.;
	    !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		  FileRca) .AND.;
	    !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		  fDesPak)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CrearDbfs(lShared,nModCry,cPatSis(cPatDat,cPatSys,cPatSis),;
		      cAnoUsr,cMaeAlu)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL SISTEMA
	      IF !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		       fPakAno+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuPakAno(lShared,nModCry,;
			    cPatSis(cPatDat,cPatSys,cPatSis),;
			    fPakAno+cAnoUsr+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+FileReg)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfReg(lShared,nModCry,;
			    cPatSis(cPatDat,cPatSys,cPatSis),;
			    FileReg)
	      ENDIF

	      IF !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+FileCat)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCat(lShared,nModCry,;
			    cPatSis(cPatDat,cPatSys,cPatSis),;
			    FileCat)
	      ENDIF

	      IF !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+FileTar)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTar(lShared,nModCry,;
			    cPatSis(cPatDat,cPatSys,cPatSis),;
			    FileTar)
	      ENDIF

	      IF !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+FileVeh)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfVeh(lShared,nModCry,;
			    cPatSis(cPatDat,cPatSys,cPatSis),;
			    FileVeh)
	      ENDIF

	      IF !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+FileCaj)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCaj(lShared,nModCry,;
			    cPatSis(cPatDat,cPatSys,cPatSis),;
			    FileCaj)
	      ENDIF

	      IF !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+FileRca)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfRca(lShared,nModCry,;
			    cPatSis(cPatDat,cPatSys,cPatSis),;
			    FileRca)
	      ENDIF

	      IF !FILE(cPatSis(cPatDat,cPatSys,cPatSis)+'\'+fDesPak)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfDes(lShared,nModCry,;
			    cPatSis(cPatDat,cPatSys,cPatSis),;
			    fDesPak)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS DEL SISTEMA

       ENDCASE
*>>>>FIN CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA

*>>>>ACTUALIZACION DE ESTRUCTURAS
       SET CURSOR ON
       SET EXACT      ON                    // Busqueda Exacta

       nActStrFsy(lShared,nModCry,PathSis,FileDbf)
     *ÀActualizaci¢n Archivos del Sistema

       nActStrStr(lShared,nModCry,PathSis,FileStr)
     *ÀActualizaci¢n Archivos de Estructuras

       nActStrErr(lShared,nModCry,PathSis,fErrSys)
     *ÀActualizaci¢n de los Errores del Sistema

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActStrPer(lShared,nModCry,;
		  PathSis(cPatDat+'\'+cPatSys,PathSis),FilePer)
     *ÀActualizaci¢n de las Personas

       nActStrEmp(lShared,nModCry,;
		  PathSis(cPatDat+'\'+cPatSys,PathSis),FileEmp)
     *ÀActualiaci¢n Empresas

       nActStrPak(lShared,nModCry,PathSis,fSimPak)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrPkA(lShared,nModCry,;
		  cPatSis(cPatDat,cPatSys,cPatSis),;
		  fPakAno+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Configuraci¢n del A¤o.

       nActStrReg(lShared,nModCry,;
		  cPatSis(cPatDat,cPatSys,cPatSis),;
		  FileReg)
     *ÀActualizaci¢n de Archivo de Registro

       nActStrCat(lShared,nModCry,;
		  cPatSis(cPatDat,cPatSys,cPatSis),;
		  FileCat)
     *ÀActualizaci¢n de Archivo de Tarifas

       nActStrTar(lShared,nModCry,;
		  cPatSis(cPatDat,cPatSys,cPatSis),;
		  FileTar)
     *ÀActualizaci¢n de Archivo de Tipo de pago

       nActStrVeh(lShared,nModCry,;
		  cPatSis(cPatDat,cPatSys,cPatSis),;
		  FileVeh)
     *ÀActualizaci¢n de Archivo de Vehiculos

       nActStrCaj(lShared,nModCry,;
		  cPatSis(cPatDat,cPatSys,cPatSis),;
		  FileCaj)
     *ÀActualizaci¢n. Tabla Caja

       nActStrRca(lShared,nModCry,;
		  cPatSis(cPatDat,cPatSys,cPatSis),;
		  FileRca)
     *ÀActualizaci¢n. Tabla Retiros de Caja

       nActStrDes(lShared,nModCry,;
		  cPatSis(cPatDat,cPatSys,cPatSis),;
		  fDesPak)
     *ÀActualizaci¢n. Tabla Descuentos

       SET EXACT      OFF                   // Busqueda no exacta
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS

*>>>>VALIDACION DE LOS INDICES
       IF !FILE(PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+fNtxPer) .OR.;
	  !FILE(PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+Ntx1Per) .OR.;
	  !FILE(PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+fNtxEmp)
	  lndexar := .T.
       ENDIF
*>>>>FIN VALIDACION DE LOS INDICES

*>>>>INDEXAR LOS ARCHIVOS
       IF lndexar
	  Indexar(lShared,nModCry,cAnoUsr,cPatDat,cPatSys,cPatSis)
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
*>>>>FIN INDEXAR LOS ARCHIVOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnArc := .F.
       IF !lUseDbf(.T.,PathSis+'\'+fSimPak,'PAK',NIL,lShared,nModCry)
	  CloseDbf('PAK')
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PAK->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       lPrnArc := PAK->lPrnArcPak
       CloseDbf('PAK')
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:10 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Crea todos los archivos generales del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,nModCry,cPatDat,cPatSys,cAnoUsr)


*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatDat				    // Path del sistema
       cPatSys                              // Path del Sistema
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

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
       CreaDbfClr(lShared,nModCry,PathSis,FileClr)

       Termometro(60)
       CreaDbfPrn(lShared,nModCry,PathSis,FilePrn)

       Termometro(80)
       CreaDbfPer(lShared,nModCry,;
		  PathSis(cPatDat+'\'+cPatSys,PathSis),FilePer)

       Termometro(90)
       CreaDbfEmp(lShared,nModCry,;
		  PathSis(cPatDat+'\'+cPatSys,PathSis),FileEmp)

       CreaDbfPak(lShared,nModCry,PathSis,fSimPak)
       Termometro(100)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Crea todos los archivos de la aplicaci¢n o del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO LOS ARCHIVOS DEL SISTEMA")

       Termometro(12)
       CreaPakAno(lShared,nModCry,cPatSis,fPakAno+cAnoUsr+ExtFile)

       Termometro(24)
       CreaDbfReg(lShared,nModCry,cPatSis,FileReg)

       CreaDbfCat(lShared,nModCry,cPatSis,FileCat)
       Termometro(36)

       CreaDbfTar(lShared,nModCry,cPatSis,FileTar)
       Termometro(48)

       CreaDbfVeh(lShared,nModCry,cPatSis,FileVeh)
       Termometro(60)

       CreaDbfCaj(lShared,nModCry,cPatSis,FileCaj)
       Termometro(72)

       CreaDbfRca(lShared,nModCry,cPatSis,FileRca)
       Termometro(84)

       CreaDbfDes(lShared,nModCry,cPatSis,fDesPak)
       Termometro(100)

       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS DEL SISTEMA

/*************************************************************************
* TITULO..: INDEXAR LOS ARCHIVOS DEL SISTEMA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:20 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Pone en uso todos los archivos de sistema que estan indexados

2- Crea los archivos indices del sistema

3- Retorna NIL


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Indexar(lShared,nModCry,cAnoUsr,cPatDat,cPatSys,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatDat                              // Path para Datos
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"      // Archivos del Sistema
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
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+;
			 FileEmp,'EMP',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS PARA INDEXAR')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>CREACION DEL INDICES DEL SISTEMA
       Termometro(0,'INDEXANDO ARCHIVOS DEL SISTEMA')
       Termometro(10)

       SELECT PER
       fNtxPer := PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+fNtxPer
       INDEX ON PER->nIdeCodPer TO &fNtxPer

       Ntx1Per := PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+Ntx1Per
       INDEX ON PER->cDocNitPer+PER->cTipNitPer TO &Ntx1Per
       Termometro(50)

       SELECT EMP
       fNtxTem := PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+fNtxEmp
       INDEX ON EMP->cDocNitEmp+EMP->cTipNitEmp TO &fNtxTem
       Termometro(100)
*>>>>FIN CREACION DEL INDICES DEL SISTEMA

*>>>>CREACION DE LOS INDICES COMPARTIDOS
       CloseAll()
       RETURN NIL
*>>>>FIN CREACION DE LOS INDICES COMPARTIDOS

/*************************************************************************
* TITULO..: DEFINICION DE LOS MENUS DE LA APLICACION                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:25 AM   OCT 01/2004 VIE

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
	    AADD(aMenus,'1ENTRADAS')
	    AADD(aMenus,'2CONSULTAS')
	    AADD(aMenus,'3INFORMES')
	    AADD(aMenus,'4INFORMES')
	    AADD(aMenus,'5INFORMES')
	    AADD(aMenus,'6INFORMES')
	    AADD(aMenus,'7UTILIDADES')

	    aAyuda := {}
	    AADD(aAyuda,'Permite Registrar los ingresos al parqueadero')
	    AADD(aAyuda,'Permite realizar las Consutas del Sistema')
	    AADD(aAyuda,'Permite imprimir los Informes del Sistema')
	    AADD(aAyuda,'Permite Ejecutar varias utilidades del sistema')
	    AADD(aAyuda,'Pendiente')
	    AADD(aAyuda,'Pendiente')
	    AADD(aAyuda,'Pendiente')

       CASE nNroOpc == 1

	    aMenus := {}
	    AADD(aMenus,'1<REGISTRO DIARIO>')
	    AADD(aMenus,'2<MENSUALIDADES  >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite registrar el ingreso y salida del parqueadero')
	    AADD(aAyuda,'Permite el pago de las mensualidades')

       CASE nNroOpc == 2

	    aMenus := {}
	    AADD(aMenus,'1<REGISTROS >')
	    AADD(aMenus,'2<CATEGORIAS>')
	    AADD(aMenus,'3<TARIFAS   >')
	    AADD(aMenus,'4<VEHICULOS >')
	    AADD(aMenus,'5<CAJA      >')
	    AADD(aMenus,'6<PERSONAS  >')
	    AADD(aMenus,'7<EMPRESAS  >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite consultar los registros del parqueadero')
	    AADD(aAyuda,'Permite consultar las Categorias')
	    AADD(aAyuda,'Permite consultar las Tarifas')
	    AADD(aAyuda,'Permite consultar las Vehiculos de Mensualidades')
	    AADD(aAyuda,'Permite consultar la Caja')
	    AADD(aAyuda,'Permite consultar las Personas')
	    AADD(aAyuda,'Permite consultar las Empresas')

       CASE nNroOpc == 3

	    aMenus := {}
	    AADD(aMenus,'1<CONSULTAS>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite realizar las Consultas')

       CASE nNroOpc == 4

	    aMenus := {}
	    AADD(aMenus,'1<INFOMRES>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite imprimir los Informes')

       CASE nNroOpc == 5

	    aMenus := {}
	    AADD(aMenus,'1<INFOMRES>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite imprimir los Informes')

       CASE nNroOpc == 6

	    aMenus := {}
	    AADD(aMenus,'1<INFOMRES>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite imprimir los Informes')

       CASE nNroOpc == 7

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubMenus(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		  cNomSec,cCodEmp,nOpcion,nOpcPal,nFilPal,aColSup,;
		  cNomUsr,cDerech,cAnoUsr,nColAno,cPatDat,cPatSys,;
		  cPatSis,cSavPan,cMaeAlu,cMaeAct,cJorTxt,cVerSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa Principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cCodEmp			            // C¢digo de la Empresa
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       nFilPal                              // Fila Inferior Men£ principal
       aColSup                              // Columnas para los sub_men£s
       cNomUsr                              // Nombre del Usuario
       cDerech                              // Derechos en el sistema
       cAnoUsr				    // A¤o del Sistema
       nColAno                              // Columna A¤o del sistema
       cPatDat                              // Path datos del Sistema
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cVerSis	                            // Versi¢n del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

       LOCAL lSiMenu := .T.                 //.T.Opci¢n principal con SubMen£
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opci¢n
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones

       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£
       LOCAL nFilInf := 0                   // Fila Inferior del Sub_men£
       LOCAL nColInf := 0                   // Columna Inferior del Sub_men£
       LOCAL       i := 0                   // Contador
       LOCAL cOrden  := ''                  // Orden para Ejecutar
       MEMVA xClrSys			    // Color del Sistema

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESARROLLO DEL PRIMER NIVEL
       DO WHILE .T.

**********LECTURA DE PATHS
	    PathPakAno(lShared,cPatSis(cPatDat,cPatSys,cPatSis),;
		       cAnoUsr,@PathUno,@PathDos,@PathTre,@PathCua,;
		       nModCry,.F.)
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
*--------------FIN CAMBIA EL A¥O DEL SISTEMA

	       nNroOpc := nMenu(aMenu,aHelp,nFilSup,nColSup,NIL,NIL,;
				nNroOpc,NIL,;
				IF(!EMPTY(xClrSys),xClrSys[3],''))


	       SETKEY(K_F2,NIL)
	       lSiMenu := .T.

	    ENDIF

	    IF nNroOpc == 0
	       EXIT
	    ENDIF
	    nNroOpc := VAL(SUBS(aDeMenu[nNroOpc],1,1))
	    cSavLin := SAVESCREEN(0,0,02,79)
	    LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
**********FIN EJECUCION DE LOS SUBMENUS

**********VALIDACION DE LA VERSION
	    IF 'B' $ cVerSis
	       cError('VERSION BETA:'+cVerSis,'PROGRAMA SOLO PARA PRUEBAS',;
		      'Se debe autorizar la versi¢n Oficial')
	    ENDIF
**********FIN VALIDACION DE LA VERSION

**********ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL
	    nFilInf := nFilSup + LEN(aMenu) + 1
	    nColInf := aColSup[nOpcion]

	    DO CASE
	    CASE nOpcPal == 1

		 DO CASE
		 CASE nNroOpc == 1
		      Pak_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Registro del parqueadero

		 CASE nNroOpc == 2
		      Pak_102(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Pago de Mensualidades

		 CASE nNroOpc == 3
		 ENDCASE

	    CASE nOpcPal == 2

		 DO CASE
		 CASE nNroOpc == 1
		      Pak_201(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta del Registro

		 CASE nNroOpc == 2
		      Pak_202(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta de Categorias

		 CASE nNroOpc == 3
		      Pak_203(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta las Tarifas

		 CASE nNroOpc == 4
		      Pak_204(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta de Vehiculos

		 CASE nNroOpc == 5
		      Pak_205(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta de la Caja

		 CASE nNroOpc == 6
		      Pak_206(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta las Personas

		 CASE nNroOpc == 7
		      Pak_207(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta las Empresas

		 ENDCASE

	    CASE nOpcPal == 3
	    CASE nOpcPal == 4
	    CASE nOpcPal == 5
	    CASE nOpcPal == 6

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

		 CASE nNroOpc == 3
		      Indexar(lShared,nModCry,cAnoUsr,cPatDat,cPatSys,cPatSis)
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
		      Pak_707(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
		     *Mantenimiento archivos del sistema

		 CASE nNroOpc == 8
		      Pak_708(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			      cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			      nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
			      cPatSis,cMaeAlu,cMaeAct,cJorTxt)
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:35 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
		    PathClr,FileClr,PathSis,fSimPak)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path General del sistema
       fSimPak				    // Configuraci¢n del Sistema */
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
       CASE nCd(PathSis) == 0
	    nCd(PathAct)

       CASE nCd(PathSis) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathSis)
	    QUIT

       CASE nCd(PathSis) == -3
	    DIRMAKE(PathSis)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DE DIRECTORIO BASES

*>>>>VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR
       IF !FILE(PathSis+'\'+fSimPak)
	  RecuDbfPak(lShared,nModCry,PathSis,fSimPak)
       ENDIF
       IF !FILE(PathClr+'\'+FileClr)
	  RecuDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrPak(lShared,nModCry,PathSis,fSimPak)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrClr(lShared,nModCry,PathClr,FileClr)
     *ÀActualizaci¢n de la Configuraci¢n del Colo
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysPak(lShared,nModCry)

       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR

/*************************************************************************
* TITULO ..: ARCHIVOS DEL SISTEMA                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 09:30 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Determina los archivos del Sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DbfSysPak(cPatDat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPatDat                              // @Path para Datos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE ARCHIVOS
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL     i,j := 0                   // Contadores
       LOCAL aRegIni := {}                  // Registro Inicial
       LOCAL aCamGen := {}                  // Campos Generales
       LOCAL aCamReg := {}                  // Campos del Registro
       LOCAL cCampo  := ''                  // Nombre del Campo
       LOCAL nModCry := 0                   // Modo de Protecci¢n
*>>>>DECLARACION DE ARCHIVOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FileDbf,'FSY',NIL,lSiRed,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVOS')
	  CloseDbf('FSY')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS DE DECISION
       IF FSY->(RECCOUNT()) # 0
	  CloseDbf('FSY')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CAMPOS GENERALES
       aRegIni := {}

       aCamGen := {}
       AADD(aCamGen,{'FSY->cNomUsrFsy','sysinit'})      // Nombre del Usuario
       AADD(aCamGen,{'FSY->dFecUsrFsy',DATE()})         // Fecha del Usuario
       AADD(aCamGen,{'FSY->cHorUsrFsy',TIME()})         // Hora del Usuario
*>>>>FIN CAMPOS GENERALES

*>>>>ARCHIVO DE ERRORES
       aCamReg := {}

       aCamReg := ACLONE(aCamGen)
       AADD(aCamReg,{'FSY->fArchvo',fErrSys}) // Nombre del Archivo
       AADD(aCamReg,{'FSY->PathArc',PathSis}) // Path del Archivo
       AADD(aCamReg,{'FSY->cNalias','ERR'})   // Alias del Archivo
       AADD(aCamReg,{'FSY->lHayNtx',.F.})     // .T. Hay archivo Indice.
       AADD(aCamReg,{'FSY->nCodigoFsy',1})    // C¢digo del Registro

       AADD(aRegIni,aCamReg)
*>>>>FIN ARCHIVO DE ERRORES

*>>>>ARCHIVO DE IMPRESORAS
       aCamReg := {}

       aCamReg := ACLONE(aCamGen)
       AADD(aCamReg,{'FSY->fArchvo',FilePrn}) // Nombre del Archivo
       AADD(aCamReg,{'FSY->PathArc',PathSis}) // Path del Archivo
       AADD(aCamReg,{'FSY->cNalias','PRN'})   // Alias del Archivo
       AADD(aCamReg,{'FSY->lHayNtx',.F.})     // .T. Hay archivo Indice.
       AADD(aCamReg,{'FSY->nCodigoFsy',2})    // C¢digo del Registro

       AADD(aRegIni,aCamReg)
*>>>>FIN ARCHIVO DE IMPRESORAS

*>>>>ARCHIVO CONFIGURACION DEL COLOR
       aCamReg := {}

       aCamReg := ACLONE(aCamGen)
       AADD(aCamReg,{'FSY->fArchvo',FileClr}) // Nombre del Archivo
       AADD(aCamReg,{'FSY->PathArc',PathSis}) // Path del Archivo
       AADD(aCamReg,{'FSY->cNalias','PRN'})   // Alias del Archivo
       AADD(aCamReg,{'FSY->lHayNtx',.F.})     // .T. Hay archivo Indice.
       AADD(aCamReg,{'FSY->nCodigoFsy',3})    // C¢digo del Registro

       AADD(aRegIni,aCamReg)
*>>>>FIN ARCHIVO CONFIGURACION DEL COLOR

*>>>>ARCHIVO DE CONFIGURACION DEL SISTEMA
       aCamReg := {}

       aCamReg := ACLONE(aCamGen)
       AADD(aCamReg,{'FSY->fArchvo',fSimPak}) // Nombre del Archivo
       AADD(aCamReg,{'FSY->PathArc',PathSis}) // Path del Archivo
       AADD(aCamReg,{'FSY->cNalias','PAK'})   // Alias del Archivo
       AADD(aCamReg,{'FSY->lHayNtx',.F.})     // .T. Hay archivo Indice.
       AADD(aCamReg,{'FSY->nCodigoFsy',4})    // C¢digo del Registro

       AADD(aRegIni,aCamReg)
*>>>>FIN ARCHIVO DE CONFIGURACION DEL SISTEMA

*>>>>ARCHIVO DEL REGISTRO
       aCamReg := {}

       aCamReg := ACLONE(aCamGen)
       AADD(aCamReg,{'FSY->fArchvo',FileReg}) // Nombre del Archivo
       AADD(aCamReg,{'FSY->PathArc',PathSis(cPatDat,PathSis)}) // Path del Archivo
       AADD(aCamReg,{'FSY->cNalias','REG'})   // Alias del Archivo
       AADD(aCamReg,{'FSY->lHayNtx',.F.})     // .T. Hay archivo Indice.
       AADD(aCamReg,{'FSY->nCodigoFsy',5})    // C¢digo del Registro

       AADD(aRegIni,aCamReg)
*>>>>FIN ARCHIVO REGISTRO

*>>>>GRABACION DE LOS REGISTROS
       FOR i := 1 TO LEN(aRegIni)

	   IF FSY->(lRegLock(lSiRed,.T.))
	      FOR j := 1 TO LEN(aRegIni[i])
		  cCampo := aRegIni[i][j][1]
		  REPL &cCampo WITH aRegIni[i][j][2]
		  FSY->(DBCOMMIT())
	      ENDFOR
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	   ENDIF
	   IF lSiRed
	      FSY->(DBUNLOCK())
	   ENDIF

       ENDFOR
       CloseDbf('FSY')
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

/*************************************************************************
* TITULO ..: ESTRUCTURAS DE LOS ARCHIVOS DEL SISTEMA                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Determina los archivos del Sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DbfStrPak(cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     cAnoUsr                              // A¤o del Usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE ARCHIVOS
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL     i,j := 0                   // Contadores
       LOCAL aRegIni := {}                  // Registro Inicial
       LOCAL aCamGen := {}                  // Campos Generales
       LOCAL aCamReg := {}                  // Campos del Registro
       LOCAL cCampo  := ''                  // Nombre del Campo
       LOCAL xConten := NIL                 // Contenido del Campo
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cTitArc := ''                  // T¡tulo del Archivo
*>>>>DECLARACION DE ARCHIVOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FileStr,'STR',NIL,lSiRed,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVOS')
	  CloseDbf('STR')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS DE DECISION
       IF STR->(RECCOUNT()) # 0
	  CloseDbf('STR')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CAMPOS GENERALES
       aRegIni := {}

       aCamGen := {}
       AADD(aCamGen,{'STR->cNomUsrStr','sysinit'})      // Nombre del Usuario
       AADD(aCamGen,{'STR->dFecUsrStr',DATE()})         // Fecha del Usuario
       AADD(aCamGen,{'STR->cHorUsrStr',TIME()})         // Hora del Usuario
*>>>>FIN CAMPOS GENERALES

*>>>>ESTRUCTURAS DE LOS ARCHIVOS
/*
       cTitArc := 'CATEGORIAS'
       StrPakCat(FileCat,cTitArc,aCamGen,@aRegIni)
     *ÀTabla. Categorias

       cTitArc := 'TARIFAS'
       StrPakTar(FileTar,cTitArc,aCamGen,@aRegIni)
     *ÀTabla. Tarifas
*/

       cTitArc := 'REGISTRO'
       StrDbfReg(FileReg,cTitArc,aCamGen,@aRegIni)
     *ÀTabla. Registro

/*
       cTitArc := 'VEHICULOS'
       StrPakVeh(FileVeh,cTitArc,aCamGen,@aRegIni)
     *ÀTabla. Vehiculos

       cTitArc := 'CAJA'
       StrPakCaj(FileCaj,cTitArc,aCamGen,@aRegIni)
     *ÀTabla. Cajas

       cTitArc := 'RETIROS'
       StrPakRca(FileRca,cTitArc,aCamGen,@aRegIni)
     *ÀTabla. Retiros de Caja
*/
*>>>>FIN ESTRUCTURAS DE LOS ARCHIVOS

*>>>>GRABACION DE LOS REGISTROS
       FOR i := 1 TO LEN(aRegIni)

	   IF STR->(lRegLock(lSiRed,.T.))
	      FOR j := 1 TO LEN(aRegIni[i])
		  cCampo  := aRegIni[i][j][1]
		  xConten := aRegIni[i][j][2]
		  REPL &cCampo WITH xConten
		  STR->(DBCOMMIT())
	      ENDFOR
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	   ENDIF
	   IF lSiRed
	      STR->(DBUNLOCK())
	   ENDIF

       ENDFOR
       CloseDbf('STR')
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS