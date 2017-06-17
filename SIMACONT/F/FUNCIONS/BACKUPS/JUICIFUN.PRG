/*               	SISTEMA DE GRABACION DE JUICIOS
		       BIBLIOTECAS DE FUNCIONES GENERALES

REQUERIMIENTOS:

- Compilar: clipper JuiciFun /w/m/b

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 18/95 SAB A
       Bucaramanga,Colombia         INICIO: 03:00 PM   FEB 18/95 SAB

OBJETIVOS:

1- Define por defecto los parametros de la aplicaci¢n

1- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IniJuici(cNomEmp,cNomSis,lSisInt,cTipSis,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       lSisInt                              // .T. Sistema Integrado
       cTipSis                              // Tipo del sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "CAMPOS\ARC-JUIC.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nMemMin := 1000000             // M¡nimo espacio en disco
       LOCAL nOpeFil := 12                  // M¡nimo archivos abiertos
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

/*>>>>ANALISIS PARA EL CONTROL INTERNO DEL PROGRAMA
       DO CASE
       CASE CHECKSUM(cMaeAlu)+4 <> 151152049
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE CHECKSUM(cNomEmp)+4 <> 487023780
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE CHECKSUM(cNomSis)+4 <> 470228333
	    cError('DA¥OS EN EL NOMBRE DEL SISTEMA')
	    QUIT
       CASE CHECKSUM(cTipSis)+4 <> 554230834 .AND. lSisInt
	    cError('DA¥OS EN EL NOMBRE DEL SISTEMA')
	    QUIT
       CASE CHECKSUM(cTipSis)+4 <> 604611055 .AND. !lSisInt
	   cError('DA¥OS EN EL NOMBRE DEL SISTEMA')
	   QUIT
       CASE VOLSERIAL()+24 <> 479494250
	    BOOTCOLD()
       ENDCASE
*>>>>FIN ANALISIS PARA EL CONTROL INTERNO DEL PROGRAMA */

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
       SET CENTURY     OFF                  // A¤o formato 99
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 18/95 SAB A
       Bucaramanga,Colombia         INICIO: 03:05 PM   FEB 18/95 SAB

OBJETIVOS:

1)- Crea el directorio de la aplicaci¢n para el a¤o especificado si
    no existe.

2)- Crea las estructuras de los archivos de la aplicaci¢n en caso de no
    existir.

3)- Recupera las estructuras de los archivos de la aplicaci¢n en caso
    de p‚rdida.

4)- Indexa los archivos de la aplicaci¢n en caso de no existir

5)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevisarDbf(cNomEmp,cNomSis,cNomUsr,lSisInt,;
		    cPatSis,cAnoSys,cSavPan,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del usuario
       lSisInt                              // .T. Sistema integrado
       cPatSis                              // Path del sistema
       cAnoSys                              // A¤o para la aplicaci¢n
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "CAMPOS\ARC-JUIC.PRG"       // Archivos del Sistema

       LOCAL lShared := .T.                 // Compartirar Archivos
       LOCAL cPatInt := ''                  // Path de Integraci¢n
       LOCAL cAnoSis := SUBS(cAnoSys,3,2)   // Path del sistemas
       LOCAL PathAct := ''                  // Path Actual
       LOCAL cPatTem := ''                  // Path temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION O CREACION DEL DIRECTORIO VARIABLE
       PathAct := cPathAct()
       cPatTem = cPatSis+'/'
       DO CASE
       CASE DIRCHANGE (cPatSis) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis) == -3
	    DIRMAKE(cPatSis)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DE DIRECTORIO VARIABLE

*>>>>CREACION Y RECUPERACION DE LAS ESTRUCTURAS
       SET CURSOR OFF
       IF 'JAR' $ cMaeAlu .AND.;
	   !FILE(cPatTem+FileMaJ) .AND. !FILE(cPatTem+FileCoJ)

	   RESTSCREEN(0,0,24,79,cSavPan)
	   CrearDbfs(lSisInt,cPatSis,SUBS(cAnoSys,3,2),'JAR')
       ENDIF
     *ÀCreaci¢n de las estructuras para Jardin

       IF 'PRI' $ cMaeAlu .AND.;
	   !FILE(cPatTem+FileMaP) .AND. !FILE(cPatTem+FileCoP)

	   RESTSCREEN(0,0,24,79,cSavPan)
	   CrearDbfs(lSisInt,cPatSis,SUBS(cAnoSys,3,2),'PRI')
       ENDIF
     *ÀCreaci¢n de las estructuras para Primaria

       IF 'BTO' $ cMaeAlu .AND.;
	   !FILE(cPatTem+FileMaB) .AND. !FILE(cPatTem+FileCoB)

	   RESTSCREEN(0,0,24,79,cSavPan)
	   CrearDbfs(lSisInt,cPatSis,SUBS(cAnoSys,3,2),'BTO')
       ENDIF
     *ÀCreaci¢n de las estructuras para Bachillerato

       IF 'JAR' $ cMaeAlu .AND. !lSisInt
	  IF !FILE(cPatTem+FileMaJ)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfMat(cPatSis,FileMaJ,NIL,'JAR')
	  ENDIF

	  IF !FILE(cPatTem+FileCoJ)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfCod(cPatSis,FileCoJ,NIL,'JAR')
	  ENDIF

	  IF !FILE(cPatTem+FileJuJ)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfCod(cPatSis,FileJuJ,NIL,'JAR')
	  ENDIF
       ENDIF
     *ÀRecuperaci¢n archivos de Jard¡n

       IF 'PRI' $ cMaeAlu .AND. !lSisInt
	  IF !FILE(cPatTem+FileMaP)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfMat(cPatSis,FileMaP,NIL,'PRI')
	  ENDIF

	  IF !FILE(cPatTem+FileCoP)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfCod(cPatSis,FileCoP,NIL,'PRI')
	  ENDIF

	  IF !FILE(cPatTem+FileJuP)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfCod(cPatSis,FileJuP,NIL,'PRI')
	  ENDIF
       ENDIF
     *ÀRecuperaci¢n archivos de Primaria

       IF 'BTO' $ cMaeAlu .AND. !lSisInt
	  IF !FILE(cPatTem+FileMaB)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfMat(cPatSis,FileMaB,NIL,'BTO')
	  ENDIF

	  IF !FILE(cPatTem+FileCoB)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfCod(cPatSis,FileCoB,NIL,'BTO')
	  ENDIF

	  IF !FILE(cPatTem+FileJuB)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RecuDbfCod(cPatSis,FileJuB,NIL,'BTO')
	  ENDIF
       ENDIF
     *ÀRecuperaci¢n archivos de Bachillerato
*>>>>FIN CREACION O RECUPERACION DE LAS ESTRUCTURAS

*>>>>CREACION DE LOS ARCHIVOS DE INDICES
       IF 'JAR' $ cMaeAlu
	  IF !FILE(cPatTem+fNtxCoJ)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     Indexar(lSisInt,cPatInt,cPatSis,cAnoSys,'JAR')
	  ENDIF

	  IF !FILE(cPatTem+fNtxJuJ)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     Indexar(lSisInt,cPatInt,cPatSis,cAnoSys,'JAR')
	  ENDIF

       ENDIF

       IF 'PRI' $ cMaeAlu
	  IF !FILE(cPatTem+fNtxCoP)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     Indexar(lSisInt,cPatInt,cPatSis,cAnoSys,'PRI')
	  ENDIF

	  IF !FILE(cPatTem+fNtxJuP)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     Indexar(lSisInt,cPatInt,cPatSis,cAnoSys,'PRI')
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu
	  IF !FILE(cPatTem+fNtxCoB)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     Indexar(lSisInt,cPatInt,cPatSis,cAnoSys,'BTO')
	  ENDIF

	  IF !FILE(cPatTem+fNtxJuB)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     Indexar(lSisInt,cPatInt,cPatSis,cAnoSys,'BTO')
	  ENDIF
       ENDIF

       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)
       CLOSE ALL
       RETURN cPatInt
*>>>>FIN CREACION DE LOS ARCHIVOS DE INDICES

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LOS ARCHIVOS DEL SISTEMAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 18/95 SAB A
       Bucaramanga,Colombia         INICIO: 03:15 PM   FEB 18/95 SAB

OBJETIVOS:

1)- Crea todos los archivos de la aplicaci¢n o del sistema

2)- Retorna NIL

SINTAXIS:
  CreaDbfs(cAnoSys)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbfs(lSisInt,cPatSis,cAnoSis,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lSisInt                              // .T. Sistema Integrado
       cPatSis			            // Path del sistema
       cAnoSis                              // A¤o del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cPatTem := cPatSis+'/'         // Path temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
*       #INCLUDE "CAMPOS\ARC-JUIC.PRG"       // Archivos del Sistema

       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO LOS ARCHIVOS DEL SISTEMA")

       Termometro(50)
       IF 'JAR' $ cMaeAlu .AND. !lSisInt

	  IF !FILE(cPatTem+FileMaJ)
	     CreaDbfMat(cPatSis,FileMaJ)
	  ENDIF

	  IF !FILE(cPatTem+FileCoJ)
	     CreaDbfCod(cPatSis,FileCoJ,NIL,'JAR')
	  ENDIF

	  IF !FILE(cPatTem+FileJuJ)
	     CreaDbfCod(cPatSis,FileJuJ,NIL,'JAR')
	  ENDIF

       ENDIF
     *ÀCreaci¢n archivos de Jard¡n

       IF 'PRI' $ cMaeAlu .AND. !lSisInt
	  IF !FILE(cPatTem+FileMaP)
	     CreaDbfMat(cPatSis,FileMaP)
	  ENDIF

	  IF !FILE(cPatTem+FileCoP)
	     CreaDbfCod(cPatSis,FileCoP,NIL,'PRI')
	  ENDIF

	  IF !FILE(cPatTem+FileJuP)
	     CreaDbfCod(cPatSis,FileJuP,NIL,'PRI')
	  ENDIF
       ENDIF
     *ÀCreaci¢n archivos de Primaria

       IF 'BTO' $ cMaeAlu .AND. !lSisInt
	  IF !FILE(cPatTem+FileMaB)
	     CreaDbfMat(cPatSis,FileMaB)
	  ENDIF

	  IF !FILE(cPatTem+FileCoB)
	     CreaDbfCod(cPatSis,FileCoB,NIL,'BTO')
	  ENDIF

	  IF !FILE(cPatTem+FileJuB)
	     CreaDbfCod(cPatSis,FileJuB,NIL,'BTO')
	  ENDIF
       ENDIF
     *ÀCreaci¢n archivos de Bachillerato

       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: INDEXAR LOS ARCHIVOS DEL SISTEMA               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 18/95 SAB A
       Bucaramanga,Colombia         INICIO: 03:17 PM   FEB 18/95 SAB

OBJETIVOS:

1- Pone en uso todos los archivos de sistema que estan indexados

2- Crea los archivos indices del sistema

3- Retorna NIL


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Indexar(lSisInt,cPatInt,cPatSis,cAnoSys,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lSisInt                              // .T. Sistema Integrado
       cPatInt			            // Path de Integraci¢n
       cPatSis                              // Patd del sistema
       cAnoSys			            // A¤o del sistema
       cMaeAlu                              // Maestros Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
*       #INCLUDE "CAMPOS\ARC-JUIC.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Compartir Archivos
       LOCAL cAnoSis := SUBS(cAnoSys,3,2)   // A¤o del sistema
       CLOSE ALL                            // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF 'JAR' $ cMaeAlu
	  IF !lUseDbf(.T.,cPatSis+'\'+FileCoJ,'COD',NIL,lShared) .OR.;
	     !lUseDbf(.T.,cPatSis+'\'+FileJuJ,'JUI',NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE JUICIOS DE JARDIN')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu
	  IF !lUseDbf(.T.,cPatSis+'\'+FileCoP,'COD',NIL,lShared) .OR.;
	     !lUseDbf(.T.,cPatSis+'\'+FileJuP,'JUI',NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE JUICIOS DE PRIMARIA')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu
	  IF !lUseDbf(.T.,cPatSis+'\'+FileCoB,'COD',NIL,lShared) .OR. ;
	     !lUseDbf(.T.,cPatSis+'\'+FileJuB,'JUI',NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE JUICIOS DE BACHILLERATO')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>CREACION DE INDEXES
       IF 'JAR' $ cMaeAlu
	  Termometro(0,'INDEXANDO LOS JUICIOS DE JARDIN')
	  Termometro(100)
	  SELECT COD
	  INDEX ON COD->Codigo TO &(cPatSis+'\'+fNtxCoJ)

	  SELECT JUI
	  INDEX ON JUI->Codigo TO &(cPatSis+'\'+fNtxJuJ)
       ENDIF

       IF 'PRI' $ cMaeAlu
	  Termometro(0,'INDEXANDO LOS JUICIOS DE PRIMARIA')
	  Termometro(100)
	  SELECT COD
	  INDEX ON COD->Codigo TO &(cPatSis+'\'+fNtxCoP)

	  SELECT JUI
	  INDEX ON JUI->Codigo TO &(cPatSis+'\'+fNtxJuP)
       ENDIF

       IF 'BTO' $ cMaeAlu
	  Termometro(0,'INDEXANDO LOS JUICIOS DE BACHILLERATO')
	  Termometro(100)
	  SELECT COD
	  INDEX ON COD->Codigo TO &(cPatSis+'\'+fNtxCoB)

	  SELECT JUI
	  INDEX ON JUI->Codigo TO &(cPatSis+'\'+fNtxJuB)
       ENDIF

       CLOSE ALL
       RETURN NIL
*>>>>FIN CREACION DE INDEXES

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DE LOS MENUS DE LA APLICACION       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 18/95 SAB A
       Bucaramanga,Colombia         INICIO: 03:20 PM   FEB 18/95 SAB

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

FUNCTION aMenusJuic(nNroOpc,cDerech,aAyudas)

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

	    aMenus := {'1JUICIOS',;
		       '2UTILIDADES'}

	    aAyuda := {'Permiter grabar los Juicios. '+;
		       '<ESC> TERMINA EL PROGRAMA',;
		       'Permite Ejecutar varias utilidades del sistema. '+;
		       '<ESC> TERMINA EL PROGRAMA'}

       CASE nNroOpc == 1

	    aMenus := {'1<GRABAR      >',;
		       '2<CONSULTAR   >',;
		       '3<MODIFICAR   >',;
		       '4<PARCIALES   >',;
		       '5<CONTABILIDAD>'}

	    aAyuda := {'Permite grabar los juicios. '+;
		       '<ESC> REGRESA',;
		       'Permite Consultar los Juicios. '+;
		       '<ESC> REGRESA',;
		       'Permite Modificar los Juicios. '+;
		       '<ESC> REGRESA',;
		       'Permite Imprimir los Juicios Parciales. '+;
		       '<ESC> REGRESA',;
		       'Permite Imprimir los Juicios de la Contabilidad. '+;
		       '<ESC> REGRESA'}

       CASE nNroOpc == 2

	    aMenus := {'1<USUARIOS      >',;
		       '2<CAMBIAR CLAVE >',;
		       '3<BACKUPS       >',;
		       '4<INDEXAR       >'}

	    aAyuda := {'Permite Crear usuarios y Asignar sus derechos. '+;
		       '<ESC> REGRESA',;
		       'Permite cambiar la clave del usuario. '+;
		       '<ESC> REGRESA',;
		       'Permite hacer backups de los archivos del sistema. '+;
		       '<ESC> REGRESA',;
		       'Indexa los archivos del sistema. '+;
		       '<ESC> REGRESA'}
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 18/95 MIE A
       Bucaramanga,Colombia         INICIO: 03:25 PM   FEB 18/95 MIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubMenus(nOpcion,nOpcPal,nFilPal,aColSup,cNomEmp,;
		  cNomSis,cAnoSys,nColAno,cNomUsr,cDerech,;
		  cSavPan,cMaeAlu,cPatInt,cPatSis,cJorTxt,lSisInt)

*>>>>PARAMETROS DE LA FUNCION
/*     nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       nFilPal                              // Fila Inferior Men£ principal
       aColSup                              // Columnas para los sub_men£s
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cDerech                              // Derechos en el sistema
       cAnoSys	                            // A¤o del Sistema
       nColAno                              // Columna A¤o del sistema
       cMaeAlu                              // Maestros habilitados
       cPatInt			            // Path de Integraci¢n
       cPatSis                              // Path del sistema
       cJorTxt                              // Jornada escogida
       lSisInt                              // .T. Sistema Integrado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "CAMPOS\ARC-JUIC.PRG"       // Archivos del Sistema

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
       LOCAL       i := 0                   // Contador

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESARROLLO DEL PRIMER NIVEL
       DO WHILE .T.

**********SELECCION DE LOS SUBMENUS
	    CLOSE ALL

	    lSiMenu := .T.
	    aDeMenu := aMenusJuic(nOpcPal,;
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

/*--------------CAMBIA EL A¥O DEL SISTEMA
		 LineaEstado('<F2>CAMBIA A¥O. '+;
			     'LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
		 SETKEY(K_F2,{||LeeAnoSys(nColAno,@cAnoSys,;
					  @cPatSis,cNomEmp,cNomSis)})
*--------------FIN CAMBIA EL A¥O DEL SISTEMA */

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

**********ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL
	    nFilInf := nFilSup + LEN(aMenu) + 1
	    DO CASE
	    CASE nOpcPal == 1

		 DO CASE
		 CASE nNroOpc == 1
		      Juici_101(nFilInf,aColSup[nOpcion],nFilPal,cNomEmp,;
		      cNomSis,cAnoSys,cNomUsr,cPatInt,cPatSis,lSisInt,cMaeAlu)
		     *Grabaci¢n de los Juicios

		 CASE nNroOpc == 2
		      Juici_102(nFilInf,aColSup[nOpcion],nFilPal,cNomEmp,;
		      cNomSis,cAnoSys,cNomUsr,cPatInt,cPatSis,lSisInt,cMaeAlu)
		     *Consulta de los Juicios

		 CASE nNroOpc == 3
		      Juici_103(nFilInf,aColSup[nOpcion],nFilPal,cNomEmp,;
		      cNomSis,cAnoSys,cNomUsr,cPatInt,cPatSis,lSisInt,cMaeAlu)
		     *Modificaci¢n de los Juicios

		 CASE nNroOpc == 4
		      Juici_104(nFilInf,aColSup[nOpcion],nFilPal,cNomEmp,;
		      cNomSis,cAnoSys,cNomUsr,cPatInt,cPatSis,lSisInt,cMaeAlu)
		     *Impresi¢n de los Juicios parciales

		 CASE nNroOpc == 5
		      Juici_105(nFilInf,aColSup[nOpcion],nFilPal,cNomEmp,;
		      cNomSis,cAnoSys,cNomUsr,cPatInt,cPatSis,lSisInt,cMaeAlu)
		     *Impresi¢n de los Juicios finales

		 ENDCASE

	    CASE nOpcPal == 2
		 DO CASE
		 CASE nNroOpc == 1
		      CamPasWor(lShared,PathSis,FileAaa,{|nOpcion,aAyudas|;
				aMenusJuic(nOpcion,'1111111111',aAyudas)},;
				cNomSis)
		     *Mantemiento de usuarios

		 CASE nNroOpc == 2
		      CamPasWor(lShared,nFilInf+1,aColSup[nOpcion],;
				PathSis,FileAaa,cNomUsr)
		     *Cambiar el PassWord del usuario

		 CASE nNroOpc == 3

		 CASE nNroOpc == 4
		      Indexar(lSisInt,cPatInt,cPatSis,cAnoSys,cMaeAlu)
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
* TITULO DE LA FUNCION..: SELECCION DE LA JORNADA DE ESTUDIO             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 12/94 JUE A
       Bucaramanga, Colombia        INICIO: 06:00 PM   ENE 12/94 JUE

OBJETIVOS:

1)- Retorna por referencia los param‚tros de la funci¢n marcados con @

2)- Permite escoger la jornada de estudio

3)- Retorna las tres iniciales de la jornada

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJornada(nNroFil,nNroCol,cJornad,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       cJornad			            // Jornadas de estudio
       cJorTxt			            // @Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL       i := 1                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LA JORNADA
       IF 'D' $ cJornad
	  AADD(aMenus,i)
	  aMenus[i++] := 'DIURNA'
       ENDIF

       IF 'N' $ cJornad
	  AADD(aMenus,i)
	  aMenus[i++] := 'NOCTURNA'
       ENDIF

       IF 'M' $ cJornad
	  AADD(aMenus,i)
	  aMenus[i++] := 'MA¥ANA'
       ENDIF

       IF 'T' $ cJornad
	  AADD(aMenus,i)
	  aMenus[i++] := 'TARDE'
       ENDIF

       IF LEN(cJornad) <> 1
	  SAVE SCREEN
	  DO WHILE .T.
	     nNroOpc := nMenu(aMenus,NIL,nNroFil,nNroCol,'JORNADAS',NIL,1)
	     IF nNroOpc <> 0
		EXIT
	     ENDIF
	  ENDDO
	  RESTORE SCREEN
       ENDIF

       cJorTxt := aMenus[nNroOpc]
       RETURN SUBS(aMenus[nNroOpc],1,3)
*>>>>FIN SELECCION DE LA JORNADA

/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DE LA JORNADA DE ESTUDIO             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 20/94 LUN A
       Bucaramanga, Colombia        INICIO: 03:25 PM   FEB 20/94 LUN

OBJETIVOS:

1)- Escoje el nivel en que se va a grabar los juicios: Jardin, Primaria o
    Bachillerato.

2)- Retorna por referencia los param‚tros de la funci¢n marcados con @

3)- Retorna el nivel escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeMaeAlu(cMaeAlu,cNomUsr,cNomMae)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomUsr                              // Nombre del Usuario
       cMaeAlu                              // Maestros Habilitados
       cNomMae                              // @Nombre maestro habilitado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroOpc := 0                   // N£mero de la Opci¢n
       LOCAL cMsgTxt := ''                  // Texto Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NIVEL DE ESTUDIOS
       DO CASE
       CASE UPPER(cNomUsr) == 'JARDIN'
	    cMsgTxt := 'JAR'

       CASE UPPER(cNomUsr) == 'PRIMARIA'
	    cMsgTxt := 'PRI'

       CASE UPPER(cNomUsr) == 'BACHILLER'
	    cMsgTxt := 'BTO'

       CASE cMaeAlu == 'JARPRIBTO'
	    nNroOpc := nLeeOpcion('VA A GRABAR LOS JUICIOS PARA: '+;
			      '1<JARDIN> 2<PRIMARIA> 3<BACHILLERATO?',3,'0')
	    DO CASE
	    CASE nNroOpc == 1
		 cMsgTxt := 'JAR'
	    CASE nNroOpc == 2
		 cMsgTxt := 'PRI'
	    CASE nNroOpc == 3
		 cMsgTxt := 'BTO'
	    ENDCASE

       CASE cMaeAlu == 'JARPRI'
	    nNroOpc := nLeeOpcion('VA A GRABAR LOS JUICIOS PARA: '+;
				'1<JARDIN> 2<PRIMARIA>?',2,'0')
	    cMsgTxt := 'JAR'
	    IF nNroOpc == 2
	       cMsgTxt := 'PRI'
	    ENDIF

       CASE cMaeAlu == 'JARBTO'
	    nNroOpc := nLeeOpcion('VA A GRABAR LOS JUICIOS PARA: '+;
				'1<JARDIN> 2<BACHILLERATO>?',2,'0')
	    cMsgTxt := 'JAR'
	    IF nNroOpc == 2
	       cMsgTxt := 'BTO'
	    ENDIF

       CASE cMaeAlu == 'PRIBTO'
	    nNroOpc := nLeeOpcion('VA A GRABAR LOS JUICIOS PARA: '+;
				'1<PRIMARIA> 2<BACHILLERATO>?',2,'0')
	    cMsgTxt := 'PRI'
	    IF nNroOpc == 2
	       cMsgTxt := 'BTO'
	    ENDIF
       OTHERWISE
	    cMsgTxt := cMaeAlu
       ENDCASE
*>>>>FIN LECTURA DEL NIVEL DE ESTUDIOS

*>>>>ANALISIS DEL MAESTRO ESCOGIDO
       DO CASE
       CASE cMsgTxt == 'JAR'
	    cNomMae := 'JARDIN'
       CASE cMsgTxt == 'PRI'
	    cNomMae := 'PRIMARIA'
       CASE cMsgTxt == 'BTO'
	    cNomMae := 'BACHILLERATO'
       ENDCASE
       RETURN cMsgTxt
*>>>>FIN ANALISIS DEL MAESTRO ESCOGIDO