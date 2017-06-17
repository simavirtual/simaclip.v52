/*BIBLIOTECAS DE FUNCIONES DE USO GENERAL 1994

REQUERIMIENTOS

- Compilar: clipper FuncsUsr /w/m

OBJETIVOS

- Son independientes de cualquier programa

FUNCIONES


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA DE USUARIOS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/94 LUN A
						       OCT 03/94 LUN
OBJETIVOS:

1)- Crea la estructura del archivo de usuarios

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfAaa(lShared,PathUsr,FileUsr,fNtxUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       PathUsr                              // Path de archivo
       FileUsr				    // Nombre del Archivo
       fNtxUsr				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfUsr := {{"A","Character",140,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathUsr) == 0
	    DBCREATE(FileUsr,aDbfUsr,"DBFNTX")

       CASE DIRCHANGE(PathUsr) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathUsr)

       CASE DIRCHANGE(PathUsr) == -5
	    cError('NO TIENE DERECHOS EN: '+PathUsr)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUsr+'\'+FileUsr,'AAA',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONTROL DE LA APLICACION')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF AAA->(lRegLock(lShared,.T.))
	  REPL AAA->A WITH STUFF(AAA->A,121,10,CRYPT('SUPER     ',"IVANAN"))
	  REPL AAA->A WITH STUFF(AAA->A,1,10  ,CRYPT('VISOR     ',"IVANAN"))
	  REPL AAA->A WITH STUFF(AAA->A,11,110,CRYPT(REPL('1',110),"IVANAN"))
	  cMsgTxt := CRYPT(STR(CHECKSUM(SUBS(AAA->A,1,130)),10),"IVANAN")
	  REPL AAA->A WITH STUFF(AAA->A,131,10,cMsgTxt)
	  AAA->(DBCOMMIT())
       ELSE
	  cError('NO SE CREA SUPERVISOR DE LA APLICACION')
       ENDIF
       IF lShared
	  AAA->(DBUNLOCK())
       ENDIF
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZACION DEL NOMBRE DEL USUARIO            *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 03/94 LUN A
						       OCT 03/94 LUN

1- Valida si existe el nombre del usuario en el archivo de usuarios

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Debe estar en uso el archivo de usuarios

4- Retorna .T. si ya existe el nombre del usuario

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocNomUsr(lShared,cAaaaaa,lMensaj,lValida)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAaaaaa			            // @Nombre del Usuario
       lMensaj                              // .T. Mostrar mensaje de error
       lValida                              // .T. Validar Cambios */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. = Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT AAA
       GO TOP
       LOCATE FOR SUBS(AAA->A,121,10) == cAaaaaa
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('NOMBRE INVALIDO')
	     cAaaaaa := SPACE(10)
	  ENDIF
	  lExiste := .F.
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>BLOQUEO DEL REGISTRO
       lShared := IF(lShared == NIL,.T.,lShared)
       IF lExiste .AND. lShared
	  AAA->(lRegLock(lShared,.F.))
       ENDIF
*>>>>FIN BLOQUEO DEL REGISTRO

*>>>>VALIDACION DE CAMBIOS EXTERNOS
       lValida := IF(lValida == NIL,.T.,lValida)
       IF lValida .AND. lExiste
	  IF CHECKSUM(SUBS(AAA->A,1,130)) <> VAL(CRYPT(SUBS(AAA->A,131,10),"IVANAN"))
	     cError("DA¥OS EN LA SEGURIDAD DEL USUARIO")
	     lExiste := .F.
	  ENDIF
       ENDIF
       RETURN lExiste
*>>>>FIN VALIDACION DE CAMBIOS EXTERNOS

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL NOMBRE DEL USUARIO		 *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 07/94 SAB A
						       OCT 08/94 DOM
1- Debe estar en uso el archivo de usuarios

2- Realiza la validaci¢n del nombre del usuario

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValNomUsr(lShared,cNomUsr,lMensaj,lValida)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr				    // Nombre del usuario
       lMensaj                              // .T. Mostrar mensaje
       lValida                              // .T. Validar Cambios */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       lValida := IF(lValida == NIL,.T.,lValida)
       IF cNomUsr # SPACE(10)
	  IF lLocNomUsr(lShared,CRYPT(cNomUsr,"IVANAN"),;
			lMensaj,lShared,lValida)
	     cError('YA EXISTE ESTE USUARIO')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO


/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL NOMBRE DEL USUARIO                 *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 08/94 SAB A
						       OCT 09/94 DOM

1- Crea el archivo de usuarios de acuerdo a la clave de creaci¢n de
   usuarios.

2- Abre el archivo de Usuarios

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Permite leer el nombre del usuario junto con su clave

5- Cierra el archivo de usuarios una vez leidos sus derechos

6- Retorna los derechos del usuario

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cUsuario(lShared,PathUsr,FileUsr,cNomUsr,cPasSis,lHayFec)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       PathUsr                              // Path del archivo
       FileUsr                              // Archivo de usuarios
       cNomUsr                              // @Nombre del Usuario
       cPasSis                              // PassWord del sistema
       lHayFec                              // .T. Verificar fecha y Hora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL cDerech := ''                  // Derechos del Usuario
       LOCAL cPasWor := ''                  // PassWord creacion de Usuarios
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lMensaj := .F.                 // No visualizar mensaje
       LOCAL lPasWor := .F.                 // .T. Validar PassWord
       LOCAL PathAct := ''                  // Path Actual

       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL       i := 1                   // Contador
       LOCAL dFecSys := CTOD("00/00/00")    // Fecha del sistema
       LOCAL cHorSys := SPACE(08)           // Hora del sistema
       LOCAL lleeFec := .F.                 // Leer la Fecha y Hora

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION O CREACION DEL DIRECTORIO FIJO
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (PathUsr) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (PathUsr) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathUsr)
	    QUIT

       CASE DIRCHANGE(PathUsr) == -3
	    DIRMAKE(PathUsr)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DE DIRECTORIO FIJO

*>>>>CREACION DE LA ESTRUCTURA DE USUARIOS
       IF !FILE(PathUsr+'\'+FileUsr)

**********VALIDACION DEL PASSWORD
	    IF ALLTRIM(cPasSis) == 'ERROR'
	       cError('REVISE EL PATH')
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DEL PASSWORD

**********LECTURA DEL PASSWORD
	    SET COLOR TO W/N,N/N
	    cSavLin := SAVESCREEN(22,0,22,79)
	    cPasWor := SPACE(10)
	    @ 22,28 SAY 'CLAVE DE CONTROL: ' GET cPasWor PICT '@X'
	    READ
	    SetClrTo()
**********FIN LECTURA DEL PASSWORD

**********CREACION DE LA ESTRUCTURA
	    IF ALLTRIM(cPasWor) == cPasSis
	       CreaDbfAaa(lShared,PathUsr,FileUsr)
	    ELSE
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
	    RESTSCREEN(22,0,22,79,cSavLin)
**********FIN CREACION DE LA ESTRUCTURA

       ENDIF
*>>>>FIN CREACION DE LA ESTRUCTURA DE USUARIOS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUsr+'\'+FileUsr,'AAA',NIL,lShared)
	  cError("ABRIENDO EL ARCHIVO DE CONTROL")
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA SEGURIDAD DEL SISTEMA
       GO TOP
       DO WHILE .NOT. EOF()
	  IF CHECKSUM(SUBS(AAA->A,1,130)) <> VAL(CRYPT(SUBS(AAA->A,131,10),"IVANAN"))
	     cError("DA¥OS EN LA SEGURIDAD DEL SISTEMA")
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
	  SKIP
       ENDDO
       GO TOP
*>>>>FIN VALIDACION DE LA SEGURIDAD DEL SISTEMA

*>>>>INICIALIZACION DE LAS COORDENAS
       lHayFec := IF(lHayFec == NIL,.F.,lHayFec)
       nFilSup := IF(lHayFec,08,10)
       nColSup := 30
       nFilInf := 15
       nColInf := 52
*>>>>FIN INICIALIZACION DE LAS COORDENAS

*>>>>LECTURA DEL USUARIO
       SET COLOR TO I
       DISPBOX(nFilSup,nColSup,nFilInf,nColInf,"ÉÍ»º¼ÍÈº")
       SetClrTo()

       cNomUsr := SPACE(10)
       @ nFilSup+2,nColSup+2 SAY 'USUARIO:' GET cNomUsr
       READ
*>>>>FIN LECTURA DEL USUARIO

*>>>>VALIDACION DEL USUARIO
       IF cNomUsr <> SPACE(10)
	  lPasWor := .F.
	  cNomUsr := CRYPT(cNomUsr,"IVANAN")
	 *Encripta el nombre
	  IF lSekNomUsr(lShared,cNomUsr,lMensaj)
	     lPasWor := .T.
	     cNomUsr := CRYPT(cNomUsr,"IVANAN")
	    *Desencripta el nombre
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL USUARIO

*>>>>LECTURA DE LA CLAVE DE ACCESO Y ASIGNACION DE DERECHOS
       cDerech := NIL
       IF cNomUsr <> SPACE(10)
	  IF lLeePasWor(nFilSup+3,nColSup+4,lPasWor)
	     cDerech := CRYPT(SUBS(AAA->A,11,110),"IVANAN")
	  ENDIF
       ENDIF
       CLOSE AAA
*>>>>FIN LECTURA DE LA CLAVE DE ACCESO Y ASIGNACION DE DERECHOS

*>>>>VERIFICACION DE LA FECHA Y HORA
       lLeeFec := .F.
       DO WHILE lHayFec

**********LECTURA Y GRABACION DE LA FECHA Y HORA
	    IF lLeeFec

*--------------LECTURA DE LA FECHA Y HORA
		 dFecSys := DATE()
		 @ nFilSup+4,nColSup+2 SAY "HOY ES :" GET dFecSys PICT "@D";
					   VALID dFecSys <> CTOD('00/00/00')
		 cHorSys := TIME()
		 @ nFilSup+5,nColSup+2 SAY "SON LAS:";
				       GET cHorSys PICT "99:99:99" ;
				       VALID TIMEVALID(ALLTRIM(cHorSys))
		 READ
		 lHayFec := .F.
*--------------FIN LECTURA DE LA FECHA Y HORA

*--------------GRABACION DE LA FECHA Y HORA
		 IF ISAT()
		    SETDATE(dFecSys,.T.)
		    SETTIME(cHorSys,.T.)
		 ELSE
		    SETDATE(dFecSys)
		    SETTIME(cHorSys)
		 ENDIF
*--------------FIN GRABACION DE LA FECHA Y HORA

	    ENDIF
**********FIN LECTURA Y GRABACION DE LA FECHA Y HORA

**********VISUALIZACION DE LA FECHA Y HORA
	    @ nFilSup+4,nColSup+2 SAY "HOY ES :"
	    @ nFilSup+5,nColSup+2 SAY "SON LAS:"

	    @ nFilSup+4,nColSup+11 SAY cFecha(DATE())
	    SHOWTIME(nFilSup+5,nColSup+11,.F.,,.T.,.T.)
**********FIN VISUALIZACION DE LA FECHA Y HORA

**********LECTURA DE LA FECHA Y HORA
	    IF lHayFec .AND.;
	       lPregunta('DESEA CAMBIAR LA FECHA Y HORA DEL SISTEMA? No Si')
	       lLeeFec := .T.
	       SHOWTIME(24,69,.F.,,.T.,.T.)
	       LOOP
	    ELSE
	       SHOWTIME(24,69,.F.,,.T.,.T.)
	       EXIT
	    ENDIF
**********FIN LECTURA DE LA FECHA Y HORA

       ENDDO
       RETURN cDerech
*>>>>FIN VERIFICACION DE LA FECHA Y HORA


/*************************************************************************
* TITULO DE LA FUNCION..: ASIGNACION DE DERECHOS AL USUARIO              *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 08/94 SAB A
						       OCT 09/94 DOM

1- Debe estar en Uso el archivo de Usuarios

2- Permite asignar y grabar los derechos al men£ principal del usuario

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AsigDerech(lShared,bCodBlo,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       bCodBlo			            // Code Block funcion de Menus
       cNomSis                              // Nombre del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPa1 := ''                  // Salvar Pantalla
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cMsgTxt := ''                  // Texto Variable

       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL nFilSup := 0                   // Fila Superior del men£
       LOCAL aColSup := {}                  // Columnas para los Submen£s
       LOCAL       i := 0                   // Contador
       LOCAL cDerech := ''                  // Derechos del Usuario

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       cSavPa1 := SAVESCREEN(0,0,24,79)
       CLEAR
       @ 00,00,24,80 BOX CHR(177)+CHR(177)+CHR(177)+CHR(177)+CHR(177)+;
			 CHR(177)+CHR(177)+CHR(177)+CHR(177)
       LineaEstado('DERECHOS PARA EL USUARIO: '+;
		   CRYPT(SUBS(AAA->A,121,10),"IVANAN"),cNomSis)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nNroOpc := 1
       cDerech := CRYPT(SUBS(AAA->A,11,110),"IVANAN")
       DO WHILE nNroOpc # 0

**********SELEECION DEL MENU PRINCIPAL
	    aDeMenu := EVAL(bCodBlo,0,@aAyuda)
	     aMenus := {}
	    FOR i:= 1 TO LEN(aDeMenu)
		AADD(aMenus,i)
		aMenus[i] := SUBS(aDeMenu[i],2,LEN(aDeMenu[i]))
	    NEXT
	    nFilSup := 00
	    aColSup := aColOpc(aMenus)
	   *Calcula de las columnas
**********FIN SELEECION DEL MENU PRINCIPAL

**********IMPRESION DE LOS DERECHOS DEL USUARIO
	    FOR i := 1 TO LEN(aMenus)
		IF SUBS(cDerech,100+i,1) == '1'
		   @ nFilSup+3,aColSup[i] SAY 'Si'
		ELSE
		   @ nFilSup+3,aColSup[i] SAY 'No'
		ENDIF
	    NEXT
**********FIN IMPRESION DE LOS DERECHOS DEL USUARIO

**********EJECUCION DEL MENU PRINCIPAL
	    nNroOpc := nMenu(aMenus,aAyuda,nFilSup,aColSup,;
			     'ASIGNACION DE DERECHOS',NIL,nNroOpc,.F.)
	    cSavPan := SAVESCREEN(0,0,24,79)
**********FIN EJECUCION DEL MENU PRINCIPAL

**********ANALISIS PARA LA TERMINACION DEL PROGRAMA
	    IF nNroOpc = 0
	       CLEAR
	       EXIT
	    ENDIF
**********FIN ANALISIS PARA LA TERMINACION DEL PROGRAMA

**********ASIGNACION DE LOS DERECHOS PRINCIPALES
	    IF SUBS(cDerech,100+nNroOpc,1) == '0'
	       cDerech := STUFF(cDerech,100+nNroOpc,1,'1')
	    ELSE
	       cDerech := STUFF(cDerech,100+nNroOpc,1,'0')
	    ENDIF
**********FIN ASIGNACION DE LOS DERECHOS PRINCIPALES

**********IMPRESION DEL DERECHO ACTUAL
	    IF SUBS(cDerech,100+nNroOpc,1) == '1'
	       @ nFilSup+2,aColSup[nNroOpc] SAY 'Si'
	    ELSE
	       @ nFilSup+2,aColSup[nNroOpc] SAY 'No'
	    ENDIF
**********FIN IMPRESION DEL DERECHO ACTUAL

**********ASIGNANCION DE LOS SUBDERECHOS
	    IF SUBS(cDerech,100+nNroOpc,1) == '1'
	       SubDerechos(nNroOpc,nFilSup+2,aColSup,bCodBlo,@cDerech,cSavPan)
	    ENDIF
**********FIN ASIGNANCION DE LOS SUBDERECHOS

       ENDDO
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA

*>>>>INCRIPTACION DE LOS DERECHOS
       IF AAA->(lRegLock(lShared,.F.))
	  REPL AAA->A WITH STUFF(AAA->A,11,110,CRYPT(cDerech,"IVANAN"))
	  cMsgTxt := CRYPT(STR(CHECKSUM(SUBS(AAA->A,1,130)),10),"IVANAN")
	  REPL AAA->A WITH STUFF(AAA->A,131,10,cMsgTxt)
	  AAA->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABAN LOS DERECHOS')
       ENDIF
       IF lShared
	  AAA->(DBUNLOCK())
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPa1)
       RETURN NIL
*>>>>FIN INCRIPTACION DE LOS DERECHOS


/*************************************************************************
* TITULO DE LA FUNCION..: ASIGNACION DE SUBDERECHOS AL USUARIOS          *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 08/94 SAB A
						       OCT 09/94 DOM
1- Debe estar en Uso el archivo de Usuarios

2- Deben estar decencriptados los derechos

3- Permite asignar y grabar los derechos a los SubMenus

4- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubDerechos(nOpcPal,nFilPal,aColSup,bCodBlo,cDerech,cSavPan)

*>>>>PARAMETROS DE LA FUNCION
/*     nOpcPal                              // Opci¢n del men£ principal
       nFilPal                              // Fila Inferior men£ principal
       aColSup                              // Columnas para los sub_men£s
       bCodBlo			            // Code Block. Funcion con Menus
       cDerech                              // @Derechos del Usuario
       cSavPan 	                            // Salvar Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiMenu := .T.                 // .T. Existe Sub_men£
       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£

       LOCAL lFlecha := .F.                 // Uso de las flechas en menu
       LOCAL aMenus  := {}                  // Vector de declarcion del men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL nNroOpc := 1                   // N£mero de opci¢n del sub_men£
       LOCAL       i := 0                   // Contador

       LOCAL Getlist                        // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESARROLLO DEL PRIMER NIVEL
       DO WHILE .T.

**********DECLARACION DE LOS MENUS DEL PRIMER NIVEL
	    lSiMenu := .T.
	    aMenus  :=   EVAL(bCodBlo,nOpcPal,@aAyuda)
**********FIN DECLARACION DE LOS MENUS DEL PRIMER NIVEL

**********ANALISIS DEL LIMITE DE LA COLUMNA
	    IF lSiMenu

	       ASCAN(aMenus, {|str| nLenOpc := MAX(nLenOpc,LEN(str))})
	      *Longitud mayor de las opciones

	       IF aColSup[nOpcPal]+ nLenOpc + 2 > 78
		  aColSup[nOpcPal] := 78-nLenOpc-1
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL LIMITE DE LA COLUMNA

**********IMPRESION DE LOS DERECHOS DEL USUARIO
	    FOR i := 1 TO LEN(aMenus)
		IF SUBS(cDerech,(nOpcPal*10-10)+i,1) == '1'
		   @ nFilPal+i+1,aColSup[nOpcPal]-1 SAY 'S'
		ELSE
		   @ nFilPal+i+1,aColSup[nOpcPal]-1 SAY 'N'
		ENDIF
	    NEXT
**********FIN IMPRESION DE LOS DERECHOS DEL USUARIO

**********EJECUCION DE LOS SUBMENUS
	    IF lSiMenu

	       nFilSup := nFilPal+1
	       nColSup := aColSup[nOpcPal]
	       nNroOpc := nMenu(aMenus,aAyuda,;
				nFilSup,nColSup,NIL,NIL,nNroOpc,lFlecha)
	       STORE .T. TO lSiMenu

	    ENDIF

	    IF nNroOpc == 0
	       RESTSCREEN(0,0,24,79,cSavPan)
	       EXIT
	    ENDIF
**********FIN EJECUCION DE LOS SUBMENUS

**********ASIGNACION DE LOS SUBDERECHOS
	    IF SUBS(cDerech,(nOpcPal*10-10)+nNroOpc,1) == '0'
	       cDerech := STUFF(cDerech,(nOpcPal*10-10)+nNroOpc,1,'1')
	    ELSE
	       cDerech := STUFF(cDerech,(nOpcPal*10-10)+nNroOpc,1,'0')
	    ENDIF
**********FIN ASIGNACION DE LOS SUBDERECHOS

       ENDDO
       RETURN NIL
*>>>>FIN DESARROLLO DEL PRIMER NIVEL


/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE USUARIOS         *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 08/94 SAB A
						       OCT 08/94 SAB
1- Permite el mantenimiento del archivo Usuarios

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenUsr(lShared,PathUsr,FileUsr,bCodBlo,cNomSis,lVerPas)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       FileUsr                              // Archivo de Usuarios
       bCodBlo			            // Code Block. Funcion con Menus
       cNomSis                              // Nombre del Sistema
       lVerPas                              // .T. Visualizar el PassWard */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL oBrwUsr := NIL		    // Objeto Browse de Usuarios
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !FILE(PathUsr+'/'+FileUsr)
	  cError("CONTACTE AL PERSONAL QUE LE DA SERVICIO AL PROGRAMA",;
		 "ERROR GRAVE EN EL SISTEMA")
	  RETURN NIL
       ENDIF
       DBUSEAREA(.T.,NIL,PathUsr+'\'+FileUsr,"AAA",lShared,.F.)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       IF AAA->(RECCOUNT()) = 0
	  cError('NO EXISTEN USUARIOS')
       ENDIF

       SELECT AAA
       oBrwUsr := oDefBrwUsr(lShared,03,00,22,79,bCodBlo,cNomSis,lVerPas)
       SETKEY(K_F5,{||AsigDerech(lShared,bCodBlo,cNomSis)})
       SETKEY(K_F9,{||CamUsrName(lShared,10,10)})

       AAA->(CtrlBrw(lShared,oBrwUsr))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE USUARIOS       *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 08/94 SAB A
						       OCT 08/94 SAB
1- Define el objeto Browse del archivo Usuarios

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwUsr(lShared,nFilSup,nColSup,nFilInf,nColInf,;
		    bCodBlo,cNomSis,lVerPas)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       bCodBlo			            // Code Block. Funcion con Menus
       cNomSis                              // Nombre del Sistema
       lVerPas                              // .T. Visualizar el PassWard */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwUsr := NIL                 // Browse de Tarifas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwUsr := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwUsr:ColSep    := '³'
       oBrwUsr:HeadSep   := 'Ä'
       oBrwUsr:Cargo     := {'<<USUARIOS DEL SISTEMA>>',;
			    '<INS>Incluir <F5>Derechos  <DEL>Borrar  '+;
			    '<ESC>Abandonar',;
			    {||IncluirUsr(lShared,bCodBlo,cNomSis)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT AAA
       oColumn	     := TBCOLUMNNEW('NOMBRE',;
				   {||CRYPT(SUBS(AAA->A,121,10),"IVANAN")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwUsr:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       lVerPas := IF(lVerPas == NIL,.T.,lVerPas)
       IF lVerPas
	  oColumn := TBCOLUMNNEW('CLAVE',;
				 {||CRYPT(SUBS(AAA->A,1,10),"IVANAN")})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrwUsr:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       RETURN oBrwUsr
*>>>>FIN DEFINICION DEL OBJETO BROWSE


/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO O USUARIO             *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 08/94 SAB A
						       OCT 08/94 SAB
1- Permite incluir un registro o usuario al archivo de Usuarios

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirUsr(lShared,bCodBlo,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       bCodBlo			            // Code Block. Funcion con Menus
       cNomSis                              // Nombre del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // Grabar el registro
       LOCAL cMsgTxt := ''                  // Variable de texto

       LOCAL cNombre := ''                  // Nombre del Usuario
       LOCAL cPasWor := ''                  // Clave del Usuario
       LOCAL lMensaj := .F.                 // No Mostrar Mensaje
       LOCAL lValida := .F.                 // No validar cambios
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE EL NOMBRE DEL USUARIO',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cNombre := SPACE(10)
	       cPasWor := SPACE(10)
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'NOMBRE DEL USUARIO:';
			GET cNombre PICT '@A!';
			VALID !lValNomUsr(lShared,cNombre,lMensaj,lValida)
	    @ nNroFil+1,nNroCol SAY 'CLAVE PARA USUARIO:';
				GET cPasWor PICT '@A!'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE cNombre == SPACE(10) .OR. cPasWor == SPACE(10)

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE GRABA EL REGISTRO')

	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT AAA
       IF lGrabar
	  IF AAA->(lRegLock(lShared,.T.))
	     REPL AAA->A WITH STUFF(AAA->A,121,10,CRYPT(cNombre,"IVANAN"))
	     REPL AAA->A WITH STUFF(AAA->A,1,10  ,CRYPT(cPasWor,"IVANAN"))
	     REPL AAA->A WITH STUFF(AAA->A,11,110,CRYPT(REPL('0',110),"IVANAN"))
	     cMsgTxt := CRYPT(STR(CHECKSUM(SUBS(AAA->A,1,130)),10),"IVANAN")
	     REPL AAA->A WITH STUFF(AAA->A,131,10,cMsgTxt)
	     AAA->(DBCOMMIT())
	  ENDIF
	  cError('A CONTINUACION ASIGNE LOS DERECHOS PARA '+;
		 ALLTRIM(CRYPT(SUBS(AAA->A,121,10),"IVANAN")))
	  AsigDerech(lShared,bCodBlo,cNomSis)
	  IF lShared
	     AAA->(DBUNLOCK())
	  ENDIF
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE LA CLAVE DEL USUARIO                *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: NOV 05/94 SAB A
						       NOV 05/94 SAB
1- Permite leer la clave del usuario y verificarla

2- Debe estar en uso el archivo de usuarios en el registro coreccto

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeePasWor(nNroFil,nNroCol,lValida)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       lValida                              // Validar la Clave */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cPasWor := ''                  // Clave del usuario
       LOCAL       i := 0                   // Contador
       LOCAL lPasWor := .T.                 // Clave Correcta

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA CLAVE DE ACCESO
       SET COLOR TO W/N,N/N

       DO WHILE i < 3
	  cPasWor := SPACE(10)
	  @ nNroFil,nNroCol SAY 'CLAVE:' GET cPasWor PICT "@X" ;
					 VALID cPasWor # SPACE(10)
	  READ

	  lValida := IF(lValida == NIL,.T.,lValida)
	  lPasWor := .F.

	  IF lValida
	     IF CRYPT(cPasWor,"IVANAN") == SUBS(AAA->A,1,10)
		lPasWor := .T.
		EXIT
	     ENDIF
	  ENDIF
	  i++
       ENDDO
       SET COLOR TO W/N,N/W
       SetClrTo()
       RETURN lPasWor
*>>>>FIN LECTURA DE LA CLAVE

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIO DE LA CLAVE DEL USUARIO                 *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: NOV 05/94 SAB A
						       NOV 05/94 SAB
1- Permite Cambiar la clave del usuario y verificarla

2- Debe estar en uso el archivo de usuarios en el registro coreccto

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CamPasWor(lShared,nNroFil,nNroCol,PathUsr,FileUsr,cNomUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       PathUsr                              // Path del Usuario
       FileUsr                              // Archivo de usuarios
       cNomUsr                              // Nombre del usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cPasNew := ''                  // Clave Nueva
       LOCAL cPasOky := ''                  // Clave Nueva confirmada
       LOCAL cMsgTxt := ''                  // Texto variable

       LOCAL GetList := {}                  // Variable del sistema
*>>>>DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !FILE(PathUsr+'\'+FileUsr)
	  cError("CONTACTE AL PERSONAL QUE LE DA SERVICIO AL PROGRAMA",;
		 "ERROR GRAVE EN EL SISTEMA")
	  RETURN NIL
       ENDIF
       DBUSEAREA(.T.,NIL,PathUsr+'\'+FileUsr,"AAA",lShared,.F.)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DEL USUARIO
       cNomUsr := CRYPT(cNomUsr,"IVANAN")
      *Encripta el nombre

       IF !lLocNomUsr(lShared,cNomUsr)
	  cError("EL USUARIO "+CRYPT(cNomUsr,"IVANAN")+;
		 "NO SE PUDO LOCALIZAR")
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL USUARIO

*>>>>LECTURA DE LA CLAVE ANTIGUA
       IF !lLeePasWor(nNroFil,nNroCol)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LA CLAVE

*>>>>LECTURA DE LA NUEVA CLAVE
       SET COLOR TO W/N,N/N,N
       cPasNew := SPACE(10)
       @ nNroFil,nNroCol SAY 'NUEVA CLAVE:' GET cPasNew PICT "@X" ;
			      VALID cPasNew # SPACE(10)
       READ
*>>>>LECTURA DE LA NUEVA CLAVE

*>>>>CONFIRMACION DE LA NUEVA CLAVE
       cPasOky :=  SPACE(10)
       @ nNroFil+1,nNroCol SAY 'CONFIRMELA :' GET cPasOky PICT "@X";
				VALID cPasOky # SPACE(10)
       READ
*>>>>FIN CONFIRMACION DE LA NUEVA CLAVE

*>>>>GRABACION DE LA CLAVE
       IF cPasNew == cPasOky
	  IF AAA->(lRegLock(lShared,.F.))
	     REPL AAA->A WITH STUFF(AAA->A,1,10  ,CRYPT(cPasNew,"IVANAN"))
	     cMsgTxt := CRYPT(STR(CHECKSUM(SUBS(AAA->A,1,130)),10),"IVANAN")
	     REPL AAA->A WITH STUFF(AAA->A,131,10,cMsgTxt)
	     AAA->(DBCOMMIT())
	     cError('LA CLAVE FUE CAMBIADA')
	  ELSE
	     cError('La clave NO fue cambiada')
	  ENDIF
	  IF lShared
	     AAA->(DBUNLOCK())
	  ENDIF
       ELSE
	   cError('La clave NO fue cambiada')
       ENDIF
       SET COLOR TO W/N,N/W,N
       RETURN NIL
*>>>>FIN GRABACION DE LA CLAVE

/*************************************************************************
* TITULO..: CAMBIO DEL NOMBRE DEL USUARIO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 01/2009 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 AM   JUN 01/2009 LUN

1- Permite Cambiar el nombre del usuario.

2- Debe estar en uso el archivo de usuarios en el registro coreccto

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CamUsrName(lShared,nNroFil,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Compartir Archivos
       nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior

       LOCAL nNroReg := 0                   // N£mero del registro
       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cMsgTxt := ''                  // Texto variable

       LOCAL GetList := {}                  // Variable del sistema
*>>>>DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       cNomUsr := CRYPT(SUBS(AAA->A,121,10),"IVANAN")
       IF !lPregunta('DESEA CAMBIAR EL NOMBRE DE '+;
		    ALLTRIM(cNomUsr)+'? No Si')
	  RETURN NIL
       ENDIF
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DEL NOMBRE DEL USUARIO
       nFilSup := 10
       nColSup := 30
       nFilInf := 15
       nColInf := 52
       DISPBOX(nFilSup,nColSup,nFilInf,nColInf,"ÉÍ»º¼ÍÈº")

       nNroReg := AAA->(RECNO())
       nTipCur := SETCURSOR(1)
       DO WHILE .T.
	  @ nFilSup+2,nColSup+2 SAY 'USUARIO:';
				GET cNomUsr PICT '@A!'
	  READ

	  lHayErr := .T.
	  DO CASE
	  CASE EMPTY(cNomUsr)
	  CASE lLocNomUsr(lShared,CRYPT(cNomUsr,"IVANAN"),.F.)
	       cError('EL USUARIO YA ESTA CREADO')

	  OTHERWISE
	       lHayErr :=.F.
	  ENDCASE
	  IF lHayErr
	     RESTSCREEN(0,0,24,79,cSavPan)
	     AAA->(DBGOTO(nNroReg))
	     RETURN NIL
	  ENDIF
	  EXIT

       ENDDO
       SETCURSOR(nTipCur)
       RESTSCREEN(0,0,24,79,cSavPan)
       AAA->(DBGOTO(nNroReg))
*>>>>FIN LECTURA DEL NOMBRE DEL USUARIO

*>>>>GRABACION DEL NOMBRE DEL USUARIO
       IF AAA->(lRegLock(lShared,.F.))
	  REPL AAA->A WITH STUFF(AAA->A,121,10,CRYPT(cNomUsr,"IVANAN"))
	  cMsgTxt := CRYPT(STR(CHECKSUM(SUBS(AAA->A,1,130)),10),"IVANAN")
	  REPL AAA->A WITH STUFF(AAA->A,131,10,cMsgTxt)
	  AAA->(DBCOMMIT())
       ENDIF
       IF lShared
	  AAA->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL NOMBRE DEL USUARIO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDA LA EXISTENCIA DEL ARCHIVO DE USUARIOS   *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: NOV 05/94 SAB A
						       NOV 05/94 SAB
1- Verifica la existencia del archivo de usuarios

2- Verifica la existencia del supervisor de la aplicaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SuperOk(lShared,FileUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       FileUsr                              // Archivo de Usuarios */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lMensaj := .F.                 //.T. Mostrar mensaje de error
       LOCAL lValida := .F.                 //.T. Validar Cambios */

       LOCAL cNomUsr := 'SUPERVISOR'        // Nombre del usuario
       LOCAL cMsgTxt := ''                  // Texto variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA EXISTENCIA DEL ARCHIVO
       IF !FILE(FileUsr)
*	  CreaDbfUsr(FileUsr)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA EXISTENCIA DEL ARCHIVO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !FILE(FileUsr)
	  cError("CONTACTE AL PERSONAL QUE LE DA SERVICIO AL PROGRAMA",;
		 "ERROR GRAVE EN EL SISTEMA")
	  RETURN NIL
       ENDIF
       DBUSEAREA(.T.,NIL,FileUsr,"AAA",lShared,.F.)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DEL USUARIO
       cNomUsr := CRYPT(cNomUsr,"IVANAN")
      *Encripta el nombre
       IF lLocNomUsr(lShared,cNomUsr,lMensaj,.F.,lValida)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL USUARIO

*>>>>GRABACION DEL SUPERVISOR DEL SISTEMA
       IF AAA->(lRegLock(lShared,.T.))
	  REPL AAA->A WITH STUFF(AAA->A,121,10,CRYPT("SUPERVISOR","IVANAN"))
	  REPL AAA->A WITH STUFF(AAA->A,1,10  ,CRYPT("SUPERVISOR","IVANAN"))
	  REPL AAA->A WITH STUFF(AAA->A,11,110,CRYPT(REPL('1',110),"IVANAN"))
	  cMsgTxt := CRYPT(STR(CHECKSUM(SUBS(AAA->A,1,130)),10),"IVANAN")
	  REPL AAA->A WITH STUFF(AAA->A,131,10,cMsgTxt)
	  AAA->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL SUPERVISOR DEL SISTEMA')
       ENDIF
       IF lShared
	  AAA->(DBUNLOCK())
       ENDIF
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DEL SUPERVISOR DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIA LOS DERECHOS ASIGNADOS                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/97 SAB A
       Colombia, Bucaramanga        INICIO: 02:45 PM   MAR 01/97 SAB

OBJETIVOS:

1)- Cambia los derechos asignados al usuario

2)- Retorna los nuevos derechos

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCambiaDer(cNueDer,cDerech)

*>>>>PARAMETROS DE LA FUNCION
/*     cNueDer                              // Nuevos Derechos
       cDerech                              // Derechos Actuales */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nOpcPal := 0                   // Opci¢n del Men£ principal
       LOCAL nNroOpc := 0                   // Opci¢n del Submen£
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMBIO DE LOS DERECHOS ACTUALES
       cDerech := REPL('0',LEN(cDerech))
      *Borra todos los derechos actuales

       FOR i := 1 TO LEN(cNueDer)/4

	   nOpcPal := VAL(SUBS(cNueDer,i*4-3,2))
	   cDerech := STUFF(cDerech,100+nOpcPal,1,'1')
	 *ÀDerechos sobre el menu principal

	   nNroOpc := VAL(SUBS(cNueDer,(i*4-3)+2,2))
	   cDerech := STUFF(cDerech,(nOpcPal*10-10)+nNroOpc,1,'1')
	 *ÀDerechos sobre el submen£

       ENDFOR
       RETURN cDerech
*>>>>FIN CAMBIO DE LOS DERECHOS ACTUALES

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZACION DEL NOMBRE DEL USUARIO            *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 03/94 LUN A
						       OCT 03/94 LUN

1- Es el mismo fuente de la funcion lLocNomUsr se repitio para hacer
   seguimiento al Error Argumento .NOT. al intentar leer el nombre
   del usuario

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSekNomUsr(lShared,cAaaaaa,lMensaj,lValida)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAaaaaa			            // @Nombre del Usuario
       lMensaj                              // .T. Mostrar mensaje de error
       lValida                              // .T. Validar Cambios */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. = Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT AAA
       GO TOP
       LOCATE FOR SUBS(AAA->A,121,10) == cAaaaaa
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('NOMBRE INVALIDO')
	     cAaaaaa := SPACE(10)
	  ENDIF
	  lExiste := .F.
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>BLOQUEO DEL REGISTRO
       lShared := IF(lShared == NIL,.T.,lShared)
       IF lExiste .AND. lShared
	  AAA->(lRegLock(lShared,.F.))
       ENDIF
*>>>>FIN BLOQUEO DEL REGISTRO

*>>>>VALIDACION DE CAMBIOS EXTERNOS
       lValida := IF(lValida == NIL,.T.,lValida)
       IF lValida .AND. lExiste
	  IF CHECKSUM(SUBS(AAA->A,1,130)) <> VAL(CRYPT(SUBS(AAA->A,131,10),"IVANAN"))
	     cError("DA¥OS EN LA SEGURIDAD DEL USUARIO")
	     lExiste := .F.
	  ENDIF
       ENDIF
       RETURN lExiste
*>>>>FIN VALIDACION DE CAMBIOS EXTERNOS

/*************************************************************************
* TITULO..: LECTURA DEL NOMBRE DEL USUARIO                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 08/2005 LUN A
       Colombia, Bucaramanga        INICIO: 09:30 AM   AGO 08/2005 LUN

1- Permite leer el nombre del usuario

2- Retorna el nombre del usuario

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomUsr(lShared,nNroFil,nNroCol,PathUsr,FileUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       PathUsr                              // Path del Usuario
       FileUsr                              // Archivo de usuarios */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL cNomUsr := ''                  // Nombre del Usuario

       LOCAL GetList := {}                  // Variable del sistema
*>>>>DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !FILE(PathUsr+'\'+FileUsr)
	  cError("CONTACTE AL PERSONAL QUE LE DA SERVICIO AL PROGRAMA",;
		 "ERROR GRAVE EN EL SISTEMA")
	  RETURN NIL
       ENDIF
       DBUSEAREA(.T.,NIL,PathUsr+'\'+FileUsr,"AAA",lShared,.F.)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>INICIALIZACION DE LAS COORDENAS
       nFilSup := nNroFil     // 10
       nColSup := nNroCol     // 30
       nFilInf := nNroFil+5   // 15
       nColInf := nNroCol+22  // 52
*>>>>FIN INICIALIZACION DE LAS COORDENAS

*>>>>LECTURA DEL USUARIO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET COLOR TO I
       DISPBOX(nFilSup,nColSup,nFilInf,nColInf,"ÉÍ»º¼ÍÈº")
       SetClrTo()

       cNomUsr := SPACE(10)
       @ nFilSup+2,nColSup+2 SAY 'USUARIO:' GET cNomUsr
       READ
       IF EMPTY(cNomUsr)
	  CloseDbf('AAA')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL USUARIO

*>>>>LOCALIZACION DEL USUARIO
       cNomUsr := CRYPT(cNomUsr,"IVANAN")
      *Encripta el nombre

       IF !lLocNomUsr(lShared,cNomUsr,.F.)
	  CloseDbf('AAA')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL USUARIO

*>>>>LECTURA DE LA CLAVE
       IF !lLeePasWor(nFilSup+3,nColSup+4)
	  CloseDbf('AAA')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       CloseDbf('AAA')
       RESTSCREEN(0,0,24,79,cSavPan)
       cNomUsr := CRYPT(cNomUsr,"IVANAN")
       RETURN cNomUsr
*>>>>FIN LECTURA DE LA CLAVE

/*************************************************************************
* TITULO..: SELECCION DE DERECHOS DEL MENU DEL SISTEMA                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 11/2008 LUN A
       Colombia, Bucaramanga        INICIO: 08:30 PM   FEB 11/2008 LUN

1- Permite modificar los derechos para las opciones del menu principal
   del sistema.

2- Retorna Derechos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cOpcOnOf(lShared,bMenSys,cDerech,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       bMenSys				    // Menu del Sistema
       cDerech                              // Derechos del Usuario
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPa1 := ''                  // Salvar Pantalla
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cMsgTxt := ''                  // Texto Variable

       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL nFilSup := 0                   // Fila Superior del men£
       LOCAL aColSup := {}                  // Columnas para los Submen£s
       LOCAL       i := 0                   // Contador

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       cSavPa1 := SAVESCREEN(0,0,24,79)
       CLEAR
       @ 00,00,24,80 BOX CHR(177)+CHR(177)+CHR(177)+CHR(177)+CHR(177)+;
			 CHR(177)+CHR(177)+CHR(177)+CHR(177)
       LineaEstado('DERECHOS PARA LA APLICACION',cNomSis)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

**********SELEECION DEL MENU PRINCIPAL
	    aDeMenu := EVAL(bMenSys,0,@aAyuda)
	     aMenus := {}
	    FOR i:= 1 TO LEN(aDeMenu)
		AADD(aMenus,i)
		aMenus[i] := SUBS(aDeMenu[i],2,LEN(aDeMenu[i]))
	    NEXT
	    nFilSup := 00
	    aColSup := aColOpc(aMenus)
	   *Calcula de las columnas
**********FIN SELEECION DEL MENU PRINCIPAL

**********IMPRESION DE LOS DERECHOS DEL USUARIO
	    FOR i := 1 TO LEN(aMenus)
		IF SUBS(cDerech,100+i,1) == '1'
		   @ nFilSup+3,aColSup[i] SAY 'Si'
		ELSE
		   @ nFilSup+3,aColSup[i] SAY 'No'
		ENDIF
	    NEXT
**********FIN IMPRESION DE LOS DERECHOS DEL USUARIO

**********EJECUCION DEL MENU PRINCIPAL
	    nNroOpc := nMenu(aMenus,aAyuda,nFilSup,aColSup,;
			     'ASIGNACION DE DERECHOS',NIL,nNroOpc,.F.)
	    cSavPan := SAVESCREEN(0,0,24,79)
**********FIN EJECUCION DEL MENU PRINCIPAL

**********ANALISIS PARA LA TERMINACION DEL PROGRAMA
	    IF nNroOpc = 0
	       CLEAR
	       EXIT
	    ENDIF
**********FIN ANALISIS PARA LA TERMINACION DEL PROGRAMA

**********ASIGNACION DE LOS DERECHOS PRINCIPALES
	    IF SUBS(cDerech,100+nNroOpc,1) == '0'
	       cDerech := STUFF(cDerech,100+nNroOpc,1,'1')
	    ELSE
	       cDerech := STUFF(cDerech,100+nNroOpc,1,'0')
	    ENDIF
**********FIN ASIGNACION DE LOS DERECHOS PRINCIPALES

**********IMPRESION DEL DERECHO ACTUAL
	    IF SUBS(cDerech,100+nNroOpc,1) == '1'
	       @ nFilSup+2,aColSup[nNroOpc] SAY 'Si'
	    ELSE
	       @ nFilSup+2,aColSup[nNroOpc] SAY 'No'
	    ENDIF
**********FIN IMPRESION DEL DERECHO ACTUAL

**********ASIGNANCION DE LOS SUBDERECHOS
	    IF SUBS(cDerech,100+nNroOpc,1) == '1'
	       SubOnOfOpc(nNroOpc,nFilSup+2,aColSup,bMenSys,@cDerech,cSavPan)
	    ENDIF
**********FIN ASIGNANCION DE LOS SUBDERECHOS

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPa1)
       RETURN cDerech
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA


/*************************************************************************
* TITULO..: SELECCION DE DERECHOS DEL SUBMENU DEL SISTEMA                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 11/2008 LUN A
       Colombia, Bucaramanga        INICIO: 08:45 PM   FEB 11/2008 LUN

1- Permite modificar los derechos para las opciones de los SubMenus
   del sistema.

2- Retorna Derechos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubOnOfOpc(nOpcPal,nFilPal,aColSup,bMenSys,cDerech,cSavPan)

*>>>>PARAMETROS DE LA FUNCION
/*     nOpcPal                              // Opci¢n del men£ principal
       nFilPal                              // Fila Inferior men£ principal
       aColSup                              // Columnas para los sub_men£s
       bMenSys				    // Menu del Sistema
       cDerech                              // @Derechos del Usuario
       cSavPan 	                            // Salvar Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiMenu := .T.                 // .T. Existe Sub_men£
       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£

       LOCAL lFlecha := .F.                 // Uso de las flechas en menu
       LOCAL aMenus  := {}                  // Vector de declarcion del men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL nNroOpc := 1                   // N£mero de opci¢n del sub_men£
       LOCAL       i := 0                   // Contador

       LOCAL Getlist                        // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESARROLLO DEL PRIMER NIVEL
       DO WHILE .T.

**********DECLARACION DE LOS MENUS DEL PRIMER NIVEL
	    lSiMenu := .T.
	    aMenus  :=   EVAL(bMenSys,nOpcPal,@aAyuda)
**********FIN DECLARACION DE LOS MENUS DEL PRIMER NIVEL

**********ANALISIS DEL LIMITE DE LA COLUMNA
	    IF lSiMenu

	       ASCAN(aMenus, {|str| nLenOpc := MAX(nLenOpc,LEN(str))})
	      *Longitud mayor de las opciones

	       IF aColSup[nOpcPal]+ nLenOpc + 2 > 78
		  aColSup[nOpcPal] := 78-nLenOpc-1
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL LIMITE DE LA COLUMNA

**********IMPRESION DE LOS DERECHOS DEL USUARIO
	    FOR i := 1 TO LEN(aMenus)
		IF SUBS(cDerech,(nOpcPal*10-10)+i,1) == '1'
		   @ nFilPal+i+1,aColSup[nOpcPal]-1 SAY 'S'
		ELSE
		   @ nFilPal+i+1,aColSup[nOpcPal]-1 SAY 'N'
		ENDIF
	    NEXT
**********FIN IMPRESION DE LOS DERECHOS DEL USUARIO

**********EJECUCION DE LOS SUBMENUS
	    IF lSiMenu

	       nFilSup := nFilPal+1
	       nColSup := aColSup[nOpcPal]
	       nNroOpc := nMenu(aMenus,aAyuda,;
				nFilSup,nColSup,NIL,NIL,nNroOpc,lFlecha)
	       STORE .T. TO lSiMenu

	    ENDIF

	    IF nNroOpc == 0
	       RESTSCREEN(0,0,24,79,cSavPan)
	       EXIT
	    ENDIF
**********FIN EJECUCION DE LOS SUBMENUS

**********ASIGNACION DE LOS SUBDERECHOS
	    IF SUBS(cDerech,(nOpcPal*10-10)+nNroOpc,1) == '0'
	       cDerech := STUFF(cDerech,(nOpcPal*10-10)+nNroOpc,1,'1')
	    ELSE
	       cDerech := STUFF(cDerech,(nOpcPal*10-10)+nNroOpc,1,'0')
	    ENDIF
**********FIN ASIGNACION DE LOS SUBDERECHOS

       ENDDO
       RETURN NIL
*>>>>FIN DESARROLLO DEL PRIMER NIVEL