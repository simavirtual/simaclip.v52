/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfPer(lShared,nModCry,PathArc,fArchvo,aStrDbf)

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
       AADD(aDbfStr,{'nIdeCodPer','Numeric'  ,16,0}) // Ide del Registro
      *Llave Principal

       AADD(aDbfStr,{'cDocNitPer','Character',16,0}) // Documento de Identidad
       AADD(aDbfStr,{'cTipNitPer','Character',1,0}) // Tipo del Documento
       AADD(aDbfStr,{'cLugNitPer','Character',20,0}) // Lugar del Documento
       AADD(aDbfStr,{'lFotNitPer','Logical',1,0}) // Fotocopia del Documento
       AADD(aDbfStr,{'cApeUnoPer','Character',20,0}) // Primer Apellido
       AADD(aDbfStr,{'cApeDosPer','Character',20,0}) // Segundo Apellido
       AADD(aDbfStr,{'cNomUnoPer','Character',20,0}) // Primer Nombre
       AADD(aDbfStr,{'cNomDosPer','Character',20,0}) // Segundo Nombre
       AADD(aDbfStr,{'dFecNacPer','Date',8,0}) // Fecha de nacimiento
       AADD(aDbfStr,{'cLugNacPer','Character',20,0}) // Lugar de nacimiento
       AADD(aDbfStr,{'lSiQepdPer','Logical',1,0}) // .T. Que En la Paz Del señor
       AADD(aDbfStr,{'lSexFemPer','Logical',1,0}) // .T. Sexo Femenino .F. Sexo Masculino
       AADD(aDbfStr,{'cTipoRhPer','Character',4,0}) // Tipo de Sangre
       AADD(aDbfStr,{'cEstratPer','Character',1,0}) // Estrato
       AADD(aDbfStr,{'cEstCivPer','Character',1,0}) // Estado Civil
       AADD(aDbfStr,{'cNitPadPer','Character',16,0}) // Documento del Padre
       AADD(aDbfStr,{'cTntPadPer','Character',1,0}) // Tipo de Documento del Padre
       AADD(aDbfStr,{'cNitMadPer','Character',16,0}) // Documento de la Madre
       AADD(aDbfStr,{'cTntMadPer','Character',1,0}) // Tipo de Documento de la Madre
       AADD(aDbfStr,{'cNitCmpPer','Character',16,0}) // Documento de Compa¤era(o)
       AADD(aDbfStr,{'cTntCmpPer','Character',1,0}) // Tipo de Documento de la Compañera(o)
       AADD(aDbfStr,{'nNroHijPer','Numeric',2,0}) // N£mero de Hijos
       AADD(aDbfStr,{'nPerCarPer','Numeric',2,0}) // Personas a Cargo
       AADD(aDbfStr,{'nTotIngPer','Numeric',12,2}) // Total de Ingresos
       AADD(aDbfStr,{'nTotEgrPer','Numeric',12,2}) // Total de Egresos
       AADD(aDbfStr,{'cDireccPer','Character',60,0}) // Direccion de la Casa
       AADD(aDbfStr,{'cBarrioPer','Character',40,0}) // Barrio de la Direccion
       AADD(aDbfStr,{'cCiudadPer','Character',40,0}) // Ciudad de la Direcci¢n
*       AADD(aDbfStr,{'cDepartPer','Character',40,0}) // Departamento de la Direcci¢n
       AADD(aDbfStr,{'cTelefnPer','Character',14,0}) // Telefono Casa
       AADD(aDbfStr,{'cTelFaxPer','Character',14,0}) // Telefono Fax de la Casa
       AADD(aDbfStr,{'cTelCelPer','Character',14,0}) // Telefono celular
       AADD(aDbfStr,{'cBipperPer','Character',30,0}) // Biper de la Persona
       AADD(aDbfStr,{'cTelOtrPer','Character',30,0}) // Otros Telefonos de la Persona
       AADD(aDbfStr,{'cUrlWwwPer','Character',40,0}) // Sitio de Internet
       AADD(aDbfStr,{'cMaiUnoPer','Character',40,0}) // e-mail 1
       AADD(aDbfStr,{'cMaiDosPer','Character',40,0}) // e-mail 2
       AADD(aDbfStr,{'cMaiTrePer','Character',40,0}) // e-mail 3
       AADD(aDbfStr,{'cDirEnvPer','Character',60,0}) // Direccion de Envio de Correspondencia
       AADD(aDbfStr,{'cBarEnvPer','Character',40,0}) // Barrio de Envio de Correspondencia
       AADD(aDbfStr,{'cCiuEnvPer','Character',40,0}) // Ciudad de Envio de la Correspondencia
       AADD(aDbfStr,{'cTelEnvPer','Character',14,0}) // Telefono Direccion de Correspondencia
       AADD(aDbfStr,{'cFaxEnvPer','Character',14,0}) // Fax Direccion de la correspondencia
       AADD(aDbfStr,{'cEmpTraPer','Character',26,0}) // Empresa del Trabajo
       AADD(aDbfStr,{'cCarTraPer','Character',20,0}) // Cargo de la Empresa
       AADD(aDbfStr,{'cDirTraPer','Character',60,0}) // Direccion del Trabajo
       AADD(aDbfStr,{'cBarTraPer','Character',40,0}) // Barrio del Trabajo
       AADD(aDbfStr,{'cCiuTraPer','Character',40,0}) // Ciudad del Trabajo
       AADD(aDbfStr,{'cTelTraPer','Character',14,0}) // Telefono del Trabajo
       AADD(aDbfStr,{'cFaxTraPer','Character',14,0}) // Fax del Trabajo
       AADD(aDbfStr,{'cTeoTraPer','Character',30,0}) // Otros Telefonos del Trabajo
       AADD(aDbfStr,{'nSueldoPer','Numeric',12,2}) // Sueldo
       AADD(aDbfStr,{'dIngTraPer','Date',8,0}) // Fecha del Ingreso
       AADD(aDbfStr,{'cTipConPer','Character',1,0}) // Tipo de Contrato
       AADD(aDbfStr,{'cProfesPer','Character',26,0}) // Profesion de la Persona

       AADD(aDbfStr,{'cNomUsrPer','Character',10,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrPer','Date'     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrPer','Character',10,0}) // Hora del Usuario
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfPer(lShared,nModCry,PathArc,fArchvo)

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
       CreaDbfPer(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

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

FUNCTION nActStrPer(lShared,nModCry,PathArc,cNomArc)

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
       CreaDbfPer(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
                         {||CreaDbfPer(lShared,nModCry,PathArc,FileTem)})
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenPer(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		   cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
		   aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
		   lHaySql)

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
       lHaySql                              // .T. Exportar a Sql */
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
       AADD(aUseDbf,{.T.,PathArc+'\'+fArchvo,'PER',fNtxArc,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
          cError('ABRIENDO EL ARCHIVO')
          CloseDbf('PER')
          RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>PARAMETROS POR DEFECTO
       lModReg := IF(EMPTY(lModReg),.F.,lModReg)
       lModReg := IF(lModReg .AND. PER->(RECCOUNT())==0,.F.,lModReg)

       lDelReg := IF(lDelReg==NIL,.F.,lDelReg)

       lInsReg := IF(lInsReg==NIL,.F.,lInsReg)

       lHaySql := IF(lHaySql==NIL,.F.,lHaySql)
*>>>>FIN PARAMETROS POR DEFECTO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwDbfPer(lShared,cNomUsr,cAnoUsr,03,00,22,79,;
                             lModReg,lDelReg,lInsReg,lHaySql)

       SETKEY(K_F2,{||lManRegPer(lShared,cNomUsr,3,oBrowse)})
     *ÀConsulta

       IF lModReg
          SETKEY(K_F4,{||lManRegPer(lShared,cNomUsr,2,oBrowse,;
                                    PER->cDocNitPer)})
       ENDIF
     *ÀActualizar

       SETKEY(K_F5,{||BuscarPer(oBrowse)})

       SETKEY(K_F9,{||MenuOtrPer(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
                                 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
                                 PathArc,fArchvo,aArcNtx,lPrnArc,cOpcPrn,;
                                 lModReg,lDelReg,lInsReg,lHaySql,oBrowse)})

       PER->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F2,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CloseDbf('PER')
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwDbfPer(lShared,cNomUsr,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,;
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

       cTitSup := '<< PERSONAS >>'
       cTitInf := '<F2>Consultar <F5>Buscar'+;
                   IF(lModReg,' <F4>Actualizar','')+' <F9>Otros'+;
                   IF(lDelReg,' <DEL>Borrar','')+;
                   IF(lInsReg,' <INS>Incluir','')

       IF lInsReg
          oBrowse:Cargo := {cTitSup,cTitInf,{||lManRegPer(lShared,cNomUsr)}}
       ELSE
          oBrowse:Cargo := {cTitSup,cTitInf}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PER
       oColumn := TBCOLUMNNEW('DOCUMENTO DE;IDENTIDAD',{||PER->cDocNitPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cDocNitPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TIPO DE;DOCUMENTO',{||PER->cTipNitPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTipNitPer'},{'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('LUGAR DEL;DOCUMENTO',{||PER->cLugNitPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cLugNitPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('FOTOCOPIA DEL;DOCUMENTO',{||PER->lFotNitPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','lFotNitPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PRIMER;APELLIDO',{||PER->cApeUnoPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cApeUnoPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('SEGUNDO;APELLIDO',{||PER->cApeDosPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cApeDosPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PRIMER;NOMBRE',{||PER->cNomUnoPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cNomUnoPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('SEGUNDO;NOMBRE',{||PER->cNomDosPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cNomDosPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('FECHA DE;NACIMIENTO',{||PER->dFecNacPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','dFecNacPer'},{'PICTURE','@D'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('LUGAR DE;NACIMIENTO',{||PER->cLugNacPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cLugNacPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('SIQEPD',{||PER->lSiQepdPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','lSiQepdPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('SEXO;FEMENINO',{||PER->lSexFemPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','lSexFemPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TIPO DE SANGRE',{||PER->cTipoRhPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTipoRhPer'},{'PICTURE','@X!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ESTRATO',{||PER->cEstratPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cEstratPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ESTADO;CIVIL',{||PER->cEstCivPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cEstCivPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DOCUMENTO;DEL PADRE',{||PER->cNitPadPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cNitPadPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TIPO DE DOCUMENTO;DEL PADRE',{||PER->cTntPadPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTntPadPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DOCUMENTO;DE LA MADRE',{||PER->cNitMadPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cNitMadPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TIPO DE DOCUMENTO;DE LA MADRE',{||PER->cTntMadPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTntMadPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DOCUMENTO DE;COMPA¥ERA(O)',{||PER->cNitCmpPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cNitCmpPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TIPO DE DOCUMENTO;DE LA COMPAÑERA(O)',{||PER->cTntCmpPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTntCmpPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NUMERO;DE HIJOS',{||PER->nNroHijPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','nNroHijPer'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PERSONAS;A CARGO',{||PER->nPerCarPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','nPerCarPer'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TOTAL DE;INGRESOS',{||PER->nTotIngPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','nTotIngPer'},{'PICTURE','99999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TOTAL DE;EGRESOS',{||PER->nTotEgrPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','nTotEgrPer'},{'PICTURE','99999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DIRECCION DE;LA CASA',{||PER->cDireccPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cDireccPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('BARRIO DE;LA DIRECCION',{||PER->cBarrioPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cBarrioPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CIUDAD',{||PER->cCiudadPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cCiudadPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       oColumn := TBCOLUMNNEW('DEPARTAMENTO',{||PER->cDepartPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cDepartPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn := TBCOLUMNNEW('TELEFONO;CASA',{||PER->cTelefnPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTelefnPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TELEFONO FAX;DE LA CASA',{||PER->cTelFaxPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTelFaxPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TELEFONO;CELULAR',{||PER->cTelCelPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTelCelPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('BIPER DE;LA PERSONA',{||PER->cBipperPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cBipperPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('OTROS TELEFONOS;DE LA PERSONA',{||PER->cTelOtrPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTelOtrPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('SITIO DE;INTERNET',{||PER->cUrlWwwPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cUrlWwwPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('E-MAIL 1',{||PER->cMaiUnoPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cMaiUnoPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('E-MAIL 2',{||PER->cMaiDosPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cMaiDosPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('E-MAIL 3',{||PER->cMaiTrePer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cMaiTrePer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DIRECCION;CORRESPONDENCIA',{||PER->cDirEnvPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cDirEnvPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('BARRIO;DE ENVIO',{||PER->cBarEnvPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cBarEnvPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CIUDAD;DE ENVIO',{||PER->cCiuEnvPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cCiuEnvPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TELEFONO;DE ENVIO',{||PER->cTelEnvPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTelEnvPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('FAX DE;DIRECCION',{||PER->cFaxEnvPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cFaxEnvPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('EMPRESA DEL;TRABAJO',{||PER->cEmpTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cEmpTraPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CARGO DE;LA EMPRESA',{||PER->cCarTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cCarTraPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DIRECCION;DEL TRABAJO',{||PER->cDirTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cDirTraPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('BARRIO DEL;TRABAJO',{||PER->cBarTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cBarTraPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CIUDAD DEL;TRABAJO',{||PER->cCiuTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cCiuTraPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TELEFONO DEL;TRABAJO',{||PER->cTelTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTelTraPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('FAX DEL;TRABAJO',{||PER->cFaxTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cFaxTraPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('OTROS TELEFONOS;DEL TRABAJO',{||PER->cTeoTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTeoTraPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('SUELDO',{||PER->nSueldoPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','nSueldoPer'},{'PICTURE','99999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('FECHA;INGRESO',{||PER->dIngTraPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','dIngTraPer'},{'PICTURE','@!D'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TIPO DE;CONTRATO',{||PER->cTipConPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cTipConPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PROFESION DE;LA PERSONA',{||PER->cProfesPer})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PER'},;
			 {'FIELD','cProfesPer'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||PER->cNomUsrPer})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(PER->dFecUsrPer)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(PER->cHorUsrPer)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO',{||PER->nIdeCodPer})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('No.',{||PER->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: VALIDACION DE EXISTENCIA DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Realiza la validaci¢n de existencia del C¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodPer(cCodigo)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo a Validar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF cCodigo # cSpaces('PER','cDocNitPer')
          IF lLocCodigo('cDocNitPer','PER',cCodigo)
             cError('ESTE CODIGO YA EXISTE')
             lHayErr := .T.
          ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarPer(oBrowse)

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
       cCodigo := cSpaces('PER','cDocNitPer')
       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '@!';
			 VALID lValPer(ROW(),COL()-3,@cCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigo == cSpaces('PER','cDocNitPer')
          cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
                 'ADVERTENCIA')
          lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT PER
       IF lBuscar .AND. lLocCodigo('cDocNitPer','PER',cCodigo)

          nNroReg := PER->(RECNO())
          PER->(DBGOTOP())
	  oBrowse:GOTOP()
	  PER->(DBGOTO(nNroReg))
	  oBrowse:FORCESTABLE()
       ELSE
          oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValPer(nNroFil,nNroCol,cCodigo)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo                              // C¢digo a Validar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF !lLocCodigo('cDocNitPer','PER',cCodigo)
          nNroReg := nSelPer(nNroFil,nNroCol)
          IF nNroReg == 0
             cCodigo := cSpaces('PER','cDocNitPer')
          ELSE
             PER->(DBGOTO(nNroReg))
             cCodigo := PER->cDocNitPer
          ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelPer(nNroFil,nNroCol)

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
       IF PER->(RECCOUNT()) == 0
          cError('NO EXISTEN REGISTROS GRABADOS')
          RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
       SELECT PER
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
       PER->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||PER->cDocNitPer})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CODIGO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrPer(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<PERSONAS>')

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
            OtrPer011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
                      cNomEmp,cNomSec,cNomUsr,cAnoUsr,PathArc,fArchvo,;
                      aArcNtx,lPrnArc,cOpcPrn,lModReg,lDelReg,lInsReg,;
                      lHaySql,oBrowse)
           *Impresi¢n de los campos del Archivo

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   DIC 16/2004 JUE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrPer011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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
                   'PERSONAS',;
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

       AADD(aNroCol,16)
       AADD(aTitPrn,'DOCUMENTO')

       AADD(aNroCol,4)
       AADD(aTitPrn,'TIPO')

       AADD(aNroCol,20)
       AADD(aTitPrn,'DE')

       AADD(aNroCol,10)
       AADD(aTitPrn,'FOTOCOPIA')

       AADD(aNroCol,20)
       AADD(aTitPrn,'PRIMER APELLIDO')

       AADD(aNroCol,20)
       AADD(aTitPrn,'SEGUNDO APELLIDO')

       AADD(aNroCol,20)
       AADD(aTitPrn,'PRIMER NOMBRE')

       AADD(aNroCol,20)
       AADD(aTitPrn,'SEGUNDO NOMBRE')

       AADD(aNroCol,16)
       AADD(aTitPrn,'FECHA NACIMIENTO')

       AADD(aNroCol,20)
       AADD(aTitPrn,'LUGAR NACIMIENTO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'SIQEPD')

       AADD(aNroCol,14)
       AADD(aTitPrn,'SEXO FEMENINO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'TIPORH')

       AADD(aNroCol,8)
       AADD(aTitPrn,'ESTRATO')

       AADD(aNroCol,12)
       AADD(aTitPrn,'ESTADO CIVIL')

       AADD(aNroCol,16)
       AADD(aTitPrn,'NIT PADRE')

       AADD(aNroCol,4)
       AADD(aTitPrn,'TIPO')

       AADD(aNroCol,16)
       AADD(aTitPrn,'NIT MADRE')

       AADD(aNroCol,4)
       AADD(aTitPrn,'TIPO')

       AADD(aNroCol,26)
       AADD(aTitPrn,'DOCUMENTO DE COMPAÑERA(O)')

       AADD(aNroCol,36)
       AADD(aTitPrn,'TIPO DE DOCUMENTO DE LA COMPAÑERA(O)')

       AADD(aNroCol,6)
       AADD(aTitPrn,'HIJOS')

       AADD(aNroCol,8)
       AADD(aTitPrn,'A CARGO')

       AADD(aNroCol,14)
       AADD(aTitPrn,'INGRESOS')

       AADD(aNroCol,14)
       AADD(aTitPrn,'EGRESOS')

       AADD(aNroCol,60)
       AADD(aTitPrn,'DIRECCION DE LA CASA')

       AADD(aNroCol,40)
       AADD(aTitPrn,'BARRIO DE LA DIRECCION')

       AADD(aNroCol,40)
       AADD(aTitPrn,'CIUDAD')

       AADD(aNroCol,14)
       AADD(aTitPrn,'TELEFONO CASA')

       AADD(aNroCol,24)
       AADD(aTitPrn,'TELEFONO FAX DE LA CASA')

       AADD(aNroCol,16)
       AADD(aTitPrn,'TELEFONO CELULAR')

       AADD(aNroCol,30)
       AADD(aTitPrn,'BIPER DE LA PERSONA')

       AADD(aNroCol,30)
       AADD(aTitPrn,'OTROS TELEFONOS DE LA PERSONA')

       AADD(aNroCol,40)
       AADD(aTitPrn,'SITIO DE INTERNET')

       AADD(aNroCol,40)
       AADD(aTitPrn,'E-MAIL 1')

       AADD(aNroCol,40)
       AADD(aTitPrn,'E-MAIL 2')

       AADD(aNroCol,40)
       AADD(aTitPrn,'E-MAIL 3')

       AADD(aNroCol,60)
       AADD(aTitPrn,'DIRECCION CORRESPONDENCIA')

       AADD(aNroCol,40)
       AADD(aTitPrn,'BARRIO DE ENVIO')

       AADD(aNroCol,40)
       AADD(aTitPrn,'CIUDAD DE ENVIO')

       AADD(aNroCol,18)
       AADD(aTitPrn,'TELEFONO DE ENVIO')

       AADD(aNroCol,16)
       AADD(aTitPrn,'FAX DE DIRECCION')

       AADD(aNroCol,26)
       AADD(aTitPrn,'EMPRESA DEL TRABAJO')

       AADD(aNroCol,20)
       AADD(aTitPrn,'CARGO DE LA EMPRESA')

       AADD(aNroCol,60)
       AADD(aTitPrn,'DIRECCION DEL TRABAJO')

       AADD(aNroCol,40)
       AADD(aTitPrn,'BARRIO DEL TRABAJO')

       AADD(aNroCol,40)
       AADD(aTitPrn,'CIUDAD DEL TRABAJO')

       AADD(aNroCol,20)
       AADD(aTitPrn,'TELEFONO DEL TRABAJO')

       AADD(aNroCol,16)
       AADD(aTitPrn,'FAX DEL TRABAJO')

       AADD(aNroCol,30)
       AADD(aTitPrn,'OTROS TELEFONOS DEL TRABAJO')

       AADD(aNroCol,14)
       AADD(aTitPrn,'SUELDO')

       AADD(aNroCol,8)
       AADD(aTitPrn,'INGRESO')

       AADD(aNroCol,14)
       AADD(aTitPrn,'TIPO CONTRATO')

       AADD(aNroCol,26)
       AADD(aTitPrn,'PROFESION DE LA PERSONA')

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
          FilePrn := 'Per'
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

       SELECT PER
       PER->(DBGOTOP())
       DO WHILE .NOT. PER->(EOF())

**********VISUALIZACION DE AVANCE
            nAvance := INT(( PER->(RECNO()) / PER->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
            aRegPrn := {}
            AADD(aRegPrn,PER->cDocNitPer)
            AADD(aRegPrn,PER->cTipNitPer)
            AADD(aRegPrn,PER->cLugNitPer)
            AADD(aRegPrn,IF(PER->lFotNitPer,'SI','NO'))
            AADD(aRegPrn,PER->cApeUnoPer)
            AADD(aRegPrn,PER->cApeDosPer)
            AADD(aRegPrn,PER->cNomUnoPer)
            AADD(aRegPrn,PER->cNomDosPer)
            AADD(aRegPrn,cFecha(PER->dFecNacPer))
            AADD(aRegPrn,PER->cLugNacPer)
            AADD(aRegPrn,IF(PER->lSiQepdPer,'SI','NO'))
            AADD(aRegPrn,IF(PER->lSexFemPer,'SI','NO'))
            AADD(aRegPrn,PER->cTipoRhPer)
            AADD(aRegPrn,PER->cEstratPer)
            AADD(aRegPrn,PER->cEstCivPer)
            AADD(aRegPrn,PER->cNitPadPer)
            AADD(aRegPrn,PER->cTntPadPer)
            AADD(aRegPrn,PER->cNitMadPer)
            AADD(aRegPrn,PER->cTntMadPer)
            AADD(aRegPrn,PER->cNitCmpPer)
            AADD(aRegPrn,PER->cTntCmpPer)
            AADD(aRegPrn,STR(PER->nNroHijPer,2,0))
            AADD(aRegPrn,STR(PER->nPerCarPer,2,0))
            AADD(aRegPrn,TRANS(PER->nTotIngPer,'###,###,###.99'))
            AADD(aRegPrn,TRANS(PER->nTotEgrPer,'###,###,###.99'))
            AADD(aRegPrn,PER->cDireccPer)
            AADD(aRegPrn,PER->cBarrioPer)
            AADD(aRegPrn,PER->cCiudadPer)
            AADD(aRegPrn,PER->cTelefnPer)
            AADD(aRegPrn,PER->cTelFaxPer)
            AADD(aRegPrn,PER->cTelCelPer)
            AADD(aRegPrn,PER->cBipperPer)
            AADD(aRegPrn,PER->cTelOtrPer)
            AADD(aRegPrn,PER->cUrlWwwPer)
            AADD(aRegPrn,PER->cMaiUnoPer)
            AADD(aRegPrn,PER->cMaiDosPer)
            AADD(aRegPrn,PER->cMaiTrePer)
            AADD(aRegPrn,PER->cDirEnvPer)
            AADD(aRegPrn,PER->cBarEnvPer)
            AADD(aRegPrn,PER->cCiuEnvPer)
            AADD(aRegPrn,PER->cTelEnvPer)
            AADD(aRegPrn,PER->cFaxEnvPer)
            AADD(aRegPrn,PER->cEmpTraPer)
            AADD(aRegPrn,PER->cCarTraPer)
            AADD(aRegPrn,PER->cDirTraPer)
            AADD(aRegPrn,PER->cBarTraPer)
            AADD(aRegPrn,PER->cCiuTraPer)
            AADD(aRegPrn,PER->cTelTraPer)
            AADD(aRegPrn,PER->cFaxTraPer)
            AADD(aRegPrn,PER->cTeoTraPer)
            AADD(aRegPrn,TRANS(PER->nSueldoPer,'###,###,###.99'))
            AADD(aRegPrn,cFecha(PER->dIngTraPer))
            AADD(aRegPrn,PER->cTipConPer)
            AADD(aRegPrn,PER->cProfesPer)

            lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
                    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PER
	    PER->(DBSKIP())
	    IF PER->(EOF())
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
