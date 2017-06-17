/*                       SIMA - MATRICULA ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION SIMAMATR

REQUERIMIENTOS:

- Compilar: clipper fSimaCon /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:15 AM   JUL 19/96 VIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfCon(PathCon,fSimaCo+cAnoUsr+ExtFile+cAnoUsr+ExtFile,lIntUno,fNtxCon)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaSimCon(lShared,PathCon,fSimaCo,lIntUno,fNtxCon,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathCon				    // Path del Archivo
       fSimaCo				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxCon				    // Archivo de Indices
       aStrDbf                              // Structura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       AADD(aDbfStr,{'cCodEmpCon','Character',03,0}) // C¢digo de la Empresa
       AADD(aDbfStr,{'nCodEmpCon','Numeric'  ,02,0}) // C¢digo de la Empresa
       AADD(aDbfStr,{'cEmpMvtCon','Character',03,0}) // C¢digo de la Empresa para la contabilida
       AADD(aDbfStr,{'cNomEmpCon','Character',40,0}) // Nombre de la Empresa
       AADD(aDbfStr,{'cCiuEmpCon','Character',20,0}) // Ciudad de la Empresa
       AADD(aDbfStr,{'cNroNitCon','Character',14,0}) // N£mero del Nit
       AADD(aDbfStr,{'cCodEanCon','Character',13,0}) // C¢digo EAN-13 de la Empresa
       AADD(aDbfStr,{'cDireccCon','Character',40,0}) // Direcci¢n
       AADD(aDbfStr,{'cTelef1Con','Character',12,0}) // Telefono Uno
       AADD(aDbfStr,{'cTelef2Con','Character',12,0}) // Telefono Dos
       AADD(aDbfStr,{'cNroFaxCon','Character',12,0}) // Telefono Tres
       AADD(aDbfStr,{'cGerentCon','Character',50,0}) // Nombre del Gerente o Rector Actual
       AADD(aDbfStr,{'cCarGerCon','Character',50,0}) // Nombre del Cargo
       AADD(aDbfStr,{'cNitGerCon','Character',40,0}) // Documento de Gerente
       AADD(aDbfStr,{'cSecretCon','Character',50,0}) // Nombre de la Secretaria Actual
       AADD(aDbfStr,{'cCarSecCon','Character',50,0}) // Nombre del Cargo
       AADD(aDbfStr,{'cNitSecCon','Character',40,0}) // Documento de la Secretaria
       AADD(aDbfStr,{'cSerFacCon','Character',15,0}) // Servicio Facturado.
       AADD(aDbfStr,{'lPrnArcCon','Logical'  ,01,0}) // .T. Imprimir en la impresora
       AADD(aDbfStr,{'nCodigoPrn','Numeric'  ,04,0}) // C¢digo de la Impresora
       AADD(aDbfStr,{'cOpcPrnCon','Character',04,0}) // Opciones de Impresi¢n
       AADD(aDbfStr,{'nCodigoClr','Numeric'  ,02,0}) // C¢digo del Color
       AADD(aDbfStr,{'lModPlaCon','Logical'  ,01,0}) // .T. Modificar el c¢digo de las materias en el plan
       AADD(aDbfStr,{'lAreProCon','Logical'  ,01,0}) // .T. El area tiene asignado un profesor.
       AADD(aDbfStr,{'nOpcCerCon','Numeric  ',02,0}) // Opci¢n de impresi¢n de los Certificados
       AADD(aDbfStr,{'nAnoIniCon','Numeric  ',04,0}) // A¤o Inicial habilitado para Certificados
       AADD(aDbfStr,{'nAnoFinCon','Numeric  ',04,0}) // A¤o Final habilitado para Certificados
       AADD(aDbfStr,{"nEmpMvtCon","Numeric"  ,02,0}) // Empresa movimientos contables
       AADD(aDbfStr,{'lHayNroCon','Logical'  ,01,0}) // .T. Controlar N£mero Consecutivo
       AADD(aDbfStr,{'nNroFacCon','Numeric'  ,09,0}) // N£mero Consecutivo de la Factura
       AADD(aDbfStr,{'cTitNroCon','Character',40,0}) // T¡tulo para el n£mero de la factura. Ej: Recibo No. FACTURA No.
       AADD(aDbfStr,{'cCenCosCon','Character',04,0}) // Centro de Costos
       AADD(aDbfStr,{'cSubCenCon','Character',04,0}) // Sub Centro de Costos
       AADD(aDbfStr,{'nPrnBolPrn','Numeric'  ,04,0}) // C¢digo de la Impresora para Boletines
       AADD(aDbfStr,{'nPrnCerPrn','Numeric'  ,04,0}) // C¢digo de la Impresora para certificados
       AADD(aDbfStr,{'nNroCerCon','Numeric'  ,16,0}) // N£mero de Certificados
       AADD(aDbfStr,{'cIsoBolCon','Character',20,0}) // C¢digo Iso para el Boletin
       AADD(aDbfStr,{'nSpaBolCon','Numeric'  ,02,0}) // Espacios para el Boletin
       AADD(aDbfStr,{'nNo1IzqCon','Numeric  ',02,0}) // Margen Inquierdo para las notas No. 1
       AADD(aDbfStr,{'nNo2IzqCon','Numeric  ',02,0}) // Margen Inquierdo para las notas No. 2
       AADD(aDbfStr,{'nMarIzqCon','Numeric  ',02,0}) // Margen Inquierdo
       AADD(aDbfStr,{'nMarDerCon','Numeric  ',03,0}) // Margen Derecho
       AADD(aDbfStr,{'nSupCerCon','Numeric  ',02,0}) // Margen Superior para el Certificado
       AADD(aDbfStr,{'nInfCerCon','Numeric  ',02,0}) // Margen Inferior para el Certificado
       AADD(aDbfStr,{'nObsCerCon','Numeric  ',02,0}) // Margen Inferior para la Observaci¢n del Certificado
       AADD(aDbfStr,{'lOficioCon','Logical  ',01,0}) // .T. Certificado tama¤o oficio
       AADD(aDbfStr,{'lValAusCon','Logical  ',01,0}) // Validar ausencias en el certificado
       AADD(aDbfStr,{'nHojObsCon','Numeric'  ,02,0}) // N£mero de la Hoja del Observador
       AADD(aDbfStr,{'cTxtLibCon','Character',300,0}) // Texto para el libro o Boletin No. 0
       AADD(aDbfStr,{'cTxtLi1Con','Character',300,0}) // Texto para el libro o Boletin No. 1
       AADD(aDbfStr,{'cPiePagCon','Character',256,0}) // Pie de p gina para los informes
       AADD(aDbfStr,{'cColaAcCon','Character',02,0}) // Cola de Impresi¢n Activada
       AADD(aDbfStr,{'lModColCon','Logical'  ,01,0}) // .T. Modificar la Cola Activada
       AADD(aDbfStr,{'cCola01Con','Character',20,0})
       AADD(aDbfStr,{'cCola02Con','Character',20,0})
       AADD(aDbfStr,{'cCola03Con','Character',20,0})
       AADD(aDbfStr,{'cCola04Con','Character',20,0})
       AADD(aDbfStr,{'cCola05Con','Character',20,0})
       AADD(aDbfStr,{'cCola06Con','Character',20,0})
       AADD(aDbfStr,{'cCola07Con','Character',20,0})
       AADD(aDbfStr,{'cCola08Con','Character',20,0})
       AADD(aDbfStr,{'cCola09Con','Character',20,0})
       AADD(aDbfStr,{'cCola10Con','Character',20,0})
       AADD(aDbfStr,{'lPruebaCon','Logical',01,0})

       AADD(aDbfStr,{'nCabIsoSco','Numeric'  ,002,0}) // Encabezado Iso
       AADD(aDbfStr,{'cLogEmpSco','Character',012,0}) // Logo de la Empresa
       AADD(aDbfStr,{'cUsrIsoSco','Character',010,0}) // Usuario del Iso
       AADD(aDbfStr,{'nCodXslSco','Numeric'  ,002,0}) // C¢digo Xsl informes
       AADD(aDbfStr,{'cPiePagSco','Character',255,0}) // Pie de p gina informes

       AADD(aDbfStr,{'nPruebaSco','Numeric'  ,002,0}) // Habilitar pruebas

       AADD(aDbfStr,{'nCodEstSco','Numeric'  ,03,0}) // Posici¢n del c¢digo del Estudiante
       AADD(aDbfStr,{'nLenCodSco','Numeric'  ,03,0}) // Longitud del C¢digo del Estudiante.
       AADD(aDbfStr,{'nCodTipSco','Numeric'  ,03,0}) // Posici¢n del Tipo de Personal
       AADD(aDbfStr,{'nLenTipSco','Numeric'  ,03,0}) // Longitud del Tipo de Personal.
       AADD(aDbfStr,{'nNitPerSco','Numeric'  ,03,0}) // Posici¢n de la Cedula de la persona
       AADD(aDbfStr,{'nLenNitSco','Numeric'  ,03,0}) // Longitud de la Cedula de la persona
       AADD(aDbfStr,{'nTipNitSco','Numeric'  ,03,0}) // Posici¢n Tipo de documento
       AADD(aDbfStr,{'nLenTniSco','Numeric'  ,03,0}) // Longitud Tipo de documento
       AADD(aDbfStr,{'cTipCodSco','Character',02,0}) // // Tipo de Codigo. Espacios por defecto. 01=>De acuerdo a las posiciones
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCon) == 0
	    DBCREATE(fSimaCo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathCon) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCon)

       CASE DIRCHANGE(PathCon) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCon)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathCon+'\'+fSimaCo,'CON',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DE MATRICULAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF CON->(lRegLock(lShared,.T.))
	  REPL CON->nSupCerCon WITH 7
	  REPL CON->nInfCerCon WITH 52
	  REPL CON->nObsCerCon WITH 43
	  REPL CON->nNo1IzqCon WITH 0
	  REPL CON->nMarIzqCon WITH 0
	  REPL CON->nMarDerCon WITH 70
	  REPL CON->nNroCerCon WITH 1
	  REPL CON->lOficioCon WITH .F.
	  REPL CON->lValAusCon WITH .F.
	  REPL CON->lPrnArcCon WITH .F.
	  REPL CON->lModPlaCon WITH .F.
	  REPL CON->lAreProCon WITH .F.
	  REPL CON->nCodigoClr WITH 1
	  CON->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
       ENDIF
       IF lShared
	  CON->(DBUNLOCK())
       ENDIF
       CLOSE CON
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:28 AM   JUL 19/96 VIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuSimCon(lShared,PathCon,fSimaCo,lIntUno,fNtxCon)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathCon			      // Path del Archivo
       fSimaCo			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxCon			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCon+'\'+fSimaCo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DE LA MATRICULA")
       Termometro(100)

       CreaSimCon(lShared,PathCon,fSimaCo,lIntUno,fNtxCon)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 01/2000 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   JUN 01/2000 JUE

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrCon(lShared,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'CON',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION GENERAL')
	  CloseDbf('CON')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := CON->(DBSTRUCT())
       CloseDbf('CON')
       CreaSimCon(lShared,PathArc,cNomArc,,,@aStrNew)
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
	  cError('El Archivo CONFIG GENERAL CONTABILIDAD su Estructura Esta DesActualizada.',;
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
			 {||CreaSimCon(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:31 AM   JUL 19/96 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

MantenCon()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManSimCon(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		   cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		   PathUno,PathDos,PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt,;
		   cJornad,lBrwCon,lBrwCar)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       lBrwCon                              // .T. Browse de la Contabilidad
       lBrwCar                              // .T. Browse de la Cartera */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL oBrwCon := NIL                 // Objeto Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PATHS DEL SISTEMA
       PathSys := SUBS(PathUno,1,RAT('\',PathUno))+PathSys
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
       cIntTre := PathTre+'\'+cPatSis
       cIntCua := PathCua+'\'+cPatSis
       lBrwCar := IF(EMPTY(lBrwCar),.F.,lBrwCar)
       IF lBrwCar
	  PathSis := PathUno+'\'+PathSis
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DE GENERAL')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwCon := oDefSimCon(lShared,cAnoUsr,nFilPal+1,00,22,79,;
			     PathUno,PathDos,PathTre,PathCua,;
			     cMaeAlu,lBrwCon,lBrwCar)
       CON->(CtrlBrw(lShared,oBrwCon))
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF CON->lPrnArcCon .AND. lBrwCon
	  FileTem := cFileTempo(PathPrn+'\',SUBS(cNomUsr,1,4),'.PRN')
	  SET PRINTER TO &FileTem              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       CLOSE ALL
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:32 AM   JUL 19/96 VIE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefSimCon(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,;
		    nColInf,PathUno,PathDos,PathTre,PathCua,;
		    cMaeAlu,lBrwCon,lBrwCar)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       lBrwCon                              // Browse para la Contabilidad
       lBrwCar                              // Browse para la Cartera */
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
       oBrowse:Cargo     := {'<< CONFIGURACION GENERAL DEL SISTEMA >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       lBrwCon := IF(EMPTY(lBrwCon),.F.,lBrwCon)
       lBrwCar := IF(EMPTY(lBrwCar),.F.,lBrwCar)
       SELECT CON

       oColumn	     := TBCOLUMNNEW('CODIGO DE;LA EMPRESA', {||CON->cCodEmpCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cCodEmpCon'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('NOMBRE DE;LA EMPRESA', {||CON->cNomEmpCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cNomEmpCon'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NIT DE;LA EMPRESA', {||CON->cNroNitCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cNroNitCon'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CIUDAD DE;LA EMPRESA', {||CON->cCiuEmpCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cCiuEmpCon'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO EAN-13;PARA EL RECAUDO', {||CON->cCodEanCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cCodEanCon'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO EMPRESA;PARA FACTURAR', {||CON->nCodEmpCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','nCodEmpCon'}, {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DIRECCION;DE LA EMPRESA', {||CON->cDireccCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cDireccCon'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TELEFONO 1', {||CON->cTelef1Con})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cTelef1Con'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TELEFONO 2', {||CON->cTelef2Con})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cTelef2Con'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO FAX', {||CON->cNroFaxCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cNroFaxCon'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL RECTOR', {||CON->cGerentCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cGerentCon'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CARGO;DEL RECTOR', {||CON->cCarGerCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cCarGerCon'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA;DEL RECTOR', {||CON->cNitGerCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cNitGerCon'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DE LA;SECRETARIA', {||CON->cSecretCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cSecretCon'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CARGO DE LA;SECRETARIA', {||CON->cCarSecCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cCarSecCon'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA DE LA;SECRETARIA', {||CON->cNitSecCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cNitSecCon'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SERVICIO;FACTURADO', {||CON->cSerFacCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cSerFacCon'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('IMPRIMIR;EN ARCHIVO', {||CON->lPrnArcCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','lPrnArcCon'},{'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('CODIGO;IMPRESORA', {||CON->nCodigoPrn})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nCodigoPrn'},{'PICTURE','9999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('OPCIONES;IMPRESORA', {||CON->cOpcPrnCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cOpcPrnCon'},{'PICTURE','9999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('IMPRESORA;BOLETIN', {||CON->nPrnBolPrn})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nPrnBolPrn'},{'PICTURE','9999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('CONFIGURACION;DEL COLOR', {||CON->nCodigoClr})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nCodigoClr'},{'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF



       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('A¥O INICIAL;CERTIFICADO',;
					   {||CON->nAnoIniCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nAnoIniCon'},{'PICTURE','9999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('A¥O FINAL;CERTIFICADO',;
					    {||CON->nAnoFinCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nAnoFinCon'},{'PICTURE','9999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NUMERO DE;CERTIFICADOS',{||CON->nNroCerCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','nNroCerCon'},{'PICTURE','9999999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('OPCION DE IMPRESION;CERTIFICADO',;
					   {||CON->nOpcCerCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nOpcCerCon'},{'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('IMPRESORA;CERTIFICADO', {||CON->nPrnCerPrn})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nPrnCerPrn'},{'PICTURE','9999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('MARGEN SUPERIOR;PARA EL CERTIFICADO',;
					    {||CON->nSupCerCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nSupCerCon'}, {'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('MARGEN INFERIOR;PARA EL CERTIFICADO',;
					    {||CON->nInfCerCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nInfCerCon'}, {'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('MARGEN INFERIOR OBSERVACION;PARA EL CERTIFICADO',;
				  {||CON->nObsCerCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nObsCerCon'}, {'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('CODIGO ISO;BOLETIN',;
					    {||CON->cIsoBolCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cIsoBolCon'}, {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('ESPACIOS ISO;BOLETIN',{||CON->nSpaBolCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nSpaBolCon'}, {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('MARGEN IZQUIERDO 1;PARA LAS NOTAS',;
				 {||CON->nNo1IzqCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nNo1IzqCon'}, {'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('MARGEN IZQUIERDO 2;PARA LAS NOTAS',;
				 {||CON->nNo2IzqCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nNo2IzqCon'}, {'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('MARGEN IZQUIERDO;PARA EL CERTIFICADO',;
				 {||CON->nMarIzqCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nMarIzqCon'}, {'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('MARGEN DERECHO;PARA EL CERTIFICADO',;
				 {||CON->nMarDerCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nMarDerCon'}, {'PICTURE','999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('TAMA¥O OFICIO', {||CON->lOficioCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','lOficioCon'}, {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('VALIDAR;AUSENCIAS', {||CON->lValAusCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','lValAusCon'}, {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCar
	  oColumn  := TBCOLUMNNEW('EMPRESA MVT;CONTABLE', {||CON->nEmpMvtCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nEmpMvtCon'},{'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCar
	  oColumn	     := TBCOLUMNNEW('CODIGO DE LA;EMPRESA MVT', {||CON->cEmpMvtCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cEmpMvtCon'}, {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF lBrwCar
	  oColumn  := TBCOLUMNNEW('CENTRO;DE COSTO', {||CON->cCenCosCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cCenCosCon'},{'PICTURE','9999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCar
	  oColumn  := TBCOLUMNNEW('SUB CENTRO;DE COSTO', {||CON->cSubCenCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cSubCenCon'},{'PICTURE','9999'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCar
	  oColumn	:= TBCOLUMNNEW('HAY NUMERO;DE FACTURA',;
				      {||CON->lHayNroCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','lHayNroCon'},{'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF lBrwCar
	  oColumn  := TBCOLUMNNEW('NUMERO;FACTURA', {||CON->nNroFacCon})
	  IF CON->lHayNroCon
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			       {'FIELD','nNroFacCon'},{'PICTURE','@!'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCar
	  oColumn  := TBCOLUMNNEW('TITULO;FACTURA', {||CON->cTitNroCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cTitNroCon'},{'PICTURE','@S40'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna



       IF lBrwCon
	  oColumn := TBCOLUMNNEW('HOJA DEL;OBSERVADOR',;
					    {||CON->nHojObsCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nHojObsCon'}, {'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	:= TBCOLUMNNEW('OBSERVACION;PARA LIBRO',{||CON->cTxtLibCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cTxtLibCon'},{'PICTURE','@!S76'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	:= TBCOLUMNNEW('...OBSERVACION;PARA LIBRO',{||CON->cTxtLi1Con})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cTxtLi1Con'},{'PICTURE','@!S76'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('MODIFICAR;PLAN ESTUDIOS', {||CON->lModPlaCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','lModPlaCon'},{'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('AREAS CON;PROFESOR', {||CON->lAreProCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','lAreProCon'},{'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PIE DE PAGINA;POR DEFECTO', {||CON->cPiePagCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			 {'FIELD','cPiePagCon'},{'PICTURE','@S76'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('HABILITAR;MODIFICACION', {||CON->lPruebaCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','lPruebaCon'},{'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('ENCABEZADO;INFORMES ISO', {||CON->nCabIsoSco})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nCabIsoSco'},{'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('LOGO;EMPRESA', {||CON->cLogEmpSco})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cLogEmpSco'},{'PICTURE','@X'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('USUARIO ISO', {||CON->cUsrIsoSco})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cUsrIsoSco'},{'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('INFORMES;INTRANET', {||CON->nCodXslSco})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nCodXslSco'},{'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn	     := TBCOLUMNNEW('PIE DE PAGINA;POR DEFECTO', {||CON->cPiePagSco})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','cPiePagSco'},{'PICTURE','@S76'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF lBrwCon
	  oColumn := TBCOLUMNNEW('HABILITAR;PRUEBAS', {||CON->nPruebaSco})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			    {'FIELD','nPruebaSco'},{'PICTURE','99'}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

      oColumn := TBCOLUMNNEW('POSICION;CODIGO', {||CON->nCodEstSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','nCodEstSco'},{'PICTURE','999'}}
      oBrowse:ADDCOLUMN(oColumn)

      oColumn := TBCOLUMNNEW('ANCHO;CODIGO', {||CON->nLenCodSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','nLenCodSco'},{'PICTURE','999'}}
      oBrowse:ADDCOLUMN(oColumn)

      oColumn := TBCOLUMNNEW('POSICION;TIPO PERSONAL', {||CON->nCodTipSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','nCodTipSco'},{'PICTURE','999'}}
      oBrowse:ADDCOLUMN(oColumn)

      oColumn := TBCOLUMNNEW('ANCHO;TIPO PERSONAL', {||CON->nLenTipSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','nLenTipSco'},{'PICTURE','999'}}
      oBrowse:ADDCOLUMN(oColumn)

/*
      oColumn := TBCOLUMNNEW('POSICION;DOCUMENTO', {||CON->nNitPerSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','nNitPerSco'},{'PICTURE','999'}}
      oBrowse:ADDCOLUMN(oColumn)

      oColumn := TBCOLUMNNEW('ANCHO;DOCUMENTO', {||CON->nLenNitSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','nLenNitSco'},{'PICTURE','999'}}
      oBrowse:ADDCOLUMN(oColumn)

      oColumn := TBCOLUMNNEW('POSICION TIPO;DOCUMENTO', {||CON->nTipNitSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','nTipNitSco'},{'PICTURE','999'}}
      oBrowse:ADDCOLUMN(oColumn)

      oColumn := TBCOLUMNNEW('ANCHO TIPO;DOCUMENTO', {||CON->nLenTniSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','nLenTniSco'},{'PICTURE','999'}}
      oBrowse:ADDCOLUMN(oColumn)

*/

      oColumn := TBCOLUMNNEW('TIPO DE;CODIGO', {||CON->cTipCodSco})
      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},;
			{'FIELD','cTipCodSco'},{'PICTURE','99'}}
      oBrowse:ADDCOLUMN(oColumn)
    *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: LECTURA DEL CONSECUTIVO DEL NUMERO DEL RECIBO                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 10/2000 JUE A
       Colombia, Bucaramanga        INICIO: 08:00 PM   AGO 10/2000 JUE


1- Permite Consultar y cambiar el n£mero consecutivo del Recibo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeNroRec(lShared,nNroFil,nNroCol,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil				    // Fila de lectura
       nNroCol				    // Columna de lectura
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList:= {}                   // Variable del sistema

       LOCAL nNroFac := 0                   // N£mero del Recibo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS INTERESES POR MORA
       nNroFac := SCO->nNroFacCon+1
       @ nNroFil,nNroCol GET nNroFac PICT '999999999';
				     VALID nNroFac > 0 .AND.;
					   !lValCodRec(cAnoUsr,nNroFac)
       READ
*>>>>FIN LECTURA DE LOS INTERESES POR MORA

*>>>>GRABACION DEL NUMERO DE LA FACTURA
       SELECT SCO
       IF SCO->(lRegLock(lShared,.F.))
	  REPL SCO->nNroFacCon WITH --nNroFac
	  SCO->(DBCOMMIT())
	  IF lShared
	     SCO->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL NUMERO CONSECTUTIVO DEL RECIBO')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL NUMERO DE LA FACTURA

/*************************************************************************
* TITULO..: COLOR DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 02/2004 MAR A
       Colombia, Bucaramanga        INICIO: 06:00 PM   OCT 02/2004 MAR

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xClrSysCon(lShared,nModCry)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimaCo,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileClr,'CLR',NIL,lShared,nModCry})
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
       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DEL COLOR
       xClrSys := xColorSys(CON->nCodigoClr)
       CloseAll(aUseDbf)
       RETURN xClrSys
*>>>>FIN SELECCION DEL COLOR