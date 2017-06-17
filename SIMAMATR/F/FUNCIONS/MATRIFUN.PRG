/*                       SIMA - MATRICULA ACADEMICA
		     BIBLIOTECAS DE FUNCIONES GENERALES

REQUERIMIENTOS:

- Compilar: clipper MatriFun /w/m/b

OBJETIVOS:

- Funciones aplicadas para los procesos que las requieran

FUNCIONES:

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
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

FUNCTION IniSistema(nMemMin,nOpeFil)

*>>>>PARAMETROS DE LA FUNCION
/*     nMemMin                              // M¡nimo espacio en disco
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
*      SET PRINTER    TO NELSON             // Archivo salida impresora
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
* TITULO DE LA FUNCION..: CONTROL DE SEGURIDAD DEL SISTEMA               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 12:15 PM   DIC 27/95 MIE

OBJETIVOS:

1- Analiza y controla la seguridad del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION KeyMatri(cNomEmp,cNomSis,lIntUno,cTipSis,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       lIntUno			            // .T. Sistema Integrado
       cTipSis                              // Tipo del sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>ANALISIS PARA EL CONTROL INTERNO DEL PROGRAMA
       DO CASE
       CASE CHECKSUM(cMaeAlu)+4 <> 151152049
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE CHECKSUM(cNomEmp)+4 <> 487023780
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE CHECKSUM(cNomSis)+4 <> 554203849
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE CHECKSUM(cTipSis)+4 <> 554230834 .AND. lIntUno
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE CHECKSUM(cTipSis)+4 <> 604611055 .AND. !lIntUno
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE VOLSERIAL()+24 <> 23
	    BOOTCOLD()
       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS PARA EL CONTROL INTERNO DEL PROGRAMA

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

FUNCTION RevisarDbf(aP1,lShared,nModCry,cCodSui,cNomEmp,cNomSis,;
		    cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,;
		    lIntCua,cSavPan,cMaeAlu,cMaeAct,cIniJor,cSerFac)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1				    // Parametros del Sistema
       nModCry                              // Modo de Protecci¢n
       cCodSui                              // C¢digo del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del usuario
       cAnoUsr			            // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activado
       cIniJor                              // Iniciales de la jornada
       cSerFac                              // @Servicio facturado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL PathUno := xParams(aP1,'PathUno')
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL PathAct := ''                  // Path Actual
       LOCAL lndexar := .F.                 // .T. Indexar Archivos
       LOCAL lHayErr := .T.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL PathWww := ''		    // Path del Sitio

       LOCAL bInfSys := NIL                 // Block Informes del Sistema
       LOCAL nCodXsl := ''                  // C¢digo Xsl de los informes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DIRECTORIOS DEL SISTEMA
       PathAct := cPathAct()

       Mdir(cPatSis,PathAct)
     *ÀDirectorio del A¤o. Ej 2007.diu

       Mdir(PathPrn,PathAct)
     *ÀPrinter

       Mdir(PathDoc,PathAct)
     *ÀMis Documentos

       Mdir(PathWeb+'\img',PathAct)
       Mdir(PathWeb+'\rec',PathAct)
     *ÀSimaWeb. General
*>>>>FIN DIRECTORIOS DEL SISTEMA

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

*>>>>SITIOS DEL SISTEMA
       PathWww := xParams(aP1,'PathW01')
       Mdir(PathWww+'\IMG',PathAct)
     *ÀSitio para la facturaci¢n

       InfPrnXsl(PathWeb+'\rec')
     *ÀArchivo XSL informes.
*>>>>FIN SITIOS DEL SISTEMA

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       bInfSys := {||MtrInfSys(lShared,cNomUsr,cCodSui)}
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis+'\'+fErrSys) .AND.;
	    !FILE(PathSis+'\'+FileInf) .AND.;
	    !FILE(PathSis+'\'+FileIso) .AND.;
	    !FILE(PathSis+'\'+FileMzp) .AND.;
	    !FILE(PathSis+'\OrdMtr01.txt')

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,nModCry,cNomEmp,cNomSis,;
		       cPatSis,cAnoUsr,bInfSys,lIntUno,;
		       lIntDos,lIntTre,lIntCua)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+FilePrn)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPrn(lShared,nModCry,PathSis,FilePrn)
	      ENDIF

	      IF !FILE(PathSis+'\'+fSimMtr)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfMtr(lShared,PathSis,fSimMtr)
	      ENDIF

	      IF !FILE(PathSis+'\'+fErrSys)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuErrSys(lShared,nModCry,PathSis,fErrSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileInf)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfInf(lShared,nModCry,PathSis,FileInf,bInfSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileIso)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfIso(lShared,nModCry,PathSis,FileIso)
	      ENDIF

	      IF !FILE(PathSis+'\OrdMtr01.txt')
		 RESTSCREEN(0,0,24,79,cSavPan)
		 OrdenMtr04(cNomSis,cNomEmp)
	      ENDIF

	      IF !FILE(PathSis+'\OrdMtr99.txt')
		 RESTSCREEN(0,0,24,79,cSavPan)
		 OrdenMtr99(cNomSis,cNomEmp)
	      ENDIF


	      IF !FILE(PathSis+'\'+FileMzp)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfMzp(lShared,nModCry,PathSis,FileMzp)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(cPatSis+'\'+FileAdm+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FileDoc+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FileCon)                 .AND.;
	    !FILE(cPatSis+'\'+FileTar)                 .AND.;
	    !FILE(cPatSis+'\'+FileDes)                 .AND.;
	    !FILE(cPatSis+'\'+FileBan)                 .AND.;
	    !FILE(cPatSis+'\'+FilePag)                 .AND.;
	    !FILE(cPatSis+'\'+FileNiv+cAnoSis+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FileCnt)                 .AND.;
	    !FILE(cPatSis+'\'+FileTrc)                 .AND.;
	    !FILE(cPatSis+'\'+FileTob)                 .AND.;
	    !FILE(cPatSis+'\'+FileObs)                 .AND.;
	    !FILE(cPatSis+'\'+FileSib)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,;
		      lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu)

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL SISTEMA
	      IF !FILE(cPatSis+'\'+fMtrAno+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfAno(lShared,cPatSis,fMtrAno+cAnoUsr+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileAdm+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfAdm(lShared,cPatSis,FileAdm+cAnoUsr+ExtFile,lIntUno)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileDoc+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPro(lShared,cPatSis,FileDoc+cAnoUsr+ExtFile,lIntUno)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCon)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCon(lShared,cPatSis,FileCon)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileTar)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTar(lShared,cPatSis,FileTar,lIntUno)
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

	      IF !FILE(cPatSis+'\'+FileBan)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfBan(lShared,nModCry,cPatSis,FileBan)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FilePag)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPag(lShared,cPatSis,FilePag)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileCnt)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCnt(lShared,nModCry,cPatSis,FileCnt)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileTrc)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTrc(lShared,nModCry,cPatSis,FileTrc)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileTob)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTob(lShared,nModCry,cPatSis,FileTob)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileObs)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfObs(lShared,nModCry,cPatSis,FileObs)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileSib)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfSib(lShared,nModCry,cPatSis,FileSib)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS DEL SISTEMA

       ENDCASE
*>>>>FIN CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA

*>>>>CREACION DE ARCHIVOS DE ARCHIVOS COMPARTIDOS
       RESTSCREEN(0,0,24,79,cSavPan)
       RevisaCont(aP1)
*>>>>FIN CREACION DE ARCHIVOS DE ARCHIVOS COMPARTIDOS

*>>>>CREACION DE INDICES COMPARTIDOS
       lndexar := .F.
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   IF !FILE(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		    fNtxAlu+cMaeAct+cAnoSis+cExtNtx)
	      lndexar := .T.
	      EXIT
	   ENDIF

       ENDFOR
*>>>>FIN CREACION DE INDICES COMPARTIDOS

*>>>>CREACION INDICES DEL SISTEMA
       IF lndexar .OR.;
	  !FILE(PathUno+'\'+PathSis+'\'+fNtxPer) .OR.;
	  !FILE(PathUno+'\'+PathSis+'\'+Ntx1Per) .OR.;
	  !FILE(PathUno+'\'+PathSis+'\'+fNtxObG) .OR.;
	  !FILE(cPatSis+'\'+fNtxPag) .OR.;
	  !FILE(cPatSis+'\'+fNtxDes)
	  !FILE(cPatSis+'\'+fNtxAdm) .OR.;
	  !FILE(cPatSis+'\'+Ntx1Adm) .OR.;
	  !FILE(cPatSis+'\'+Ntx2Adm) .OR.;

	  RESTSCREEN(0,0,24,79,cSavPan)
	  Indexar(lShared,cAnoUsr,cPatSis,cMaeAlu,PathUno)

       ENDIF
*>>>>FIN CREACION O RECUPERACION DE LAS ESTRUCTURAS

*>>>>ACTUALIZACION DE ESTRUCTURAS
       lndexar := .F.

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActStrMtr(lShared,PathSis,fSimMtr)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrInf(lShared,nModCry,PathSis,FileInf)
     *ÀActualizacion de Archios de informes del sistema

       nActStrIso(lShared,nModCry,PathSis,FileIso)
     *ÀActualizacion de Archios de documentos a imprimir

       nActStrMzp(lShared,nModCry,PathSis,FileMzp)
     *ÀActualizacion de Archios de documentos a imprimir

       nActStrAno(lShared,cPatSis,fMtrAno+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Configuraci¢n del A¤o

       nActStrAdm(lShared,cPatSis,FileAdm+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Admisiones

       nActStrBan(lShared,nModCry,cPatSis,FileBan)
     *ÀActualiaci¢n de Bancos

       nActStrPag(lShared,cPatSis,FilePag)
     *ÀActualizaci¢n de Estructuras

       nActDbfCon(lShared,cPatSis,FileCon)
     *ÀActualizaci¢n de Conceptos

       nActStrCnt(lShared,nModCry,cPatSis,FileCnt)
     *ÀActualizaci¢n de Contratantes

       nActStrTrc(lShared,nModCry,cPatSis,FileTrc)
     *ÀActualizaci¢n de Tipo de Recibos

       nActStrTob(lShared,nModCry,cPatSis,FileTob)
     *ÀActualizaci¢n de la tabla de observaciones

*       nActStrObs(lShared,nModCry,cPatSis,FileObs)
     *ÀActualizaci¢n de Observaciones de los estudiantes
*       Si se actualiza se puede borrar los campos memos

	nActStrSib(lShared,nModCry,cPatSis,FileSib)
     *ÀActualizaci¢n del Sisben

       nActStrCmv(lShared,nModCry,cPatSis,FileCmv)


       IF nActStrDes(lShared,nModCry,cPatSis,FileDes) == 0
	  lndexar := .T.
       ENDIF
     *ÀActualizaci¢n de Descuentos
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS

*>>>>INDEXAR LOS ARCHIVOS
       IF lndexar
	  Indexar(lShared,cAnoUsr,cPatSis,cMaeAlu,PathUno)
       ENDIF
*>>>>FIN INDEXAR LOS ARCHIVOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared,nModCry)
	  CloseDbf('MTR')
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')

       CASE EMPTY(MTR->cCodFacMtr)
	    cError('NO SE HA CONFIRGURADO EL CODIGO DEL SERVICIO FACTURADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF MTR->lPrnArcMtr
	  SET PRINTER TO SIMATEMP              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       nCodXsl := MTR->nCodXslMtr
       cSerFac := ALLTRIM(MTR->cSerFacMtr)+":"+MTR->cCodFacMtr

       CloseDbf('MTR')
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

*>>>>CREACION DE SITIOS DEL SISTEMA
*       InfPrnXsl(nCodXsl) // Pendiente

       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE SITIOS DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION ARCHIVOS GENERALES DEL SISTEMA        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   JUL 19/96 VIE

OBJETIVOS:

1)- Crea todos los archivos generales del sistema

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,nModCry,cNomEmp,cNomSis,cPatSis,;
		    cAnoUsr,bInfSys,lIntUno,lIntDos,lIntTre,;
		    lIntCua)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       bInfSys                              // Block Informes del Sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cIntUno                              // Path de Integraci¢n uno */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

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
       CreaDbfPrn(lShared,nModCry,PathSis,FilePrn)

       Termometro(60)
       CreaDbfInf(lShared,nModCry,PathSis,FileInf,,bInfSys)

       Termometro(80)
       CreaDbfIso(lShared,nModCry,PathSis,FileIso)

       Termometro(90)
       CreaDbfMzp(lShared,nModCry,PathSis,FileMzp)

       OrdenMtr04(cNomSis,cNomEmp)
       Termometro(100)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LOS ARCHIVOS DEL SISTEMAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 04:35 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Crea todos los archivos de la aplicaci¢n o del sistema

2)- Retorna NIL

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,lIntUno,;
		   lIntDos,lIntTre,lIntCua,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cIntUno                              // Path de Integraci¢n uno
       cAnoSis                              // A¤o del sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE  ESTRUCTURAS DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS DEL SISTEMA")

       CreaDbfAdm(lShared,cPatSis,FileAdm+cAnoUsr+ExtFile,lIntUno)
       Termometro(10)

       CreaDbfPro(lShared,cPatSis,FileDoc+cAnoUsr+ExtFile,lIntUno)
       Termometro(20)

       CreaDbfCon(lShared,cPatSis,FileCon)
       Termometro(30)

       CreaDbfTar(lShared,cPatSis,FileTar,lIntUno)
       Termometro(40)

       Termometro(45)
       CreaDbfDes(lShared,nModCry,cPatSis,FileDes)

       CreaDbfBan(lShared,nModCry,cPatSis,FileBan)
       Termometro(50)

       CreaDbfPag(lShared,cPatSis,FilePag)
       Termometro(60)

       CreaDbfCnt(lShared,nModCry,cPatSis,FileCnt)
       Termometro(70)

       CreaDbfTrc(lShared,nModCry,cPatSis,FileTrc)
       Termometro(80)

       CreaDbfTob(lShared,nModCry,cPatSis,FileTob)
       Termometro(90)

       CreaDbfObs(lShared,nModCry,cPatSis,FileObs)
       Termometro(95)

       CreaDbfSib(lShared,nModCry,cPatSis,FileSib)
       Termometro(100)
*>>>>FIN CREACION DE ESTRUCTURAS DEL SISTEMA

*>>>>CREACION DE ESTRUCTURAS COMPARTIDAS
       IF !lIntUno

**********CREACION DE ESTRUCTURAS DE JARDIN
	    IF 'JAR' $ cMaeAlu
	       Termometro(0,"CREANDO ARCHIVOS DE JARDIN")
	       Termometro(100)
	       cPatTem := cPatSis+'\JAR'
	       IF !FILE(cPatTem+'\'+FileNiv+cAnoSis+ExtFile)
		  CreaDbfNiv(lShared,cPatTem,FileNiv+cAnoSis+ExtFile,;
			     NIL,'JAR')
	       ENDIF

	       IF !FILE(cPatTem+'\'+FMaeJar+cAnoSis+ExtFile)
		  CreaDbfAlu(lShared,cPatTem,FMaeJar+cAnoSis+ExtFile,lIntUno)
	       ENDIF
	    ENDIF
**********FIN CREACION DE ESTRUCTURAS DE JARDIN

**********CREACION DE ESTRUCTURAS DE PRIMARIA
	    IF 'PRI' $ cMaeAlu
	       Termometro(0,"CREANDO ARCHIVOS DE PRIMARIA")
	       Termometro(100)
	       cPatTem := cPatSis+'\PRI'
	       IF !FILE(cPatTem+'\'+FileNiv+cAnoSis+ExtFile)
		  CreaDbfNiv(lShared,cPatTem,FileNiv+cAnoSis+ExtFile,;
			     NIL,'PRI')
	       ENDIF

	       IF !FILE(cPatTem+'\'+FMaePri+cAnoSis+ExtFile)
		  CreaDbfAlu(lShared,cPatTem,FMaePri+cAnoSis+ExtFile,lIntUno)
	       ENDIF
	    ENDIF
**********FIN CREACION DE ESTRUCTURAS DE PRIMARIA

**********CREACION DE ESTRUCTURAS DE BACHILLERATO
	    IF 'BTO' $ cMaeAlu
	       Termometro(0,"CREANDO ARCHIVOS DE BACHILLERATO")
	       Termometro(100)
	       cPatTem := cPatSis+'\BTO'
	       IF !FILE(cPatTem+'\'+FileNiv+cAnoSis+ExtFile)
		  CreaDbfNiv(lShared,cPatTem,FileNiv+cAnoSis+ExtFile,;
			     NIL,'BTO')
	       ENDIF

	       IF !FILE(cPatTem+'\'+FMaeBto+cAnoSis+ExtFile)
		  CreaDbfAlu(lShared,cPatTem,FMaeBto+cAnoSis+ExtFile,lIntUno)
	       ENDIF
	    ENDIF
**********FIN CREACION DE ESTRUCTURAS DE BACHILLERATO

       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS COMPARTIDAS

/*************************************************************************
* TITULO DE LA FUNCION..: INDEXAR LOS ARCHIVOS DEL SISTEMA               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/95 MAR A
       Colombia, Bucaramanga        INICIO: 01:25 PM   MAY 02/95 MAR

OBJETIVOS:

1- Coloca en uso todos los archivos de sistema que estan indexados

2- Crea los archivos indices del sistema

3- Retorna NIL


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Indexar(lShared,cAnoUsr,cPatSis,cMaeAlu,PathUno)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros Habilitados
       PathUno                              // Path de integraci¢n uno */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FilePag,'PAG',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>CREACION DEL INDICES DEL SISTEMA
       Termometro(0,'INDEXANDO LOS ARCHIVOS DEL SISTEMA')
       Termometro(10)

       SELECT ADM
       Termometro(25)
       fNtxAdm := cPatSis+'\'+fNtxAdm
       INDEX ON ADM->cNumeroAdm TO &fNtxAdm

       Termometro(50)
       Ntx1Adm := cPatSis+'\'+Ntx1Adm
       INDEX ON ADM->cApelliEst TO &Ntx1Adm

       Termometro(75)
       Ntx2Adm := cPatSis+'\'+Ntx2Adm
       INDEX ON ADM->cNombreEst TO &Ntx2Adm

       Termometro(80)
       SELECT PAG
       INDEX ON PAG->cCodigoEst+PAG->cMatricPag;
	     TO &(cPatSis+'\'+fNtxPag)

       Termometro(100)
       SELECT DES
       INDEX ON DES->cCodigoEst+STR(DES->nNroMesDes,2);
	     TO &(cPatSis+'\'+fNtxDes)
       CloseDbf('DES',cPatSis+'\'+FileDes)
       Termometro(25)
*>>>>FIN CREACION DEL INDICES DEL SISTEMA

*>>>>CREACION DE LOS INDICES COMPARTIDOS
       NtxAlu(lShared,PathUno,cPatSis,cAnoSis,cMaeAlu)

       CloseAll()
       RETURN NIL
*>>>>FIN CREACION DE LOS INDICES COMPARTIDOS

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DE LOS MENUS DE LA APLICACION       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 07:55 PM   DIC 27/95 MIE

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

FUNCTION aMenusMatr(lShared,nNroOpc,cDerech,aAyudas,cModem)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroOpc			            // N£mero de Opci¢n
       cDerech                              // Derechos a los Menus
       aAyudas                              // @Vector de Ayudas escogidas
       cModem                               // Banco para Gerencia Electr¢nica */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                    // Declaraci¢n de Men£s
       LOCAL aAyuda  := {}                    // Declaraci¢n de Ayudas
       LOCAL aMenuss := {}                    // Men£ escogido
       LOCAL     i,j := 0                     // Contadores
       LOCAL lModDua := .T.                   // Modo Dual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENUS
       DO CASE
       CASE nNroOpc == 0

	    aMenus  := {'1INSCRIPCIONES',;
			'2EVALUACION',;
			'3ENTREVISTAS',;
			'4CUPOS',;
			'5PAGOS',;
			'6MATRICULAS',;
			'7UTILIDADES'}

	    aAyuda  := {'Permite Inscribir a los aspirantes. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite la leer el resultado final de la evaluaci¢n. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite definir los candidatos a entrevistas. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite registrar los datos de la Entrevista. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite Asignar los cupos. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite Realizar la Matricula Acad‚mica. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite Ejecutar varias utilidades del sistema. '+;
			'<ESC> TERMINA EL PROGRAMA'}

       CASE nNroOpc == 1

	    aMenus  := {'1<INSCRIPCION>',;
			'2<CONSULTA   >',;
			'3<IMPRESION  >'}

	    aAyuda  := {'Permite la inscripci¢n del Candidato',;
			'Permite la Consulta de las Inscripciones',;
			'Permite Generar el listado de Inscritos'}

       CASE nNroOpc == 2

	    aMenus  := {"1<GRABACION    >",;
			"2<EVALUACION   >",;
			"3<CONSULTA     >",;
			"4<IMPRESION    >",;
			"5<CARTELERA    >",;
			"6<GRABAR OBSERV>",;
			"7<OBSERVACIONES>"}

	    aAyuda  := {'Permite la Grabar las notas de las Evaluaciones',;
			'Permite Evaluar las Evaluaciones',;
			'Permite Consultar los resultados de las Evaluaciones',;
			'Permite Generar el listado de las Evaluaciones',;
			'Imprime los C¢digo de los Estudiantes que Aprobaron la Evaluaci¢n',;
			'Permite grabar las observaciones de las pruebas de admisi¢n',;
			'Permite consultar las observaciones de las pruebas de admisi¢n'}

       CASE nNroOpc == 3

	    aMenus  := {"1<ASIGNACION DE CITAS >",;
			"2<CONSULTA DE CITAS   >",;
			"3<CARTELERA DE CITAS  >",;
			"4<ASIGNAR EL HORARIO  >",;
			"5<IMPRIMIR LAS CITAS  >",;
			"6<IMPRIMIR CITACIONES >",;
			"7<GRABACION HOJA VIDA >",;
			"8<CONSULTAR RESULTADOS>",;
			"9<IMPRIMIR RESULTADOS >"}

	    aAyuda  := {"Permite dar la citas para las entrevistas",;
			"Permite Consultar los canditados citados",;
			"Imprime los C¢digo de los Candatos a Entrevistar",;
			"Permite asignar el Horario de las entrevistas",;
			"Permite imprimir los recibos de citaci¢n",;
			"Imprime la relaci¢n de candidatos a entrevistar "+;
			"con su horario",;
			"Permite Grabar la informaci¢n del Estudiante",;
                        'Permite Consultar los resultados de las Entrevistas',;
			'Genera el listado con los resultados de las entrevisatas'}

       CASE nNroOpc == 4

	    aMenus  := {'1<ASIGNAR     >',;
			'2<CONSULTAR   >',;
			'3<CARTELERA   >',;
			'4<IMPRESION   >',;
			'5<CONTRATANTES>'}

	    aAyuda := {'Permite Asignar el cupo a los Estudiantes',;
		       'Permite Consultar los cupos asignados',;
		       'Genera el listado de los estudiantes con cupo. Cartelera',;
		       'Genera el listado de los estudiantes con cupo.',;
		       'Permite Grabar los Contratantes'}

       CASE nNroOpc == 5

	    cModem  := IF(EMPTY(cModem),'PAGOS POR MODEM'+SPACE(05),cModem)

	    aMenus  := {'1<FACTURAR NUEVOS     >',;
			'2<FACTURAR ANTIGUOS   >',;
			'3<REGISTRAR RECIBOS   >',;
			'4<'+cModem+'>',;
			'5<INFORMES FACTURACION>',;
			'6<CONCEPTOS ALUMNOS   >',;
			'7<PAGOS EN LINEA      >',;
			'8<DESCUENTOS/RECARGOS >',;
			'9<CONSIGNACIONES      >'}

	    aAyuda := {'Permite Facturar los recibos de los alumnos nuevos',;
		       'Permite Facturar los recibos de los alumnos antiguos',;
		       'Permite indicar la forma de pago de los recibos',;
		       'Procesa los Movimientos del archivo transferido por Modem ',;
		       'Permite imprimir los diferentes informes de la Facturaci¢n.',;
		       'Permite Asignar los Conceptos de Pago Individuales al Estudiante',;
		       'Permite generar la facturaci¢n en archivo para los pagos en linea',;
		       'Permite aplicar descuentos o recargos indivuales',;
		       'Permite imprimir recibos para hacer consignaciones'}

       CASE nNroOpc == 6

	    aMenus := {'1<MATRICULAS  >',;
		       '2<CONSULTAS   >',;
		       '3<IMPRESIONES >',;
		       '4<ACTUALIZAR  >',;
		       '5<REPITENTES  >',;
		       '6<ORDENES     >',;
		       '7<RETIROS     >',;
		       '8<FIJAR GRUPOS>',;
		       '9<LISTAS CLASE>'}

	    aAyuda := {'Permite realizar la matr¡cula de los estudiantes',;
		       'Permite consultar sobre las matr¡culas',;
		       'Permite generar listados sobre matr¡culas',;
		       'Permite Actualizar la Informaci¢n de los Estudiantes',;
		       'Permite definir los estudiantes repitentes',;
		       'Permite imprimir diferentes formatos como las orden‚s de matr¡cula,etc',;
		       'Permite Cancelar la matr¡cula al estudiante',;
		       'Permite cambiar de grupos a los estudiantes',;
		       'Permite imprimir listas de clase provisionales'}

       CASE nNroOpc == 7

	    aMenus := {'1<USUARIOS      >',;
		       '2<CAMBIAR CLAVE >',;
		       '3<REINDEXAR     >',;
		       '4<INTEGRIDAD    >',;
		       '5<MATRICULAS FAC>',;
		       '6<ACTUALIZAR    >',;
		       '7<MANTENIMIENTO >',;
		       '8<CONFIGURACION >',;
		       '9<VARIOS        >'}

	    aAyuda := {'Permite Crear usuarios y Asignar sus derechos.',;
		       'Permite cambiar la clave. ',;
		       'Reindexa los archivos del Sistema.',;
		       'Elimina los registros marcados como borrados.',;
		       'Permite realizar la matr¡cula de los estudiantes con fines de facturaci¢n.',;
		       'Permite Actualizar las estructuras de los Archivos del Sistema',;
		       'Permite el Mantenimiento de los Archivos del Sistema',;
		       'Permite definir las diferentes Configuraciones del Sistema',;
		       'Men£ con otros procesos utilitarios del Sistema'}


	    lModDua := .F.
	    IF lModDua
	       AADD(aMenus,'8<EJECUTAR         >')
	       AADD(aAyuda,'Ejecuta el programa especificado')

	       AADD(aMenus,'9<CONTROL IMPRESION>')
	       AADD(aAyuda,'Permite accesar el control de impresi¢n en Red')
	    ENDIF

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
* TITULO......: EJECUCION MENUS PRIMER NIVEL                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 29/95 JUE A
       Colombia, Bucaramanga        INICIO: 10:35 AM   DIC 29/95 JUE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubMenus(aP1,;
		  nOpcion,nOpcPal,aColSup,cDerech,;
		  nColAno,cSavPan,lCodEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       aColSup                              // Columnas para los sub_men£s
       cDerech                              // Derechos en el sistema
       nColAno                              // Columna A¤o del sistema
       cSavPan                              // Salvar Pantalla
       lCodEst                              // .T. C¢digo Generado por el Sistema .F. C¢digo Generado Externamente */
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
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL cModem := xPrm(aP1,'cModem')   // Banco para Gerencia Electr¢nica
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>PARAMETROS GENERALES
       LOCAL aP2 := {}                  // Parametros Generales
       LOCAL aP3 := {}                  // Parametros Generales
*>>>>FIN PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL lSiMenu := .T.                 //.T.Opci¢n principal con SubMen£
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opci¢n
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones

       LOCAL       i := 0                   // Contador
       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£

       LOCAL  cOrden := ''                  // Orden a Ejecutar

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

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>EJECUCION DEL PRIMER NIVEL
       DO WHILE .T.

	  CloseAll()

**********AREAS DE TRABAJO
	    aUseDbf := {}
	    AADD(aUseDbf,{.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared,nModCry})
	    AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			      fSimaCo,'SCO',NIL,lShared,nModCry})
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
	    CASE MTR->(RECCOUNT()) == 0
		 cError('NO EXISTE CONFIGURACION DEL SISTEMA')

	    CASE SCO->(RECCOUNT()) == 0
		 cError('NO EXISTE CONFIGURACION DEL SISTEMA '+;
			'DE CONTATABILIDAD')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseAll(aUseDbf)
	       QUIT
	    ENDIF

	    nPrueba := MTR->nPruebaMtr
	    lPrnArc := MTR->lPrnArcMtr
	    nCodPrn := MTR->nCodigoPrn
	    cOpcPrn := MTR->cOpcPrnMtr
	    cUsrIso := MTR->cUsrIsoMtr
	    nCodXsl := MTR->nCodXslMtr
	    cPiePag := MTR->cPiePagMtr
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LECTURA DEL LOGO DE LA EMPRESA
	    cLogEmp := ''
	    IF !EMPTY(SCO->cLogEmpSco)

	       cPatSim := cPathSima()
	       cLogEmp := cPatSim+'\'+'SimaCont\Bases\'+;
			  ALLTRIM(SCO->cLogEmpSco)
	    ENDIF
	    CloseAll()

	    nParameSet(aP1,'cLogEmp',cLogEmp)
**********FIN LECTURA DEL LOGO DE LA EMPRESA

**********DETALLES DEL INFORME
	    aP3 := {}
	    AADD(aP3,{'cPieTre',cPiePag})
	    AADD(aP3,{'cUsrIso',cUsrIso})
	    AADD(aP3,{'nCodXsl',nCodXsl})

	    AADD(aP3,{'lPrnArc',lPrnArc})
	    AADD(aP3,{'nCodPrn',nCodPrn})
	    AADD(aP3,{'cOpcPrn',cOpcPrn})
**********FIN DETALLES DEL INFORME

**********LECTURA DE PATHS
	    LeePathMaA(lShared,cPatSis,cAnoUsr,;
		       @PathUno,@PathDos,@PathTre,@PathCua,.F.)
	  *ÀLectura de paths

	    nParameSet(aP1,'PathUno',PathUno)
	    nParameSet(aP1,'PathDos',PathDos)
	    nParameSet(aP1,'PathTre',PathTre)
	    nParameSet(aP1,'PathCua',PathCua)
**********FIN LECTURA DE PATHS

**********SELECCION DE LOS SUBMENUS
	    CloseAll()
	    lSiMenu := .T.
	    aDeMenu := aMenusMatr(lShared,nOpcPal,;
				  SUBS(cDerech,nOpcPal*10-9,10),@aHelp,;
				  cModem)
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

		 nNroOpc := nMenu(aMenu,aHelp,;
				  nFilSup,nColSup,NIL,NIL,nNroOpc,NIL)

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
		      Matri_101(aP1,aP2,aP3,;
				lCodEst)
		    *Inscripciones

		 CASE nNroOpc == 2
		      Matri_102(aP1,aP2,aP3)
		    *Consulta Inscripciones

		 CASE nNroOpc == 3
		      Matri_103(aP1,aP2,aP3)
		    *Impresi¢n Inscripciones

		 ENDCASE

	    CASE nOpcPal == 2

		 DO CASE
		 CASE nNroOpc == 1
		      Matri_201(aP1,aP2,aP3)
		    *Grabaci¢n de Examenes

		 CASE nNroOpc == 2
		      Matri_202(aP1,aP2,aP3)
		    *Evaluaci¢n Examenes

		 CASE nNroOpc == 3
		      Matri_203(aP1,aP2,aP3)
		    *Consulta de Examenes

		 CASE nNroOpc == 4
		      Matri_204(aP1,aP2,aP3)
		    *Impresi¢n de Examenes

		 CASE nNroOpc == 5
		      Matri_205(aP1,aP2,aP3)
		    *Impresi¢n de la Cartelera

		 CASE nNroOpc == 6
		      Matri_206(aP1,aP2,aP3)
		    *Grabaci¢n de las observaciones

		 CASE nNroOpc == 7
		      Matri_207(aP1,aP2,aP3)
		    *Consulta de las observaciones

		 ENDCASE

	    CASE nOpcPal == 3

		 DO CASE
		 CASE nNroOpc == 1
		      Matri_301(aP1,aP2,aP3)
		    *Grabaci¢n citas a entrevistas

		 CASE nNroOpc == 2
		      Matri_302(aP1,aP2,aP3)
		    *Consulta de las citas

		 CASE nNroOpc == 3
		      Matri_303(aP1,aP2,aP3)
		    *Impresi¢n de n£meros de Inscripci¢n a entrevistar

		 CASE nNroOpc == 4
		      Matri_304(aP1,aP2,aP3)
		    *Asignaci¢n de fechas de entrevistas

		 CASE nNroOpc == 5
		      Matri_305(aP1,aP2,aP3)
		     *Impresi¢n de las citas a entrevistas

		 CASE nNroOpc == 6
		      Matri_306(aP1,aP2,aP3)
		     *Impresi¢n de candidatos a entrevistar

		 CASE nNroOpc == 7
		      Matri_307(aP1,aP2,aP3)
		    *Grabaci¢n de Entrevista

		 CASE nNroOpc == 8
		      Matri_308(aP1,aP2,aP3)
		    *Consulta de entrevistas

		 CASE nNroOpc == 9
		      Matri_309(aP1,aP2,aP3)
		    *Impresion de entrevistas


		 ENDCASE

	    CASE nOpcPal == 4

		 DO CASE
		 CASE nNroOpc == 1
		      Matri_401(aP1,aP2,aP3)
		    *Grabaci¢n de Cupos

		 CASE nNroOpc == 2
		      Matri_402(aP1,aP2,aP3)
		    *Consulta de Cupos

		 CASE nNroOpc == 3
		      Matri_403(aP1,aP2,aP3)
		    *Impresi¢n Cupos para cartelera

		 CASE nNroOpc == 4
		      Matri_404(aP1,aP2,aP3)
		    *Impresi¢n Cupos

		 CASE nNroOpc == 5
		      Matri_405(aP1,aP2,aP3)
		    *Grabaci¢n de Contratantes

		 ENDCASE

	    CASE nOpcPal == 5

		 DO CASE
		 CASE nNroOpc == 1
		      Matri_501(aP1,aP2,aP3,;
				lCodEst)
		    *Impresi¢n recibos nuevos

		 CASE nNroOpc == 2
		      Matri_502(aP1,aP2,aP3)
		    *Impresi¢n recibos antiguos

		 CASE nNroOpc == 3
		      Matri_503(aP1,aP2,aP3)
		    *Forma de pago

		 CASE nNroOpc == 4
		      Matri_504(aP1,aP2,aP3)
		    *ÀPagos por Archivo

		 CASE nNroOpc == 5
		      Matri_505(aP1,aP2,aP3)
		    *Impresi¢n de pagos por grupos

		 CASE nNroOpc == 6
		      Matri_506(aP1,aP2,aP3)
		    *ÀGrabaci¢n de los conceptos a los alumnos

		 CASE nNroOpc == 7
		      Matri_507(aP1,aP2,aP3)
		    *ÀPago en Cajeros

		 CASE nNroOpc == 8
		      MantenDes(aP1,aP2,aP3)
		    *ÀDescuentos Individuales

		 CASE nNroOpc == 9
		      Matri_509(aP1,aP2,aP3)
		    *ÀFacturaci¢n - Consignaciones

		 ENDCASE

	    CASE nOpcPal == 6

		 DO CASE
		 CASE nNroOpc == 1
		      Matri_601(aP1,aP2,aP3,;
				lCodEst)
		    *Matriculas

		 CASE nNroOpc == 2
		      Matri_602(aP1,aP2,aP3)
		     *Consultas de las matriculas

		 CASE nNroOpc == 3
		      Matri_603(aP1,aP2,aP3)
		     *Impresi¢n de matriculas

		 CASE nNroOpc == 4
		      Matri_604(aP1,aP2,aP3)
		     *Actualizar del Directorio

		 CASE nNroOpc == 5
		      Matri_605(aP1,aP2,aP3)
		     *Estudiantes repitentes

		 CASE nNroOpc == 6
		      Matri_606(aP1,aP2,aP3)
		     *Impresi¢n de Ordenes de matriculas

		 CASE nNroOpc == 7
		      Matri_607(aP1,aP2,aP3)
		     *Retiro de Estudiantes

		 CASE nNroOpc == 8
		      Matri_608(aP1,aP2,aP3)
		     *Cambio de Grupos

		 CASE nNroOpc == 9
		      Matri_609(aP1,aP2,aP3)
		     *Listas de clase

		 ENDCASE


	    CASE nOpcPal == 7

		 DO CASE
		 CASE nNroOpc == 1
		      MantenUsr(lShared,PathSis,FileAaa,{|nOpcion,aAyudas|;
				aMenusMatr(lShared,nOpcion,'1111111111',;
					   aAyudas,cModem)},cNomSis,.F.)
		     *Mantemiento de usuarios

		 CASE nNroOpc == 2
		      CamPasWor(lShared,nFilInf+1,aColSup[nOpcion],;
				PathSis,FileAaa,cNomUsr)
		     *Cambiar el PassWord del usuario

		 CASE nNroOpc == 3
		      Indexar(lShared,cAnoUsr,cPatSis,cMaeAlu,PathUno)
		     *Indexa los archivos del sistema

		 CASE nNroOpc == 5
		      Matri_705(aP1,aP2,aP3,;
				lCodEst)
		    *Matriculas Fac

		 CASE nNroOpc == 6
		      Matri_706(aP1,aP2,aP3)
		     *Actualizar

		 CASE nNroOpc == 7
		      Matri_707(aP1,aP2,aP3)
		     *Mantenimientos

		 CASE nNroOpc == 8
		      Matri_708(aP1,aP2,aP3)
		     *Configuraci¢n del Sistema

		 CASE nNroOpc == 9
		      Matri_709(aP1,aP2,aP3)
		     *Men£ utilidades varios

		 CASE nNroOpc == 10
		      cOrden := SPACE(150)
		      @nFilInf+1,01 SAY 'ORDEN:' GET cOrden PICT '@S70'
		      READ
		      IF !SWPRUNCMD(cOrden,0,"","")
			 cError('DE EJECUCION')
		      ENDIF

		 CASE nNroOpc == 11
		      SWPRUNCMD("PCONSOLE",0,"","")
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
* TITULO DE LA FUNCION..: IMPRESION DE RECIBO DE PAGO                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 19/96 MIE A
       Bucaramanga, Colombia        INICIO: 12:55 AM   JUN 19/96 MIE

OBJETIVOS:

1- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo(cNomEmp,cCodigo,cNombre,cCodGru,nNroLis,;
		 cNomBan,cCtaBan,cLugBan,cConcep,nIntMor,;
		 dPagOpo,dPagExt,cMensaj,nVlrMes,nMesIni)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cCodigo                              // C¢digo del estudiante
       cNombre		                    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       nNroLis                              // N£mero de lista
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       nMesIni                              // Mes inicial del pago */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 58                  // Longitud del recibo

       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       cMsgTxt := cNomEmp
       @ PROW(),03 SAY cMsgTxt+SPACE(01)+'ALUMNO'
       @ PROW(),nNroLen   SAY cMsgTxt+SPACE(01)+'BANCO'
       @ PROW(),nNroLen*2 SAY cMsgTxt+SPACE(01)+'COLEGIO'
*>>>>FIN IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL NOMBRE DEL BANCO
       Linea_Recibo(RTRIM(cNomBan)+' '+;
		    RTRIM(cCtaBan)+' '+;
		    RTRIM(cLugBan))
*>>>>FIN IMPRESION DEL NOMBRE DEL BANCO

*>>>>IMPRESION DE LOS DATOS DEL ESTUDIANTE
       Linea_Recibo('ALUMNO: '+cNombre)
       Linea_Recibo('CODIGO: '+cCodigo+SPACE(08)+;
		    'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
					 SUBS(cCodGru,3,2)+;
		    '   No. '+STR(nNroLis,2))
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>IMPRESION DE LOS ENCABEZADOS DE COLUMNA
       cLinea := REPL ('-',48)
       Linea_Recibo(cLinea)
     *ÀPrimera linea separadora

       Linea_Recibo('|DESCRIPCION     '+;
		    '| ATRASOS | '+SPACE(02)+;
		     cMes(nMesIni,3)+SPACE(02)+;
		    ' |  TOTAL  |')

       Linea_Recibo(cLinea)
      *Segunda linea separadora
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nVlrConcep(cConcep)
      *Impresi¢n de conceptos

       nVlrTot := nVlrMes

       Linea_Recibo(cLinea)
      *Impresi¢n tercera l¡nea separadora
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cMsgTxt  := 'HASTA '+cFecha(dPagOpo)+' ..PAGUE $'+;
		   TRANSFORM(nVlrTot,"9999,999.99")
       Linea_Recibo(cMsgTxt)
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       nVlrPag := nVlrTot
       nVlrInt := ROUND((nVlrPag*nIntMor)/100,0)
      *Calculo de los intereses

       cMsgTxt := 'HASTA '+cFecha(dPagExt)+' ..PAGUE $'+;
		   TRANSFORM(nVlrTot+nVlrInt,"9999,999.99")
       Linea_Recibo(cMsgTxt)

       @ PROW()+1,(163-LEN(cMensaj))/2 SAY cMensaj
      *Impresion del mensaje de la facturacion

       RETURN nVlrTot
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA

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
* TITULO DE LA FUNCION..: DETALLES PARA LA FACTURACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:20 PM   AGO 09/96 VIE

OBJETIVOS:

1- Visualiza los detalles del pago con los cuales se van a facturar los
   recibos.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDetFac(lShared,nFilPal,nColPal,cNomBan,;
		 cCtaBan,nMesIni,nMesFin,cAnoUsr,;
		 cNomTrc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilPal                              // Fila Superior
       nColPal                              // Columna Superior
       cNomBan                              // Nombre del Banco
       cCtaBan                              // N£mero de cuenta del banco
       nMesIni                              // Mes Inicial del Pago
       nMesFin                              // Mes Final del pago
       cAnoUsr                              // A¤o del Usuario
       cNomTrc                              // Nombre del Tipo de Recibo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
      LOCAL lHayErr := .T.                  // .T. Hay Error
      LOCAL lSiorNo := .F.                  // Variable de decisi¢n
      LOCAL cSavPan := ''                   // Salvar Pantalla
      LOCAL cMsgTxt := ''                   // Texto Variable
      LOCAL nNroFil := 0                    // N£mero de la Fila
      LOCAL nNroCol := 0                    // N£mero de la Columna
      LOCAL nColTem := 0                    // Columna Temporal
      LOCAL cNroFac := ''                   // N£mero del Recibo
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>IMPRESION DE LOS TITULOS
       nNroFil := nMarco(nFilPal,'DETALLES DE FACTURACION PARA LA '+;
				 'IMPRESION DE LOS RECIBOS',22,'°')
       nNroCol := nColPal

       cMsgTxt := "FECHA DE PAGO OPORTUNO     :MATRICULA->"
       nColTem := nColPal+LEN(cMsgTxt)

       @ nNroFil  ,nNroCol    SAY cMsgTxt
       @ nNroFil  ,nColTem+13 SAY "PENSION->"
       @ nNroFil+1,nNroCol    SAY "FECHA DE PAGO EXTEMPORANEO :MATRICULA->"
       @ nNroFil+1,nColTem+13 SAY "PENSION->"
       @ nNroFil+2,nNroCol    SAY "FECHA FACTURACION          :"+;
				   IF(SCO->lHayNroCon,;
				      SPACE(11)+'°RECIBO No.','')

       @ nNroFil+4, nNroCol    SAY "NOMBRE DEL BANCO DEL PAGO  :"
       @ nNroFil+5, nNroCol    SAY IF(ANO->lIntMatAno,"INTERES","RECARGO")+;
						      " POR MORA. MATRICULA:"
       @ nNroFil+5, nNroCol+43 SAY IF(ANO->lIntPenAno,"INTERES","RECARGO")+;
						      " PENSION:"

       IF TRC->(RECCOUNT()) > 1
	  @ nNroFil+7, nNroCol    SAY "MENSAJE PARA LA FACTURACION:"+;
				      REPL('°',15)+'TIPO DE RECIBO:'
       ELSE
	  @ nNroFil+7, nNroCol    SAY "MENSAJE PARA LA FACTURACION:"
       ENDIF

       @ nNroFil+10,nNroCol    SAY "CONCEPTOS PARA MATRICULA:"

       IF !EMPTY(nMesIni) .OR. !EMPTY(nMesFin)
	  @ nNroFil+13,nNroCol SAY "CONCEPTOS DE PENSION "+;
				   "PARA LOS MESES DE "+;
				   cMes(nMesIni,3)+' A '+cMes(nMesFin,3)
       ENDIF
*>>>>FIN IMPRESION DE LOS TITULOS

*>>>>VALIDACION DE LOS DETALLES DE LA FACTURACION
/*       DO WHILE ANO->dOpoMatAno == CTOD("00/00/00")
	  cError('NO EXISTE FECHA PARA PAGO OPORTUNO DE LA MATRICULA')
	  dFecExt(lShared,nNroFil,nColTem,"ANO->dOpoMatAno")
	 ENDDO

	DO WHILE ANO->dExtMatAno == CTOD("00/00/00")
	  cError('NO EXISTE FECHA PARA PAGO EXTEMPORANEO DE LA MATRICULA')
	  dFecExt(lShared,nNroFil+1,nColTem,"ANO->dExtMatAno")
	ENDDO */

       DO WHILE ANO->dOpoPenAno == CTOD("00/00/00")
	  cError('NO EXISTE FECHA PARA PAGO OPORTUNO DE LA PENSION')
	  dFecExt(lShared,nNroFil,nColTem+23,"ANO->dOpoPenAno")
       ENDDO

       DO WHILE ANO->dExtPenAno == CTOD("00/00/00")
	  cError('NO EXISTE FECHA PARA PAGO EXTEMPORANEO DE LA PENSION')
	  dFecExt(lShared,nNroFil+1,nColTem+23,"ANO->dExtPenAno")
       ENDDO

       DO WHILE LEN(ALLTRIM(ANO->cConMatAno)) == 0
	  cError('NO SE HAN DEFINIDO LOS CONCEPTOS A COBRAR POR MATRICULA')
	  GrabarCon(lShared,nNroFil+7,30,nNroFil+11,1,'ANO->cConMatAno')
       ENDDO

       DO WHILE LEN(ALLTRIM(ANO->cConPenAno)) == 0
	  cError('NO SE HAN DEFINIDO LOS CONCEPTOS A COBRAR POR PENSION')
	  GrabarCon(lShared,nNroFil+7,30,nNroFil+14,1,'ANO->cConPenAno')
       ENDDO

       IF SCO->lHayNroCon .AND. lSeekRec(cAnoUsr,SCO->nNroFacCon+1)
	  cError('EL RECIBO No. '+;
		 ALLTRIM(STR(SCO->nNroFacCon+1,9))+' YA FUE IMPRESO')
	  nLeeNroRec(IF(lShared,lShared,!lShared),;
		     nNroFil+2,nColTem+11,cAnoUsr)
       ENDIF
*>>>>FIN VALIDACION DE LOS DETALLES DE LA FACTURACION

*>>>>IMPRESION DE LOS DETALLES DE LA FACTURACION
       SET COLOR TO I
       @ nNroFil  ,nColTem    SAY cFecha(ANO->dOpoMatAno)
       @ nNroFil  ,nColTem+23 SAY cFecha(ANO->dOpoPenAno)
       @ nNroFil+1,nColTem    SAY cFecha(ANO->dExtMatAno)
       @ nNroFil+1,nColTem+23 SAY cFecha(ANO->dExtPenAno)
       @ nNroFil+2,nColTem-11 SAY cFecha(DATE())

       IF SCO->lHayNroCon
	  SET DECIMALS TO 0
	  SET COLOR TO G*
	  cNroFac := STR(SCO->nNroFacCon+1,9)
	  lCorrecion(@cNroFac,.T.)
	  @ nNroFil+2,nColTem+11 SAY SCO->cCodEmpCon+'-'+cNroFac
	  SET COLOR TO
	  SET DECIMALS TO 2
	  SET COLOR TO I
       ENDIF

       @ nNroFil+4,nColTem-11 SAY RTRIM(cNomBan)+;
			   ' CUENTA No. '+RTRIM(cCtaBan)
       @ nNroFil+5,nColTem-11 SAY IF(ANO->lIntMatAno,;
				     ANO->nIntMatAno,;
				     ANO->nMorMatAno)
       @ nNroFil+5,nColTem+20 SAY IF(ANO->lIntPenAno,;
				     ANO->nIntPenAno,;
				     ANO->nMorPenAno)

       IF TRC->(RECCOUNT()) > 1
	  SET COLOR TO G*
	  @ nNroFil+7,nColTem+20 SAY cNomTrc
	  SET COLOR TO
       ENDIF

       IF LEN(RTRIM(ANO->cMensajAno)) == 80
	  nColTem := 0
       ELSE
	  nColTem := nColPal
       ENDIF
       @ nNroFil+8,nColTem SAY IF(LEN(ALLTRIM(ANO->cMensajAno)) == 0,;
				  'NO EXISTE MENSAJE',;
				  RTRIM(ANO->cMensajAno))
*>>>>FIN IMPRESION DE LOS DETALLES DE LA FACTURACION

*>>>>CONSULTA DE LOS CONCEPTOS DE MATRICULA
       nNroFil := nNroFil + 11
       IF !ConsultCon(nNroFil,nColPal,ANO->cConMatAno)
	  lHayErr := .F.
       ENDIF
*>>>>FIN CONSULTA DE LOS CONCEPTOS DE MATRICULA

*>>>>CONSULTA DE LOS CONCEPTOS DE PENSION
       IF !EMPTY(nMesIni) .OR. !EMPTY(nMesFin)

	  nNroFil := nNroFil + 3
	  IF !ConsultCon(nNroFil,nColPal,ANO->cConPenAno)
	     lHayErr := .F.
	  ENDIF

       ENDIF
       RETURN lHayErr
*>>>>FIN CONSULTA DE LOS CONCEPTOS DE PENSION

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIA LOS DETALLES DE LA FACTURACION          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   AGO 09/96 VIE

OBJETIVOS:

1- Permite cambiar a trav‚s de un men£ los detalles para la facturaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CamDetFac(lShared,nNroFil,nNroCol,cNomBan,cCtaBan,nMesIni,;
		   nMesFin,cAnoUsr,cNomTrc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil			            // Fila de impresi¢n
       nNroCol			            // Columna de impresi¢n
       cNomBan                              // Nombre del Banco
       cCtaBan                              // N£mero de cuenta del banco
       nMesIni                              // Mes Inicial para el pago
       nMesFin                              // Mes Final para el pago
       cAnoUsr                              // A¤o del Usuario
       cNomTrc                              // Nombre del Tipo de Recibo */
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
       AADD(aMenus,'1 <FECHA PAGO OPO. MATRICULA>')
       AADD(aMenus,'2 <FECHA PAGO EXT. MATRICUAL>')
       AADD(aMenus,'3 <FECHA PAGO OPO. PENSION  >')
       AADD(aMenus,'4 <FECHA PAGO EXT. PENSION  >')
       AADD(aMenus,'5 <FECHA DE FACTURACION     >')
       AADD(aMenus,'6 <NOMBRE DEL BANCO         >')
       IF ANO->lIntMatAno
	  AADD(aMenus,'7 <INTERESES MORA. MATRICULA>')
       ELSE
	  AADD(aMenus,'7 <RECARGO   MORA. MATRICULA>')
       ENDIF
       IF ANO->lIntPenAno
	  AADD(aMenus,'8 <INTERESES MORA. PENSION  >')
       ELSE
	  AADD(aMenus,'8 <RECARGO   MORA. PENSION  >')
       ENDIF
       AADD(aMenus,'9 <MENSAJE PARA FACTURACION >')
       AADD(aMenus,'10<CONCEPTOS PARA MATRICULA >')
       AADD(aMenus,'11<CONCEPTOS PARA PENSION   >')
       AADD(aMenus,'12<TIPOS DE RECIBOS         >')
       IF SCO->lHayNroCon
	  AADD(aMenus,'13<NUMERO DEL RECIBO        >')
       ENDIF

       AADD(aAyuda,'Cambia la fecha para pago oportuno de la matr¡cula')
       AADD(aAyuda,'Cambia la fecha para pago extempor neo de la matr¡cula')
       AADD(aAyuda,'Cambia la fecha para pago oportuno de la pensi¢n')
       AADD(aAyuda,'Cambia la fecha para pago extempor neo de la pensi¢n')
       AADD(aAyuda,'Cambia la fecha de la facturaci¢n')
       AADD(aAyuda,'Cambia el Banco donde se debe pagar')
       AADD(aAyuda,'Cambia los intereses por mora para matricula')
       AADD(aAyuda,'Cambia los intereses por mora para pensi¢n')
       AADD(aAyuda,'Cambia el mensaje que aparece en la facturaci¢n')
       AADD(aAyuda,'Cambia los conceptos de la matr¡cula')
       AADD(aAyuda,'Cambia los conceptos de la pension')
       AADD(aAyuda,'Cambia el Tipo de Recibo a Facturar')
       IF SCO->lHayNroCon
	  AADD(aAyuda,'Cambia el Consecutivo del N£mero del Recibo')
       ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,07,25,NIL,NIL,1,.F.)
       IF nNroOpc # 0
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       nColTem := nNroCol+LEN("FECHA DE PAGO OPORTUNO     :MATRICULA->")
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroFil += 3
       DO CASE
       CASE nNroOpc == 1
	    dFecExt(lShared,nNroFil,nColTem+1,"ANO->dOpoMatAno")
       CASE nNroOpc == 2
	    dFecExt(lShared,nNroFil+1,nColTem+1,"ANO->dExtMatAno")
       CASE nNroOpc == 3
	    dFecExt(lShared,nNroFil,nColTem+22,"ANO->dOpoPenAno")
       CASE nNroOpc == 4
	    dFecExt(lShared,nNroFil+1,nColTem+22,"ANO->dExtPenAno")

       CASE nNroOpc == 5
	    dFecSys := DATE()
	    @ nNroFil+2,nColTem GET dFecSys PICT "@D" ;
				    VALID dFecSys <> CTOD('00/00/00')
	    READ
	    IF ISAT()
	       SETDATE(dFecSys,.T.)
	    ELSE
	       SETDATE(dFecSys)
	    ENDIF

       CASE nNroOpc == 6
	    @ nNroFil+4,nColTem-11 SAY REPL('°',80)
	    CambiaBan(lShared,nNroFil+4,nColTem-11)

	    IF !lLocCodigo('cCodigoBan','BAN',ANO->cCodBanAno)
	       cError('NO SE DEFINIO EL BANCO DONDE SE DEBE PAGAR')
	       RETURN NIL
	    ENDIF

	    cNomBan := BAN->cNombreBan
	    cCtaBan := BAN->cNroctaBan

       CASE nNroOpc == 7
	    nLeeIntMor(lShared,nNroFil+5,nColTem-11,ANO->lIntMatAno,;
		       "ANO->nIntMatAno","ANO->nMorMatAno")

       CASE nNroOpc == 8
	    nLeeIntMor(lShared,nNroFil+5,nColTem+20,ANO->lIntPenAno,;
		       "ANO->nIntPenAno","ANO->nMorPenAno")

       CASE nNroOpc == 9
	    cLeeMensaj(lShared,nNroFil+8,0)

       CASE nNroOpc == 10
	    @ nNroFil+11,01 SAY REPL('°',80)
	    GrabarCon(lShared,nNroFil+6,30,nNroFil+11,1,'ANO->cConMatAno')
	    @ nNroFil+11,01 SAY REPL('°',80)

       CASE nNroOpc == 11 .AND. !EMPTY(nMesIni) .AND. !EMPTY(nMesIni)
	    @ nNroFil+14,01 SAY REPL('°',80)
	    GrabarCon(lShared,nNroFil+6,30,nNroFil+14,1,'ANO->cConPenAno')
	    @ nNroFil+14,01 SAY REPL('°',80)

       CASE nNroOpc == 12
	    CambiaTrc(lShared,nNroFil+7,nColTem+20)

	    IF !lLocCodigo('cCodigoTrc','TRC',ANO->cCodTrcAno)
	       cError('NO SE DEFINIO EL TIPO DE RECIBO A FACTURAR')
	       RETURN NIL
	    ENDIF
	    cNomTrc := TRC->cNombreTrc

       CASE nNroOpc == 13 .AND. SCO->lHayNroCon
	    nLeeNroRec(IF(lShared,lShared,!lShared),;
		       nNroFil+2,nColTem+11,cAnoUsr)
       ENDCASE

       IF nNroOpc # 0
	  cSavLin := SAVESCREEN(22,0,22,79)
	  lDetFac(lShared,nNroFil-3,nNroCol,cNomBan,;
		  cCtaBan,nMesIni,nMesFin,cAnoUsr,cNomTrc)
	  RESTSCREEN(22,0,22,79,cSavLin)
       ENDIF

       SET CURSOR OFF
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO DE LA FUNCION..: REVISAR ARCHIVOS DE LA CONTABILIDAD            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/96 JUE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   NOV 14/96 JUE

OBJETIVOS:

1- Revisa y crea los archivos compartidos de la contabilidad

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevisaCont(aP1)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1				    // Parametros del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

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

*>>>>DECLARACION DE VARIABLE
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .T.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL PathAct := ''                  // Path Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE AT("\SIMACONT",PathUno) == 0
	    cError('EL PATH UNO NO ESTA ASIGNADO A LA CONTABILIDAD',PathUno)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DIRECTORIOS DE LA CONTABILIDAD
       PathAct := cPathAct()

       Mdir(PathUno+'\'+PathSis,PathAct)
     *ÀBases

       Mdir(PathUno+'\'+cPatSis,PathAct)
     *ÀDirectorio del A¤o. Ej 2008.diu
*>>>>FIN DIRECTORIOS DE LA CONTABILIDAD

*>>>>CREACION ESTRUCTURAS GENERALES DEL SISTEMA
       DO CASE
       CASE !FILE(PathUno+'\'+PathSis+'\'+fSimaCo) .AND.;
	    !FILE(PathUno+'\'+PathSis+'\'+FilePer) .AND.;
	    !FILE(PathUno+'\'+PathSis+'\'+FileObG) .AND.;
	    !FILE(PathUno+'\'+PathSis+'\'+FileToG) .AND.;
	    !FILE(PathUno+'\'+PathSis+'\'+FileSoG) .AND.;
	    !FILE(PathUno+'\'+cPatSis+'\'+fColPrc) .AND.;
	    !FILE(PathUno+'\'+cPatSis+'\'+fPazEst+cAnoSis+ExtFile) .AND.;
	    !FILE(PathUno+'\'+cPatSis+'\'+fDpzEst+cAnoSis+ExtFile)

************CREACION DE ESTRUCTURAS GENERALES
	      Termometro(0,"CREANDO CONFIGURACION GENERAL DE LA CONTABILIDAD")

	      CreaSimCon(lShared,PathUno+'\'+PathSis,fSimaCo)
	      Termometro(15)

	      CreaDbfPer(lShared,nModCry,PathUno+'\'+PathSis,FilePer)
	      Termometro(30)

	      CreaDbfObG(lShared,nModCry,PathUno+'\'+PathSis,FileObG)
	      Termometro(45)

	      CreaDbfToG(lShared,nModCry,PathUno+'\'+PathSis,FileToG)
	      Termometro(55)

	      CreaDbfSoG(lShared,nModCry,PathUno+'\'+PathSis,FileSoG)
	      Termometro(65)

	      CreaDbfPaz(lShared,nModCry,PathUno+'\'+cPatSis,;
			 fPazEst+cAnoSis+ExtFile)
	      Termometro(70)

	      CreaDbfDpz(lShared,nModCry,PathUno+'\'+cPatSis,;
			 fDpzEst+cAnoSis+ExtFile)
	      Termometro(80)

	      CreaDbfCol(lShared,nModCry,PathUno+'\'+cPatSis,fColPrc)
	      Termometro(100)
************FIN CREACION DE ESTRUCTURAS GENERALES

       OTHERWISE

************RECUPERACION O ACTUALIZACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathUno+'\'+PathSis+'\'+fSimaCo)
		 RecuSimCon(lShared,PathUno+'\'+PathSis,fSimaCo)
	      ELSE
		 nActStrCon(lShared,PathUno+'\'+PathSis,fSimaCo)
	      ENDIF

	      IF !FILE(PathUno+'\'+PathSis+'\'+FilePer)
		 RecuDbfPer(lShared,nModCry,PathUno+'\'+PathSis,FilePer)
	      ELSE
		 nActStrPer(lShared,nModCry,PathUno+'\'+PathSis,FilePer)
	      ENDIF

	      IF !FILE(PathUno+'\'+PathSis+'\'+FileObG)
		 RecuDbfObG(lShared,nModCry,PathUno+'\'+PathSis,FileObG)
	      ELSE
		 nActStrObG(lShared,nModCry,PathUno+'\'+PathSis,FileObG)
	      ENDIF

	      IF !FILE(PathUno+'\'+PathSis+'\'+FileToG)
		 RecuDbfToG(lShared,nModCry,PathUno+'\'+PathSis,FileToG)
	      ELSE
		 nActStrToG(lShared,nModCry,PathUno+'\'+PathSis,FileToG)
	      ENDIF

	      IF !FILE(PathUno+'\'+PathSis+'\'+FileSoG)
		 RecuDbfSoG(lShared,nModCry,PathUno+'\'+PathSis,FileSoG)
	      ELSE
		 nActStrSoG(lShared,nModCry,PathUno+'\'+PathSis,FileSoG)
	      ENDIF

	      IF !FILE(PathUno+'\'+cPatSis+'\'+fPazEst+cAnoSis+ExtFile)
		 RecuDbfPaz(lShared,nModCry,PathUno+'\'+cPatSis,;
			    fPazEst+cAnoSis+ExtFile)
	      ELSE
		 nActStrPaz(lShared,nModCry,PathUno+'\'+cPatSis,;
			    fPazEst+cAnoSis+ExtFile)
	      ENDIF

	      IF !FILE(PathUno+'\'+cPatSis+'\'+fDpzEst+cAnoSis+ExtFile)
		 RecuDbfDpz(lShared,nModCry,PathUno+'\'+cPatSis,;
			    fDpzEst+cAnoSis+ExtFile)
	      ELSE
		 nActStrDpz(lShared,nModCry,PathUno+'\'+cPatSis,;
			    fDpzEst+cAnoSis+ExtFile)
	      ENDIF

	      IF !FILE(PathUno+'\'+cPatSis+'\'+fColPrc)
		 RecuDbfCol(lShared,nModCry,PathUno+'\'+cPatSis,;
			    fColPrc)
	      ELSE
		 nActStrCol(lShared,nModCry,PathUno+'\'+cPatSis,;
			    fColPrc)
	      ENDIF
************FIN RECUPERACION O ACTUALIZACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION ESTRUCTURAS DEL NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	   Mdir(PathUno+'\'+cPatSis+'\'+cMaeAct,PathAct)
	 *ÀDirectorio del Nivel

	  DO CASE
	  CASE !FILE(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		     FileAlu+cMaeAct+cAnoSis+ExtFile) .AND.;
	       !FILE(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		     FileNiv+cAnoSis+ExtFile) .AND.;
	       !FILE(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		     FileGru+cMaeAct+cAnoSis+ExtFile)

***************CREACION ESTRCUTURAS DEL NIVEL
		 Termometro(0,'CREANDO ARCHIVOS DE '+cMaeAct)

		 CreaDbfAlu(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
			    FileAlu+cMaeAct+cAnoSis+ExtFile)
		 Termometro(35)

		 CreaDbfNiv(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
			    FileNiv+cAnoSis+ExtFile,NIL,cMaeAct)
		 Termometro(70)

		 CreaDbfGru(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
			    FileGru+cMaeAct+cAnoSis+ExtFile)
		 Termometro(100)
***************FIN CREACION DE LOS ARCHIVOS

	  OTHERWISE

***************RECUPERACION DE ESTRUCTURAS DEL SISTEMA
		 IF !FILE(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			  FileAlu+cMaeAct+cAnoSis+ExtFile)

		    RecuDbfAlu(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
			       FileAlu+cMaeAct+cAnoSis+ExtFile)
		 ELSE
		    IF lActStrAlu(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
				  FileAlu+cMaeAct+cAnoSis+ExtFile)
		       cError(FileAlu+cMaeAct+cAnoSis+ExtFile+' '+;
			      'ACTUALIZADA SU ESTRUCTURA','ATENCION')
		    ENDIF
		 ENDIF

		 IF !FILE(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			  FileNiv+cAnoSis+ExtFile)

		    RecuDbfNiv(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
			       FileNiv+cAnoSis+ExtFile,NIL,cMaeAct)
		 ELSE
		    nActStrNiv(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
				       FileNiv+cAnoSis+ExtFile,cMaeAct)
		 ENDIF

		 IF !FILE(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			  FileGru+cMaeAct+cAnoSis+ExtFile)

		    RecuDbfGru(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
			       FileGru+cMaeAct+cAnoSis+ExtFile)
		 ELSE
		    nActStrGru(lShared,PathUno+'\'+cPatSis+'\'+cMaeAct,;
				       FileGru+cMaeAct+cAnoSis+ExtFile)
		 ENDIF
***************FIN RECUPERACION DE ESTRUCTURAS DEL SISTEMA

	  ENDCASE

       ENDFOR
       RETURN NIL
*>>>>FIN CREACION ESTRUCTURAS DEL NIVEL

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDA LA EXISTENCIA DEL PLAN ACADEMICO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 08/95 LUN A
       Colombia, Bucaramanga        INICIO: 12:15 AM   MAY 08/95 LUN

OBJETIVOS:

1- Se debe pasar solo un maestro habilitado

2- Valida la existencia de los archivos del plan acad‚mico para el
   correspondiente nivel para permitir la inclusion de grupos

3- Retorna .T. si existen los archivos o NIL si se paso mal el maestro

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lFilesPla(cPatSis,cAnoSis,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     cPatSis                              // Path del sistema
       cAnoSis                              // A¤o del Sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema
       LOCAL lExiste := NIL                // .T. Existen los archivos
       LOCAL cNroNiv := ''                 // N£mero de nivel
       LOCAL       i := 0                  // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE EXISTENCIA DE LOS ARCHIVOS
       DO CASE
       CASE 'JAR' $ cMaeAlu
	    lExiste := .F.
	    FOR i := 11 TO 16
		cNroNiv := STR(i,2)
		lCorrecion(@cNroNiv)
		IF FILE (cPatSis+'\PLAN'+cNroNiv+cAnoSis+ExtFile)
		   lExiste := .T.
		ENDIF
	    ENDFOR

       CASE 'PRI' $ cMaeAlu
	    lExiste := .F.
	    FOR i := 0 TO 5
		cNroNiv := STR(i,2)
		lCorrecion(@cNroNiv)
		IF FILE (cPatSis+'\PLAN'+cNroNiv+cAnoSis+ExtFile)
		   lExiste := .T.
		ENDIF
	    ENDFOR

       CASE 'BTO' $ cMaeAlu
	    lExiste := .F.
	    FOR i := 6 TO 11
		cNroNiv := STR(i,2)
		lCorrecion(@cNroNiv)
		IF FILE (cPatSis+'\PLAN'+cNroNiv+cAnoSis+ExtFile)
		   lExiste := .T.
		ENDIF
	    ENDFOR

       ENDCASE
       RETURN lExiste
*>>>>FIN VALIDACION DE EXISTENCIA DE LOS ARCHIVOS

/*************************************************************************
* TITULO ..: LECTURA DEL COLOR DEL SISTEMA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 23/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:40 PM   SEP 23/2004 JUE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
		    PathClr,FileClr,PathSis,fSimMtr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path General del sistema
       fSimMtr			      // Configuraci¢n del Sistema */
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
       IF !FILE(PathSis+'\'+fSimMtr)
	  CreaDbfMtr(lShared,PathSis,fSimMtr)
       ENDIF
       IF !FILE(PathClr+'\'+FileClr)
	  CreaDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrMtr(lShared,PathSis,fSimMtr)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrClr(lShared,nModCry,PathClr,FileClr)
     *ÀActualizaci¢n de la Configuraci¢n del Colo
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysMtr(lShared,nModCry)
       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR

/*************************************************************************
* TITULO..: PARAMETOS GENERALES DEL SISTEMA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/2007 JUE A
       Bucaramanga, Colombia        INICIO: 06:00 PM   DIC 27/2007 JUE

OBJETIVOS:

1- Lee los parametros generales del sistema en variables locales.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lParam0101(aParams,;
		    lShared,nModCry,cCodSui,cNomSis,;
		    cEmpPal,cNitEmp,cNomEmp,cNomSec,cCodEmp,;
		    cNomUsr,cAnoUsr,cAnoSis,cPatSis,;
		    nFilPal,nFilInf,nColInf,;
		    PathW01,PathW02,PathW03,PathW04,PathW05,;
		    PathW06,PathW07,PathW08,PathW09,PathW10,;
		    PathUno,PathDos,PathTre,PathCua,;
		    cMaeAlu,cMaeAct,cJorTxt,cJornad)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParams                              // Parametros Generales

       lShared                              // @.T. Sistema Compartido
       nModCry                              // @Modo de Protecci¢n
       cCodSui                              // @C¢digo del Sistema
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
       PathW02                              // @Sitio No.02 del Sistema
       PathW03                              // @Sitio No.03 del Sistema
       PathW04                              // @Sitio No.04 del Sistema
       PathW05                              // @Sitio No.05 del Sistema
       PathW06                              // @Sitio No.06 del Sistema
       PathW07                              // @Sitio No.07 del Sistema
       PathW08                              // @Sitio No.08 del Sistema
       PathW09                              // @Sitio No.09 del Sistema
       PathW10                              // @Sitio No.10 del Sistema
     *ÀSitios del Sistema

       PathUno := ''                        // Path de Integraci¢n Uno
       PathDos := ''                        // Path de Integraci¢n Dos
       PathTre := ''                        // Path de Integraci¢n Tres
       PathCua := ''                        // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       cMaeAlu                              // @Maestros habilitados
       cMaeAct                              // @Maestro Activo
       cJorTxt                              // @Jornada escogida
       cJornad                              // @Jornadas habilitadas */
     *ÀDetalles Acad‚micos
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DEL SISTEMA
       lShared := xParams(aParams,'lShared')
       nModCry := xParams(aParams,'nModCry')
       cCodSui := xParams(aParams,'cCodSui')
       cNomSis := xParams(aParams,'cNomSis')

       IF lShared == NIL .OR.;
	  nModCry == NIL .OR.;
	  cCodSui == NIL .OR.;
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
       PathW02 := xParams(aParams,'PathW02')
       PathW03 := xParams(aParams,'PathW03')
       PathW04 := xParams(aParams,'PathW04')
       PathW05 := xParams(aParams,'PathW05')
       PathW06 := xParams(aParams,'PathW06')
       PathW07 := xParams(aParams,'PathW07')
       PathW08 := xParams(aParams,'PathW08')
       PathW09 := xParams(aParams,'PathW09')
       PathW10 := xParams(aParams,'PathW10')

       IF PathW01 == NIL .OR.;
	  PathW02 == NIL .OR.;
	  PathW03 == NIL .OR.;
	  PathW04 == NIL .OR.;
	  PathW05 == NIL .OR.;
	  PathW06 == NIL .OR.;
	  PathW07 == NIL .OR.;
	  PathW08 == NIL .OR.;
	  PathW09 == NIL .OR.;
	  PathW10 == NIL
	  lHayErr := .T.
       ENDIF
*>>>>FIN SITIOS DEL SISTEMA

*>>>>PATH DE INTEGRACION
       PathUno := xParams(aParams,'PathUno')
       PathDos := xParams(aParams,'PathDos')
       PathTre := xParams(aParams,'PathTre')
       PathCua := xParams(aParams,'PathCua')
*>>>>FIN PATH DE INTEGRACION

*>>>>DETALLES ACADEMICOS
       cMaeAlu := xParams(aParams,'cMaeAlu')
       cMaeAct := xParams(aParams,'cMaeAct')
       cJorTxt := xParams(aParams,'cJorTxt')
       cJornad := xParams(aParams,'cJornad')

       IF cMaeAlu == NIL .OR.;
	  cMaeAct == NIL .OR.;
	  cJorTxt == NIL
	  lHayErr := .T.
       ENDIF
       RETURN !lHayErr
*>>>>FIN DETALLES ACADEMICOS

