/*               	  SISTEMA CARTERA ACADEMICA
		     BIBLIOTECAS DE FUNCIONES GENERALES

REQUERIMIENTOS:

- Compilar: clipper MatriCar /w/m/b

OBJETIVOS:

- Funciones aplicadas para los procesos que las requieran

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
*>>>>FIN DECLARACION DE CONSTANTES

/*************************************************************************
* TITULO DE LA FUNCION..: INICIALIZACION PARAMETROS DE LA APLICACION     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 12:23 PM   DIC 27/95 MIE

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
* TITULO DE LA FUNCION..: CREACION DE LOS ARCHIVOS DEL SISTEMAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 05:15 PM   MAY 27/95 MIE

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

FUNCTION RevisarDbf(aP1,cSavPan,cModem,cEmpCob,cSerFac,nMesVal)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1				    // Parametros del Sistema
       cSavPan                              // Salvar Pantalla
       cModem                               // @Banco para la Gerencia Electronica
       cEmpCob                              // @Empresa de Cobro de la Cartera
       cSerFac                              // @Servicio Facturado
       nMesVal                              // @Mes Conciliado con la Contabilidad */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CART.PRG"              // Archivos del Sistema

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL cPatFil := ''                  // Path del archivo
       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL PathAct := ''                  // Path Actual

       LOCAL bInfSys := NIL                 // Block Informes del Sistema

       LOCAL PathWww := ''		    // Path del Sitio

       LOCAL       i := 0                   // Contador
       LOCAL lPrnArc := .F.                 // .T. Imprimir en Archivo
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL lndexar := .F.                 // .T. Indexar Archivos
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

/*
       LOCAL FileMvt := 'MOVICONT'+ExtFile
       LOCAL FileCtt := 'CUENTAT'+ExtFile
       LOCAL FileCnc := 'CONCILIA'+ExtFile
*/
       FileMvt := 'MOVICONT'+ExtFile
       FileCtt := 'CUENTAT'+ExtFile
       FileCnc := 'CONCILIA'+ExtFile
*>>>>FIN DECLARACION PARAMETROS GENERALES

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

       Mdir(cPatSis+'\MOVIM',PathAct)
     *ÀDirectorio de movimientos.

       Mdir(cPatSis+'\RECIBOS',PathAct)
     *ÀDirectorio de movimientos.

       Mdir(PathPrn,PathAct)
     *ÀPrinter

       Mdir(PathDoc,PathAct)
     *ÀMis Documentos

       Mdir(PathWeb+'\IMG',PathAct)
     *ÀSimaWeb. General
*>>>>FIN DIRECTORIOS DEL SISTEMA

*>>>>SITIOS DEL SISTEMA
       PathWww := xParams(aP1,'PathW01')

       Mdir(PathWww+'\IMG',PathAct)
     *ÀSitio para la facturaci¢n

       InfPrnXsl(PathWww+'\IMG')
     *ÀArchivo XSL informes.

       FactAnoHtm(cNomEmp,cAnoUsr,PathWww)
     *ÀEstructura del Sitio
*>>>>FIN SITIOS DEL SISTEMA

*>>>>LECTURA DE PATHS
       IF !FILE(cPatSis+'\'+fCarAno+cAnoUsr+ExtFile)
	  CreaCarAno(lShared,nModCry,cPatSis,fCarAno+cAnoUsr+ExtFile)
       ENDIF

       nActStrAno(lShared,nModCry,cPatSis,fCarAno+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Configuraci¢n del A¤o.

       IF FILE(cPatSis+'\'+fCarAno+cAnoUsr+ExtFile)
	  PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		     @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>RECUPERACION DE ESTRUCTURAS GENERALES DEL SISTEMA
       IF !EMPTY(PathUno)

	  IF !FILE(PathUno+'\'+PathSis+'\'+FileRec)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfRec(lShared,nModCry,PathUno+'\'+PathSis,FileRec)
	     lndexar := .T.
	  ENDIF

	  IF !FILE(PathUno+'\'+PathSis+'\'+FilePer)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfPer(lShared,nModCry,PathUno+'\'+PathSis,FilePer)
	     lndexar := .T.
	  ENDIF

	  IF !FILE(PathUno+'\'+PathSis+'\'+fSimaCo)
	     RecuSimCon(lShared,PathUno+'\'+PathSis,fSimaCo)
	  ELSE
	     nActStrCon(lShared,PathUno+'\'+PathSis,fSimaCo)
	  ENDIF
	*ÀConfiguraci¢n General de la Contabilidad

       ENDIF
*>>>>FIN RECUPERACION DE ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       bInfSys := {||CarInfSys(lShared,cNomUsr,cCodSui)}
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+fErrSys) .AND.;
	    !FILE(PathSis+'\'+fSimCar) .AND.;
	    !FILE(PathSis+'\'+FileClr) .AND.;
	    !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis+'\'+FileInf) .AND.;
	    !FILE(PathSis+'\'+FileIso)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,cPatSis,cAnoUsr,bInfSys)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+fSimCar)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCar(lShared,nModCry,PathSis,fSimCar)
	      ENDIF

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
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(cPatSis+'\'+fCarAno+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FileBan)                 .AND.;
	    !FILE(cPatSis+'\'+FileCon)                 .AND.;
	    !FILE(cPatSis+'\'+FileTar)                 .AND.;
	    !FILE(cPatSis+'\'+FileDes)                 .AND.;
	    !FILE(cPatSis+'\'+FilePuc)                 .AND.;
	    !FILE(cPatSis+'\'+FileRut)                 .AND.;
	    !FILE(cPatSis+'\'+FileCoE)                 .AND.;
	    !FILE(cPatSis+'\'+FilePaC)                 .AND.;
	    !FILE(cPatSis+'\'+FileURu)                 .AND.;
	    !FILE(cPatSis+'\'+FileCvn)                 .AND.;
	    !FILE(cPatSis+'\'+FileMvt)                 .AND.;
	    !FILE(cPatSis+'\'+FileCtt)                 .AND.;
	    !FILE(cPatSis+'\'+FileCnc)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,cMaeAlu)

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL SISTEMA
	      IF !FILE(cPatSis+'\'+fCarAno+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuCarAno(lShared,nModCry,cPatSis,;
			    fCarAno+cAnoUsr+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileBan)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfBan(lShared,nModCry,cPatSis,FileBan)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCon)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCon(lShared,nModCry,cPatSis,FileCon)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileTar)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTar(lShared,nModCry,cPatSis,FileTar)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileDes)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfDes(lShared,nModCry,cPatSis,FileDes)
		 lndexar := .T.
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCmv)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCmv(lShared,nModCry,cPatSis,FileCmv)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileFpg)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfFpg(lShared,nModCry,cPatSis,FileFpg)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FilePuc)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPuc(lShared,nModCry,cPatSis,FilePuc)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileRut)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfRut(lShared,nModCry,cPatSis,FileRut)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileFia)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfFia(lShared,nModCry,cPatSis,FileFia)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCoE)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCoE(lShared,nModCry,cPatSis,FileCoE)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FilePaC)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPaC(lShared,nModCry,cPatSis,FilePaC)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileURu)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfURu(lShared,nModCry,cPatSis,FileURu)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCvn)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCvn(lShared,nModCry,cPatSis,FileCvn)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileMvt)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfMvt(lShared,nModCry,cPatSis,FileMvt)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCtt)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCtTt(lShared,nModCry,cPatSis,FileCtt)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCnc)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCnc(lShared,nModCry,cPatSis,FileCnc)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS DEL SISTEMA

       ENDCASE
*>>>>FIN CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cPatFil := cIntUno
      *Escoge el path de integraci¢n o el del sistema
*>>>>FIN LECTURA DE PATHS

*>>>>RECUPERACION DE ESTRUCTURAS COMPARTIDAS
       IF !FILE(cIntUno+'\'+;
		FileGru+'POS'+cAnoSis+ExtFile)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  RecuDbfGru(lShared,cIntUno,;
		     FileGru+'POS'+cAnoSis+ExtFile)
       ENDIF
*>>>>FIN RECUPERACION DE ESTRUCTURAS COMPARTIDAS

*>>>>CREACION INDICES DEL SISTEMA
       IF (!FILE(cPatFil+'\JAR\'+fNtxJar+cAnoSis+cExtNtx);
			       .AND. 'JAR' $ cMaeAlu) .OR.;
	  (!FILE(cPatFil+'\JAR\'+Ntx1Jar+cAnoSis+cExtNtx);
			       .AND. 'JAR' $ cMaeAlu) .OR.;
	  (!FILE(cPatFil+'\JAR\'+Ntx2Jar+cAnoSis+cExtNtx);
			       .AND. 'JAR' $ cMaeAlu) .OR.;
	  (!FILE(cPatFil+'\PRI\'+fNtxPri+cAnoSis+cExtNtx);
			       .AND. 'PRI' $ cMaeAlu) .OR.;
	  (!FILE(cPatFil+'\PRI\'+Ntx1Pri+cAnoSis+cExtNtx);
			       .AND. 'PRI' $ cMaeAlu) .OR.;
	  (!FILE(cPatFil+'\PRI\'+Ntx2Pri+cAnoSis+cExtNtx);
			       .AND. 'PRI' $ cMaeAlu) .OR.;
	  (!FILE(cPatFil+'\BTO\'+fNtxBto+cAnoSis+cExtNtx);
			       .AND. 'BTO' $ cMaeAlu) .OR.;
	  (!FILE(cPatFil+'\BTO\'+Ntx1Bto+cAnoSis+cExtNtx);
			       .AND. 'BTO' $ cMaeAlu) .OR.;
	  (!FILE(cPatFil+'\BTO\'+Ntx2Bto+cAnoSis+cExtNtx);
			       .AND. 'BTO' $ cMaeAlu) .OR.;
	  !FILE(cPatSis+'\'+fNtxDes) .OR.;
	  !FILE(PathUno+'\'+PathSis+'\'+fNtxRec) .OR.;
	  !FILE(PathUno+'\'+PathSis+'\'+fNtxPer) .OR.;
	  !FILE(PathUno+'\'+PathSis+'\'+Ntx1Per)

	  lndexar := .T.

       ENDIF
       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CREACION INDICES DEL SISTEMA

*>>>>ACTUALIZACION ESTRUCTURAS GENERALES. COMPARTIDAS
       SET EXACT      ON                    // Busqueda Exacta

       nActStrPer(lShared,nModCry,PathUno+'\'+PathSis,FilePer)
     *ÀActualizaci¢n archivos de personas

       IF nActStrRec(lShared,nModCry,PathUno+'\'+PathSis,FileRec) == 0
	  lndexar := .T.
       ENDIF
*>>>>FIN ACTUALIZACION ESTRUCTURAS GENERALES. COMPARTIDAS

*>>>>ACTUALIZACION DE ESTRUCTURAS GENERALES
       nActStrCar(lShared,nModCry,PathSis,fSimCar)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrErr(lShared,nModCry,PathSis,fErrSys)
     *ÀActualizaci¢n de los Errores del Sistema

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActStrInf(lShared,nModCry,PathSis,FileInf)
     *ÀActualizacion. Informes del sistema

       nActStrIso(lShared,nModCry,PathSis,FileIso)
     *ÀActualizacion de Archios de documentos a imprimir
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS GENERALES

*>>>>ACTUALIZACION DE ESTRUCTURAS DEL A¥O
       nActStrAno(lShared,nModCry,cPatSis,fCarAno+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Configuraci¢n del A¤o.

       nActStrBan(lShared,nModCry,cPatSis,FileBan)
     *ÀActualiaci¢n de Bancos

       IF nActStrDes(lShared,nModCry,cPatSis,FileDes) == 0
	  lndexar := .T.
       ENDIF
     *ÀActualizaci¢n de Descuentos

       nActDbfCon(lShared,nModCry,cPatSis,FileCon)
       nActDbfTar(lShared,nModCry,cPatSis,FileTar)
       nActStrCmv(lShared,nModCry,cPatSis,FileCmv)
       nActStrFpg(lShared,nModCry,cPatSis,FileFpg)
       nActStrPuc(lShared,nModCry,cPatSis,FilePuc)
       nActStrRut(lShared,nModCry,cPatSis,FileRut)
       nActStrFia(lShared,nModCry,cPatSis,FileFia)
       nActStrCoE(lShared,nModCry,cPatSis,FileCoE)
       nActStrPaC(lShared,nModCry,cPatSis,FilePaC)
       nActStrURu(lShared,nModCry,cPatSis,FileURu)
       nActStrCvn(lShared,nModCry,cPatSis,FileCvn)
       nActStrMvt(lShared,nModCry,cPatSis,FileMvt)
       nActStrCnc(lShared,nModCry,cPatSis,FileCnc)

       SET EXACT      OFF                   // Busqueda no exacta
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS DEL A¥O

*>>>>ACTUALIZACION DE CONTABILIDAD
       nActStrGru(lShared,cIntUno,FileGru+'POS'+cAnoSis+ExtFile)

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	   nActStrGru(lShared,cIntUno+'\'+cMaeAct,;
			      FileGru+cMaeAct+cAnoSis+ExtFile)
       NEXT

       GruposAno(lShared,cIntUno,cPatSis,cAnoUsr,cMaeAlu)
*>>>>FIN ACTUALIZACION DE CONTABILIDAD

*>>>>INDEXAR LOS ARCHIVOS
       IF lndexar
	  Indexar(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu)
       ENDIF
*>>>>FIN INDEXAR LOS ARCHIVOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnArc := .F.
       IF !lUseDbf(.T.,PathSis+'\'+fSimCar,'CAR',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry)
	  CloseDbf('CAR')
	  CloseDbf('CAA')
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O DEL SISTEMA')

       CASE EMPTY(CAR->cCodFacCar)
	    cError('NO SE HA CONFIRGURADO EL CODIGO DEL SERVICIO FACTURADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       lPrnArc := CAR->lPrnArcCar
       cModem  := CAR->cModemCar
       cEmpCob := CAR->cEmpCobCar
       cSerFac := ALLTRIM(CAR->cSerFacCar)+':'+CAR->cCodFacCar
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF lPrnArc
	  SET PRINTER TO SIMATEMP              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF

       CloseDbf('CAR')
       CloseDbf('CAA')
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION ARCHIVOS GENERALES DEL SISTEMA        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 30/96 LUN A
       Colombia, Bucaramanga        INICIO: 11:05 AM   SEP 30/96 LUN

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
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

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

       Termometro(70)
       CreaDbfInf(lShared,nModCry,PathSis,FileInf,bInfSys)

       Termometro(80)
       CreaDbfIso(lShared,nModCry,PathSis,FileIso)

       Termometro(100)
       CreaDbfCar(lShared,nModCry,PathSis,fSimCar)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LOS ARCHIVOS DEL SISTEMAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 30/96 LUN A
       Colombia, Bucaramanga        INICIO: 11:05 AM   SEP 30/96 LUN

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
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CART.PRG"              // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
/*
       LOCAL FileMvt := 'MOVICONT'+ExtFile
       LOCAL FileCtt := 'CUENTAT'+ExtFile
       LOCAL FileCnc := 'CONCILIA'+ExtFile
*/
       FileMvt := 'MOVICONT'+ExtFile
       FileCtt := 'CUENTAT'+ExtFile
       FileCnc := 'CONCILIA'+ExtFile
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE  ESTRUCTURAS DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO LOS ARCHIVOS DEL SISTEMA")

       Termometro(07)
       CreaCarAno(lShared,nModCry,cPatSis,fCarAno+cAnoUsr+ExtFile)

       Termometro(14)
       CreaDbfBan(lShared,nModCry,cPatSis,FileBan)

       Termometro(21)
       CreaDbfCon(lShared,nModCry,cPatSis,FileCon)

       Termometro(28)
       CreaDbfTar(lShared,nModCry,cPatSis,FileTar)

       Termometro(35)
       CreaDbfDes(lShared,nModCry,cPatSis,FileDes)

       Termometro(42)
       CreaDbfCmv(lShared,nModCry,cPatSis,FileCmv)

       Termometro(49)
       CreaDbfFpg(lShared,nModCry,cPatSis,FileFpg)

       Termometro(56)
       CreaDbfPuc(lShared,nModCry,cPatSis,FilePuc)

       Termometro(63)
       CreaDbfRut(lShared,nModCry,cPatSis,FileRut)

       Termometro(70)
       CreaDbfFia(lShared,nModCry,cPatSis,FileFia)

       Termometro(77)
       CreaDbfCoE(lShared,nModCry,cPatSis,FileCoE)

       Termometro(84)
       CreaDbfPaC(lShared,nModCry,cPatSis,FilePaC)

       Termometro(91)
       CreaDbfURu(lShared,nModCry,cPatSis,FileURu)

       Termometro(92)
       CreaDbfCvn(lShared,nModCry,cPatSis,FileCvn)

       CreaDbfMvt(lShared,nModCry,cPatSis,FileMvt)
       Termometro(93)

       CreaDbfCtt(lShared,nModCry,cPatSis,FileCtt)
       Termometro(94)

       CreaDbfCnc(lShared,nModCry,cPatSis,FileCnc)
       Termometro(100)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE  ESTRUCTURAS DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: INDEXAR LOS ARCHIVOS DEL SISTEMA               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 21/94 JUE A
						       DIC 21/94 JUE
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
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema
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
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+;
		       FileRec,'REC',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+;
		       FilePer,'PER',NIL,lShared,nModCry)

	  cError('ABRIENDO ARCHIVOS PARA INDEXAR EN'+cPatSis)
	  CloseDbf('DES',cPatSis+'\'+FileDes,nModCry)
	  CloseDbf('REC',PathUno+'\'+PathSis+'\'+FileRec,nModCry)
	  CloseDbf('PER',PathUno+'\'+PathSis+'\'+FilePer,nModCry)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>CREACION DEL INDICES DEL SISTEMA
       Termometro(0,'INDEXANDO ARCHIVOS DEL SISTEMA')
       Termometro(10)
       SELECT DES
       INDEX ON DES->cCodigoEst+STR(DES->nNroMesDes,2);
	     TO &(cPatSis+'\'+fNtxDes)
       CloseDbf('DES',cPatSis+'\'+FileDes,nModCry)
       Termometro(25)

       SELECT REC
       INDEX ON VAL(REC->cAnoUsrRec)+REC->nNumeroRec;
	     TO &(PathUno+'\'+PathSis+'\'+fNtxRec) DESCENDING
       CloseDbf('REC',PathUno+'\'+PathSis+'\'+FileRec,nModCry)
       Termometro(50)

       SELECT PER
       fNtxTem := PathUno+'\'+PathSis+'\'+fNtxPer
       INDEX ON PER->nIdeCodPer TO &fNtxTem
       Termometro(75)

       fNtxTem := PathUno+'\'+PathSis+'\'+Ntx1Per
       INDEX ON PER->cDocNitPer+PER->cTipNitPer TO &fNtxTem

       CloseDbf('PER',PathUno+'\'+PathSis+'\'+FilePer,nModCry)
       Termometro(100)
*>>>>FIN CREACION DEL INDICES DEL SISTEMA

*>>>>CREACION DE LOS INDICES COMPARTIDOS
       IndexarAlu(lShared,cIntUno,cAnoSis,cMaeAlu)
       CloseAll()
       RETURN NIL
*>>>>FIN CREACION DE LOS INDICES COMPARTIDOS


/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DE LOS MENUS DE LA APLICACION       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 19/94 LUN A
						       DIC 19/94 LUN
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

FUNCTION aMenusCart(nNroOpc,cDerech,aAyudas,cModem,cEmpCob,lvalida)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroOpc			            // N£mero de Opci¢n
       cDerech                              // Derechos a los Menus
       aAyudas                              // @Vector de Ayudas escogidas
       cModem                               // Banco para Gerencia Electr¢nica
       cEmpCob                              // Empresa de Cobro de la Cartera
       lValida                              // .T. Valida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                    // Declaraci¢n de Men£s
       LOCAL aAyuda  := {}                    // Declaraci¢n de Ayudas
       LOCAL aMenuss := {}                    // Men£ escogido
       LOCAL     i,j := 0                     // Contadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENUS
       lValida := IF(lValida==NIL,.F.,lValida)
       DO CASE
       CASE nNroOpc == 0

	    aMenus := {'1FACTURACION',;
		       '2PAGOS',;
		       '3CONSULTAS',;
		       '4INFORMES',;
		       '5ACTUALIZAR',;
		       '6OTROS',;
		       '7UTILIDADES'}

	    aAyuda := {'Imprime los recibos de pago. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Cancela la deuda de los Clientes. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Consulta la Cartera por Pantalla. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Imprime Informes sobre la Cartera. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Ejecuta opciones importantes de la cartera. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite Otros Procesos del Sistema. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite Ejecutar varias utilidades del sistema. '+;
		       '<ESC> TERMINA EL PROGRAMA'}

       CASE nNroOpc == 1  // Facturaci¢n

	    aMenus := {}
	    AADD(aMenus,'1<SOLO UN RECIBO    >')
	    AADD(aMenus,'2<TODOS LOS RECIBOS >')
	    AADD(aMenus,'3<POR ADELANTADO    >')
	    AADD(aMenus,'4<FACTURAR ABONOS   >')
	    AADD(aMenus,'5<DESCONTAR ABONOS  >')
	    AADD(aMenus,'6<ELIMINAR RECIBOS  >')
	    AADD(aMenus,'7<ELIMINAR NOVEDADES>')
	    AADD(aMenus,'8<OTRA FACTURACION  >')
	    AADD(aMenus,'9<FACTURAR CONCEPTOS>')

	    aAyuda := {}
	    AADD(aAyuda,'Imprime un recibo de pago.')
	    AADD(aAyuda,'Imprime los recibos por Grupos')
	    AADD(aAyuda,'Imprime Recibos para meses por Adelantado')
	    AADD(aAyuda,'Imprime el recibo para realizar un abono  al saldo')
	    AADD(aAyuda,'Permite descontar del saldo el abono realizado.')
	    AADD(aAyuda,'Permite eliminar el £ltimo recibo del estudiante especificado')
	    AADD(aAyuda,'Permite Eliminar Abonos,Descuentos,Recargos')
	    AADD(aAyuda,'Permite imprimir recibos por otros conceptos.')
	    AADD(aAyuda,'Permite facturar por conceptos.')


       CASE nNroOpc == 2  // Pagos

	    cModem  := IF(EMPTY(cModem),'PAGOS POR MODEM  ',cModem)

	    aMenus  := {}
	    AADD(aMenus,"1<PAGOS POR ALUMNOS   >")
	    AADD(aMenus,"2<REGISTRAR RECIBOS   >")
	    AADD(aMenus,"3<"+cModem+">")
	    AADD(aMenus,"4<COBROS JURIDICOS    >")
	    AADD(aMenus,"5<INFORMES FACTURACION>")
	    AADD(aMenus,"6<INCONSISTENCIAS     >")
	    AADD(aMenus,"7<CONCILIACION CARTERA>")
	    IF lValida
	       AADD(aMenus,"8<INTERFAZ CONTABLE   >")
	    ENDIF
	    AADD(aMenus,"9<PAGOS EN LINEA      >")

	    aAyuda := {}

	    AADD(aAyuda,'Imprime la relaci¢n de pagos por grupos.')
	    AADD(aAyuda,'Permite indicar la forma de pago de los recibos.')
	    AADD(aAyuda,'Procesa los Movimientos del archivo transferido por Modem')
	    AADD(aAyuda,'Permite el control del cobro de estudiantes en mora.')
	    AADD(aAyuda,'Permite imprimir los diferentes informes de la Facturaci¢n.')
	    AADD(aAyuda,'Permite imprimir las Inconsistencias del Sistema')
	    AADD(aAyuda,'Imprime la Carta de la Conciliaci¢n de la Cartera')
	    IF lValida
	       AADD(aAyuda,'Permite Generar la Interfaz Contable')
	    ENDIF
	    AADD(aAyuda,'Permite generar la facturaci¢n en archivo para los pagos en linea')

       CASE nNroOpc == 3  // Consultas

	    aMenus  := {"1<SITUACION CLIENTE   >",;
			"2<CARTERA ACTUAL      >",;
			"3<CARTERA POR DIAS    >",;
			"4<ESTADO DE CUENTA    >",;
			"5<DEFINIR CONTRATANTES>",;
			"6<CONTABILIDAD        >",;
			"7<SOPORTE DATACREDITO >",;
			"8<FAMILIAS DEL COLEGIO>",;
			"9<VALIDACION CEDULAS  >"}

	    aAyuda := {'Consulta la situaci¢n actual de un Cliente',;
		       'Consulta los Estudiantes Morosos Actuales',;
		       'Consulta la Cartera d¡a por d¡a',;
		       'Imprime el estado de Cuenta del Estudiante',;
		       'Permite Definir los Contrantes',;
		       'Permite confirmar la conciliaci¢n con la contabilidad',;
		       'Imprime el Soporte de Data Cr‚dito',;
		       'Imprime las Familias del Colegio',;
		       'Imprime las C‚dulas a validar'}

       CASE nNroOpc == 4  // Informes

	    aMenus  := {'1<ALUMNOS MOROSOS     >',;
			'2<ALUMNOS BECADOS     >',;
			'3<DIRECTORIO          >',;
			'4<LISTAS GENERALES    >',;
			'5<LISTAS TAMA¥O CARTA >',;
			'6<PAZ Y SALVOS        >',;
			'7<COMPORTAMIENTO PAGOS>',;
			'8<FACTURACION Y PAGOS >'}

	    aAyuda := {'Imprime la relaci¢n de los Estudiantes Morosos. '+;
		       '<ESC> REGRESA',;
		       'Imprime la relaci¢n de los Estudiantes Becados. '+;
		       '<ESC> REGRESA',;
		       'Imprime el Directorio de Alumnos. '+;
		       '<ESC> REGRESA',;
		       'Imprime las listas Generales de Clase. '+;
		       '<ESC> REGRESA',;
		       'Imprime las listas de Generales tama¤o carta. '+;
		       '<ESC> REGRESA',;
		       'Imprime los paz y salvos. '+;
		       '<ESC> REGRESA',;
		       'Imprime los comportamiento de pagos',;
		       'Imprime el total de la facturaci¢n y pagos del estudiante.'}

       CASE nNroOpc == 5  // Actualizar

	    aMenus := {'1<CREAR TARIFAS          >',;
		       '2<CREAR CLIENTES         >',;
		       '3<REINDEXAR              >',;
		       '4<DESCUENTOS/RECARGOS    >',;
		       '5<ALUMNOS BECADOS        >',;
		       '6<ALUMNOS EN CONVENIO    >',;
		       '7<REVISAR ALUMNOS        >',;
		       '8<ACTUALIZAR ALUMNOS     >',;
		       '9<PAZ Y SALVOS ACADEMICOS>'}

	    aAyuda := {'Define la tabla de pagos para los conceptos. '+;
		       '<ESC> REGRESA',;
		       'Crea los clientes de la cartera. '+;
		       '<ESC> REGRESA',;
		       'Reindexa los archivos maestros de la cartera. '+;
		       '<ESC> REGRESA',;
		       'Graba los descuentos o los Recargos. '+;
		       '<ESC> REGRESA',;
		       'Graba los alumnos becados. '+;
		       '<ESC> REGRESA',;
		       'Graba los alumnos en Convenio.',;
		       'Revisa los Estudiante que no figuran en la Cartera',;
		       'Actualiza la informaci¢n de los Estudiante.',;
		       'Permite Grabar los Paz y Salvos Acad‚micos.'}

       CASE nNroOpc == 6
	    aMenus  := {"1<TODOS LOS CONCEPTOS>",;
			"2<RUTAS              >",;
			"3<CAFETERIA          >",;
			"4<OTROS CONCEPTOS    >",;
			"5<CONSIGNACIONES     >"}

	    aAyuda := {'Men£ con los procesos de todos los Conceptos',;
		       'Men£ con los procesos de Rutas',;
		       'Men£ con los procesos de Cafeteria',;
		       'Menu con los procesos de Otros Conceptos',;
		       'Permite imprimir recibos para hacer consignaciones'}

       CASE nNroOpc == 7  // Utilidades

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
* TITULO DE LA FUNCION......: EJECUCION MENUS PRIMER NIVEL               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 19/94 LUN A
						       DIC 19/94 LUN
OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubMenus(aP1,lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,cCodEmp,nOpcion,nOpcPal,nFilPal,;
		  aColSup,cNomUsr,cDerech,cAnoUsr,nColAno,cPatSis,;
		  cSavPan,cMaeAlu,cMaeAct,cJorTxt,cModem,cEmpCob)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       lShared                              // .T. Sistema Compartido
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
       cPatSis                              // Path del sistema
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cModem                               // Banco para la Gerencia Electronica
       cEmpCob                              // Empresa de Cobro de la Cartera */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>PARAMETROS GENERALES
       LOCAL aP2 := {}                      // Parametros Generales
       LOCAL aP3 := {}                      // Parametros Generales
*>>>>FIN PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL lSiMenu := .T.                 //.T.Opci¢n principal con SubMen£
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opci¢n
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones

       LOCAL cNalias := ''                  // Alias del Archivo

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL lValida := .F.                 // .T. Validar

       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£
       LOCAL nFilInf := 0                   // Fila Inferior del Sub_men£
       LOCAL nColInf := 0                   // Columna Inferior del Sub_men£
       LOCAL       i := 0                   // Contador
       LOCAL cOrden  := ''                  // Orden para Ejecutar
       MEMVA xClrSys			    // Color del Sistema

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPrnArc := SCA->lPrnArcCar
       nCodPrn := SCA->nCodigoPrn
       cOpcPrn := SCA->cOpcPrnCar
       lValida := SCA->lValidaCar
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DESARROLLO DEL PRIMER NIVEL
       DO WHILE .T.

**********LECTURA DE PATHS
	    PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		       @PathDos,@PathTre,@PathCua,nModCry,.F.)

	    nParameSet(aP1,'PathUno',PathUno)
	    nParameSet(aP1,'PathDos',PathDos)
	    nParameSet(aP1,'PathTre',PathTre)
	    nParameSet(aP1,'PathCua',PathCua)
**********FIN LECTURA DE PATHS

**********SELECCION DE LOS SUBMENUS
	    @ 100,100 SAY ""
	    CloseAll()
	    lSiMenu := .T.
	    aDeMenu := aMenusCart(nOpcPal,;
				  SUBS(cDerech,nOpcPal*10-9,10),@aHelp,;
				  cModem,cEmpCob,lValida)
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
	    aP3 := {}
	    DO CASE
	    CASE nOpcPal == 1

		 DO CASE
		 CASE nNroOpc == 1
		      Carte_101(aP1,aP2,aP3)
		     *Impresi¢n recibos por alumno

		 CASE nNroOpc == 2
		      Carte_102(aP1,aP2,aP3)
		     *Impresi¢n recibos por grupos

		 CASE nNroOpc == 3
		      Carte_103(aP1,aP2,aP3)
		     *Impresi¢n recibos por adelantado

		 CASE nNroOpc == 4
		      Carte_104(aP1,aP2,aP3)
		     *Facturar abonos

		 CASE nNroOpc == 5
		      Carte_105(aP1,aP2,aP3)
		     *Aplicaci¢n de los abonos

		 CASE nNroOpc == 6
		      Carte_106(aP1,aP2,aP3)
		     *Cancelaci¢n de recibos

		 CASE nNroOpc == 7
		      Carte_107(aP1,aP2,aP3)
		     *Facturaci¢n general

		 CASE nNroOpc == 8
		      Carte_108(aP1,aP2,aP3)
		     *Facturaci¢n general

		 CASE nNroOpc == 9
		      Carte_109(aP1,aP2,aP3)
		     *Facturar Conceptos

		 ENDCASE

	    CASE nOpcPal == 2

		 DO CASE
		 CASE nNroOpc == 1
		      Carte_201(aP1,aP2,aP3)
		     *Impresion pagos por alumnos

		 CASE nNroOpc == 2
		      Carte_202(aP1,aP2,aP3)
		     *Cancelaci¢n recibos de pago

		 CASE nNroOpc == 3

		      Carte_203(aP1,aP2,aP3,cModem)
		     *Pagos por Modem

		 CASE nNroOpc == 4
		      Carte_204(aP1,aP2,aP3)
		     *Cobros jurid¡cos.

		 CASE nNroOpc == 5
		      Carte_205(aP1,aP2,aP3)
		     *Informes Facturaci¢n.

		 CASE nNroOpc == 6
		      Carte_206(aP1,aP2,aP3)
		     *Inconsistencias Facturaci¢n.

		 CASE nNroOpc == 7
		      Carte_207(aP1,aP2,aP3)
		     *Carta de Conciliaci¢n de la Cartera.

		 CASE nNroOpc == 8

		      Carte_208(aP1,aP2,aP3,cEmpCob)
		     *Reporte de Morosos

		 CASE nNroOpc == 9

		      Carte_209(aP1,aP2,aP3)
		     *Pago en Cajeros

		 ENDCASE

	    CASE nOpcPal == 3

		 DO CASE
		 CASE nNroOpc == 1
		      Carte_301(aP1,aP2,aP3)
		     *Consulta situaci¢n del cliente

		 CASE nNroOpc == 2
		      MantenMor(aP1,aP2,aP3,;
				cEmpCob,.T.)
		     *Morosos a la Fecha

		 CASE nNroOpc == 3
		      MantenMor(aP1,aP2,aP3,;
				cEmpCob,'DIA')
		     *Deuda por d¡as

		 CASE nNroOpc == 4
		      Carte_304(aP1,aP2,aP3)
		     *Pagos del Estudiante.

		 CASE nNroOpc == 5
		      Carte_305(aP1,aP2,aP3)
		     *Definir contrantes

		 CASE nNroOpc == 6
		      Carte_306(aP1,aP2,aP3)
		     *Conciliar Contabilidad

		 CASE nNroOpc == 7
		      Carte_307(aP1,aP2,aP3)
		     *Soporte de Fiadores o DataCr‚dito

		 CASE nNroOpc == 8

*=====================AREAS DE TRABAJO
			aArchvo := {}
			AADD(aArchvo,{PathUno+'\'+PathSis+'\'+;
				      FilePer,NIL,'PER'})
			AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+;
				      FileFam,NIL,'FAM'})
			AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
*=====================FIN AREAS DE TRABAJO

*=====================MANTENIMIENTO DEL ARCHIVO
			lModReg := .T.
			lDelReg := .F.
			lInsReg := .T.
			lHaySql := .F.

			MantenFam(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
				  cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
				  aArchvo,lPrnArc,cOpcPrn,nCodPrn,;
				  lModReg,lDelReg,lInsReg,lHaySql,;
				  nFilInf,nColInf,cPatSis,cMaeAlu,;
				  cJorTxt,PathUno)
*=====================FIN MANTENIMIENTO DEL ARCHIVO

		 CASE nNroOpc == 9

		      PrnCedVal(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,;
				cAnoUsr,PathUno+'\'+cPatSis,cMaeAlu,cJorTxt,;
				fSimCar,'Car')


		 ENDCASE

	    CASE nOpcPal == 4

		 DO CASE
		 CASE nNroOpc == 1
		      Carte_401(aP1,aP2,aP3)
		     *Estudiantes Morosos

		 CASE nNroOpc == 2
		      Carte_402(aP1,aP2,aP3)
		     *Estudiantes Becados

		 CASE nNroOpc == 3
		      Carte_403(aP1,aP2,aP3)
		     *Directorio de Estudiantes

		 CASE nNroOpc == 4
		      Carte_404(aP1,aP2,aP3)
		     *Impresion listas de uso general

		 CASE nNroOpc == 5
		      Carte_405(aP1,aP2,aP3)
		     *Impresion listas de uso general. Carta

		 CASE nNroOpc == 6
		      Carte_406(aP1,aP2,aP3)
		     *Impresion de Paz y Salvos

		 CASE nNroOpc == 7
		      Carte_407(aP1,aP2,aP3)
		     *Comportamiento de pagos.

		 CASE nNroOpc == 8
		      Carte_408(aP1,aP2,aP3)
		     *Relaci¢n detallada por Estudiantes

		 CASE nNroOpc == 9
/*
		      Carte_409(aP1,aP2,aP3)
		     *Relaci¢n detallada por Familias
*/

		 ENDCASE

	    CASE nOpcPal == 5

		 DO CASE
		 CASE nNroOpc == 1
		      MantenTar(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Crea la tabla de tarifas

		 CASE nNroOpc == 2
		      Carte_502(aP1,aP2,aP3)
		     *Crea los clientes de la cartera

		 CASE nNroOpc == 3
		      Indexar(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu)
		     *Indexa los archivos del sistema

		 CASE nNroOpc == 4
		      Carte_504(aP1,aP2,aP3)
		     *Menu de Descuentos

		 CASE nNroOpc == 5
		      Carte_505(aP1,aP2,aP3)
		     *Grabaci¢n de los estudiantes becados

		 CASE nNroOpc == 6

*=====================AREAS DE TRABAJO
			aArchvo := {}
			AADD(aArchvo,{cPatSis+'\'+FileCvn,NIL,'CVN'})
			AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
*=====================FIN AREAS DE TRABAJO

*=====================MANTENIMIENTO DEL ARCHIVO
			lModReg := .T.
			lDelReg := .T.
			lInsReg := .T.
			lHaySql := .F.

			MantenCvn(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
				  cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
				  aArchvo,lPrnArc,cOpcPrn,nCodPrn,lModReg,;
				  lDelReg,lInsReg,lHaySql,;
				  PathUno+'\'+cPatSis,cMaeAlu)
*=====================FIN MANTENIMIENTO DEL ARCHIVO

		 CASE nNroOpc == 7
		      Carte_507(aP1,aP2,aP3)
		     *Revisar Estudiantes

		 CASE nNroOpc == 8
		      Carte_508(aP1,aP2,aP3)
		     *Actualizar Estudiantes

		 CASE nNroOpc == 9
		      Carte_509(aP1,aP2,aP3)
		     *Grabaci¢n Paz y Salvos

		 ENDCASE

	    CASE nOpcPal == 6
		 DO CASE
		 CASE nNroOpc == 1
		      Carte_601(aP1,aP2,aP3)
		     *Conceptos Individuales por Estudiantes

		 CASE nNroOpc == 2
		      Carte_602(aP1,aP2,aP3)
		     *Menu de Rutas

		 CASE nNroOpc == 3
		      Carte_603(aP1,aP2,aP3)
		     *Menu de Cafeteria

		 CASE nNroOpc == 4
		      Carte_604(aP1,aP2,aP3)
		     *Impresi¢n de todos los conceptos individuales por Estudiantes

		 CASE nNroOpc == 5
		      Carte_605(aP1,aP2,aP3)
		    *ÀFacturaci¢n - Consignaciones

		 ENDCASE


	    CASE nOpcPal == 7
		 DO CASE
		 CASE nNroOpc == 1
		      MantenUsr(lShared,PathSis,FileAaa,{|nOpcion,aAyudas|;
				aMenusCart(nOpcion,'1111111111',aAyudas,cModem,cEmpCob)},;
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
		      Carte_706(aP1,aP2,aP3)
		     *Actualizar Estructuras

		 CASE nNroOpc == 7
		      Carte_707(aP1,aP2,aP3)
		     *Mantenimiento archivos del sistema

		 CASE nNroOpc == 8
		      Carte_708(aP1,aP2,aP3)
		     *Configuraciones

		 CASE nNroOpc == 9
		      Carte_709(aP1,aP2,aP3)
		     *Utilidades Varios

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
* TITULO..: PARAMETOS GENERALES DEL SISTEMA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 23/2007 JUE A
       Bucaramanga, Colombia        INICIO: 05:30 PM   NOV 23/2007 JUE

OBJETIVOS:

1- Lee los parametros generales del sistema en variables locales.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lParam0104(aParams,;
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
* TITULO DE LA FUNCION..: DETALLES PARA LA FACTURACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/94 SAB A
						       AGO 13/94 SAB
OBJETIVOS:

1- Visualiza los detalles del pago con los cuales se van a facturar los
   recibos.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDetFac(lShared,nFilPal,nColPal,cNomBan,;
		 cCtaBan,nMesIni,nMesFin,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilPal                              // Fila Superior
       nColPal                              // Columna Superior
       cNomBan                              // Nombre del Banco
       cCtaBan                              // N£mero de cuenta del banco
       nMesIni                              // Mes Inicial del Pago
       nMesFin                              // Mes Final del pago
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL       i := 0                   // Contador
       LOCAL lHayErr := .T.                  // .T. Hay Error
       LOCAL lSiorNo := .F.                  // Variable de decisi¢n
       LOCAL cSavPan := ''                   // Salvar Pantalla
       LOCAL cMsgTxt := ''                   // Texto Variable
       LOCAL nNroFil := 0                    // N£mero de la Fila
       LOCAL nNroCol := 0                    // N£mero de la Columna
       LOCAL nColTem := 0                    // Columna Temporal
       LOCAL cNroFac := ''                   // N£mero del Recibo

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cSayTxt := ''                  // Color del Texto fijo
       LOCAL cSayDat := ''                  // Color para los datos
       LOCAL cClrMar := ''                  // Color del Marco y Fondo
       LOCAL cClrTit := ''                  // Color T¡tulo del Marco
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[7],'')),;
	       @cSayTxt,@cSayDat,@cClrMar,@cClrTit)
*>>>>IF ANALISIS DEL COLOR

*>>>>IMPRESION DE LOS TITULOS
       nNroFil := nMarco(nFilPal,'DETALLES DE FACTURACION PARA LA '+;
				 'IMPRESION DE LOS RECIBOS',22,'°',;
				 cClrMar+','+cClrTit)
       nNroCol := nColPal

       cSetColor(cSayTxt)

       cMsgTxt := "FECHA DE PAGO OPORTUNO     :"
       nColTem := nColPal+LEN(cMsgTxt)

       @ nNroFil,nNroCol SAY cMsgTxt
       IF !CAA->lPagExtCaA
	  @ nNroFil,nNroCol+38 SAY 'FECHA PARA EL RECIBO :'
       ENDIF

       @ nNroFil+01,nNroCol SAY "FECHA DE PAGO EXTEMPORANEO :"
       @ nNroFil+02,nNroCol SAY "FECHA DE FACTURACION       :"+;
				IF(SCO->lHayNroCon,;
				   SPACE(11)+'°RECIBO No.','')
       @ nNroFil+04,nNroCol SAY "NOMBRE DEL BANCO DEL PAGO  :"

       @ nNroFil+05,nNroCol SAY IF(CAA->lIntPenCaA,;
				"INTERES PAGO EXTEMPORANEO  :",;
				"RECARGO POR MORA           :")+;
				REPL('°',12)+'INTERES NO PAGO:'

       @ nNroFil+07,nNroCol SAY "MENSAJE PARA LA FACTURACION:"
       @ nNroFil+10,nNroCol SAY "CONCEPTOS DE PENSION"+;
				IF(nMesIni == 0 .OR. nMesFin == 0,'',;
		" PARA LOS MESES DE "+cMes(nMesIni,3)+' A '+cMes(nMesFin,3))
*>>>>FIN IMPRESION DE LOS TITULOS

*>>>>VALIDACION DE LOS DETALLES DE LA FACTURACION
       DO WHILE CAA->dOpoPenCaA == CTOD("00/00/00")
	  cError('NO EXISTE FECHA PARA PAGO OPORTUNO DE LA PENSION')
	  dFecExt(lShared,nNroFil,nColTem,"CAA->dOpoPenCaA")
       ENDDO



       IF !CAA->lPagExtCaA
	  DO WHILE CAA->dFecRecCaA == CTOD("00/00/00")
	     cError('NO EXISTE FECHA PARA EL RECIBO')
	     dFecExt(lShared,nNroFil,nColTem+32,"CAA->dFecRecCaA")
	  ENDDO
       ENDIF

       DO WHILE CAA->dExtPenCaA == CTOD("00/00/00")
	  cError('NO EXISTE FECHA PARA PAGO EXTEMPORANEO DE LA PENSION')
	  dFecExt(lShared,nNroFil+1,nColTem,"CAA->dExtPenCaA")
	  SET COLOR TO
       ENDDO

       IF LEN(ALLTRIM(CAA->cConPenCaA)) == 0
	  IF lPregunta('NO EXISTEN CONCEPTOS GRUPALES A COBRAR. '+;
		       'DESEA GRABARLOS? No Si')
	     GrabarCon(lShared,nNroFil+6,30,nNroFil+11,1,'CAA->cConPenCaA')
	  ENDIF
       ENDIF

       IF SCO->lHayNroCon .AND. lSeekRec(cAnoUsr,SCO->nNroFacCon+1)
	  cError('EL RECIBO No. '+;
		 ALLTRIM(STR(SCO->nNroFacCon+1,9))+' YA FUE IMPRESO')
	  nLeeNroRec(IF(lShared,lShared,!lShared),;
		     nNroFil+2,nColTem+26,cAnoUsr)
       ENDIF
       SET COLOR TO
*>>>>FIN VALIDACION DE LOS DETALLES DE LA FACTURACION

*>>>>IMPRESION DE LOS DETALLES DE LA FACTURACION
       SET COLOR TO I
       cSetColor(cSayDat)
       @ nNroFil,nColTem SAY cFecha(CAA->dOpoPenCaA)
       IF !CAA->lPagExtCaA
	  @ nNroFil,nColTem+32 SAY cFecha(CAA->dFecRecCaA)
       ENDIF

       @ nNroFil+1,nColTem SAY cFecha(CAA->dExtPenCaA)
       @ nNroFil+2,nColTem SAY cFecha(DATE())

       IF SCO->lHayNroCon
	  SET DECIMALS TO 0
	  SET COLOR TO G*
	  cNroFac := STR(SCO->nNroFacCon+1,9)
	  lCorrecion(@cNroFac,.T.)
	  @ nNroFil+2,nColTem+22 SAY SCO->cCodEmpCon+'-'+cNroFac
	  SET COLOR TO
	  SET DECIMALS TO 2
	  SET COLOR TO I
	  cSetColor(cSayDat)
       ENDIF

       @ nNroFil+4,nColTem SAY RTRIM(cNomBan)+;
			   ' CUENTA No. '+RTRIM(cCtaBan)

       @ nNroFil+5,nColTem SAY IF(CAA->lIntPenCaA,;
				  CAA->nIntPenCaA,;
				  CAA->nVlrMorCaA)

       @ nNroFil+5,nColTem+28 SAY CAA->nIntDeuCaA

       IF LEN(RTRIM(CAA->cMensajCaA)) == 80
	  nColTem := 0
       ELSE
	  nColTem := nColPal
       ENDIF
       @ nNroFil+8,nColTem SAY IF(LEN(ALLTRIM(CAA->cMensajCaA)) == 0,;
				  'NO EXISTE MENSAJE',;
				  RTRIM(CAA->cMensajCaA))
*>>>>FIN IMPRESION DE LOS DETALLES DE LA FACTURACION

*>>>>CONSULTA DE LOS CONCEPTOS DE PENSION
       IF !ConsultCon(nNroFil+11,nColPal,CAA->cConPenCaA)
	  lHayErr := .F.
       ENDIF
       RETURN lHayErr
*>>>>FIN CONSULTA DE LOS CONCEPTOS DE PENSION

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIA LOS DETALLES DE LA FACTURACION          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 20/94 MAR A
						       SEP 20/94 MAR
OBJETIVOS:

1- Permite cambiar a trav‚s de un men£ los detalles para la facturaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CamDetFac(lShared,nNroFil,nNroCol,cNomBan,;
		   cCtaBan,nMesIni,nMesFin,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil			            // Fila de impresi¢n
       nNroCol			            // Columna de impresi¢n
       cNomBan                              // Nombre del Banco
       cCtaBan                              // N£mero de cuenta del banco
       nMesIni                              // Mes Inicial para el pago
       nMesFin                              // Mes Final para el pago
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}	            // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nColTem := 0                   // Columna Temporal
       LOCAL dFecSys := CTOD("00/00/00")    // Fecha del sistema

       LOCAL GetList := {}                  // Variable del Sistema
       SET CURSOR ON
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<FECHA PAGO OPO   >')
       AADD(aMenus,'2<FECHA PAGO EXT   >')
       AADD(aMenus,'3<FECHA FACTURACION>')
       AADD(aMenus,'4<CAMBIO DEL BANCO >')
       AADD(aMenus,IF(CAA->lIntPenCaA,;
		   '5<INTERESES        >',;
		   '5<RECARGO POR MORA >'))
       AADD(aMenus,'6<MENSAJE RECIBO   >')
       AADD(aMenus,'7<CONCEPTOS        >')
       IF SCO->lHayNroCon
	  AADD(aMenus,'8<NUMERO DEL RECIBO>')
       ENDIF
       IF !CAA->lPagExtCaA
	  AADD(aMenus,'9<FECHA PARA RECIBO>')
       ENDIF

       AADD(aAyuda,'Cambia la fecha para pago oportuno')
       AADD(aAyuda,'Cambia la fecha para pago extempor neo')
       AADD(aAyuda,'Cambia la fecha de Facturaci¢n')
       AADD(aAyuda,'Cambia el Banco donde se debe pagar')
       AADD(aAyuda,'Cambia '+IF(CAA->lIntPenCaA,;
				'los intereses',;
				'el valor del recargo por mora'))
       AADD(aAyuda,'Cambia el mensaje que aparece en la facturaci¢n')
       AADD(aAyuda,'Cambia los Conceptos de facturaci¢n')
       IF SCO->lHayNroCon
	  AADD(aAyuda,'Cambia el Consecutivo del N£mero del Recibo')
       ENDIF
       IF !CAA->lPagExtCaA
	  AADD(aAyuda,'Cambia la Fecha para el Recibo')
       ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1)

       IF nNroOpc == 0
	  SET CURSOR OFF
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       nColTem := nNroCol+LEN("FECHA DE PAGO OPORTUNO     :")
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroFil += 3
       nNroOpc := VAL(SUBS(aMenus[nNroOpc],1,1))
       DO CASE
       CASE nNroOpc == 1
	    @ nNroFil,nColTem SAY REPL('°',10)
	    dFecExt(lShared,nNroFil,nColTem,"CAA->dOpoPenCaA")
	    @ nNroFil,nColTem SAY REPL('°',10)

       CASE nNroOpc == 2
	    @ nNroFil+1,nColTem SAY REPL('°',10)
	    dFecExt(lShared,nNroFil+1,nColTem,"CAA->dExtPenCaA")
	    @ nNroFil+1,nColTem SAY REPL('°',10)

       CASE nNroOpc == 3
	    @ nNroFil+2,nColTem SAY REPL('°',10)
	    dFecSys := DATE()
	    @ nNroFil+2,nColTem GET dFecSys PICT "@D" ;
				    VALID dFecSys <> CTOD('00/00/00')
	    READ
	    IF ISAT()
	       SETDATE(dFecSys,.T.)
	    ELSE
	       SETDATE(dFecSys)
	    ENDIF
	    @ nNroFil+2,nColTem SAY REPL('°',10)

       CASE nNroOpc == 4
	    @ nNroFil+4,nColTem-11 SAY REPL('°',80)
	    CambiaBan(lShared,nNroFil+4,nColTem-11)
	    IF !lLocCodBan(CAA->cCodigoBan)
	       RETURN NIL
	    ENDIF
	    cNomBan := BAN->cNombreBan
	    cCtaBan := BAN->cNroctaBan

       CASE nNroOpc == 5
	    nLeeIntExt(lShared,nNroFil+5,nColTem,CAA->lIntPenCaA)
	    nLeeIntMor(lShared,nNroFil+5,nColTem+28,CAA->lIntPenCaA)

       CASE nNroOpc == 6
	    cLeeMensaj(lShared,nNroFil+8,1)

       CASE nNroOpc == 7
	    @ nNroFil+11,01 SAY REPL('°',80)
	    GrabarCon(lShared,nNroFil+7,30,nNroFil+11,1,'CAA->cConPenCaA')
	    @ nNroFil+11,01 SAY REPL('°',80)

       CASE nNroOpc == 8 .AND. SCO->lHayNroCon
	    nLeeNroRec(IF(lShared,lShared,!lShared),;
		       nNroFil+2,nColTem+26,cAnoUsr)

       CASE nNroOpc == 9 .AND. !CAA->lPagExtCaA
	    @ nNroFil,nColTem+32 SAY REPL('°',10)
	    dFecExt(lShared,nNroFil,nColTem+32,"CAA->dFecRecCaA")
	    @ nNroFil,nColTem+32 SAY REPL('°',10)

       ENDCASE

       IF nNroOpc # 0
	  cSavLin := SAVESCREEN(22,0,22,79)
	  lDetFac(lShared,nNroFil-3,nNroCol,cNomBan,;
		  cCtaBan,nMesIni,nMesFin,cAnoUsr)
	  RESTSCREEN(22,0,22,79,cSavLin)
       ENDIF

       SET COLOR TO
       SET CURSOR OFF
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO DEL PROGRAMA......: IMPRESION LINEA DE RECIBO                   *
**************************************************************************

OBJETIVOS:

1- Imprime una linea del recibo de pago

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Linea_Recibo(cLinTxt,nNroLin,nNroLen,cTxtRes)

*>>>>DECLARACION DE VARIABLES
/*     cLinTxt                              // L¡nea de Texto
       nNroLin                              // N£mero de l¡neas
       nNroLen                              // Longitud del Recibo
       cTxtRes                              // Texto de Resumen */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LA LINEA
       nNroLin := IF(nNroLin == NIL,1,nNroLin)
       nNroLen := IF(nNroLen == NIL,57,nNroLen)

       @ PROW()+nNroLin,02     SAY cLinTxt
       @ PROW(),nNroLen        SAY cLinTxt
       @ PROW(),(nNroLen*2)-2  SAY cLinTxt
       IF !EMPTY(cTxtRes)
	  @ PROW(),(nNroLen*3)-20 SAY cTxtRes
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LA LINEA

/*************************************************************************
* TITULO DE LA FUNCION..: INFORMACION DEL ESTUDIANTE                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 02/94 VIE A
						       DIC 02/94 VIE
OBJETIVOS:

1)- Visualiza la informaci¢n sobre cualquier estudiante

3)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION InfoAlumno(nFilInf,nColInf,;
		    cCodEst,cApelli,cNomEst,cCodGru,dFecNac,cLugNac,;
		    cDocNit,cLugNit,cDirecc,cBarrio,cTelefn,cNomPad,;
		    cProPad,cEmpPad,cCarPad,cTelPad,cNomMad,cProMad,;
		    cEmpMad,cCarMad,cTelMad,cNomAcu,cTe1Acu,cTe2Acu,;
		    cNomEmp,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilInf                              // Fila de Impresi¢n
       nColInf                              // Columna de Impresi¢n
       cCodEst			            // C¢digo del Alumno
       cApelli                              // Apellido del alumno
       cNomEst			            // Nombre del alumno
       cCodGru                              // C¢digo del grupo
       dFecNac                              // Fecha de nacimiento
       cLugNac                              // Lugar de nacimiento
       cDocNit                              // Documento de identidad
       cLugNit                              // Lugar del documento
       cDirecc                              // Direcci¢n del alumno
       cBarrio                              // Barrio
       cTelefn                              // Telefono de la casa
       cNomPad                              // Nombre del padre
       cProPad                              // Profesi¢n del padre
       cEmpPad                              // Empresa del padre
       cCarPad                              // Cargo del padre
       cTelPad                              // Telefono del padre
       cNomMad                              // Nombre de la madre
       cProMad                              // Profesion de la madre
       cEmpMad                              // Empresa de la madre
       cCarMad                              // Cargo de la madre
       cTelMad                              // Telefono de la madre
       cNomAcu                              // Nombre del acudiente
       cTe1Acu                              // Telefono uno del acudiente
       cTe2Acu                              // Telefono dos del acudiente
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LA LINEA DE ESTADO
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(nFilInf+1,'INFORMACION DEL CANDIDATO AL CUPO',22,'°')
       nNroCol := nColInf
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+cCodEst
       @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+RTRIM(cNomEst)+' '+cApelli
       @ nNroFil,nNroCol+65 SAY 'CURSO : '+cCodGru
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>IMPRSION DE LOS TITULOS
       nNroFil := nFilInf+6
       @nNroFil,nNroCol+00 SAY 'NACIDO EN: '
       @nNroFil++,nNroCol+36 SAY 'FECHA:'

       @nNroFil  ,nNroCol+00 SAY 'DOCUMENTO:'
       @nNroFil++,nNroCol+36 SAY 'DE:'

       @++nNroFil,nNroCol+00 SAY 'DIRECCION:'
       @nNroFil  ,nNroCol+37 SAY 'BARRIO:'
       @nNroFil++,nNroCol+61 SAY 'TELEFONO:'

       @++nNroFil,nNroCol+00 SAY 'PADRE:'
       @nNroFil++,nNroCol+42 SAY 'PROFESION:'
       @nNroFil  ,nNroCol+00 SAY 'EMPRESA:'
       @nNroFil  ,nNroCol+34 SAY 'CARGO:'
       @nNroFil++,nNroCol+61 SAY 'TELEFONO:'

       @++nNroFil,nNroCol+00 SAY 'MADRE:'
       @nNroFil++,nNroCol+42 SAY 'PROFESION:'
       @nNroFil  ,nNroCol+00 SAY 'EMPRESA:'
       @nNroFil  ,nNroCol+34 SAY 'CARGO:'
       @nNroFil++,nNroCol+61 SAY 'TELEFONO:'

       @++nNroFil,nNroCol+00 SAY 'ACUDIENTE:'
       @nNroFil  ,nNroCol+42 SAY 'TEL CASA:'
       @nNroFil  ,nNroCol+61 SAY 'TEL OFIC:'
*>>>>FIN IMPRSION DE LOS TITULOS

*>>>>IMPRESION DE LOS DATOS
       nNroFil := nFilInf+6
       SET COLOR TO I
       @nNroFil  ,nNroCol+10 SAY cLugNac
       @nNroFil++,nNroCol+44 SAY dFecNac

       @nNroFil  ,nNroCol+10 SAY cDocNit
       @nNroFil++,nNroCol+39 SAY cLugNit

       @++nNroFil,nNroCol+10 SAY cDirecc  PICT "@!S25"
       @nNroFil  ,nNroCol+44 SAY cBarrio  PICT "@!"
       @nNroFil++,nNroCol+70 SAY cTelefn

       @++nNroFil,nNroCol+07 SAY cNomPad  PICT "@!S30"
       @nNroFil++,nNroCol+52 SAY cProPad  PICT "@!"
       @nNroFil  ,nNroCol+08 SAY cEmpPad  PICT "@!"
       @nNroFil  ,nNroCol+40 SAY cCarPad  PICT "@!"
       @nNroFil++,nNroCol+70 SAY cTelPad

       @++nNroFil,nNroCol+07 SAY cNomMad  PICT "@!S30"
       @nNroFil++,nNroCol+52 SAY cProMad  PICT "@!"
       @nNroFil  ,nNroCol+08 SAY cEmpMad  PICT "@!"
       @nNroFil  ,nNroCol+40 SAY cCarMad  PICT "@!"
       @nNroFil++,nNroCol+70 SAY cTelMad

       @++nNroFil,nNroCol+10 SAY cNomAcu  PICT "@!S30"
       @nNroFil  ,nNroCol+52 SAY cTe1Acu
       @nNroFil  ,nNroCol+70 SAY cTe2Acu
       SET COLOR TO

       cPausa()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DATOS

/*************************************************************************
* TITULO ..: LECTURA DEL COLOR DEL SISTEMA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 10:40 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
		    PathClr,FileClr,PathSis,fSimCar)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path General del sistema
       fSimCar                              // Configuraci¢n del Sistema */
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
       IF !FILE(PathSis+'\'+fSimCar)
	  RecuDbfCar(lShared,nModCry,PathSis,fSimCar)
       ENDIF
       IF !FILE(PathClr+'\'+FileClr)
	  RecuDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrCar(lShared,nModCry,PathSis,fSimCar)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrClr(lShared,nModCry,PathClr,FileClr)
     *ÀActualizaci¢n de la Configuraci¢n del Colo
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysCar(lShared,nModCry)
       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR

/*************************************************************************
* TITULO ..: INDEX DE LA FACTURACION DEL A¥O EN HTML                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 25/2005 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 25/2005 MIE

OBJETIVOS:

1- Crea el archivo index.html de la facturaci¢n del a¤o.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FactAnoHtm(cNomEmp,cAnoUsr,PathWww)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del Sistema
       PathWww			      // Path del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL       i := 0                   // Contador
       LOCAL PathAct := ''                  // Path Actual
       LOCAL FileHtm := ''                  // Archivo Html
       LOCAL nHanHtm := 0                   // Manejador Archivo Binario
       LOCAL cLinkWw := ''                  // Link del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION O CREACION DEL DIRECTORIO DE LA FACTURACION
       FOR i := 1 TO 12

	   PathAct := cPathAct()
	   Mdir(PathWww+'\FACT'+cMes(i,3),PathAct)

       ENDFOR
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO DE LA FACTURACION

*>>>>VALIDACION DEL ARCHIVO
       FileHtm := PathWww+'\index.html'
       IF FILE(FileHtm)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       IF FCREATE(FileHtm,0) == -1
	   cError(FileHtm,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHanHtm := FOPEN(FileHtm,2)) = -1 .AND. lFHayErr(FileHtm)
	  cError(FileHtm,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>ENCABEZADO DE LA PAGINA
       lSaveTxt('<html>',nHanHtm,FileHtm)
       lSaveTxt('<head>',nHanHtm,FileHtm)
       lSaveTxt('<TITLE>SIMA. FACTURACION DEL A¥O:'+cAnoUsr+'</TITLE>',nHanHtm,FileHtm)
       lSaveTxt('</head>',nHanHtm,FileHtm)
       lSaveTxt('<body background="IMG\fondo.jpg">',nHanHtm,FileHtm)
*>>>>FIN ENCABEZADO DE LA PAGINA

*>>>>CUERPO DE LA PAGINA
       lSaveTxt('<div align="center">',nHanHtm,FileHtm)
       lSaveTxt('<h1>'+cNomEmp+'</h1>',nHanHtm,FileHtm)
       lSaveTxt('<h2>FACTURACION DEL A¥O:'+cAnoUsr+'</h2>',nHanHtm,FileHtm)
       lSaveTxt('</div>',nHanHtm,FileHtm)

       FOR i := 1 TO 12

	   cLinkWw := 'FACT'+UPPER(cMes(i,3))+'\'+;
		      'RSF'+UPPER(cMes(i,3))+cAnoSis+'.XML'

	   lSaveTxt('<p><a href="'+cLinkWw+'">'+;
		    'FACTURACION DE '+cMes(i,3)+;
		    '</a></p>',nHanHtm,FileHtm)
       ENDFOR
*>>>>FIN CUERPO DE LA PAGINA

*>>>>CERRANDO ARCHIVOS
       lSaveTxt('</body>',nHanHtm,FileHtm)
       lSaveTxt('</html>',nHanHtm,FileHtm)

       IF !FCLOSE(nHanHtm) .AND. lFHayErr(FileHtm)
	  cError('ERROR CERRANDO EL ARCHIVO '+FileHtm)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS





