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
  CreaDbfUsr()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfUsr(FileAaa)

*>>>>PARAMETROS DE LA FUNCION
/*     FileAaa                              // Archivo de usuarios */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aDbfUsr := {{"cAaaaaaaaa","Character",10,0},;
			 {"cBbbbbbbbb","Character",10,0},;
			 {"cCcccccccc","Character",110,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       DBCREATE(FileAaa, aDbfUsr, "DBFNTX")
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

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

FUNCTION lLocNomUsr(cAaaaaa,lMensaj,lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     cAaaaaa			            // @Nombre del Usuario
       lMensaj                              // .T. Mostrar mensaje de error
       lShared                              // .T. Archivo compartido */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. = Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT AAA
       GO TOP
       LOCATE FOR AAA->cAaaaaaAaa == cAaaaaa
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('NOMBRE INVALIDO')
	     cAaaaaa := SPACE(LEN(cAaaaaa))
	  ENDIF
	  lExiste := .F.
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>BLOQUEO DEL REGISTRO
       lShared := IF(lShared == NIL,.T.,lShared)
       IF lExiste .AND. lShared
	  AAA->(lRegLock(.F.))
       ENDIF
       RETURN lExiste
*>>>>FIN BLOQUEO DEL REGISTRO

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

FUNCTION lValNomUsr(cNomUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomUsr				    // C¢digo del Concepto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       IF cNomUsr # cSpaField('AAA','CAaaaaaAaa')
	  IF lLocNomUsr(cNomUsr,.F.)
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

1- Abre el archivo de Usuarios

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite leer el nombre del usuario junto con su clave

4- Cierra el archivo de usuarios una vez leidos sus derechos

5- Retorna los derechos del usuario

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cUsuario(FileUsr,cNomUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     FileUsr                              // Archivo de usuarios
       cNomUsr                              // Nombre del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Archivos Compartidos
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cDerech := ''                  // Derechos del Usuario
       LOCAL cPasWor := ''                  // Palabra Clave
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileUsr,'AAA',NIL,lShared)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>INICIALIZACION DE LAS COORDENAS
       nFilSup := 10
       nColSup := 30
       nFilInf := 15
       nColInf := 52
       cSavPan := SAVESCREEN(nFilSup,nColSup,nFilInf,nColInf)
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
       IF !lLocNomUsr(@cNomUsr)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL USUARIO

*>>>>LECTURA DE LA CLAVE DE ACCESO
       SET COLOR TO W/N,N/N,N

       DO WHILE i <= 3
	  cPasWor := SPACE(10)
	  @ nFilSup+3,nColSup+4 SAY 'CLAVE:' GET cPasWor
	  READ

	  IF cPasWor == AAA->cBbbbbbBbb
	     lHayErr := .F.
	     EXIT
	  ELSE
	     lHayErr := .T.
	  ENDIF
	  i++
       ENDDO

       IF lHayErr
	  cDerech := NIL
       ELSE
	  cDerech := AAA->cCcccccCcc
       ENDIF

       CLOSE AAA

       RESTSCREEN(nFilSup,nColSup,nFilInf,nColInf,cSavPan)
       SET COLOR TO W/N,N/W,N
       RETURN cDerech
*>>>>FIN LECTURA DE LA CLAVE


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

FUNCTION AsigDerech(bCodBlo,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     bCodBlo			            // Code Block funcion de Menus
       cNomSis                              // Nombre del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPa1 := ''                  // Salvar Pantalla
       LOCAL cSavPan := ''                  // Salvar Pantalla

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
       LineaEstado('DERECHOS PARA EL USUARIO: '+AAA->cAaaaaaAaa,cNomSis)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nNroOpc := 1
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
		IF SUBS(AAA->cCcccccCcc,100+i,1) == '1'
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

**********GRABACION DEL DERECHO
	    IF AAA->(lRegLock(.F.))
	       IF SUBS(AAA->cCcccccCcc,100+nNroOpc,1) == '0'
		  REPL AAA->cCcccccCcc WITH ;
		       STUFF(AAA->cCcccccCcc,100+nNroOpc,1,'1')
	       ELSE
		  REPL AAA->cCcccccCcc WITH ;
		       STUFF(AAA->cCcccccCcc,100+nNroOpc,1,'0')
	       ENDIF
	    ELSE
	       cError('NO SE GRABA EL DERECHO DEL MENU PRINCIPAL')
	    ENDIF
**********FIN GRABACION DEL DERECHO

**********IMPRESION DEL DERECHO ACTUAL
	    IF SUBS(AAA->cCcccccCcc,100+nNroOpc,1) == '1'
	       @ nFilSup+2,aColSup[nNroOpc] SAY 'Si'
	    ELSE
	       @ nFilSup+2,aColSup[nNroOpc] SAY 'No'
	    ENDIF
**********FIN IMPRESION DEL DERECHO ACTUAL

**********ASIGNANCION DE LOS SUBDERECHOS
	    IF SUBS(AAA->cCcccccCcc,100+nNroOpc,1) == '1'
	       SubDerechos(nNroOpc,nFilSup+2,aColSup,bCodBlo,cSavPan)
	    ENDIF
**********FIN ASIGNANCION DE LOS SUBDERECHOS

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPa1)
       RETURN NIL
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA

/*************************************************************************
* TITULO DE LA FUNCION..: ASIGNACION DE SUBDERECHOS AL USUARIOS          *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: OCT 08/94 SAB A
						       OCT 09/94 DOM
1- Debe estar en Uso el archivo de Usuarios

2- Permite asignar y grabar los derechos a los SubMenus

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SubDerechos(nOpcPal,nFilPal,aColSup,bCodBlo,cSavPan)

*>>>>PARAMETROS DE LA FUNCION
/*     nOpcPal                              // Opci¢n del men£ principal
       nFilPal                              // Fila Inferior men£ principal
       aColSup                              // Columnas para los sub_men£s
       bCodBlo			            // Code Block. Funcion con Menus
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
		IF SUBS(AAA->cCcccccCcc,(nOpcPal*10-10)+i,1) == '1'
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

**********GRABACION DE LOS DERECHOS
	    IF AAA->(lRegLock(.F.))
	       IF SUBS(AAA->cCcccccCcc,(nOpcPal*10-10)+nNroOpc,1) == '0'
		  REPL AAA->cCcccccCcc WITH;
		       STUFF(AAA->cCcccccCcc,(nOpcPal*10-10)+nNroOpc,1,'1')
	       ELSE
		  REPL AAA->cCcccccCcc WITH;
		      STUFF(AAA->cCcccccCcc,(nOpcPal*10-10)+nNroOpc,1,'0')
	       ENDIF
	    ELSE
	       cError('NO SE GRABA EL DERECHO DEL MENU PRINCIPAL')
	    ENDIF
**********FIN GRABACION DE LOS DERECHOS

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

FUNCTION MantenUsr(FileUsr,bCodBlo,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     FileUsr                              // Archivo de Usuarios
       bCodBlo			            // Code Block. Funcion con Menus
       cNomSis                              // Nombre del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL oBrwUsr := NIL		    // Objeto Browse de Usuarios
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileUsr,'AAA',NIL,.F.)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       IF AAA->(RECCOUNT()) # 0
	  SELECT AAA
	  oBrwUsr := oDefBrwUsr(03,00,22,79,bCodBlo,cNomSis)
	  SETKEY(K_F5,{||AsigDerech(bCodBlo,cNomSis)})
	  AAA->(CtrlBrw(lShared,oBrwUsr))
	  SETKEY(K_F5,NIL)
       ELSE
	  cError('NO EXISTEN USUARIOS')
       ENDIF
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

 oBrwUsr := oDefBrwUsr(00,00,24,79,cNomSis)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwUsr(nFilSup,nColSup,nFilInf,nColInf,bCodBlo,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       bCodBlo			            // Code Block. Funcion con Menus
       cNomSis                              // Nombre del Sistema */
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
			    '<ESC>Abandonar',{||IncluirUsr(bCodBlo,cNomSis)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT AAA
       oColumn	     := TBCOLUMNNEW('NOMBRE', {||AAA->cAaaaaaaAaa})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwUsr:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

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

FUNCTION IncluirUsr(bCodBlo,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     bCodBlo			            // Code Block. Funcion con Menus
       cNomSis                              // Nombre del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // Grabar el registro

       LOCAL cAaaaaaTaa := ''               // Nombre del Usuario
       LOCAL cBbbbbbTbb := ''               // Clave del Usuario
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE EL NOMBRE DEL USUARIO',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cAaaaaaTaa := cSpaField('AAA','cAaaaaaAaa')
	       cBbbbbbTbb := cSpaField('AAA','cBbbbbbBbb')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'NOMBRE DEL USUARIO:';
				GET cAaaaaaTaa PICT '@A!';
				VALID !lValNomUsr(cAaaaaaTaa)
	    @ nNroFil+1,nNroCol SAY 'CLAVE PARA USUARIO:';
				GET cBbbbbbTbb PICT '@A!'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE cAaaaaaTaa == cSpaField('AAA','cAaaaaaAaa') .OR.;
		 cBbbbbbTbb == cSpaField('AAA','cBbbbbbBbb')

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
	  IF AAA->(lRegLock(.T.))
	     REPL cAaaaaaAaa WITH cAaaaaaTaa
	     REPL cBbbbbbBbb WITH cBbbbbbTbb
	     REPL cCcccccCcc WITH REPL('0',111)
	  ENDIF
	  cError('A CONTINUACION ASIGNE LOS DERECHOS PARA '+;
		 ALLTRIM(AAA->cAaaaaaAaa))
	  AsigDerech(bCodBlo,cNomSis)
	  DBUNLOCK()
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO