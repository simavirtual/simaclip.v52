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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   SEP 04/2002 MIE

OBJETIVOS:

1- Define por defecto los parametros de la aplicaci¢n

1- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IniSistema(lShared,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n */
*>>>>PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nMemMin := 1000000             // Espacio M¡nimo en Disco Duro
       LOCAL nOpeFil := 12                  // M ximo de Archivos Abiertos
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
       SET FIXED       ON                   // Decimales del SET DECIMALS
*>>>>FIN SETS PARA LOS PROCESOS POR DEFECTO

*>>>>SETS PARA SALIDA POR DEFECTO
       SET WRAP       ON                    // Men£s circulares
       SET CONSOLE    ON                    // Activaci¢n de la pantalla
       SET DEVICE     TO SCREEN             // La Pantalla por defecto
       SET MESSAGE    TO 22 CENTER          // Fila para mensajes
       SET MARGIN     TO 0                  // N£mero del margen
       SET PRINTER TO SIMASOFT	            // Archivo salida impresora
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
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:35 AM   SEP 04/2002 MIE

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

FUNCTION RevisarDbf(lShared,nModCry,cAnoUsr,cPatSis,cSavPan)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cNomUsr                              // Nombre del usuario
       cAnoUsr			            // A¤o del usuario
       cPatSis                              // Path del sistema
       cSavPan                              // Salvar Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

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
       PathAct := DIRNAME()
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
	    !FILE(PathSis+'\'+fSimSof) .AND.;
	    !FILE(PathSis+'\'+FileClr) .AND.;
	    !FILE(PathSis+'\'+FilePrn) .AND.;
	    !FILE(PathSis+'\'+FileCiu) .AND.;
	    !FILE(PathSis+'\'+FileEmp) .AND.;
	    !FILE(PathSis+'\'+FileTip) .AND.;
	    !FILE(PathSis+'\'+FileSui) .AND.;
	    !FILE(PathSis+'\'+FileCmd) .AND.;
	    !FILE(PathSis+'\'+FileLic)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,nModCry)
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

	      IF !FILE(PathSis+'\'+fSimSof)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuSimSof(lShared,nModCry,PathSis,fSimSof)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileCiu)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCiu(lShared,nModCry,PathSis,FileCiu)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileEmp)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfEmp(lShared,nModCry,PathSis,FileEmp)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileTip)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfTip(lShared,nModCry,PathSis,FileTip)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileSui)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfSui(lShared,nModCry,PathSis,FileSui)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileCmd)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfCmd(lShared,nModCry,PathSis,FileCmd)
	      ENDIF

	      IF !FILE(PathSis+'\'+FileLic)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfLic(lShared,nModCry,PathSis,FileLic)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>ACTUALIZACION DE ESTRUCTURAS
       SET EXACT      ON                    // Busqueda Exacta
       nActStrErr(lShared,nModCry,PathSis,fErrSys)
      *Actualizaci¢n de los Errores del Sistema

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
      *Actualizaci¢n de Archivos de Impresora

       nActStrSof(lShared,nModCry,PathSis,fSimSof)
      *Actualizaci¢n de Configuraci¢n General

       nActStrCiu(lShared,nModCry,PathSis,FileCiu)
      *Actualizaci¢n de Ciudades

       nActStrEmp(lShared,nModCry,PathSis,FileEmp)
      *Actualizaci¢n de la Empresa

       nActStrTip(lShared,nModCry,PathSis,FileTip)
      *Actualizaci¢n de Tipos Empresas

       nActStrSui(lShared,nModCry,PathSis,FileSui)
      *Actualizaci¢n de la Suites

       nActStrCmd(lShared,nModCry,PathSis,FileCmd)
      *Actualizaci¢n de la Comunidades

       nActStrLic(lShared,nModCry,PathSis,FileLic)
      *Actualizaci¢n de las Licencias

       SET EXACT      OFF                   // Busqueda no exacta
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnArc := .F.
       IF !lUseDbf(.T.,PathSis+'\'+fSimSof,'SOF',NIL,lShared,nModCry)
	  CloseDbf('SOF',PathSis+'\'+fSimSof,nModCry)
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SOF->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       lPrnArc := SOF->lPrnArcSof
       CloseDbf('SOF',PathSis+'\'+fSimSof,nModCry)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF lPrnArc
	  SET PRINTER TO SIMASOFT              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO..: CREACION ARCHIVOS GENERALES DEL SISTEMA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 04/2002 MIE

OBJETIVOS:

1)- Crea todos los archivos generales del sistema

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
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
       CreaSimSof(lShared,nModCry,PathSis,fSimSof)

       Termometro(80)
       CreaDbfCiu(lShared,nModCry,PathSis,FileCiu)

       Termometro(90)
       CreaDbfEmp(lShared,nModCry,PathSis,FileEmp)

       Termometro(95)
       CreaDbfTip(lShared,nModCry,PathSis,FileTip)

       Termometro(97)
       CreaDbfSui(lShared,nModCry,PathSis,FileSui)

       Termometro(100)
       CreaDbfCmd(lShared,nModCry,PathSis,FileCmd)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO..: DEFINICION DE LOS MENUS DE LA APLICACION                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 04/2002 MIE

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

FUNCTION aMenuSoft(nNroOpc,cDerech,aAyudas)

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

*>>>>DECLARACION DE MENUS
       DO CASE
       CASE nNroOpc == 0

	    AADD(aMenus,'1EMPRESAS')
	    AADD(aMenus,'2SOFTWARE')
	    AADD(aMenus,'3PENDIENTE1')
	    AADD(aMenus,'4PENDIENTE2')
	    AADD(aMenus,'5PENDIENTE3')
	    AADD(aMenus,'6PENDIENTE4')
	    AADD(aMenus,'7UTILIDADES')

	    AADD(aAyuda,'Permite efectuar procesos sobre las Empresas')
	    AADD(aAyuda,'Permite efectuar procesos sobre el Software')
	    AADD(aAyuda,'Pendiente1')
	    AADD(aAyuda,'Pendiente2')
	    AADD(aAyuda,'Pendiente3')
	    AADD(aAyuda,'Pendiente4')
	    AADD(aAyuda,'Pendiente4')
	    AADD(aAyuda,'Permite Ejecutar varias utilidades del sistema')

       CASE nNroOpc == 1

	    AADD(aMenus,'1<EMPRESAS   >')
	    AADD(aMenus,'2<COMUNIDADES>')

	    AADD(aAyuda,'Permite Consultar las Empresas Actuales')
	    AADD(aAyuda,'Permite Consultar las Comunidades de Empresas')

       CASE nNroOpc == 2

	    AADD(aMenus,'1<SUITES   >')
	    AADD(aAyuda,'Permite Consultar las Suite de SoftWare')
	    AADD(aMenus,'2<LICENCIAS>')
	    AADD(aAyuda,'Permite Consultar las Licencias del SoftWare')

       CASE nNroOpc == 3

	    AADD(aMenus,'1<PENDIENTE2>')
	    AADD(aAyuda,'Pendiente2')

       CASE nNroOpc == 4

	    AADD(aMenus,'1<PENDIENTE3>')
	    AADD(aAyuda,'Pendiente3')

       CASE nNroOpc == 5

	    AADD(aMenus,'1<PENDIENTE4>')
	    AADD(aAyuda,'Pendiente4')

       CASE nNroOpc == 6

	    AADD(aMenus,'1<PENDIENTE6>')
	    AADD(aAyuda,'Pendiente6')

       CASE nNroOpc == 7

	    AADD(aMenus,'1<USUARIOS      >')
	    AADD(aMenus,'2<CAMBIAR CLAVE >')
	    AADD(aMenus,'3<REINDEXAR     >')
	    AADD(aMenus,'4<INTEGRIDAD    >')
	    AADD(aMenus,'5<RESPALDO      >')
	    AADD(aMenus,'6<ACTUALIZAR    >')
	    AADD(aMenus,'7<MANTENIMIENTO >')
	    AADD(aMenus,'8<CONFIGURACION >')
	    AADD(aMenus,'9<VARIOS        >')

	    AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
	    AADD(aAyuda,'Permite cambiar la clave.')
	    AADD(aAyuda,'Reindexa los archivos del Sistema.')
	    AADD(aAyuda,'Elimina los registros marcados como borrados.')
	    AADD(aAyuda,'Copia los archivos principales del sistema en Disco Duro.')
	    AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
	    AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
	    AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
	    AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')

       ENDCASE
*>>>>FIN DECLARACION DE MENUS

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:05 PM   SEP 04/2002 MIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenusSoft(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,nOpcion,nOpcPal,nFilPal,aColSup,;
		   cNomUsr,cDerech,cAnoUsr,nColAno,cPatSis,;
		   cSavPan)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       nFilPal                              // Fila Inferior Men£ principal
       aColSup                              // Columnas para los sub_men£s
       cEmpPal                              // Nombre de la Empresa Principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cDerech                              // Derechos en el sistema
       cAnoUsr				    // A¤o del Sistema
       nColAno                              // Columna A¤o del sistema
       cPatSis                              // Path del sistema
       cSavPan                              // Salvar Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

       LOCAL lSiMenu := .T.                 //.T.Opci¢n principal con SubMen£
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opci¢n
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL cOrden  := ''                  // Orden de Ejecuci¢n

       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£
       LOCAL nFilInf := 0                   // Fila Inferior del Sub_men£
       LOCAL nColInf := 0                   // Columna Inferior del Sub_men£
       LOCAL       i := 0                   // Contador

       LOCAL Getlist                        // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESARROLLO DEL PRIMER NIVEL
       DO WHILE .T.

**********SELECCION DE LOS SUBMENUS
	    CloseAll()
	    lSiMenu := .T.
	    aDeMenu := aMenuSoft(nOpcPal,;
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
	    nColInf := aColSup[nOpcion]
	    DO CASE
	    CASE nOpcPal == 1

		 DO CASE
		 CASE nNroOpc == 1
		      MantenEmp(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
				cAnoUsr,cPatSis)
		     *Mantenimientos de Empresas

		 CASE nNroOpc == 2
		      MantenCmd(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
				cAnoUsr,cPatSis)
		     *Mantenimientos de Comunidades

		 ENDCASE

	    CASE nOpcPal == 2

		 DO CASE
		 CASE nNroOpc == 1
		      MantenSui(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
				cAnoUsr,cPatSis)
		     *Mantenimientos de Suites

		 CASE nNroOpc == 2
		      MantenLic(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
				cAnoUsr,cPatSis)
		     *Mantenimientos de Licencias

		 ENDCASE

	    CASE nOpcPal == 3

		 DO CASE
		 CASE nNroOpc == 1
		 ENDCASE

	    CASE nOpcPal == 4

		 DO CASE
		 CASE nNroOpc == 1
		 CASE nNroOpc == 2
		 ENDCASE

	    CASE nOpcPal == 5

		 DO CASE
		 CASE nNroOpc == 1
		 CASE nNroOpc == 2
		 ENDCASE

	    CASE nOpcPal == 6
		 DO CASE
		 CASE nNroOpc == 1
		 CASE nNroOpc == 2
		 ENDCASE


	    CASE nOpcPal == 7
		 DO CASE
		 CASE nNroOpc == 1
		      MantenUsr(lShared,PathSis,FileAaa,{|nOpcion,aAyudas|;
				aMenuSoft(nOpcion,'1111111111',aAyudas)},;
				cNomSis,.F.)
		     *Mantemiento de usuarios

		 CASE nNroOpc == 2
		      CamPasWor(lShared,nFilInf+1,aColSup[nOpcion],;
				PathSis,FileAaa,cNomUsr)
		     *Cambiar el PassWord del usuario

		 CASE nNroOpc == 7
		      Soft_707(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
			       cAnoUsr,cPatSis)
		     *Mantenimientos

		 CASE nNroOpc == 8
		      Soft_708(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
			       cAnoUsr,cPatSis)
		     *Configuraci¢n

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   SEP 04/2002 MIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
		    PathClr,FileClr,PathSis,fSimSof)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       PathClr                              // Path del Archivo del Color
       FileClr                              // Archivo del Color
       PathSis                              // Path General del sistema
       fSimSof			            // Configuraci¢n del Sistema */
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
       PathAct := DIRNAME()
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
       IF !FILE(PathSis+'\'+fSimSof)
	  RecuSimSof(lShared,nModCry,PathSis,fSimSof)
       ENDIF
       IF !FILE(PathClr+'\'+FileClr)
	  RecuDbfClr(lShared,nModCry,PathClr,FileClr)
       ENDIF
       nActStrSof(lShared,nModCry,PathSis,fSimSof)
     *ÀActualizaci¢n de Configuraci¢n General

       nActStrClr(lShared,nModCry,PathClr,FileClr)
     *ÀActualizaci¢n de la Configuraci¢n del Colo
*>>>>FIN VALIDACION DE LA ESTRUCTURA DEL ARCHIVO DEL COLOR

*>>>>LECTURA DE LA CONFIGURACION DEL COLOR
       xClrSys := xClrSysSof(lShared,nModCry)
       RETURN xClrSys
*>>>>FIN LECTURA DE LA CONFIGURACION DEL COLOR

/*************************************************************************
* TITULO ..: LOGO PARA EL FONDO DEL SISTEMA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 06:15 PM   SEP 04/2002 MIE

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LogoSys(cNomSis,cNomEmp)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList := {}                  // Variable del sistema

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cClrFnd := ''                  // Color del Fondo
       LOCAL cGetsSi := ''                  // Color del Get Selecionados
       LOCAL cMarGen := ''                  // Marco General en Color
       LOCAL cGetsNo := ''                  // Color del Get No Seleccionados
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[1],'')),;
	       @cClrFnd,@cGetsSi,@cGetsNo,@cMarGen)
       cSetColor(cClrFnd+','+cGetsSi+','+cMarGen+',,'+cGetsNo)
*>>>>FIN ANALISIS DEL COLOR

*>>>>DISE¥O DEL FONDO
       CLEAR
       @ 00,00,24,80 BOX CHR(176)+CHR(176)+CHR(176)+CHR(176)+CHR(176)+;
			 CHR(176)+CHR(176)+CHR(176)+CHR(176)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
       RETURN NIL
*>>>>FIN DISE¥O DEL FONDO