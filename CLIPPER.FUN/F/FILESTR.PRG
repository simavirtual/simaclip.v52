/*                   SIMA. SISTEMA INTEGRADO MULTIUSUARIO
		BIBLIOTECA DE FUNCIONES PARA EL ARCHIVO DE FILEPRG

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:00 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfStr(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'nIdeCodStr','Numeric'  ,16,0}) // Ide del Registro
      *Llave Principal

       AADD(aDbfStr,{"cNomArcStr","Character",12,0}) // Nombre del Archivo
       AADD(aDbfStr,{"Field_Name","Character",10,0}) // Nombre del Campo
       AADD(aDbfStr,{"Field_Type","Character",01,0}) // Tipo de Campo
       AADD(aDbfStr,{"Field_Len" ,"Numeric"  ,03,0}) // Longitud del Campo
       AADD(aDbfStr,{"Field_Dec" ,"Numeric"  ,01,0}) // N£mero de decimales
     *ÀEstructura del Archivo

       AADD(aDbfStr,{"Field_Pic" ,"Character",20,0}) // Picture del Campo
       AADD(aDbfStr,{"Field_Val" ,"Logical"  ,01,0}) // Validaci¢n de Vacio
       AADD(aDbfStr,{"Field_Mod" ,"Character",08,0}) // Validaci¢n para modificar el campo
     *ÀCampos de Validaci¢n

       AADD(aDbfStr,{"cTitArcStr","Character",20,0}) // T¡tulo del Archivo
       AADD(aDbfStr,{"cNaliasStr","Character",03,0}) // Alias del Archivo
       AADD(aDbfStr,{"cTemCamStr","Character",03,0}) // Temporal del Campo
       AADD(aDbfStr,{"cDocCamStr","Character",60,0}) // Documentaci¢n del Campo
       AADD(aDbfStr,{"cTxtGetStr","Character",40,0}) // Texto para la lectura
       AADD(aDbfStr,{"nLenGetStr","Numeric  ",02,0}) // Longitud del texto para la lectura
       AADD(aDbfStr,{"cHlpGetStr","Character",60,0}) // Ayuda para la lectura
       AADD(aDbfStr,{"cTxtBrwStr","Character",40,0}) // Texto para el Browse
       AADD(aDbfStr,{"cTitPrnStr","Character",40,0}) // T¡tulo para impresi¢n

       AADD(aDbfStr,{"nCodigoStr","Numeric"  ,16,0}) // C¢digo del Registro
       AADD(aDbfStr,{"cNomUsrStr","Character",10,0}) // Nombre del Usuario
       AADD(aDbfStr,{"dFecUsrStr","Date"     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{"cHorUsrStr","Character",10,0}) // Hora del Usuario
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE nCd(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE nCd(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE nCd(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       nCd(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:05 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfStr(lShared,nModCry,PathArc,fArchvo)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfStr(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:10 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Actualiza la Estructura del Archivo

2- Retorna el N£mero de Error:
   0 => No hay Error
	Estructura Actualizada
	Estructura Sin problemas
   1 => Estructura No Actualizada

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrStr(lShared,nModCry,PathArc,cNomArc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ACT',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('ACT')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ACT->(DBSTRUCT())
       CloseDbf('ACT')
       CreaDbfStr(lShared,nModCry,PathArc,cNomArc,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio .AND. lShared
	  cError('El Archivo '+cNomArc+' su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfStr(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:15 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenStr(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		   cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		   aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		   lHaySql,lHayPrg)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       cNitEmp                              // Nit de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       PathArc                              // Path del Archivo
       fArchvo				    // Archivo de Usuarios
       aArcNtx			            // Archivos Indice
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       lHayPrg                              // .T. Generar Prg */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aUseDbf := {}                  // Archivos en Uso
       LOCAL fNtxArc := ''                  // Archivo Indice
       LOCAL oBrowse := NIL                 // Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       fNtxArc := IF(aArcNtx==NIL,NIL,PathArc+'\'+aArcNtx[1])

       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathArc+'\'+fArchvo,'ARC',fNtxArc,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('ARC')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>PARAMETROS POR DEFECTO
       lModReg := IF(EMPTY(lModReg),.F.,lModReg)
       lModReg := IF(lModReg .AND. ARC->(RECCOUNT())==0,.F.,lModReg)

       lDelReg := IF(lDelReg==NIL,.F.,lDelReg)

       lInsReg := IF(lInsReg==NIL,.F.,lInsReg)

       lHaySql := IF(lHaySql==NIL,.F.,lHaySql)
*>>>>FIN PARAMETROS POR DEFECTO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwDbfStr(lShared,cNomUsr,cAnoUsr,03,00,22,79,;
			     lModReg,lDelReg,lInsReg,lHaySql)

       SETKEY(K_F2,{||lManRegStr(lShared,cNomUsr,3)})
     *ÀConsulta

       IF lModReg
	  SETKEY(K_F4,{||lManRegStr(lShared,cNomUsr,2,oBrowse,;
				    ARC->Field_Name)})
       ENDIF
     *ÀActualizar

       SETKEY(K_F5,{||BuscarStr(oBrowse)})

       SETKEY(K_F9,{||MenuOtrStr(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
				 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
				 PathArc,fArchvo,aArcNtx,lPrnArc,cOpcPrn,;
				 lModReg,lDelReg,lInsReg,lHaySql,oBrowse,;
				 lHayPrg)})

       ARC->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F2,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CloseDbf('ARC')
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:20 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwDbfStr(lShared,cNomUsr,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,;
		    lModReg,lDelReg,lInsReg,lHaySql)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registros
       lHaySql                              // .T. Exportar a Sql */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrowse := NIL	            // Browse del Archivo

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       cTitSup := '<< INFORMACION DE LAS EMPRESAS >>'
       cTitInf := '<F2>Consultar <F5>Buscar'+;
		   IF(lModReg,' <F4>Actualizar','')+' <F9>Otros'+;
		   IF(lDelReg,' <DEL>Borrar','')+;
		   IF(lInsReg,' <INS>Incluir','')

       IF lInsReg
	  oBrowse:Cargo := {cTitSup,cTitInf,{||lManRegStr(lShared,cNomUsr)}}
       ELSE
	  oBrowse:Cargo := {cTitSup,cTitInf}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ARC
       oColumn := TBCOLUMNNEW('CAMPO',{||ARC->Field_Name})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','Field_Name'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze := 1
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO',{||ARC->Field_Type})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','Field_Type'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('LEN',{||ARC->Field_Len})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','Field_Len'},{'PICTURE','999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('DECS',{||ARC->Field_Dec})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','Field_Dec'},{'PICTURE','9.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PICTURE',{||ARC->Field_Pic})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','Field_Pic'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALID',{||ARC->Field_Val})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','Field_Val'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MODREG',{||ARC->Field_Mod})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','Field_Mod'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('DOCUMENTACION',{||ARC->cDocCamStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cDocCamStr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ARCHIVO',{||ARC->cNomArcStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cNomArcStr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DESCRIPCION ARCHIVO',{||ARC->cTitArcStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cTitArcStr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ALIAS DEL ARCHIVO',{||ARC->cNaliasStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cNaliasStr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('EXTENSION DEL;CAMPO TEMPORAL',{||ARC->cTemCamStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cTemCamStr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TXT BROWSE',{||ARC->cTxtBrwStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cTxtBrwStr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TXT GET',{||ARC->cTxtGetStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cTxtGetStr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('LEN GET',{||ARC->nLenGetStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','nLenGetStr'},{'PICTURE','99.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('AYUDA GET',{||ARC->cHlpGetStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cHlpGetStr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TITULO PRN',{||ARC->cTitPrnStr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cTitPrnStr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||ARC->cNomUsrStr})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(ARC->dFecUsrStr)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(ARC->cHorUsrStr)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO',{||ARC->nCodigoStr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','nCodigoStr'},{'PICTURE','9999999999999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('No.',{||ARC->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL REGISTRO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:25 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Permite inclusi¢n,modificaci¢n y consulta del registro

2- Puede invocarse en la lectura a trav‚s de la clausula VALID

2- Returna .T.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lManRegStr(lShared,cNomUsr,nTipMod,oBrowse,cCodigo,nNroOpc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       nTipMod			            // Tipo de Modificaci¢n. 1 =>Insertar, 2=>Modificar 3=>Consultar
       cCodigo			            // C¢digo a Ingresar, Actualizar
       cTipNit                              // Tipo de Documento
       nNroOpc                              // N£mero de Opci¢n
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL nTipCur := 1                   // Tipo de Cursor
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 1                   // N£mero de la Columna
       LOCAL nColTem := 0                   // Columna Temporal
       LOCAL nFilIni := 0                   // Fila Inicial

       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL lInsReg := .F.                 // .T. Insertar el Registro

       LOCAL cTxtTem := ''                  // Texto temporal
       LOCAL cTxtHlp := ''                  // Texto de Ayuda

       LOCAL cNomCam := ''                  // Nombre del Campo
       LOCAL cTipCam := ''                  // Tipo de Campo
       LOCAL nLenCam := 0                   // Longitud del Campo
       LOCAL nDecCam := 0                   // N£mero de decimales
     *ÀEstructura del Archivo

       LOCAL cPicCam := ''                  // Picture del Campo
       LOCAL lValCam := .F.                 // Validaci¢n de Vacio
       LOCAL nLenGet := 0                   // Longitud del texto para la lectura

       LOCAL cNomDbf := ''                  // Nombre del Archivo
       LOCAL cDocCam := ''                  // Documentaci¢n del Campo
       LOCAL cTxtBrw := ''                  // Texto para el Browse
       LOCAL cTxtGet := ''                  // Texto para la lectura
       LOCAL cHlpGet := ''                  // Ayuda para la lectura
       LOCAL cTitPrn := ''                  // T¡tulo para Impresi¢n

       LOCAL GetList := {}                 // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENU
       nTipMod := IF(nTipMod==NIL,1,nTipMod)

       cSavPan := SAVESCREEN(0,0,24,79)
       IF EMPTY(nNroOpc)

	  AADD(aMenus,'1<INFORMACION BASICA>')

	  AADD(aAyuda,IF(nTipMod==3,'Consulta','Actualiza')+' '+;
		      'la Informaci¢n B sica de la Empresa')

	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := 1
	  nNroOpc := nMenu(aMenus,aAyuda,10,25,;
			   IF(nTipMod==3,'CONSULTAR','ACTUALIZAR'),NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nNroOpc == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN DECLARACION DEL MENU

*>>>>VALIDACION DE LA INFORMACION BASICA
       IF nNroOpc # 1
	  IF EMPTY(nNroOpc) // Ojo
	     cError('PRIMERO DEBE ESTAR ACTUALIZADA LA INFORMACION BASICA')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LA INFORMACION BASICA

*>>>>MARCO DEL MANTENIMIENTO
       nTipCur := SETCURSOR()
       DO CASE
       CASE nTipMod == 1
	    cTxtTem := 'POR FAVOR INGRESE LOS DATOS DEL ARCHIVO'
	    ARC->(DBGOBOTTOM())
	    ARC->(DBSKIP())
	    nTipCur := SETCURSOR(1)

       CASE nTipMod == 2
	    cTxtTem := 'POR FAVOR ACTUALICE LOS DATOS DEL ARCHIVO'
	    nTipCur := SETCURSOR(1)

       CASE nTipMod == 3
	    cTxtTem := 'CONSULTA DE LOS DETALLES DEL ARCHIVO'
       ENDCASE
       nFilIni := nMarco(03,cTxtTem,22,'°')
*>>>>FIN MARCO DEL MANTENIMIENTO

*>>>>MANTENIMIENTO DEL REGISTRO
       SELECT ARC
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF lGrabar

	       IF EMPTY(cCodigo)
		  cCodigo := ARC->Field_Name
	       ENDIF

	       cNomDbf := ARC->cNomArcStr
	       cTipCam := ARC->Field_Type
	       nLenCam := ARC->Field_Len
	       nDecCam := ARC->Field_Dec

	       cPicCam := ARC->Field_Pic
	       lValCam := ARC->Field_Val
	       nLenGet := ARC->nLenGetStr

	       cDocCam := ARC->cDocCamStr
	       cTxtBrw := ARC->cTxtBrwStr
	       cTxtGet := ARC->cTxtGetStr
	       cHlpGet := ARC->cHlpGetStr
	       cTitPrn := ARC->cTitPrnStr

	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********NOMBRE DEL CAMPO
	    nNroFil := nFilIni
	    cTxtTem := 'NOMBRE DEL CAMPO       :'

	    IF nTipMod == 2 .OR. nTipMod == 3 .OR. !EMPTY(cCodigo)
	       @ nNroFil,nNroCol SAY cTxtTem
	       @ nNroFil,nNroCol+LEN(cTxtTem)+1 SAY cCodigo COLOR('I')
	    ELSE
	       @ nNroFil,nNroCol SAY cTxtTem;
				 GET cCodigo PICT '@X';
				 VALID !EMPTY(cCodigo) .AND.;
				       !lValCodStr(cCodigo)
	    ENDIF
**********FIN NOMBRE DEL CAMPO

**********TIPO DE CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'TIPO DE CAMPO          :'

	    IF nTipMod == 3
	       @ nNroFil+01,nColTem SAY cTxtTem
	       @ nNroFil+01,nColTem+LEN(cTxtTem)+1 SAY cTipCam COLOR('I')
	    ELSE
	       @ nNroFil+01,nColTem SAY cTxtTem;
				 GET cTipCam PICT "@X";
				 VALID !EMPTY(cTipCam);
			    WHEN {||HelpRead('DIGITE EL TIPO DE CAMPO')}
	    ENDIF
**********FIN TIPO DE CAMPO

**********LONGITUD DE CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'LONGITUD DEL CAMPO     :'

	    IF nTipMod == 3
	       @ nNroFil+02,nColTem SAY cTxtTem
	       @ nNroFil+02,nColTem+LEN(cTxtTem)+1 SAY nLenCam COLOR('I')
	    ELSE
	       @ nNroFil+02,nColTem SAY cTxtTem;
				 GET nLenCam PICT "99";
				 VALID !EMPTY(nLenCam);
			    WHEN {||HelpRead('DIGITE LA LONGITUD DEL CAMPO')}
	    ENDIF
**********FIN LONGITUD DE CAMPO

**********DECIMALES DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'DECIMALES DEL CAMPO    :'

	    IF nTipMod == 3
	       @ nNroFil+03,nColTem SAY cTxtTem
	       @ nNroFil+03,nColTem+LEN(cTxtTem)+1 SAY nDecCam COLOR('I')
	    ELSE
	       @ nNroFil+03,nColTem SAY cTxtTem;
				 GET nDecCam PICT "9";
			    WHEN {||HelpRead('DIGITE LOS DECIMALES DEL CAMPO')}
	    ENDIF
**********FIN DECIMALES DEL CAMPO

**********PICTURE DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'PICTURE DEL CAMPO      :'

	    IF nTipMod == 3
	       @ nNroFil+04,nColTem SAY cTxtTem
	       @ nNroFil+04,nColTem+LEN(cTxtTem)+1 SAY cPicCam COLOR('I')
	    ELSE
	       @ nNroFil+04,nColTem SAY cTxtTem;
				    GET cPicCam PICT "@!";
			    WHEN {||HelpRead('DIGITE EL PICTURE DEL CAMPO')}
	    ENDIF
**********FIN PICTURE DEL CAMPO

**********VALIDACION DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'VALIDAR EL CAMPO       :'

	    IF nTipMod == 3
	       @ nNroFil+05,nColTem SAY cTxtTem
	       @ nNroFil+05,nColTem+LEN(cTxtTem)+1 SAY IF(lValCam,'SI','NO') COLOR('I')
	    ELSE
	       @ nNroFil+05,nColTem SAY cTxtTem;
				    GET lValCam PICT "@!";
			    WHEN {||HelpRead('POR FAVOR DIGITE SI EL CAMPO DEBE SER VALIDADO')}
	    ENDIF
**********FIN VALIDACION DEL CAMPO

**********ARCHIVO DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'ARCHIVO DEL CAMPO      :'

	    IF nTipMod == 3
	       @ nNroFil+06,nColTem SAY cTxtTem
	       @ nNroFil+06,nColTem+LEN(cTxtTem)+1 SAY cNomDbf COLOR('I')
	    ELSE
	       @ nNroFil+06,nColTem SAY cTxtTem;
				 GET cNomDbf PICT "@!";
				 VALID !EMPTY(cNomDbf);
			    WHEN {||HelpRead('INGRESE EL ARCHIVO AL QUE PERTENECE EL CAMPO')}
	    ENDIF
**********FIN ARCHIVO DEL CAMPO

**********DOCUMENTACION DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'DOCUMENTACION DEL CAMPO:'

	    IF nTipMod == 3
	       @ nNroFil+07,nColTem SAY cTxtTem
	       @ nNroFil+07,nColTem+LEN(cTxtTem)+1 SAY cDocCam COLOR('I')
	    ELSE
	       @ nNroFil+07,nColTem SAY cTxtTem;
				 GET cDocCam PICT "@X";
				 VALID !EMPTY(cDocCam);
			    WHEN {||HelpRead('DIGITE LOS DOCUMENTACION DEL CAMPO')}
	    ENDIF
**********FIN DOCUMENTACION DEL CAMPO

**********OBROWSE DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'OBROWSE DEL CAMPO      :'

	    IF nTipMod == 3
	       @ nNroFil+08,nColTem SAY cTxtTem
	       @ nNroFil+08,nColTem+LEN(cTxtTem)+1 SAY cTxtBrw COLOR('I')
	    ELSE
	       @ nNroFil+08,nColTem SAY cTxtTem;
				 GET cTxtBrw PICT "@!";
				 VALID !EMPTY(cTxtBrw);
			    WHEN {||HelpRead('DIGITE LOS OBROWSE DEL CAMPO')}
	    ENDIF
**********FIN OBROWSE DEL CAMPO

**********TEXTO DEL GET
	    nColTem := nNroCol
	    cTxtTem := 'TEXTO DEL GET          :'

	    IF nTipMod == 3
	       @ nNroFil+09,nColTem SAY cTxtTem
	       @ nNroFil+09,nColTem+LEN(cTxtTem)+1 SAY cTxtGet COLOR('I')
	    ELSE
	       @ nNroFil+09,nColTem SAY cTxtTem;
				 GET cTxtGet PICT "@!";
				 VALID !EMPTY(cTxtGet);
			    WHEN {||HelpRead('DIGITE EL TEXTO DEL GET')}
	    ENDIF
**********FIN TEXTO DEL GET

**********LEN TITULO DE LECTURA
	    nColTem := nNroCol
	    cTxtTem := 'LEN TITULO GET         :'

	    IF nTipMod == 3
	       @ nNroFil+10,nColTem SAY cTxtTem
	       @ nNroFil+10,nColTem+LEN(cTxtTem)+1 SAY cPicCam COLOR('I')
	    ELSE
	       @ nNroFil+10,nColTem SAY cTxtTem;
				    GET cPicCam PICT "@!";
			    WHEN {||HelpRead('DIGITE LA LONGITUD DEL TITULO DE LECTURA')}
	    ENDIF
**********FIN LEN TITULO DE LECTURA

**********AYUDA DEL GET
	    nColTem := nNroCol
	    cTxtTem := 'AYUDA DEL GET          :'

	    IF nTipMod == 3
	       @ nNroFil+11,nColTem SAY cTxtTem
	       @ nNroFil+11,nColTem+LEN(cTxtTem)+1 SAY cHlpGet COLOR('I')
	    ELSE
	       @ nNroFil+11,nColTem SAY cTxtTem;
				 GET cHlpGet PICT "@!";
				 VALID !EMPTY(cHlpGet);
			    WHEN {||HelpRead('DIGITE EL AYUDA DEL GET')}
	    ENDIF
**********FIN AYUDA DEL GET

**********TITULO PARA IMPRESION
	    nColTem := nNroCol
	    cTxtTem := 'TITULO PARA EL LISTADO :'

	    IF nTipMod == 3
	       @ nNroFil+12,nColTem SAY cTxtTem
	       @ nNroFil+12,nColTem+LEN(cTxtTem)+1 SAY cTitPrn COLOR('I')
	    ELSE
	       @ nNroFil+12,nColTem SAY cTxtTem;
				 GET cTitPrn PICT "@!";
				 VALID !EMPTY(cTitPrn);
			    WHEN {||HelpRead('DIGITE EL TITULO PARA EL LISTADO')}
	    ENDIF
**********FIN TITULO PARA IMPRESION

**********LECTURA DE LOS CAMPOS
	    IF nTipMod == 3
	       cPausa()
	       EXIT
	    ELSE
	       READ
	    ENDIF
**********FIN LECTURA DE LOS CAMPOS

**********PREGUNTA DE DECISION
	    DO CASE
	    CASE LASTKEY() # K_ESC .AND. nTipMod # 3
		 IF !lPregunta('DESEA GRABAR? Si No')
		    lGrabar := .F.
		    LOOP
		 ELSE
		    lGrabar := .T.
		    EXIT
		 ENDIF

	    CASE LASTKEY() == K_ESC
		 lGrabar := .F.
		 IF !lPregunta('DESEA ABANDONAR? Si No')
		    LOOP
		 ENDIF
		 EXIT
	    ENDCASE
**********FIN PREGUNTA DE DECISION

       ENDDO
*>>>>FIN MANTENIMIENTO DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT ARC
       IF nTipMod # 3 .AND. lGrabar

	  lInsReg := IF(nTipMod == 1,.T.,.F.)
	  IF ARC->(lRegLock(lShared,lInsReg))

	     IF lInsReg
		REPL ARC->nCodigoStr WITH ARC->(RECNO())
		REPL ARC->Field_Name WITH cCodigo
	     ENDIF

	     REPL ARC->Field_Type WITH cTipCam
	     REPL ARC->Field_Len  WITH nLenCam
	     REPL ARC->Field_Dec  WITH nDecCam

	     REPL ARC->Field_Pic WITH cPicCam
	     REPL ARC->Field_Val WITH lValCam

	     REPL ARC->cNomArcStr WITH cNomDbf
	     REPL ARC->cDocCamStr WITH cDocCam
	     REPL ARC->cTxtBrwStr WITH cTxtBrw
	     REPL ARC->cTxtGetStr WITH cTxtGet
	     REPL ARC->nLenGetStr WITH nLenGet
	     REPL ARC->cHlpGetStr WITH cHlpGet
	     REPL ARC->cTitPrnStr WITH cTitPrn

	     REPL ARC->cNomUsrStr WITH cNomUsr
	     REPL ARC->dFecUsrStr WITH DATE()
	     REPL ARC->cHorUsrStr WITH TIME()

	     ARC->(DBCOMMIT())
	  ENDIF

       IF lShared
	  ARC->(DBUNLOCK())
       ENDIF

       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(nTipCur)
*>>>>FIN GRABACION DEL CAMPO

*>>>>REFRESCAR EL BROWSE
       IF nTipMod == 2
	  nNroReg := ARC->(RECNO())
	  ARC->(DBGOTOP())
	  oBrowse:GOTOP()
	  ARC->(DBGOTO(nNroReg))
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN .T.
*>>>>FIN REFRESCAR EL BROWSE

/*************************************************************************
* TITULO..: VALIDACION DE EXISTENCIA DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:30 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Realiza la validaci¢n de existencia del C¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodStr(cCodigo)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo			            // C¢digo a Validar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF cCodigo # cSpaces('ARC','Field_Name')
	  IF lLocCodigo('Field_Name','ARC',cCodigo)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:35 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarStr(oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     oBrowse			            // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''                  // C¢digo de b£squeda
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigo := cSpaces('ARC','Field_Name')
       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '@!';
			 VALID lValNomCam(ROW(),COL()-3,@cCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigo == cSpaces('ARC','Field_Name')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT ARC
       IF lBuscar .AND. lLocCodigo('Field_Name','ARC',cCodigo)
	  nNroReg := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nNroReg
	  oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:40 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValNomCam(nNroFil,nNroCol,cCodigo)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // C¢digo a Validar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF !lLocCodigo('Field_Name','ARC',cCodigo)
	  nNroReg := nSelNomCam(nNroFil,nNroCol)
	  IF nNroReg == 0
	     cCodigo := cSpaces('ARC','Field_Name')
	  ELSE
	     GO nNroReg
	     cCodigo := ARC->Field_Name
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:45 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelNomCam(nNroFil,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nNroReg := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF ARC->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT ARC
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CODIGO
       ARC->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||ARC->Field_Name})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CODIGO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:50 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrStr(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		    cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		    aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		    lHaySql,oBrowse,lHayPrg)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       cNitEmp                              // Nit de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       PathArc                              // Path del Archivo
       fArchvo				    // Archivo de Usuarios
       aArcNtx			            // Archivos Indice
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo
       lHayPrg                              // .T. Generar Prg */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<ESTRUCTURA DEL ARCHIVO>')
       AADD(aMenus,'2<CAMPOS DE LECTURA     >')
       AADD(aMenus,'3<CAMPOS DE CONSULTA    >')
       AADD(aMenus,'4<ORDENAR EL ARCHIVO    >')

       IF lHayPrg
	   AADD(aMenus,'5<GENERAR CODIGO PRG    >')
       ENDIF

       aAyuda := {}
       AADD(aAyuda,'Imprime las Estructuras de los Archivo')
       AADD(aAyuda,'Imprime los campos que controlan la lectura')
       AADD(aAyuda,'Imprime los campos que controlan la consulta')
       AADD(aAyuda,'Imprime Otros detalles de la Estructura de los Archivo')
       AADD(aAyuda,'Ordena el Archivo')

       IF lHayPrg
	   AADD(aAyuda,'Permite Generar c¢digo fuente para crear el Archivo')
       ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrStr011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		      cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		      aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		      lHaySql,oBrowse)
	   *Impresi¢n de la Estructura del Archivo

       CASE nNroOpc == 2
	    OtrStr012(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		      cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		      aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		      lHaySql,oBrowse)
	   *Impresi¢n Campos de Consulta

       CASE nNroOpc == 3
	    OtrStr013(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		      cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		      aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		      lHaySql,oBrowse)
	   *Impresi¢n Campos de Lectura

       CASE nNroOpc == 4
	    OrdenaStr(lShared,PathArc,fArchvo,'nCodigoStr',oBrowse)
	  *ÀOrdenamiento del Archivo

       CASE nNroOpc == 5
	    OtrStr015(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		      cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		      aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		      lHaySql,oBrowse)
	   *Generaci¢n de C¢digo

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 09:55 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrStr011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		    cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		    aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		    lHaySql,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       cNitEmp                              // Nit de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       PathArc                              // Path del Archivo
       fArchvo				    // Archivo de Usuarios
       aArcNtx			            // Archivos Indice
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'CAMPOS DE LOS ARCHIVOS',;
		   '',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {12,10,04,04,04,20,06,08,60}
       aTitPrn := {'TABLA','CAMPO','TIPO','LEN','DEC',;
		   'PICTURE','VALID','MODREG','DESCRIPCION'}
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF lPrnArc
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'str'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT ARC
       GO TOP
       DO WHILE .NOT. ARC->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( ARC->(RECNO()) / ARC->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}

	    AADD(aRegPrn,ARC->cNomArcStr)
	    AADD(aRegPrn,ARC->Field_Name)
	    AADD(aRegPrn,ARC->Field_Type)
	    AADD(aRegPrn,STR(ARC->Field_Len,3))
	    AADD(aRegPrn,STR(ARC->Field_Dec,1))
	    AADD(aRegPrn,ARC->Field_Pic)
	    AADD(aRegPrn,IF(ARC->Field_Val,'SI','NO'))
	    AADD(aRegPrn,ARC->Field_Mod)
	    AADD(aRegPrn,ARC->cDocCamStr)

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ARC
	    ARC->(DBSKIP())
	    IF ARC->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION OTROS CAMPOS DEL MANTENIMIENTO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Imprime otros campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrStr012(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		    cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		    aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		    lHaySql,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       cNitEmp                              // Nit de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       PathArc                              // Path del Archivo
       fArchvo				    // Archivo de Usuarios
       aArcNtx			            // Archivos Indice
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'CAMPOS DE LECTURA DE LOS ARCHIVOS',;
		   '',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {12,10,40,04,60}
       aTitPrn := {'TABLA',;
		   'CAMPO',;
		   'TITULO DE LECTURA',;
		   'LEN',;
		   'AYUDA DE LECTURA'}
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF lPrnArc
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'str'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT ARC
       GO TOP
       DO WHILE .NOT. ARC->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( ARC->(RECNO()) / ARC->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}

	    AADD(aRegPrn,ARC->cNomArcStr)
	    AADD(aRegPrn,ARC->Field_Name)
	    AADD(aRegPrn,ARC->cTxtGetStr)
	    AADD(aRegPrn,STR(ARC->nLenGetStr,2))
	    AADD(aRegPrn,ARC->cHlpGetStr)

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ARC
	    ARC->(DBSKIP())
	    IF ARC->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION OTROS CAMPOS DEL MANTENIMIENTO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 10:05 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Imprime otros campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrStr013(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		    cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		    aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		    lHaySql,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       cNitEmp                              // Nit de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       PathArc                              // Path del Archivo
       fArchvo				    // Archivo de Usuarios
       aArcNtx			            // Archivos Indice
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'CAMPOS DE CONSULTA DE LOS ARCHIVOS',;
		   '',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {12,20,04,04,10,40,40}
       aTitPrn := {'TABLA',;
		   'DESCRIPCION TABLA',;
		   'ALIAS',;
		   'TEMP',;
		   'CAMPO',;
		   'TITULO DE BROWSE',;
		   'TITULO DE IMPRESION'}
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF lPrnArc
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'str2'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT ARC
       GO TOP
       DO WHILE .NOT. ARC->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( ARC->(RECNO()) / ARC->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}

	    AADD(aRegPrn,ARC->cNomArcStr)
	    AADD(aRegPrn,ARC->cTitArcStr)
	    AADD(aRegPrn,ARC->cNaliasStr)
	    AADD(aRegPrn,ARC->cTemCamStr)
	    AADD(aRegPrn,ARC->Field_Name)
	    AADD(aRegPrn,ARC->cTxtBrwStr)
	    AADD(aRegPrn,ARC->cTitPrnStr)

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ARC
	    ARC->(DBSKIP())
	    IF ARC->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: GENERACION DE CODIGO FUENTE                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrStr015(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		    cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		    aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		    lHaySql,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       cNitEmp                              // Nit de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       PathArc                              // Path del Archivo
       fArchvo				    // Archivo de Usuarios
       aArcNtx			            // Archivos Indice
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nHandle := 0                   // N£mero de Archivo
       LOCAL cNalias := ''                  // Alias del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO SI NO EXISTE
       fArchvo := cFileTempo('','SIMA','.Txt')
       IF !File(fArchvo)
	  IF FCREATE(fArchvo,0) == -1
	     cError('NO SE PUEDE CREAR EL ARCHIVO '+fArchvo)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO SI NO EXISTE

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>CREACION DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'ARCHIVO:'+fArchvo+' GENERANDO EL CODIGO..')
       Termometro(25)

       SELECT ARC
       ARC->(DBGOTOP())
       cNalias := ALLTRIM(ARC->cNaliasStr)
     *ÀAlias del Archivo

       ARC->(DBGOTOP())
       CreaDbf(nHandle,fArchvo,cNalias)
     *ÀCreaci¢n de la Estrucutra

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       RecuDbf(nHandle,fArchvo,cNalias)
     *ÀRecuperaci¢n de la Estructura

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       nActStr(nHandle,fArchvo,cNalias)
     *ÀActualizaci¢n de la Estructura

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       Manten(nHandle,fArchvo,cNalias)
     *ÀMantenimiento del Archivo

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       oBrwDbf(nHandle,fArchvo,cNalias)
     *ÀBrowse del Archivo

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       lManReg(nHandle,fArchvo,cNalias)
     *ÀMantenimiento del Registro

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       lValCod(nHandle,fArchvo,cNalias)
     *ÀValidaci¢n del C¢digo

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       Buscar(nHandle,fArchvo,cNalias)
     *ÀBusqueda del Registro

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       lVal(nHandle,fArchvo,cNalias)
     *ÀValidaci¢n del Campo

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       nSel(nHandle,fArchvo,cNalias)
     *ÀSelecci¢n del C¢digo

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       MenuOtr(nHandle,fArchvo,cNalias)
     *ÀMenu Otros

       ARC->(DBGOTOP())
       lSaveTxt('',nHandle,fArchvo)
       Otr011(nHandle,fArchvo,cNalias)
     *ÀImpresion de Campos
*>>>>FIN CREACION DEL ARCHIVO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF

       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO DE LA FUNCION..: ORDENAR EL ARCHIVO POR APELLIDO                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 12/99 VIE A
       Colombia, Bucaramanga        INICIO: 10:45 AM   FEB 12/99 VIE

OBJETIVOS:

1- Activa el campo para la revisi¢n de estudiantes cuando el profesor
   ingrese al sistema de Profesores.

2- Debe estar en uso el archivo de los profesores

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaStr(lShared,PathArc,fArchvo,cCamOrd,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       cCamOrd                              // Campo para Ordenar
       oBrowse			            // Browse del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>VALIDACION DEL CONTENIDO
       IF ARC->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
       CloseDbf('ARC')
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,PathArc+'\'+fArchvo,cCamOrd)
	  cError('NO SE ORDENO EL MAESTRO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'ARC',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO A ORDENAR')
	  RETURN NIL
       ENDIF
       SELECT ARC
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO