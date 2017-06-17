/*                   SISTEMA DE CONTABILIDAD ACADEMICA
		     BIBLIOTECAS DE FUNCIONES GENERALES

REQUERIMIENTOS:

- Compilar: clipper ContaFun /w/m/b

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:10 AM   MAY 02/95 MAR

OBJETIVOS:

1- Define por defecto los parametros de la aplicaci¢n

1- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IniConta(cNomEmp,cNomSis,lSisInt,cTipSis)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       lSisInt                              // .T. Sistema Integrado
       cTipSis                              // Tipo del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nMemMin := 1000000             // M¡nimo espacio en disco
       LOCAL nOpeFil := 12                  // M¡nimo archivos abiertos
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

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
       SET FIXED       OFF                  // Decimales del SET DECIMALS
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
* TITULO DE LA FUNCION..: REVISION DE LOS ARCHIVOS DEL SISTEMAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   MAY 02/95 MAR

OBJETIVOS:

1- Crea el directorio de la aplicaci¢n para el a¤o especificado si
   no existe.

2- Crea las estructuras de los archivos de la aplicaci¢n en caso de no
   existir.

3- Recupera las estructuras de los archivos de la aplicaci¢n en caso
   de p‚rdida.

4- Indexa los archivos de la aplicaci¢n en caso de no existir

5- Retorna el Path de integraci¢n

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevisarDbf(aP1,;
		    lIntUno,lIntDos,lIntTre,lIntCua,;
		    cSavPan,cSerFac)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1				    // Parametros del Sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cSavPan                              // Salvar Pantalla
       cSerFac                              // @Servicio facturado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cPatInt := ''                  // Path para la integraci¢n
       LOCAL cPatTem := ''                  // Path temporal
       LOCAL PathAct := ''                  // Path Actual
       LOCAL cNewDir := ''                  // Nombre del Directorio nuevo

       LOCAL PathWww := ''		    // Path del Sitio */

       LOCAL       i := 0                   // Contador
       LOCAL bInfSys := NIL                 // Block Informes del Sistema

       LOCAL cTemTxt := ''                  // Texto Temporal
       LOCAL lndexar := .F.                 // .T. Indexar Archivos
       LOCAL lPrnArc := .F.                 // .T. Imprimir en Archivo
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

*>>>>DIRECTORIOS DEL SISTEMA
       PathAct := cPathAct()

       Mdir(cPatSis,PathAct)
     *ÀDirectorio del A¤o. Ej 2007.diu

       Mdir(PathPrn,PathAct)
     *ÀPrinter

       Mdir(PathDoc,PathAct)
     *ÀMis Documentos

       Mdir('AulasWww',PathAct)
     *ÀAulas Virtuales

       Mdir(PathWeb+'\IMG',PathAct)
       Mdir(PathWeb+'\FOTOS',PathAct)
     *ÀSimaWeb. General
*>>>>FIN DIRECTORIOS DEL SISTEMA

*>>>>SITIOS DEL SISTEMA No.1
       PathWww := xParams(aP1,'PathW01')
       IF !('sitio01' $ PathWww)

	  Mdir(PathWww+'\IMG',PathAct)
	*ÀCreaci¢n del Directorio

	  InfPrnXsl(PathWww+'\IMG')
	*ÀArchivo XSL informes.

	  BoletinHtm(lShared,nModCry,cNomEmp,cAnoUsr,cPatSis,cMaeAlu)
       ENDIF
*>>>>FIN SITIOS DEL SISTEMA No.1

*>>>>VERIFICACION DE DIRECTORIOS DEL NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3
	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   Mdir(cPatSis+'\'+cMaeAct,PathAct)
       NEXT
*>>>>FIN VERIFICACION DE DIRECTORIOS DEL NIVEL

*>>>>VALIDACION DE CAMPOS EN NOTAS
       HayCamJnt(lShared,cAnoUsr,cPatSis,cMaeAlu)
*>>>>FIN VALIDACION DE CAMPOS EN NOTAS

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       bInfSys := {||ScoInfSys(lShared,cNomUsr,cCodSui)}
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+fErrSys) .AND.;
	    !FILE(PathSis+'\'+fSimaCo) .AND.;
	    !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis+'\'+FilePer) .AND.;
	    !FILE(PathSis+'\'+FileInf) .AND.;
	    !FILE(PathSis+'\'+FileIso)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,cPatSis,cAnoUsr,lIntUno,;
		       lIntDos,lIntTre,lIntCua,bInfSys)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+fSimaCo)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuSimCon(lShared,PathSis,fSimaCo,lIntUno)
	      ENDIF

	      IF !FILE(PathSis+'\'+fErrSys)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuErrSys(lShared,nModCry,PathSis,fErrSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FilePrn)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPrn(lShared,nModCry,PathSis,FilePrn)
	      ENDIF

	      IF !FILE(PathSis+'\'+FilePer)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPer(lShared,nModCry,PathSis,FilePer)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileInf)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfInf(lShared,nModCry,PathSis,FileInf,bInfSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileIso)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfIso(lShared,nModCry,PathSis,FileIso)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileAlu+'ALU'+ExtFile)

		RESTSCREEN(0,0,24,79,cSavPan)
		RecuDbfAlu(PathSis,FileAlu+'ALU'+ExtFile,'ALU',;
			   fNtxAlu+'ALU'+cExtNtx)

	      ENDIF

	      IF !FILE(PathSis+'\'+FileAlu+'ARCHI'+ExtFile)

		RESTSCREEN(0,0,24,79,cSavPan)
		RecuDbfAlu(PathSis,FileAlu+'ARCHI'+ExtFile,'ARC',;
			   fNtxAlu+'ARCHI'+cExtNtx)

	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION O RECUPERACION DE ESTRUCTURAS PARA EL A¥O
       SET CURSOR OFF
       DO CASE
       CASE !FILE(cPatSis+'\'+fConAno+cAnoUsr+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+fPazEst+cAnoSis+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+fDpzEst+cAnoSis+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FilePro+cAnoSis+ExtFile) .AND.;
	    !FILE(cPatSis+'\'+FileOrg) .AND.;
	    !FILE(cPatSis+'\'+fCorBol) .AND.;
	    !FILE(cPatSis+'\'+fTipUsr) .AND.;
	    !FILE(cPatSis+'\'+fColPrc)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfAno(lShared,nModCry,cPatSis,cAnoUsr,;
		       lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu)

       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL SISTEMA
	      IF !FILE(cPatSis+'\'+fConAno+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuConAno(lShared,cPatSis,fConAno+cAnoUsr+ExtFile,lIntUno)
	      ENDIF

	      IF !FILE(cPatSis+'\'+;
		       FileAlu+cAnoUsr+ExtFile)

		RESTSCREEN(0,0,24,79,cSavPan)
		RecuDbfAlu(cPatSis,;
			   FileAlu+cAnoUsr+ExtFile,'MAE',;
			   fNtxAlu+cAnoUsr+cExtNtx)

	      ENDIF


	      IF !FILE(cPatSis+'\'+;
		       FileGru+'POS'+cAnoSis+ExtFile)

		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfGru(lShared,cPatSis,;
			    FileGru+'POS'+cAnoSis+ExtFile,lIntUno)
	      ENDIF


	      IF !FILE(cPatSis+'\'+;
		       FileAlu+'IMPOR'+ExtFile)

		RESTSCREEN(0,0,24,79,cSavPan)
		RecuDbfAlu(cPatSis,;
			   FileAlu+'IMPOR'+ExtFile,'IMP',;
			   fNtxAlu+'IMPOR'+cExtNtx)

	      ENDIF

	      IF !FILE(cPatSis+'\'+;
		       FileAlu+'CON'+cAnoSis+ExtFile)

		RESTSCREEN(0,0,24,79,cSavPan)
		RecuDbfAlu(cPatSis,;
			   FileAlu+'CON'+cAnoSis+ExtFile,'MAC',;
			   fNtxAlu+'CON'+cAnoSis+cExtNtx)

	      ENDIF

	      IF !FILE(cPatSis+'\'+fPerImp+'ESTIM'+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPer(lShared,nModCry,cPatSis,fPerImp+'ESTIM'+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fPerImp+'ADMIM'+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPer(lShared,nModCry,cPatSis,fPerImp+'ADMIM'+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fPazEst+cAnoSis+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPaz(lShared,nModCry,cPatSis,fPazEst+cAnoSis+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fDpzEst+cAnoSis+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfDpz(lShared,nModCry,cPatSis,fDpzEst+cAnoSis+ExtFile)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FilePro+cAnoSis+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPro(lShared,cPatSis,FilePro+cAnoSis+ExtFile,lIntUno)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileOrg)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfOrg(lShared,cPatSis,FileOrg)
	      ENDIF

/*
	      IF !FILE(cPatSis+'\'+FileHor)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfHor(lShared,nModCry,cPatSis,FileHor)
	      ENDIF
*/

	      IF !FILE(cPatSis+'\'+FileHra)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfHra(lShared,nModCry,cPatSis,FileHra)
	      ENDIF

	      IF !FILE(cPatSis+'\'+FileFun)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfFun(lShared,cPatSis,FileFun)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fCorBol)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuCorBol(lShared,nModCry,cPatSis,fCorBol)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fTipUsr)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTus(lShared,nModCry,cPatSis,fTipUsr)
	      ENDIF

	      IF !FILE(cPatSis+'\'+fColPrc)
		 RecuDbfCol(lShared,nModCry,cPatSis,fColPrc)
	      ELSE
		 nActStrCol(lShared,nModCry,cPatSis,fColPrc)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS COMPARTIDAS

       ENDCASE
*>>>>FIN CREACION O RECUPERACION DE ESTRUCTURAS PARA EL A¥O

*>>>>ACTUALIZACION DE ESTRUCTURAS GENERALES
       nActStrCon(lShared,PathSis,fSimaCo)
     *ÀConfiguraci¢n General

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActStrPer(lShared,nModCry,PathSis,FilePer)
     *ÀActualizaci¢n de las Personas

       nActStrInf(lShared,nModCry,PathSis,FileInf)
     *ÀActualizacion. Informes del sistema

       nActStrIso(lShared,nModCry,PathSis,FileIso)
     *ÀActualizacion de Archios de documentos a imprimir

       IF lActStrAlu(lShared,PathSis,;
		     FileAlu+'ALU'+ExtFile,;
		     fNtxAlu+'ALU'+cExtNtx,;
		     'ALU',cAnoUsr)

	  lndexar := .T.
       ENDIF

       IF lActStrAlu(lShared,PathSis,;
		     FileAlu+'ARCHI'+ExtFile,;
		     fNtxAlu+'ARCHI'+cExtNtx,;
		     'ARC',cAnoUsr)

	  lndexar := .T.
       ENDIF
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS GENERALES

*>>>>ACTUALIZACION DE ESTRUCTURAS DEL A¥O
       nActStrCoA(lShared,cPatSis,FConAno+cAnoUsr+ExtFile)
       nActStrPaz(lShared,nModCry,cPatSis,fPazEst+cAnoSis+ExtFile)
       nActStrDpz(lShared,nModCry,cPatSis,fDpzEst+cAnoSis+ExtFile)
       nActStrPro(lShared,cPatSis,FilePro+cAnoSis+ExtFile)
*       nActStrHor(lShared,nModCry,cPatSis,FileHor)
       nActStrHra(lShared,nModCry,cPatSis,FileHra)
       nActStrFun(lShared,cPatSis,FileFun)
       nActCorBol(lShared,nModCry,cPatSis,fCorBol)
       nActStrTus(lShared,nModCry,cPatSis,fTipUsr)

       nActStrPer(lShared,nModCry,cPatSis,fPerImp+'ESTIM'+ExtFile)
     *ÀActualizaci¢n de las Personas Estudiantes Importar

       nActStrPer(lShared,nModCry,cPatSis,fPerImp+'ADMIM'+ExtFile)
     *ÀActualizaci¢n de las Personas Estudiantes Importar

       IF lActStrAlu(lShared,cPatSis,;
		     FileAlu+cAnoUsr+ExtFile,;
		     fNtxAlu+cAnoUsr+cExtNtx,;
		     'MAE',cAnoUsr)

	  lndexar := .T.
       ENDIF

       nActStrGru(lShared,cPatSis,FileGru+'POS'+cAnoSis+ExtFile)


       IF lActStrAlu(lShared,cPatSis,;
		     FileAlu+'IMPOR'+ExtFile,;
		     fNtxAlu+'IMPOR'+cExtNtx,;
		     'IMP',cAnoUsr)

	  lndexar := .T.
       ENDIF

       IF lActStrAlu(lShared,cPatSis,;
		     FileAlu+'CON'+cAnoSis+ExtFile,;
		     fNtxAlu+'CON'+cAnoSis+cExtNtx,;
		     'MAC',cAnoUsr)

	  lndexar := .T.
       ENDIF
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS DEL A¥O

*>>>>ANALISIS DE ESTRUCTURAS DEL NIVEL
       SET CURSOR OFF
       FOR i := 1 TO LEN(cMaeAlu)/3

***********CREACION O RECUPERACION DE ESTRUCTURAS DEL NIVEL
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	     DO CASE
	     CASE !FILE(cPatSis+'\'+cMaeAct+'\'+FileEmp) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+FileMat) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+FileCla) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+FileEva) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+;
			FNroInd+cMaeAct+cAnoSis+ExtFile) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+;
			FileCar+cMaeAct+ExtFile)         .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+;
			FConTbl+cMaeAct+ExtFile)         .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+;
			FileAlu+cMaeAct+cAnoSis+ExtFile) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+;
			FileGru+cMaeAct+cAnoSis+ExtFile) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+;
			FileJui+cMaeAct+cAnoSis+ExtFile) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+;
			FileHab+cAnoSis+ExtFile)         .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+FileSuN) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+FileSuG) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+FileJvf) .AND.;
		  !FILE(cPatSis+'\'+cMaeAct+'\'+;
			FileSin+cMaeAct+cAnoSis+ExtFile)

*=================CREACION DE ESTRUCTURAS
		    RESTSCREEN(0,0,24,79,cSavPan)
		    CrearDbfs(lShared,cPatSis+'\'+cMaeAct,cAnoUsr,;
			      lIntUno,lIntDos,lIntTre,lIntCua,cMaeAct)
*=================FIN CREACION DE ESTRUCTURAS

	     OTHERWISE

*=================RECUPERACION DE ESTRUCTURAS
		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileEmp)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfEmp(lShared,cPatSis+'\'+cMaeAct,;
				  FileEmp,lIntUno)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileMat)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfMat(lShared,cPatSis+'\'+cMaeAct,;
				  FileMat,lIntUno)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileSel+cMaeAct+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfSel(lShared,nModCry,cPatSis+'\'+cMaeAct,;
				  FileSel+cMaeAct+ExtFile,;
				  fNtxSel+cMaeAct+cExtNtx)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FConTbl+cMaeAct+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuConTbl(lShared,cPatSis+'\'+cMaeAct,;
				  FConTbl+cMaeAct+ExtFile,lIntUno)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileCar+cMaeAct+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfCar(cPatSis+'\'+cMaeAct,;
				  FileCar+cMaeAct+ExtFile)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileAlu+cMaeAct+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfAlu(cPatSis+'\'+cMaeAct,;
				  FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
				  fNtxAlu+cMaeAct+cAnoSis+cExtNtx)

		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileGru+cMaeAct+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfGru(lShared,cPatSis+'\'+cMaeAct,;
				  FileGru+cMaeAct+cAnoSis+ExtFile,lIntUno)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileNiv+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfNiv(lShared,cPatSis+'\'+cMaeAct,;
				  FileNiv+cAnoSis+ExtFile,NIL,cMaeAct)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileJui+cMaeAct+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfJui(lShared,nModCry,cPatSis+'\'+cMaeAct,;
				  FileJui+cMaeAct+cAnoSis+ExtFile)
		       lndexar := .T.
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+FileCla)
		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfCla(lShared,nModCry,cPatSis+'\'+cMaeAct,FileCla)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+FileEva)
		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfEva(lShared,cPatSis+'\'+cMaeAct,;
				  FileEva,lIntUno)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileApr)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfApr(lShared,cPatSis+'\'+cMaeAct,;
				  FileApr,lIntUno)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FNroInd+cMaeAct+cAnoSis+ExtFile)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfNro(lShared,nModCry,cPatSis+'\'+cMaeAct,;
				  FNroInd+cMaeAct+cAnoSis+ExtFile)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileSuN)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfSuN(lShared,cPatSis+'\'+cMaeAct,;
				  FileSuN,lIntUno)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileSuG)

		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfSuG(lShared,cPatSis+'\'+cMaeAct,;
				  FileSuG,lIntUno)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+FileJvf)
		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfJvf(lShared,nModCry,cPatSis+'\'+cMaeAct,;
				  FileJvf)
		    ENDIF

		    IF !FILE(cPatSis+'\'+cMaeAct+'\'+;
			     FileSin+cMaeAct+cAnoSis+ExtFile)
		       RESTSCREEN(0,0,24,79,cSavPan)
		       RecuDbfSin(lShared,nModCry,cPatSis+'\'+cMaeAct,;
				  FileSin+cMaeAct+cAnoSis+ExtFile)
		    ENDIF
*=================FIN RECUPERACION DE ESTRUCTURAS

	     ENDCASE
***********FIN CREACION O RECUPERACION DE ESTRUCTURAS DEL NIVEL

***********ACTUALIZACION DE LAS ESTRUCTURAS
	     nActStrMat(lShared,cPatSis+'\'+cMaeAct,FileMat)
	     nActStrApr(lShared,cPatSis+'\'+cMaeAct,FileApr)
	     nActStrCla(lShared,nModCry,cPatSis+'\'+cMaeAct,FileCla)

	     nActStrNro(lShared,nModCry,cPatSis+'\'+cMaeAct,;
			FNroInd+cMaeAct+cAnoSis+ExtFile)

	     nActStrEva(lShared,cPatSis+'\'+cMaeAct,FileEva)

	     nActStrNiv(lShared,cPatSis+'\'+cMaeAct,;
			FileNiv+cAnoSis+ExtFile,cMaeAct)

	     IF nActStrJui(lShared,nModCry,cPatSis+'\'+cMaeAct,;
			   FileJui+cMaeAct+cAnoSis+ExtFile) == 0
		lndexar := .T.
	     ENDIF


	     IF nActStrSel(lShared,nModCry,cPatSis+'\'+cMaeAct,;
			   FileSel+cMaeAct+ExtFile,;
			   fNtxSel+cMaeAct+cExtNtx) == 0
		lndexar := .T.
	     ENDIF
***********FIN ACTUALIZACION DE LAS ESTRUCTURAS

       NEXT
*>>>>FIN ANALISIS DE ESTRUCTURAS DEL NIVEL


*>>>>VALIDACION INDICES GENERALES
       IF !FILE(PathSis+'\'+fNtxAlu+'ALU'+cExtNtx) .OR. lndexar
	  lndexar := .T.
       ENDIF

       IF !FILE(PathSis+'\'+fNtxAlu+'ARCHI'+cExtNtx) .OR. lndexar
	  lndexar := .T.
       ENDIF
*>>>>FIN VALIDACION INDICES GENERALES

*>>>>VALIDACION INDICES DEL A¥O
       IF !FILE(cPatSis+'\'+fNtxAlu+cAnoUsr+cExtNtx) .OR. lndexar
	  lndexar := .T.
       ENDIF

       IF !FILE(cPatSis+'\'+fNtxAlu+'IMPOR'+cExtNtx) .OR. lndexar
	  lndexar := .T.
       ENDIF


       IF !FILE(cPatSis+'\'+fNtxAlu+'CON'+cAnoSis+cExtNtx) .OR. lndexar
	  lndexar := .T.
       ENDIF
*>>>>FIN VALIDACION INDICES DEL A¥O


*>>>>VALIDACION DE LOS INDICES
       cTemTxt := 'MAEAPENOM'
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)

***********VALIDACION INDICES DEL MAESTRO
	     fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
			SUBS(cTemTxt,i*3-2,3)+cMaeAct+cAnoSis+cExtNtx

	     IF !FILE(fNtxTem) .OR. lndexar
		lndexar := .T.
		EXIT
	     ENDIF
***********FIN VALIDACION INDICES DEL MAESTRO

***********VALIDACION INDICE DE INDICADORES
	    fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
		       fNtxJui+cMaeAct+cAnoSis+cExtNtx
	     IF !FILE(fNtxTem) .OR. lndexar
		lndexar := .T.
		EXIT
	     ENDIF
***********FIN VALIDACION INDICE DE INDICADORES

***********VALIDACION INDICE DE LA SELECCION
	     fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
			fNtxSel+cMaeAct+cExtNtx
	     IF !FILE(fNtxTem)
		lndexar := .T.
	     ENDIF
***********FIN VALIDACION INDICE DE LA SELECCION

       NEXT

       IF !FILE(PathSis+'\'+fNtxPer) .OR. lndexar
	  lndexar := .T.
       ENDIF

       IF !FILE(PathSis+'\'+Ntx1Per) .OR. lndexar
	  lndexar := .T.
       ENDIF
*>>>>FIN VALIDACION DE LOS INDICES

*>>>>ACTUALIZACION DE ESTRUCTURAS DEL NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	   nActStrTbl(lShared,cPatSis+'\'+cMaeAct,;
			      FConTbl+cMaeAct+ExtFile)
	   nActStrGru(lShared,cPatSis+'\'+cMaeAct,;
			      FileGru+cMaeAct+cAnoSis+ExtFile)
	   nActStrSuN(lShared,cPatSis+'\'+cMaeAct,;
			      FileSuN)
	   nActStrSuG(lShared,cPatSis+'\'+cMaeAct,;
			      FileSuG)
	   nActStrJvf(lShared,nModCry,cPatSis+'\'+cMaeAct,FileJvf)

	   nActStrSin(lShared,nModCry,cPatSis+'\'+cMaeAct,;
		      FileSin+cMaeAct+cAnoSis+ExtFile)

	   IF lActStrAlu(lShared,cPatSis+'\'+cMaeAct,;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,;
			 cMaeAct,cAnoUsr)

	      lndexar := .T.
	   ENDIF
       NEXT
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS DEL NIVEL

*>>>>CREACION DE LOS INDICES
       IF lndexar
	  RESTSCREEN(0,0,24,79,cSavPan)
	  Indexar(cPatSis,cAnoUsr,cMaeAlu)
       ENDIF
*>>>>FIN CREACION DE LOS INDICES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnArc := .F.
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)
	  CloseDbf('SCO')
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       lPrnArc := SCO->lPrnArcCon
       cSerFac := ALLTRIM(SCO->cSerFacCon)
       CloseDbf('SCO')
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF lPrnArc
	  FileTem := cFileTempo(PathPrn+'\',SUBS(cNomUsr,1,4),'.PRN')
	  SET PRINTER TO &FileTem              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       cPatSis := cPatTem
       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN cPatInt
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION ARCHIVOS GENERALES DEL SISTEMA        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   MAY 02/95 MAR

OBJETIVOS:

1)- Crea todos los archivos generales del sistema

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,cPatSis,cAnoUsr,lIntUno,lIntDos,lIntTre,lIntCua,;
		    bInfSys)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cIntUno                              // Path de Integraci¢n uno
       bInfSys                              // Block Informes del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL nModCry := 0                   // Modo de Protecci¢n
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
       CreaSimCon(lShared,PathSis,fSimaCo,lIntUno)

       Termometro(80)
       CreaDbfPer(lShared,nModCry,PathSis,FilePer)

       Termometro(90)
       CreaDbfInf(lShared,nModCry,PathSis,FileInf,,bInfSys)

       Termometro(100)
       CreaDbfIso(lShared,nModCry,PathSis,FileIso)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION ARCHIVOS GENERALES DEL SISTEMA        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   MAY 02/95 MAR

OBJETIVOS:

1)- Crea todos los archivos generales del a¤o del sistema

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfAno(lShared,nModCry,cPatSis,cAnoUsr,;
		    lIntUno,lIntDos,lIntTre,lIntCua)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cIntUno                              // Path de Integraci¢n uno */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS GENERALES DEL A¥O")

       Termometro(12)
       CreaConAno(lShared,cPatSis,fConAno+cAnoUsr+ExtFile,lIntUno)

       Termometro(24)
       CreaDbfPro(lShared,cPatSis,FilePro+cAnoSis+ExtFile,lIntUno)

       Termometro(36)
       CreaDbfPaz(lShared,nModCry,cPatSis,fPazEst+cAnoSis+ExtFile)

       Termometro(48)
       CreaDbfDpz(lShared,nModCry,cPatSis,fDpzEst+cAnoSis+ExtFile)

       Termometro(60)
       CreaDbfOrg(lShared,cPatSis,FileOrg,lIntUno)

/*
       Termometro(70)
       CreaDbfHor(lShared,nModCry,cPatSis,FileHor)
*/

       Termometro(75)
       CreaDbfHra(lShared,nModCry,cPatSis,FileHra)

       Termometro(85)
       CreaDbfFun(lShared,cPatSis,FileFun,lIntUno)

       Termometro(95)
       CreaCorBol(lShared,nModCry,cPatSis,fCorBol)

       CreaDbfTus(lShared,nModCry,cPatSis,fTipUsr)
       Termometro(95)

       CreaDbfCol(lShared,nModCry,cPatSis,fColPrc)
       Termometro(100)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LOS ARCHIVOS DEL SISTEMAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/95 MAR A
       Colombia, Bucaramanga        INICIO: 01:10 PM   MAY 02/95 MAR

OBJETIVOS:

1)- Crea todos los archivos de la aplicaci¢n o del sistema

2)- Retorna NIL

SINTAXIS:

  CrearDbfs(lIntUno,cPatSis,SUBS(cAnoUsr,3,2),cMaeAlu)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbfs(lShared,cPatSis,cAnoUsr,lIntUno,;
		   lIntDos,lIntTre,lIntCua,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cPatSis			            // Path del sistema
       cAnoUsr                              // A¤o del usuario
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cIntUno                              // Path de Integraci¢n uno
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nModCry := 0                   // Modo de Protecci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       cSavPan := SAVESCREEN(0,0,24,79)
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. LEN(cMaeAlu) == 3
	     Termometro(0,"CREANDO LOS ARCHIVOS DEL JARDIN")
       CASE 'PRI' $ cMaeAlu .AND. LEN(cMaeAlu) == 3
	     Termometro(0,"CREANDO LOS ARCHIVOS DEL PRIMARIA")
       CASE 'BTO' $ cMaeAlu .AND. LEN(cMaeAlu) == 3
	     Termometro(0,"CREANDO LOS ARCHIVOS DEL BACHILLERATO")
       OTHERWISE
	     Termometro(0,"CREANDO LOS ARCHIVOS DEL SISTEMA")
       ENDCASE

       Termometro(5)
       CreaDbfEmp(lShared,cPatSis,FileEmp,lIntUno)

       Termometro(10)
       CreaDbfMat(lShared,cPatSis,FileMat,lIntUno)

       Termometro(15)
       CreaDbfSuN(lShared,cPatSis,FileSuN,lIntUno)

       Termometro(20)
       CreaDbfSuG(lShared,cPatSis,FileSuG,lIntUno)

       IF 'JAR' $ cMaeAlu

	  Termometro(25)
	  CreaConTbl(lShared,cPatSis,FConTbl+'JAR'+ExtFile,lIntUno)

	  Termometro(30)
	  CreaDbfCla(lShared,nModCry,cPatSis,FileCla)

	  Termometro(35)
	  CreaDbfEva(lShared,cPatSis,FileEva,lIntUno)

	  Termometro(40)
	  CreaDbfApr(lShared,cPatSis,FileApr,lIntUno)

	  Termometro(45)
	  CreaDbfNro(lShared,cPatSis,FNroInd+'JAR'+cAnoSis+ExtFile,lIntUno)

	  Termometro(50)
	  CreaDbfCar(cPatSis,FileCar+'JAR'+ExtFile)

	  Termometro(55)
	  CreaDbfSel(lShared,nModCry,cPatSis,;
		     FileSel+'JAR'+ExtFile,fNtxSel+'JAR'+cExtNtx)

	  Termometro(60)
	  CreaDbfAlu(cPatSis,FMaeJar+cAnoSis+ExtFile,'JAR',;
			     fNtxJar+cAnoSis+cExtNtx)
	  Termometro(65)
	  CreaDbfGru(lShared,cPatSis,FGruJar+cAnoSis+ExtFile,lIntUno)

	  Termometro(70)
	  CreaDbfNiv(lShared,cPatSis,FileNiv+cAnoSis+ExtFile,NIL,'JAR')

	  Termometro(75)
	  CreaDbfJui(lShared,nModCry,cPatSis,FJuiJar+cAnoSis+ExtFile)

	  Termometro(80)
	  CreaDbfHab(lShared,cPatSis,FileHab+cAnoSis+ExtFile)

	  Termometro(85)
	  CreaDbfJvf(lShared,nModCry,cPatSis,FileJvf)

	  Termometro(100)
	  CreaDbfSin(lShared,nModCry,cPatSis,;
		     FileSin+'JAR'+cAnoSis+ExtFile)

       ENDIF
     *ÀCreaci¢n archivos de Jard¡n

       IF 'PRI' $ cMaeAlu

	  Termometro(25)
	  CreaConTbl(lShared,cPatSis,FConTbl+'PRI'+ExtFile,lIntUno)

	  Termometro(30)
	  CreaDbfCla(lShared,nModCry,cPatSis,FileCla)

	  Termometro(35)
	  CreaDbfEva(lShared,cPatSis,FileEva,lIntUno)

	  Termometro(40)
	  CreaDbfApr(lShared,cPatSis,FileApr,lIntUno)

	  Termometro(45)
	  CreaDbfNro(lShared,cPatSis,FNroInd+'PRI'+cAnoSis+ExtFile,lIntUno)

	  Termometro(50)
	  CreaDbfCar(cPatSis,FileCar+'PRI'+ExtFile)

	  Termometro(55)
	  CreaDbfSel(lShared,nModCry,cPatSis,;
		     FileSel+'PRI'+ExtFile,fNtxSel+'PRI'+cExtNtx)

	  Termometro(60)
	  CreaDbfAlu(cPatSis,FMaePri+cAnoSis+ExtFile,'PRI',;
			     fNtxPri+cAnoSis+cExtNtx)
	  Termometro(65)
	  CreaDbfGru(lShared,cPatSis,FGruPri+cAnoSis+ExtFile,lIntUno)

	  Termometro(70)
	  CreaDbfNiv(lShared,cPatSis,FileNiv+cAnoSis+ExtFile,NIL,'PRI')

	  Termometro(75)
	  CreaDbfJui(lShared,nModCry,cPatSis,FJuiPri+cAnoSis+ExtFile)

	  Termometro(80)
	  CreaDbfHab(lShared,cPatSis,FileHab+cAnoSis+ExtFile)

	  Termometro(90)
	  CreaDbfJvf(lShared,nModCry,cPatSis,FileJvf)

	  Termometro(100)
	  CreaDbfSin(lShared,nModCry,cPatSis,;
		     FileSin+'PRI'+cAnoSis+ExtFile)
       ENDIF
     *ÀCreaci¢n archivos de Primaria

       IF 'BTO' $ cMaeAlu

	  Termometro(25)
	  CreaConTbl(lShared,cPatSis,FConTbl+'BTO'+ExtFile,lIntUno)

	  Termometro(30)
	  CreaDbfCla(lShared,nModCry,cPatSis,FileCla)

	  Termometro(35)
	  CreaDbfEva(lShared,cPatSis,FileEva,lIntUno)

	  Termometro(40)
	  CreaDbfApr(lShared,cPatSis,FileApr,lIntUno)

	  Termometro(45)
	  CreaDbfNro(lShared,cPatSis,FNroInd+'BTO'+cAnoSis+ExtFile,lIntUno)

	  Termometro(50)
	  CreaDbfCar(cPatSis,FileCar+'BTO'+ExtFile)

	  Termometro(55)
	  CreaDbfSel(lShared,nModCry,cPatSis,;
		     FileSel+'BTO'+ExtFile,fNtxSel+'BTO'+cExtNtx)

	  Termometro(60)
	  CreaDbfAlu(cPatSis,FMaeBto+cAnoSis+ExtFile,'BTO',;
			    fNtxBto+cAnoSis+cExtNtx)
	  Termometro(65)
	  CreaDbfGru(lShared,cPatSis,FGruBto+cAnoSis+ExtFile,lIntUno)

	  Termometro(70)
	  CreaDbfNiv(lShared,cPatSis,FileNiv+cAnoSis+ExtFile,NIL,'BTO')

	  Termometro(75)
	  CreaDbfJui(lShared,nModCry,cPatSis,FJuiBto+cAnoSis+ExtFile)

	  Termometro(80)
	  CreaDbfHab(lShared,cPatSis,FileHab+cAnoSis+ExtFile)

	  Termometro(85)
	  CreaDbfJvf(lShared,nModCry,cPatSis,FileJvf)

	  Termometro(100)
	  CreaDbfSin(lShared,nModCry,cPatSis,;
		     FileSin+'BTO'+cAnoSis+ExtFile)
       ENDIF
     *ÀCreaci¢n archivos de Bachillerato

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: INDEXAR LOS ARCHIVOS DEL SISTEMA               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/95 MAR A
       Colombia, Bucaramanga        INICIO: 01:25 PM   MAY 02/95 MAR

OBJETIVOS:

1- Pone en uso todos los archivos de sistema que estan indexados

2- Crea los archivos indices del sistema

3- Retorna NIL


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Indexar(cPatSis,cAnoUsr,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     cPatSis                              // Path del sistema
       cAnoUsr			            // A¤o del Usuario
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Compartir Archivos
       LOCAL nModCry := 0                   // Modo de Protecci¢n

       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lIndNiv := .T.

       FIELD cCodigoEst
       FIELD cApelliEst
       FIELD cNombreEst

       CloseDbf('JAR')
       CloseDbf('JUI')
       CloseDbf('SEL')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE INDICES PARA EL NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********ANALISIS DEL NIVEL ESCOGIDO
	     cNomNiv := ''
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     DO CASE
	     CASE 'JAR' $ cMaeAct
		  cNomNiv := 'JARDIN'
	     CASE 'PRI' $ cMaeAct
		  cNomNiv := 'PRIMARIA'
	     CASE 'BTO' $ cMaeAct
		  cNomNiv := 'BACHILLERATO'
	     ENDCASE
***********FIN ANALISIS DEL NIVEL ESCOGIDO

***********AREAS DE TRABAJO
	     aUseDbf := {}

	     AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			       FileAlu+cMaeAct+cAnoSis+ExtFile,;
			       cMaeAct,NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			       FileJui+cMaeAct+cAnoSis+ExtFile,;
			       'JUI',NIL,lShared,nModCry})

	     AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			       FileSel+cMaeAct+ExtFile,;
			       'SEL',NIL,lShared,nModCry})
***********FIN AREAS DE TRABAJO

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbfs(aUseDbf)
		cError('ABRIENDO ARCHIVOS PARA INDEXAR '+cNomNiv)
		CloseDbf(cMaeAct)
		CloseDbf('JUI')
		CloseDbf('SEL')
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********CREACION DE INDEXES
	     Termometro(0,'INDEXANDO A '+cNomNiv)
	     Termometro(20)

	     SELECT &cMaeAct
	     fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
			'MAE'+cMaeAct+cAnoSis+cExtNtx
	     INDEX ON cCodigoEst TO &fNtxTem

	     Termometro(40)
	     fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
			'APE'+cMaeAct+cAnoSis+cExtNtx
	     INDEX ON cApelliEst TO &fNtxTem

	     Termometro(60)
	     fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
			'NOM'+cMaeAct+cAnoSis+cExtNtx
	     INDEX ON cNombreEst TO &fNtxTem

	     Termometro(80)
	     SELECT JUI

	     
	     fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
			fNtxJui+cMaeAct+cAnoSis+cExtNtx
	     IF lIndNiv
		INDEX ON JUI->cCodigoNiv+JUI->cCodigoJui TO &fNtxTem
	     ELSE
		INDEX ON JUI->cCodigoJui TO &fNtxTem
	     ENDIF

	     Termometro(100)
	     SELECT SEL
	     fNtxTem := cPatSis+'\'+cMaeAct+'\'+;
			fNtxSel+cMaeAct+cExtNtx
	     INDEX ON SEL->cCodigoEst+SEL->cCodAreSel TO &fNtxTem

	     CloseDbf(cMaeAct)
	     CloseDbf('JUI')
	     CloseDbf('SEL')
***********FIN CREACION DE INDEXES

       NEXT
*>>>>FIN CREACION DE INDICES PARA EL NIVEL

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePer,'PER',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+'ALU'+ExtFile,'ALU',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+'ARCHI'+ExtFile,'ARC',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAlu+cAnoUsr+ExtFile,'MAE',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAlu+'IMPOR'+ExtFile,'IMP',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAlu+'CON'+cAnoSis+ExtFile,'MAC',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS PARA INDEXAR')
	  CloseDbf('PER')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CREACION DE INDEXES GENERALES
       SELECT PER
       fNtxPer := PathSis+'\'+fNtxPer
       INDEX ON PER->nIdeCodPer TO &fNtxPer

       Ntx1Per := PathSis+'\'+Ntx1Per
       INDEX ON PER->cDocNitPer+PER->cTipNitPer TO &Ntx1Per
       CloseDbf('PER')

       SELECT ALU
       fNtxAlu := 'MAE'
       fNtxAlu := PathSis+'\'+fNtxAlu+'ALU'+cExtNtx
       INDEX ON ALU->cCodigoEst TO &(fNtxAlu)
       CloseDbf('ALU')

       SELECT ARC
       fNtxAlu := 'MAE'
       fNtxAlu := PathSis+'\'+fNtxAlu+'ARCHI'+cExtNtx
       INDEX ON ARC->cCodigoEst TO &(fNtxAlu)
       CloseDbf('ALU')
*>>>>FIN CREACION DE INDEXES GENERALES

*>>>>CREACION DE INDEXES DEL A¥O
       SELECT MAE
       fNtxAlu := 'MAE'
       fNtxAlu := cPatSis+'\'+fNtxAlu+cAnoUsr+cExtNtx
       INDEX ON MAE->cCodigoEst TO &(fNtxAlu)
       CloseDbf('MAE')

       SELECT IMP
       fNtxAlu := 'MAE'
       fNtxAlu := cPatSis+'\'+fNtxAlu+'IMPOR'+cExtNtx
       INDEX ON IMP->cCodigoEst TO &(fNtxAlu)
       CloseDbf('IMP')

       SELECT MAC
       fNtxAlu := 'MAE'
       fNtxAlu := cPatSis+'\'+fNtxAlu+'CON'+cAnoSis+cExtNtx
       INDEX ON MAC->cCodigoEst TO &(fNtxAlu)
       CloseDbf('MAC')

       RETURN NIL
*>>>>FIN CREACION DE INDEXES DEL A¥O

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DE LOS MENUS DE LA APLICACION       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 08:55 AM   MAY 03/95 MIE

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

FUNCTION aMenusCont(nNroOpc,cDerech,aAyudas)

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

	    aMenus := {'1INICIO',;
		       '2PERIODOS',;
		       '3INFORMES',;
		       '4ESTADISTICA',;
		       '5FIN A¥O',;
		       '6CERTIFICADOS',;
		       '7UTILIDADES'}

	    aAyuda := {'Permite efectuar los procesos de comienzo de a¤o.'+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite realizar los procesos por peri¢dos. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite imprimir informes generales del  sistema. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite Generar las Estad¡sticas. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite realizar varias utilidades del sistema. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite efectuar los procesos de final de a¤o. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite actualizar los maestros. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite actualizar los maestros. '+;
		       '<ESC> TERMINA EL PROGRAMA'}

       CASE nNroOpc == 1  // Inicio

	    aMenus := {'1<CONSULTAR ALUMNOS    >',;
		       '2<CONSULTAR PROFESORES >',;
		       '3<GRADOS DE ESTUDIO    >',;
		       '4<TITULARES DE CURSO   >',;
		       '5<AREAS DE CONOCIMIENTO>',;
		       '6<PLAN DE ESTUDIOS     >',;
		       '7<CARGAS ACADEMICAS    >',;
		       '8<CREACION DE GRUPOS   >'}

	    aAyuda := {'Permite consultar la informaci¢n sobre los alumnos. '+;
		       '<ESC> REGRESA',;
		       'Permite consultar e incluir los Docentes del Colegio. '+;
		       '<ESC> REGRESA',;
		       'Permite consultar los niveles de Estudio. '+;
		       '<ESC> REGRESA',;
		       'Permite definir los titulares de grupo. '+;
		       '<ESC> REGRESA',;
		       'Permite definir la tabla general '+;
		       'de las Areas de Conocimiento. <ESC> REGRESA',;
		       'Permite definir plan acad‚mico por niveles. '+;
		       '<ESC> REGRESA',;
		       'Permite definir la carga acad‚mica '+;
		       'de los profesores. <ESC> REGRESA',;
		       'Permite crear los grupos especificados. '+;
		       '<ESC> REGRESA'}

       CASE nNroOpc == 2  // Periodos

	    aMenus := {"1<LECTURA DE NOTAS >",;
		       "2<NOTAS DIGITADAS  >",;
		       "3<DIGITADOS        >",;
		       "4<MODIFICACION     >",;
		       "5<CALCULOS         >",;
		       "6<BOLETINES        >",;
		       "7<RESUMENES        >",;
		       "8<CORRECIONES      >",;
		       "9<BOLETINES RECUPER>"}

	    aAyuda := {'Permite leer las notas de los estudiantes. '+;
		       '<ESC> REGRESA',;
		       'Permite imprimir la notas digitadas '+;
		       'para correcci¢n. <ESC> REGRESA',;
		       'Permite imprimir la juicios digitados '+;
		       'para correcci¢n. <ESC> REGRESA',;
		       'Permite modificar las notas de los estudiantes. '+;
		       '<ESC> REGRESA',;
		       'Visualiza el menu de los calculos',;
		       'Permite imprimir los boletines. '+;
		       '<ESC> REGRESA',;
		       'Permite imprimir los cuadros de '+;
		       'resumen de los estudiantes. <ESC> REGRESA',;
		       'Permite Autorizar las Correciones de los Estudiantes',;
		       'Permite imprimir los boletines de solo recuperaciones'}


       CASE nNroOpc == 3  // Informes

	    aMenus  := {"1<POR PROFESOR            >",;
			"2<CONTROL DE ASISTENCIAS  >",;
			"3<DIRECTORIO DE ALUMNOS   >",;
			"4<DIRECTORIO DE PROFESORES>",;
			"5<CARGAS ACADEMICAS       >",;
			"6<CARNETS ESTUDIANTIL     >",;
			"7<RESUMEN DE JUICIOS      >",;
			"8<ESTUDIANTES POR GRABAR  >",;
			"9<FAMILIAS DEL COLEGIO    >"}

	    aAyuda := {'Permite imprimir varios informes por Profesor. '+;
		       '<ESC> REGRESA',;
		       'Permite imprimir listas para control de asistencia. '+;
		       '<ESC> REGRESA',;
		       'Permite imprimir el directorio de alumnos. '+;
		       '<ESC> REGRESA',;
		       'Permite imprimir el directorio de profesores. '+;
		       '<ESC> REGRESA',;
		       'Permite imprimir la carga acad‚mica de los '+;
		       'profesores. <ESC> REGRESA',;
		       'Permite imprimir los carnets de los estudiantes. '+;
		       '<ESC> REGRESA',;
		       'Imprime el resumen de los juicios valorativos',;
		       'Imprime los estudiantes que no han sido selecionados',;
		       'Imprime las Familias del Colegio'}


       CASE nNroOpc == 4  // Estadisticas

	    aMenus := {}
	    AADD(aMenus,'1<POR ESTUDIANTE >')
	    AADD(aMenus,'2<POR MATERIA    >')
	    AADD(aMenus,'3<POR INDICADORES>')
	    AADD(aMenus,'4<CLASIFICACION  >')
/*
	    AADD(aMenus,'2<POR CURSO     >')
	    AADD(aMenus,'3<POR GRADOS    >')
	    AADD(aMenus,'4<POR PROFESOR  >')
	    AADD(aMenus,'6<Pendiente     >')
	    AADD(aMenus,'7<A ARCHIVO     >')
*/

	    aAyuda := {}
	    AADD(aAyuda,'Imprime las Estad¡sticas por Estudiante')
	    AADD(aAyuda,'Calcula las Estad¡sticas por Materia')
	    AADD(aAyuda,'Calcula las Estad¡sticas por Indicadores')
	    AADD(aAyuda,'Permite la Clasificaci¢n de los Indicadores')
/*
	    AADD(aAyuda,'Imprime las Estad¡sticas por Curso')
	    AADD(aAyuda,'Imprime las Estad¡sticas por Grados')
	    AADD(aAyuda,'Imprime las Estad¡sticas por Profesor')
	    AADD(aAyuda,'Imprime las Estad¡sticas por Materia')
	    AADD(aAyuda,'Pendiente')
	    AADD(aAyuda,'Pendiente')
*/

       CASE nNroOpc == 5  // Fin de a¤o

	    aMenus := {}
	    AADD(aMenus,'1<RECUPERACIONES           >')
	    AADD(aMenus,'2<RELACION DE REPROBADOS   >')
	    AADD(aMenus,'3<OBSERVACIONES LIBRO FINAL>')
	    AADD(aMenus,'4<IMPRESION LIBRO FINAL    >')
	    AADD(aMenus,'5<PROMOCIONES FINALES      >')

	    aAyuda := {}
	    AADD(aAyuda,'Permite realizar todos los procesos de las Recuperaciones.')
	    AADD(aAyuda,'Imprime la relaci¢n de los reprobados.')
	    AADD(aAyuda,'Permite grabar observaciones para el libro del estudiante')
	    AADD(aAyuda,'Imprime el libro final')
	    AADD(aAyuda,'Permite grabar las promociones finales')

       CASE nNroOpc == 6  // Certificados

	    aMenus := {}
	    AADD(aMenus,'1<ESTUDIANTES >')
	    AADD(aMenus,'2<PAZ Y SALVOS>')
	    AADD(aMenus,'3<FORMATOS    >')

	    aAyuda := {}
	    AADD(aAyuda,'Imprime certificados de Estudio para los Estudiantes.')
	    AADD(aAyuda,'Imprime los Paz y Salvos de los Estudiantes.')
	    AADD(aAyuda,'Permite dise¤ar los diferentes formatos para Certificados,Constancias,etc')

       CASE nNroOpc == 7  // Utilidades

	    aMenus := {'1<USUARIOS     >',;
		       '2<CAMBIAR CLAVE>',;
		       '3<REINDEXAR    >',;
		       '4<ACTUALIZAR   >',;
		       '5<MANTENIMIENTO>',;
		       '6<CONFIGURACION>',;
		       '7<VARIOS       >'}
/*
		       '8<OTROS        >',;
		       '9<SIMAVIRTUAL  >'}
*/

	    aAyuda := {'Permite Crear usuarios y Asignar sus derechos.',;
		       'Permite cambiar la clave. ',;
		       'Reindexa los archivos del Sistema.',;
		       'Permite Actualizar las estructuras de los Archivos del Sistema',;
		       'Permite el Mantenimiento de los Archivos del Sistema',;
		       'Permite definir las diferentes Configuraciones del Sistema',;
		       'Men£ con varios procesos utilitarios del Sistema'}
/*
		       'Men£ con otros procesos utilitarios del Sistema',;
		       'Exporta la Base de Datos a MySql'}
*/

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

FUNCTION SubMenus(aP1,lShared,lNovell,cNomSis,cEmpPal,cCodEmp,;
		  cNitEmp,cNomEmp,cNomDpt,cNomMun,nFilPal,aColSup,;
		  cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,;
		  lIntCua,cMaeAlu,cMaeAct,cJorTxt,cJornad,nColAno,;
		  nOpcion,nOpcPal,cDerech,cSavPan)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cCodEmp                              // C¢digo de la Empresa
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       aColSup                              // Columnas para los sub_men£s
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       nColAno                              // Columna A¤o del sistema
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       cDerech                              // Derechos del Usuario
       cSavPan                              // Salvar Pantalla */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>PARAMETROS GENERALES
       LOCAL aP2 := {}                  // Parametros Generales
       LOCAL aP3 := {}                  // Parametros Generales
*>>>>FIN PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL cPatInt := ''                  // Path de Integraci¢n
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

       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSec := ''                  // Nombre secundario

       LOCAL cDerSys := ''                  // Derechos del Sistema

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
     *ÀVariables archivos

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

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESARROLLO DEL PRIMER NIVEL
       cDerech := cDerAppSys(cDerech,cDerSys)
       DO WHILE .T.

**********AREAS DE TRABAJO
	    aUseDbf := {}
	    AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared,nModCry})
	    AADD(aUseDbf,{.T.,cPatSis+'\'+;
			      FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})
**********FIN AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbfs(aUseDbf)
	       cError('ABRIENDO LOS ARCHIVOS')
	       CloseAll(aUseDbf)
	       QUIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE SCO->(RECCOUNT()) == 0
		 cError('NO EXISTE CONFIGURACION GENERAL')

	    CASE COA->(RECCOUNT()) == 0
		 cError('NO EXISTE CONFIGURACION DEL A¥O')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseAll(aUseDbf)
	       QUIT
	    ENDIF

	    nPrueba := SCO->nPruebaSco
	    lPrnArc := SCO->lPrnArcCon
	    nCodPrn := SCO->nCodigoPrn
	    cOpcPrn := SCO->cOpcPrnCon
	    cUsrIso := SCO->cUsrIsoSco
	    nCodXsl := SCO->nCodXslSco
	    cPiePag := SCO->cPiePagSco

*	    cDerSys := COA->cDerechCoA
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LECTURA DEL LOGO DE LA EMPRESA
	    cLogEmp := ''
	    IF !EMPTY(SCO->cLogEmpSco)

	       cPatSim := cPathSima()
	       cLogEmp := cPatSim+'\'+'SimaCont\Bases\'+;
			  ALLTRIM(SCO->cLogEmpSco)
	    ENDIF
	    CloseDbf('SCO')
	    CloseDbf('COA')

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
	    PathConAno(lShared,cAnoUsr,cPatSis,;
		       @PathUno,@PathDos,@PathTre,@PathCua,.F.)

	    nParameSet(aP1,'PathUno',PathUno)
	    nParameSet(aP1,'PathDos',PathDos)
	    nParameSet(aP1,'PathTre',PathTre)
	    nParameSet(aP1,'PathCua',PathCua)
	    CloseAll()
**********FIN LECTURA DE PATHS

**********SELECCION DE LOS SUBMENUS
	    @ 100,100 SAY ""
	    CloseAll()

	    lSiMenu := .T.
	    aDeMenu := aMenusCont(nOpcPal,;
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

		 nParameSet(aP1,'cPatSis',cPatSis)
		 nParameSet(aP1,'cAnoUsr',cAnoUsr)
		 nParameSet(aP1,'cAnoSis',SUBS(cAnoUsr,3,2))
*--------------FIN CAMBIA EL A¥O DEL SISTEMA

	       nNroOpc := nMenu(aMenu,aHelp,;
				nFilSup,nColSup,NIL,NIL,nNroOpc,NIL)

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

**********PARAMETROS GENERALES
	    nFilInf := nFilSup + LEN(aMenu) + 1
	    nColInf := aColSup[nOpcion]

	    nParameSet(aP1,'nFilInf',nFilInf)
	    nParameSet(aP1,'nColInf',nColInf)
**********FIN PARAMETROS GENERALES

**********ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL
	    DO CASE
	    CASE nOpcPal == 1  // <INICIO>

		 DO CASE
		 CASE nNroOpc == 1

		      MantenAlu(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomDpt,cNomMun,nFilPal,nFilInf,;
				nColInf,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
				lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
				cJorTxt,cJornad)
		     *Mantenimiento del archivo Alumnos


		 CASE nNroOpc == 2
		      MantenPro(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomDpt,cNomMun,nFilPal,nFilInf,;
				nColInf,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
				lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
				cJorTxt,cJornad)
		     *Mantenimiento del archivo profesores

		 CASE nNroOpc == 3
		      MantenNiv(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomDpt,cNomMun,nFilPal,nFilInf,;
				nColInf,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
				lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
				cJorTxt,cJornad)
		     *Mantenimiento del archivo niveles


		 CASE nNroOpc == 4
		      Conta_104(aP1,aP2,aP3)
		     *Titulares de grado

		 CASE nNroOpc == 5
		      Conta_105(aP1,aP2,aP3)
		     *Areas de conocimiento

		 CASE nNroOpc == 6
		      Conta_106(aP1,aP2,aP3)
		     *Plan Acad‚mico

		 CASE nNroOpc == 7
		      Conta_107(aP1,aP2,aP3)
		     *Cargas Acad‚micas

		 CASE nNroOpc == 8
		      Conta_108(aP1,aP2,aP3)
		     *Creaci¢n de grupos

		 ENDCASE

	    CASE nOpcPal == 2  // <PERIODOS>

		 DO CASE
		 CASE nNroOpc == 1
		      Conta_201(aP1,aP2,aP3)
		     *Lectura de notas

		 CASE nNroOpc == 2
		      Conta_202(aP1,aP2,aP3)
		     *Notas digitadas

		 CASE nNroOpc == 3
		      Conta_203(aP1,aP2,aP3)
		     *Juicios digitados

		 CASE nNroOpc == 4
		      Conta_204(aP1,aP2,aP3)
		     *Modificaci¢n de notas

		 CASE nNroOpc == 5
		      Conta_205(aP1,aP2,aP3)
		     *Calculos

		 CASE nNroOpc == 6
		      Conta_206(aP1,aP2,aP3)
		     *Boletines

		 CASE nNroOpc == 7

		      Conta_207(aP1,aP2,aP3)
		     *Resumenes

		 CASE nNroOpc == 8
		      Conta_208(aP1,aP2,aP3)
		     *Retiro o activaci¢n de Estudiantes

		 CASE nNroOpc == 9

		      Conta_209(aP1,aP2,aP3)
		     *Modificaci¢n de indicadores

		 ENDCASE

	    CASE nOpcPal == 3  // <INFORMES>

		 DO CASE
		 CASE nNroOpc == 1
		      Conta_301(aP1,aP2,aP3)
		     *Por Profesor

		 CASE nNroOpc == 2
		      Conta_302(aP1,aP2,aP3)
		     *Control de asistencia

		 CASE nNroOpc == 3
		      Conta_303(aP1,aP2,aP3)
		      *Directorio de Alumnos

		 CASE nNroOpc == 5
		      Conta_305(aP1,aP2,aP3)
		     *Creaci¢n de las cargas Academicas.

		 CASE nNroOpc == 6
		      Conta_306(aP1,aP2,aP3)
		     *Carnets Estudiantil

		 CASE nNroOpc == 7
		      Conta_307(aP1,aP2,aP3)
		     *Resumen Juicios

		 CASE nNroOpc == 8
		      Conta_308(aP1,aP2,aP3)
		     *Estudiantes por grabar.

		 CASE nNroOpc == 9

*=====================AREAS DE TRABAJO
			aArchvo := {}
			AADD(aArchvo,{cPatSis+'\'+FileFam,NIL,'FAM'})
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
				  cJorTxt)
*=====================FIN MANTENIMIENTO DEL ARCHIVO

		 ENDCASE

	    CASE nOpcPal == 4  // <ESTADISTICAS>

		 DO CASE
		 CASE nNroOpc == 1
		      Conta_401(aP1,aP2,aP3)
		     *Estad¡stica por estudiante

		 CASE nNroOpc == 2
		      Conta_402(aP1,aP2,aP3)
		     *Estad¡stica por Materia

		 CASE nNroOpc == 3
		      Conta_403(aP1,aP2,aP3)
		     *Estad¡sticas por Indicadores

		 CASE nNroOpc == 4

*=====================AREAS DE TRABAJO
			aArchvo := {}
			AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
			AADD(aArchvo,{PathSis+'\'+FileIso,NIL,'ISO'})
			AADD(aArchvo,{PathSis+'\'+FileInf,NIL,'INF'})
			AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
				      FileSin+cMaeAct+cAnoSis+ExtFile,;
				      NIL,'SIN'})
*=====================FIN AREAS DE TRABAJO

*=====================MANTENIMIENTO DEL ARCHIVO
			lModReg := IF(nPrueba==0,.F.,.T.)
			lDelReg := IF(nPrueba==0,.F.,.T.)
			lInsReg := .F.
			lHaySql := .F.
			bInsReg := NIL

			MantenSin(aP1,aP2,aP3,;
				  aArchvo,cOpcPrn,nCodPrn,lModReg,;
				  lDelReg,lInsReg,lHaySql,bInsReg)
		      *ÀClasificaci¢n de Indicadores
*=====================FIN MANTENIMIENTO DEL ARCHIVO

		 CASE nNroOpc == 7
		      Conta_407(aP1,aP2,aP3)
		     *Lista de Estudiantes a Archivo
		 ENDCASE

	    CASE nOpcPal == 5  // <FIN A¥O>

		 DO CASE
		 CASE nNroOpc == 1
		      Conta_501(aP1,aP2,aP3)
		     *Habilitaciones

		 CASE nNroOpc == 2
		      Conta_502(aP1,aP2,aP3)
		     *Reprobados

		 CASE nNroOpc == 3
		      Conta_503(aP1,aP2,aP3)
		     *Grabaci¢n de Observaciones para el libro.

		 CASE nNroOpc == 4
		      Conta_504(aP1,aP2,aP3)
		     *Libro Final

		 CASE nNroOpc == 5
		      Conta_505(aP1,aP2,aP3)
		     *Aprobaciones finales
		 ENDCASE

	    CASE nOpcPal == 6  // <CERTIFICADOS>

		 DO CASE
		 CASE nNroOpc == 1
		      Conta_601(aP1,aP2,aP3,cJornad)
		     *Certificados Estudiantes

		 CASE nNroOpc == 2
		      Conta_602(aP1,aP2,aP3)
		     *Paz y Salvos

		 CASE nNroOpc == 3
		      Conta_603(aP1,aP2,aP3)
		     *Formatos para los Certificados.

		 ENDCASE

	    CASE nOpcPal == 7  // <UTILIDADES>

		 DO CASE
		 CASE nNroOpc == 1
		      MantenUsr(lShared,PathSis,FileAaa,{|nOpcion,aAyudas|;
				aMenusCont(nOpcion,'1111111111',aAyudas)},;
				cNomSis,.F.)
		     *Mantemiento de usuarios

		 CASE nNroOpc == 2
		      CamPasWor(lShared,nFilInf+1,aColSup[nOpcion],;
				PathSis,FileAaa,cNomUsr)
		     *Cambiar el PassWord del usuario

		 CASE nNroOpc == 3

		      RESTSCREEN(0,0,24,79,cSavPan)
		      Indexar(cPatSis,cAnoUsr,cMaeAlu)
		    *ÀCreaci¢n de Indices

		 CASE nNroOpc == 4
		      Conta_704(aP1,aP2,aP3)
		     *Actualizaci¢n de Estructuras.

		 CASE nNroOpc == 5
		      Conta_705(aP1,aP2,aP3)
		     *Mantenimientos de Archivos

		 CASE nNroOpc == 6
		      Conta_706(aP1,aP2,aP3,;
				{|nOpcion,aAyudas|;
				  aMenusCont(nOpcion,'1111111111',aAyudas)})
		     *Configuraciones.

		 CASE nNroOpc == 7
		      Conta_707(aP1,aP2,aP3)
		     *Men£ de utilidades varios.

		 CASE nNroOpc == 8

		      Conta_708(aP1,aP2,aP3)
		     *Men£ de utilidades otros.

		 CASE nNroOpc == 9
		      Conta_709(aP1,aP2,aP3)
		     *Simavirtual

		 ENDCASE

	    ENDCASE
	    RESTSCREEN(0,0,24,79,cSavPan)
	    RESTSCREEN(0,0,02,79,cSavLin)
	    CLOSE ALL
**********FIN ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN DESARROLLO DEL PRIMER NIVEL

/*************************************************************************
* TITULO ..: LECTURA DEL COLOR DEL SISTEMA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 02/2004 MAR A
       Colombia, Bucaramanga        INICIO: 06:00 PM   NOV 02/2004 MAR

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
		    PathClr,FileClr,PathSis,fSimaCo)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path General del sistema
       fSimaCo			            // Configuraci¢n del Sistema */
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
       IF !FILE(PathSis+'\'+fSimaCo)
	  RecuSimCon(lShared,PathSis,fSimaCo)
       ENDIF
       IF !FILE(PathClr+'\'+FileClr)
	  RecuDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrCon(lShared,PathSis,fSimaCo)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrClr(lShared,nModCry,PathClr,FileClr)
     *ÀActualizaci¢n de la Configuraci¢n del Colo
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysCon(lShared,nModCry)
       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR

/*************************************************************************
* TITULO ..: DERECHOS DEL SISTEMA                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 11/2007 LUN A
       Colombia, Bucaramanga        INICIO: 06:15 PM   FEB 11/2007 LUN

OBJETIVOS:

1- Activa los derechos del Sistema

2- Retorna los derecos del Sistema

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDerAppSys(cDerUsr,cDerSys)

*>>>>DESCRIPCION DE PARAMETROS
/*     cDerUsr                              // Derechos del Usuario
       cDerSys                              // Derechos del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>OPCION DE CLASIFICACION
      i := 34
      IF VAL(SUBS(cDerUsr,i,1)) == 1 .AND.;
	 VAL(SUBS(cDerSys,i,1)) == 0
	 cDerUsr := STUFF(cDerUsr,i,1,'0')
      ENDIF
      RETURN cDerUsr
*>>>>FIN OPCION DE CLASIFICACION