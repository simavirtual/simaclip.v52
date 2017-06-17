/*                      SIMASOFT - SISTEMA ADMINISTRADOR

MODULO     : SOFTWARE
SUBMODULO..: SIMAWEB

**************************************************************************
* TITULO..: CREACION DE LA BASE                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 08/2006 MIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   FEB 08/2006 MIE

OBJETIVOS:

1- Crea las tablas de la base de datos para los boletines.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Soft_203(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		  nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL cNroTbl := ''                  // N£mero de Tabla
       LOCAL nHandle := 0                   // N£mero de Archivo
       LOCAL FileTbl := ''                  // Nombre de la tabla
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL aMaeAct := {}                  // Dbfs de MaeAct
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL lSiPaso := .F.                 // Control de Flujo
       LOCAL PathSql := ''                  // Path del Sql
       LOCAL cLinTxt := ''                  // L¡nea de Texto
       LOCAL aRegTxt := {}                  // Registros de Texto
       LOCAL cRegTxt := {}                  // Registro de Texto

       LOCAL nNroAtt := 0                  // N£mero de Atributos

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TABLA DE EMPRESAS
       PathSql := 'FILEWWW'

       cNroTbl := '1'
       FileTbl := 'empresas'
       aStrDbf := aStrDbfWww(,'EMP')

       fSqlTbl(PathSql,'empresas',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt := 'copy '+FileTbl+'.str'
*>>>>FIN TABLA DE EMPRESAS

*>>>>TABLA DE USUARIOS
       cNroTbl := '2'
       FileTbl := 'usuarios'
       aStrDbf := aStrDbfWww(,'USR')

       fSqlTbl(PathSql,'usuarios',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE USUARIOS

*>>>>TABLA DE TIPOS DE USUARIOS
       cNroTbl := '3'
       FileTbl := 'tipousr'
       aStrDbf := aStrDbfWww(,'TUS')

       fSqlTbl(PathSql,'tipousr',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>TABLA DE TIPOS DE USUARIOS

*>>>>TABLA DE CONFIGURACION
       cNroTbl := '4'
       FileTbl := 'simaWww'
       aStrDbf := aStrDbfWww(,'WWW')

       fSqlTbl(PathSql,'simaWww',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE CONFIGURACION

*>>>>TABLA DE PERSONAS
       cNroTbl := '5'
       FileTbl := 'personas'
       aStrDbf := aStrDbfWww(,'PER')

       fSqlTbl(PathSql,'personas',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE PERSONAS

*>>>>TABLA DE PERFILES DE NIVEL
       cNroTbl := '6'
       FileTbl := 'perfil_nivel'
       aStrDbf := aStrDbfWww(,'PNI')

       fSqlTbl(PathSql,'pfinivel',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+ pfinivel.str'
*>>>>FIN TABLA DE PERFILES DE NIVEL

*>>>>TABLA DE PROFESORES
       cNroTbl := '7'
       FileTbl := 'profes'
       aStrDbf := aStrDbfWww(,'DOC')

       fSqlTbl(PathSql,'profes',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE PROFESORES

*>>>>TABLA DE ALUMNOS
       cNroTbl := '8'
       FileTbl := 'alumnos'
       aStrDbf := aStrDbfWww(,'ALU')

       fSqlTbl(PathSql,'alumnos',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE ALUMNOS

*>>>>TABLA DE NIVELES
       cNroTbl := '9'
       FileTbl := 'niveles'
       aStrDbf := aStrDbfWww(,'NIV')

       fSqlTbl(PathSql,'niveles',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE NIVELES

*>>>>TABLA DE GRUPOS
       cNroTbl := '10'
       FileTbl := 'grupos'
       aStrDbf := aStrDbfWww(,'GRU')

       fSqlTbl(PathSql,'grupos',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>TABLA DE GRUPOS

*>>>>TABLA DE MATERIAS
       cNroTbl := '11'
       FileTbl := 'materias'
       aStrDbf := aStrDbfWww(,'MAT')

       fSqlTbl(PathSql,'materias',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE MATERIAS

*>>>>TABLA DE CARGAS
       cNroTbl := '12'
       FileTbl := 'cargas'
       aStrDbf := aStrDbfWww(,'CAR')

       fSqlTbl(PathSql,'cargas',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE CARGAS

*>>>>TABLA DE LISTAS
       cNroTbl := '13'
       FileTbl := 'listas'
       aStrDbf := aStrDbfWww(,'LIS')

       fSqlTbl(PathSql,'listas',FileTbl,aStrDbf)
       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)

       cRegTxt += '+'+FileTbl+'.str'
*>>>>FIN TABLA DE LISTAS

*>>>>UBICACION DE LA TABLAS
       AADD(aLinTxt,'')
       FOR i := 1 TO 13
	   cLinTxt := SPACE(08)+;
		  '<graphmetadata:Node element="ent'+ALLTRIM(STR(i,4))+'" '+;
				     'id="ent'+ALLTRIM(STR(i,4))+;
				     '_go" x="37.541733" y="166.31686"/>'
	   AADD(aLinTxt,cLinTxt)
       ENDFOR
*>>>>FIN UBICACION DE LA TABLAS

*>>>>CREACION DEL ARCHIVO DE ENTIDA DE WEBML
       FileTem := PathSql+'\Entidad.xml'
       IF FCREATE(FileTem,0) == -1
	  cError('NO SE PUEDE CREAR EL ARCHIVO '+FileTem)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO DE ENTIDA DE WEBML

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(FileTem,2)) = -1 .AND. lFHayErr(FileTem)
	  cError(FileTem,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>CREACION DE LA LINEAS DEL ARCHIVO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,FileTem)
       NEXT
*>>>>FIN CREACION DE LA LINEAS DEL ARCHIVO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(FileTem)
	  cError('ERROR CERRANDO EL ARCHIVO '+FileTem)
       ENDIF
*>>>>FIN CERRANDO ARCHIVOS

*>>>>CREACION DEL ARCHIVO BAT
       cRegTxt += ' simaweb.sql'
       aRegTxt := {}
       AADD(aRegTxt,{cRegTxt})

       FileChr(PathSql+'\str.bat',aRegTxt)
       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO BAT
