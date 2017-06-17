/*                       SIMA - SISTEMA CENTRAL DE RIESGOS
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION DATAaaaa

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 05:00 PM   ENE 19/2004 LUN

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDatAno(lShared,nModCry,PathArc,fArchvo,aStrDbf)

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
       AADD(aDbfStr,{'cIntUnoDaA','Character',70,0}) // Path de Integraci¢n No. 1
       AADD(aDbfStr,{'cIntDosDaA','Character',70,0}) // Path de Integraci¢n No. 2
       AADD(aDbfStr,{'cIntTreDaA','Character',70,0}) // Path de Integraci¢n No. 3
       AADD(aDbfStr,{'cIntCuaDaA','Character',70,0}) // Path de Integraci¢n No. 4
       AADD(aDbfStr,{'cMaeHabDaA','Character',09,0}) // Maestros Habilitados para el A¤o
       AADD(aDbfStr,{'cJorHabDaA','Character',04,0}) // Jornadas Habilitadas
       AADD(aDbfStr,{'nTotCouDaA','Numeric'  ,03,0}) // Total Coutas
       AADD(aDbfStr,{'nNroCntDaA','Numeric'  ,01,0}) // N£mero de Contratantes a Reportar
       AADD(aDbfStr,{'nTipRepDaA','Numeric'  ,01,0}) /* Tipo de Reporte.
							1 => Teniedo en cuenta los contratantes no definidos
							2 => Descartando los contratantes no definidos */

       AADD(aDbfStr,{'nValCntDaA','Numeric'  ,01,0}) /* Validar Contrantes
							1 => Validar Primer Contratante
							2 => Validar Segunto Contratante
							3 => Validar Tercer Contratante
							4 => Validar Cuarto Contratante
							9 => No Validar Contratantes */
       AADD(aDbfStr,{'cValRepDaA','Character',12,0}) // Validaci¢n del Reporte. Un caracter por mes. '0'=>No Validado '1'=>Valido

       AADD(aDbfStr,{'nMesPlzDaA','Numeric'  ,01,0}) // Meses de plazo
*>>>>FIN DECLARACION DE LA ESTRUCTURA

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
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'DAA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseDbf('DAA',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF DAA->(lRegLock(lShared,.T.))
	  REPL DAA->cIntUnoDaA WITH '\Sima\SimaCont'
	  REPL DAA->cIntDosDaA WITH '\Sima\SimaCart'
	  REPL DAA->cIntTreDaA WITH '\Sima\SimaMatr'
	  REPL DAA->cIntCuaDaA WITH ''
	  DAA->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
       ENDIF
       IF lShared
	  DAA->(DBUNLOCK())
       ENDIF
       CloseDbf('DAA',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 05:05 PM   ENE 19/2004 LUN

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDatAno(lShared,nModCry,PathArc,fArchvo)

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
       CreaDatAno(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 05:10 PM   ENE 19/2004 LUN

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

FUNCTION nActStrAno(lShared,nModCry,PathArc,cNomArc)

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
       CreaDatAno(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
			 {||CreaDatAno(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: LECTURAS PATHS DE INTEGRACION                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 05:15 PM   ENE 19/2004 LUN

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathDatAno(lShared,cPatSis,cAnoUsr,cIntUno,;
		    cIntDos,cIntTre,cIntCua,nModCry,lPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del sistema
       cAnoUsr                              // A¤o del Usuario
       cIntUno                              // @Path de Integraci¢n uno
       cIntDos                              // @Path de Integraci¢n dos
       cIntTre                              // @Path de Integraci¢n tres
       cIntCua                              // @Path de Integraci¢n cuatro
       nModCry                              // Modo de Protecci¢n
       lPatSis                              // .T. Incluir Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cNalias := ''                  // Nombre del Alias
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       IF VALTYPE(nModCry) != 'N'
	  cError('NO ES NUMERICO EL PARAMETRO EN LOS PATHS DE INTEGRACCION')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>ANALISIS DEL ALIAS
       IF ALIAS(SELECT('DAA')) == 'DAA'
	  cNalias := 'DAA'
       ELSE
	  cNalias := 'ANO'
       ENDIF
*>>>>FIN ANALISIS DEL ALIAS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF cNalias == 'ANO'
	  IF !lUseDbf(.T.,cPatSis+'\'+;
			  FDatAno+cAnoUsr+ExtFile,cNalias,NIL,lShared,nModCry)
	     cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	     CloseDbf(cNalias,cPatSis+'\'+FDatAno+cAnoUsr+ExtFile,nModCry)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT &cNalias
       GO TOP
       lPatSis := IF(lPatSis == NIL,.T.,lPatSis)
       cIntUno := ALLTRIM(&cNalias->cIntUnoDaA)+IF(lPatSis,'\'+cPatSis,'')
       cIntDos := ALLTRIM(&cNalias->cIntDosDaA)+IF(lPatSis,'\'+cPatSis,'')
       cIntTre := ALLTRIM(&cNalias->cIntTreDaA)+IF(lPatSis,'\'+cPatSis,'')
       cIntCua := ALLTRIM(&cNalias->cIntCuaDaA)+IF(lPatSis,'\'+cPatSis,'')
       IF cNalias == 'ANO'
	  CloseDbf(cNalias,cPatSis+'\'+FDatAno+cAnoUsr+ExtFile,nModCry)
       ENDIF
       RETURN NIL
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 05:20 PM   ENE 19/2004 LUN

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManDatAno(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt)

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
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL oBrowse := NIL                 // Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+;
		       fSimDat,'SDA',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FDatAno+cAnoUsr+ExtFile,'DAA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseDbf('DAA',cPatSis+'\'+FDatAno+cAnoUsr+ExtFile,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwDatAno(lShared,cAnoUsr,nFilPal+1,00,22,79)
       DAA->(CtrlBrw(lShared,oBrowse))
       CloseDbf('DAA',cPatSis+'\'+FDatAno+cAnoUsr+ExtFile,nModCry)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 05:25 PM   ENE 19/2004 LUN

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwDatAno(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,;
		    nColInf,lIntUno,lIntDos,lIntTre,lIntCua)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n */
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
       oBrowse:Cargo     := {'<< CONFIGURACION DEL A¥O: '+cAnoUsr+' >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT DAA
       oColumn	:= TBCOLUMNNEW('PATH DE SIMACONT',{||DAA->cIntUnoDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','cIntUnoDaA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE SIMACART',{||DAA->cIntDosDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','cIntDosDaA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE SIMAMATR',{||DAA->cIntTreDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','cIntTreDaA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MAESTROS;HABILITADOS',{||DAA->cMaeHabDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','cMaeHabDaA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('JORNADAS;HABILITADAS',{||DAA->cJorHabDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','cJorHabDaA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TOTAL;COUTAS',{||DAA->nTotCouDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','nTotCouDaA'}, {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CONTRATANTES;A REPORTAR',{||DAA->nNroCntDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','nNroCntDaA'}, {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TIPO DE;REPORTE',{||DAA->nTipRepDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','nTipRepDaA'}, {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALIDAR;CONTRATANTES',{||DAA->nValCntDaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			 {'FIELD','nValCntDaA'}, {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALIDAR;REPORTE',{||DAA->cValRepDaA})
       IF SDA->nPruebaDat == 0
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS','DAA'},;
			    {'FIELD','cValRepDaA'}, {'PICTURE','999999999999'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			    {'FIELD','cValRepDaA'}, {'PICTURE','999999999999'}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MESES DE;PLAZO',{||DAA->nMesPlzDaA})
       IF SDA->nPruebaDat == 0
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS','DAA'},;
			    {'FIELD','nMesPlzDaA'}, {'PICTURE','9'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DAA'},;
			    {'FIELD','nMesPlzDaA'}, {'PICTURE','9'}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: VALIDAR EL TOTAL DE COUTAS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2004 LUN A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ABR 20/2004 LUN

OBJETIVOS:

1- Valida el total del n£mero de coutas de un intervalo de a¤os.

2- Retorn .T. Si no hay problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValTotCou(lShared,nModCry,cPatSis,fDatAno,ExtFile,nAnoIni,nAnoFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Integraci¢n
       cPatSis                              // Path del Sistema
       fDatAno                              // Archivo del Nivel
       ExtFile                              // Extensi¢n del Archivo
       nAnoIni                              // A¤o Inicial de Validaci¢n
       nAnoFin                              // A¤o Final de Validaci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL     i,j := 0                   // Contador
       LOCAL cAnoUsr := ''                  // A¤o Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS PARA CADA A¥O
       FOR j := nAnoIni TO nAnoFin

***********SELECION DE LAS AREAS DE TRABAJO
	     cAnoUsr := STR(j,4)
	     cPatSis := STR(j,4)+SUBS(cPatSis,5,4)

	     IF !lUseDbf(.T.,cPatSis+'\'+;
			     FDatAno+cAnoUsr+ExtFile,'DAA',NIL,;
			     lShared,nModCry)
		cError('ABRIENDO EL ARCHIVO DEL A¥O '+cAnoUsr)
		CloseDbf('DAA')
		RETURN .F.
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE DAA->(RECCOUNT()) == 0
		  cError('NO EXISTE CONFIGURACION DEL A¥O '+cAnoUsr)

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseDbf('DAA')
		RETURN .F.
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********ANALISIS DE VALIDACION
	     SELECT DAA
	     DAA->(DBGOTOP())
	     lHayErr :=.F.
	     DO WHILE .NOT. DAA->(EOF())

		IF DAA->nTotCouDaA == 0
		   lHayErr := .T.
		   EXIT
		ENDIF

		DAA->(DBSKIP())

	     ENDDO

	     IF lHayErr
		cError('NO SE HA DEFINIDO EL TOTAL DE COUTAS PARA '+cAnoUsr)
		EXIT
	     ENDIF
***********FIN ANALISIS DE VALIDACION

       ENDFOR
       CloseDbf('DAA')
       RETURN !lHayErr
*>>>>FIN ANALISIS PARA CADA A¥O

/*************************************************************************
* TITULO..: VALIDAR EL MES DEL REPORTE                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 07/2009 LUN A
       Colombia, Bucaramanga        INICIO: 02:00 PM   SEP 07/2009 LUN

OBJETIVOS:

1- Valida el mes a generar el reporta.

2- Verifica con los meses anteriores a mes a generar este confirmados

2- Retorn .T. Si no hay problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValRep(cValRep,nMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     cValRep                              // Validaci¢n del reporte
       nMesIni                              // Mes Inicial del reporte */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL REPORTE
       FOR i := 1 TO nMesIni-1
	   IF VAL(SUBS(cValRep,i,1)) < 2
	      cError(cMes(i)+' NO HA SIDO VALIDADO')
	      lHayErr := .T.
	   ENDIF
       ENDFOR
       RETURN !lHayErr
*>>>>FIN VALIDACION DEL REPORTE

