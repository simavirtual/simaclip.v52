/*                              SIMASOFT
		 SISTEMAS INSTEGRADOS MULTIUSUARIOS AVANZADOS
		     BIBLIOTECA PARA EL ARCHIVO IMPRESORAS

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:45 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfFsy(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'nIdeCodFsy','Numeric'  ,16,0}) // Ide del Registro
      *Llave Principal

       AADD(aDbfStr,{'fArchvo','Character',12,0}) // Nombre del Archivo
       AADD(aDbfStr,{'PathArc','Character',60,0}) // Path del Archivo
       AADD(aDbfStr,{'cNalias','Character',03,0}) // Alias del Archivo
       AADD(aDbfStr,{'lHayNtx','Logical'  ,01,0}) // .T. Hay archivo Indice.

       AADD(aDbfStr,{'cTituloFsy','Character',20,0}) // Descripci¢n del Archivo

       AADD(aDbfStr,{'nCodigoFsy','Numeric'  ,16,0}) // C¢digo del Registro
       AADD(aDbfStr,{'cNomUsrFsy','Character',10,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrFsy','Date'     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrFsy','Character',10,0}) // Hora del Usuario
*>>>>FIN CREACION DE LA ESTRUCTURA

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
            DBCREATE(fArchvo,aDbfStr,'DBFNTX')

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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:46 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfFsy(lShared,nModCry,PathArc,fArchvo)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError('SE BORRO EL ARCHIVO '+PathArc+'\'+fArchvo,;
              'Error Grave. TOME NOTA',;
              'Al Presionar Cualquier tecla se crea el archivo')
       Termometro(0,'CREANDO LA ESTRUCTURA')
       Termometro(100)
       CreaDbfFsy(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:47 PM   OCT 21/2004 JUE

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

FUNCTION nActStrFsy(lShared,nModCry,PathArc,cNomArc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc                              // Path del Archivo
       cNomArc                              // Nombre del Archivo */
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
       CreaDbfFsy(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
*>>>>FIN VALIDACION DE LA ESTRUCTURA

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
			 {||CreaDbfFsy(lShared,nModCry,PathArc,FileTem)})
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:48 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenFsy(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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
       fArchvo                              // Archivo de Usuarios
       aArcNtx                              // Archivos Indice
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       lHayPrg                              // .T. Generar Prg */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE 'inkey.ch'                  // Declaraci¢n de teclas

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

       lHayPrg := IF(lHayPrg==NIL,.F.,lHayPrg)
*>>>>FIN PARAMETROS POR DEFECTO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwDbfFsy(lShared,cNomUsr,cAnoUsr,03,00,22,79,;
				     lModReg,lDelReg,lInsReg,lHaySql)

       SETKEY(K_F2,{||lManRegFsy(lShared,cNomUsr,3)})
     *ÀConsulta

       IF lModReg
	  SETKEY(K_F4,{||lManRegFsy(lShared,cNomUsr,2,oBrowse,;
					    ARC->fArchvo)})
       ENDIF
     *ÀActualizar

       SETKEY(K_F5,{||BuscarFsy(oBrowse)})

       SETKEY(K_F9,{||MenuOtrFsy(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:49 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwDbfFsy(lShared,cNomUsr,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,;
		    lModReg,lDelReg,lInsReg,lHaySql)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       nFilSup                              // Fila Superior
       nColSup                              // Columna Superior
       nFilInf                              // Fila Inferior
       nColInf                              // Columna Inferior
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registros
       lHaySql                              // .T. Exportar a Sql */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       cTitSup := '<< ARCHIVOS DEL SISTEMA >>'
       cTitInf := '<F2>Consultar <F5>Buscar'+;
                   IF(lModReg,' <F4>Actualizar','')+' <F9>Otros'+;
                   IF(lDelReg,' <DEL>Borrar','')+;
                   IF(lInsReg,' <INS>Incluir','')

       IF lInsReg
	  oBrowse:Cargo := {cTitSup,cTitInf,{||lManRegFsy(lShared,cNomUsr)}}
       ELSE
          oBrowse:Cargo := {cTitSup,cTitInf}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ARC
       oColumn := TBCOLUMNNEW('ARCHIVO',{||ARC->fArchvo   })
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','fArchvo   '},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PATH',{||ARC->PathArc   })
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','PathArc   '},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TITULO',{||ARC->cTituloFsy})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cTituloFsy'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ALIAS',{||ARC->cNalias   })
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','cNalias   '},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('INDICE',{||ARC->lHayNtx   })
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ARC'},;
			 {'FIELD','lHayNtx   '},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL REGISTRO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:50 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Permite inclusi¢n,modificaci¢n y consulta del registro

2- Puede invocarse en la lectura a trav‚s de la clausula VALID

2- Returna .T.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lManRegFsy(lShared,cNomUsr,nTipMod,oBrowse,cCodigo,nNroOpc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       nTipMod                              // Tipo de Modificaci¢n. 1 =>Insertar, 2=>Modificar 3=>Consultar
       cCodigo                              // C¢digo a Ingresar, Actualizar
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

       LOCAL Path := ''                     // Path del Archivo
       LOCAL cNal := ''                     // Alias del Archivo
       LOCAL lHay := .F.                    // .T. Hay archivo Indice.
       LOCAL cTitulo := ''                  // Descripci¢n del Archivo

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENU
       nTipMod := IF(nTipMod==NIL,1,nTipMod)

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := 1
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
                  cCodigo := ARC->fArchvo
               ENDIF

	       Path    := ARC->PathArc
	       cNal    := ARC->cNalias
	       lHay    := ARC->lHayNtx
	       cTitulo := ARC->cTituloFsy
            ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL CAMPO
	    nNroFil := nFilIni
	    cTxtTem := 'ARCHIVO:'

            IF nTipMod == 2 .OR. nTipMod == 3 .OR. !EMPTY(cCodigo)
               @ nNroFil,nNroCol SAY cTxtTem
               @ nNroFil,nNroCol+LEN(cTxtTem)+1 SAY cCodigo COLOR('I')
            ELSE
               @ nNroFil,nNroCol SAY cTxtTem;
                                 GET cCodigo PICT '@X';
                                 VALID !EMPTY(cCodigo) .AND.;
				       !lValCodFsy(cCodigo)
            ENDIF
**********FIN LECTURA DEL CAMPO

**********LECTURA DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'PATH   :'

            IF nTipMod == 3
	       @ nNroFil+1,nColTem SAY cTxtTem
	       @ nNroFil+1,nColTem+LEN(cTxtTem)+1 SAY Path COLOR('I')
	    ELSE
	       @ nNroFil+1,nColTem SAY cTxtTem;
				    GET Path PICT '@!';
				    VALID !EMPTY(Path);
				    WHEN {||HelpRead('PATH')}
	    ENDIF
**********FIN LECTURA DEL CAMPO

**********LECTURA DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'TITULO :'

            IF nTipMod == 3
	       @ nNroFil+2,nColTem SAY cTxtTem
	       @ nNroFil+2,nColTem+LEN(cTxtTem)+1 SAY cTitulo COLOR('I')
	    ELSE
	       @ nNroFil+2,nColTem SAY cTxtTem;
				    GET cTitulo PICT '@!';
				    VALID !EMPTY(cTitulo);
				    WHEN {||HelpRead('INGRESE EL TITULO DEL ARCHIVO')}
            ENDIF
**********FIN LECTURA DEL CAMPO

**********LECTURA DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'ALIAS  :'

            IF nTipMod == 3
	       @ nNroFil+3,nColTem SAY cTxtTem
	       @ nNroFil+3,nColTem+LEN(cTxtTem)+1 SAY cNal COLOR('I')
	    ELSE
	       @ nNroFil+3,nColTem SAY cTxtTem;
				    GET cNal PICT '@!';
				    VALID !EMPTY(cNal);
				    WHEN {||HelpRead('POR FAVOR INGRESE EL ALIAS DEL ARCHIVO')}
	    ENDIF
**********FIN LECTURA DEL CAMPO

**********LECTURA DEL CAMPO
	    nColTem := nNroCol
	    cTxtTem := 'INDICE :'

            IF nTipMod == 3
	       @ nNroFil+4,nColTem SAY cTxtTem
	       @ nNroFil+4,nColTem+LEN(cTxtTem)+1 SAY lHay COLOR('I')
	    ELSE
	       @ nNroFil+4,nColTem SAY cTxtTem;
				    GET lHay PICT '@!';
				    WHEN {||HelpRead('INDICE')}
	    ENDIF
**********FIN LECTURA DEL CAMPO

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
		REPL ARC->nCodigoFsy WITH ARC->(RECNO())
		REPL ARC->fArchvo WITH cCodigo
             ENDIF

	     REPL ARC->PathArc WITH Path
             REPL ARC->cNalias WITH cNal
             REPL ARC->lHayNtx WITH lHay

	     REPL ARC->cTituloFsy WITH cTitulo

	     REPL ARC->cNomUsrFsy WITH cNomUsr
	     REPL ARC->dFecUsrFsy WITH DATE()
	     REPL ARC->cHorUsrFsy WITH TIME()
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:51 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Realiza la validaci¢n de existencia del C¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodFsy(cCodigo)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo a Validar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF cCodigo # cSpaces('ARC','fArchvo')
          IF lLocCodigo('fArchvo','ARC',cCodigo)
             cError('ESTE CODIGO YA EXISTE')
             lHayErr := .T.
          ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:52 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarFsy(oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     oBrowse                              // Browse del Archivo */
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
       cCodigo := cSpaces('ARC','fArchvo')
       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '@!';
			 VALID lValArc(ROW(),COL()-3,@cCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigo == cSpaces('ARC','fArchvo')
          cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
                 'ADVERTENCIA')
          lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT ARC
       IF lBuscar .AND. lLocCodigo('fArchvo','ARC',cCodigo)
          nNroReg := ARC->(RECNO())
          ARC->(DBGOTOP())
          oBrowse:GOTOP()
          ARC->(DBGOTO(nNroReg))
          oBrowse:FORCESTABLE()
       ELSE
          oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:53 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValArc(nNroFil,nNroCol,cCodigo)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo                              // C¢digo a Validar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF !lLocCodigo('fArchvo','ARC',cCodigo)
          nNroReg := nSelArc(nNroFil,nNroCol)
          IF nNroReg == 0
             cCodigo := cSpaces('ARC','fArchvo')
          ELSE
             ARC->(DBGOTO(nNroReg))
             cCodigo := ARC->fArchvo
          ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:54 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelArc(nNroFil,nNroCol)

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
       LOCAL nNroReg := 0                   // N£mero del Registro
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
			     {||ARC->fArchvo})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CODIGO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:55 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrFsy(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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
       fArchvo                              // Archivo de Usuarios
       aArcNtx                              // Archivos Indice
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

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<ARCHIVOS DEL SISTEMA>')
       AADD(aMenus,'2<ENTIDADES PARA WEBML>')

       IF lHayPrg
	  AADD(aMenus,'3<GENERAR CODIGO PRG  >')
       ENDIF

       aAyuda := {}
       AADD(aAyuda,'Imprime los Archivos del Sistema')
       AADD(aAyuda,'Genera la Estructura de la Tablas para WebML')

       IF lHayPrg
	   AADD(aAyuda,'Permite Generar c¢digo fuente para crear los Archivos')
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
	    OtrFsy011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		      cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
                      aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		      lHaySql,oBrowse)
	   *Impresi¢n de los campos del Archivo

       CASE nNroOpc == 2
	    OtrFsy012(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		      cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
                      aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		      lHaySql,oBrowse)
	   *Entidades para WebMl

       CASE nNroOpc == 3
	    OtrFsy013(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		      cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
                      aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		      lHaySql,oBrowse)
	   *Generaci¢n c¢digo fuente

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 04:56 PM   OCT 21/2004 JUE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrFsy011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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
       fArchvo                              // Archivo de Usuarios
       aArcNtx                              // Archivos Indice
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
		   'ARCHIVOS DEL SISTEMA',;
                   '',;
                   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,12)
       AADD(aTitPrn,'ARCHIVO')

       AADD(aNroCol,60)
       AADD(aTitPrn,'PATH')

       AADD(aNroCol,20)
       AADD(aTitPrn,'TITULO')

       AADD(aNroCol,06)
       AADD(aTitPrn,'ALIAS')

       AADD(aNroCol,06)
       AADD(aTitPrn,'INDICE')

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
	  FilePrn := 'Fsy'
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
       ARC->(DBGOTOP())
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
            AADD(aRegPrn,ARC->fArchvo)
	    AADD(aRegPrn,ARC->PathArc)
	    AADD(aRegPrn,ARC->cTituloFsy)
            AADD(aRegPrn,ARC->cNalias)
	    AADD(aRegPrn,IF(ARC->lHayNtx,'SI','NO'))

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
* TITULO..: ENTIDADES PARA WEBML                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 25/2005 VIE A
       Colombia, Bucaramanga        INICIO: 06:15 PM   NOV 25/2005 VIE

OBJETIVOS:

1- Genera parte del archivo xml con las estructuras de la tablas
   para anexarlo al archivo del proyecto de WebRation

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrFsy012(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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
       fArchvo                              // Archivo de Usuarios
       aArcNtx                              // Archivos Indice
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cNroTbl := ''                  // N£mero de Tabla
       LOCAL nHandle := 0                   // N£mero de Archivo
       LOCAL FileTem := ''                  // Nombre del Archivo
       LOCAL FileTbl := ''                  // Nombre de la tabla
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL cLinTxt := ''                  // L¡nea de Texto
       LOCAL nNroAtt := 0                  // N£mero de Atributos

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TABLA DE TABLAS
       cNroTbl := '1'
       FileTbl := 'tablas'

       aStrDbf := {'1'}
       CreaDbfFsy(,,,,@aStrDbf)

       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)
*>>>>TABLA DE TABLAS

*>>>>TABLA DE CAMPOS
       cNroTbl := '2'
       FileTbl := 'campos'

       aStrDbf := {'1'}
       CreaDbfStr(,,,,@aStrDbf)

       EntidadWeb(aStrDbf,FileTbl,cNroTbl,@aLinTxt,@nNroAtt)
*>>>>FIN TABLA DE CAMPOS

*>>>>UBICACION DE LA TABLAS
       AADD(aLinTxt,'')
       FOR i := 1 TO 2
	   cLinTxt := SPACE(08)+;
		  '<graphmetadata:Node element="ent'+ALLTRIM(STR(i,4))+'" '+;
				     'id="ent'+ALLTRIM(STR(i,4))+;
				     '_go" x="37.541733" y="166.31686"/>'
	   AADD(aLinTxt,cLinTxt)
       ENDFOR
*>>>>FIN UBICACION DE LA TABLAS

*>>>>CREACION DEL ARCHIVO DE ENTIDA DE WEBML
       FileTem := 'FileWww\Entidad.xml'
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
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: GENERACION DE CODIGO FUENTE                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 12:15 AM   OCT 21/2004 JUE

OBJETIVOS:

1- Genera el c¢digo prg para crear todos los archivos.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrFsy013(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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
       fArchvo                              // Archivo de Usuarios
       aArcNtx                              // Archivos Indice
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
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL fNtxArc := ''                  // Archivo Indice
       LOCAL aUseDbf := {}                  // Archivos en Uso

       LOCAL FileStr := ''                  // Estructuras del Sistema

       LOCAL nAvance := 0                   // Avance de registros
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       CloseDbf('ARC')
       fNtxArc := IF(aArcNtx==NIL,NIL,PathArc+'\'+aArcNtx[1])

       FileStr := 'FILESTR.DAT'

       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathArc+'\'+fArchvo,'FSY',fNtxArc,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathArc+'\'+FileStr,'STR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
          cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('FSY')
	  CloseDbf('STR')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'GENERANDO CODIGO')

       SELECT FSY
       FSY->(DBGOTOP())
       DO WHILE .NOT. FSY->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( FSY->(RECNO()) / FSY->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********AREAS DE TRABAJO
	    CreaDbfStr(lShared,nModCry,PathArc,'FilePrg.Dat')

	    aUseDbf := {}
	    AADD(aUseDbf,{.T.,PathArc+'\'+'FilePrg.Dat','ARC',NIL,.F.,nModCry})
**********FIN AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbfs(aUseDbf)
	       cError('ABRIENDO EL ARCHIVO')
	       CloseDbf('ARC')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO DE LAS ESTRUCTURAS
	    SELECT STR
	    STR->(DBGOTOP())
	    DO WHILE .NOT. STR->(EOF())

*==============SELECION DEL ARCHIVO
		 IF STR->cNomDbfStr # FSY->fArchvo
		    STR->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN SELECION DEL ARCHIVO

*==============GRABACION DEL REGISTRO
		 IF ARC->(lRegLock(lShared,.T.))

		    REPL ARC->cNomDbfStr WITH FSY->fArchvo
		    REPL ARC->Field_Name WITH STR->Field_Name
		    REPL ARC->Field_Type WITH STR->Field_Type
		    REPL ARC->Field_Len  WITH STR->Field_Len
		    REPL ARC->Field_Dec  WITH STR->Field_Dec

		    REPL ARC->cDocCamStr WITH STR->cDocCamStr
		    REPL ARC->cTxtBrwStr WITH STR->cTxtBrwStr
		    REPL ARC->cTxtGetStr WITH STR->cTxtGetStr
		    REPL ARC->cHlpGetStr WITH STR->cHlpGetStr
		    REPL ARC->cTitPrnStr WITH STR->cTitPrnStr

		    REPL ARC->nCodigoStr WITH STR->nCodigoStr
		    REPL ARC->cNomUsrStr WITH STR->cNomUsrStr
		    REPL ARC->dFecUsrStr WITH STR->dFecUsrStr
		    REPL ARC->cHorUsrStr WITH STR->cHorUsrStr

		    ARC->(DBCOMMIT())
		 ENDIF

		 IF lShared
		    ARC->(DBUNLOCK())
		 ENDIF
*==============FIN GRABACION DEL REGISTRO

*==============GENERACION DEL CODIGO
		 OtrStr012(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
			   cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
			   PathArc,'FilePrg.Dat',aArcNtx,lPrnArc,;
			   cOpcPrn,lModReg,lDelReg,lInsReg,lHaySql,;
			   oBrowse)
*==============FIN GENERACION DEL CODIGO

	       STR->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO DE LAS ESTRUCTURAS

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT FSY
	    FSY->(DBSKIP())
	    IF FSY->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

	  CloseDbf('ARC')

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>AREAS DE TRABAJO
       CloseDbf('FSY')
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
       SELECT ARC
       ARC->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO
