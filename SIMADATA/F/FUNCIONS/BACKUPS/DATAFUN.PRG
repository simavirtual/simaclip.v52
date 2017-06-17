/*               	  SISTEMA CENTRAL DE RIESGOS
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   ENE 16/2004 VIE

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
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:05 AM   ENE 16/2004 VIE

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
		    cNomEmp,cNomSec,cNomUsr,cAnoUsr,cPatSis,;
		    cSavPan,cMaeAlu,cMaeAct,cIniJor)

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
       cPatSis                              // Path del sistema
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activado
       cIniJor                              // Iniciales de la jornada */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cPatFil := ''                  // Path del archivo
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

*>>>>VERIFICACION O CREACION DEL DIRECTORIO REPORT
       DO CASE
       CASE DIRCHANGE (cPatSis+'\REPORT') == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\REPORT') == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\REPORT') == -3
	    DIRMAKE(cPatSis+'\REPORT')
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO REPORT

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+fErrSys) .AND.;
	    !FILE(PathSis+'\'+fSimDat) .AND.;
	    !FILE(PathSis+'\'+FileClr) .AND.;
	    !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis+'\'+FileEmp)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,nModCry,cPatSis,cAnoUsr)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+fSimDat)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfDat(lShared,nModCry,PathSis,fSimDat)
	      ENDIF

	      IF !FILE(PathSis+'\'+fErrSys)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuErrSys(lShared,nModCry,PathSis,fErrSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FilePrn)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPrn(lShared,nModCry,PathSis,FilePrn)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileEmp)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfEmp(lShared,nModCry,PathSis,FileEmp)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(cPatSis+'\'+fDatAno+cAnoUsr+ExtFile)
	    RESTSCREEN(0,0,24,79,cSavPan)
	    CrearDbfs(lShared,nModCry,cPatSis,cAnoUsr,cMaeAlu)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS DEL SISTEMA
	      IF !FILE(cPatSis+'\'+fDatAno+cAnoUsr+ExtFile)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuCarAno(lShared,nModCry,cPatSis,;
			    fDatAno+cAnoUsr+ExtFile)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS DEL SISTEMA

       ENDCASE
*>>>>FIN CREACION O RECUPERACION DE ESTRUCTURAS ESPECIFICAS DEL SISTEMA

*>>>>ACTUALIZACION DE ESTRUCTURAS
       SET CURSOR ON
       RESTSCREEN(0,0,24,79,cSavPan)

       SET EXACT      ON                    // Busqueda Exacta
       nActStrErr(lShared,nModCry,PathSis,fErrSys)
     *ÀActualizaci¢n de los Errores del Sistema

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActStrDat(lShared,nModCry,PathSis,fSimDat)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrEmp(lShared,nModCry,PathSis,FileEmp)
     *ÀActualizaci¢n del archivo de empresas

       nActStrAno(lShared,nModCry,cPatSis,fDatAno+cAnoUsr+ExtFile)
     *ÀActualizaci¢n de Configuraci¢n del A¤o.

       SET EXACT      OFF                   // Busqueda no exacta
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnArc := .F.
       IF !lUseDbf(.T.,PathSis+'\'+fSimDat,'DAT',NIL,lShared,nModCry)
	  CloseDbf('DAT',PathSis+'\'+fSimDat,nModCry)
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE DAT->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       lPrnArc := DAT->lPrnArcDat
       CloseDbf('DAT',PathSis+'\'+fSimDat,nModCry)
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:10 AM   ENE 16/2004 VIE

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
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

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
       CreaDbfDat(lShared,nModCry,PathSis,fSimDat)

       Termometro(100)
       CreaDbfEmp(lShared,nModCry,PathSis,FileEmp)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   ENE 16/2004 VIE

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
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cPatTem := ''                  // Path Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE  ESTRUCTURAS DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO LOS ARCHIVOS DEL SISTEMA")

       Termometro(10)
       CreaDatAno(lShared,nModCry,cPatSis,fDatAno+cAnoUsr+ExtFile)

       Termometro(100)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE  ESTRUCTURAS DEL SISTEMA

/*************************************************************************
* TITULO..: DEFINICION DE LOS MENUS DE LA APLICACION                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:20 AM   ENE 16/2004 VIE

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

	    AADD(aMenus,'1DATACREDITO')
	    AADD(aMenus,'2CONSOLIDAR')
	    AADD(aMenus,'3CONSULTAS')
	    AADD(aMenus,'4INFORMES')
	    AADD(aMenus,'5UTILIDADES')

	    AADD(aAyuda,'Permite Crear el Reporte a DataCredito')
	    AADD(aAyuda,'Permite Consolidar los Diferentes Reportes de cada Empresa')
	    AADD(aAyuda,'Consultas')
	    AADD(aAyuda,'Permite Imprimir los Informes del Sistema')
	    AADD(aAyuda,'Permite Ejecutar varias utilidades del sistema')

       CASE nNroOpc == 1

	    AADD(aMenus,'1<CREAR    >')
	    AADD(aMenus,'2<CONSULTAR>')
	    AADD(aMenus,'3<CONFIRMAR>')
	    AADD(aMenus,'4<AUDITORIA>')
	    AADD(aMenus,'5<RESTAURAR>')

	    aAyuda := {}
	    AADD(aAyuda,'Permite crear el archivo para reportar a DataCredito')
	    AADD(aAyuda,'Permite Consultar para verificar los registros a Reportar')
	    AADD(aAyuda,'Permite confirmar los registros a Reportar')
	    AADD(aAyuda,'Permite auditar los estados de Cuenta')
	    AADD(aAyuda,'Permite Restaurar las novedades del £ltimo reporte')

       CASE nNroOpc == 2

	    aMenus  := {"1<REPORTAR>"}

	    aAyuda := {'Crea el archivo consolidado para reportar a DataCr‚dito'}

       CASE nNroOpc == 3

	    AADD(aMenus,"1<SITUACION CLIENTE>")
	    AADD(aAyuda,'Consulta la situaci¢n actual de un Cliente')

       CASE nNroOpc == 4

	    AADD(aMenus,"1<CONTRATANTES>")

	    AADD(aAyuda,'Imprime los Contratantes')

       CASE nNroOpc == 5

	    AADD(aMenus,'1<USUARIOS      >')
	    AADD(aMenus,'2<CAMBIAR CLAVE >')
	    AADD(aMenus,'3<EJECUTAR      >')
	    AADD(aMenus,'4<MANTENIMIENTO >')
	    AADD(aMenus,'5<CONFIGURACION >')

	    AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
	    AADD(aAyuda,'Permite cambiar la clave.')
	    AADD(aAyuda,'Permite Ejecutar un programa Externo.')
	    AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
	    AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2004 VIE A
       Colombia, Bucaramanga        INICIO: 10:25 AM   ENE 16/2004 VIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubMenus(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		  cNomSec,cCodCol,nOpcion,nOpcPal,nFilPal,aColSup,;
		  cNomUsr,cDerech,cAnoUsr,nColAno,cPatSis,cSavPan,;
		  cMaeAlu,cMaeAct,cJorTxt,cVerSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa Principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cCodCol                              // C¢digo del Colegio
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
       cVerSis	                            // Versi¢n del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

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
	       cError('VERSION BETA:'+cVerSis,'NO REPORAR CON ESTA VERSION',;
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
		      Data_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt,cVerSis)
		     *Crear Reporte

		 CASE nNroOpc == 2
		      ManDbfRep(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Consulta de Reportados

		 CASE nNroOpc == 3
		      Data_103(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			       cJorTxt)
		     *Confirmaci¢n de las novedades

		 CASE nNroOpc == 4
		      Data_104(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Auditor¡a

		 CASE nNroOpc == 5
		      Data_105(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Restuar novedades

		 ENDCASE

	    CASE nOpcPal == 2

		 DO CASE
		 CASE nNroOpc == 1

		      MantenTxt(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt,cVerSis)
		     *Consulta de Reportados

		 ENDCASE

	    CASE nOpcPal == 3

		 DO CASE
		 CASE nNroOpc == 1
		      Data_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Situaci¢n del Cliente

		 ENDCASE

	    CASE nOpcPal == 4

		 DO CASE
		 CASE nNroOpc == 1
		      Data_401(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Informe de Contrantes

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
		      cOrden := SPACE(150)
		      @nFilInf+1,01 SAY 'ORDEN:' GET cOrden PICT '@S70'
		      READ
		      IF !SWPRUNCMD(cOrden,0,"","")
			 cError('DE EJECUCION')
		      ENDIF
		      cPausa()


		 CASE nNroOpc == 4
		      Data_504(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			       cJorTxt)
		     *Mantenimiento archivos del sistema

		 CASE nNroOpc == 5
		      Data_505(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			       cJorTxt)
		     *Configuraciones

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
		    PathClr,FileClr,PathSis,fSimDat)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path General del sistema
       fSimDat			      // Configuraci¢n del Sistema */
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
       IF !FILE(PathSis+'\'+fSimDat)
	  RecuDbfDat(lShared,nModCry,PathSis,fSimDat)
       ENDIF
       IF !FILE(PathClr+'\'+FileClr)
	  RecuDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrDat(lShared,nModCry,PathSis,fSimDat)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrClr(lShared,nModCry,PathClr,FileClr)
     *ÀActualizaci¢n de la Configuraci¢n del Colo
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysDat(lShared,nModCry)
       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR