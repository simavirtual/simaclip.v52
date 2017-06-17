/*                  SISTEMA CONTABILIDAD ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO PROFESOR

REQUERIMIENTOS:

- Compilar: clipper FuncsPro /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo profesor

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
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
	nColInf := nColSup+LEN(PRO->cApelliPro)+LEN(PRO->cNombrePro)

	PRO->(DBGOTOP())
	nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			     {||RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro})
	IF nNroReg == 0
	   RETURN .F.
	ENDIF
	PRO->(DBGOTO(nNroReg))
	@ nFilSup,nColSup SAY PRO->cCodigoPro
	RETURN .T.
*>>>>FIN SELEECION DEL GRUPO

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

FUNCTION MantenPro(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		   cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		   lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		   cJornad)

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
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL oBrowse := NIL                  // Browse de Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       IF !PathConAno(lShared,cAnoUsr,cPatSis,;
		      @cIntUno,@cIntDos,;
		      @cIntTre,@cIntCua)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
     *ÀLectura de paths
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cIntUno := IF(lIntUno,cIntUno+'\'+cMaeAct,cPatSis)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileOrg,'ORG',NIL,lShared) .OR. ;
	  !lUseDbf(.T.,cPatSis+'\'+;
		   FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared) .OR. ;
	  !lUseDbf(.T.,cPatSis+'\'+;
		   FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR. ;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared) .OR. ;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   FileMat,'MAT',NIL,lShared)                 .OR. ;
	  !lUseDbf(.T.,cPatSis+'\'+FileHra,'HRA',NIL,lShared) .OR. ;
	  !lUseDbf(.T.,cPatSis+'\'+FileFun,'FUN',NIL,lShared) .OR. ;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO PROFESORES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       IF !lFileLock()
	  oBrowse := oDefBrwPro(lShared,cAnoUsr,cPatSis,nFilPal+1,00,22,79)
	  SETKEY(K_F2,{||ConsulPro(nFilPal,1,'INFORMACION DEL PROFESOR')})
	  SETKEY(K_F3,{||VerCarPro(lShared,PRO->cCodigoPro,cMaeAct)})
	  SETKEY(K_F4,{||lDatosPro(lShared,nFilPal,1,;
				   PRO->cCodigoPro,;
				   SUBS(ALLTRIM(PRO->cApelliPro)+' '+;
				   PRO->cNombrePro,1,40))})
	  SETKEY(K_F5,{||BuscarPro(oBrowse)})
	  SETKEY(K_F9,{||MenuOtrPro(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,;
				    cNomEmp,cNomDpt,cNomMun,nFilPal,nFilInf,;
				    nColInf,cNomUsr,cAnoUsr,cPatSis,cIntUno,;
				    lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
				    cJorTxt,cJornad,oBrowse)})

	  PRO->(CtrlBrw(lShared,oBrowse))

	  SETKEY(K_F2,NIL)
	  SETKEY(K_F4,NIL)
	  SETKEY(K_F5,NIL)
	  SETKEY(K_F9,NIL)

       ENDIF
       DBUNLOCKALL()
       CLOSE ALL
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

 oBrowse := oDefBrwPro(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwPro(lShared,cAnoUsr,cPatSis,nFilSup,nColSup,nFilInf,nColInf)

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
			    '<F2>Consultar <F3>Cargas <F4>Modificar '+;
			    '<F5>Buscar <F9>Otros <INS>Incluir <DEL>Borrar',;
			    {||IncluirPro(lShared,cAnoUsr,cPatSis)}}
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
       oBrowse:Freeze:= 3
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

       oColumn	     := TBCOLUMNNEW('PROFESOR;RETIRADO', {||PRO->lRetiroPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','lRetiroPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;DE RETIRO', {||PRO->dFecRetPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','dFecRetPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DOCUMENTO;DE IDENTIDAD', {||PRO->cDocNitPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cDocNitPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LUGAR DEL;DOCUMENTO', {||PRO->cLugNitPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cLugNitPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DIRECCION;DEL PROFESOR', {||PRO->cDireccPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cDireccPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TELEFONO;DEL PROFESOR', {||PRO->cTelUnoPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cTelUnoPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO', {||PRO->cCodigoOrg})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'}, {'FIELD','cCodigoOrg'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ITEM;PAZ Y SALVO', {||PRO->cCodPazPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cCodPazPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SERVICIOS;HABILITADOS', {||PRO->cSerHabPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cSerHabPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CLAVE DEL;PROFESOR',;
			      {||cLeeTxtCry(PRO->lSiCrypPro,PRO->cPasWorPro)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ENCRIPTAR;LA CLAVE', {||PRO->lCryPasPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','lCryPasPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ENCRIPTADO', {||PRO->lSiCrypPro})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CAMBIAR;CLAVE', {||PRO->cPasWorPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRO'},{'FIELD','cPasWorPro'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de Configuraci¢n del A¤o

2- Incluye un registro al archivo

SINTAXIS:

  IncluirPro()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirPro(lShared,cAnoUsr,cPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTor := ''               // C¢digo de la Organizaci¢n
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cNombreTpr := ''               // Nombre del Profesor
       LOCAL cApelliTpr := ''               // Apellido del Profesor
       LOCAL cDocNitTpr := ''               // Documento del Profesor
       LOCAL cLugNitTpr := ''               // Lugar del Documento
       LOCAL dFecNacTpr := CTOD('00/00/00') // Fecha de Nacimiento
       LOCAL cLugNacTpr := ''               // Lugar de Nacimiento
       LOCAL cDireccTpr := ''               // Direcci¢n
       LOCAL cTelUnoTpr := ''               // Telefono No. 1
       LOCAL cTelDosTpr := ''               // Telefono No. 2
       LOCAL cTituloTpr := ''               // T¡tulo del Profesor
       LOCAL dFecTitTpr := ''               // Fecha del T¡tilo
       LOCAL nEscalaTpr := 0                // N£mero del Escalafon
       LOCAL cResEscTpr := ''               // Resoluci¢n del Escalafon 
       LOCAL dFecIngTpr := CTOD('00/00/00') // Fecha de Ingreso
       LOCAL nSueActTpr := 0                // Sueldo Actual
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA DE LOS PROFESORES DEL A¥O ANTERIOR
       IF PRO->(RECCOUNT()) == 0
	  IF lLeeProAnt(lShared,cPatSis,cAnoUsr)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DE LOS PROFESORES DEL A¥O ANTERIOR

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil+3,'POR FAVOR ENTRE LOS DATOS DEL PROFESOR',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTor := cSpaces('PRO','cCodigoOrg')
	       cNombreTpr := cSpaces('PRO','cNombrePro')
	       cApelliTpr := cSpaces('PRO','cApelliPro')
	       cDocNitTpr := cSpaces('PRO','cDocNitPro')
	       cLugNitTpr := cSpaces('PRO','cLugNitPro')
	       dFecNacTpr := CTOD('00/00/00')
	       cLugNacTpr := cSpaces('PRO','cLugNacPro')
	       cDireccTpr := cSpaces('PRO','cDireccPro')
	       cTelUnoTpr := cSpaces('PRO','cTelUnoPro')
	       cTelDosTpr := cSpaces('PRO','cTelDosPro')
	       cTituloTpr := cSpaces('PRO','cTituloPro')
	       dFecTitTpr := CTOD('00/00/00')
	       nEscalaTpr := 0
	       cResEscTpr := cSpaces('PRO','cResoluPro')
	       dFecIngTpr := CTOD('00/00/00')
	       nSueActTpr := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+00,nNroCol SAY 'TIPO     :';
				 GET cCodigoTor PICT '@!'
	    @ nNroFil+01,nNroCol SAY 'APELLIDO :';
				GET cApelliTpr PICT '@!'
	    @ nNroFil+02,nNroCol SAY 'NOMBRE   :';
				GET cNombreTpr PICT '@!'
	    @ nNroFil+03,nNroCol SAY 'DOCUMENTO:';
				GET cDocNitTpr PICT '@!'
	    @ nNroFil+04,nNroCol SAY 'DE       :';
				GET cLugNitTpr PICT '@!'
	    @ nNroFil+05,nNroCol SAY 'F. NACIMI:';
				GET dFecNacTpr PICT '@D'
	    @ nNroFil+06,nNroCol SAY 'LUGAR NAC:';
				GET cLugNacTpr PICT '@!'
	    @ nNroFil+07,nNroCol SAY 'DIREECION:';
				GET cDireccTpr PICT '@!'
	    @ nNroFil+08,nNroCol SAY 'TELEFONO1:';
				GET cTelUnoTpr PICT '@!'
	    @ nNroFil+09,nNroCol SAY 'TELEFONO2:';
				GET cTelDosTpr PICT '@!'
	    @ nNroFil+10,nNroCol SAY 'TITULO   :';
				GET cTituloTpr PICT '@!'
	    @ nNroFil+11,nNroCol SAY 'F. TITULO:';
				GET dFecTitTpr PICT '@D'
	    @ nNroFil+12,nNroCol SAY 'ESCALAFON:';
				GET nEscalaTpr PICT '99'
	    @ nNroFil+13,nNroCol SAY 'RESO. ESC:';
				GET cResEscTpr PICT '@!'
	    @ nNroFil+14,nNroCol SAY 'F.INGRESO:';
				GET dFecIngTpr PICT '@D'
	    @ nNroFil+15,nNroCol SAY 'SUELDO   :';
				GET nSueActTpr PICT '9999999'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF !EMPTY(cApelliTpr) .AND. !EMPTY(cNombreTpr)
*	       !EMPTY(dFecNacTpr) .AND. !EMPTY(cLugNacTpr)
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

*>>>>ASIGNACION DEL CODIGO DEL PROFESOR
       IF lGrabar

	  IF COA->(lRegLock(lShared,.F.))

	     cCodigoTpr := STR(COA->nNroProCoA+1,4)
	    *Lectura del C¢digo del Profesor

	     REPL COA->nNroProCoA WITH COA->nNroProCoA+1
	     COA->(DBCOMMIT())
	     IF lShared
		COA->(DBUNLOCK())
	     ENDIF
	   *ÀGrabaci¢n de C¢digo asignado
	  ENDIF
       ENDIF
*>>>>FIN ASIGNACION DEL CODIGO DEL PROFESOR

*>>>>ASIGNACION DEL CODIGO DEL PROFESOR
       IF lGrabar
	  lCorrecion(@cCodigoTpr)
	  IF VAL(cAnoUsr) >= 2000
	     cCodigoTpr := SUBS(cAnoUsr,1,1)+cAnoSis+;
			   SUBS(cCodigoTpr,2,3)
	  ELSE
	     cCodigoTpr := cAnoSis+cCodigoTpr
	  ENDIF
       ENDIF
*>>>>FIN ASIGNACION DEL CODIGO DEL PROFESOR

*>>>>LOCALIZACION DEL CODIGO DEL PROFESOR
       IF lGrabar
	  IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
	     cError('EL CODIGO: '+cCodigoTpr+' YA ESTA ASIGNADO A '+;
		     RTRIM(PRO->cApelliPro)+' '+RTRIM(PRO->cNombrePro))
	     lGrabar := .F.
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO DEL PROFESOR

*>>>>GRABACION DEL REGISTRO
       SELECT PRO
       IF lGrabar
	  IF PRO->(lRegLock(lShared,.T.))
	     REPL PRO->cCodigoPro WITH cCodigoTpr
	     REPL PRO->cCodigoOrg WITH cCodigoTor
	     REPL PRO->cApelliPro WITH cApelliTpr
	     REPL PRO->cNombrePro WITH cNombreTpr
	     REPL PRO->cDocNitPro WITH cDocNitTpr
	     REPL PRO->cLugNitPro WITH cLugNitTpr
	     REPL PRO->dFecNacPro WITH dFecNacTpr
	     REPL PRO->cLugNacPro WITH cLugNacTpr
	     REPL PRO->cDireccPro WITH cDireccTpr
	     REPL PRO->cTelUnoPro WITH cTelUnoTpr
	     REPL PRO->cTelDosPro WITH cTelDosTpr
	     REPL PRO->cTituloPro WITH cTituloTpr
	     REPL PRO->dFecTitPro WITH dFecTitTpr
	     REPL PRO->nEscalaPro WITH nEscalaTpr
	     REPL PRO->cResoluPro WITH cResEscTpr
	     REPL PRO->dFecIngPro WITH dFecIngTpr
	     REPL PRO->nSueActPro WITH nSueActTpr
	     REPL PRO->lRetiroPro WITH .F.
	     REPL PRO->cRevisaPro WITH '000'
	     REPL PRO->lSiProfPro WITH .T.
	     PRO->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  PRO->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO EN EL BROWSE                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Localiza el c¢digo del Profesor dentro del Browse

2- Retorna NIL

SINTAXIS:

  BuscarPro(oBrowse)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarPro(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			      // Objeto Browse*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegPro := 0                   // Registro del Profesor
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTpr := ''               // C¢digo del banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTpr := cSpaces('PRO','cCodigoPro')
       TitBuscar(LEN(cCodigoTpr),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTpr PICT '999999';
			 VALID lValProfes(ROW()+2,COL()-20,@cCodigoTpr)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigoTpr == cSpaces('PRO','cCodigoPro')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT PRO
       IF lBuscar .AND. lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
	   nRegPro := RECNO()
	   GO TOP
	   oBrowse:GOTOP()
	   GO nRegPro
	   oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL PROFESOR                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro del archivo de acuerdo al nombre del Profesor

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelProfes(nNroFil,nNroCol,cAlias)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       cAlias                               // Alias del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegPro := 0		    // Registro del Profesor

       FIELD cNombrePro                     // Nombre del Profesor
       FIELD cApelliPro                     // Apellido del Profesor
       FIELD cMaeAluPro                     // Niveles donde dicta
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       cAlias := IF(EMPTY(cAlias),'PRO',cAlias)
       SELECT &cAlias
       IF RECCOUNT() == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT &cAlias
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+LEN(cApelliPro+cNombrePro)+12
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL PROFESOR
       SELECT &cAlias
       DBGOTOP()
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nRegPro := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			    {||RTRIM(cApelliPro)+' '+;
			       RTRIM(cNombrePro)+' ->'+;
			       cMaeAluPro},62)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nRegPro
*>>>>FIN SELECCION DEL PROFESOR

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 01/94 VIE A
						       JUL 01/94 VIE
OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodPro(cCodPro)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodPro			      // C¢digo del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF cCodPro # cSpaces('PRO','cCodigoPro')
	     
	  IF lLocCodigo('cCodigoPro','PRO',cCodPro)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO



FUNCTION lLeeProAnt(lShared,cPatSis,cAnoUsr)

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path Anterior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatAnt+'\'+;
		       FilePro+SUBS(cAnoAnt,3,2)+ExtFile,'TEM',NIL,lShared)
	  cError('NO EXISTEN PROFESORES PARA EL A¥O ANTERIOR')
	  CloseDbf('TEM')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PROFESORES DEL A¥O ANTERIOR
       SELECT TEM
       GO TOP
       DO WHILE .NOT. TEM->(EOF())

**********ANALISIS SI EL PROFESOR ESTA RETIRADO
	    IF TEM->lRetiroPro
	       SELECT TEM
	       SKIP
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL PROFESOR ESTA RETIRADO

**********GRABACION DEL REGISTRO
	    IF PRO->(lRegLock(lShared,.T.))
	       REPL PRO->cCodigoPro WITH TEM->cCodigoPro
	       REPL PRO->cCodigoOrg WITH TEM->cCodigoOrg
	       REPL PRO->cPasWorPro WITH TEM->cPasWorPro
	       REPL PRO->cNombrePro WITH TEM->cNombrePro
	       REPL PRO->cApelliPro WITH TEM->cApelliPro
	       REPL PRO->cDocNitPro WITH TEM->cDocNitPro
	       REPL PRO->cLugNitPro WITH TEM->cLugNitPro
	       REPL PRO->cLugNitPro WITH TEM->cLugNitPro
	       REPL PRO->dFecNacPro WITH TEM->dFecNacPro
	       REPL PRO->cDireccPro WITH TEM->cDireccPro
	       REPL PRO->cTelUnoPro WITH TEM->cTelUnoPro
	       REPL PRO->cTelDosPro WITH TEM->cTelDosPro
	       REPL PRO->cTituloPro WITH TEM->cTituloPro
	       REPL PRO->dFecTitPro WITH TEM->dFecTitPro
	       REPL PRO->nEscalaPro WITH TEM->nEscalaPro
	       REPL PRO->cResoluPro WITH TEM->cResoluPro
	       REPL PRO->cDictarPro WITH TEM->cDictarPro
	       REPL PRO->dFecIngPro WITH TEM->dFecIngPro
	       REPL PRO->lRetiroPro WITH .F.
	       REPL PRO->cRevisaPro WITH '000'
	       PRO->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       PRO->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  SELECT TEM
	  SKIP

       ENDDO
       RETURN .T.
*>>>>FIN LECTURA DE LOS PROFESORES DEL A¥O ANTERIOR


/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DEL PROGRAMA ACADEMICO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 23/97 JUE A
       Colombia, Bucaramanga        INICIO: 12:10 PM   ENE 23/97 JUE

OBJETIVOS:

1- Imprime el listado de los profesores

2- Debe estar en uso el archivo de los profesores

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnProfes(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
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

       LOCAL cNombreTpr := ''               // Nombre de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PRO->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := PRO->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'PROFESORES A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
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
       nLenPrn := n17Stan
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
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT PRO
       GO TOP
       DO WHILE .NOT. PRO->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PRO->(RECNO()) / PRO->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	    cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
	    aTitulo := {STR(++i,4),;
			PRO->cCodigoPro,;
			cNombreTpr,;
			PRO->cDocNitPro,;
			PRO->cLugNitPro,;
			ALLTRIM(PRO->cTelUnoPro)+'-'+;
			ALLTRIM(PRO->cTelDosPro),;
			SPACE(12)}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO DEL PROGRAMA..: GRABACION DE LOS DATOS DEL PROFESOR             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 05/97 LUN A
       Colombia, Bucaramanga        INICIO: 11:20 AM   MAY 05/97 LUN

OBJETIVOS:

1- Debe estar en uso el archivo de profesores del respectivo a¤o.

2- El archivo debe estar ubicado en el registro del profesor y debe estar
   bloqueado

3- Graba los datos Generales del profesor.

4- Retorna .T. si grabo sin problemas.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDatosPro(lShared,nFilInf,nColInf,cCodPro,cNombre)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila de lectura
       nColInf                              // Columna de lectura
       cCodPro				    // C¢digo del Profesor
       cNombre                              // Nombre del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero de Registro

       LOCAL cLugNacTpr := ''               // Lugar de nacimiento
       LOCAL dFecNacTpr := CTOD('00/00/00') // Fecha de nacimiento
       LOCAL cDocNitTpr := ''		    // Documento de identidad
       LOCAL cLugNitTpr := ''		    // Lugar de expedici¢n
       LOCAL cDireccTpr := ''		    // Direcci¢n
       LOCAL cBarrioTpr := ''		    // Barrio
       LOCAL cTelUnoTpr := ''		    // Telefono No. 1
       LOCAL cTelDosTpr := ''               // Telefono No. 2
       LOCAL cTelTreTpr := ''		    // Telefono No. 3
       LOCAL cTituloTpr := ''		    // T¡tulo
       LOCAL cUniTitTpr := ''		    // Universidad del T¡tulo
       LOCAL dFecTitTpr := CTOD('00/00/00') // Fecha del t¡tulo
       LOCAL nEscalaTpr := ''		    // N£mero del Escalafon
       LOCAL cResoluTpr := ''		    // Resoluci¢n del Escalafon
       LOCAL dFecIngTpr := CTOD('00/00/00') // Fecha de Ingreso
       LOCAL dFecRetTpr := CTOD('00/00/00') // Fecha de Retiro
       LOCAL cCargosTpr := ''		    // Cargos que ocupa

       LOCAL GetList    := {}               // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nTipCur := SETCURSOR(1)
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(nFilInf+1,'POR FAVOR LOS DATOS DEL PROFESOR',22,'°')
       nNroCol := nColInf
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+cCodPro
       @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+cNombre
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       SET ESCAPE ON
       SELECT PRO
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES TANOORALES
	    IF lGrabar
	       cLugNacTpr := PRO->cLugNacPro
	       dFecNacTpr := PRO->dFecNacPro
	       cDocNitTpr := PRO->cDocNitPro
	       cLugNitTpr := PRO->cLugNitPro
	       cDireccTpr := PRO->cDireccPro
	       cBarrioTpr := PRO->cBarrioPro
	       cTelUnoTpr := PRO->cTelUnoPro
	       cTelDosTpr := PRO->cTelDosPro
	       cTelTreTpr := PRO->cTelTrePro
	       cTituloTpr := PRO->cTituloPro
	       cUniTitTpr := PRO->cUniTitPro
	       dFecTitTpr := PRO->dFecTitPro
	       nEscalaTpr := PRO->nEscalaPro
	       cResoluTpr := PRO->cResoluPro
	       dFecIngTpr := PRO->dFecIngPro
	       dFecRetTpr := PRO->dFecRetPro
	       cCargosTpr := PRO->cCargosPro
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES TANOORALES


**********LECTURA DE LOS DATOS DEL CANDIDATO
	    nNroFil := nFilInf+6

	    @nNroFil,nNroCol+00   SAY 'NACIDO EN:';
				  GET cLugNacTpr PICT "@!";
				  VALID !EMPTY(cLugNacTpr)

	    @nNroFil++,nNroCol+37 SAY 'FECHA:';
				  GET dFecNacTpr;
				  VALID !EMPTY(dFecNacTpr)

	    @nNroFil  ,nNroCol+00 SAY 'DOCUMENTO:';
				  GET cDocNitTpr PICT "@!";
				  VALID !EMPTY(cDocNitTpr)

	    @nNroFil++,nNroCol+37 SAY 'DE:';
				  GET cLugNitTpr PICT "@!" ;
				  VALID !EMPTY(cLugNitTpr)

	    @++nNroFil,nNroCol+00 SAY 'DIRECCION:';
				  GET cDireccTpr PICT "@!";
				  VALID !EMPTY(cDireccTpr)

	    @nNroFil  ,nNroCol+53 SAY 'BARRIO:';
				  GET cBarrioTpr PICT "@!";
				  VALID !EMPTY(cBarrioTpr)

	    @++nNroFil,nNroCol    SAY 'TELEFONOS:';
				  GET cTelUnoTpr PICT "@!"

	    @nNroFil,nNroCol+22 SAY '-';
				GET cTelDosTpr PICT "@!"

	    @nNroFil++,nNroCol+36 SAY '-';
				GET cTelTreTpr PICT "@!"

	    @++nNroFil,nNroCol+00 SAY 'TITULO:';
				  GET cTituloTpr PICT "@!"

	    @nNroFil,nNroCol+40   SAY 'F.TITULO:';
				  GET dFecTitTpr

	    @++nNroFil,nNroCol    SAY 'UNIVERSIDAD:';
				  GET cUniTitTpr PICT "@!"

	    @++nNroFil,nNroCol    SAY 'ESCALAFON:';
				  GET nEscalaTpr PICT "99"

	    @nNroFil++,nNroCol+16 SAY 'RESOLUCION:';
				  GET cResoluTpr PICT "@!"

	    @++nNroFil  ,nNroCol+00 SAY 'CARGOS:';
				  GET cCargosTpr PICT "@!S30"

	    @++nNroFil,nNroCol+00 SAY 'F.INGRESO:';
				  GET dFecIngTpr PICT "@!";
				  VALID !EMPTY(dFecIngTpr)

	    @nNroFil,nNroCol+42 SAY 'F.RETIRO:';
				GET dFecRetTpr PICT "@!"

	    READ
**********FIN LECTURA DE LOS DATOS DEL CANDIDATO

**********PREGUNTA DE DECISION
	    DO CASE
	    CASE LASTKEY() # K_ESC
		 IF !lPregunta('DESEA GRABAR? Si No')
		    lGrabar := .F.
		    LOOP
		 ELSE
		    lGrabar := .T.
		 ENDIF

	    CASE LASTKEY() == K_ESC
		 lGrabar := .F.
		 IF !lPregunta('DESEA ABANDONAR? Si No')
		    LOOP
		 ENDIF
	    ENDCASE
**********FIN PREGUNTA DE DECISION

**********GRABACION DE LOS DATOS DEL CANDIDATO
	    SELECT PRO
	    IF lGrabar
	       IF lRegLock(lShared,.F.)
		  REPL PRO->cLugNacPro WITH cLugNacTpr
		  REPL PRO->dFecNacPro WITH dFecNacTpr
		  REPL PRO->cDocNitPro WITH cDocNitTpr
		  REPL PRO->cLugNitPro WITH cLugNitTpr
		  REPL PRO->cDireccPro WITH cDireccTpr
		  REPL PRO->cBarrioPro WITH cBarrioTpr
		  REPL PRO->cTelUnoPro WITH cTelUnoTpr
		  REPL PRO->cTelDosPro WITH cTelDosTpr
		  REPL PRO->cTelTrePro WITH cTelTreTpr
		  REPL PRO->cTituloPro WITH cTituloTpr
		  REPL PRO->cUniTitPro WITH cUniTitTpr
		  REPL PRO->nEscalaPro WITH nEscalaTpr
		  REPL PRO->cResoluPro WITH cResoluTpr
		  REPL PRO->dFecIngPro WITH dFecIngTpr
		  REPL PRO->dFecRetPro WITH dFecRetTpr
		  REPL PRO->cCargosPro WITH cCargosTpr
	       ELSE
		   cError('NO SE GRABA EL REGISTRO')
	       ENDIF

	       DBCOMMIT()
	       IF lShared
		  DBUNLOCK()
	       ENDIF

	    ENDIF
	    EXIT
**********FIN GRABACION DE LOS DATOS DEL CANDIDATO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(nTipCur)
       SET ESCAPE OFF
       RETURN lGrabar
*>>>>FIN LECTURA Y GRABACION DE LA HOJA DE VIDA


FUNCTION lLeeCargos(nNroFil,nNroCol,nFilOrg,nColOrg,cCargos)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil			            // Fila Principal
       nNroCol			            // Columna Principal
       nFilOrg			            // Fila Impresion de Conceptos
       nColOrg			            // Columna impresion Conceptos
       cCargos                              // @Cargos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL lSavPan := .T.                 // .T. Salvar Pantalla

       LOCAL       i := 0                   // Contador
       LOCAL cCodCar := ''                  // C¢digo de la carga
       LOCAL nNroCar := 1                   // N£mero de Cargos
       LOCAL nNroReg := 0                   // N£mero de Registro

       LOCAL cCodigoTor := ''               // C¢digo del Cargo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS CARGOS
       IF EMPTY(cCargos)
	  RETURN .T.
       ENDIF

       IF lPar(LEN(ALLTRIM(cCargos)))
	  FOR i := 1 TO LEN(ALLTRIM(cCargos))/2
	      cCodCar := SUBS(cCargos,i*2-1,2)
	      IF !lLocCodigo('cCodigoOrg','ORG',cCodCar)
		 lHayErr := .T.
		 LOOP
	      ENDIF
	      cCodigoTor += cCodCar
	  NEXT
       ELSE
	  @ nFilOrg,nColOrg SAY SPACE(LEN(cCargos)) COLOR("I")
	  cCodigoTor := ''
	  lHayErr := .T.
       ENDIF

       IF !lHayErr
	  RETURN .T.
       ENDIF
*>>>>FIN VALIDACION DE LOS CARGOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT ORG
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+30
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>LECTURA DE LOS CARGOS
       DO WHILE .T.

**********SELECCION DEL CODIGO DEL CARGO
	    SELECT ORG
	    ORG->(DBGOTOP())
	    nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
				  {||ORG->cNombreOrg},30,lSavPan)
	    IF nNroReg == 0
	       EXIT
	    ENDIF
**********FIN SELECCION DEL CODIGO DEL CARGO

**********ACUMULACION DEL CODIGO DEL CARGO
	    IF nNroReg <> 0

	       ORG->(DBGOTO(nNroReg))
	       IF ORG->cCodigoOrg $ cCodigoTor
		  cError('EL CARGO '+ALLTRIM(ORG->cNombreOrg)+;
			 ' YA LO APLICO')
	       ELSE

*--------------ANALISIS PARA EL LIMITE DE LOS CARGOS
		 IF nNroCar <= 2
		    cCodigoTor = cCodigoTor + ORG->cCodigoOrg
		    @ nFilOrg,nColOrg SAY cCodigoTor COLOR ("I")
		    nNroCar++
		 ELSE
		    cError('SOLO SE PUEDEN APLICAR SIETE (7) CARGOS',;
			   'A CONTINUACION SE GRABAN LOS CARGOS')
		    EXIT
		 ENDIF
*--------------FIN ANALISIS PARA EL LIMITE DE LOS CARGOS

	       ENDIF

	    ENDIF
**********FIN ACUMULACION DEL CODIGO DEL CARGO

       ENDDO
       cCargos := cCodigoTor+SPACE(LEN(cCargos)-LEN(cCodigoTor))
       RETURN .T.
*>>>>FIN LECTURA DE LOS CARGOS

/*************************************************************************
* TITULO DE LA FUNCION..: CONSULTA DE LOS DATOS DEL PROFESOR             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/97 LUN A
       Colombia, Bucaramanga        INICIO: 11:15 AM   MAY 26/97 LUN

OBJETIVOS:

1- Debe estar en uso el archivo en el registro correspondiente

2- Visualiza la informaci¢n personal del profesor.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ConsulPro(nFilInf,nColInf,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilInf                              // Fila de Impresi¢n
       nColInf                              // Columna de Impresi¢n
       cNalias                              // Alias del Maestro
       cTitulo                              // T¡tulo de la Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cTitulo := IF(cTitulo == NIL,'DETALLES DE LA HOJA DE VIDA',cTitulo)
       nNroFil := nMarco(nFilInf+1,cTitulo,22,'°')
       nNroCol := nColInf
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+PRO->cCodigoPro
       @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+ALLTRIM(PRO->cApelliPro)+' '+;
					   PRO->cNombrePro
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>IMPRSION DE LOS TITULOS
       nNroFil := nFilInf+6
       @nNroFil  ,nNroCol+00 SAY 'NACIDO EN:'
       @nNroFil++,nNroCol+37 SAY 'FECHA:'
       @nNroFil  ,nNroCol+00 SAY 'DOCUMENTO:'
       @nNroFil++,nNroCol+37 SAY 'DE:'
       @++nNroFil,nNroCol+00 SAY 'DIRECCION:'
       @nNroFil  ,nNroCol+53 SAY 'BARRIO:'
       @++nNroFil,nNroCol+00 SAY 'TELEFONOS:'
       @nNroFil  ,nNroCol+22 SAY '-'
       @nNroFil++,nNroCol+36 SAY '-'
       @++nNroFil,nNroCol+00 SAY 'TITULO:'
       @nNroFil  ,nNroCol+40 SAY 'F.TITULO:'
       @++nNroFil,nNroCol+00 SAY 'UNIVERSIDAD:'
       @++nNroFil,nNroCol+00 SAY 'ESCALAFON:'
       @nNroFil++,nNroCol+16 SAY 'RESOLUCION:'
       @++nNroFil,nNroCol+00 SAY 'CARGOS:'
       @++nNroFil,nNroCol+00 SAY 'F.INGRESO:'
       @nNroFil  ,nNroCol+42 SAY 'F.RETIRO:'
*>>>>FIN IMPRSION DE LOS TITULOS

*>>>>IMPRESION DE LOS DATOS
       nNroFil := nFilInf+6
       SET COLOR TO I

       @nNroFil  ,nNroCol+11 SAY PRO->cLugNacPro PICT "@!"

       @nNroFil++,nNroCol+44 SAY PRO->dFecNacPro

       @nNroFil  ,nNroCol+11 SAY PRO->cDocNitPro PICT "@!"

       @nNroFil++,nNroCol+41 SAY PRO->cLugNitPro PICT "@!"

       @++nNroFil,nNroCol+11 SAY PRO->cDireccPro PICT "@!"

       @nNroFil  ,nNroCol+61 SAY PRO->cBarrioPro PICT "@!"

       @++nNroFil,nNroCol+11 SAY PRO->cTelUnoPro PICT "@!"

       @nNroFil  ,nNroCol+24 SAY PRO->cTelDosPro PICT "@!"

       @nNroFil++,nNroCol+38 SAY PRO->cTelTrePro PICT "@!"

       @++nNroFil,nNroCol+08 SAY PRO->cTituloPro PICT "@!"

       @nNroFil  ,nNroCol+50 SAY PRO->dFecTitPro

       @++nNroFil,nNroCol+13 SAY PRO->cUniTitPro PICT "@!"

       @++nNroFil,nNroCol+11 SAY PRO->nEscalaPro PICT "99"

       @nNroFil++,nNroCol+28 SAY PRO->cResoluPro PICT "@!"

       @++nNroFil,nNroCol+08 SAY PRO->cCargosPro PICT "@!"

       @++nNroFil,nNroCol+11 SAY PRO->dFecIngPro PICT "@!"

       @nNroFil  ,nNroCol+52 SAY PRO->dFecRetPro
       SET COLOR TO

       cPausa()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DATOS

/*************************************************************************
* TITULO DE LA FUNCION..: VISUALIZACION DE LA CARGA              	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/98 VIE A
       Colombia, Bucaramanga        INICIO: 04:50 PM   MAR 06/98 VIE


OBJETIVOS:

1- Visualiza la Subdivision de una materia variable

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VerCarPro(lShared,cCodPro,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cCodPro                              // C¢digo del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA CARGA
       DO CASE
       CASE !PRO->lCargasPro
	    cError('NO TIENE CARGA ACADEMICA')

       CASE !(cMaeAct $ PRO->cMaeAluPro)
	    cError('NO TIENE CARGA ACADEMICA')

       OTHERWISE
	    lHayErr := .F.
       ENDCASE

       IF lHayErr
	  SELECT PRO
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA CARGA

*>>>>VISUALIZACION DEL BROWSE
       SELECT CAR
       SET FILTER TO CAR->cCodigoPro == cCodPro
       GO TOP

       CAR->(CtrlBrw(lShared,oDefCarPro(lShared,05,01,22,78)))
       SET FILTER TO
       SELECT PRO
       RETURN NIL
*>>>>FIN VISUALIZACION DEL BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE CARGAS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
				    INICIO: 03:43 PM   DIC 26/94 LUN

OBJETIVOS:
1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefCarPro(lShared,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwCar := NIL		    // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwCar := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwCar:ColSep    := '³'
       oBrwCar:HeadSep   := 'Ä'
       oBrwCar:Cargo     := {'<<CARGA ACADEMICA DE '+ALLTRIM(PRO->cNombrePro)+' >>'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CAR
       oColumn	     := TBCOLUMNNEW('GRUPO',{||SUBS(CAR->cCodigoCar,5,4)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCar:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||SUBS(CAR->cCodigoCar,1,4)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCar:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MATERIAS',;
			     {||cSekNomMat(SUBS(CAR->cCodigoCar,1,4),'CAR')})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 32
       oBrwCar:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO', {||IF(CAR->nTipCarCar==0,;
						  'NORMAL',;
						  IF(CAR->nTipCarCar==1,;
						     'POR GRUPO',;
						     IF(CAR->nTipCarCar==2,;
						     'POR NIVEL',;
						     IF(CAR->nTipCarCar==3,'POR NIVELES','ERROR'))))})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 12
       oBrwCar:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwCar
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: MENU DE INFORMES PARA EL BROWSE DEL PROFESOR   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 04/98 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   AGO 04/98 MAR

OBJETIVOS:

1- Menu de informes para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrPro(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		    cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		    cIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		    cJornad,oBrowse)

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
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       oBrowse			            // Browse del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'1<LISTADO DE PROFESORES>',;
		   '2<ORDENAR POR APELLIDO >',;
		   '3<ACTIVAR REVISION     >',;
		   '4<DESACTIVAR REVISION  >',;
		   '5<ASIGNACION ACADEMICA >',;
		   '6<GRABAR HORARIO       >',;
		   '7<ASIGNACION ACADEMICA >',;
		   '8<PROFESORES CARGA ACAD>',;
		   '9<ENCRIPTAR CLAVES     >'}

       aAyuda := {'Imprime el listado de los profesores',;
		  'Ordenar los profesores por apellido',;
		  'Activar la revisi¢n de los estudiantes',;
		  'Desactiva la revisi¢n de los profesores',;
		  'Imprime los Profesores con su asignaci¢n Acad‚mica',;
		  'Graba el Horario del Profesor',;
		  'Imprime los Profesores con su asignaci¢n Acad‚mica',;
		  'Profesores con asignaci¢n acad‚mica',;
		  'Permite Encriptar y Descriptar las Claves de los Profesores'}

       SAVE SCREEN
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTORE SCREEN
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    PrnProfes(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt)
*	    PrnProfes1(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt)

       CASE nNroOpc == 2
	    OrdenaPro(lShared,cAnoUsr,cPatSis,oBrowse)
	   *Ordenar por apellido

       CASE nNroOpc == 3
	    RevEstPro(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt,oBrowse,.T.)
	   *Activar revision de Estudiantes .T.

       CASE nNroOpc == 4
	    RevEstPro(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt,oBrowse,.F.)
	   *Deactivar revision de Estudiantes .T.

       CASE nNroOpc == 5
	    PrnProfCar(lShared,cNomEmp,cNomSis,cAnoUsr,cPatSis,cMaeAct,cJorTxt)

       CASE nNroOpc == 6
	    GraHorPro(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		      cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		      cIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		      cJornad,oBrowse)

       CASE nNroOpc == 7
	    PrnProfHor(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cPatSis,;
		       cIntUno,cMaeAct,cJorTxt)

       CASE nNroOpc == 8
	    ProfCarga(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		      cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		      cIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		      cJornad,oBrowse)
	   *Profesores con carga.

       CASE nNroOpc == 9
	    EncPasPro(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt,oBrowse)
	   *Encriptar Claves de los Profesores

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO DEL PROGRAMA..: INTERVALO DE PROFESORES                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   MAY 27/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de grupos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite selecionar un intervalo de grupos.

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervPro(nNroFil,nNroCol,nRegIni,nRegFin,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nRegIni                              // @Registro Inicial
       nRegFin                              // @Registro Final
       cNalias                              // Alias del Archivo del profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar l¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegTem := 0                   // Registro temporal
       LOCAL nLenBrw := 0                   // Longitud del Browse

       FIELD cNombrePro                     // Nombre del Profesor
       FIELD cApelliPro                     // Apellido del Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt = 'PROF INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'PROF FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	cNalias := IF(EMPTY(cNalias),'PRO',cNalias)
	SELECT &cNalias

	nNroCol = nNroCol + LEN(cMsgTxt)+1
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - 1
	ENDIF
	nLenBrw := LEN(&cNalias->cNombrePro)+LEN(&cNalias->cNombrePro)/2
	nColInf := nColSup+nLenBrw

	DBGOTOP()
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||RTRIM(cApelliPro)+' '+cNombrePro})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	DBGOTO(nRegIni)
	@ nFilSup,nColSup SAY SUBS(RTRIM(&cNalias->cApelliPro)+' '+;
					 &cNalias->cNombrePro,1,nLenBrw)
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       DBGOTOP()
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			    {||RTRIM(cApelliPro)+' '+cNombrePro})
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       DBGOTO(nRegFin)
       @ nFilSup+1,nColSup SAY SUBS(RTRIM(&cNalias->cApelliPro)+' '+;
					  &cNalias->cNombrePro,1,nLenBrw)
*>>>>FIN CAPTURA DEL INTERVALO FINAL

*>>>>INTERCAMBIO DE REGISTROS
       IF nRegIni > nRegFin
	  nRegTem = nRegIni
	  nRegIni = nRegFin
	  nRegFin = nRegTem
       ENDIF
       RETURN .T.
*>>>>FIN INTERCAMBIO DE REGISTROS

/*************************************************************************
* TITULO DE LA FUNCION..: REVISAR ESTUDIANTES DEL PROFESOR               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 12/99 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   FEB 12/99 VIE

OBJETIVOS:

1- Activa el campo para la revisi¢n de estudiantes cuando el profesor
   ingrese al sistema de Profesores.

2- Debe estar en uso el archivo de los profesores

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevEstPro(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt,oBrowse,lRevisa)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       oBrowse			            // Browse del Profesor
       lRevisa                              // .T. Activa Revisi¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nAvance := 0                   // Avance del Termometro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PRO->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ACTIVACION DEL CAMPO DE REVISAR A ESTUDIANTES
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,IF(lRevisa,'ACTIVANDO','DESACTIVANDO')+' LA REVISION')

       SELECT PRO
       GO TOP
       DO WHILE .NOT. PRO->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PRO->(RECNO()) / PRO->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ACTIVACION O DESACTIVACION DE LA REVISION
	    IF PRO->(lRegLock(lShared,.F.))
	       IF lRevisa
		  REPL PRO->cRevisaPro WITH '111'
	       ELSE
		  REPL PRO->cRevisaPro WITH '000'
	       ENDIF
	       PRO->(DBCOMMIT())
	    ENDIF
	    IF lShared
	       PRO->(DBUNLOCK())
	    ENDIF
**********FIN ACTIVACION O DESACTIVACION DE LA REVISION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN ACTIVACION DEL CAMPO DE REVISAR A ESTUDIANTES

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

FUNCTION OrdenaPro(lShared,cAnoUsr,cPatSis,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       oBrowse			            // Browse del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PRO->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN NIL
       ENDIF
       CloseDbf('PRO')
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,cPatSis+'\'+;
		    FilePro+cAnoSis+ExtFile,'cApelliPro')
	  cError('NO SE ORDENO EL MAESTRO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO PROFESORES')
	  RETURN NIL
       ENDIF
       SELECT PRO
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO ..: PROFESORES CON ASIGNACION ACADEMICA                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/2007 JUE A
       Colombia, Bucaramanga        INICIO: 10:30 PM   MAY 03/2007 JUE

OBJETIVOS:

1- Imprime el listado de los profesores con asignaci¢n acad‚mica.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ProfCarga(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		   cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		   cIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		   cJornad,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
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
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       oBrowse			            // Browse del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
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
       LOCAL cColPrn := ''                  // Columna de Impresi¢n
       LOCAL cCampo  := ''                  // Contenido del Campo

       LOCAL PathPrn := 'PRINTER'           // Path para impresiones
       LOCAL aStrPrn := {}                  // Estructura del Archivo
     *ÀVariables de informe

       LOCAL   i,k,y := 0                   // Contador
       LOCAL nNroPer := 0                   // Total Periodos
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cCodAct := ''                  // C¢digo Actual
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL lRegUno := .T.                 // .T. Primer Registro
       LOCAL nJuiSAp := 0                   // Juicios Si Aprobados
       LOCAL nJuiNAp := 0                   // Juicios No Aprobados
       LOCAL aJvfMat := {}                  // Total Juicios Valorativos por materia
       LOCAL lPorcen := .F.                 // .T. Imprimir Porcentajes
       LOCAL lPrnMat := .F.                 // .T. Imprimir detalles de materias
       LOCAL cTitCol := ''                  // T¡tulo de la columna

       LOCAL nNroReg := 0                   // N£mero de registro
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aStdMat := {}                  // Estadistica de la materia
       LOCAL aStdGru := {}                  // Estadistica por Grupo
       LOCAL aTotStd := {}                  // Total de Estadisticas
       LOCAL aMatPrn := {}                  // Materias a Imprimir
       LOCAL nGruPrn := 0                   // N£mero de Grupos impresos

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())
       nLenPrn := PCL('n17Stan')

       IF SCO->lPrnArcCon
          SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'doccarga'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.,2)
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
		   'PROFESORES CON ASIGNACION ACADEMICA. A¥O:'+cAnoUsr,;
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
       aJvfMat := {}

       cTitCol := 'No.'
       AADD(aNroCol,4)
       AADD(aTitPrn,cTitCol)
       AADD(aStrPrn,{cTitCol,'Character',4,0})

       cTitCol := 'CODIGO'
       AADD(aNroCol,6)
       AADD(aTitPrn,cTitCol)
       AADD(aStrPrn,{cTitCol,'Character',6,0})

       cTitCol := 'APELLIDOS NOMBRES'
       AADD(aNroCol,40)
       AADD(aTitPrn,cTitCol)
       AADD(aStrPrn,{cTitCol,'Character',40,0})

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN FIN ENCABEZADOS DE COLUMNA

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

*>>>>RECORRIDO POR GRUPOS
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT PRO
       PRO->(DBGOTOP())
       DO WHILE .NOT. PRO->(EOF())

**********LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('PROFESOR:'+ALLTRIM(STR(PRO->(RECNO())),9)+'/'+;
				    ALLTRIM(STR(PRO->(RECCOUNT())),9),'')
	    SET DEVICE TO PRINT
**********FIN LINEA DE ESTADO

**********ANALISIS DE DECISION
	    IF EMPTY(PRO->cMaeAluPro)

	       SELECT PRO
	       PRO->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE DECISION

**********IMPRESION DEL REGISTRO
	    nNroReg++
	    aRegPrn := {}

	    cCampo := nNroReg
	    cCampo := cCampoPrn({cCampo,'N',4,0})
	    AADD(aRegPrn,cCampo)

	    cCampo := PRO->cCodigoPro
	    cCampo := cCampoPrn({cCampo,'C',6,0})
	    AADD(aRegPrn,cCampo)

	    cCampo := ALLTRIM(PRO->cApelliPro)+' '+;
		      ALLTRIM(PRO->cNombrePro)
	    cCampo := SUBS(cCampo+SPACE(40),1,40)
	    cCampo := cCampoPrn({cCampo,'C',40,0})
	    AADD(aRegPrn,cCampo)

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
		    bCabeza)
**********FIN IMPRESION DEL REGISTRO

	  SELECT PRO
	  PRO->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION PROFESORES Y ASIGNACION ACADEMICA    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 31/2000 LUN A
       Colombia, Bucaramanga        INICIO: 11:45 PM   ENE 31/2000 LUN

OBJETIVOS:

1- Imprime el listado de los profesores con su carga acad‚mica.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnProfCar(lShared,cNomEmp,cNomSis,cAnoUsr,cPatSis,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
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
       LOCAL lCarga  := .F.                 // .T. Tiene Carga Acad‚mica.
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL nTotHor := 0                   // Total Horas
       LOCAL nIntHor := 0                   // Intensidad Horaria
       LOCAL cCursos := ''                  // Cursos
       LOCAL cMatAnt := ''                  // Materia Anterior
       LOCAL nTotal  := 0                   // Total ?
       LOCAL cIntens := ''                  // Intensidad
     *ÀVariables espec¡ficas

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cNombreTpr := ''               // Nombre de la materia
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO ESTAN CREADAS LAS ASIGNACIONES ACADEMICAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>NOMBRE DEL NIVEL
       DO CASE
       CASE cMaeAct == 'JAR'
	    cNomNiv := 'JARDIN'
       CASE cMaeAct == 'PRI'
	    cNomNiv := 'PRIMARIA'
       CASE cMaeAct == 'BTO'
	    cNomNiv := 'BACHILLERATO'
       ENDCASE
*>>>>FIN NOMBRE DEL NIVEL

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := PRO->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'PROFESORES A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   cNomNiv,;
		   'ASIGNACION ACADEMICA',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,100,06}
       aTitulo := {'CODIGO',;
		   'NOMBRE',;
		   'HORAS'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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
       ActivaPrn(lShared,cNomSis,PathSis,fSimaCo,'cColaAcCon','Con')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	  RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT PRO
       GO TOP
       DO WHILE .NOT. PRO->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PRO->(RECNO()) / PRO->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********FILTRACION DE LOS PROFESORES
	    SELECT CAR
	    SET FILTER TO CAR->cCodigoPro == PRO->cCodigoPro
	    GO TOP
	    IF CAR->(EOF())
	       SET FILTER TO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LOS PROFESORES

**********IMPRESION DEL REGISTRO
	    cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	    cNombreTpr := SUBS(cNombreTpr+SPACE(100),1,100)
	    aTitulo := {PRO->cCodigoPro,;
			cNombreTpr,;
			SPACE(06)}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********IMPRESION DE LA ASIGNACION ACADEMICA
	    SELECT CAR
	    GO TOP
	    cMatAnt := SUBS(CAR->cCodigoCar,1,4)
	    cCursos := ''
	    nIntHor := 0
	    nTotHor := 0
	    DO WHILE .NOT. CAR->(EOF())

*--------------LOCALIZACION DE LA MATERIA
		 cCodigoTma := SUBS(CAR->cCodigoCar,1,4)
		 cCodigoTgr := SUBS(CAR->cCodigoCar,5,4)
		 IF lLocCodigo('cCodigoMat','MAT',cMatAnt)
		    cNombreTma := cCodigoTma+'->'+MAT->cNombreMat
		 ELSE
		    cNombreTma := cCodigoTma+'-> MATERIA NO EXISTE'
		 ENDIF
		 cNombreTma := SUBS(cNombreTma+SPACE(100),1,100)
*--------------FIN LOCALIZACION DE LA MATERIA

*--------------IMPRESION DE LA ASIGNACION ACADEMICA
		 IF cMatAnt # cCodigoTma

*...................IMPRESION DE LA MATERIA
		      aTitulo := {'DICTA',;
				  cNombreTma,;
				  SPACE(06)}
		      cTxtPrn := cRegPrint(aTitulo,aNroCol)
		      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*...................FIN IMPRESION DE LA MATERIA

*...................IMPRESION DE LOS CURSOS DONDE DICTA
		      nTotal := INT(LEN(cCursos)/100)+;
				IF(MOD(LEN(cCursos),100) # 0,1,0)
		      FOR i := 1 TO nTotal

			cIntens := SUBS(cCursos+SPACE(100),i*100-99,100)
			aTitulo := {'EN',;
				    cIntens,;
				    IF(i==nTotal,STR(nIntHor,2),SPACE(06))}
			cTxtPrn := cRegPrint(aTitulo,aNroCol)
			lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		      NEXT
*...................FIN IMPRESION DE LOS CURSOS DONDE DICTA

		    cMatAnt := cCodigoTma
		    cCursos := ''
		    nIntHor := 0

		 ELSE

		    cCursos += cCodigoTgr+':'+CAR->cIntHorPla+'h  '
		    IF SUBS(CAR->cIntHorPla,1,1) == '.'
		       nIntHor += VAL('.'+SUBS(CAR->cIntHorPla,2,1))
		    ELSE
		       IF ISDIGIT(ALLTRIM(CAR->cIntHorPla))
			  nIntHor += VAL(CAR->cIntHorPla)
		       ENDIF
		    ENDIF
		    nTotHor += nIntHor
		 ENDIF
*--------------FIN IMPRESION DE LA ASIGNACION ACADEMICA

	       CAR->(DBSKIP())

	    ENDDO
**********FIN IMPRESION DE LA ASIGNACION ACADEMICA

**********IMPRESION DEL TOTAL DE HORAS DEL PROFESOR
	    aTitulo := {SPACE(06),;
			SUBS('TOTAL HORAS'+SPACE(100),1,100),;
			STR(nTotHor,5,2)}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    lPrnReg(01,nColCab,REPL('-',LEN(cTxtPrn)),bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL TOTAL DE HORAS DEL PROFESOR

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION HORARIO DE LOS PROFESORES            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 01/2000 MIE A
       Colombia, Bucaramanga        INICIO: 11:45 PM   FEB 01/2000 MIE

OBJETIVOS:

1- Imprime el listado de los profesores con su respectivo horario.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnProfHor(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cPatSis,cIntUno,;
		    cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cIntUno                              // Primera Integraci¢n
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

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
       LOCAL lCarga  := .F.                 // .T. Tiene Carga Acad‚mica.
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL lCarPro := .T.                 // .T. Carga en Profesores
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL aCarCon := {}                  // Carga en Contabilida
       LOCAL aCarPro := {}                  // Carga en Profesores
       LOCAL cPatPro := ''                  // Path de Profesores
     *ÀVariables espec¡ficas

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cNombreTpr := ''               // Nombre de la materia
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO ESTAN CREADAS LAS ASIGNACIONES ACADEMICAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>NOMBRE DEL NIVEL
       DO CASE
       CASE cMaeAct == 'JAR'
	    cNomNiv := 'JARDIN'
       CASE cMaeAct == 'PRI'
	    cNomNiv := 'PRIMARIA'
       CASE cMaeAct == 'BTO'
	    cNomNiv := 'BACHILLERATO'
       ENDCASE
*>>>>FIN NOMBRE DEL NIVEL

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := PRO->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'PROFESORES A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   cNomNiv,;
		   'ASIGNACION ACADEMICA',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,94,06}
       aTitulo := {'CURSO',;
		   'NOMBRE',;
		   'IH'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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

*>>>>ANALISIS DE DECISION
       IF lPregunta('DESEA IMPRIMIR TODOS LOS PROFESORES? No Si')
	  PRO->(DBGOTOP())
	  nRegIni := PRO->(RECNO())
	  PRO->(DBGOBOTTOM())
	  nRegFin := PRO->(RECNO())
	  PRO->(DBGOTOP())
       ELSE
	  nRegIni := PRO->(RECNO())
	  nRegFin := nRegIni
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECION DEL TIPO DE IMPRESION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'cargapro'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT PRO
       PRO->(DBGOTO(nRegIni))
       DO WHILE PRO->(RECNO()) <= nRegFin

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PRO->(RECNO()) / PRO->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********FILTRACION DE LOS PROFESORES
	    SELECT CAR
	    SET FILTER TO CAR->cCodigoPro == PRO->cCodigoPro
	    GO TOP
	    IF CAR->(EOF())
	       SET FILTER TO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LOS PROFESORES

**********CREACION DE LA CARGA DE CONTABILIDAD
	    aCarCon := {}
	    SELECT CAR
	    GO TOP
	    DO WHILE .NOT. CAR->(EOF())
	       AADD(aCarCon,{CAR->cCodigoCar,CAR->cIntHorPla})
	       CAR->(DBSKIP())
	    ENDDO
**********FIN CREACION DE LA CARGA DE CONTABILIDAD

**********ANALISIS DE LA CARGA EN SIMAPROF
	    lCarPro := .T.
	    cPatPro := cIntUno+'\'+PRO->cCodigoPro
	    IF .NOT. FILE(cPatPro+'\'+FilePro+ExtFile) .OR.;
	       .NOT. FILE(cPatPro+'\'+FCarPro+cAnoSis+ExtFile)
	       lCarPro := .F.
	    ENDIF
**********FIN ANALISIS DE LA CARGA EN SIMAPROF

**********SELECION DE LAS AREAS DE TRABAJO
	    CloseDbf('CAP')
	    IF lCarPro
	       IF !lUseDbf(.T.,cPatPro+'\'+;
			   FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)

		  cError('ABRIENDO ARCHIVOS CARGA DEL PROFESOR '+;
			 PRO->cCodigoPro)
		  CloseDbf('CAP')
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********CREACION DE LA CARGA DE CONTABILIDAD
	    IF lCarPro
	       SELECT CAP
	       GO TOP
	       aCarPro := {}
	       DO WHILE .NOT. CAP->(EOF())
		  AADD(aCarPro,CAP->cCodigoCar)
		  CAP->(DBSKIP())
	       ENDDO
	    ENDIF
**********FIN CREACION DE LA CARGA DE CONTABILIDAD

**********ANALISIS DE LAS CARGAS
	    lHayErr := .F.
	    IF lCarPro
	       IF LEN(aCarCon) == LEN(aCarPro)
		  FOR i := 1 TO LEN(aCarCon)
		      IF aCarCon[i,1] # aCarPro[i]
			 lHayErr := .T.
			 EXIT
		      ENDIF
		  ENDFOR
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE LAS CARGAS

**********IMPRESION DEL REGISTRO
	    cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	    cNombreTpr := SUBS(cNombreTpr+SPACE(86),1,86)

	    IF lCarPro
	       aTitulo := {SPACE(06),;
			   PRO->cCodigoPro+'->'+cNombreTpr,;
			   IF(lHayErr,'ERROR',SPACE(06))}
	    ELSE
	       aTitulo := {SPACE(06),;
			   PRO->cCodigoPro+'->'+cNombreTpr,'*'}
	    ENDIF

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********IMPRESION DE LA ASIGNACION ACADEMICA
	    FOR i := 1 TO LEN(aCarCon)

*--------------LOCALIZACION DE LA MATERIA
		 cCodigoTma := SUBS(aCarCon[i,1],1,4)
		 cCodigoTgr := SUBS(aCarCon[i,1],5,4)
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma)
		    cNombreTma := cCodigoTma+'->'+MAT->cNombreMat
		 ELSE
		    cNombreTma := cCodigoTma+'-> MATERIA NO EXISTE'
		 ENDIF
		 cNombreTma := SUBS(cNombreTma+SPACE(94),1,94)
*--------------FIN LOCALIZACION DE LA MATERIA

*--------------IMPRESION DE LA ASIGNACION ACADEMICA
		 aTitulo := {cCodigoTgr,;
			     cNombreTma,;
			     aCarCon[i,2]}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*--------------FIN IMPRESION DE LA ASIGNACION ACADEMICA

	    ENDFOR
	    cTxtPrn := REPL('=',LEN(cTxtPrn))
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DE LA ASIGNACION ACADEMICA

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO DE LA FUNCION..: GRABACION DEL HORARIO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 03/2000 JUE A
       Colombia, Bucaramanga        INICIO: 01:45 PM   FEB 03/2000 JUE

OBJETIVOS:

1- Permite Grabar el Horario del Profesor

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION GraHorPro(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		   cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		   cIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		   cJornad,oBrowse)

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
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas
       oBrowse			            // Browse del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna
       LOCAL nNroDia := 0                   // N£mero del D¡a
       LOCAL cTipAsi := ''                  // Tipo de Asignaci¢n
       LOCAL cCodAsi := ''                  // C¢digo de la Asignaci¢n
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nNroHor := 0                   // N£mero de Hora
       LOCAL cCodHor := ''                  // C¢digo del Horario
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoThr := ''               // C¢digo de la Hora
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCamHorPro := ''               // Campo del Horario del Profesor
       SETCURSOR(1)
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE HRA->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS HORAS DEL HORARIO')

       CASE FUN->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS FUNCIONES DEL PERSONAL')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO SE EXISTE LOS GRUPOS CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(nFilPal+1)
       cCabeza := cRegPrint({'HORA',;
			     'DIA',;
			     'DICTA',;
			     'CURSO'},;
			     {04,04,06,06},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza+' PROFESOR '+;
			  ALLTRIM(RTRIM(PRO->cNombrePro)+' '+PRO->cApelliPro)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DEL HORARIO
       lHayErr := .F.
       DO WHILE .T.

**********LECTURA DEL DIA Y HORA
	    IF .NOT. lHayErr
		  nNroDia := 0
		  cTipAsi := ''
		  cCodAsi := SPACE(04)
	       cCodigoThr := SPACE(02)
	       cCodigoTgr := SPACE(04)
	    ENDIF
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)

	    @ nNroFil,aNroCol[1] GET cCodigoThr PICT '99';
				 VALID lValCodHra(ROW(),COL()-2,@cCodigoThr)

	    @ nNroFil,aNroCol[2] GET nNroDia PICT '9';
				 VALID lnValDia(ROW(),COL()-1,@nNroDia)

	    @ nNroFil,aNroCol[3] GET cTipAsi PICT '9';
				 VALID lValTipAsi(ROW(),COL()-1,@cTipAsi)


	    READ
**********FIN LECTURA DEL DIA Y HORA

**********LECTURA DE LA ASIGNACION ACADEMICA
	    DO CASE
	    CASE cTipAsi == '1'
		 @ nNroFil,aNroCol[3] GET cCodAsi PICT '9999';
			   VALID lValMateria(ROW(),COL()-4,@cCodAsi)
		 @ nNroFil,aNroCol[4] GET cCodigoTgr PICT '9999'
		 READ

	    CASE cTipAsi == '2'
		 @ nNroFil,aNroCol[3] GET cCodAsi PICT '@!';
			   VALID lValCodFun(ROW(),COL()-1,@cCodAsi)
		 @ nNroFil,aNroCol[4] GET cCodigoTgr PICT '9999'
		 READ

	    OTHERWISE
		 cCodAsi := ''
	    ENDCASE
**********FIN LECTURA DE LA ASIGNACION ACADEMICA

**********ANALISIS DE LA LECTURA
	    nNroOpc := nLeeOpcion('SELECIONE: '+;
		      '1<GRABAR> 2<CORREGIR> 3<TERMINAR>?',3,'0')

	    lHayErr := .T.
	    DO CASE
	    CASE nNroOpc == 2
		 LOOP
	    CASE nNroOpc == 3
		 EXIT
	    ENDCASE
**********FIN ANALISIS DE LA LECTURA

**********VALIDACION DE LA LECTURA
	    IF EMPTY(nNroDia) .OR. EMPTY(cCodigoThr) .OR.;
	       EMPTY(cCodAsi)
	       cError('DEBE INGRESAR TODOS LOS DATOS SOLICITADOS')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA LECTURA

**********VALIDACION DEL CODIGO DEL GRUPO
	    IF !EMPTY(cCodigoTgr)
	       IF !lLocCodigo('cCodigoGru','GRU',cCodigoTgr)
		  cError('EL GRUPO '+cCodigoTgr+' NO EXISTE')
		  LOOP
	       ENDIF
	    ENDIF
	    lHayErr := .F.
**********FIN VALIDACION DEL CODIGO DEL GRUPO

**********GRABACION DEL HORARIO
	    nNroHor := VAL(cCodigoThr)
	    cCodHor := cCodigoTgr+cCodAsi
	    cCamHorPro := 'cHor'+cDia(nNroDia,3)+'Pro'

	    SELECT PRO
	    IF PRO->(lRegLock(lShared,.F.))
	       REPL &cCamHorPro WITH;
		    STUFF(&cCamHorPro,nNroHor*8-7,8,cCodHor)
	       PRO->(DBCOMMIT())
	       IF lShared
		  PRO->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL HORARIO

**********CONTROL DE LA FILA DE VISUALIZACION
	    nNroFil++
	    IF nNroFil > 20

*--------------VISUALIZACION DEL ULTIMO REGISTRO
		  nNroFil := nMarco(nFilPal+1)
		  @ nNroFil-2,01 SAY cCabeza

		  SET COLOR TO I
		  @ nNroFil,aNroCol[1] SAY nNroDia
		  SET COLOR TO
		  @ nNroFil,aNroCol[2] SAY cCodigoThr
		  SET COLOR TO I
		  @ nNroFil,aNroCol[3] SAY cCodigoTma
		  SET FILTER TO
		  nNroFil++
*--------------FIN VISUALIZACION DEL ULTIMO REGISTRO

	     ENDIF
***********CONTROL DE LA FILA DE VISUALIZACION

       ENDDO
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN GRABACION DEL HORARIO

/*************************************************************************
* TITULO..: GRABACION DATOS DEL PROFESOR                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 22/2002 JUE A
       Colombia, Bucaramanga        INICIO: 03:13 PM   AGO 22/2002 JUE

OBJETIVOS:

1- Permite Actualizar la informaci¢n del profesor

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lHojaVida(lShared,nFilInf,nColInf,cNroIns,;
		   cNombre,cCodGru,nNroOpc,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila de lectura
       nColInf                              // Columna de lectura
       cNroIns                              // N£mero de Inscripci¢n
       cNombre                              // Nombre del Estudiante
       cCodGru                              // C¢digo del grupo
       nNroOpc                              // Opci¢n de Actualizaci¢n
       oBrowse			            // Browse de Consulta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL cSexFem := ''                  // Sexo del Estudiante

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cLugNacTes := ''               // Lugar de nacimiento
       LOCAL dFecNacTes := ''               // Fecha de nacimiento
       LOCAL cDocNitTes := ''		    // Documento de identidad
       LOCAL cLugNitTes := ''		    // Lugar de expedici¢n
       LOCAL cTipNitTes := ''               //*Tipo del Documento
       LOCAL lSexFemTes := .F.              //*Sexo del Estudiante
       LOCAL cDireccTes := ''		    // Direcci¢n del candidato
       LOCAL cBarrioTes := ''		    // Barrio
       LOCAL cCiudadTes := ''               //*Ciudad del Estudiante
       LOCAL cTelefnTes := ''		    // Telefono de la residencia
       LOCAL cMaiEstTes := ''               //*E-MAIL de la Casa o del Estudiante
       LOCAL cApePadTes := ''               //*Apellido del padre
       LOCAL cNomPadTes := ''		    // Nombre del padre
       LOCAL cPadNitTes := ''               // C‚dula del padre
       LOCAL cPadLugTes := ''               // Lugar de la c‚dula
       LOCAL cPadTntTes := ''               //*Tipo del Documento
       LOCAL cDirPadTes := ''               //*Direcci¢n del Padre
       LOCAL cBarPadTes := ''               //*Barrio del Padre
       LOCAL cCiuPadTes := ''               //*Ciudad del Padre
       LOCAL cProPadTes := ''		    // Profesi¢n del padre
       LOCAL cEmpPadTes := ''		    // Empresa del padre
       LOCAL cCarPadTes := ''		    // Cargo del padre
       LOCAL cTelPadTes := ''               // Telefono del padre
       LOCAL cMaiPadTes := ''               // E-MAIL del Padre
       LOCAL cApeMadTes := ''               //*Apellido de la madre
       LOCAL cNomMadTes := ''		    // Nombre de la madre
       LOCAL cMadNitTes := ''               // C‚dula de la madre
       LOCAL cMadLugTes := ''               // Lugar de la c‚dula
       LOCAL cMadTntTes := ''               //*Tipo del Documento
       LOCAL cDirMadTes := ''               //*Direcci¢n de la Madre
       LOCAL cBarMadTes := ''               //*Barrio de la Madre
       LOCAL cCiuMadTes := ''               //*Ciudad de la Madre
       LOCAL cProMadTes := ''		    // Profesi¢n de la madre
       LOCAL cEmpMadTes := ''		    // Empresa de la madre
       LOCAL cCarMadTes := ''		    // Cargo de la madre
       LOCAL cTelMadTes := ''		    // Telefono de la madre
       LOCAL cMaiMadTes := ''               // E-MAIL de la Madre
       LOCAL cApeAcuTes := ''               //*Apellido del Acudiente
       LOCAL cNomAcuTes := ''		    // Nombre del acudiente
       LOCAL cAcuNitTes := ''               // C‚dula del acudiante
       LOCAL cAcuLugTes := ''               // Lugar de la c‚dula
       LOCAL cAcuTntTes := ''               //*Tipo del Documento
       LOCAL cDirAcuTes := ''               //*Direcci¢n del Acudiente
       LOCAL cBarAcuTes := ''               //*Barrio del Acudiente
       LOCAL cCiuAcuTes := ''               //*Ciudad del Acudiente
       LOCAL cTe1AcuTes := ''		    // Telefono casa acudiente
       LOCAL cTe2AcuTes := ''		    // Telefono oficina acudiente
       LOCAL cMaiAcuTes := ''               // E-MAIL del Acudiente
       LOCAL cParAcuTes := ''               //*Parentesco del Acudiente

       LOCAL GetList    := {}               // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF !EMPTY(oBrowse)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  SET CURSOR ON
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>MENU DE ACTUALIZACION
       IF EMPTY(nNroOpc)
	  AADD(aMenus,'1<INFORMACION PERSONAL>')
	  AADD(aMenus,'2<INFORMACION FAMILIAR>')
	  AADD(aAyuda,'Actualiza la Informaci¢n Personal')
	  AADD(aAyuda,'Actualiza la Informaci¢n Familiar')

	  nNroOpc := 1
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := nMenu(aMenus,aAyuda,10,25,'ACTUALIZAR',NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nNroOpc == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN MENU DE ACTUALIZACION

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,;
		  IF(nNroOpc==1,;
		     'POR FAVOR ACTUALICE LA INFORMACION DEL ESTUDIANTE',;
		     'CODIGO: '+ADM->cNumeroAdm+' '+cNombreTes+' '+;
		     'CURSO : '+ADM->cCodigoGru),22,'°')

       nNroCol := nColInf
       IF nNroOpc == 1
	  @ nNroFil,nNroCol+00 SAY 'CODIGO: '+ADM->cCodigoEst
	  @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+RTRIM(ADM->cApelliEst)+' '+;
						    ADM->cNombreEst
	  @ nNroFil,nNroCol+65 SAY 'CURSO : '+ADM->cCodigoGru
       ENDIF
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,;
		  IF(nNroOpc==1,;
		     'POR FAVOR ACTUALICE LA INFORMACION DEL ESTUDIANTE',;
		     'CODIGO: '+cNroIns+' '+cNombre+' '+;
		     'CURSO : '+cCodGru),22,'°')

       nNroCol := nColInf
       IF nNroOpc == 1
	  @ nNroFil,nNroCol+00 SAY 'CODIGO: '+cNroIns
	  @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+cNombre
	  @ nNroFil,nNroCol+65 SAY 'CURSO : '+cCodGru
       ENDIF
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       SET ESCAPE ON
       SELECT ADM
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES TEMPORALES
	    IF lGrabar
	       DO CASE
	       CASE nNroOpc == 1  // INFORMACION PERSONAL

		    cLugNacTes := ADM->cLugNacEst
		    dFecNacTes := ADM->dFecNacEst
		    cDocNitTes := ADM->cDocNitEst
		    cLugNitTes := ADM->cLugNitEst
		    cTipNitTes := ADM->cTipNitEst
		    lSexFemTes := ADM->lSexFemEst
		    IF lSexFemTes
		       cSexFem := 'F'
		    ELSE
		       cSexFem := 'M'
		    ENDIF
		    cDireccTes := ADM->cDireccEst
		    cBarrioTes := ADM->cBarrioEst
		    cCiudadTes := ADM->cCiudadEst
		    cTelefnTes := ADM->cTelefnEst
		    cMaiEstTes := ADM->cMaiEstEst

	       CASE nNroOpc == 2  // INFORMACION DE LOS PADRES

		    cApePadTes := ADM->cApePadEst
		    cNomPadTes := ADM->cNomPadEst
		    cPadNitTes := ADM->cPadNitEst
		    cPadLugTes := ADM->cPadLugEst
		    cPadTntTes := ADM->cPadTntEst
		    cDirPadTes := ADM->cDirPadEst
		    cBarPadTes := ADM->cBarPadEst
		    cCiuPadTes := ADM->cCiuPadEst
		    cProPadTes := ADM->cProPadEst
		    cEmpPadTes := ADM->cEmpPadEst
		    cCarPadTes := ADM->cCarPadEst
		    cTelPadTes := ADM->cTelPadEst
		    cMaiPadTes := ADM->cMaiPadEst
		  *ÀInformaci¢n del Padre

		    cApeMadTes := ADM->cApeMadEst
		    cNomMadTes := ADM->cNomMadEst
		    cMadNitTes := ADM->cMadNitEst
		    cMadLugTes := ADM->cMadLugEst
		    cMadTntTes := ADM->cMadTntEst
		    cDirMadTes := ADM->cDirMadEst
		    cBarMadTes := ADM->cBarMadEst
		    cCiuMadTes := ADM->cCiuMadEst
		    cProMadTes := ADM->cProMadEst
		    cEmpMadTes := ADM->cEmpMadEst
		    cCarMadTes := ADM->cCarMadEst
		    cTelMadTes := ADM->cTelMadEst
		    cMaiMadTes := ADM->cMaiMadEst
		  *ÀInformaci¢n de la Madre

	       CASE nNroOpc == 3  // INFORMACION DEL ACUDIENTE

		    cApeAcuTes := ADM->cApeAcuEst
		    cNomAcuTes := ADM->cNomAcuEst
		    cAcuNitTes := ADM->cAcuNitEst
		    cAcuLugTes := ADM->cAcuLugEst
		    cAcuTntTes := ADM->cAcuTntEst
		    cDirAcuTes := ADM->cDirAcuEst
		    cBarAcuTes := ADM->cBarAcuEst
		    cCiuAcuTes := ADM->cCiuAcuEst
		    cTe1AcuTes := ADM->cTe1AcuEst
		    cTe2AcuTes := ADM->cTe2AcuEst
		    cParAcuTes := ADM->cParAcuEst
		    cMaiAcuTes := ADM->cMaiAcuEst
		  *ÀInformaci¢n del Acudiente

	       ENDCASE
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES TEMPORALES

**********ACTUALIZACION DE LA INFORMACION DEL ESTUDIANTE
	    DO CASE
	    CASE nNroOpc == 1

*----------------INFORMACION PERSONAL
		   nNroFil := nFilInf+6
		   @nNroFil,nNroCol+00   SAY 'NACIDO EN:';
					 GET cLugNacTes PICT "@!";
					 VALID !EMPTY(cLugNacTes)

		   @nNroFil,nNroCol+40 SAY 'FECHA:';
					 GET dFecNacTes;
					 VALID !EMPTY(dFecNacTes)

		   @nNroFil++,nNroCol+59 SAY 'SEXO:';
					 GET cSexFem;
					 VALID lValSexo(ROW(),COL()-1,;
					       @cSexFem,@lSexFemTes)

		   @nNroFil  ,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cDocNitTes PICT "9999999999999999";
					 VALID !EMPTY(cDocNitTes)

		   @nNroFil  ,nNroCol+28 SAY 'TIPO:';
					 GET cTipNitTes PICT "@!";
					 VALID lValTipNit(ROW(),COL()-1,;
							  @cTipNitTes)

		   @nNroFil++,nNroCol+40 SAY 'DE:';
					 GET cLugNitTes PICT "@!" ;
					 VALID !EMPTY(cLugNitTes)


		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDireccTes PICT "@!S40";
					 VALID !EMPTY(cDireccTes)

		   @nNroFil++  ,nNroCol+53 SAY 'BARRIO:';
					   GET cBarrioTes PICT "@!";
					   VALID !EMPTY(cBarrioTes)

		   @nNroFil,nNroCol+00   SAY 'CIUDAD   :';
					 GET cCiudadTes PICT "@!S30";
					 VALID !EMPTY(cCiudadTes)

		   @nNroFil++,nNroCol+43 SAY 'TELEFONO:';
					 GET cTelefnTes PICT "@!"

		   @nNroFil++,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiEstTes PICT "@!"
*----------------FIN INFORMACION PERSONAL

	    CASE nNroOpc == 2

*----------------ACTUALIZACION DE LOS DATOS DEL PADRE
		   nNroFil := nFilInf+3

		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS PADRE:';
					 GET cApePadTes PICT "@!S20";
					 VALID !EMPTY(cApePadTes)

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES PADRE:';
					 GET cNomPadTes PICT "@!S25";
					 VALID !EMPTY(cNomPadTes)

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cPadNitTes PICT "9999999999999999";
					 VALID !EMPTY(cPadNitTes)

		   @nNroFil,nNroCol+28 SAY 'TIPO:';
				       GET cPadTntTes PICT "@!";
				       VALID lValTipNit(ROW(),COL()-1,;
							@cPadTntTes)

		   @nNroFil,nNroCol+38 SAY 'DE:';
					 GET cPadLugTes PICT "@!S16";
					 VALID !EMPTY(cPadLugTes)

		   @nNroFil++,nNroCol+59 SAY 'TEL:';
					 GET cTelPadTes PICT "@!9"

		   @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					 GET cEmpPadTes PICT "@!";
					 VALID !EMPTY(cEmpPadTes)

		   @nNroFil++,nNroCol+38  SAY 'CARGO:';
					 GET cCarPadTes PICT "@!";
					 VALID !EMPTY(cCarPadTes)

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDirPadTes PICT "@!S45";
					 VALID !EMPTY(cDirPadTes)

		   @nNroFil++  ,nNroCol+52 SAY 'BARRIO:';
					   GET cBarPadTes PICT "@!";
					   VALID !EMPTY(cBarPadTes)

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiuPadTes PICT "@!S29";
					 VALID !EMPTY(cCiuPadTes)

		   @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					 GET cProPadTes PICT "@!" ;
					 VALID !EMPTY(cProPadTes)

		   @nNroFil++,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiPadTes PICT "@!"
*----------------FIN ACTUALIZACION DE LOS DATOS DEL PADRE

*----------------ACTUALIZACION DE LOS DATOS DE LA MADRE
		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS MADRE:';
					 GET cApeMadTes PICT "@!S20";
					 VALID !EMPTY(cApeMadTes)

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES MADRE:';
					 GET cNomMadTes PICT "@!S25";
					 VALID !EMPTY(cNomMadTes)

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cMadNitTes PICT "9999999999999999";
					 VALID !EMPTY(cMadNitTes)

		   @nNroFil  ,nNroCol+28 SAY 'TIPO:';
					 GET cMadTntTes PICT "@!";
					 VALID lValTipNit(ROW(),COL()-1,;
							  @cMadTntTes)

		   @nNroFil,nNroCol+38 SAY 'DE:';
					 GET cMadLugTes PICT "@!S16";
					 VALID !EMPTY(cMadLugTes)

		   @nNroFil++,nNroCol+59 SAY 'TEL:';
					 GET cTelMadTes PICT "@!9"

		   @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					 GET cEmpMadTes PICT "@!";
					 VALID !EMPTY(cEmpMadTes)

		   @nNroFil++,nNroCol+38  SAY 'CARGO:';
					 GET cCarMadTes PICT "@!";
					 VALID !EMPTY(cCarMadTes)

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDirMadTes PICT "@!S45";
					 VALID !EMPTY(cDirMadTes)

		   @nNroFil++,nNroCol+52 SAY 'BARRIO:';
					   GET cBarMadTes PICT "@!";
					   VALID !EMPTY(cBarMadTes)

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiuMadTes PICT "@!S29";
					 VALID !EMPTY(cCiuMadTes)

		   @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					 GET cProMadTes PICT "@!" ;
					 VALID !EMPTY(cProMadTes)

		   @nNroFil++,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiMadTes PICT "@!"
*----------------FIN ACTUALIZACION DE LOS DATOS DE LA MADRE

	    CASE nNroOpc == 3

*----------------ACTUALIZACION DE LOS DATOS DEL ACUDIENTE
		   nNroFil := nFilInf+3

		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS ACUDIENTE:';
					 GET cApeAcuTes PICT "@!S16";
					 VALID !EMPTY(cApeAcuTes)

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES ACUDIENTE:';
					 GET cNomAcuTes PICT "@!S21";
					 VALID !EMPTY(cNomAcuTes)

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cAcuNitTes PICT "@!S11 9999999999999999";
					 VALID !EMPTY(cAcuNitTes)

		   @nNroFil,nNroCol+23 SAY 'TIPO:';
				       GET cAcuTntTes PICT "@!";
				       VALID lValTipNit(ROW(),COL()-1,;
							@cAcuTntTes)

		   @nNroFil,nNroCol+33 SAY 'DE:';
				       GET cAcuLugTes PICT "@!S12";
				       VALID !EMPTY(cAcuLugTes)

		   @nNroFil++,nNroCol+50 SAY 'PARENTESCO:';
					 GET cParAcuTes PICT "@!";
					 VALID !EMPTY(cParAcuTes)

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDirAcuTes PICT "@!S45";
					 VALID !EMPTY(cDirAcuTes)

		   @nNroFil++  ,nNroCol+52 SAY 'BARRIO:';
					   GET cBarAcuTes PICT "@!";
					   VALID !EMPTY(cBarAcuTes)

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiuAcuTes PICT "@!S29";
					 VALID !EMPTY(cCiuAcuTes)

		   @nNroFil  ,nNroCol+38 SAY 'TEL CASA:';
					 GET cTe1AcuTes PICT "@!S10"
		   @nNroFil  ,nNroCol+59 SAY 'TEL OFI:';
					 GET cTe2AcuTes PICT "@!S10"

		   @++nNroFil,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiAcuTes PICT "@!"

*----------------FIN ACTUALIZACION DE LOS DATOS DEL ACUDIENTE

	    ENDCASE
	    READ
**********FIN ACTUALIZACION DE LA INFORMACION DEL ESTUDIANTE

**********PREGUNTA DE DECISION
	    DO CASE
	    CASE LASTKEY() # K_ESC
		 IF !lPregunta('DESEA GRABAR? Si No')
		    lGrabar := .F.
		    LOOP
		 ELSE
		    lGrabar := .T.
		 ENDIF

	    CASE LASTKEY() == K_ESC
		 lGrabar := .F.
		 IF !lPregunta('DESEA ABANDONAR? Si No')
		    LOOP
		 ENDIF
	    ENDCASE
**********FIN PREGUNTA DE DECISION

**********GRABACION DE LOS DATOS DEL CANDIDATO
	    IF lGrabar
	       IF ADM->(lRegLock(lShared,.F.))
		  DO CASE
		  CASE nNroOpc == 1

*----------------------GRABACION DE LA INFORMACION PERSONAL
			 REPL ADM->cLugNacEst WITH cLugNacTes
			 REPL ADM->dFecNacEst WITH dFecNacTes
			 REPL ADM->cDocNitEst WITH cDocNitTes
			 REPL ADM->cLugNitEst WITH cLugNitTes
			 REPL ADM->cTipNitEst WITH cTipNitTes
			 REPL ADM->lSexFemEst WITH lSexFemTes
			 REPL ADM->cDireccEst WITH cDireccTes
			 REPL ADM->cBarrioEst WITH cBarrioTes
			 REPL ADM->cCiudadEst WITH cCiudadTes
			 REPL ADM->cTelefnEst WITH cTelefnTes
			 REPL ADM->cMaiEstEst WITH cMaiEstTes
*----------------------FIN GRABACION DE LA INFORMACION PERSONAL

		  CASE nNroOpc == 2

*----------------------GRABACION DE LA INFORMACION DE LOS PADRES
			 REPL ADM->cApePadEst WITH cApePadTes
			 REPL ADM->cNomPadEst WITH cNomPadTes
			 REPL ADM->cPadNitEst WITH cPadNitTes
			 REPL ADM->cPadLugEst WITH cPadLugTes
			 REPL ADM->cPadTntEst WITH cPadTntTes
			 REPL ADM->cDirPadEst WITH cDirPadTes
			 REPL ADM->cBarPadEst WITH cBarPadTes
			 REPL ADM->cCiuPadEst WITH cCiuPadTes
			 REPL ADM->cProPadEst WITH cProPadTes
			 REPL ADM->cEmpPadEst WITH cEmpPadTes
			 REPL ADM->cCarPadEst WITH cCarPadTes
			 REPL ADM->cTelPadEst WITH cTelPadTes
			 REPL ADM->cMaiPadEst WITH cMaiPadTes
		       *ÀGrabaci¢n de la Informaci¢n del Padre

			 REPL ADM->cApeMadEst WITH cApeMadTes
			 REPL ADM->cNomMadEst WITH cNomMadTes
			 REPL ADM->cMadNitEst WITH cMadNitTes
			 REPL ADM->cMadLugEst WITH cMadLugTes
			 REPL ADM->cMadTntEst WITH cMadTntTes
			 REPL ADM->cDirMadEst WITH cDirMadTes
			 REPL ADM->cBarMadEst WITH cBarMadTes
			 REPL ADM->cCiuMadEst WITH cCiuMadTes
			 REPL ADM->cProMadEst WITH cProMadTes
			 REPL ADM->cEmpMadEst WITH cEmpMadTes
			 REPL ADM->cCarMadEst WITH cCarMadTes
			 REPL ADM->cTelMadEst WITH cTelMadTes
			 REPL ADM->cMaiMadEst WITH cMaiMadTes
		       *ÀGrabaci¢n de la Informaci¢n de la Madre
*----------------------FIN GRABACION DE LA INFORMACION DE LOS PADRES

		  CASE nNroOpc == 3

*----------------------GRABACION DE LA INFORMACION DEL ACUDIENTE
			 REPL ADM->cApeAcuEst WITH cApeAcuTes
			 REPL ADM->cNomAcuEst WITH cNomAcuTes
			 REPL ADM->cAcuNitEst WITH cAcuNitTes
			 REPL ADM->cAcuLugEst WITH cAcuLugTes
			 REPL ADM->cAcuTntEst WITH cAcuTntTes
			 REPL ADM->cDirAcuEst WITH cDirAcuTes
			 REPL ADM->cBarAcuEst WITH cBarAcuTes
			 REPL ADM->cCiuAcuEst WITH cCiuAcuTes
			 REPL ADM->cTe1AcuEst WITH cTe1AcuTes
			 REPL ADM->cTe2AcuEst WITH cTe2AcuTes
			 REPL ADM->cParAcuEst WITH cParAcuTes
			 REPL ADM->cMaiAcuEst WITH cMaiAcuTes
		       *ÀGrabaci¢n de la Informaci¢n del Acudiente
*----------------------FIN GRABACION DE LA INFORMACION DEL ACUDIENTE

		  ENDCASE
	       ELSE
		   cError('NO SE GRABA EL REGISTRO')
	       ENDIF

	       DBCOMMIT()
	       IF lShared
		  DBUNLOCK()
	       ENDIF

	    ENDIF
	    EXIT
**********FIN GRABACION DE LOS DATOS DEL CANDIDATO

       ENDDO
*>>>>FIN LECTURA Y GRABACION DE LA HOJA DE VIDA

*>>>>ANALISIS DE DECISION
       IF !EMPTY(oBrowse)
	  SET CURSOR OFF
	  RESTSCREEN(0,0,24,79,cSavPan)
	  nNroReg := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nNroReg
	  oBrowse:FORCESTABLE()
       ENDIF
       SET ESCAPE OFF
       RETURN lGrabar
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL TIPO ASIGNACION                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 03/2000 JUE A
       Colombia, Bucaramanga        INICIO: 04:10 AM   FEB 03/2000 JUE

OBJETIVOS:

1- Realiza la validaci¢n del tipo de Horario

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValTipAsi(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<ASIGNATURA   >',;
		  '2<NO ASIGNATURA>'}

       aAyudas := {'Asignatura',;
		   'Asignaci¢n que no es una asignatura'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       cSavPan := SAVESCREEN(0,0,24,79)
       DO WHILE .T.
	  nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)

	  IF nNroOpc == 0
	     LOOP
	  ENDIF

	  cCodigo := SUBS('12',nNroOpc,1)
	  EXIT
       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: ENCRIPTAR LAS CLAVES DE LOS PRESORES                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2004 JUE A
       Colombia, Bucaramanga        INICIO: 08:45 AM   MAR 04/2004 JUE

OBJETIVOS:

1- Permite encriptar y desencriptar las claves de los profesores

2- Debe estar en uso el archivo de los profesores

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EncPasPro(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       oBrowse			            // Browse del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION)

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nAvance := 0                   // Avance del Termometro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PRO->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ACTIVACION DEL CAMPO DE REVISAR A ESTUDIANTES
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'PROCESANDO LA ENCRIPTACION')

       SELECT PRO
       PRO->(DBGOTOP())
       DO WHILE .NOT. PRO->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PRO->(RECNO()) / PRO->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ENCRIPTACION O DESCRIPTACION DE LA CLAVE
	    IF PRO->(lRegLock(lShared,.F.))

	       IF PRO->lCryPasPro .AND. !PRO->lSiCrypPro
		  REPL PRO->cPasWorPro WITH cEncry(PRO->cPasWorPro)
		  REPL PRO->lSiCrypPro WITH .T.
	       ENDIF

	       IF !PRO->lCryPasPro .AND. PRO->lSiCrypPro
		  REPL PRO->cPasWorPro WITH cEncry(PRO->cPasWorPro,.F.)
		  REPL PRO->lSiCrypPro WITH .F.
	       ENDIF

	       PRO->(DBCOMMIT())
	    ENDIF
	    IF lShared
	       PRO->(DBUNLOCK())
	    ENDIF
**********FIN ENCRIPTACION O DESCRIPTACION DE LA CLAVE

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN ACTIVACION DEL CAMPO DE REVISAR A ESTUDIANTES

/*************************************************************************
* TITULO..: LISTADO DE LOS PROFESORES                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 23/97 JUE A
       Colombia, Bucaramanga        INICIO: 12:10 PM   ENE 23/97 JUE

OBJETIVOS:

1- Imprime el listado de los profesores

2- Debe estar en uso el archivo de los profesores

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnProfes1(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del usuario
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroIso := 0                   // N£mero Iso del Informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL aTitIso := {}                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}                  // Textos del pie de p gina
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n
       LOCAL lSelPrn := .F.                 // .T. Selecionar Impresora
       LOCAL lFrmArc := .F.                 // .T. Formato de Archivo
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL cNalias := ''                  // Alias del Archivo a imprimir
       LOCAL aRegPrn := ''                  // Registros para impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nNroIso := 2
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<INICIO><CONSULTAR PROFESORES><F9>LISTADO DE PROFESORES'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'PROFESORES.'+;
		    'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
     *ÀPie de p gina por defecto

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>DETALLES DEL INFORME
       lPrnArc := SCO->lPrnArcCon
       FilePrn := 'Profe'+cAnoUsr
       cOpcPrn := SCO->cOpcPrnCon
       lSelPrn := .T.
       lFrmArc := .T.
*>>>>FIN DETALLES DEL INFORME

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,08,52,16,20,22,12}
       aTitPrn := {'No. ',;
		   'CODIGO',;
		   'NOMBRE',;
		   'CEDULA',;
		   'DE',;
		   'TELEFONOS',;
		   'OBSERVACION'}

/*
       aNroCol := {06}
       aTitPrn := {'CODIGO'}
*/

       aCabSec := NIL
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>CAMPOS A IMPRIMIR
       aRegPrn := {}
       AADD(aRegPrn,STR(PRO->(RECNO()),4,0))
       AADD(aRegPrn,{||PRO->cCodigoPro})
       AADD(aRegPrn,{||cNomPro(52)})
       AADD(aRegPrn,{||PRO->cDocNitPro})
       AADD(aRegPrn,{||PRO->cLugNitPro})
       AADD(aRegPrn,ALLTRIM(PRO->cTelUnoPro)+'-'+ALLTRIM(PRO->cTelDosPro))
       AADD(aRegPrn,SPACE(12))

/*
       aRegPrn := {}
       AADD(aRegPrn,{||PRO->cCodigoPro})
*/
*>>>>FIN CAMPOS A IMPRIMIR

*>>>>IMPRESION DEL INFORME
       cNalias := 'PRO'
       PrinterInf(lShared,cNomSis,cNomEmp,cNomUsr,nNroIso,cOpcSys,aMezIso,;
		  aTitIso,cPiePag,aPieIso,lPrnArc,FilePrn,cOpcPrn,lSelPrn,;
		  lFrmArc,aTitPrn,aNroCol,aCabSec,cNalias,aRegPrn)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: NOMBRE DEL PROFESOR                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 22/2006 MAR A
       Colombia, Bucaramanga        INICIO: 12:10 PM   AGO 22/2006 MAR

OBJETIVOS:

1- Retorna el nombre del profesor

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomPro(nLenNom)

*>>>>DESCRIPCION DE PARAMETROS
/*     nLenNom                              // Longitud del Nombre */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNombreTpr := ''               // Nombre del profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL PROFESOR
       cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
       cNombreTpr := SUBS(cNombreTpr+SPACE(nLenNom),1,nLenNom)
       RETURN cNombreTpr
*>>>>FIN NOMBRE DEL PROFESOR