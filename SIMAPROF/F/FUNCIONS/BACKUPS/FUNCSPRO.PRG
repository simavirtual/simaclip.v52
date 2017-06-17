/*                       SIMA - CONTABILIDAD PROFESORES
		 BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO PROFESOR

REQUERIMIENTOS:

- Compilar: clipper FuncsPro /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Profesor

FUNCIONES:


***************************************************************************
*----------------------- FUNCIONES DE SIMACONT ---------------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 01:20 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo Profesor

2)- Retorna NIL

SINTAXIS:

   CreaDbfPro(PathPro,FilePro,fNtxPro)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfPro(lShared,PathPro,FilePro,lIntUno,fNtxPro,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathPro				    // Path del Archivo
       FilePro				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxPro				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfStr := {}                  // Estructura del Archivo

       AADD(aDbfStr,{"cCodigoPro","Character", 06,0}) // C¢digo del profesor
       AADD(aDbfStr,{"cPasWwwPro","Character", 10,0}) // PassWord del Internet
       AADD(aDbfStr,{"cPasWorPro","Character", 10,0}) // PassWord del profesor
       AADD(aDbfStr,{"lCryPasPro","Logical"  , 01,0}) // .T. Encriptar el PassWord
       AADD(aDbfStr,{"lSiCrypPro","Logical"  , 01,0}) // .T. Clave Encrytada
       AADD(aDbfStr,{"cMaiProPro","Character", 40,0}) // E-MAIL del Profesor
       AADD(aDbfStr,{"nNroPerPro","Numeric"  , 02,0}) // N£mero del Periodo
     *ÀInformaci¢n de identificaci¢n t‚cnica

       AADD(aDbfStr,{"cCodigoOrg","Character", 02,0}) // C¢digo de la organizaci¢n
       AADD(aDbfStr,{"cRevisaPro","Character", 03,0}) //  '000' Revisar sus alumnos en contabilidad de profesores
       AADD(aDbfStr,{"lSiProfPro","Logical"  , 01,0}) // .T. Puede entrar a la contabilidad de profesores
       AADD(aDbfStr,{"lCargasPro","Logical"  , 01,0}) // .T.=> Tiene Carga en Contabilidad .F.=>No tiene Carga
       AADD(aDbfStr,{"cMaeAluPro","Character", 09,0}) // Niveles donde dicta. Jardin, Primaria, Bachillerato
       AADD(aDbfStr,{"cAnoUsrPro","Character", 04,0}) // A¤o Autorizado para el Ingreso
       AADD(aDbfStr,{"cCargosPro","Character", 30,0}) // Cargos de ocupa el Profesor
     *ÀInformaci¢n Academica

       AADD(aDbfStr,{"lSexFemPro","Logical"  , 01,0}) // .T. Sexo Femenino .F. Sexo Masculino
       AADD(aDbfStr,{"cNombrePro","Character", 26,0}) // Nombre del profesor
       AADD(aDbfStr,{"cApelliPro","Character", 26,0}) // Apellido del profesor
       AADD(aDbfStr,{"cDocNitPro","Character", 16,0}) // Documento de Identidad
       AADD(aDbfStr,{"cLugNitPro","Character", 20,0}) // Lugar del Documento
       AADD(aDbfStr,{"cTipNitPro","Character",003,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfStr,{"dFecNacPro","Date"     , 08,0}) // Fecha de Nacimiento
       AADD(aDbfStr,{"cLugNacPro","Character", 20,0}) // Lugar de Nacimiento
       AADD(aDbfStr,{"cDireccPro","Character", 40,0}) // Direccion del profesor
       AADD(aDbfStr,{"cBarrioPro","Character", 16,0}) // Barrio de la direcci¢n
       AADD(aDbfStr,{"cTelUnoPro","Character", 10,0}) // Telefono No. 1
       AADD(aDbfStr,{"cTelDosPro","Character", 10,0}) // Telefono No. 2
       AADD(aDbfStr,{"cTelTrePro","Character", 10,0}) // Telefono No. 3
       AADD(aDbfStr,{"cTituloPro","Character", 30,0}) // T¡tulo
       AADD(aDbfStr,{"cUniTitPro","Character", 30,0}) // Universidad del t¡tulo
       AADD(aDbfStr,{"dFecTitPro","Date"     , 08,0}) // Fecha del T¡tulo
       AADD(aDbfStr,{"nEscalaPro","Numeric"  , 02,0}) // N£mero del Escalafon
       AADD(aDbfStr,{"cResoluPro","Character", 30,0}) // Resoluci¢n del Escalafon
       AADD(aDbfStr,{"dFecResPro","Date"     , 08,0}) // Fecha £ltimo Escalafon
       AADD(aDbfStr,{"cDictarPro","Character", 20,0}) // Materias en capacidad de Dictar
     *ÀInformaci¢n Personal

       AADD(aDbfStr,{"lNominaPro","Logical"  , 01,0}) // .T. Pertenece a la n¢mina
       AADD(aDbfStr,{"dFecIngPro","Date"     , 08,0}) // Fecha de Ingreso
       AADD(aDbfStr,{"lRetiroPro","Logical"  , 01,0}) // .T. Profesor Retirado
       AADD(aDbfStr,{"dFecRetPro","Date"     , 08,0}) // Fecha del retiro
       AADD(aDbfStr,{"nSueActPro","Numeric"  , 07,0}) // Sueldo Actual
       AADD(aDbfStr,{"cCtaNomPro","Character", 16,0}) // Cuenta de la Nomina
     *ÀInformaci¢n de N¢mina

       AADD(aDbfStr,{"cHorLunPro","Character",200,0}) // Horario del Lunes
       AADD(aDbfStr,{"cHorMarPro","Character",200,0}) // Horario del Martes
       AADD(aDbfStr,{"cHorMiePro","Character",200,0}) // Horario del Miercoles
       AADD(aDbfStr,{"cHorJuePro","Character",200,0}) // Horario del Jueves
       AADD(aDbfStr,{"cHorViePro","Character",200,0}) // Horario del Viernes
       AADD(aDbfStr,{"cHorSabPro","Character",200,0}) // Horario del Sabado
       AADD(aDbfStr,{"cHorDomPro","Character",200,0}) // Horario del Domingo
     *ÀHorario de Clase

       AADD(aDbfStr,{"cSerHabPro","Character",010,0}) // Servicios Habilitados
       AADD(aDbfStr,{"dResIniPro","Date"     , 08,0}) // Fecha de Inicio del Servicio de Restaurante
       AADD(aDbfStr,{"dResFinPro","Date"     , 08,0}) // Fecha Final del Servicio de Restaurante
       AADD(aDbfStr,{"cResEnePro","Character",031,0}) // Servicio de Restaurante de Enero
       AADD(aDbfStr,{"cResFebPro","Character",031,0}) // Servicio de Restaurante de Febrero
       AADD(aDbfStr,{"cResMarPro","Character",031,0}) // Servicio de Restaurante de Marzo
       AADD(aDbfStr,{"cResAbrPro","Character",031,0}) // Servicio de Restaurante de Abril
       AADD(aDbfStr,{"cResMayPro","Character",031,0}) // Servicio de Restaurante de Mayo
       AADD(aDbfStr,{"cResJunPro","Character",031,0}) // Servicio de Restaurante de Junio
       AADD(aDbfStr,{"cResJulPro","Character",031,0}) // Servicio de Restaurante de Julio
       AADD(aDbfStr,{"cResAgoPro","Character",031,0}) // Servicio de Restaurante de Agosto
       AADD(aDbfStr,{"cResSepPro","Character",031,0}) // Servicio de Restaurante de Septiembre
       AADD(aDbfStr,{"cResOctPro","Character",031,0}) // Servicio de Restaurante de Octubre
       AADD(aDbfStr,{"cResNovPro","Character",031,0}) // Servicio de Restaurante de Noviembre
       AADD(aDbfStr,{"cResDicPro","Character",031,0}) // Servicio de Restaurante de
     *ÀServicio de Restaurante

       AADD(aDbfStr,{"cCodPazPro","Character",040,0}) // C¢digo de Item de Paz y Salvo
       AADD(aDbfStr,{"cVotConPro","Character",030,0}) // Voto al Consejo Directivo
     *ÀOtros
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
       CASE DIRCHANGE(PathPro) == 0
	    DBCREATE(FilePro,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathPro) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathPro)

       CASE DIRCHANGE(PathPro) == -5
	    cError('NO TIENE DERECHOS EN: '+PathPro)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 01:25 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo de Profesor

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfPro(lShared,PathPro,FilePro,lIntUno,fNtxPro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathPro			      // Path del Archivo
       FilePro			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxPro			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathPro+'\'+FilePro,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE PROFESOR")
       Termometro(100)
       CreaDbfPro(lShared,PathPro,FilePro,lIntUno,fNtxPro)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 04/99 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   NOV 04/99 JUE

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

FUNCTION nActStrPro(lShared,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'PRO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE PROFESORES')
	  CloseDbf('PRO')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := PRO->(DBSTRUCT())
       CloseDbf('PRO')
       CreaDbfPro(lShared,PathArc,cNomArc,,,@aStrNew)
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
	  cError('El Archivo PROFESORES su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfPro(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

***************************************************************************
*----------------------- FUNCIONES DE SIMAPROF ---------------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/96 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 AM   MAR 11/96 LUN

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaSprPro(lShared,PathPro,FilePro,fNtxPro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathPro				    // Path del Archivo
       FilePro				    // Nombre del Archivo
       fNtxPro				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cUnidad := ''                  // Unidad de Disco
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfPro := {{"cCodigoPro","Character",06,0},;
			 {"cNombrePro","Character",25,0},;
			 {"cApelliPro","Character",25,0},;
			 {"lCargOkPro","Logical"  ,01,0},;
			 {"cPasWorPro","Character",10,0},;
			 {"dUltIngPro","Date"     ,08,0},;
			 {"cUltIngPro","Character",08,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMBIO A LA UNIDAD DE DISKETTE
       PathAct := cPathAct()
       IF PathPro == 'A:' .OR. PathPro == 'B:'
	  cUnidad := DISKNAME()
	  IF !DISKCHANGE(PathPro)
	     cError('NO SE CAMBIO A LA UNIDAD '+PathPro)
	  ENDIF
       ENDIF
*>>>>FIN CAMBIO A LA UNIDAD DE DISKETTE

*>>>>CREACION DE LA ESTRUCTURA
       DO CASE
       CASE DIRCHANGE(PathPro) == 0 .OR. PathPro == 'A:' .OR. PathPro == 'B:'
	    DBCREATE(FilePro,aDbfPro,"DBFNTX")

       CASE DIRCHANGE(PathPro) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathPro)

       CASE DIRCHANGE(PathPro) == -5
	    cError('NO TIENE DERECHOS EN: '+PathPro)
       ENDCASE
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>CAMBIO A LA UNIDAD DEL DISCO DURO
       IF PathPro == 'A:' .OR. PathPro == 'B:'
	  IF !DISKCHANGE(cUnidad)
	     cError('NO SE CAMBIO A LA UNIDAD '+cUnidad)
	  ENDIF
       ENDIF
       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CAMBIO A LA UNIDAD DEL DISCO DURO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/96 LUN A
       Colombia, Bucaramanga        INICIO: 10:40 AM   MAR 11/96 LUN

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuSprPro(lShared,PathPro,FilePro,fNtxPro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathPro			      // Path del Archivo
       FilePro			      // Nombre del Archivo
       fNtxPro			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathPro+'\'+FilePro,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE PROFESOR")
       Termometro(100)

       CreaSprPro(lShared,PathPro,FilePro,fNtxPro)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/96 MAR A
       Colombia, Bucaramanga        INICIO: 11:45 AM   MAR 12/96 MAR

OBJETIVOS:

1)- Lee el C¢digo del profesor

2)- Verifica la Clave del Profesor

3)- Solicita el disco de notas si se est  trabanjando con diskettes

4)- Crea el directorio de notas si se est  trabanjando el disco duro

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cUsrPro(lShared,cNomSis,cPatSis,cNomUsr,cAnoUsr,;
		 cMaeAct,lMemUsb,cCodPro,cNomPro,lClose)

*>>>>DESCRIPCION DE VARIABLES
/*     lShared                              // Archivos Compartidos
       cNomSis                              // Nombre del Sistema
       cPatSis                              // Path del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       lMemUsb                              // .T. SimaProf en Usb. .F. SimaProf en la Red
       cCodPro                              // @Nombre del Profesor
       cNomPro                              // @Nombre del Profesor
       lClose                               // .T. Cerrar el archivo de Profesores */
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // .T. Ano Actual
       LOCAL nModCry := 0                   // Modo de Protecci¢n

       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL cPasWor := ''                  // PassWord creacion de Usuarios
       LOCAL lMensaj := .F.                 // No visualizar mensaje
       LOCAL lPasWor := .F.                 // .T. Validar PassWord
       LOCAL lHayStr := .T.                 // .F. No existen archivos Prof

       LOCAL nFilSup := 10                  // Fila Superior
       LOCAL nColSup := 30                  // Columna Superior
       LOCAL nFilInf := 15                  // Fila Inferior
       LOCAL nColInf := 52                  // Columna Inferior
       LOCAL       i := 1                   // Contador
       LOCAL PathAct := ''                  // Path Actual
       LOCAL cPatPro := ''                  // Path del Profesor
       LOCAL lCreaCar

       LOCAL GetList := {}                  // Variable del sistema
       LOCAL cCodigoTpr := ''               // C¢digo del profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       IF !PathSprAno(lShared,nModCry,cAnoUsr,cPatSis,;
		      @PathUno,@PathDos,@PathTre,@PathCua)
	  CloseAll()
	  RETURN NIL
       ENDIF
       PathUno := IF(lMemUsb,PathSCO,PathUno)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION DEL DE LA CONTABILIDAD')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DE LOS INDICADORES
       SELECT PRO
       SET FILTER TO PRO->lSiProfPro .AND. !PRO->lRetiroPro
       GO TOP
       IF EOF()
	  cError('NO EXISTEN PROFESORES ACTIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS INDICADORES

*>>>>LECTURA Y VALIDACION DEL PROFESOR USUARIO
       SET CURSOR ON
       SET COLOR TO I
       DISPBOX(nFilSup,nColSup,nFilInf,nColInf,"ÉÍ»º¼ÍÈº")
       SET COLOR TO

       cError('INGRESE SU CODIGO DE IDENTIFICACION','PROFESOR POR FAVOR')

       DO WHILE .T.

**********LECTURA DEL CODIGO DE IDENTIFICACION
	    cCodigoTpr := SPACE(06)
	    @ nFilSup+2,nColSup+2 SAY 'CODIGO :';
				  GET cCodigoTpr PICT '999999';
				  VALID lValProfes(05,10,@cCodigoTpr) .OR.;
				  EMPTY(cCodigoTpr)
	    READ
	    cCodPro := cCodigoTpr
**********FIN LECTURA DEL CODIGO DE IDENTIFICACION

**********ANALISIS PARA LA SALIDA
	    IF EMPTY(cCodigoTpr)
	       lClose := IF(lClose == NIL,.T.,lClose)
	       IF lClose
		  CloseDbf('PRO')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN ANALISIS PARA LA SALIDA

**********LECTURA DE LA CLAVE DE ACCESO
	    IF !lLeePasPro(nFilSup+3,nColSup+4)
	       cCodigoTpr := ''
	       RETURN NIL
	    ENDIF
	    cNomPro := ALLTRIM(PRO->cApelliPro)+' '+;
		       ALLTRIM(PRO->cNombrePro)+':'+cCodigoTpr
**********FIN LECTURA DE LA CLAVE DE ACCESO

**********VALIDACION DEL A¥O DE INGRESO
	    IF !EMPTY(SPR->cAnoUsrSpr)   .AND.;
	       PRO->cAnoUsrPro # cAnoUsr .AND.;
	       SPR->cAnoUsrSpr # cAnoUsr .AND.;
	       UPPER(cNomUsr) # 'SUPER'
	       cError('NO ESTA HABILITADO EL INGRESO AL '+cAnoUsr)
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL A¥O DE INGRESO

**********PREGUNTA DE DECISION
	    IF !lPregunta(cNomPro+' DESEA CONTINUAR? Si No')
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********ANALISIS SI EL PROFESOR TIENE CARGA
	    IF !PRO->lCargasPro .OR. !(cMaeAct $ PRO->cMaeAluPro)
	       cCodigoTpr := '999999'
	    ENDIF
**********FIN ANALISIS SI EL PROFESOR TIENE CARGA

**********VERIFICACION O CREACION DEL DIRECTORIO DE BACHILLERATO
	    cPatPro := TCO->cUnidadTbl+':'
	    IF cPatPro # 'A:' .AND. cPatPro # 'B:'
	       PathAct := cPathAct()
	       cPatPro := cPatSis+'\'+cMaeAct+'\'+cCodigoTpr
	       DO CASE
	       CASE DIRCHANGE (cPatPro) == 0
		    DIRCHANGE(PathAct)

	       CASE DIRCHANGE (cPatPro) == -5
		    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatPro)
		    QUIT

	       CASE DIRCHANGE(cPatPro) == -3
		    DIRCHANGE(cPatSis+'\'+cMaeAct)
		    DIRMAKE(cCodigoTpr)
	       ENDCASE
	       DIRCHANGE(PathAct)
	    ENDIF
	    EXIT
**********FIN VERIFICACION O CREACION DEL DIRECTORIO DE BACHILLERATO

       ENDDO
*>>>>FIN LECTURA Y VALIDACION DEL PROFESOR USUARIO

*>>>>VALIDACION DEL DISKETTE
       IF cPatPro == 'A:' .OR. cPatPro == 'B:'

**********VALIDACION EN EL DRIVE
	    IF !lDisketeOk(SUBS(cPatPro,1,1),ALLTRIM(PRO->cNombrePro))
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION EN EL DRIVE

**********PREGUNTA DE DECISION
	    IF !FILE(cPatPro+'\'+FilePro+ExtFile) .AND.;
	       !FILE(cPatPro+'\'+FCarPro+cAnoSis+ExtFile)

	       IF !lPregunta(ALLTRIM(PRO->cNombrePro)+' '+;
			     'DESEA PREPARAR ESTE DISCO '+;
			     'PARA LLEVAR SUS NOTAS? Si No')
		  RETURN NIL
	       ENDIF

	    ENDIF
**********FIN PREGUNTA DE DECISION

       ENDIF
*>>>>FIN VALIDACION DEL DISKETTE

*>>>>CREACION DE LAS ESTRUCTURAS
       lHayStr := .T.
       IF !FILE(cPatPro+'\'+FilePro+ExtFile) .AND.;
	  !FILE(cPatPro+'\'+FCarPro+cAnoSis+ExtFile)

	  CreaCarPro(lShared,cAnoUsr,cPatSis,PathUno,cMaeAct,cPatPro,;
		     cCodigoTpr,ALLTRIM(PRO->cApelliPro),;
		     ALLTRIM(PRO->cNombrePro))
	  lHayStr := .F.
       ENDIF
       ModNomPro(lShared,cPatPro,cCodigoTpr)
      *Modifica el Nombre local del Profesor
*>>>>FIN CREACION DE LAS ESTRUCTURAS

*>>>>ACTUALIZACION DE LOS ESTUDIANTES
       IF lHayStr

	  DO CASE
	  CASE 'JAR' $ cMaeAct
	       i := 1
	  CASE 'PRI' $ cMaeAct
	       i := 2
	  CASE 'BTO' $ cMaeAct
	       i := 3
	  ENDCASE

	  IF SUBS(PRO->cRevisaPro,i,1) == '1'

	     RevisarEst(lShared,cNomSis,cAnoUsr,;
			cPatPro,PathUno+'\'+cPatSis,cMaeAct,lAnoAct)

	     IF PRO->(lRegLock(lShared,.F.))
		REPL PRO->cRevisaPro WITH STUFF(PRO->cRevisaPro,i,1,'0')
		PRO->(DBCOMMIT())
	     ELSE
		cError('NO SE GRABA EL SWICTH DE LA ACTUALIZACION')
	     ENDIF
	     IF lShared
		PRO->(DBUNLOCK())
	     ENDIF
	  ENDIF
       ENDIF
       RETURN cPatPro
*>>>>FIN ACTUALIZACION DE LOS ESTUDIANTES

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE LA CLAVE DEL PROFESOR               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/96 MAR A
       Colombia, Bucaramanga        INICIO: 01:25 PM   MAR 12/96 MAR

1- Permite leer la clave del profesor y verificarla

2- Debe estar en uso el archivo de profes de la contabilidad
   en el registro coreccto

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeePasPro(nNroFil,nNroCol,lValida)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       lValida                              // Validar la Clave */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cPasWor := ''                  // Clave del usuario
       LOCAL       i := 0                   // Contador
       LOCAL lPasWor := .T.                 // Clave Correcta
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA CLAVE DE ACCESO
       SET COLOR TO W/N,N/N,N

       DO WHILE i < 3
	  cPasWor := SPACE(10)
	  @ nNroFil,nNroCol SAY 'CLAVE:' GET cPasWor PICT 'XXXXXXXXXX'
	  READ

	  lValida := IF(lValida == NIL,.T.,lValida)
	  lPasWor := .F.

	  IF lValida
	     IF cPasWor == cLeeTxtCry(PRO->lSiCrypPro,PRO->cPasWorPro)
		lPasWor := .T.
		EXIT
	     ENDIF
	  ENDIF
	  i++
       ENDDO
       SET COLOR TO W/N,N/W,N
       RETURN lPasWor
*>>>>FIN LECTURA DE LA CLAVE

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO DEL PROFESOR               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:10 PM   MAY 09/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo

2- Verifica la existencia del c¢digo

3- Deja el archivo en el registro del c¢digo si este existe.

4- Retorna .T. si localizo el codigo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodPro(cCodigo,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo			            // C¢digo a localizar
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT PRO
       GO TOP
       LOCATE FOR PRO->cCodigoPro == cCodigo
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('EL CODIGO DEL PROFESOR '+cCodigo+' NO SE ENCUENTRA')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL PROFESOR             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:10 AM   MAY 09/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo Profesor

2- Realiza la validaci¢n del c¢digo del Profesor

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodPro(cCodPro)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodPro				    // C¢digo del Grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL GRUPO
       IF lLocCodPro(cCodPro,.F.) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL GRUPO

/*************************************************************************
* TITULO DEL PROGRAMA..: ENCONTRAR EL NOMBRE DEL PROFESOR                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:50 AM   MAY 09/95 MAR

OBJETIVOS:

1- Deben estar en uso el archivo de profesores

2- Permite encontrar el nombre del profesor

3- Si el nombre del profesor se incluye en un browse de debe pasar
   el Alias del Archivo del Browse

4- Retorna el nombre del profesor

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSekNomPro(cCodigo,cAlias)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				      // C¢digo de b£squeda
       cAlias                                 // Alias diferente al maestro*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNalias := ''                    // Alias del maestro

       LOCAL cNombreTpr := ''                 // Nombre del profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL CODIGO
       IF lLocCodPro(cCodigo,.F.)

	  cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
			RTRIM(PRO->cNombrePro)
	  IF PRO->lRetiroPro
	     cNombreTpr := cNombreTpr +'. RETIRADO'
	  ENDIF

       ELSE
	  cNombreTpr := 'PROFESOR NO EXISTE'
       ENDIF
       IF cAlias # NIL
	  SELECT &cAlias
       ENDIF
       RETURN cNombreTpr+SPACE(50-LEN(cNombreTpr))
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL PROFESOR                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/95 MIE A
       Colombia, Bucaramanga        INICIO: 07:40 AM   MAY 10/95 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de profesores

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Realiza la validaci¢n del c¢digo del profesor

4- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValProfes(nNroFil,nNroCol,cCodigo,nNroReg)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // Codigo a validar
       nNroReg			            // @Registro escogido */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>VALIDACION DEL CODIGO
       IF !lLocCodPro(cCodigo,.F.)
	  lSelProfes(nNroFil,nNroCol,@nNroReg)
	  IF nNroReg == 0
	     cCodigo := cSpaField('PRO','cCodigoPro')
	  ELSE
	     GO nNroReg
	     cCodigo := PRO->cCodigoPro
	  ENDIF
       ELSE
	  nNroReg := RECNO()
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL PROFESOR                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/95 MIE A
       Colombia, Bucaramanga        INICIO: 07:45 AM   MAY 10/95 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de profesores

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite escoger un profesor

4- Retorna .T. si escogio un profesor

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSelProfes(nNroFil,nNroCol,nNroReg,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nNroReg		                    // @N£mero del registro escogido
       cTitulo                              // T¡tulo de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cTitulo := IF(cTitulo == NIL,'',cTitulo)
       @ nNroFil,nNroCol SAY cTitulo
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>SELEECION DEL GRUPO
	SELECT PRO
	nNroCol = nNroCol + LEN(cTitulo)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT()-1
	ENDIF
	nColInf := nColSup+LEN(PRO->cApelliPro+PRO->cNombrePro)+12

	PRO->(DBGOTOP())
	nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			     {||RTRIM(PRO->cApelliPro)+' '+;
				RTRIM(PRO->cNombrePro)+' ->'+;
				IF(!EMPTY(PRO->cMaeAluPro),;
				   PRO->cMaeAluPro,'NO DICTA')},62)
	IF nNroReg == 0
	   RETURN .F.
	ENDIF
	PRO->(DBGOTO(nNroReg))
*	@ nFilSup,nColSup SAY PRO->cCodigoPro
	RETURN .T.
*>>>>FIN SELEECION DEL GRUPO

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE ARCHIVOS DEL PROFESOR              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/96 MAR A
       Colombia, Bucaramanga        INICIO: 11:45 AM   MAR 12/96 MAR

OBJETIVOS:

1)- Debe venir validado la no existencia de la configuracion del profesor

2)- Crea los archivos con la carga academica del profesor

3)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaCarPro(lShared,cAnoUsr,cPatSis,PathUno,;
		    cMaeAct,cPatPro,cCodPro,cApePro,cNomPro)

*>>>>DECLARACIO DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL lUseNtx := .F.                 // .T. Abrir Indices
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual
       LOCAL nNroAlu := 1                   // N£mero de Alumnos
       LOCAL cUnidad := ''                  // Unidad de Disco
       LOCAL lHayMat := .T.                 // .T. Hay Materia

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lCargOkTpr := .T.              //.T.Profesor con Carga Academica
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTni := ''               // C¢digo del Nivel

       FIELD cCodigoGru                     // C¢digo del Grupo
       FIELD cCodigoNiv                     // C¢digo del Nivel
       FIELD cCodigoMat                     // C¢digo de la materia
*>>>>FIN DECLARACIO DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CARGAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO APARECEN LAS CARGAS ACADEMICAS DE LOS PROFESORES')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS SI TIENE CARGA ACADEMICA ASIGNADA
       lCargOkTpr := .F.
       IF lLocCodigo('cCodigoPro','CAR',cCodPro)
	  lCargOkTpr := .T.
       ENDIF
*>>>>FIN ANALISIS SI TIENE CARGA ACADEMICA ASIGNADA

*>>>>CREACION DE LAS ESTRUCTURAS DEL PROFESOR
       CreaSprPro(lShared,cPatPro,FilePro+ExtFile)
       CreaDbfCaP(lShared,cPatPro,FCarPro+cAnoSis+ExtFile)
       CreaDbfMaP(lShared,cPatPro,FMatPro+cAnoSis+ExtFile)
       CloseDbf('PRO')
*>>>>FIN CREACION DE LAS ESTRUCTURAS DEL PROFESOR

*>>>CAMBIO A LA UNIDAD DEL DISCO DURO
      IF cPatPro == 'A:' .OR. cPatPro == 'B:'
	 SET DEFA TO &(cUnidad)
      ENDIF
*>>>FIN CAMBIO A LA UNIDAD DEL DISCO DURO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis+'\',cMaeAct,cAnoSis,lUseNtx) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                   .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FilePro+ExtFile,'PRO',NIL,lShared)           .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FMatPro+cAnoSis+ExtFile,'MAP',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN ''
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO ESTUDIANTES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO APARECEN MATERIAS GRABADAS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO APARECEN LAS CARGAS ACADEMICAS DE LOS PROFESORES')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>GRABACION DE LOS DATOS DEL PROFESOR
       IF PRO->(lRegLock(lShared,.T.))
	  REPL PRO->cCodigoPro WITH cCodPro
	  REPL PRO->cApelliPro WITH cApePro
	  REPL PRO->cNombrePro WITH cNomPro
	  REPL PRO->lCargOkPro WITH lCargOkTpr
	  PRO->(DBCOMMIT())
       ENDIF
       IF lShared
	  PRO->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DE LOS DATOS DEL PROFESOR

*>>>>FILTRACION DE LA CARGA ACADEMICA
       SELECT CAR
       SET FILTER TO CAR->cCodigoPro = cCodPro
       GO TOP
       IF EOF()
	  cError('PARA '+cNomPro+' NO EXISTE CARGA ACADEMICA')
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LA CARGA ACADEMICA

*>>>>GRABACION DE LA CARGA ACADEMICA DEL PROFESOR
       nNroFil := nMarco(01,cNomPro+' POR FAVOR REVISE SU CARGA '+;
			    'ACADEMICA MIENTRAS SE GRABA')
       SELECT CAR
       GO TOP
       DO WHILE .NOT. CAR->(EOF())

**********LOCALIZACION DEL CODIGO DE LA MATERIA
	    cCodigoTgr := SUBS(CAR->cCodigoCar,5,4)
	    cCodigoTni := SUBS(CAR->cCodigoCar,5,2)
	    cCodigoTma := SUBS(CAR->cCodigoCar,1,4)

	    cNombreTma := 'MATERIA CON CODIGO: '+cCodigoTma+;
			  ' NO EXISTE'
	    IF cCodigoTma == '9999'
	       cNombreTma := 'MATERIA:'+REPL('_',22)
	    ENDIF


	    IF lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	       cNombreTma := MAT->cNombreMat
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO DE LA MATERIA

**********VISUALIZACION DE LA MATERIA
	    nNroFil++
	    @ nNroFil,01 SAY 'GRUPO:'+cCodigoTgr+'->'+ALLTRIM(cNombreTma)+' '+;
			     IF(CAR->nTipCarCar==0,'',;
				IF(CAR->nTipCarCar==1,': POR GRUPO',;
				   IF(CAR->nTipCarCar==2,': POR NIVEL',;
				      IF(CAR->nTipCarCar==3,': POR NIVELES',;
							    ': ERROR'))));
			     PICT "@S78"
	    IF nNroFil == 21
	       cPausa()
	       nNroFil := nMarco(01,cNomPro+' POR FAVOR REVISE '+;
				    'SU CARGA ACADEMICA MIENTRAS SE GRABA')
	    ENDIF
**********FIN VISUALIZACION DE LA MATERIA

**********GRABACION DE LA CARGA
	    IF CAP->(lRegLock(lShared,.T.))
	       REPL CAP->cCodigoCar WITH CAR->cCodigoCar
	       REPL CAP->nTipCarCar WITH CAR->nTipCarCar
	       REPL CAP->cNombreMat WITH cNombreTma
	       CAP->(DBCOMMIT())
	    ENDIF
	    IF lShared
	       CAP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA CARGA

**********GRABACION DE LAS MATERIAS DEL PROFESOR
	    IF TCO->cIndUnoTbl # cCodigoTma .AND.;
	       TCO->cIndDosTbl # cCodigoTma

	       SELECT MAP
	       IF TCO->lIndNivTbl
		  LOCATE FOR cCodigoNiv == cCodigoTni .AND.;
			     cCodigoMat == cCodigoTma
		  lHayMat := .F.
		  IF FOUND()
		     lHayMat := .T.
		  ENDIF
	       ELSE
		   lHayMat := lLocCodigo('cCodigoMat','MAP',cCodigoTma)
	       ENDIF

	       IF !lHayMat
		  IF MAP->(lRegLock(lShared,.T.))
		     IF TCO->lIndNivTbl
			REPL MAP->cCodigoNiv WITH cCodigoTni
		     ELSE
			REPL MAP->cCodigoNiv WITH SPACE(02)
		     ENDIF
		     REPL MAP->cCodigoMat WITH cCodigoTma
		     REPL MAP->cNombreMat WITH cNombreTma
		     MAP->(DBCOMMIT())
		  ENDIF
		  IF lShared
		     MAP->(DBUNLOCK())
		  ENDIF
	       ENDIF

	    ENDIF
**********FIN GRABACION DE LAS MATERIAS DEL PROFESOR

	  SELECT CAR
	  CAR->(DBSKIP())

       ENDDO
       SET FILTER TO
       cPausa()
*>>>>FIN GRABACION DE LA CARGA ACADEMICA EN ARCHIVOS

*>>>>CREACION DE LOS GRUPOS Y GRABACION DE LOS ALUMNOS
       SELECT CAP
       GO TOP
       DO WHILE .NOT. CAP->(EOF())

**********CREACION DE LA ESTRUCTURA DEL GRUPO
	    FNotPro := CAP->cCodigoCar+ExtFile
	    CreaDbfNoP(lShared,cPatPro,FNotPro)
**********FIN CREACION DE LA ESTRUCTURA DEL GRUPO

**********VALIDACION DE LA CARGA NORMAL
	    IF CAP->nTipCarCar # 0

	       @ 10,20 SAY 'PARA '+SUBS(cCodigoTgr,1,2)+;
			   ' CREANDO '+ALLTRIM(CAP->cNombreMat)
	       CAP->(DBSKIP())
	       CloseDbf('NOP')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA CARGA NORMAL

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+FNotPro,'NOP',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS '+FNotPro)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********FILTRACION DEL MAESTRO DE ALUMNOS
	    SELECT &cMaeAct
	    cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
	    SET FILTER TO cCodigoGru == cCodigoTgr
	    GO TOP
	    IF EOF()
	       cError('NO EXISTEN ALUMNOS PARA EL GRUPO '+cCodigoTgr)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN FILTRACION DEL MAESTRO DE ALUMNOS

**********GRABACION DE LOS ALUMNOS DEL RESPECTIVO GRUPO
	    nNroFil := nMarco(01,'GRABANDO LOS ALUMNOS DE '+;
			      ALLTRIM(CAP->cNombreMat)+' '+;
			      'DEL GRUPO '+cCodigoTgr)
	    SELECT &cMaeAct
	    GO TOP
	    DO WHILE .NOT. EOF()

*--------------GRABACION DEL ALUMNO EN EL DISCO
		 IF NOP->(lRegLock(lShared,.T.))
		    REPL NOP->cCodigoEst WITH &cMaeAct->cCodigoEst
		    REPL NOP->cApelliEst WITH &cMaeAct->cApelliEst
		    REPL NOP->cNombreEst WITH &cMaeAct->cNombreEst
		    REPL NOP->lRetiroNoP WITH .F.
		    NOP->(DBCOMMIT())
		 ENDIF
		 IF lShared
		    NOP->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DEL ALUMNO EN EL DISCO

*--------------VISUALIZACION DEL ESTUDIANTE GRABADO
		 SELECT &cMaeAct
		 cNombreTes := ALLTRIM(&cMaeAct->cApelliEst)+' '+;
			       ALLTRIM(&cMaeAct->cNombreEst)
		 nNroFil++
		 @ nNroFil,01 SAY 'No. '+STR(nNroAlu++,2)+;
				  ' CODIGO: '+&cMaeAct->cCodigoEst+' '+;
				  cNombreTes+' ...'

		 IF nNroFil == 21
		    nNroFil := nMarco(01,'GRABANDO LOS ALUMNOS DE '+;
				      ALLTRIM(CAP->cNombreMat)+' DEL GRUPO '+;
				      cCodigoTgr)
		 ENDIF
*--------------FIN VISUALIZACION DEL ESTUDIANTE GRABADO


	       SKIP

	    ENDDO
	    SELECT &cMaeAct
	    SET FILTER TO
	    CloseDbf('NOP')
	    nNroAlu := 1
**********FIN GRABACION DE LOS ALUMNOS DEL RESPECTIVO GRUPO

	  CAP->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN CREACION DE LOS GRUPOS Y GRABACION DE LOS ALUMNOS

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 09/95 LUN A
       Colombia, Bucaramanga        INICIO: 11:10 AM   SEP 09/95 LUN

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

MantenPro()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManProfes(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL oBrwPro := NIL                  // Browse de Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwPro := oDefProfes(lShared,cAnoUsr,cPatSis,nFilPal+1,00,22,79)
       PRO->(CtrlBrw(lShared,oBrwPro))
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
				    INICIO: 03:43 PM   DIC 26/94 LUN

OBJETIVOS:
1- Define el objeto Browse del archivo

SINTAXIS:

 oBrwPro := oDefProfes(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefProfes(lShared,cAnoUsr,cPatSis,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<PERSONAL PARA '+cAnoUsr+'.TOTAL: '+;
			      STR(PRO->(RECCOUNT()),4)+' >>',;
			    '<ENTER>Modificar <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PRO
       oColumn	     := TBCOLUMNNEW('No.', {||STR(PRO->(RECNO()),4)})
       oColumn:Width := 4
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO DEL;PROFESOR', {||PRO->cCodigoPro})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('APELLIDOS;DEL PROFESOR', {||PRO->cApelliPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'}, {'FIELD','cApelliPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRES;DEL PROFESOR', {||PRO->cNombrePro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cNombrePro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REVISAR;ALUMNOS', {||PRO->cRevisaPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cRevisaPro'},;
			 {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INGRESAR;A SIMAPROF', {||PRO->lSiProfPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','lSiProfPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIENE CARGA;ACADEMICA', {||PRO->lCargasPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','lCargasPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NIVELES;DONDE DICTA', {||PRO->cMaeAluPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cMaeAluPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O ACTUAL', {||PRO->cAnoUsrPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cAnoUsrPro'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NUMERO DEL;PERIODO', {||PRO->nNroPerPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','nNroPerPro'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PASSWORD;DEL PROFESOR', {||PRO->cPasWorPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cPasWorPro'},;
			 {'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MODIFICACION NOMBRE DEL PROFESOR                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2002 MAR A
       Colombia, Bucaramanga        INICIO: 10:00 AM   ABR 02/2002 MAR

OBJETIVOS:

1- Modifica el nombre del Profesor local de acuerdo al archivo de los
   profesores de la contabilidad.

2- Debe estar en uso el archivo de profesore de la Contabilidad.

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ModNomPro(lShared,cPatPro,cCodPro)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cPatPro                              // Path del Profesor
       cCodPro                              // C¢digo del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       FilePro+ExtFile,'PRL',NIL,lShared)
	  cError('ABRIENDO ARCHIVO PROFESOR LOCAL')
	  CloseDbf('PRL',cPatPro+'\'+FilePro+ExtFile)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE NOMBRE DEL PROFESOR
       IF ALLTRIM(PRO->cApelliPro) == ALLTRIM(PRL->cApelliPro) .AND.;
	  ALLTRIM(PRO->cNombrePro) == ALLTRIM(PRO->cNombrePro)
	  CloseDbf('PRL',cPatPro+'\'+FilePro+ExtFile)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE NOMBRE DEL PROFESOR

*>>>>ACTUALIZACION DEL NOMBRE DEL PROFESOR
       IF PRO->cCodigoPro == cCodPro
	  IF PRL->(lRegLock(lShared,.F.))
	     REPL PRL->cApelliPro WITH PRO->cApelliPro
	     REPL PRL->cNombrePro WITH PRO->cNombrePro
	     PRL->(DBCOMMIT())
	     cError('SE MODIFICO EL NOMBRE DEL PROFESOR')
	  ELSE
	     cError('NO SE ACTUALIZA EL NOMBRE LOCAL DEL PROFESOR')
	  ENDIF
	  IF lShared
	     PRL->(DBUNLOCK())
	  ENDIF
       ENDIF
       CloseDbf('PRL',cPatPro+'\'+FilePro+ExtFile)
       RETURN NIL
*>>>>FIN ACTUALIZACION DEL NOMBRE DEL PROFESOR