/*               	   SIMA - SISTEMA DE CAFETERIA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE PERSONAL

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 10:45 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfPer(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual      fECHA DE NACIMIENTO

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoPer","Character", 07,0}) // C¢digo del Personal
       AADD(aDbfStr,{"cPasWwwPer","Character", 10,0}) // PassWord del Internet
       AADD(aDbfStr,{"cPasWorPer","Character", 10,0}) // PassWord del Personal
       AADD(aDbfStr,{"cMaiPerPer","Character", 40,0}) // E-MAIL del Personal
       AADD(aDbfStr,{"cCodigoTip","Character", 01,0}) // C¢digo del Tipo de Personal
     *ÀInformaci¢n de identificaci¢n t‚cnica

       AADD(aDbfStr,{"lSexFemPer","Logical"  , 01,0}) // .T. Sexo Femenino .F. Sexo Masculino
       AADD(aDbfStr,{"cNombrePer","Character", 26,0}) // Nombre del profesor
       AADD(aDbfStr,{"cApelliPer","Character", 26,0}) // Apellido del profesor
       AADD(aDbfStr,{"cDocNitPer","Character", 16,0}) // Documento de Identidad
       AADD(aDbfStr,{"cLugNitPer","Character", 20,0}) // Lugar del Documento
       AADD(aDbfStr,{"cTipNitPer","Character", 03,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfStr,{"dFecNacPer","Date"     , 08,0}) // Fecha de Nacimiento
       AADD(aDbfStr,{"cLugNacPer","Character", 20,0}) // Lugar de Nacimiento
       AADD(aDbfStr,{"cDireccPer","Character", 50,0}) // Direccion del profesor
       AADD(aDbfStr,{"cBarrioPer","Character", 40,0}) // Barrio de la direcci¢n
       AADD(aDbfStr,{"cTelUnoPer","Character", 14,0}) // Telefono No. 1
       AADD(aDbfStr,{"cTelDosPer","Character", 14,0}) // Telefono No. 2
       AADD(aDbfStr,{"cTelTrePer","Character", 14,0}) // Telefono No. 3
       AADD(aDbfStr,{"cCodPrfPer","Character", 10,0}) // C¢digo de Profesi¢n
       AADD(aDbfStr,{"cTituloPer","Character", 30,0}) // T¡tulo
       AADD(aDbfStr,{"cUniTitPer","Character", 30,0}) // Universidad del t¡tulo
     *ÀInformaci¢n Personal

       AADD(aDbfStr,{"lNominaPer","Logical"  , 01,0}) // .T. Pertenece a la n¢mina
       AADD(aDbfStr,{"dFecIngPer","Date"     , 08,0}) // Fecha de Ingreso
       AADD(aDbfStr,{"lRetiroPer","Logical"  , 01,0}) // .T. Perfesor Retirado
       AADD(aDbfStr,{"dFecRetPer","Date"     , 08,0}) // Fecha del retiro
       AADD(aDbfStr,{"nSueActPer","Numeric"  , 07,0}) // Sueldo Actual
       AADD(aDbfStr,{"cCtaNomPer","Character", 16,0}) // Cuenta de la Nomina
     *ÀInformaci¢n de N¢mina

       AADD(aDbfStr,{"cSerHabPer","Character",010,0}) // Servicios Habilitados
       AADD(aDbfStr,{"dResIniPer","Date"     ,008,0}) // Fecha de Inicio del Servicio de Restaurante
       AADD(aDbfStr,{"dResFinPer","Date"     ,008,0}) // Fecha Final del Servicio de Restaurante
       AADD(aDbfStr,{"cResEnePer","Character",031,0}) // Servicio de Restaurante de Enero
       AADD(aDbfStr,{"cResFebPer","Character",031,0}) // Servicio de Restaurante de Febrero
       AADD(aDbfStr,{"cResMarPer","Character",031,0}) // Servicio de Restaurante de Marzo
       AADD(aDbfStr,{"cResAbrPer","Character",031,0}) // Servicio de Restaurante de Abril
       AADD(aDbfStr,{"cResMayPer","Character",031,0}) // Servicio de Restaurante de Mayo
       AADD(aDbfStr,{"cResJunPer","Character",031,0}) // Servicio de Restaurante de Junio
       AADD(aDbfStr,{"cResJulPer","Character",031,0}) // Servicio de Restaurante de Julio
       AADD(aDbfStr,{"cResAgoPer","Character",031,0}) // Servicio de Restaurante de Agosto
       AADD(aDbfStr,{"cResSepPer","Character",031,0}) // Servicio de Restaurante de Septiembre
       AADD(aDbfStr,{"cResOctPer","Character",031,0}) // Servicio de Restaurante de Octubre
       AADD(aDbfStr,{"cResNovPer","Character",031,0}) // Servicio de Restaurante de Noviembre
       AADD(aDbfStr,{"cResDicPer","Character",031,0}) // Servicio de Restaurante de
     *ÀServicio de Restaurante

       AADD(aDbfStr,{"cVotConPer","Character",030,0}) // Voto al Consejo Directivo
     *ÀOtros
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
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 10:50 PM   JUL 03/2002 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfPer(lShared,nModCry,PathArc,fArchvo,fNtxArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo
       fNtxArc			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfPer(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 10:55 PM   JUL 03/2002 MIE

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

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ARC',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('ARC')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ARC->(DBSTRUCT())
       CloseDbf('ARC')
       CreaDbfPer(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
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
	  cError('El Archivo PERSONAL su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
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
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 10:55 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenPer(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL aCamLoc := {}                  // Campos a Localizar
       LOCAL cTitCam := ''                  // T¡tulo del Campo
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse del Browse
       LOCAL bCodIns := NIL                 // CodeBlock de Inserci¢n
       LOCAL bCodBlo := NIL                 // CodeBlock

       LOCAL GetList := {}                  // Variable del Sistema

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCaf,'CAF',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePer,'PER',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTip+cAnoUsr+ExtFile,'TIP',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O DE LA CONTABILIDAD')

       CASE CAF->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TIP->(RECCOUNT()) == 0
	    cError('NO EXISTEN TIPOS DE PERSONAL GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>BROWSE DEL ARCHIVO
       SELECT PER
       IF !lFileLock()
	  oBrowse := oDefBrwPer(lShared,nFilPal+1,00,22,79,cAnoUsr)

	  SETKEY(K_F9,{||MenuOtrPer(aP1,aP2,aP3,oBrowse)})

	  PER->(CtrlBrw(lShared,oBrowse))
	  SETKEY(K_F9,NIL)
       ENDIF
       DBUNLOCKALL()
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 10:57 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Define el objeto Browse del archivo.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwPer(lShared,nFilSup,nColSup,nFilInf,nColInf,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCampos := ''                  // Campos

       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Transaciones
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       oBrowse:Cargo := {'<< OTRO PERSONAL'+' .'+;
			 'TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>',;
			 '<INS>Incluir <DEL>Borrar <F9>Otros '+;
			 '<ESC>Abandonar',{||IncluirPer(lShared,cAnoUsr)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PER
       oColumn	     := TBCOLUMNNEW('CODIGO', {||PER->cCodigoPer})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PER'},{'FIELD','cCodigoPer'},;
			 {'PICTURE','9999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       SELECT PER
       oColumn	     := TBCOLUMNNEW('DOCUMENTO', {||PER->cDocNitPer})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PER'},{'FIELD','cDocNitPer'},;
			 {'PICTURE','9999999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('APELLIDOS', {||PER->cApelliPer})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PER'},{'FIELD','cApelliPer'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRES', {||PER->cNombrePer})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PER'},{'FIELD','cNombrePer'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO', {||PER->cCodigoTip})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PER'},{'FIELD','cCodigoTip'},;
			 {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION DEL TIPO',;
				    {||cNomTipPer(PER->cCodigoTip,'PER')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ACTIVAR;SERVICIO', {||PER->cSerHabPer})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PER'},{'FIELD','cSerHabPer'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;INICIO', {||PER->dResIniPer})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PER'},{'FIELD','dResIniPer'},;
			 {'PICTURE','@D'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;FINAL', {||PER->dResFinPer})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PER'},{'FIELD','dResIniPer'},;
			 {'PICTURE','@D'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       FOR i := 1 TO 12
	  cCampos := 'PER->cRes'+cMes(i,3)+'Per'
	  oColumn	:= TBCOLUMNNEW('INGRESOS A LA CAFETERIA MES '+;
				       cMes(i,3)+;
				       ';1234567890123456789012345678901',;
				       {||&cCampos})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDFOR

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: INCLUCION DE UN REGISTRO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 10:57 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Inserta un registro al archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirPer(lShared,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL cSavLin := ''
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL    cSexFem := ''               // Sexo del Personal
       LOCAL cCodigoTtp := ''               // C¢digo Tipo de Personal
       LOCAL cCodigoTpe := ''               // C¢digo del Personal
       LOCAL cNombreTpe := ''               // Nombre del Personal
       LOCAL cApelliTpe := ''               // Apellido del Personal
       LOCAL cDocNitTpe := ''               // Documento del Personal
       LOCAL cLugNitTpe := ''               // Lugar del Documento
       LOCAL cTipNitTpe := ''               // Tipo del Documento
       LOCAL lSexFemTpe := .F.              // Sexo del Estudiante

       LOCAL dFecNacTpe := CTOD('00/00/00') // Fecha de Nacimiento
       LOCAL cLugNacTpe := ''               // Lugar de Nacimiento
       LOCAL cMaiPerTpe := ''               // Correo Electronico
       LOCAL cDireccTpe := ''               // Direcci¢n
       LOCAL cBarrioTpe := ''               // Barrio
       LOCAL cTelUnoTpe := ''               // Telefono No. 1
       LOCAL cTelDosTpe := ''               // Telefono No. 2
       LOCAL dFecIngTpe := CTOD('00/00/00') // Fecha de Ingreso
       LOCAL nSueActTpe := 0                // Sueldo Actual
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil+3,'POR FAVOR ENTRE LOS DATOS DEL PERSONAL',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTtp := cSpaces('TIP','cCodigoTip')
	       cNombreTpe := cSpaces('PER','cNombrePer')
	       cApelliTpe := cSpaces('PER','cApelliPer')
	       cDocNitTpe := cSpaces('PER','cDocNitPer')
	       cLugNitTpe := cSpaces('PER','cLugNitPer')
	       cTipNitTpe := cSpaces('PER','cTipNitPer')
	       lSexFemTpe := PER->lSexFemPer
	       IF lSexFemTpe
		  cSexFem := 'F'
	       ELSE
		  cSexFem := 'M'
	       ENDIF
	       dFecNacTpe := CTOD('00/00/00')
	       cLugNacTpe := cSpaces('PER','cLugNacPer')
	       cDireccTpe := cSpaces('PER','cDireccPer')
	       cBarrioTpe := cSpaces('PER','cBarrioPer')
	       cTelUnoTpe := cSpaces('PER','cTelUnoPer')
	       cTelDosTpe := cSpaces('PER','cTelDosPer')
	       cMaiPerTpe := cSpaces('PER','cMaiPerPer')

	       dFecIngTpe := CTOD('00/00/00')
	       nSueActTpe := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    cSavLin := SAVESCREEN(22,00,22,79)
	    centrar('Digite las Fechas en el Formato: MM/DD/AAAA',22)

	    @ nNroFil+00,nNroCol SAY 'TIPO PERSONAL:';
				 GET cCodigoTtp PICT '9';
				 VALID lValTipo(ROW(),COL()-2,@cCodigoTtp) .AND.;
				       cCodigoTtp # '1' .AND. cCodigoTtp # '2'


	    @ nNroFil+01,nNroCol SAY 'APELLIDO     :';
				 GET cApelliTpe PICT '@!'
	    @ nNroFil+01,nNroCol+59 SAY 'SEXO:';
				    GET cSexFem;
				    VALID lValSexo(ROW(),COL()-1,;
					  @cSexFem,@lSexFemTpe)
	    @ nNroFil+02,nNroCol SAY 'NOMBRE       :';
				 GET cNombreTpe PICT '@!'
	    @ nNroFil+03,nNroCol SAY 'DOCUMENTO    :';
				 GET cDocNitTpe PICT '9999999999999999'
	    @ nNroFil+04,nNroCol SAY 'DE           :';
				 GET cLugNitTpe PICT '@!'
	    @ nNroFil+05,nNroCol SAY 'TIPO         :';
				 GET cTipNitTpe PICT "@!";
				 VALID lValTipNit(ROW(),COL()-1,;
						   @cTipNitTpe)
	    @ nNroFil+06,nNroCol SAY 'F. NACIMIENTO:';
				 GET dFecNacTpe PICT '@D'
	    @ nNroFil+07,nNroCol SAY 'L. NACIMEINTO:';
				 GET cLugNacTpe PICT '@!'
	    @ nNroFil+08,nNroCol SAY 'DIREECION    :';
				 GET cDireccTpe PICT '@!'
	    @ nNroFil+09,nNroCol SAY 'BARRIO       :';
				 GET cBarrioTpe PICT '@!'
	    @ nNroFil+10,nNroCol SAY 'TELEFONO1    :';
				 GET cTelUnoTpe PICT '99999999999999'
	    @ nNroFil+11,nNroCol SAY 'TELEFONO2    :';
				 GET cTelDosTpe PICT '99999999999999'
	    @ nNroFil+12,nNroCol SAY 'E-MAIL       :';
				 GET cMaiPerTpe PICT '@!'
	    @ nNroFil+13,nNroCol SAY 'F.INGRESO    :';
				 GET dFecIngTpe PICT '@D'
	    @ nNroFil+14,nNroCol SAY 'SUELDO       :';
				 GET nSueActTpe PICT '9999999'
	    READ
	    RESTSCREEN(22,00,22,79,cSavLin)
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF !EMPTY(cApelliTpe) .AND. !EMPTY(cNombreTpe)
	       !EMPTY(dFecNacTpe) .AND. !EMPTY(cLugNacTpe)
	       lGrabar := .T.
	    ELSE
	       lGrabar := .F.
	       cError('DEBE DAR LOS DATOS COMPLETOS. NO SE GRABA EL REGISTRO')
	    ENDIF
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

*>>>>ASIGNACION DEL CODIGO
       IF lGrabar

	  IF COA->(lRegLock(lShared,.F.))

	     cCodigoTpe := STR(COA->nNroProCoA+1,4)
	    *Lectura del Secuencia

	     REPL COA->nNroProCoA WITH COA->nNroProCoA+1
	     COA->(DBCOMMIT())
	     IF lShared
		COA->(DBUNLOCK())
	     ENDIF
	   *ÀGrabaci¢n de C¢digo asignado
	  ENDIF
       ENDIF
*>>>>FIN ASIGNACION DEL CODIGO

*>>>>ASIGNACION DEL CODIGO
       IF lGrabar
	  lCorrecion(@cCodigoTpe)

	  IF VAL(cAnoUsr) >= 2000
	     cCodigoTpe := SUBS(cAnoUsr,1,1)+cAnoSis+SUBS(cCodigoTpe,2,3)
	  ELSE
	     cCodigoTpe := cAnoSis+cCodigoTpe
	  ENDIF
       ENDIF
*>>>>FIN ASIGNACION DEL CODIGO

*>>>>LOCALIZACION DEL CODIGO
       IF lGrabar
	  IF lLocCodigo('cCodigoPer','PER',cCodigoTpe)
	     cError('EL CODIGO: '+cCodigoTpe+' YA ESTA ASIGNADO A '+;
		     RTRIM(PER->cApelliPer)+' '+RTRIM(PER->cNombrePer))
	     lGrabar := .F.
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL

*>>>>GRABACION DEL REGISTRO
       SELECT PER
       IF lGrabar
	  IF PER->(lRegLock(lShared,.T.))
	     REPL PER->cCodigoPer WITH cCodigoTtp+cCodigoTpe
	     REPL PER->cCodigoTip WITH cCodigoTtp
	     REPL PER->cApelliPer WITH cApelliTpe
	     REPL PER->cNombrePer WITH cNombreTpe
	     REPL PER->cDocNitPer WITH cDocNitTpe
	     REPL PER->cLugNitPer WITH cLugNitTpe
	     REPL PER->cTipNitPer WITH cTipNitTpe
	     REPL PER->lSexFemPer WITH lSexFemTpe
	     REPL PER->dFecNacPer WITH dFecNacTpe
	     REPL PER->cLugNacPer WITH cLugNacTpe

	     REPL PER->cDireccPer WITH cDireccTpe
	     REPL PER->cBarrioPer WITH cBarrioTpe
	     REPL PER->cTelUnoPer WITH cTelUnoTpe
	     REPL PER->cTelDosPer WITH cTelDosTpe
	     REPL PER->cMaiPerPer WITH cMaiPerTpe
	     REPL PER->dFecIngPer WITH dFecIngTpe
	     REPL PER->nSueActPer WITH nSueActTpe
	     REPL PER->lRetiroPer WITH .F.
	     PER->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  PER->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: MENU OTROS DEL ARCHIVO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Definici¢n del Menu de Otros Procesos

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrPer(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<LISTADO DEL PERSONAL>')
       AADD(aMenus,'2<ORDENAR POR APELLIDO>')

       AADD(aAyuda,'Imprime el listado del Personal Actual')
       AADD(aAyuda,'Ordenar el Personal por apellido')

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
	    CaF_00400(aP1,aP2,aP3,oBrowse)
	  *ÀListado del Personal

       CASE nNroOpc == 2
	    OrdenaPer(lShared,cAnoUsr,cPatSis,oBrowse)
	   *Ordenar por apellido

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION DEL PERSONL ACTUAL                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Imprime el listado del Personal Actual

2- Debe estar en uso el archivo

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnPersnl(lShared,cNomEmp,cNomSis,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe


       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL cNombreTpe := ''               // Nombre de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PER->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := PER->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'PERSONAL ACTUAL A¥O:'+cAnoUsr,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,08,52,16,20,22,12}
       aTitulo := {'No. ',;
		   'CODIGO',;
		   'NOMBRE',;
		   'CEDULA',;
		   'DE',;
		   'TELEFONOS',;
		   'OBSERVACION'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
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
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  NNETSETQ('COLA')
	  NNETCAPBEG(1)
	  IF !lPregunta('DESEA IMPRIMIR EN RED? Si No')
	     NNETCAPEND(1)
	  ENDIF
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCaF,'cColaAcCaF','CaF')
       IF !Printer_on(CAF->lPrnArcCaF)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY PCL({"Reset"})
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PERSONAL
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT PER
       GO TOP
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
	    cNombreTpe := RTRIM(PER->cApelliPer)+' '+;
				PER->cNombrePer
	    cNombreTpe := SUBS(cNombreTpe+SPACE(52),1,52)

	    aTitulo := {STR(++i,4),;
			PER->cCodigoPer,;
			cNombreTpe,;
			PER->cDocNitPer,;
			PER->cLugNitPer,;
			ALLTRIM(PER->cTelUnoPer)+'-'+;
			ALLTRIM(PER->cTelDosPer),;
			SPACE(12)}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
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
*>>>>FIN IMPRESION DEL PERSONAL

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: ORDENAR EL ARCHIVO POR APELLIDO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:35 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Activa el campo para la revisi¢n de estudiantes cuando el profesor
   ingrese al sistema de Profesores.

2- Debe estar en uso el archivo de los profesores

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaPer(lShared,cAnoUsr,cPatSis,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       oBrowse			            // Browse del Archivo  */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PER->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN NIL
       ENDIF
       CloseDbf('PER')
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,PathSis+'\'+FilePer,'cApelliPer')
	  cError('NO SE ORDENO EL MAESTRO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+FilePer,'PER',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO PROFESORES')
	  RETURN NIL
       ENDIF
       SELECT PER
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DE LA FUNCION..: OBJETO CONSULTA DE ESTUDIANTES                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 29/94 MAR A
						       NOV 29/94 MAR

1- Define el objeto Browse para cualquier archivo

2- Debe estar en uso el archivo que se va a utilizar

3- Retorna el objeto para el browse

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrowses(nFilSup,nColSup,nFilInf,nColInf,;
		 cEncabe,cEncPie,aCampos,bCodIns)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cEncabe                              // Encabezado del marco
       cEncPie                              // Pie para el marco
       aCampos                              // Campos de las columnas
       bCodIns                              // CodeBlock de Inserci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oConsul := NIL                 // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oConsul := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oConsul:ColSep    := '³'
       oConsul:HeadSep   := 'Ä'
       oConsul:Cargo     := {cEncabe,cEncPie,bCodIns}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras


       IF LEN(aCampos) >= 1
	  oColumn := TBCOLUMNNEW(aCampos[1,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[1,1,2]))})
	  IF aCampos[1,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[1,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 2
	  oColumn := TBCOLUMNNEW(aCampos[2,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[2,1,2]))})
	  IF aCampos[2,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[2,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 3

	  IF UPPER(VALTYPE(aCampos[3,1,2])) == 'B'
	     oColumn := TBCOLUMNNEW(aCampos[3,1,1],aCampos[3,1,2])
	  ELSE
	     oColumn := TBCOLUMNNEW(aCampos[2,1,1],;
			{||FIELDGET(FIELDPOS(aCampos[2,1,2]))})
	  ENDIF

	  IF aCampos[3,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[3,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       RETURN oConsul
*>>>>FIN DEFINICION DEL OBJETO BROWSE