/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfIso(lShared,nModCry,PathArc,fArchvo,aStrDbf)

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
       AADD(aDbfStr,{'nIdeCodIso','Numeric'  ,16,0}) // Ide del Registro
      *Llave Principal

       AADD(aDbfStr,{'nNumeroIso','Numeric',4,0}) // N£mero Iso del Documento
       AADD(aDbfStr,{'cCodSuiIso','Character',4,0}) // C¢digo del Sistema
       AADD(aDbfStr,{'nNroOrdIso','Numeric',4,0}) // N£mero de orden
       AADD(aDbfStr,{'cCodInfIso','Character',8,0}) // C¢digo del Informe
       AADD(aDbfStr,{'nCodPrnIso','Numeric',4,0}) // C¢digo de la Impresora
       AADD(aDbfStr,{'dFecAprIso','Date',8,0}) // Fecha de Aprobaci¢n del Iso
       AADD(aDbfStr,{'nMargSIIso','Numeric',3,0}) // Margen Superior Izquierdo
       AADD(aDbfStr,{'nMargSDIso','Numeric',3,0}) // Margen Superior Derecho
       AADD(aDbfStr,{'nMargIIIso','Numeric',3,0}) // Margen Inferior Izquierdo
       AADD(aDbfStr,{'nMargIDIso','Numeric',3,0}) // Margen Inferior Derecho
       AADD(aDbfStr,{'nMarg1IIso','Numeric',3,0}) // Margen Uno Izquierdo
       AADD(aDbfStr,{'nMarg1DIso','Numeric',3,0}) // Margen Uno Derecho
       AADD(aDbfStr,{'nMarg2IIso','Numeric',3,0}) // Margen Dos Izquierdo
       AADD(aDbfStr,{'nMarg2DIso','Numeric',3,0}) // Margen Dos Derecho
       AADD(aDbfStr,{'nNroDocIso','Numeric',2,0}) // N£mero del Documento
       AADD(aDbfStr,{'cTituloIso','Character',60,0}) // T¡tulo por defecto del Documento
       AADD(aDbfStr,{'cOpcSysIso','Character',60,0}) // Opci¢n del Sistema del Informe
       AADD(aDbfStr,{'cCodigoIso','Character',60,0}) // C¢digo Iso del Documento
       AADD(aDbfStr,{'cTitUnoIso','Character',60,0}) // T¡tulo Uno Iso del Documento
       AADD(aDbfStr,{'cTitDosIso','Character',60,0}) // T¡tulo Dos Iso del Documento
       AADD(aDbfStr,{'cTitTreIso','Character',60,0}) // T¡tulo Tres Iso del Documento
       AADD(aDbfStr,{'cPieUnoIso','Character',256,0}) // Pie de P gina Uno del Documento
       AADD(aDbfStr,{'cPieDosIso','Character',256,0}) // Pie de P gina Dos del Documento
       AADD(aDbfStr,{'cPieTreIso','Character',256,0}) // Pie de P gina Tres del Documento
       AADD(aDbfStr,{'cObsUnoIso','Character',256,0}) // Observaci¢n Uno
       AADD(aDbfStr,{'cObsDosIso','Character',256,0}) // Observaci¢n Dos
       AADD(aDbfStr,{'cObsTreIso','Character',256,0}) // Observaci¢n Tres

       AADD(aDbfStr,{'cNomUsrIso','Character',10,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrIso','Date'     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrIso','Character',10,0}) // Hora del Usuario
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfIso(lShared,nModCry,PathArc,fArchvo)

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
       CreaDbfIso(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

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

FUNCTION nActStrIso(lShared,nModCry,PathArc,cNomArc)

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
       CreaDbfIso(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
                         {||CreaDbfIso(lShared,nModCry,PathArc,FileTem)})
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenIso(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		   cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
		   cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql)

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
       aArchvo                              // Archivos en Uso
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       nCodPrn                              // C¢digo de Impresi¢n 
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE 'inkey.ch'                  // Declaraci¢n de teclas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL lHayPrn := .F.                 // .T. Hay Archivo de Impresi¢n
       LOCAL aUseDbf := {}                  // Archivos en Uso
       LOCAL fArchvo := ''                  // Nombre del Archivo
       LOCAL fNtxArc := ''                  // Archivo Indice
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL oBrowse := NIL                 // Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       FOR i := 1 TO LEN(aArchvo)
           fArchvo := aArchvo[i,1]
           fNtxArc := aArchvo[i,2]
           cNalias := aArchvo[i,3]
           AADD(aUseDbf,{.T.,fArchvo,cNalias,fNtxArc,lShared,nModCry})
           IF cNalias == 'PRN'
              lHayPrn := .T.
           ENDIF
       ENDFOR
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
          cError('ABRIENDO EL ARCHIVO')
          CloseAll()
          RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DE LA IMPRESORA
       IF lHayPrn
          IF !lLocCodigo('nCodigoPrn','PRN',nCodPrn)
             cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
             CloseAll()
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>PARAMETROS POR DEFECTO
       lModReg := IF(EMPTY(lModReg),.F.,lModReg)
       lModReg := IF(lModReg .AND. ISO->(RECCOUNT())==0,.F.,lModReg)

       lDelReg := IF(lDelReg==NIL,.F.,lDelReg)

       lInsReg := IF(lInsReg==NIL,.F.,lInsReg)

       lHaySql := IF(lHaySql==NIL,.F.,lHaySql)
*>>>>FIN PARAMETROS POR DEFECTO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwDbfIso(lShared,cNomUsr,cAnoUsr,03,00,22,79,;
                             lModReg,lDelReg,lInsReg,lHaySql)

       SETKEY(K_F2,{||lManRegIso(lShared,cNomUsr,3,oBrowse)})
     *ÀConsulta

       IF lModReg
          SETKEY(K_F4,{||lManRegIso(lShared,cNomUsr,2,oBrowse,;
                                    ISO->nNumeroIso)})
       ENDIF
     *ÀActualizar

       SETKEY(K_F5,{||BuscarIso(oBrowse)})

       SETKEY(K_F9,{||MenuOtrIso(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
                                 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
                                 aArchvo,lPrnArc,cOpcPrn,nCodPrn,lModReg,;
                                 lDelReg,lInsReg,lHaySql,oBrowse)})

       ISO->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F2,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwDbfIso(lShared,cNomUsr,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,;
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

       cTitSup := '<< DOCUMENTOS ISO >>'
       cTitInf := '<F2>Consultar <F5>Buscar'+;
                   IF(lModReg,' <F4>Actualizar','')+' <F9>Otros'+;
                   IF(lDelReg,' <DEL>Borrar','')+;
                   IF(lInsReg,' <INS>Incluir','')

       IF lInsReg
          oBrowse:Cargo := {cTitSup,cTitInf,{||lManRegIso(lShared,cNomUsr)}}
       ELSE
          oBrowse:Cargo := {cTitSup,cTitInf}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ISO
       oColumn := TBCOLUMNNEW('NUMERO',{||ISO->nNumeroIso})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ISO'},;
			 {'FIELD','nNumeroIso'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CODIGO;SISTEMA',{||ISO->cCodSuiIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cCodSuiIso'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ORDEN',{||ISO->nNroOrdIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nNroOrdIso'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CODIGO;INFORME',{||ISO->cCodInfIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cCodInfIso'},{'PICTURE','XXXXXXXX'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CODIGO;IMPRESORA',{||ISO->nCodPrnIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nCodPrnIso'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('FECHA;APROBACION',{||ISO->dFecAprIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','dFecAprIso'},{'PICTURE','@!D'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN SUPERIOR;IZQUIERDO',{||ISO->nMargSIIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nMargSIIso'},{'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN SUPERIOR;DERECHO',{||ISO->nMargSDIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nMargSDIso'},{'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN INFERIOR;IZQUIERDO',{||ISO->nMargIIIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nMargIIIso'},{'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN INFERIOR;DERECHO',{||ISO->nMargIDIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nMargIDIso'},{'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN UNO;IZQUIERDO',{||ISO->nMarg1IIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nMarg1IIso'},{'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN UNO;DERECHO',{||ISO->nMarg1DIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nMarg1DIso'},{'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN DOS;IZQUIERDO',{||ISO->nMarg2IIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nMarg2IIso'},{'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN DOS;DERECHO',{||ISO->nMarg2DIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nMarg2DIso'},{'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NUMERO;DOCUMENTO',{||ISO->nNroDocIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','nNroDocIso'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TITULO;POR DEFECTO',{||ISO->cTituloIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cTituloIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('OPCION DEL SISTEMA',{||ISO->cOpcSysIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cOpcSysIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CODIGO;DE LA ISO',{||ISO->cCodigoIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cCodigoIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TITULO UNO',{||ISO->cTitUnoIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cTitUnoIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TITULO DOS',{||ISO->cTitDosIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cTitDosIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TITULO TRES',{||ISO->cTitTreIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cTitTreIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PIE DE PAGINA UNO',{||ISO->cPieUnoIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cPieUnoIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PIE DE PAGINA DOS',{||ISO->cPieDosIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cPieDosIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PIE DE PAGINA TRES',{||ISO->cPieTreIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cPieTreIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('OBSERVACION UNO',{||ISO->cObsUnoIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cObsUnoIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('OBSERVACION DOS',{||ISO->cObsDosIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cObsDosIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('OBSERVACION TRES',{||ISO->cObsTreIso})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ISO'},;
			 {'FIELD','cObsTreIso'},{'PICTURE','@!S42'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||ISO->cNomUsrIso})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(ISO->dFecUsrIso)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(ISO->cHorUsrIso)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO',{||ISO->nIdeCodIso})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('No.',{||ISO->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL REGISTRO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Permite inclusi¢n,modificaci¢n y consulta del registro

2- Puede invocarse en la lectura a trav‚s de la clausula VALID

2- Returna .T.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lManRegIso(lShared,cNomUsr,nTipMod,oBrowse,nNumero,nNroOpc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       nTipMod                              // Tipo de Modificaci¢n. 1 =>Insertar, 2=>Modificar 3=>Consultar
       xCodigo                              // C¢digo a Ingresar, Actualizar
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

       LOCAL cCodSuiTis := ''               // C¢digo del Sistema                                          
       LOCAL nNroOrdTis := 0                // N£mero de orden                                             
       LOCAL cCodInfTis := ''               // C¢digo del Informe                                          
       LOCAL nCodPrnTis := 0                // C¢digo de la Impresora                                      
       LOCAL dFecAprTis := CTOD('00/00/00')   // Fecha de Aprobaci¢n del Iso                                 
       LOCAL nMargSITis := 0                // Margen Superior Izquierdo                                   
       LOCAL nMargSDTis := 0                // Margen Superior Derecho                                     
       LOCAL nMargIITis := 0                // Margen Inferior Izquierdo                                   
       LOCAL nMargIDTis := 0                // Margen Inferior Derecho                                     
       LOCAL nMarg1ITis := 0                // Margen Uno Izquierdo                                        
       LOCAL nMarg1DTis := 0                // Margen Uno Derecho                                          
       LOCAL nMarg2ITis := 0                // Margen Dos Izquierdo                                        
       LOCAL nMarg2DTis := 0                // Margen Dos Derecho                                          
       LOCAL nNroDocTis := 0                // N£mero del Documento                                        
       LOCAL cTituloTis := ''               // T¡tulo por defecto del Documento                            
       LOCAL cOpcSysTis := ''               // Opci¢n del Sistema del Informe                              
       LOCAL cCodigoTis := ''               // C¢digo Iso del Documento                                    
       LOCAL cTitUnoTis := ''               // T¡tulo Uno Iso del Documento                                
       LOCAL cTitDosTis := ''               // T¡tulo Dos Iso del Documento                                
       LOCAL cTitTreTis := ''               // T¡tulo Tres Iso del Documento                               
       LOCAL cPieUnoTis := ''               // Pie de P gina Uno del Documento                             
       LOCAL cPieDosTis := ''               // Pie de P gina Dos del Documento                             
       LOCAL cPieTreTis := ''               // Pie de P gina Tres del Documento                            
       LOCAL cObsUnoTis := ''               // Observaci¢n Uno                                             
       LOCAL cObsDosTis := ''               // Observaci¢n Dos                                             
       LOCAL cObsTreTis := ''               // Observaci¢n Tres                                            

       LOCAL GetList := {}                 // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENU
       nTipMod := IF(nTipMod==NIL,1,nTipMod)

       AADD(aMenus,'1<INFORMACION BASICA>')

       AADD(aAyuda,IF(nTipMod==3,'Consulta','Actualiza')+' '+;
                   'la Informaci¢n B sica.')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := IF(nNroOpc==NIL,1,nNroOpc)
       IF EMPTY(nNroOpc)

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
            cTxtTem := 'DOCUMENTOS ISO .INCLUIR. '+aMenus[nNroOpc]
            ISO->(DBGOBOTTOM())
            ISO->(DBSKIP())
            nTipCur := SETCURSOR(1)

       CASE nTipMod == 2
            cTxtTem := 'DOCUMENTOS ISO .ACTUALIZAR. '+aMenus[nNroOpc]
            nTipCur := SETCURSOR(1)

       CASE nTipMod == 3
            cTxtTem := 'DOCUMENTOS ISO. CONSUTA. '+aMenus[nNroOpc]
       ENDCASE
       nFilIni := nMarco(03,cTxtTem,22,'°')
*>>>>FIN MARCO DEL MANTENIMIENTO

*>>>>MANTENIMIENTO DEL REGISTRO
       SELECT ISO
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
            IF lGrabar

               IF EMPTY(nNumero)
                  nNumero := ISO->nNumeroIso
               ENDIF

               cCodSuiTis := ISO->cCodSuiIso
               nNroOrdTis := ISO->nNroOrdIso
               cCodInfTis := ISO->cCodInfIso
               nCodPrnTis := ISO->nCodPrnIso
               dFecAprTis := ISO->dFecAprIso
               nMargSITis := ISO->nMargSIIso
               nMargSDTis := ISO->nMargSDIso
               nMargIITis := ISO->nMargIIIso
               nMargIDTis := ISO->nMargIDIso
               nMarg1ITis := ISO->nMarg1IIso
               nMarg1DTis := ISO->nMarg1DIso
               nMarg2ITis := ISO->nMarg2IIso
               nMarg2DTis := ISO->nMarg2DIso
               nNroDocTis := ISO->nNroDocIso
               cTituloTis := ISO->cTituloIso
               cOpcSysTis := ISO->cOpcSysIso
               cCodigoTis := ISO->cCodigoIso
               cTitUnoTis := ISO->cTitUnoIso
               cTitDosTis := ISO->cTitDosIso
               cTitTreTis := ISO->cTitTreIso
               cPieUnoTis := ISO->cPieUnoIso
               cPieDosTis := ISO->cPieDosIso
               cPieTreTis := ISO->cPieTreIso
               cObsUnoTis := ISO->cObsUnoIso
               cObsDosTis := ISO->cObsDosIso
               cObsTreTis := ISO->cObsTreIso
            ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil := nFilIni
               cTxtTem := 'NUMERO DEL DOCUMENTO    :'

               IF nTipMod == 2 .OR. nTipMod == 3 .OR. !EMPTY(nNumero)
                  @ nNroFil,nNroCol SAY cTxtTem
                  @ nNroFil,nNroCol+LEN(cTxtTem)+1 SAY nNumero COLOR('I')
               ELSE
                  @ nNroFil,nNroCol SAY cTxtTem;
                                    GET nNumero PICT '9999';
                                    VALID !EMPTY(nNumero) .AND.;
                                          !lValCodIso(nNumero)
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'CODIGO SISTEMA          :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cCodSuiTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cCodSuiTis PICT '9999';
                                    VALID !EMPTY(cCodSuiTis);
                                    WHEN {||HelpRead('FAVOR INGRESE EL CODIGO SISTEMA')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'NUMERO DE ORDEN         :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nNroOrdTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nNroOrdTis PICT '9999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL NUMERO DE ORDEN')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'CODIGO INFORME          :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cCodInfTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cCodInfTis PICT 'XXXXXXXX';
                                    VALID !EMPTY(cCodInfTis);
                                    WHEN {||HelpRead('FAVOR INGRESE EL CODIGO DEL INFORME')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'CODIGO IMPRESORA        :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nCodPrnTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nCodPrnTis PICT '9999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL CODIGO DE LA IMPRESORA')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'FECHA APROBACION        :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY dFecAprTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET dFecAprTis PICT '@!D';
                                    WHEN {||HelpRead('FAVOR INGRESE LA FECHA DE APROBACION')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'MARGEN SUPERIOR IZQUIERD:'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nMargSITis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nMargSITis PICT '999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL MARGEN SUPERIOR IZQUIERDO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'MARGEN SUPERIOR DERECHO :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nMargSDTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nMargSDTis PICT '999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL MARGEN SUPERIOR DERECHO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'MARGEN INFERIOR IZQUIERD:'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nMargIITis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nMargIITis PICT '999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL MARGEN INFERIOR IZQUIERDO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'MARGEN INFERIOR DERECHO :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nMargIDTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nMargIDTis PICT '999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL MARGEN INFERIOR DERECHO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'MARGEN UNO IZQUIERDO    :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nMarg1ITis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nMarg1ITis PICT '999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL MARGEN UNO IZQUIERDO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'MARGEN UNO DERECHO      :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nMarg1DTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nMarg1DTis PICT '999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL MARGEN UNO DERECHO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'MARGEN DOS IZQUIERDO    :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nMarg2ITis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nMarg2ITis PICT '999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL MARGEN DOS IZQUIERDO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'MARGEN DOS DERECHO      :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nMarg2DTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nMarg2DTis PICT '999';
                                    WHEN {||HelpRead('FAVOR INGRESE EL MARGEN DOS DERECHO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'NUMERO DOCUMENTO        :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nNroDocTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET nNroDocTis PICT '99';
                                    WHEN {||HelpRead('FAVOR INGRESE EL NUMERO DEL DOCUMENTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'TITULO POR DEFECTO      :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTituloTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cTituloTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE EL TITULO POR DEFECTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'OPCION DEL SISTEMA      :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cOpcSysTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cOpcSysTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE LA OPCION DEL INFORME')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'CODIGO ISO DEL DOCUMENTO:'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cCodigoTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cCodigoTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE EL CODIGO ISO DEL DOCUMENTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'TITULO UNO              :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTitUnoTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cTitUnoTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE EL TITULO UNO DEL DOCUMENTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'TITULO DOS              :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTitDosTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cTitDosTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE EL TITULO DOS DEL DOCUMENTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'TITULO TRES             :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTitTreTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cTitTreTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE EL TITULO UNO ISO DEL DOCUMENTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'PIE DE PAGINA UNO       :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cPieUnoTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cPieUnoTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE EL PIE DE PAGINA UNO DEL DOCUMENTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'PIE DE PAGINA DOS       :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cPieDosTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cPieDosTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE EL PIE DE PAGINA DOS DEL DOCUMENTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'PIE DE PAGINA TRES      :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cPieTreTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cPieTreTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE EL PIE DE PAGINA UNO DEL DOCUMENTO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'OBSERVACION UNO         :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cObsUnoTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cObsUnoTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE LA OBSERVACION UNO')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'OBSERVACION DOS         :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cObsDosTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cObsDosTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE LA OBSERVACION DOS')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

               nNroFil++
               nColTem := nNroCol
               cTxtTem := 'OBSERVACION TRES        :'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cObsTreTis COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cObsTreTis PICT '@!S42';
                                    WHEN {||HelpRead('FAVOR INGRESE LA OBSERVACION TRES')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

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
       SELECT ISO
       IF nTipMod # 3 .AND. lGrabar

          lInsReg := IF(nTipMod == 1,.T.,.F.)
          IF ISO->(lRegLock(lShared,lInsReg))

             IF lInsReg
                REPL ISO->nIdeCodIso WITH ISO->(RECNO())
                REPL ISO->nNumeroIso WITH nNumero
             ENDIF

             REPL ISO->cCodSuiIso WITH cCodSuiTis
             REPL ISO->nNroOrdIso WITH nNroOrdTis
             REPL ISO->cCodInfIso WITH cCodInfTis
             REPL ISO->nCodPrnIso WITH nCodPrnTis
             REPL ISO->dFecAprIso WITH dFecAprTis
             REPL ISO->nMargSIIso WITH nMargSITis
             REPL ISO->nMargSDIso WITH nMargSDTis
             REPL ISO->nMargIIIso WITH nMargIITis
             REPL ISO->nMargIDIso WITH nMargIDTis
             REPL ISO->nMarg1IIso WITH nMarg1ITis
             REPL ISO->nMarg1DIso WITH nMarg1DTis
             REPL ISO->nMarg2IIso WITH nMarg2ITis
             REPL ISO->nMarg2DIso WITH nMarg2DTis
             REPL ISO->nNroDocIso WITH nNroDocTis
             REPL ISO->cTituloIso WITH cTituloTis
             REPL ISO->cOpcSysIso WITH cOpcSysTis
             REPL ISO->cCodigoIso WITH cCodigoTis
             REPL ISO->cTitUnoIso WITH cTitUnoTis
             REPL ISO->cTitDosIso WITH cTitDosTis
             REPL ISO->cTitTreIso WITH cTitTreTis
             REPL ISO->cPieUnoIso WITH cPieUnoTis
             REPL ISO->cPieDosIso WITH cPieDosTis
             REPL ISO->cPieTreIso WITH cPieTreTis
             REPL ISO->cObsUnoIso WITH cObsUnoTis
             REPL ISO->cObsDosIso WITH cObsDosTis
             REPL ISO->cObsTreIso WITH cObsTreTis

             REPL ISO->cNomUsrIso WITH cNomUsr
             REPL ISO->dFecUsrIso WITH DATE()
             REPL ISO->cHorUsrIso WITH TIME()
             ISO->(DBCOMMIT())
          ENDIF

          IF lShared
             ISO->(DBUNLOCK())
          ENDIF

       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(nTipCur)
*>>>>FIN GRABACION DEL REGISTRO

*>>>>REFRESCAR EL BROWSE
       IF nTipMod == 2
          nNroReg := ISO->(RECNO())
          ISO->(DBGOTOP())
          oBrowse:GOTOP()
          ISO->(DBGOTO(nNroReg))
          oBrowse:FORCESTABLE()
       ENDIF
       RETURN .T.
*>>>>FIN REFRESCAR EL BROWSE

/*************************************************************************
* TITULO..: VALIDACION DE EXISTENCIA DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Realiza la validaci¢n de existencia del C¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodIso(cCodigo)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo a Validar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF cCodigo # cSpaces('ISO','nNumeroIso')
          IF lLocCodigo('nNumeroIso','ISO',cCodigo)
             cError('ESTE CODIGO YA EXISTE')
             lHayErr := .T.
          ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarIso(oBrowse)

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
       cCodigo := cSpaces('ISO','nNumeroIso')
       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '@!';
			 VALID lValIso(ROW(),COL()-3,@cCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigo == cSpaces('ISO','nNumeroIso')
          cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
                 'ADVERTENCIA')
          lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT ISO
       IF lBuscar .AND. lLocCodigo('nNumeroIso','ISO',cCodigo)
          nNroReg := ISO->(RECNO())
          ISO->(DBGOTOP())
          oBrowse:GOTOP()
          ISO->(DBGOTO(nNroReg))
          oBrowse:FORCESTABLE()
       ELSE
          oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValIso(nNroFil,nNroCol,cCodigo)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo                              // C¢digo a Validar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF !lLocCodigo('nNumeroIso','ISO',cCodigo)
          nNroReg := nSelIso(nNroFil,nNroCol)
          IF nNroReg == 0
             cCodigo := cSpaces('ISO','nNumeroIso')
          ELSE
             ISO->(DBGOTO(nNroReg))
             cCodigo := ISO->nNumeroIso
          ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelIso(nNroFil,nNroCol)

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
       IF ISO->(RECCOUNT()) == 0
          cError('NO EXISTEN REGISTROS GRABADOS')
          RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
       SELECT ISO
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
       ISO->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||ISO->nNumeroIso})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CODIGO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrIso(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
                    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
                    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
                    oBrowse)

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
       aArchvo                              // Archivo en Uso
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       nCodPrn                              // C¢digo de Impresi¢n
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

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<DOCUMENTOS ISO>')

       aAyuda := {}
       AADD(aAyuda,'Imprime los Detalles del Archivo')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,'MENU OTROS',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
          RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
            OtrIso011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
                      cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
                      cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
                      oBrowse)
           *Impresi¢n de los campos del Archivo

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 21/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:07 AM   SEP 21/2007 VIE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrIso011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
              cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
              cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
              oBrowse)

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
       aArchvo                              // Archivos en Uso
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       nCodPrn                              // C¢digo de Impresi¢n
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
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
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

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())
       nLenPrn := PCL('n17Stan')

       IF lPrnArc
          SET DEVICE TO PRINT
       ELSE
          FilePrn := 'Iso'
          nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.T.)
          IF EMPTY(nOpcPrn)
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
                   'DOCUMENTOS ISO',;
                   '',;
                   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,6)
       AADD(aTitPrn,'NUMERO')

       AADD(aNroCol,8)
       AADD(aTitPrn,'SISTEMA')

       AADD(aNroCol,6)
       AADD(aTitPrn,'ORDEN')

       AADD(aNroCol,8)
       AADD(aTitPrn,'INFORME')

       AADD(aNroCol,10)
       AADD(aTitPrn,'IMPRESORA')

       AADD(aNroCol,8)
       AADD(aTitPrn,'FECHA')

       AADD(aNroCol,8)
       AADD(aTitPrn,'MARGENSI')

       AADD(aNroCol,8)
       AADD(aTitPrn,'MARGENSD')

       AADD(aNroCol,8)
       AADD(aTitPrn,'MARGENII')

       AADD(aNroCol,8)
       AADD(aTitPrn,'MARGENID')

       AADD(aNroCol,8)
       AADD(aTitPrn,'MARGEN1I')

       AADD(aNroCol,8)
       AADD(aTitPrn,'MARGEN1D')

       AADD(aNroCol,8)
       AADD(aTitPrn,'MARGEN2I')

       AADD(aNroCol,8)
       AADD(aTitPrn,'MARGEN2D')

       AADD(aNroCol,10)
       AADD(aTitPrn,'DOCUMENTO')

       AADD(aNroCol,60)
       AADD(aTitPrn,'TITULO POR DEFECTO')

       AADD(aNroCol,60)
       AADD(aTitPrn,'OPCION DEL SISTEMA')

       AADD(aNroCol,60)
       AADD(aTitPrn,'CODISO')

       AADD(aNroCol,60)
       AADD(aTitPrn,'TITULO UNO')

       AADD(aNroCol,60)
       AADD(aTitPrn,'TITULO DOS')

       AADD(aNroCol,60)
       AADD(aTitPrn,'TITULO DOS')

       AADD(aNroCol,256)
       AADD(aTitPrn,'PIE UNO')

       AADD(aNroCol,256)
       AADD(aTitPrn,'PIE DOS')

       AADD(aNroCol,256)
       AADD(aTitPrn,'PIE TRES')

       AADD(aNroCol,256)
       AADD(aTitPrn,'OBSERVACION UNO')

       AADD(aNroCol,256)
       AADD(aTitPrn,'OBSERVACION DOS')

       AADD(aNroCol,256)
       AADD(aTitPrn,'OBSERVACION TRES')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
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

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT ISO
       ISO->(DBGOTOP())
       DO WHILE .NOT. ISO->(EOF())

**********VISUALIZACION DE AVANCE
            nAvance := INT(( ISO->(RECNO()) / ISO->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
            aRegPrn := {}
            AADD(aRegPrn,STR(ISO->nNumeroIso,4,0))
            AADD(aRegPrn,ISO->cCodSuiIso)
            AADD(aRegPrn,STR(ISO->nNroOrdIso,4,0))
            AADD(aRegPrn,ISO->cCodInfIso)
            AADD(aRegPrn,STR(ISO->nCodPrnIso,4,0))
            AADD(aRegPrn,cFecha(ISO->dFecAprIso))
            AADD(aRegPrn,STR(ISO->nMargSIIso,3,0))
            AADD(aRegPrn,STR(ISO->nMargSDIso,3,0))
            AADD(aRegPrn,STR(ISO->nMargIIIso,3,0))
            AADD(aRegPrn,STR(ISO->nMargIDIso,3,0))
            AADD(aRegPrn,STR(ISO->nMarg1IIso,3,0))
            AADD(aRegPrn,STR(ISO->nMarg1DIso,3,0))
            AADD(aRegPrn,STR(ISO->nMarg2IIso,3,0))
            AADD(aRegPrn,STR(ISO->nMarg2DIso,3,0))
            AADD(aRegPrn,STR(ISO->nNroDocIso,2,0))
            AADD(aRegPrn,ISO->cTituloIso)
            AADD(aRegPrn,ISO->cOpcSysIso)
            AADD(aRegPrn,ISO->cCodigoIso)
            AADD(aRegPrn,ISO->cTitUnoIso)
            AADD(aRegPrn,ISO->cTitDosIso)
            AADD(aRegPrn,ISO->cTitTreIso)
            AADD(aRegPrn,ISO->cPieUnoIso)
            AADD(aRegPrn,ISO->cPieDosIso)
            AADD(aRegPrn,ISO->cPieTreIso)
            AADD(aRegPrn,ISO->cObsUnoIso)
            AADD(aRegPrn,ISO->cObsDosIso)
            AADD(aRegPrn,ISO->cObsTreIso)

            lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
                    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ISO
	    ISO->(DBSKIP())
	    IF ISO->(EOF())
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
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS
