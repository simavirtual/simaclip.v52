/*                      SIMA - CONTABILIDAD PROFESORES
		     BIBLIOTECAS DE FUNCIONES GENERALES

REQUERIMIENTOS:

- Compilar: clipper ProfeFun /w/m/b

OBJETIVOS:

- Funciones aplicadas para los procesos que las requieran

FUNCIONES:

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "EPSONFX.PRG"
*>>>>FIN DECLARACION DE CONSTANTES

/*************************************************************************
* TITULO DE LA FUNCION..: INICIALIZACION PARAMETROS DE LA APLICACION     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/96 VIE A
       Colombia, Bucaramanga        INICIO: 05:10 PM   MAR 08/96 VIE

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
* TITULO DE LA FUNCION..: CREACION DE LOS ARCHIVOS DEL SISTEMAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/96 VIE A
       Colombia, Bucaramanga        INICIO: 05:13 PM   MAR 08/96 VIE


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

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // Crear Estructuras

       LOCAL       i := 0                   // Contador
       LOCAL bInfSys := NIL                 // Block Informes del Sistema

       LOCAL cPatFil := ''                  // Path del archivo
       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL PathAct := ''                  // Path Actual
       LOCAL PathWww := ''		    // Path del Sitio */

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
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // .T. SimaProf en Usb. .F. SimaProf en la Red
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DIRECTORIOS DEL SISTEMA
       PathAct := cPathAct()

       Mdir(cPatSis,PathAct)
     *ÀDirectorio del A¤o. Ej 2007.diu

       Mdir(PathPrn,PathAct)
     *ÀPrinter

       Mdir(PathDoc,PathAct)
     *ÀMis Documentos

       Mdir(PathWeb+'\IMG',PathAct)
     *ÀSimaWeb. General
*>>>>FIN DIRECTORIOS DEL SISTEMA

*>>>>SITIOS DEL SISTEMA No.1
       PathWww := xParams(aP1,'PathW01')
       IF !('sitio01' $ PathWww)

	  Mdir(PathWww+'\IMG',PathAct)
	*ÀCreaci¢n del Directorio

	  InfPrnXsl(PathWww+'\IMG')
	*ÀArchivo XSL informes.
       ENDIF
*>>>>FIN SITIOS DEL SISTEMA No.1

*>>>>DIRECTORIOS DE NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3
	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   Mdir(cPatSis+'\'+cMaeAct,PathAct)
       NEXT
*>>>>FIN DIRECTORIOS DE NIVEL

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       bInfSys := {||SprInfSys(lShared,cNomUsr,cCodSui)}
       SET CURSOR OFF
       IF !FILE(PathSis+'\'+FilePrn) .AND.;
	  !FILE(PathSis+'\'+fSimSpr) .AND.;
	  !FILE(PathSis+'\'+FileInf) .AND.;
	  !FILE(PathSis+'\'+FileIso)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  CreaDbfSys(lShared,cPatSis,cAnoUsr,bInfSys)
       ENDIF
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION DE LAS ESTRUCTURAS ESPECIFICAS DEL SISTEMA
       lHayErr := .F.
       IF 'GUA' $ cMaeAlu
	  IF FILE(cPatSis+'\GUA\'+FileInd+'GUA'+ExtFile) .AND.;
	     FILE(cPatSis+'\GUA\'+fProTbl+'GUA'+ExtFile)
	     lHayErr := .T.
	  ENDIF
       ENDIF

       IF 'JAR' $ cMaeAlu
	  IF FILE(cPatSis+'\JAR\'+FileInd+'JAR'+ExtFile) .AND.;
	     FILE(cPatSis+'\JAR\'+fProTbl+'JAR'+ExtFile)
	     lHayErr := .T.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu
	  IF FILE(cPatSis+'\PRI\'+FileInd+'PRI'+ExtFile) .AND.;
	     FILE(cPatSis+'\PRI\'+fProTbl+'PRI'+ExtFile)
	     lHayErr := .T.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu
	  IF FILE(cPatSis+'\BTO\'+FileInd+'BTO'+ExtFile) .AND.;
	     FILE(cPatSis+'\BTO\'+fProTbl+'BTO'+ExtFile)
	     lHayErr := .T.
	  ENDIF
       ENDIF

       IF !lHayErr
	 RESTSCREEN(0,0,24,79,cSavPan)
	 CrearDbfs(lShared,cPatSis,cAnoUsr,cMaeAlu)
       ENDIF
*>>>>FIN CREACION DE LAS ESTRUCTURAS ESPECIFICAS DEL SISTEMA

*>>>>RECUPERACION DE LAS ESTRUCTURAS
       IF lHayErr

**********RECUPERACION DE ESTRUCTURAS DEL SISTEMA
	    IF !FILE(PathSis+'\'+FilePrn)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RecuDbfPrn(lShared,nModCry,PathSis,FilePrn)
	    ENDIF

	    IF !FILE(PathSis+'\'+fSimSpr)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RecuSimSpr(lShared,nModCry,PathSis,fSimSpr)
	    ENDIF

	    IF !FILE(PathSis+'\'+FileInf)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RecuDbfInf(lShared,nModCry,PathSis,FileInf,bInfSys)
	    ENDIF

	    IF !FILE(PathSis+'\'+FileIso)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RecuDbfIso(lShared,nModCry,PathSis,FileIso)
	    ENDIF

	    IF !FILE(cPatSis+'\'+fSprAno+cAnoUsr+ExtFile)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RecuSprAno(lShared,nModCry,cPatSis,fSprAno+cAnoUsr+ExtFile)
	    ENDIF
**********FIN RECUPERACION DE ESTRUCTURAS DEL SISTEMA

**********RECUPERACION DE ESTRUCTURAS DE GUARDERIA
	    IF 'GUA' $ cMaeAlu
	       cPatTem := cPatSis+'\GUA'
	       IF !FILE(cPatTem+'\'+FileInd+'GUA'+ExtFile)
		  RecuDbfInd(lShared,nModCry,cPatTem,FileInd+'GUA'+ExtFile)
	       ENDIF

	       IF !FILE(cPatTem+'\'+fProTbl+'GUA'+ExtFile)
		  RecuProTbl(lShared,nModCry,cPatTem,fProTbl+'GUA'+ExtFile)
	       ENDIF
	       IF nActStrInd(lShared,nModCry,cPatTem,FileInd+'GUA'+ExtFile) == 0
		  lndexar := .T.
	       ENDIF
	       nActProTbl(lShared,nModCry,cPatSis+'\'+'GUA',FProTbl+'GUA'+ExtFile)
	    ENDIF
**********FIN RECUPERACION DE ESTRUCTURAS DE GUARDERIA

**********RECUPERACION DE ESTRUCTURAS DE JARDIN
	    IF 'JAR' $ cMaeAlu
	       cPatTem := cPatSis+'\JAR'
	       IF !FILE(cPatTem+'\'+FileInd+'JAR'+ExtFile)
		  RecuDbfInd(lShared,nModCry,cPatTem,FileInd+'JAR'+ExtFile)
	       ENDIF

	       IF !FILE(cPatTem+'\'+fProTbl+'JAR'+ExtFile)
		  RecuProTbl(lShared,nModCry,cPatTem,fProTbl+'JAR'+ExtFile)
	       ENDIF
	       IF nActStrInd(lShared,nModCry,cPatTem,FileInd+'JAR'+ExtFile) == 0
		  lndexar := .T.
	       ENDIF
	       nActProTbl(lShared,nModCry,cPatSis+'\'+'JAR',FProTbl+'JAR'+ExtFile)
	    ENDIF
**********FIN RECUPERACION DE ESTRUCTURAS DE JARDIN

**********RECUPERACION DE ESTRUCTURAS DE PRIMARIA
	    IF 'PRI' $ cMaeAlu
	       cPatTem := cPatSis+'\PRI'
	       IF !FILE(cPatTem+'\'+FileInd+'PRI'+ExtFile)
		  RecuDbfInd(lShared,nModCry,cPatTem,FileInd+'PRI'+ExtFile)
	       ENDIF

	       IF !FILE(cPatTem+'\'+fProTbl+'PRI'+ExtFile)
		  RecuProTbl(lShared,nModCry,cPatTem,fProTbl+'PRI'+ExtFile)
	       ENDIF
	       IF nActStrInd(lShared,nModCry,cPatTem,FileInd+'PRI'+ExtFile) == 0
		  lndexar := .T.
	       ENDIF
	       nActProTbl(lShared,nModCry,cPatSis+'\'+'PRI',FProTbl+'PRI'+ExtFile)
	    ENDIF
**********FIN RECUPERACION DE ESTRUCTURAS DE PRIMARIA

**********RECUPERACION DE ESTRUCTURAS DE BACHILLERATO
	    IF 'BTO' $ cMaeAlu
	       cPatTem := cPatSis+'\BTO'
	       IF !FILE(cPatTem+'\'+FileInd+'BTO'+ExtFile)
		  RecuDbfInd(lShared,nModCry,cPatTem,FileInd+'BTO'+ExtFile)
	       ENDIF

	       IF !FILE(cPatTem+'\'+fProTbl+'BTO'+ExtFile)
		  RecuProTbl(lShared,nModCry,cPatTem,fProTbl+'BTO'+ExtFile)
	       ENDIF

	       IF nActStrInd(lShared,nModCry,cPatTem,FileInd+'BTO'+ExtFile) == 0
		  lndexar := .T.
	       ENDIF
	       nActProTbl(lShared,nModCry,cPatSis+'\'+'BTO',FProTbl+'BTO'+ExtFile)
	    ENDIF
**********FIN RECUPERACION DE ESTRUCTURAS DE BACHILLERATO

       ENDIF
*>>>>RECUPERACION DE LAS ESTRUCTURAS

*>>>>ACTUALIZACION DE ESTRUCTURAS
       SET EXACT      ON                    // Busqueda Exacta

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActStrInf(lShared,nModCry,PathSis,FileInf)
     *ÀActualizacion. Informes del sistema

       nActStrIso(lShared,nModCry,PathSis,FileIso)
     *ÀActualizacion de Archios de documentos a imprimir

       nActSprAno(lShared,nModCry,cPatSis,fSprAno+cAnoUsr+ExtFile)
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS

*>>>>VALIDACION DE LOS INDICES
       IF !lndexar

	  FOR i := 1 TO LEN(cMaeAlu)/3

	      cMaeAct := SUBS(cMaeAlu,i*3-2,3)

**************INDICE MAESTRO DE ESTUDIANTES
		fNtxTem := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			   fNtxAlu+cMaeAct+cAnoSis+cExtNtx
		IF !FILE(fNtxTem)
		   lndexar := .T.
		   EXIT
		ENDIF
**************FIN INDICE MAESTRO DE ESTUDIANTES

**************INDICE DE INDICADORES
		fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
			   fNtxInd+cMaeAct+cExtNtx
		IF !FILE(fNtxTem)
		   lndexar := .T.
		   EXIT
		ENDIF
**************FIN INDICE DE INDICADORES

	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LOS INDICES

*>>>>REVISION DE ESTRUCTURAS COMPARTIDAS
       IF lMemUsb
	  UsbDdfCont(aP1,@lndexar)
	  RevisarUsb(aP1,cSavPan)
       ENDIF
*>>>>FIN REVISION DE ESTRUCTURAS COMPARTIDAS

*>>>>CREACION DE LOS INDICES
       SET EXACT      OFF                   // Busqueda no exacta
       IF lndexar
	  RESTSCREEN(0,0,24,79,cSavPan)
	  Indexar(aP1)
       ENDIF
*>>>>FIN CREACION DE LOS INDICES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared)
	  CloseDbf('SPR',PathSis+'\'+fSimSpr)
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       FileTem := cFileTempo(PathPrn+'\','PROF','.PRN')
       IF SPR->lPrnArcSpr
	  SET PRINTER TO &FileTem              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       CloseDbf('SPR',PathSis+'\'+fSimSpr)
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

*>>>>CREACION DE SITIOS DEL SISTEMA
*       InfPrnXsl()  // Pendiente por definir

       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE SITIOS DEL SISTEMA


/*************************************************************************
* TITULO DE LA FUNCION..: CREACION ARCHIVOS GENERALES DEL SISTEMA        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 14/96 MIE A
       Colombia, Bucaramanga        INICIO: 01:45 PM   MAY 14/96 MIE

OBJETIVOS:

1)- Crea todos los archivos generales del sistema

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,cPatSis,cAnoUsr,bInfSys)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       bInfSys                              // Block Informes del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS GENERALES DEL SISTEMA")

       Termometro(35)
       CreaDbfPrn(lShared,nModCry,PathSis,FilePrn)

       Termometro(70)
       CreaSimSpr(lShared,nModCry,PathSis,fSimSpr)

       Termometro(80)
       CreaDbfInf(lShared,nModCry,PathSis,FileInf,bInfSys)

       Termometro(100)
       CreaDbfIso(lShared,nModCry,PathSis,FileIso)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION ARCHIVOS ESPECIFICOS DEL SISTEMA      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/96 VIE A
       Colombia, Bucaramanga        INICIO: 05:20 PM   MAR 08/96 VIE

OBJETIVOS:

1)- Crea todos los archivos especificos del sistema

2)- Retorna NIL

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbfs(lShared,cPatSis,cAnoUsr,cMaeAlu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       cAnoSis                              // A¤o del sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS ESPECIFICOS DEL SISTEMA")

       Termometro(100)
       CreaSprAno(lShared,nModCry,cPatSis,fSprAno+cAnoUsr+ExtFile)


*******ESTRUCTURAS DE GUARDERIA
	 IF 'GUA' $ cMaeAlu
	    Termometro(0,"CREANDO LOS ARCHIVOS DE GUARDERIA")
	    cPatTem := cPatSis+'\GUA'

	    Termometro(50)
	    IF !FILE(cPatTem+'\'+FileInd+'GUA'+ExtFile)
	       CreaDbfInd(lShared,nModCry,cPatTem,FileInd+'GUA'+ExtFile)
	    ENDIF

	    Termometro(100)
	    IF !FILE(cPatTem+'\'+fProTbl+'GUA'+ExtFile)
	       CreaProTbl(lShared,nModCry,cPatTem,fProTbl+'GUA'+ExtFile)
	    ENDIF
	 ENDIF
*******FIN ESTRUCTURAS DE GUARDERIA

*******ESTRUCTURAS DE JARDIN
	 IF 'JAR' $ cMaeAlu
	    Termometro(0,"CREANDO LOS ARCHIVOS DE JARDIN")
	    cPatTem := cPatSis+'\JAR'

	    Termometro(50)
	    IF !FILE(cPatTem+'\'+FileInd+'JAR'+ExtFile)
	       CreaDbfInd(lShared,nModCry,cPatTem,FileInd+'JAR'+ExtFile)
	    ENDIF

	    Termometro(100)
	    IF !FILE(cPatTem+'\'+fProTbl+'JAR'+ExtFile)
	       CreaProTbl(lShared,nModCry,cPatTem,fProTbl+'JAR'+ExtFile)
	    ENDIF
	 ENDIF
*******FIN ESTRUCTURAS DE JARDIN

*******ESTRUCTURAS DE PRIMARIA
	 IF 'PRI' $ cMaeAlu
	    Termometro(0,"CREANDO LOS ARCHIVOS DE PRIMARIA")
	    cPatTem := cPatSis+'\PRI'

	    Termometro(50)
	    IF !FILE(cPatTem+'\'+FileInd+'PRI'+ExtFile)
	       CreaDbfInd(lShared,nModCry,cPatTem,FileInd+'PRI'+ExtFile)
	    ENDIF

	    Termometro(100)
	    IF !FILE(cPatTem+'\'+fProTbl+'PRI'+ExtFile)
	       CreaProTbl(lShared,nModCry,cPatTem,fProTbl+'PRI'+ExtFile)
	    ENDIF
	 ENDIF
*******FIN ESTRUCTURAS DE PRIMARIA

*******ESTRUCTURAS DE BACHILLERATO
	 IF 'BTO' $ cMaeAlu
	    Termometro(0,"CREANDO LOS ARCHIVOS DE BACHILLERATO")
	    cPatTem := cPatSis+'\BTO'

	    Termometro(50)
	    IF !FILE(cPatTem+'\'+FileInd+'BTO'+ExtFile)
	       CreaDbfInd(lShared,nModCry,cPatTem,FileInd+'BTO'+ExtFile)
	    ENDIF

	    Termometro(100)
	    IF !FILE(cPatTem+'\'+fProTbl+'BTO'+ExtFile)
	       CreaProTbl(lShared,nModCry,cPatTem,fProTbl+'BTO'+ExtFile)
	    ENDIF
	 ENDIF
*******FIN ESTRUCTURAS DE BACHILLERATO

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS DEL SISTEMA


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

FUNCTION Indexar(aP1)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cPatFil := ''                  // Path de archivo
       LOCAL lIndNiv := ''                  // .T. Indicador de Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
     *ÀDetalles del Sistema

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
     *ÀDetalles Acad‚micos

       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // .T. SimaProf en Usb. .F. SimaProf en la Red
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>CREACION DE INDICES DE JARDIN
       IF 'JAR' $ cMaeAlu

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\JAR\'+;
			FileInd+'JAR'+ExtFile,'IND',NIL,lShared) .OR.;
	       !lUseDbf(.T.,PathUno+'\'+cPatSis+'\JAR\'+;
			    FConTbl+'JAR'+ExtFile,'TCO',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO INDICADORES EN '+cPatSis)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********CREACION DEL INDICE DEL INDICADOR
	    Termometro(0,'INDEXANDO EL ARCHIVO DE INDICADORES DE JARDIN')
	    Termometro(100)
	    SELECT IND
	    IF TCO->lIndNivTbl
	       INDEX ON IND->cCodigoNiv+IND->cCodigoJui;
		     TO &(cPatSis+'\JAR\'+fNtxInd+'JAR'+cExtNtx)
	    ELSE
	       INDEX ON IND->cCodigoJui;
		     TO &(cPatSis+'\JAR\'+fNtxInd+'JAR'+cExtNtx)
	    ENDIF
	    CloseDbf('IND')
**********FIN CREACION DEL INDICE DEL INDICADOR

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\JAR\'+;
			FileInd+'JAR'+cAnoSis+ExtFile,'JUI',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO INDICADORES EN '+;
		      PathUno+'\'+cPatSis)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********CREACION DEL INDICE DEL INDICADOR
	    Termometro(0,'INDEXANDO EL ARCHIVO DE INDICADORES '+;
			 'DE JARDIN COMPARTIDO')
	    Termometro(100)
	    SELECT JUI
	    IF TCO->lIndNivTbl
	       INDEX ON JUI->cCodigoNiv+JUI->cCodigoJui;
		     TO &(PathUno+'\'+cPatSis+'\JAR\'+fNtxInd+'JAR'+cAnoSis+cExtNtx)
	    ELSE
	       INDEX ON JUI->cCodigoJui;
		     TO &(PathUno+'\'+cPatSis+'\JAR\'+fNtxInd+'JAR'+cAnoSis+cExtNtx)
	    ENDIF
	    CloseDbf('JUI')
	    CloseDbf('TCO')
**********FIN CREACION DEL INDICE DEL INDICADOR

       ENDIF
*>>>>FIN CREACION DE INDICES DE JARDIN

*>>>>CREACION DE INDICES DE PRIMARIA
       IF 'PRI' $ cMaeAlu

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\PRI\'+;
			FileInd+'PRI'+ExtFile,'IND',NIL,lShared) .OR.;
	       !lUseDbf(.T.,PathUno+'\'+cPatSis+'\PRI\'+;
			    FConTbl+'PRI'+ExtFile,'TCO',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO INDICADORES EN '+cPatSis)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********CREACION DEL INDICE DEL INDICADOR
	    Termometro(0,'INDEXANDO EL ARCHIVO DE INDICADORES DE PRIMARIA')
	    Termometro(100)
	    SELECT IND
	    IF TCO->lIndNivTbl
	       INDEX ON IND->cCodigoNiv+IND->cCodigoJui;
		     TO &(cPatSis+'\PRI\'+fNtxInd+'PRI'+cExtNtx)
	    ELSE
	       INDEX ON IND->cCodigoJui;
		     TO &(cPatSis+'\PRI\'+fNtxInd+'PRI'+cExtNtx)
	    ENDIF
	    CloseDbf('IND')
**********FIN CREACION DEL INDICE DEL INDICADOR

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\PRI\'+;
			FileInd+'PRI'+cAnoSis+ExtFile,'JUI',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO INDICADORES EN '+cPatSis)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********CREACION DEL INDICE DEL INDICADOR
	    Termometro(0,'INDEXANDO EL ARCHIVO DE INDICADORES '+;
			 'DE PRIMARIA COMPARTIDOS')
	    Termometro(100)
	    SELECT JUI
	    IF TCO->lIndNivTbl
	       INDEX ON JUI->cCodigoNiv+JUI->cCodigoJui;
		     TO &(PathUno+'\'+cPatSis+'\PRI\'+fNtxInd+'PRI'+cAnoSis+cExtNtx)
	    ELSE
	       INDEX ON JUI->cCodigoJui;
		     TO &(PathUno+'\'+cPatSis+'\PRI\'+fNtxInd+'PRI'+cAnoSis+cExtNtx)
	    ENDIF
	    CloseDbf('JUI')
	    CloseDbf('TCO')
**********FIN CREACION DEL INDICE DEL INDICADOR

       ENDIF
*>>>>FIN CREACION DE INDICES DE PRIMARIA

*>>>>CREACION DE INDICES DE BACHILLERATO
       IF 'BTO' $ cMaeAlu

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\BTO\'+;
			FileInd+'BTO'+ExtFile,'IND',NIL,lShared) .OR.;
	       !lUseDbf(.T.,PathUno+'\'+cPatSis+'\BTO\'+;
			    FConTbl+'BTO'+ExtFile,'TCO',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO INDICADORES EN '+cPatSis)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********CREACION DEL INDICE DEL INDICADOR
	    Termometro(0,'INDEXANDO EL ARCHIVO DE INDICADORES DE BACHILLERATO')
	    Termometro(100)
	    SELECT IND
	    IF TCO->lIndNivTbl
	       INDEX ON IND->cCodigoNiv+IND->cCodigoJui;
		     TO &(cPatSis+'\BTO\'+fNtxInd+'BTO'+cExtNtx)
	    ELSE
	       INDEX ON IND->cCodigoJui;
		     TO &(cPatSis+'\BTO\'+fNtxInd+'BTO'+cExtNtx)
	    ENDIF
	    CloseDbf('IND')
**********FIN CREACION DEL INDICE DEL INDICADOR

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\BTO\'+;
			FileInd+'BTO'+cAnoSis+ExtFile,'JUI',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO INDICADORES EN '+cPatSis)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********CREACION DEL INDICE DEL INDICADOR
	    Termometro(0,'INDEXANDO EL ARCHIVO DE INDICADORES '+;
			 'DE BACHILLERATO COMPARTIDO')
	    Termometro(100)
	    SELECT JUI
	    IF TCO->lIndNivTbl
	       INDEX ON JUI->cCodigoNiv+JUI->cCodigoJui;
		     TO &(PathUno+'\'+cPatSis+'\BTO\'+fNtxInd+'BTO'+cAnoSis+cExtNtx)
	    ELSE
	       INDEX ON JUI->cCodigoJui;
		     TO &(PathUno+'\'+cPatSis+'\BTO\'+fNtxInd+'BTO'+cAnoSis+cExtNtx)
	    ENDIF
	    CloseDbf('JUI')
	    CloseDbf('TCO')
**********FIN CREACION DEL INDICE DEL INDICADOR

       ENDIF
*>>>>FIN CREACION DE INDICES DE BACHILLERATO

*>>>>CREACION DE LOS INDICES COMPARTIDOS
       NtxAlu(lShared,PathUno,cPatSis,cAnoSis,cMaeAlu,lMemUsb)

       CLOSE ALL
       RETURN NIL
*>>>>FIN CREACION DE LOS INDICES COMPARTIDOS

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DE LOS MENUS DE LA APLICACION       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/96 VIE A
       Colombia, Bucaramanga        INICIO: 05:25 PM   MAR 08/96 VIE

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

FUNCTION aMenusProf(nNroOpc,cDerech,aAyudas,lMemUsb)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroOpc			            // N£mero de Opci¢n
       cDerech                              // Derechos a los Menus
       aAyudas                              // @Vector de Ayudas escogidas
       lMemUsb                              // .T. SimaProf en Usb. .F. SimaProf en la Red */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"        // Archivos del Sistema

       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyuda  := {}                  // Declaraci¢n de Ayudas
       LOCAL aMenuss := {}                  // Men£ escogido
       LOCAL     i,j := 0                   // Contadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENUS
       lMemUsb := IF(lMemUsb==NIL,.F.,lMemUsb)
       DO CASE
       CASE nNroOpc == 0

	    aMenus  := {'1LISTAS',;
			'2LOGROS',;
			'3EVALUAR',;
			'4RECUPERACIONES',;
			'5INDICADORES',;
			'6CONSULTAS',;
			'7UTILIDADES'}

	    aAyuda  := {'Permite Imprimir los informes. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite Aplicar,Consultar y Corregir '+;
			'los indicadores. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite Evaluar,Consultar y Corregir '+;
			'los indicadores. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite crear los indicadores a evaluar. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite controlar las recuperaciones. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite realizar diferentes consultas al sistema. '+;
			'<ESC> TERMINA EL PROGRAMA',;
			'Permite Ejecutar varias utilidades del sistema. '+;
			'<ESC> TERMINA EL PROGRAMA'}

       CASE nNroOpc == 1  // Listas

	    aMenus  := {'1<LISTAS DE CLASE        >',;
			'2<INDICADORES DEFINITIVOS>',;
			'3<INDICADORES APLICADOS  >',;
			'4<GRABAR ESTUDIANTES     >',;
			'5<SOLO NOMBRES           >',;
			'6<HOJA DEL OBSERVADOR    >',;
			'7<ACTUALIZAR DIRECTORIO  >',;
			'8<PAZ Y SALVOS           >',;
			'9<CONTROL DE AUSENCIAS   >'}

	    aAyuda  := {'Imprime las listas de Clase.',;
			'Imprime la lista de logros e indicadores definitivos',;
			'Imprime el resumen de Indicadores Aplicados',;
			'Permite Escoger los Estudiantes a los que le dicta.',;
			'Imprime las listas de clase con solo los nombres de los estudiante',;
			'Imprime en el formato de la Hoja del Observador',;
			'Permite Actualizar el Directorio de Estudiantes',;
			'Permite Grabar los Paz y Salvos de los Estudiantes',;
			'Imprime las listas para control de ausencias'}

       CASE nNroOpc == 2  // Logros

	    aMenus  := {'1<APLICAR  >',;
			'2<MODIFICAR>',;
			'3<CONSULTAR>',;
			'4<IMPRIMIR >',;
			'5<AUSENCIAS>',;
			'6<POR GRUPO>'}

	    aAyuda := {'Permite aplicar logros por Estudiante',;
		       'Permite Modificar los logros a cada Estudiante',;
		       'Permite Consultar los logros a cada Estudiante',;
		       'Imprime los Indicadores aplicados a cada Estudiante',;
		       'Permite grabar las Ausencias de los Estudiantes',;
		       'Permite aplicar logros por Grupo'}


       CASE nNroOpc == 3  // Evaluar

	    aMenus := {}
	    AADD(aMenus,'1<EVALUAR  >')
	    AADD(aMenus,'2<MODIFICAR>')
	    AADD(aMenus,'3<CONSULTAR>')
	    AADD(aMenus,'4<IMPRIMIR >')
	    AADD(aMenus,'5<AUSENCIAS>')
	    AADD(aMenus,'6<POR GRUPO>')

*	    AADD(aMenus,'7<APLICAR  >')
	    AADD(aMenus,'7<MOD INDIC>')
	    AADD(aMenus,'8<SOLO NOTA>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite evaluar logros por Estudiante')
	    AADD(aAyuda,'Permite Modificar los logros a cada Estudiante')
	    AADD(aAyuda,'Permite Consultar los logros a cada Estudiante')
	    AADD(aAyuda,'Permite Imprimir los logros aplicados a cada Estudiante')
	    AADD(aAyuda,'Permite grabar las Ausencias de los Estudiantes')
	    AADD(aAyuda,'Permite evaluar logros por Grupo')

*	    AADD(aAyuda,'Permite aplicar los logros que se van a evaluar')
	    AADD(aAyuda,'Permite modificar los c¢digos de los indicadores aplicados por grupos')
	    AADD(aAyuda,'Permite grabar solo la nota final sin indicadores')

       CASE nNroOpc == 4  // Recuperaciones

	    aMenus  := {'1<RECUPERAR>',;
			'2<CONSULTAR>',;
			'3<IMPRIMIR >',;
			'4<MODIFICAR>'}

	    aAyuda := {'Permite definir las recuparaciones',;
		       'Permite Consultar las recuperaciones',;
		       'Imprime las Recuperaciones Pendientes',;
		       'Permite Modificar las Recuperaciones'}

       CASE nNroOpc == 5

	    aMenus := {}
	    AADD(aMenus,'1<CREAR     >')
	    AADD(aMenus,'2<CONSULTAR >')
	    AADD(aMenus,'3<MODIFICAR >')
	    AADD(aMenus,'4<IMPRIMIR  >')
	    AADD(aMenus,'5<CAMBIAR   >')
	    AADD(aMenus,'6<TRASLADAR1>')
	    AADD(aMenus,'7<TRASLADAR2>')
	    AADD(aMenus,'8<ASOCIAR   >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite crear los Logros e Indicadores')
	    AADD(aAyuda,'Permite Consultar los Logros e indicadores')
	    AADD(aAyuda,'Permite Modificar los Logros e Indicadores')
	    AADD(aAyuda,'Imprime los Logrso e Indicadores parciales')
	    AADD(aAyuda,'Permite modificar los Logros e Indicadores finales')
	    AADD(aAyuda,'Permite trasladar UNO a UNO los Logros e Indicadores del a¤o anterior')
	    AADD(aAyuda,'Permite trasladar TODOS los Logros e Indicadores del a¤o anterior')
	    AADD(aAyuda,'Permite asociar los Indicadores a los Logros')

       CASE nNroOpc == 6

/*
	    aMenus  := {"1<CARGA ACADEMICA>",;
			"2<USO DEL SISTEMA>"}

	    aAyuda  := {"Permite Consultar la Carga Acad‚mica",;
			"Permite Consultar el Uso del Sistema"}
*/

	    aMenus  := {"1<CARGA ACADEMICA>",;
			"2<CLASIFICAR     >"}

	    aAyuda  := {"Permite Consultar la Carga Acad‚mica",;
			"Permite Clasificar los Logros e Indicadores"}


       CASE nNroOpc == 7

	    lMemUsb := .T.

	    aMenus := {}
	    AADD(aMenus,'1<USUARIOS      >')
	    AADD(aMenus,'2<CAMBIAR CLAVE >')
	    AADD(aMenus,'3<REINDEXAR     >')
	    AADD(aMenus,'4<ACTUALIZAR    >')
	    AADD(aMenus,'5<MANTENIMIENTO >')
	    AADD(aMenus,'6<CONFIGURACION >')
	    AADD(aMenus,'7<VARIOS        >')
	    AADD(aMenus,'8<CLAVE PROFESOR>')
	    IF !lMemUsb
	       AADD(aMenus,'9<SIMAUSB       >')
	    ENDIF

	    aAyuda := {}
	    AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
	    AADD(aAyuda,'Permite cambiar la clave')
	    AADD(aAyuda,'Reindexa los archivos del Sistema')
	    AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
	    AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
	    AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
	    AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')
	    AADD(aAyuda,'Permite Cambiar la clave del Profesor')
	    IF !lMemUsb
	       AADD(aAyuda,'Sistema Acad‚mico para trabajo en USB')
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
* TITULO DE LA FUNCION......: EJECUCION MENUS PRIMER NIVEL               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/96 VIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   MAR 08/96 VIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubMenus(aP1,;
		  nOpcion,nOpcPal,aColSup,cDerech,;
		  nColAno,cSavPan,lMemUsb,cCodPro,;
		  cPatPro,cNomPro)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       aColSup                              // Columnas para los sub_men£s
       cDerech                              // Derechos en el sistema
       nColAno                              // Columna A¤o del sistema
       cSavPan                              // Salvar Pantalla
       lMemUsb                              // .T. SimaProf en Usb. .F. SimaProf en la Red
       cCodPro                              // C¢digo del Profesor
       cPatPro                              // Path del Profesor
       cNomPro                              // Nombre del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>PARAMETROS GENERALES
       LOCAL aP2 := {}                      // Parametros Generales
       LOCAL aP3 := {}                      // Parametros Generales
*>>>>FIN PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

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
       LOCAL cSubInd := ''                  // Sub Indicadores. space(02) = No Clasificaci¢n 01=Clasificaci¢n de los indicadores
       LOCAL cOpcInd := ''                  // Sub Indicadores.
       LOCAL nMetRec := 0                   // M‚todo para las recuperaciones

       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado

       LOCAL cDerSys := ''                  // Derechos del Sistema

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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FProTbl+cMaeAct+ExtFile,'TPR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE PRA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE TPR->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL NIVEL')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DETALLES DE CONFIGURACION
       nPerAct := TCO->nPerActTbl
       cSubInd := TPR->cSubIndTbl
       cDerSys := PRA->cDerechAno
       cJvfCal := SUBS(TPR->cJvfCalTbl,nPerAct*3-2,3)
       nMetRec := TPR->nMetRecTbl
       CloseAll()
*>>>>FIN DETALLES DE CONFIGURACION

*>>>>EJECUCION DEL PRIMER NIVEL
       cDerech := cDerSprAno(cDerech,cDerSys)
       DO WHILE .T.

**********LECTURA DE PATHS
	    PathSprAno(lShared,nModCry,cAnoUsr,cPatSis,;
		       @PathUno,@PathDos,@PathTre,@PathCua)
	  *ÀLectura de paths

	    nParameSet(aP1,'PathUno',PathUno)
	    nParameSet(aP1,'PathDos',PathDos)
	    nParameSet(aP1,'PathTre',PathTre)
	    nParameSet(aP1,'PathCua',PathCua)
**********FIN LECTURA DE PATHS

**********PERIODO ACTUAL
	    IF nPerAct <> 0
	       @ nFilPal,65 SAY 'Peri¢do No: '+STR(nPerAct,1)
	    ENDIF
**********FIN PERIODO ACTUAL

**********SELECCION DE LOS SUBMENUS
	    CloseAll()
	    lSiMenu := .T.
	    aDeMenu := aMenusProf(nOpcPal,;
				  SUBS(cDerech,nOpcPal*10-9,10),@aHelp,;
				  lMemUsb)
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
		      Profe_101(aP1,aP2,aP3)
		    *Impresi¢n listas de Clase

		 CASE nNroOpc == 2
		      Profe_102(aP1,aP2,aP3)
		     *Lista de Indicadores

		 CASE nNroOpc == 3
		      Profe_103(aP1,aP2,aP3)
		    *Resumen de logros.

		 CASE nNroOpc == 4
		      Profe_104(aP1,aP2,aP3)
		     *Selecci¢n de Estudiantes

		 CASE nNroOpc == 5
		      Profe_105(aP1,aP2,aP3)
		    *Listas de Clase con solo nombres de los estudiantes.

		 CASE nNroOpc == 6
		      Profe_106(aP1,aP2,aP3)
		     *Hoja del Observador

		 CASE nNroOpc == 7
		      Profe_107(aP1,aP2,aP3)
		     *Actualizar el Directorio

		 CASE nNroOpc == 8
		      Profe_108(aP1,aP2,aP3)
		     *Registro de Paz y Salvo

		 CASE nNroOpc == 9
		      Profe_109(aP1,aP2,aP3)
		    *Impresi¢n Control de Ausencias

		 ENDCASE

	    CASE nOpcPal == 2

		 DO CASE
		 CASE nNroOpc == 1
		      Profe_201(aP1,aP2,aP3)
		    *Grabacci¢n de logros por estudiante

		 CASE nNroOpc == 2
		      Profe_202(aP1,aP2,aP3)
		    *Modificaci¢n de logros

		 CASE nNroOpc == 3
		      Profe_203(aP1,aP2,aP3)
		    *Consulta de logros

		 CASE nNroOpc == 4
		      Profe_204(aP1,aP2,aP3)
		    *Impresion de logros

		 CASE nNroOpc == 5
		      Profe_205(aP1,aP2,aP3)
		    *Grabaci¢n de las ausencias

		 CASE nNroOpc == 6
		      Profe_206(aP1,aP2,aP3)
		    *Grabacci¢n de logros por grupo

		 ENDCASE

	    CASE nOpcPal == 3

		 DO CASE
		 CASE nNroOpc == 1
		      Profe_301(aP1,aP2,aP3)
		    *Grabacci¢n de logros por estudiante

		 CASE nNroOpc == 2
		      Profe_302(aP1,aP2,aP3)
		    *Modificaci¢n de logros

		 CASE nNroOpc == 3
		      Profe_203(aP1,aP2,aP3)
		    *Consulta de logros

		 CASE nNroOpc == 4
		      Profe_204(aP1,aP2,aP3)
		    *Impresion de logros

		 CASE nNroOpc == 5
		      Profe_205(aP1,aP2,aP3)
		    *Grabaci¢n de las ausencias

		 CASE nNroOpc == 6

		      Profe_206(aP1,aP2,aP3)
		    *Grabacci¢n de logros por grupo

		 CASE nNroOpc == 7
		      Profe_202(aP1,aP2,aP3)
		    *Modificaci¢n de logros

/*
		      Profe_307(aP1,aP2,aP3)
		    *Aplicaci¢n de logros a evaluar
*/
		 CASE nNroOpc == 8
		      Profe_308(aP1,aP2,aP3)
		    *Grabacci¢n de sole notas.

		 ENDCASE

	    CASE nOpcPal == 4

		 DO CASE
		 CASE nNroOpc == 1


		      DO CASE
		      CASE nMetRec == 0     // Por defecto
			   Profe_401(aP1,aP2,aP3)

		      CASE nMetRec == 99    // Colsalle
			   Spr_401_99(aP1,aP2,aP3)

		      OTHERWISE
			     cError('EL METODO No.'+ALLTRIM(STR(nMetRec,4,0)+;
				    ' DE RECUPERACION NO ESTA PERMITIDO.'))
		      ENDCASE
		    *ÀRecuperaciones

		 CASE nNroOpc == 2
		      Profe_402(aP1,aP2,aP3,.F.)
		    *Consulta de Recuperaciones

		 CASE nNroOpc == 3
		      Profe_403(aP1,aP2,aP3)
		    *Imprimir

		 CASE nNroOpc == 4
		      Profe_404(aP1,aP2,aP3)
		    *Modificar

		 ENDCASE

	    CASE nOpcPal == 5

		 DO CASE
		 CASE nNroOpc == 1  // Creaci¢n de Indicadores

*=====================ANALISIS DE DECISION
			DO CASE
			CASE cSubInd == SPACE(02) .OR. cSubInd == '01'

			     IF cSubInd # SPACE(02)
				IF !lPregunta('DESEA CLASIFICAR LOS '+;
					      'INDICADORS? Si No')
				   cOpcInd := SPACE(02)
				ELSE
				   cOpcInd := cSubInd
				ENDIF
			     ELSE
				cOpcInd := SPACE(02)
			     ENDIF

			CASE cSubInd == '02'  // Indicores Padre e Hijos
			     cOpcInd := cSubInd
			ENDCASE
*=====================FIN ANALISIS DE DECISION

*=====================CREACION DE INDICADORES
			DO CASE
			CASE cOpcInd == SPACE(02)
			     Profe_501(aP1,aP2,aP3)
			    *Indicadores

			CASE cOpcInd == '01'
			     Spr_501_01(aP1,aP2,aP3)
			   *Indicadores. Clasificaci¢n

			CASE cOpcInd == '02'
			     Spr_501_02(aP1,aP2,aP3)
			   *Clasificaci¢n de Indicadores Padre e Hijos

			OTHERWISE
			     cError('CODIGO DE CLASIFICACION '+;
				    'NO PERMITIDO.'+cSubInd)
			ENDCASE
*=====================FIN CREACION DE INDICADORES

		 CASE nNroOpc == 2
		      Profe_502(aP1,aP2,aP3)
		    *Consulta

		 CASE nNroOpc == 3
		      Profe_503(aP1,aP2,aP3)
		     *Modificaci¢n de Indicadores parciales.

		 CASE nNroOpc == 4

*=====================ANALISIS DE DECISION
			IF cSubInd == SPACE(02) .OR. cSubInd == '01'

			     IF cSubInd # SPACE(02)
				IF !lPregunta('DESEA IMPRIMIR LA '+;
					      'CLASIFICACION? Si No')
				   cOpcInd := SPACE(02)
				ELSE
				   cOpcInd := cSubInd
				ENDIF
			     ELSE
				cOpcInd := SPACE(02)
			     ENDIF

			ENDIF
*=====================FIN ANALISIS DE DECISION

*=====================CREACION DE INDICADORES
			DO CASE
			CASE cOpcInd == SPACE(02)
*			     Profe_504(aP1,aP2,aP3)
			     Profe_510(aP1,aP2,aP3)
			    *Imprimir indicadores parciales

			CASE cOpcInd == '01'
*			     Spr_504_01(aP1,aP2,aP3)
			     Profe_510(aP1,aP2,aP3)
			   *Imprimir clasificaci¢n de Indicadores

			OTHERWISE
			     cError('CODIGO DE CLASIFICACION '+;
				    'NO PERMITIDO.'+cSubInd)
			ENDCASE
*=====================FIN CREACION DE INDICADORES

		 CASE nNroOpc == 5
		      Profe_505(aP1,aP2,aP3)
		     *Modificaci¢n de Indicadores finales.

		 CASE nNroOpc == 6
		      Profe_506(aP1,aP2,aP3)
		     *Trasladar UNO a UNO los indicadores del a¤o anterior.

		 CASE nNroOpc == 7
		      Profe_507(aP1,aP2,aP3)
		     *Trasladar TODOS los indicadores del a¤o anterior.

		 CASE nNroOpc == 8
		      Profe_509(aP1,aP2,aP3)

*		      Profe_508(aP1,aP2,aP3)
		     *Asociar los Indicadores a los Logros.

		 ENDCASE

	    CASE nOpcPal == 6

		 DO CASE
		 CASE nNroOpc == 1
		      Profe_601(aP1,aP2,aP3)
		    *Consulta de la carga acad‚mica

		 CASE nNroOpc == 2

/*
		      ManProLog(aP1,aP2,aP3,FileLog)
		     *Log de Actividades
*/

		      Profe_602(aP1,aP2,aP3)
		    *Consulta de indicadores de contabilidad.

		 ENDCASE

	    CASE nOpcPal == 7

		 DO CASE
		 CASE nNroOpc == 1
		      MantenUsr(lShared,PathSis,FileAaa,{|nOpcion,aAyudas|;
				aMenusProf(nOpcion,'1111111111',aAyudas,;
				lMemUsb)},cNomSis,.F.)
		     *Mantemiento de usuarios

		 CASE nNroOpc == 2

		      CamPasWor(lShared,nFilInf+1,aColSup[nOpcion],;
				PathSis,FileAaa,cNomUsr)
		     *Cambiar el PassWord del usuario

		 CASE nNroOpc == 3

		     *ÀIndexar

		 CASE nNroOpc == 4
		      Profe_704(aP1,aP2,aP3)
		     *Actualizaci¢n de Estructuras

		 CASE nNroOpc == 5
		      Profe_705(aP1,aP2,aP3)
		     *Mantenimiento

		 CASE nNroOpc == 6
		      Profe_706(aP1,aP2,aP3,;
				{|nOpcion,aAyudas|;
				  aMenusProf(nOpcion,'1111111111',aAyudas,;
				  lMemUsb)})
		     *Configuraci¢n

		 CASE nNroOpc == 7
		      Profe_707(aP1,aP2,aP3)
		     *Varios

		 CASE nNroOpc == 8
		      Profe_708(aP1,aP2,aP3)
		     *Cambiar Clave del Profesor

		 CASE nNroOpc == 9
		      Profe_709(aP1,aP2,aP3)
		     *SimaUsb

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
* TITULO DE LA FUNCION..: VERIFICACION DEL DISCO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 14/96 JUE A
       Bucaramanga, Colombia        INICIO: 02:10 PM   MAR 14/96 JUE

OBJETIVOS:

1)- Verifica que el disco se encuentre en el Drive

2)- Verifica que el disco no este protegido contra escritura.

3)- Retorna .T. si el discon no tiene problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDisketeOk(cUnidad,cMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cUnidad                              // Unidad de Disco a Verificar
       cMensaj                              // Mensaje   */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION DEL DISKETTE EN LA UNIDAD
       cMensaj := IF(EMPTY(cMensaj),'',cMensaj)
       DO WHILE .NOT. DISKREADY(cUnidad)
	  IF cError('Entre su DISCO DE NOTAS en la unidad '+cUnidad,;
		    cMensaj+' POR FAVOR',;
		    'Presione <ESC> para NO Intentar m s.') == CHR(K_ESC)
	     lHayErr := .T.
	     EXIT
	  ENDIF
       ENDDO
*>>>>FIN VERIFICACION DEL DISKETTE EN LA UNIDAD

*>>>>VERIFICACION DE LA PROTECCION DE LECTURA
       IF !lHayErr
	  DO WHILE .NOT. DISKREADYW(cUnidad)
	     IF cError('Remueva la proteci¢n, SI ES SU DISCO DE NOTAS',;
		       cMensaj+;
		       ' El Diskette, ESTA PROTEGIDO contra escritura.',;
		       'Presione <ESC> para NO Intentar m s.') == CHR(K_ESC)
		lHayErr := .T.
		EXIT
	     ENDIF
	  ENDDO
       ENDIF
       RETURN !lHayErr
*>>>>FIN VERIFICACION DE LA PROTECCION DE LECTURA

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

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,PathClr,FileClr,;
		    PathSis,fSimSpr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path del Sistema
       fSimSpr                              // Configuraci¢n del Sistema */
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
       IF !FILE(PathSis+'\'+fSimSpr)
	  RecuSimSpr(lShared,nModCry,PathSis,fSimSpr)
       ENDIF
       nActSimSpr(lShared,nModCry,PathSis,fSimSpr)

       IF !FILE(PathClr+'\'+FileClr)
	  RecuDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrClr(lShared,nModCry,PathClr,FileClr)
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysSpr(lShared,nModCry)
       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR

/*************************************************************************
* TITULO..: POSICION INICIAL                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/2002 VIE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   MAY 03/2002 VIE

OBJETIVOS:

1- Calcula la posici¢n inicial del t‚rmino general que gobierna una
   secuencia n£merica de acuerdo a la longitud fija de cada elemento.

2- Retorna la posici¢n inicial


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nPosIni(nNroPos,nLenCod)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroPos			            // N£mero de la posici¢n
       nLenCod                              // Longitud del C¢digo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nPosIni := 0                   // Posici¢n Inicial
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LA POSICION
       nPosIni := (nNroPos*nLenCod)-(nLenCod-1)
       RETURN nPosIni
*>>>>FIN CALCULO DE LA POSICION

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DE SIMACONT                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 25/2008 DOM A
       Colombia, Bucaramanga        INICIO:  10:30 PM  MAY 25/2008 DOM

OBJETIVOS:

1- Crea los archivos necesarios de SIMACONT

1- Crea el directorio de la aplicaci¢n para el a¤o especificado si
   no existe.

2- Crea las estructuras de los archivos de la aplicaci¢n en caso de no
   existir.

3- Recupera las estructuras de los archivos de la aplicaci¢n en caso
   de p‚rdida.

4- Indexa los archivos de la aplicaci¢n en caso de no existir

5- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION UsbDdfCont(aP1,lndexar,cSavPan)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       lndexar                              // .T. Indexar Archivos
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
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // Crear Estructuras

       LOCAL       i := 0                   // Contador
       LOCAL PathAct := ''                  // Path Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DIRECTORIOS DEL SISTEMA
       PathAct := cPathAct()

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   Mdir(PathSCO+'\'+cPatSis+'\'+cMaeAct,PathAct)

       ENDFOR
*>>>>FIN DIRECTORIOS DEL SISTEMA

*>>>>CREACION DE ESTRUCTURAS DEL A¥O
       DO CASE
       CASE !FILE(PathSCO+'\'+cPatSis+'\'+FilePro+cAnoSis+ExtFile)

************CREACION DE ESTRUCTURAS
	      RESTSCREEN(0,0,24,79,cSavPan)
	      UsbContAno(lShared,nModCry,PathSCO+'\'+cPatSis,cAnoUsr)
************FIN CREACION DE ESTRUCTURAS

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL A¥O
	      IF !FILE(PathSCO+'\'+cPatSis+'\'+FilePro+cAnoSis+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPro(lShared,PathSCO+'\'+cPatSis,;
				    FilePro+cAnoSis+ExtFile)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS DEL A¥O

       ENDCASE
*>>>>CREACION DE ESTRUCTURAS DEL A¥O

*>>>>CREACION DE ESTRUCTURAS DEL NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)

***********CREACION O RECUPERACION DE ESTRUCTURAS DEL NIVEL
	     DO CASE
	     CASE !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileMat) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileCla) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileEva) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			FileCar+cMaeAct+ExtFile)         .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			FConTbl+cMaeAct+ExtFile)         .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			FileAlu+cMaeAct+cAnoSis+ExtFile) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			FileGru+cMaeAct+cAnoSis+ExtFile) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			FileNiv+cAnoSis+ExtFile) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			FileJui+cMaeAct+cAnoSis+ExtFile) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileSuN+ExtFile) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileSuG+ExtFile) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileJvf+ExtFile) .AND.;
		  !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			FileSin+cMaeAct+cAnoSis+ExtFile)

*===================CREACION DE ESTRUCTURAS
		      RESTSCREEN(0,0,24,79,cSavPan)
		      UsbContTbl(lShared,nModCry,;
				 PathSCO+'\'+cPatSis,cMaeAlu,cAnoUsr)
*===================FIN CREACION DE ESTRUCTURAS

	     OTHERWISE

*=================RECUPERACION DE ESTRUCTURAS
		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileMat)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfMat(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileMat)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileSel+cMaeAct+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfSel(lShared,nModCry,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileSel+cMaeAct+ExtFile,;
				  fNtxSel+cMaeAct+cExtNtx)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FConTbl+cMaeAct+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuConTbl(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FConTbl+cMaeAct+ExtFile)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileCar+cMaeAct+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfCar(PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileCar+cMaeAct+ExtFile)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileAlu+cMaeAct+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfAlu(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileAlu+cMaeAct+cAnoSis+ExtFile)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileGru+cMaeAct+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfGru(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileGru+cMaeAct+cAnoSis+ExtFile)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileNiv+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfNiv(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileNiv+cAnoSis+ExtFile,NIL,cMaeAct)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileJui+cMaeAct+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfJui(lShared,nModCry,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileJui+cMaeAct+cAnoSis+ExtFile)
		       lndexar := .T.
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileCla)
		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfCla(lShared,nModCry,PathSCO+'\'+cPatSis+'\'+cMaeAct,FileCla)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileEva)
		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfEva(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileEva)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileSuN+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfSuN(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileSuN+ExtFile)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileSuG+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfSuG(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileSuG+ExtFile)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+FileJvf+ExtFile)
		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfJvf(lShared,nModCry,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileJvf+ExtFile)
		    ENDIF

		    IF !FILE(PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileSin+cMaeAct+cAnoSis+ExtFile)
		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfSin(lShared,nModCry,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
				  FileSin+cMaeAct+cAnoSis+ExtFile)
		    ENDIF
*=================FIN RECUPERACION DE ESTRUCTURAS

	     ENDCASE
***********FIN CREACION O RECUPERACION DE ESTRUCTURAS DEL NIVEL

***********ACTUALIZACION DE LAS ESTRUCTURAS
	     nActStrMat(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,FileMat)

	     nActStrCla(lShared,nModCry,PathSCO+'\'+cPatSis+'\'+cMaeAct,FileCla)

	     nActStrEva(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,FileEva)

	     nActStrNiv(lShared,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
			FileNiv+cAnoSis+ExtFile,cMaeAct)

	     IF nActStrJui(lShared,nModCry,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
			   FileJui+cMaeAct+cAnoSis+ExtFile) == 0
		lndexar := .T.
	     ENDIF


	     IF nActStrSel(lShared,nModCry,PathSCO+'\'+cPatSis+'\'+cMaeAct,;
			   FileSel+cMaeAct+ExtFile,;
			   fNtxSel+cMaeAct+cExtNtx) == 0
		lndexar := .T.
	     ENDIF
***********FIN ACTUALIZACION DE LAS ESTRUCTURAS

       NEXT
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS DEL NIVEL

/*************************************************************************
* TITULO..: CREACION ARCHIVOS DEL A¥O.SIMACONT                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 25/2008 DOM A
       Colombia, Bucaramanga        INICIO:  11:00 PM  MAY 25/2008 DOM

OBJETIVOS:

1- Crea todos los archivos generales del a¤o del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION UsbContAno(lShared,nModCry,cPatSis,cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS DEL A¥O
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS DEL A¥O.SIMACONT")

       CreaDbfPro(lShared,cPatSis,FilePro+cAnoSis+ExtFile)
       Termometro(100)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS DEL A¥O

/*************************************************************************
* TITULO..: CREACION ARCHIVOS DEL NIVEL.SIMACONT                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  02:00 AM  MAY 26/2008 LUN

OBJETIVOS:

1- Crea todos los archivos especificos del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION UsbContTbl(lShared,nModCry,cPatSis,cMaeAlu,cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cMaeAlu                              // Maestro Habilitados
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS ESPECIFICAS
       cSavPan := SAVESCREEN(0,0,24,79)

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	   Termometro(0,"CREANDO ARCHIVOS ESPECIFICOS.SIMACONT."+cMaeAct)

	   Termometro(7)
	   CreaDbfMat(lShared,cPatSis+'\'+cMaeAct,FileMat)

	   Termometro(14)
	   CreaDbfSuN(lShared,cPatSis+'\'+cMaeAct,FileSuN+ExtFile)

	   Termometro(21)
	   CreaDbfSuG(lShared,cPatSis+'\'+cMaeAct,FileSuG+ExtFile)

	   Termometro(28)
	   CreaConTbl(lShared,cPatSis+'\'+cMaeAct,FConTbl+cMaeAct+ExtFile)

	   Termometro(35)
	   CreaDbfCla(lShared,nModCry,cPatSis+'\'+cMaeAct,FileCla)

	   Termometro(42)
	   CreaDbfEva(lShared,cPatSis+'\'+cMaeAct,FileEva)

	   Termometro(49)
	   CreaDbfCar(cPatSis+'\'+cMaeAct,FileCar+cMaeAct+ExtFile)

	   Termometro(56)
	   CreaDbfSel(lShared,nModCry,cPatSis+'\'+cMaeAct,;
		      FileSel+cMaeAct+ExtFile,fNtxSel+'JAR'+cExtNtx)

	   Termometro(63)
	   CreaDbfAlu(lShared,cPatSis+'\'+cMaeAct,;
		      FileAlu+cMaeAct+cAnoSis+ExtFile)

	   Termometro(70)
	   CreaDbfGru(lShared,cPatSis+'\'+cMaeAct,FileGru+cMaeAct+cAnoSis+ExtFile)

	   Termometro(77)
	   CreaDbfNiv(lShared,cPatSis+'\'+cMaeAct,FileNiv+cAnoSis+ExtFile,NIL,cMaeAct)

	   Termometro(84)
	   CreaDbfJui(lShared,nModCry,cPatSis+'\'+cMaeAct,FileJui+cMaeAct+cAnoSis+ExtFile)

	   Termometro(91)
	   CreaDbfJvf(lShared,nModCry,cPatSis+'\'+cMaeAct,FileJvf+ExtFile)

	   CreaDbfSin(lShared,nModCry,cPatSis+'\'+cMaeAct,;
		      FileSin+cMaeAct+cAnoSis+ExtFile)
	   Termometro(100)


       ENDFOR

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS ESPECIFICAS

/*************************************************************************
* TITULO..: VALIDACION DEL SISTEMA                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  02:45 AM  MAY 26/2008 LUN

OBJETIVOS:

1- Valida la consistencia del SimaUsb

2- Retorna .T. Si no hay problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevisarUsb(aP1,cSavPan)

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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL cUnidad := xPrm(aP1,'cUnidad') // Unidad del Sima
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL PathAct := ''                  // Path Actual
       LOCAL lInsSco := .F.                 // Insertar registros en Simacont
       LOCAL cPatSco := ''                  // Path de SimaCont
       LOCAL cPatSpr := ''                  // Path de SimaProf

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA UNIDAD DEL SIMA
       PathAct := cPathAct()
       IF !EMPTY(cUnidad) .AND. DIRCHANGE(cUnidad+'\') # 0

	  nCd(PathAct)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  DO WHILE .T.

	     cUnidad := SUBS(cUnidad,1,1)
	     @ 16,30 SAY 'UNIDAD DEL SIMA:';
		     GET cUnidad PICT '@! A';
		     WHEN {||HelpRead('FAVOR INGRESE LA LETRA '+;
			     'DE LA UNIDAD DONDE ESTA INSTALADO EL SIMA')}
	     READ

	     lHayErr := .T.
	     DO CASE

/*
	     CASE !EMPTY(cUnidad) .AND. SUBS(cPathAct(),1,2) == cUnidad+':'
		  cError('NO PUEDE SER LA MISMA UNIDAD '+;
			 'DE LA MEMORIA USB '+cUnidad+':')
*/

	     CASE !EMPTY(cUnidad) .AND. DIRCHANGE(cUnidad+'\') # 0
		  cError('NO SE PUDO CONECTAR AL SIMA '+;
			 'EN LA UNIDAD '+cUnidad)

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		LOOP
	     ENDIF

	     EXIT

	  ENDDO
	  IF EMPTY(cUnidad)
	     cError('NO SE PUDO CONECTAR AL SIMA')
	     RETURN .F.
	  ENDIF
	  cUnidad += ':'

       ENDIF
       nCd(PathAct)
*>>>>FIN LECTURA DE LA UNIDAD DEL SIMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lNoRed,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LA UNIDAD DEL SIMA
       IF SUBS(SPR->cUnidadSpr,1,1) # cUnidad

	  nParameSet(aP1,'cUnidad',cUnidad)
	  SELECT SPR
	  IF SPR->(lRegLock(lShared,.F.))

	     REPL SPR->cUnidadSpr WITH cUnidad

	     SPR->(DBCOMMIT())
	  ELSE
	     cError('NO SE ACTUALIZO LA UNIDAD DEL SIMA')
	  ENDIF
	  IF lShared
	     SPR->(DBUNLOCK())
	  ENDIF
       ENDIF
*>>>>FIN GRABACION DE LA UNIDAD DEL SIMA

*>>>>ANALISIS DE DECISION
      lInsSco := .F.
      IF PRO->(RECCOUNT()) == 0
	 lInsSco := .T.
      ENDIF
      cPatSco := ALLTRIM(PRA->PathUnoAno)
      cPatSpr := ALLTRIM(PRA->PathDosAno)

      nParameSet(aP1,'PathUno',cPatSco)
      nParameSet(aP1,'PathDos',cPatSpr)

      CloseAll()
*>>>>FIN ANALISIS DE DECISION

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF lInsSco

	  IF !FILE(cUnidad+cPatSco+'\'+PathSis+'\'+'DATO0102.DAT') .OR.;
	     !FILE(cUnidad+cPatSpr+'\'+PathSis+'\'+'DATO0103.DAT')

	     cError(cUnidad+ALLTRIM(PRA->PathUnoAno)+'\'+PathSis,;
		    'NO SE PUEDE CONECTAR AL SIMA EN:',;
		    cUnidad+ALLTRIM(PRA->PathUnoAno)+'\'+PathSis)
	     RETURN .F.
	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,cUnidad+'\'+cPatSco+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lNoRed,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN .F.
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DEL ARCHIVO
       IF !lLocCodigo('cCodigoPro','PRO',cCodPro)
	  cError('EL CODIGO DEL PROFESOR NO EXISTE:'+cCodPro)
	  CloseAll(aUseDbf)
	  RETURN .F.
       ENDIF
*>>>>FIN LOCALIZACION DEL ARCHIVO

*>>>>ANALISIS DE DECISION
       FOR i := 1 TO LEN(cMaeAlu)/3
	   IF SUBS(PRO->cRevisaPro,i,1) == '1'
	      lInsSco := .T.
	   ENDIF
       ENDFOR
*>>>>FIN ANALISIS DE DECISION

*>>>>INICIALIZACION SIMAUSB.SIMACONT
       IF lInsSco
	  lHayErr := lUsbScoIni(aP1)
       ENDIF
       nParameSet(aP1,'PathUno',PathUno)
       nParameSet(aP1,'PathDos',PathDos)
       RETURN !lHayErr
*>>>>FIN INICIALIZACION SIMAUSB.SIMACONT

/*************************************************************************
* TITULO..: INICIALIZACION DE LOS ARCHIVOS DE SIMACONT                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  05:00 AM  MAY 26/2008 LUN

OBJETIVOS:

1- Inicializa los archivos de SimaCont para el profesor

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUsbScoIni(aP1)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales */
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL cUnidad := xPrm(aP1,'cUnidad') // Unidad del Sima
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL   i,j,k := 0                   // Contador

       LOCAL cCodGru := ''                  // C¢digo del Grupo
       LOCAL cCodNiv := ''                  // C¢digo del Nivel
       LOCAL cCodMat := ''                  // C¢digo de la Materia

       LOCAL aCodGru := {}                  // C¢digo del Grupo
       LOCAL aCodNiv := {}                  // C¢digo del Nivel
       LOCAL aCodMat := {}                  // C¢digo de la Materia

       LOCAL aRegArr := {}                  // Registro Error
       LOCAL aValArr := {1}                 // Campos a Validar

       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL nNroFil := 0                   // N£mero de la Fila

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SIMACONT. ARCHIVOS DE NIVEL
       cError('A CONTINUACION SE ACTUALIZA EL SISTEMA','FAVOR ESPERAR')
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)

***********AREAS DE TRABAJO DE SIMACONT.USB
	     aUseDbf := {}

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileMat,'MAT',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileCla,'CLA',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileEva,'EVA',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileCar+cMaeAct+ExtFile,;
			       'CA1',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FConTbl+cMaeAct+ExtFile,;
			       'TCO',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileAlu+cMaeAct+cAnoSis+ExtFile,;
			       cMaeAct,NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileGru+cMaeAct+cAnoSis+ExtFile,;
			       'GRU',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileNiv+cAnoSis+ExtFile,;
			       'NIV',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileJui+cMaeAct+cAnoSis+ExtFile,;
			       'IND',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileSuN+ExtFile,'SUN',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileSuG+ExtFile,'SUG',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileJvf+ExtFile,'JVF',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileSin+cMaeAct+cAnoSis+ExtFile,;
			       'SIN',NIL,lNoRed,nModCry})
***********FIN AREAS DE TRABAJO DE SIMACONT.USB

***********AREAS DE TRABAJO DE SIMACONT
	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileMat,'MA1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileCla,'CL1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileEva,'EV1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileCar+cMaeAct+ExtFile,;
			       'CAR',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FConTbl+cMaeAct+ExtFile,;
			       'TC1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileAlu+cMaeAct+cAnoSis+ExtFile,;
			       'ALU',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileGru+cMaeAct+cAnoSis+ExtFile,;
			       'GR1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileNiv+cAnoSis+ExtFile,;
			       'NI1',NIL,lNoRed,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileJui+cMaeAct+cAnoSis+ExtFile,;
			       'IN1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileSuN+ExtFile,'SN1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileSuG+ExtFile,'SG1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileJvf+ExtFile,'JV1',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileSin+cMaeAct+cAnoSis+ExtFile,;
			       'SI1',NIL,lShared,nModCry})
***********FIN AREAS DE TRABAJO DE SIMACONT

***********SELECCION DE LAS AREAS DE TRABAJO
	     IF !lUseDbfs(aUseDbf)
		cError('ABRIENDO ARCHIVOS')
		CloseAll(aUseDbf)
		RETURN .F.
	     ENDIF
***********FIN SELECCION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE CAR->(RECCOUNT()) == 0
		  cError('NO APARECEN LAS CARGAS ACADEMICAS DE LOS PROFESORES')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseAll(aUseDbf)
		RETURN .F.
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********FILTRACION DE LA CARGA ACADEMICA
	     SELECT CAR
	     SET FILTER TO CAR->cCodigoPro = cCodPro
	     CAR->(DBGOTOP())
	     IF CAR->(EOF())
		cError('PARA '+cCodPro+' '+;
		       'NO EXISTE CARGA ACADEMICA DE '+cMaeAct)
		RETURN .F.
	     ENDIF
***********FIN FILTRACION DE LA CARGA ACADEMICA

***********RECORRIDO DE LA CARGA ACADEMICA DEL PROFESOR
	     SELECT CA1
	     ZAP
	   *ÀBorrado de los registros

	     aStrDbf := CA1->(DBSTRUCT())

	     SELECT CAR
	     CAR->(DBGOTOP())
	     DO WHILE .NOT. CAR->(EOF())

*===============LOCALIZACION DEL CODIGO DE LA MATERIA
		  cCodGru := SUBS(CAR->cCodigoCar,5,4)
		  cCodNiv := SUBS(CAR->cCodigoCar,5,2)
		  cCodMat := SUBS(CAR->cCodigoCar,1,4)
*===============FIN LOCALIZACION DEL CODIGO DE LA MATERIA

*===============ACUMULACION DE LOS REGISTROS
		  aRegArr := {cCodGru}
		  ValRegArr(@aCodGru,aRegArr,aValArr)

		  aRegArr := {cCodNiv}
		  ValRegArr(@aCodNiv,aRegArr,aValArr)

		  aRegArr := {cCodMat}
		  ValRegArr(@aCodMat,aRegArr,aValArr)
*===============FIN ACUMULACION DE LOS REGISTROS

*===============GRABACION DEL REGISTRO
		  SELECT CA1
		  IF CA1->(lRegLock(lShared,.T.))

		     FOR j := 1 TO LEN(aStrDbf)
			 cCampo := aStrDbf[j,1]
			 REPL &('CA1->'+cCampo) WITH &('CAR->'+cCampo)
		     ENDFOR
		     CA1->(DBCOMMIT())

		  ELSE
		     cError('NO SE GRABO EL REGISTRO DE GRUPOS')
		  ENDIF
		  IF lShared
		     CA1->(DBUNLOCK())
		  ENDIF
*===============FIN GRABACION DEL REGISTRO

		SELECT CAR
		CAR->(DBSKIP())

	     ENDDO
	     SET FILTER TO
	     aCodGru := ASORT(aCodGru,,,{|x,y|x[1] < y[1]})
	     aCodNiv := ASORT(aCodNiv,,,{|x,y|x[1] < y[1]})
	     aCodMat := ASORT(aCodMat,,,{|x,y|x[1] < y[1]})
***********FIN RECORRIDO DE LA CARGA ACADEMICA DEL PROFESOR

***********INICIALIZACION DE REGISTROS
	     lnsGruUsb(lShared,cNomSis,aCodGru)

	     lnsNivUsb(lShared,cNomSis,aCodNiv)

	     lnsMatUsb(lShared,cNomSis,aCodMat)

	     lnsClaUsb(lShared,cNomSis)

	     lnsMaeUsb(lShared,cNomSis,cMaeAct)

	     lnsEvaUsb(lShared,cNomSis)

	     lnsJvfUsb(lShared,cNomSis)

	     lnsTcoUsb(lShared,cNomSis)
***********FIN INICIALIZACION DE REGISTROS

       ENDFOR
       CloseAll()
*>>>>FIN SIMACONT. ARCHIVOS DE NIVEL

*>>>>AREAS DE TRABAJO DE SIMACONT.USB
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSCO+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lNoRed,nModCry})
*>>>>FIN AREAS DE TRABAJO DE SIMACONT.USB

*>>>>AREAS DE TRABAJO DE SIMACONT
       AADD(aUseDbf,{.T.,cUnidad+PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PR1',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO DE SIMACONT

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PR1->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN .F.
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SIMACONT. ARCHIVOS DEL A¥O
       lnsProUsb(lShared,cNomSis,cCodPro)

       CloseAll()
       RETURN .F.
*>>>>FIN SIMACONT. ARCHIVOS DEL A¥O