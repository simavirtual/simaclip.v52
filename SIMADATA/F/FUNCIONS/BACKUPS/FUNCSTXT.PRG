/*                       SIMA - SISTEMA CENTRAL DE RIESGOS
		  BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE PLANO

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 01:00 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfTxt(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'cCodEmpCon','Character',003,0}) // C¢digo de la Empresa
       AADD(aDbfStr,{'cCodigoEst','Character',006,0}) // C¢digo del Estudiante
       AADD(aDbfStr,{'cCodigoGru','Character',004,0}) // C¢digo del Grupo
       AADD(aDbfStr,{'cAnoSisRep','Character',04,0}) // A¤o de la Novedad
       AADD(aDbfStr,{'cVerSisRep','Character',12,0}) // Versi¢n del Sistema
       AADD(aDbfStr,{'nMesRepRep','Numeric'  ,02,0}) // Mes del Reporte
       AADD(aDbfStr,{'nMesIniPag','Numeric'  ,02,0}) // Mes Inicial del Pago
       AADD(aDbfStr,{'nMesFinPag','Numeric'  ,02,0}) // Mes Final del Pago
       AADD(aDbfStr,{'cCodigoRep','Character',18,0}) // N£mero de la Cuenta o Obligaci¢n
       AADD(aDbfStr,{'cDocNitRep','Character',11,0}) // N£mero de Identificaci¢n
       AADD(aDbfStr,{'cNovedaRep','Character',02,0}) // Novedad
       AADD(aDbfStr,{"nValidoRep","Numeric"  ,02,0}) // Registro valido

       AADD(aDbfStr,{'nRegPagRep','Numeric'  ,04,0}) // Registro del Pago
       AADD(aDbfStr,{'cNomUsrPag','Character',10,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrPag','Date'     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrPag','Character',10,0}) // Hora del Usuario

       AADD(aDbfStr,{'nNroCntDaA','Numeric'  ,01,0}) // N£mero de Contratantes a Reportar
       AADD(aDbfStr,{'nTipRepDaA','Numeric'  ,01,0}) // Tipo de Reporte.
       AADD(aDbfStr,{'nValCntDaA','Numeric'  ,01,0}) // Validar Contrantes

       AADD(aDbfStr,{'cRegistTxt','Character',800,0}) // A¤o de la Novedad
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 01:05 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfTxt(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfTxt(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 01:10 PM   ABR 22/2004 ABR

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

FUNCTION nActStrTxt(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ACT',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('ACT')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ACT->(DBSTRUCT())
       CloseDbf('ACT')
       CreaDbfTxt(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
			 {||CreaDbfTxt(lShared,nModCry,PathArc,FileTem)})
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 01:15 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenTxt(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,cVerSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       cVerSis	                            // Versi¢n del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual

       LOCAL oBrowse := NIL                 // Browse
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SDA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SDA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DEL MES
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes del Reporte',.T.)

       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIni == 0
	  RETURN NIL
       ENDIF
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni,.T.)
*>>>>FIN CAPTURA DEL MES

*>>>>VERIFICACION O CREACION DEL DIRECTORIO REPORT DEL MES
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)) == -3
	    DIRMAKE(cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3))
       ENDCASE
       cPatSis += '\REPORT\'+cMes(VAL(cMesIni),3)
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO REPORT DEL MES

*>>>>CREACION DEL ARCHIVO
       IF !FILE(cPatSis+'\'+FileTxt+cMesIni+ExtFile)
	  CreaDbfTxt(lShared,nModCry,cPatSis,;
		     FileTxt+cMesIni+ExtFile)
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       nActStrTxt(lShared,nModCry,cPatSis,FileTxt+cMesIni+ExtFile)
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FileTxt+cMesIni+ExtFile,;
		      'TXT',NIL,lNoRed,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrowseTxt(lShared,cAnoUsr,nFilPal+1,00,22,79,nMesIni)

       SETKEY(K_F5,{||BuscarEmp(oBrowse)})

       SETKEY(K_F9,{||MenuOtrTxt(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				 cJorTxt,cVerSis,cMesIni,oBrowse)})

       TXT->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 01:20 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrowseTxt(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,nMesIni)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       nMesIni                              // Mes Inicial */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrowse := NIL	            // Browse de Clientes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<< REPORTE DATA CREDITO A¥O: '+cAnoUsr+' '+;
			     'MES '+cMes(nMesIni)+' >>',;
			     '<ENTER>Modificar  <F9>Otros <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT TXT
       oColumn	:= TBCOLUMNNEW('No.',{||TXT->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9999'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('REGISTRO;CONFIRMADO',{||TXT->nValidoRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO DE;LA EMPRESA',{||TXT->cCodEmpCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO DEL;ESTUDIANTE',{||TXT->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('GRUPO DEL;ESTUDIANTE',{||TXT->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('A¥O',{||TXT->cAnoSisRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VERSION',{||TXT->cVerSisRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES',{||cMes(TXT->nMesRepRep,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES;INI',{||cMes(TXT->nMesIniPag,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MES;FIN',{||cMes(TXT->nMesFinPag,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NUMERO DE;LA CUENTA',;
			       {||TXT->cCodigoRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NUMERO DE;IDENTIFICACION',;
			       {||TXT->cDocNitRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NOVEDAD',{||TXT->cNovedaRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('REGISTRO EN PAGOS',{||TXT->nRegPagRep})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9999'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||TXT->cNomUsrPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(TXT->dFecUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(TXT->cHorUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CONTRATANTES;A REPORTAR',{||TXT->nNroCntDaA})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TIPO DE;REPORTE',{||TXT->nTipRepDaA})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := '9'
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALIDAR;CONTRATANTES',{||TXT->nValCntDaA})
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('REGISTRO',{||TXT->cRegistTxt})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarTxt(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			      // Browse de Bancos */
*>>>>FIN PARAMETROS DE LA FUNCION

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
       cCodigo := cSpaces('TXT','cCodigoEst')
       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '@!'
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigo == cSpaces('TXT','cCodigoEst')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT TXT
       IF lBuscar .AND. lLocCodigo('cCodigoEst','TXT',cCodigo)
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
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrTxt(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		    cJorTxt,cVerSis,cMesIni,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       cVerSis	                            // Versi¢n del Sistema
       oBrowse                              // Browse del Archivo */
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
       AADD(aMenus,'1<CREACION DE REGISTROS>')
       AADD(aMenus,'2<CREAR ARCHIVO ASCII  >')

       AADD(aAyuda,'Creaci¢n de los registros a Reportar')
       AADD(aAyuda,'Creaci¢n del ASCCI para DataCr‚dito')

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
	    OtrTxt011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,cVerSis,cMesIni,oBrowse)
	   *Creaci¢n de Registros

       CASE nNroOpc == 2
	    OtrTxt012(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,cVerSis,cMesIni,oBrowse)
	   *Creaci¢n archivo ASCII

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: CREACION DEL REGISTRO A REPORTAR                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTxt011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		    cJorTxt,cVerSis,cMesIni,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       cVerSis	                            // Versi¢n del Sistema
       cMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL dFecHoy := CTOD('00/00/00')    // Fecha de Proceso
       LOCAL aFecHoy := {}                  // Fecha de Proceso
       LOCAL cRegIni := ''                  // Registro Inicial
       LOCAL cRegFin := ''                  // Registro Inicial
       LOCAL nTotReg := 0                   // Total de Registros
       LOCAL cTotReg := ''                  // Total de Registros
       LOCAL nTotNov := 0                   // Total de Novedades
       LOCAL cTotNov := ''                  // Total de Novedades
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nAvance := 0                   // Avance de registros

       LOCAL cFecPrn := ''                  // Fecha de Corte
       LOCAL cSuscri := ''                  // C¢digo del Suscriptor
       LOCAL cTipCta := ''                  // Tipo de Cuenta
       LOCAL cFiador := ''                  // Responsable o Calidad de deudor
       LOCAL cFecSub := ''                  // Fecha del Subsidio
       LOCAL cFecOri := ''                  // Fecha Estado Origen
       LOCAL cFecEst := ''                  // Fecha Estado de la Cuenta
       LOCAL cOfiRad := ''                  // Oficina de radicaci¢n
       LOCAL cCiuRad := ''                  // Ciudad de radicaci¢n
       LOCAL cCiuRes := ''                  // Ciudad de residencia
       LOCAL cDirRes := ''                  // Direcci[on de residencia
       LOCAL cTelRes := ''                  // Telefono de la residencia
       LOCAL cCiuTra := ''                  // Ciudad Laboral
       LOCAL cDirTra := ''                  // Direcci[on Laboral
       LOCAL cTelTra := ''                  // Telefono Laboral
       LOCAL cCiuEnv := ''                  // Ciudad de Correspondencia
       LOCAL cDirEnv := ''                  // Direcci¢n de Correspondencia

       LOCAL cEstCta := ''                  // Estadod de la cuenta


       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecHoy := DATE()

       SET CURSOR ON
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(10,'FECHA DE PROCESO:',14,' ',NIL,20,50)
       @ nNroFil  ,21 SAY 'FECHA DE PROCESO:' GET dFecHoy PICT '@D';
				   WHEN {||HelpRead('FECHA')}
       READ

       SET CURSOR OFF
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(dFecHoy)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>ANALISIS DE DECISION
       IF TXT->(RECCOUNT()) == 0
	  lHayErr := !lPregunta('DESEA CONTINUAR? Si No')
       ELSE
	  lHayErr := !lPregunta('ESTA SEGURO EN BORRAR Y '+;
			       'VOLVER A CREAR EL ARCHIVO? Si No')
       ENDIF
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>ANALISIS DE DECISION

*>>>>BORRADO DE REGISTROS
       SELECT TXT
       ZAP
*>>>>FIN BORRADO DE REGISTROS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileEmp,'EMP',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseDbf('SDA')
	  CloseDbf('EMP')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SDA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SDA->cSuscriDat)
	    cError('NO SE HA DEFINIDIO EL CODIGO DE SUSCRIPCION')

       CASE EMPTY(SDA->cTipCtaDat)
	    cError('NO SE HA DEFINIDIO EL CODIGO DE SUSCRIPCION')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('SDA')
	  CloseDbf('EMP')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS


*>>>>GRABACION INICIALIZACION REGISTRO DE CONTROL
       cSuscri := SDA->cSuscriDat
       cTipCta := SDA->cTipCtaDat

       IF TXT->(lRegLock(lShared,.T.))
	  REPL TXT->cRegistTxt WITH 'INICIAL'
	  REPL TXT->cVerSisRep WITH cVerSis
	  TXT->(DBCOMMIT())
	  nTotReg++
       ELSE
	  cError('NO SE GRABA EL REGISTRO DE CONTROL')
       ENDIF
       IF lShared
	  TXT->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION INICIALIZACION REGISTRO DE CONTROL

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT EMP
       GO TOP
       DO WHILE .NOT. EMP->(EOF())

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+;
			    FileRep+EMP->cCodEmpCon+cMesIni+ExtFile,;
			    'REP',NIL,lShared,nModCry)

	       cError('ABRIENDO ARCHIVOS')
	       CloseDbf('SDA')
	       CloseDbf('EMP')
	       CloseDbf('REP')
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE REP->(RECCOUNT()) == 0
		 cError('NO EXISTE GRUPOS GRABADOS')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('SDA')
	       CloseDbf('EMP')
	       CloseDbf('REP')
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********RECORRIDO DE LOS REGISTROS
	    SELECT REP
	    REP->(DBGOTOP())
	    cFecPrn := REP->cFecActRep
	    DO WHILE .NOT. REP->(EOF())

*--------------GRABACION DEL REGISTRO
		 IF TXT->(lRegLock(lShared,.T.))

		    nTotNov += VAL(REP->cNovedaRep)
		   *Sumatoria de Novedades

		    cFiador := IF('C' $ REP->cCodigoRep,'01','00')
		    cFecSub := REPL('0',8)
		    cFecOri := REP->cFecApeRep+'01'
		    cFecEst := REP->cFecPrnRep

		    DO CASE
		    CASE REP->cNovedaRep == '01'
			 cEstCta := REP->cNovedaRep  // 01 Al d¡a
		    CASE REP->cNovedaRep == '05'
			 cEstCta := '03'             // 03 Pago Total
		    OTHERWISE
			 cEstCta := '02'             // 02 En Mora
		    ENDCASE

		    cOfiRad := REP->cNomEmpRep+SPACE(15)
		    cCiuRad := REP->cCiuEmpRep+SPACE(5)
		    cCiuRes := REP->cCiuResRep+SPACE(5)
		    cDirRes := REP->cDirResRep+SPACE(30)
		    cTelRes := REP->cTelResRep+SPACE(2)
		    cCiuTra := REP->cCiuTraRep+SPACE(5)
		    cDirTra := cDirRes
		    cTelTra := REP->cTelTraRep+SPACE(2)
		    cCiuEnv := REP->cCiuEnvRep+SPACE(5)
		    cDirEnv := REP->cDirEnvRep+SPACE(30)



		    REPL TXT->cCodEmpCon WITH EMP->cCodEmpCon
		    REPL TXT->cCodigoEst WITH REP->cCodigoEst
		    REPL TXT->cCodigoGru WITH REP->cCodigoGru
		    REPL TXT->cVerSisRep WITH REP->cVerSisRep
		    REPL TXT->cAnoSisRep WITH REP->cAnoSisRep
		    REPL TXT->nMesRepRep WITH REP->nMesRepRep
		    REPL TXT->nMesIniPag WITH REP->nMesIniPag
		    REPL TXT->nMesFinPag WITH REP->nMesFinPag
		    REPL TXT->cCodigoRep WITH REP->cCodigoRep
		    REPL TXT->cDocNitRep WITH REP->cDocNitRep
		    REPL TXT->cNovedaRep WITH REP->cNovedaRep
		    REPL TXT->nValidoRep WITH REP->nValidoRep

		    REPL TXT->nRegPagRep WITH REP->nRegPagRep
		    REPL TXT->cNomUsrPag WITH REP->cNomUsrPag
		    REPL TXT->dFecUsrPag WITH REP->dFecUsrPag
		    REPL TXT->cHorUsrPag WITH REP->cHorUsrPag

		    REPL TXT->nNroCntDaA WITH REP->nNroCntDaA
		    REPL TXT->nTipRepDaA WITH REP->nTipRepDaA
		    REPL TXT->nValCntDaA WITH REP->nValCntDaA

		    REPL TXT->cRegistTxt WITH;
			 REP->cTipNitRep+;       // 2.1  Tipo de Identificaci¢n
			 REP->cDocNitRep+;       // 2.2  N£mero de Identificaci¡n
			 REP->cCodigoRep+;       // 2.3  N£mero de la Cuenta
			 REP->cNombreRep+;       // 2.4  Nombre Completo
			 '0'+;                   // 2.5  Situaci¢n del Titular. 0=>Normal
			 REP->cFecApeRep+'01'+;  // 2.6  Fecha de Apertura
			 REP->cFecVtoRep+'30'+;  // 2.7  Fecha de Vencimiento
			 cFiador+;               // 2.8  Responsable o Calidad de deudor
			 REP->cTipCtaRep+;       // 2.9  Tipo de Obligaci¢n
			 '0'+;                   // 2.10 Subsidio Hipotecario
			 cFecSub+;               // 2.11 Fecha de Subsidio
			 '1'+;                   // 2.12 Termino del Contrato que genera la obligaci¢n. 1=>Definido
			 REP->cForPagRep+;       // 2.13 Forma de Pago
			 REP->cPerPagRep+;       // 2.14 Periodicidad de Pago
			 REP->cNovedaRep+;       // 2.15 Novedad
			 '0'+;                   // 2.16 Estado origen de la cuenta. 0=>Normal
			 cFecOri+;               // 2.17*Fecha Estado de la cuenta
			 cEstCta+;               // 2.18*Estado de la cuenta
			 cFecEst+;               // 2.19*Fecha estado de la cuenta
			 '0'+;                   // 2.20*Estado del Plastico
			 '00000000'+;            // 2.21*Fecha estado del plastico
			 '0'+;                   // 2.22 Adjetivo
			 '00000000'+;            // 2.23 Fecha del adjetivo
			 '0'+;                   // 2.24*Clase Tarjeta
			 '0'+;                   // 2.25*Franquicia 0
			 REPL('0',30)+;          // 2.26*Nombre Marca Privada
			 REP->cTipMonRep+;       // 2.27 Tipo Moneda
			 REP->cTipGarRep+;       // 2.28 Tipo de Garant¡a
			 REP->cCalifiRep+' '+;   // 2.29*Calificaci¢n
			 '000'+;                 // 2.30*Probabilidad de incumplimiento
			 REP->cEdaMorRep+;       // 2.31 Edad de Mora o Pago Total
			 '0'+REP->cVlrIniRep+;   // 2.32 Valor Inicial
			 '0'+REP->cSdoActRep+;   // 2.33 Valor Saldo Deuda
			 '0'+REP->cVlrDisRep+;   // 2.34 Valor Disponible
			 '0'+REP->cVlrMenRep+;   // 2.35 Valor Couta Mensual
			 '0'+REP->cSdoMorRep+;   // 2.36 Valor Saldo Mora
			 REP->cTotCouRep+;       // 2.37 Total Coutas
			 REP->cCouPagRep+;       // 2.38 Coutas Canceladas
			 REP->cCouMorRep+;       // 2.39 Coutas en Mora
			 '000'+;                 // 2.40 Clausula de permanencia
			 '00000000'+;            // 2.41 Fecha Clausula de permanencia
			 REP->cFecActRep+;       // 2.42 Fecha l¡mite de pago
			 REP->cFecPagRep+;       // 2.43 Fecha de Pago
			 cOfiRad+;               // 2.44 Oficina de Radicaci¢n
			 cCiuRad+;               // 2.45 Ciudad de Radicaci¢n
			 '00000000'+;            // 2.46 C¢digo Dane Ciudad de Radicaci¢n
			 cCiuRes+;               // 2.47 Ciudad de residencia
			 '00000000'+;            // 2.48 C¢digo Dane Ciudad de residencia
			 REPL(' ',20)+;          // 2.49 Departamento Residencia
			 cDirRes+;               // 2.50 Direcci¢n de residencia
			 cTelRes+;               // 2.51 Telefono de residencia
			 cCiuTra+;               // 2.52 Ciudad Laboral
			 '00000000'+;            // 2.53 C¢digo Dane Ciudad Laboral
			 REPL(' ',20)+;          // 2.54 Departamento Laboral
			 cDirTra+;               // 2.55 Direcci¢n laboral
			 cTelTra+;               // 2.56 Telefono Laboral
			 cCiuEnv+;               // 2.57 Ciudad de Correspondencia
			 '00000000'+;            // 2.58 C¢digo Dane Ciudad Correspondencia
			 REPL(' ',20)+;          // 2.59 Departamento Correspondencia
			 cDirEnv+;               // 2.60 Direcci¢n de Correspondencia
			 REPL(' ',60)+;          // 2.61 Correo Electr¢nico
			 cTelRes+;               // 2.62 Celular
			 cSuscri+;               // 2.63 Suscriptor Destino
			 REPL(' ',37)            // 2.64 Filler

		    nTotReg++
		    TXT->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABA EL REGISTRO DE CONTROL')
		 ENDIF
		 IF lShared
		    TXT->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DEL REGISTRO

*--------------LINEA DE ESTADO
		 LineaEstado('A¥O : '+cAnoUsr+;
			     'ºEMP: '+STR(EMP->(RECNO()),4)+'/'+;
				      STR(EMP->(RECCOUNT()),4)+;
			     'ºCODIGO: '+REP->cCodigoEst+;
			     'º'+EMP->cCodEmpCon+':'+;
				 STR(REP->(RECNO()),4)+'/'+;
				 STR(REP->(RECCOUNT()),4),cNomSis)
*--------------FIN LINEA DE ESTADO

*--------------AVANCE DEL REGISTRO
		 SELECT REP
		 REP->(DBSKIP())
*--------------FIN AVANCE DEL REGISTRO

	    ENDDO
**********FIN RECORRIDO DE LOS REGISTROS

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT EMP
	    EMP->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       CloseDbf('SDA')
       CloseDbf('EMP')
       CloseDbf('REP')
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>REGISTRO FINAL
       nTotReg++
       cTotReg := STR(nTotReg,8)
       lCorrecion(@cTotReg)

       cTotNov := STR(nTotNov,8)
       lCorrecion(@cTotNov)

       aFecHoy := aFecha(dFecHoy)
       cRegFin := REPL('Z',18)+;                     // 018 Identificador
		  aFecHoy[3]+aFecHoy[1]+aFecHoy[2]+; // 026 Fecha de Proceso
		  cTotReg+;                          // 034 N£mero de Registros
		  cTotNov+;                          // 042 Sumatoria de Novedades
		  REPL('0',758)                      // Filler
*>>>>FIN REGISTRO FINAL

*>>>>GRABACION DEL REGISTRO FINAL
       IF TXT->(lRegLock(lShared,.T.))
	  REPL TXT->cRegistTxt WITH cRegFin
	  REPL TXT->cVerSisRep WITH cVerSis
	  REPL TXT->nValidoRep WITH TXT->nValidoRep+1

	  TXT->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO DE CONTROL')
       ENDIF
       IF lShared
	  TXT->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DEL REGISTRO FINAL


*>>>>REGISTRO DE CONTROL
       cRegIni := REPL('H',18)+;       // 018 Indicador de Registro Inicial
		  cSuscri+;            // 024 C¢digo del Suscriptor
		  cTipCta+;            // 026 Tipo de Cuenta
		  cFecPrn+;            // 034 Fecha de Corte
		  'M'+;                // 035 Ampliaci¢n Milenio
		  '0'+;                // 036 Indicador de Valores de Miles
		  'T'+;                // 037 Tipo de Entrega
		  REPL('0',8)+;        // 045 Fecha de Inicio Reporte
		  REPL('0',8)+;        // 053 Fecha de Fin Reporte
		  'N'+;                // 054 Indicador de Partir
		  REPL('0',746)        // 800 Filler
*>>>>FIN REGISTRO DE CONTROL


*>>>>GRABACION DEL REGISTRO DE CONTROL
       TXT->(DBGOTOP())
       IF TXT->(lRegLock(lShared,.F.))
	  REPL TXT->cRegistTxt WITH cRegIni
	  REPL TXT->cVerSisRep WITH cVerSis
	  REPL TXT->nValidoRep WITH TXT->nValidoRep+1
	  TXT->(DBCOMMIT())
	  nTotReg++
       ELSE
	  cError('NO SE GRABA EL REGISTRO DE CONTROL')
       ENDIF
       IF lShared
	  TXT->(DBUNLOCK())
       ENDIF

       SELECT TXT
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO DE CONTROL

/*************************************************************************
* TITULO..: CREACION DEL ARCHIVO ASCII                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 26/2004 ABR A
       Colombia, Bucaramanga        INICIO: 04:00 PM   ABR 26/2004 ABR

OBJETIVOS:

1- Crea el archivo ASCII con los registros que van reportar a DataCr‚dito.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTxt012(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		    cJorTxt,cVerSis,cMesIni,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       cVerSis	                            // Versi¢n del Sistema
       cMesIni                              // Mes Inicial
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cVerUno := ''                  // Versi¢n uno
       LOCAL cVerDos := ''                  // Versi¢n dos

       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
     *ÀVariables de informe


       LOCAL nNroArc := 0                   // N£mero del Archivo
       LOCAL cRegTxt := ''                  // Texto del registro
       LOCAL nByeWri := 0                   // Bytes Escritos
       LOCAL lGraReg := .F.                 // Grabar el Registro
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas 
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TXT->(RECCOUNT()) == 0
	    cError('NO SE HAN CREADO LOS REGISTROS A REPORTAR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>VALIDACION DE LOS REGISTROS
       IF .NOT. lValidoRep()
	  cError('EXISTEN REGISTROS SIN CONFIRMACION')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LOS REGISTROS

*>>>>VALIDACION DE LA VERSION
       SELECT TXT
       TXT->(DBGOTOP())
       DO WHILE .NOT. TXT->(EOF())

	  cVerUno := ALLTRIM(cVerSis)
	  cVerDos := ALLTRIM(TXT->cVerSisRep)

	  IF !(cVerUno == cVerDos)

	     cError('LA VERSION:'+ALLTRIM(TXT->cVerSisRep)+' '+;
		    'NO COINCIDE CON LA DEL SISTEMA')

	     RETURN NIL

	  ENDIF

	  SELECT TXT
	  TXT->(DBSKIP())
       ENDDO
       TXT->(DBGOTOP())
*>>>>FIN VALIDACION DE LA VERSION

*>>>>DEFINCION DEL ENCABEZADO
       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'REPORTE A DATACREDITO',;
		   'MES DE '+cMes(VAL(cMesIni),10)}
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aTitPrn := {'No.','CODIGO','GRUPO','A¥O',;
		   '123456789 123456789 123456789 123456789 123456789 '+;
		   '123456789 123456789 123456789 123456789 123456789 '+;
		   '123456789 123456789 123456789 123456789 123456789 '+;
		   '123456789 123456789 123456789 123456789 123456789 '+;
		   '123456789 123456789 123456789 123456789 123456789 '+;
		   '123456789 123456789 123456789 123456789 123456789 '+;
		   '123456789 123456789 123456789 123456789 123456789 '+;
		   '123456789 123456789 123456789 '}
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ACTIVACION DE LA IMPRESORA
       FilePrn := cPatSis+'\'+FileTxt+cMesIni+'.xml'

       AADD(aCabPrn,cFecha(DATE())) // Fecha
       AADD(aCabPrn,TIME())         // Hora
       AADD(aCabPrn,'')             // D¡a

       nHanXml := nOpenXml(FilePrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>CREACION DEL ARCHIVO
       FileTem := cPatSis+'\'+FileTxt+cMesIni+'.txt'
       nNroArc := FCREATE(FileTem,0)
       IF nNroArc == -1
	  cError('NO SE PUEDE CREAR EL ARCHIVO '+FileTem)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT TXT
       TXT->(DBGOTOP())
       DO WHILE .NOT. TXT->(EOF())

**********GRABACION DE LA CABECERA DEL ARCHIVO
	    cRegTxt := TXT->cRegistTxt+CHR(13)+CHR(10)
	    nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
	    IF nByeWri # LEN(cRegTxt)
		cError('GRABACION DE LA CABECERA')
		EXIT
	    ENDIF
**********FIN GRABACION DE LA CABECERA DEL ARCHIVO

**********LINEA DE ESTADO
	    LineaEstado('A¥O : '+cAnoUsr+;
			'ºREGISTRO: '+STR(TXT->(RECNO()),4)+'/'+;
				      STR(TXT->(RECCOUNT()),4)+;
			'ºCODIGO: '+TXT->cCodigoEst,cNomSis)
**********FIN LINEA DE ESTADO

**********IMPRESION DEL REGISTRO
	    aRegPrn := {STR(TXT->(RECNO()),6),;
			TXT->cCodEmpCon+TXT->cCodigoEst,;
			TXT->cCodigoGru,;
			TXT->cAnoSisRep,;
			TXT->cRegistTxt}

	    SaveRegXml(FilePrn,nHanXml,aRegPrn,aTitPrn)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT TXT
	    TXT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)

       CloseXml(FilePrn,nHanXml)

       SELECT TXT
       TXT->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS REGISTROS

/*************************************************************************
* TITULO..: VERIFICAR LOS REGISTROS REGISTRADOS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 26/2006 ABR A
       Colombia, Bucaramanga        INICIO: 09:45 PM   ENE 26/2006 ABR

OBJETIVOS:

1- Valida si todos los registros se encuentran registrados

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValidoRep()

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS REGISTROS
       SELECT TXT
       TXT->(DBGOTOP())
       DO WHILE .NOT. TXT->(EOF())

**********ANALISIS DEL REGISTRO
	    IF TXT->nValidoRep == 0
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN ANALISIS DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT TXT
	    TXT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RETURN !lHayErr
*>>>>FIN VALIDACION DE LOS REGISTROS