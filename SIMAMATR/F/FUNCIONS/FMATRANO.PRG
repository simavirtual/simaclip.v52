/*                       SIMA - MATRICULA ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION DEL A¥O

REQUERIMIENTOS:

- Compilar: clipper FMatrAno /w/m/b

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
       Colombia, Bucaramanga        INICIO: 02:45 PM   JUL 19/96 VIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfAno(lShared,PathAno,FileAno,fNtxAno,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathAno				    // Path del Archivo
       FileAno				    // Nombre del Archivo
       fNtxAno				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfAno := {{"cIntUnoAno","Character",070,0},; // Path de Integraci¢n No. 1
			 {"cIntDosAno","Character",070,0},; // Path de Integraci¢n No. 2
			 {"cIntTreAno","Character",070,0},; // Path de Integraci¢n No. 3
			 {"cIntCuaAno","Character",070,0},; // Path de Integraci¢n No. 4
			 {"cMaeHabAno","Character",009,0},; // Maestros Habilitados para el A¤o
			 {"cJorHabAno","Character",004,0},; // Jornadas Habilitadas
			 {"nNroAdmAno","Numeric"  ,004,0},; // Contador de Inscripciones alumnos nuevos
			 {"nVlrAdmAno","Numeric"  ,010,0},; // Valor de la Inscripci¢n.
			 {"nNroProAno","Numeric"  ,004,0},; // Contador de Inscripciones de profesores nuevos
			 {"lHayInsAno","Logico"   ,001,0},; // .T. Inscripciones Abiertas
			 {"lPrnAdmAno","Logico"   ,001,0},; // .T. Imprimir las Inscripciones
			 {"nTipAdmAno","Numeric"  ,002,0},; // Tipo de formulario de Inscripci¢n
			 {"nTipOrdAno","Numeric"  ,002,0},; // Tipo de formulario de Orden de Matricula
			 {"nTipMtrAno","Numeric"  ,002,0},; // Tipo de formulario de Hoja de Matricula
			 {"lHayMtrAno","Logico"   ,001,0},; // .T. Matriculas Abiertas
			 {"lHayCntAno","Logico"   ,001,0},; // .T. Validar los Contratantes
			 {"lActInfAno","Logico"   ,001,0},; // .T. Actualizar la informaci¢n junto con los contratantes
			 {"lPrnEmpAno","Logico"   ,001,0},; // .T. Imprimir la Nombre de la Empresa
			 {"lPrnMtrAno","Logico"   ,001,0},; // .T. Imprimir la matr¡cula
			 {"lPrnRecAno","Logico"   ,001,0},; // .T. Imprimir recibos de Matr¡cula
			 {"lHayExaAno","Logico"   ,001,0},; // .T. Hay Evaluaci¢n
			 {"lHayEntAno","Logico"   ,001,0},; // .T. Hay Entrevistas
			 {"nRecNroAno","Numeric"  ,002,0},; // Clase de Recibo identificado por c¢digo
			 {"nTipFacAno","Numeric"  ,002,0},; // 1->Matr¡cula 2->Pensi¢n 3->Ambas
			 {"lPrePrnAno","Logical"  ,001,0},; // .T. Imprimir Forma Preimpresa
			 {"lPreMzpAno","Logical"  ,001,0},; // .T. Imprimir con configuraci¢n de Columnas
			 {"lLeeInfAno","Logical"  ,001,0},; // .T. Leer Informaci¢n de contacto
			 {"lHayNroAno","Logical"  ,001,0},; // .T. Controlar N£mero Consecutivo
			 {"nNroFacAno","Numeric"  ,009,0},; // N£mero Consecutivo de la Factura
			 {"cNroCupAno","Character",072,0},; // N£mero de Cupos
			 {"nNroExaAno","Numeric",  002,0},; // N£mero de Notas para el examen
			 {"nNroEntAno","Numeric"  ,002,0},; // N£mero de Notas para la entrevista
			 {"cCodBanAno","Character",002,0},; // C¢digo del Banco para facturaci¢n
			 {"cCodTrcAno","Character",002,0},; // C¢digo del Tipo de Recibo
			 {"cConMatAno","Character",014,0},; // Conceptos para la matricula
			 {"cConPenAno","Character",014,0},; // Conceptos para la pension
			 {"lIntMatAno","Logical"  ,001,0},; // .T. Utilizar interes por mora y no valor de recargo para lo no pagos o pagos extemporaneos
			 {"nIntMatAno","Numeric"  ,005,2},; // Intereses para la matricula
			 {"nMorMatAno","Numeric"  ,010,2},; // Valor recargo por pago extemporaneo o no pago
			 {"lIntPenAno","Logical"  ,001,0},; // .T. Utilizar interes por mora y no valor de recargo para lo no pagos o pagos extemporaneos
			 {"nIntPenAno","Numeric"  ,005,2},; // Intereses para la pension
			 {"nMorPenAno","Numeric"  ,010,2},; // Valor recargo por pago extemporaneo o no pago
			 {"dOpoMatAno","Date"     ,008,0},; // Fecha para pago oportuno. Matr¡cula
			 {"dExtMatAno","Date"     ,008,0},; // Fecha para pago extemporaneo. Matr¡cula
			 {"lExtMatAno","Logical"  ,001,0},; // Visualizar Fecha extemporanea. Matr¡cula
			 {"dOpoPenAno","Date"     ,008,0},; // Fecha para pago oportuno. Pension
			 {"dExtPenAno","Date"     ,008,0},; // Fecha para pago extemporaneo. Pensi¢n
			 {"lExtPenAno","Logical"  ,001,0},; // Visualizar Fecha Extemporanea
			 {"lLeeFecAno","Logical"  ,001,0},; // .T. Leer Fecha de pago .F. Leer forma de pago
			 {"lSinGruAno","Logical"  ,001,0},; //*.F. Con Grupo Anterior .T. Sin Grupo Anterior
			 {"lValGruAno","Logical"  ,001,0},; //*.T. Validar el Grupo para matricular.
			 {"cMensajAno","Character",080,0},; // Mensaje para la facturaci¢n
			 {"lLeeObsAno","Logical"  ,001,0},; // .T. Leer Observaci¢n individual para cada inscripci¢n
			 {"cMenIncAno","Character",127,0},; // Mensaje para la Inscripci¢n
			 {"cObsUnoAno","Character",144,0},; // Observaci¢n No. 1. Inscripci¢n.
			 {"cObsDosAno","Character",144,0},; // Observaci¢n No. 2. Inscripci¢n.
			 {"cObsTreAno","Character",144,0},; // Observaci¢n No. 3. Inscripci¢n.
			 {"cObsMtrAno","Character",134,0},; // Observaci¢n para la Hoja de Matr¡cula
			 {"nTipLisAno","Numeric"  ,002,0},; // Tipo de lista de Clase
			 {"nLinEspAno","Numeric"  ,002,0},; // N£mero de l¡neas para el encabezado
			 {"cAnoMtrAno","Character",004,0},; // A¤o para procesar las matr¡culas
			 {"cAnoAluAno","Character",004,0},; // A¤o para el Maestro de Estudiantes
			 {"lSisbenAno","Logical"  ,001,0},; // .T. Hay Sisben
			 {"lMtrResAno","Logical"  ,001,0},; // .T. Matriculas Restricci¢n
			 {"lNomConDes","Logical"  ,001,0},; // .T. Habilitar el Concepto para Descuentos y Recargos en la facturaci¢n
			 {"cValConAno","Character",012,0},; // Validaci¢n de la Contabilidad
			 {"lEstAntAno","Logical"  ,001,0}}  // .T. Hay Estudiantes Antiguos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfAno
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathAno) == 0
	    DBCREATE(FileAno,aDbfAno,"DBFNTX")

       CASE DIRCHANGE(PathAno) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathAno)

       CASE DIRCHANGE(PathAno) == -5
	    cError('NO TIENE DERECHOS EN: '+PathAno)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathAno+'\'+FileAno,'ANO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF ANO->(lRegLock(lShared,.T.))
	  REPL ANO->lHayInsAno WITH .T.  // Hay Inscripciones
	  REPL ANO->lHayMtrAno WITH .T.  // Hay Matriculas para el a¤o
	  REPL ANO->lPrnAdmAno WITH .T.  // Imprimir Solicitud de cupo
	  REPL ANO->nTipAdmAno WITH 1    // Inscripci¢n        No. 1
	  REPL ANO->nTipOrdAno WITH 1    // Orden de Matr¡cula No. 1
	  REPL ANO->nTipMtrAno WITH 1    // Hoja de Matr¡cula  No. 1
	  REPL ANO->lPrnMtrAno WITH .T.  // Imprimir Hoja de Matr¡cula
	  REPL ANO->lPrnRecAno WITH .T.  // Imrpimir Recibos de Matr¡cula
	  REPL ANO->lHayExaAno WITH .F.  // .T. Hay Examen
	  REPL ANO->lHayEntAno WITH .F.  // .T. Hay Entrevistas
	  REPL ANO->nTipFacAno WITH 1    // 1:Matricula 2:Pension 3:Ambos
	  REPL ANO->nRecNroAno WITH 1    // Recibo No. 1 por defecto
	  REPL ANO->lPrePrnAno WITH .F.  // Imprimir recibo todo impreso
	  REPL ANO->lPreMzpAno WITH .F.  // Imprimir con columnas Mzp
	  REPL ANO->lLeeFecAno WITH .T.  // *.F. Leer forma de pago.
	  REPL ANO->lSinGruAno WITH .F.  // Con Grupo Anterior para antiguos
	  REPL ANO->lValGruAno WITH .T.  // Validar el Grupo para la Matricula.
	  REPL ANO->nNroFacAno WITH 0    // N£mero Consecutivo en Cero
	  REPL ANO->lHayNroAno WITH .F.  // No controlar consecutivo
	  REPL ANO->lIntPenAno WITH .T.  // *.T. Interes por mora .F. Valor por Mora
	  REPL ANO->nMorPenAno WITH 0    // *Valor por mora
	  REPL ANO->lIntMatAno WITH .T.  // *.T. Interes por mora .F. Valor por Mora
	  REPL ANO->nMorMatAno WITH 0    // *Valor por mora
	  REPL ANO->nNroExaAno WITH 5    // Notas por defecto para examenes
	  REPL ANO->nNroEntAno WITH 5    // Notas por defecto para entrevistas
	  REPL ANO->lExtMatAno WITH .T.  // Utilizar Fecha Extemporanea para la matr¡cula
	  REPL ANO->lExtPenAno WITH .T.  // Utilizar Fecha Extemporanea para la matr¡cula
	  REPL ANO->lHayCntAno WITH .T.  // .T. Validar Contratantes
	  REPL ANO->lActInfAno WITH .T.  // .T. Actualizar infomaci¢n junto contratantes
	  REPL ANO->cMensajAno WITH 'RECONSTRUYENDO EL PRESENTE PARA '+;
				    'LA SOCIEDAD DEL FUTURO'
	  REPL ANO->cIntUnoAno WITH '\Sima\SimaCont'
	  REPL ANO->cIntDosAno WITH '\Sima\SimaCart'
	  REPL ANO->cIntTreAno WITH ''
	  REPL ANO->cIntCuaAno WITH ''
	  REPL ANO->lLeeObsAno WITH .F.
	  REPL ANO->lLeeInfAno WITH .T.   // Leer del Contacto
	  REPL ANO->cObsUnoAno WITH 'LA PRESENTE SOLICITUD NO REPRESENTA '+;
				    'NINGUN TIPO DE COMPROMISO POR PARTE '+;
				    'DE LA INSTITUCION Y NO HABRA '+;
				    'DEVOLUCION DE DINERO.'

	  REPL ANO->cObsDosAno WITH 'LA POSIBLE ASIGNACION DE CUPO DEPENDERA '+;
				    'DE LA DISPONIBILIDAD DE LOS MISMOS.'

	  REPL ANO->cObsTreAno WITH 'POR POLITICA INSTITUCIONAL, NO SE '+;
				    'RECIBEN ESTUDIANTES NUEVOS PARA LOS '+;
				    'GRADOS DECIMO Y UNDECIMO.'

	  REPL ANO->cObsMtrAno WITH 'ACEPTAMOS LA CONFESIONALIDAD, '+;
				    'FILOSOFIA, ORIENTACION Y '+;
				    'REGLAMENTO DEL COLEGIO.'
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
       ENDIF
       ANO->(DBCOMMIT())
       IF lShared
	  ANO->(DBUNLOCK())
       ENDIF
       CloseDbf('ANO')
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 02:55 PM   JUL 19/96 VIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfAno(lShared,PathAno,FileAno,fNtxAno)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathAno			      // Path del Archivo
       FileAno			      // Nombre del Archivo
       fNtxAno			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathAno+'\'+FileAno,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DEL A¥O")
       Termometro(100)

       CreaDbfAno(lShared,PathAno,FileAno,fNtxAno)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/99 SAB A
       Colombia, Bucaramanga        INICIO: 07:30 PM   SEP 04/99 SAB

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

FUNCTION nActStrAno(lShared,PathAno,FileAno)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathCar				    // Path del Archivo
       FileAno				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('ANO')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathAno+'\'+FileAno,'ANO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseDbf('ANO')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ANO->(DBSTRUCT())
       CloseDbf('ANO')
       CreaDbfAno(lShared,PathAno,FileAno,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
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
	  cError('El Archivo CONFIGURACION DEL A¥O su Estructura Esta DesActualizada.',;
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
	  FileTem := SUBS(FileAno,1,AT('.',FileAno))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathAno+'\'+FileAno,;
			 PathAno+'\'+FileTem,;
			 {||CreaDbfAno(lShared,PathAno,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURAS PATHS DE INTEGRACION                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 02:57 PM   JUL 19/96 VIE

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeePathMaA(lShared,cPatSis,cAnoUsr,cIntUno,;
		    cIntDos,cIntTre,cIntCua,lPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del sistema
       cAnoUsr                              // A¤o del Usuario
       cIntUno                              // @Path de Integraci¢n uno
       cIntDos                              // @Path de Integraci¢n dos
       cIntTre                              // @Path de Integraci¢n tres
       cIntCua                              // @Path de Integraci¢n cuatro
       lPatSis                              // .T. Incluir Path del sistema*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL PathAct := ''                  // Path Actual
       LOCAL PathUno := ''                  // Path de Integraci¢n uno

       LOCAL PathSco := ''                  // Path de la Contabilidad

       LOCAL nPosFin := 0                   // Posici¢n final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(cPatSis+'\'+FMtrAno+cAnoUsr+ExtFile)

	  PathAct := cPathAct()
	  Mdir(cPatSis,PathAct)
	*ÀDirectorio del A¤o.

	  CreaDbfAno(lShared,cPatSis,FMtrAno+cAnoUsr+ExtFile)
       ELSE
	  nActStrAno(lShared,cPatSis,FMtrAno+cAnoUsr+ExtFile)
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FMtrAno+cAnoUsr+ExtFile,'TEM',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LOS PATHS DE INTEGRACION
       PathAct := cPathAct()
       nPosFin := AT("\SIMAMATR",PathAct)-1

       PathUno := SUBS(PathAct,1,nPosFin)
       PathUno := SUBS(PathUno,3)

       PathSco := PathUno+'\'+'SIMACONT'

       IF EMPTY(TEM->cIntUnoAno) .OR.;
	  UPPER(ALLTRIM(PathUno)) # UPPER(PathSco) .OR.;
	  EMPTY(TEM->cIntDosAno)

	  IF TEM->(lRegLock(lShared,.F.))

	     IF EMPTY(TEM->cIntUnoAno) .OR.;
		UPPER(ALLTRIM(PathUno)) # UPPER(PathSco)
		REPL TEM->cIntUnoAno WITH UPPER(PathSco)
	     ENDIF
	   *ÀPath integraci¢n uno

	     IF EMPTY(TEM->cIntDosAno)
		REPL TEM->cIntDosAno WITH '\Sima\SimaCart'
	     ENDIF
	   *ÀPath integraci¢n dos

	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	  ENDIF
	  TEM->(DBCOMMIT())
	  IF lShared
	     TEM->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE LOS PATHS DE INTEGRACION

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT TEM
       GO TOP
       lPatSis := IF(lPatSis == NIL,.T.,lPatSis)
       cIntUno := ALLTRIM(TEM->cIntUnoAno)+IF(lPatSis,'\'+cPatSis,'')
       cIntDos := ALLTRIM(TEM->cIntDosAno)+IF(lPatSis,'\'+cPatSis,'')
       cIntTre := ALLTRIM(TEM->cIntTreAno)+IF(lPatSis,'\'+cPatSis,'')
       cIntCua := ALLTRIM(TEM->cIntCuaAno)+IF(lPatSis,'\'+cPatSis,'')
       CloseDbf('TEM')
       RETURN NIL
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   JUL 19/96 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenAno(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		   cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		   cMaeAlu,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL oBrwAno := NIL                 // Browse de Anoresa
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwAno := oDefBrwAno(lShared,cAnoUsr,nFilPal+1,00,22,79,;
			     lIntUno,lIntDos,lIntTre,lIntCua)
       ANO->(CtrlBrw(lShared,oBrwAno))
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:02 PM   JUL 19/96 VIE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwAno(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,;
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
       LOCAL oBrwAno := NIL	            // Browse de Clientes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwAno := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwAno:ColSep    := '³'
       oBrwAno:HeadSep   := 'Ä'
       oBrwAno:Cargo     := {'<< CONFIGURACION DE LA MARTRICULA PARA '+;
			     cAnoUsr+' >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ANO
       IF lIntUno
	  oColumn	:= TBCOLUMNNEW('PATH DE;SIMACONT',;
				       {||ANO->cIntUnoAno})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','cIntUnoAno'},{'PICTURE','@X'}}
	  oBrwAno:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF lIntDos
	  oColumn	:= TBCOLUMNNEW('PATH DE;SIMACART',;
				       {||ANO->cIntDosAno})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','cIntDosAno'},{'PICTURE','@X'}}
	  oBrwAno:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF lIntTre
	  oColumn	:= TBCOLUMNNEW('PATH DE;INTEGRACION 3',;
				       {||ANO->cIntTreAno})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','cIntTreAno'},{'PICTURE','@X'}}
	  oBrwAno:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF !EMPTY(ANO->cIntCuaAno)
	  oColumn	:= TBCOLUMNNEW('PATH DE;SIMACON REAL',;
				       {||ANO->cIntCuaAno})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','cIntCuaAno'},{'PICTURE','@X'}}
	  oBrwAno:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	:= TBCOLUMNNEW('MAESTROS;HABILITADOS',{||ANO->cMaeHabAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cMaeHabAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('JORNADAS;HABILITADAS',{||ANO->cJorHabAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cJorHabAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO DE;INSCRIPICIONES',;
				    {||ANO->nNroAdmAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nNroAdmAno'}, {'PICTURE','9999'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR DE LAS;INSCRIPICIONES',;
				    {||ANO->nVlrAdmAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nVlrAdmAno'}, {'PICTURE','9999999999'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('INSCRIPCIONES;ABIERTAS',;
				    {||ANO->lHayInsAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lHayInsAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MATRICULAS;ABIERTAS',;
				    {||ANO->lHayMtrAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lHayMtrAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('VALIDAR;CONTRATANTES',{||ANO->lHayCntAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lHayCntAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('ACTUALIZAR DATOS;CON CONTRATANTES',{||ANO->lActInfAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lActInfAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('HAY;EVALUACIONES',;
				    {||ANO->lHayExaAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lHayExaAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('HAY;ENTREVISTAS',;
				    {||ANO->lHayEntAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lHayEntAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('IMPRIMIR LA;INSCRIPCION',;
				    {||ANO->lPrnAdmAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lPrnAdmAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('IMPRIMIR LA HOJA;DE MATRICULA',;
				    {||ANO->lPrnMtrAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lPrnMtrAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('IMPRIMIR RECIBOS;DE MATRICULA',;
				    {||ANO->lPrnRecAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lPrnRecAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('IMPRIMIR NOMBRE;DE LA EMPRESA',;
				    {||ANO->lPrnEmpAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lPrnEmpAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NUMERO DE HOJA;INSCRIPCION',{||ANO->nTipAdmAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nTipAdmAno'}, {'PICTURE','@99'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NUMERO DE HOJA;ORDEN DE MATRICULA',{||ANO->nTipOrdAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nTipOrdAno'}, {'PICTURE','@99'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NUMERO DE HOJA;DE MATRICULA',{||ANO->nTipMtrAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nTipMtrAno'}, {'PICTURE','@99'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('NUMERO;DE RECIBO',{||ANO->nRecNroAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nRecNroAno'}, {'PICTURE','@99'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TIPO DE;FACTURACION',;
				    {||ANO->nTipFacAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nTipFacAno'}, {'PICTURE','@99'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FACTURA;PREIMPRESA', {||ANO->lPrePrnAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lPrePrnAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HAY;NUMERACION', {||ANO->lHayNroAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lHayNroAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF ANO->lHayNroAno
	  oColumn	:= TBCOLUMNNEW('NUMERO DE LA;FACTURACION',;
				      {||ANO->nNroFacAno})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','nNroFacAno'},{'PICTURE','@!'}}
	  oBrwAno:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	:= TBCOLUMNNEW('CONCEPTOS PARA;LA MATRICULA',;
			       {||ANO->cConMatAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cConMatAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CONCEPTOS PARA;LA PENSION',;
			       {||ANO->cConPenAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cConPenAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('UTILIZAR INTERES;POR MORA MATRICULA',;
				    {||ANO->lIntMatAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lIntMatAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF ANO->lIntMatAno
	  oColumn := TBCOLUMNNEW('INTERESES;PARA MATRICULA',;
				 {||ANO->nIntMatAno})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','nIntMatAno'},{'PICTURE','@!'}}
	  oBrwAno:ADDCOLUMN(oColumn)
       ELSE
	  oColumn := TBCOLUMNNEW('VALOR DEL;RECARGO MAT',{||ANO->nMorMatAno})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','nMorMatAno'},{'PICTURE','@!'}}
	  oBrwAno:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('UTILIZAR INTERES;POR MORA PENSION',;
				    {||ANO->lIntPenAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lIntPenAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF ANO->lIntPenAno
	  oColumn := TBCOLUMNNEW('INTERESES;PARA PENSION',;
				 {||ANO->nIntPenAno})

	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','nIntPenAno'},{'PICTURE','@!'}}
	  oBrwAno:ADDCOLUMN(oColumn)
       ELSE
	  oColumn := TBCOLUMNNEW('VALOR DEL;RECARGO PEN',{||ANO->nMorPenAno})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			    {'FIELD','nMorPenAno'},{'PICTURE','@!'}}
	  oBrwAno:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LEER FECHA;DE PAGO',;
				   {||ANO->lLeeFecAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lLeeFecAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR FECHA; EXT MATRICULA',;
				    {||ANO->lExtMatAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lExtMatAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR FECHA;EXT PENSION',;
				   {||ANO->lExtPenAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lExtPenAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO;DEL BANCO',{||ANO->cCodBanAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cCodBanAno'}, {'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('A¥O PROCESAR;LAS MATRICULAS',;
			       {||ANO->cAnoMtrAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cAnoMtrAno'}, {'PICTURE','9999'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('A¥O DEL MAESTRO;DE ESTUDIANTES',;
			       {||ANO->cAnoAluAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cAnoAluAno'}, {'PICTURE','9999'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LEER OBSERVACION;INDIVIDUAL',;
				    {||ANO->lLeeObsAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lLeeObsAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('OBSERVACION PARA;LA SOLICITUD',;
			       {||ANO->cMenIncAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cMenIncAno'}, {'PICTURE','@!S76'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PRIMERA NOTA;PARA LA SOLICITUD',;
				    {||ANO->cObsUnoAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cObsUnoAno'}, {'PICTURE','@!S76'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('SEGUNDA NOTA;PARA LA SOLICITUD',;
				    {||ANO->cObsDosAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cObsDosAno'}, {'PICTURE','@!S76'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('TERCERA NOTA;PARA LA SOLICITUD',;
				    {||ANO->cObsTreAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cObsTreAno'}, {'PICTURE','@!S76'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('OBSERVACION PARA;LA HOJA DE MATRICULA',;
				    {||ANO->cObsMtrAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cObsMtrAno'}, {'PICTURE','@!S76'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LEER CONTACTO',{||ANO->lLeeInfAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lLeeInfAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO DE LISTA',{||ANO->nTipLisAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nTipLisAno'},{'PICTURE','99'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('A¥O DEL MAESTRO;DE ESTUDIANTES',;
			       {||ANO->cAnoAluAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cAnoAluAno'}, {'PICTURE','9999'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LINEAS DE;ESPACIADO',{||ANO->nLinEspAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','nLinEspAno'},{'PICTURE','99'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SISBEN',{||ANO->lSisbenAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lSisbenAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PRN COLUMNAS;FILAS MZP', {||ANO->lPreMzpAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lPreMzpAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ESTUDIANTES ANTIGUOS;SIN GRUPO ASIGNADO',;
				   {||ANO->lSinGruAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lSinGruAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALIDAR GRUPO;MATRICULA CONCEPTOS',;
				   {||ANO->lValGruAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lValGruAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATRICULAS;RESTRICCIONES',{||ANO->lMtrResAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lMtrResAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ESTUDIANTES;ANTIGUOS',{||ANO->lEstAntAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','lEstAntAno'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HABILITAR CONCEPTO;DES/REC RECIBO',;
				   {||ANO->lNomConDes})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CAA'},;
			 {'FIELD','lNomConDes'},{'PICTURE','@!'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CONCILIACION;CON CONTABILIDAD.',;
			      {||ANO->cValConAno})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ANO'},;
			 {'FIELD','cValConAno'},{'PICTURE','999999999999'}}
       oBrwAno:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       RETURN oBrwAno
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIO DE LA FECHA PARA PAGO EXTEMPORANEO      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   AGO 09/96 VIE

OBJETIVOS:

1- Debe estar en uso el archivo de Tablas

2- Permite visualizar y cambiar la fecha para pago extemporaneo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION dFecExt(lShared,nNroFil,nNroCol,dFecha)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil				    // Fila de impresi¢n
       nNroCol				    // Columna de impresi¢n
       dFecha			            // Fecha a cambiar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARCION DE VARIABLES
       LOCAL cMsgTxt                        // Texto Variable
       LOCAL cNroMes			    // N£mero del mes
       LOCAL cAnoSys                        // Ano del sistema
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL dOpoPenTan := CTOD('00/00/00') // Fecha Exteporaneo Pension
*>>>>FIN DECLARCION DE VARIABLES

*>>>>INICIALIZACION DE LA FECHA PARA EL DIA 10 DEL MES
       dOpoPenTan := IF(EMPTY(&(dFecha)),DATE(),&(dFecha))
       IF DAY(DATE()) > 20

	  cNroMes = STR(MONTH(DATE()+30),2)
	  IF MONTH(DATE()) = 12
	     cAnoSys = STR(YEAR(DATE())+1,4)
	  ELSE
	     cAnoSys = STR(YEAR(DATE()),4)
	  ENDIF
	*ÀInicializa para el d¡a 10 del siguiente mes

	  dOpoPenTan := CTOD(cNroMes+'/15/'+cAnoSys)

       ENDIF
*>>>>FIN INICIALIZACION DE LA FECHA PARA EL DIA 10 DEL MES

*>>>>LECTURA Y VALIDACION DE LA FECHA PARA EL PAGO OPORTUNO
       DO WHILE .T.

**********LECTURA DE LA FECHA PARA PAGO OPORTUNO
	    @ nNroFil,nNroCol GET dOpoPenTan
	    READ
**********FIN CAPTURA DE LOS DETALLES DE LA DEUDA

**********VALIDACION DE LA FECHA POR PAGO OPORTUNO
	    IF !EMPTY(dOpoPenTan)
	       DO CASE
	       CASE MONTH(dOpoPenTan) < MONTH(DATE()) .AND.;
		     YEAR(dOpoPenTan) <=  YEAR(DATE())
		     cError('EL MES DEL PAGO NO DEBE SER MENOR AL MES ACTUAL')

	       CASE YEAR(dOpoPenTan) < YEAR(DATE())
		    cError('EL A¥O DEL PAGO NO DEBE SER MENOR AL A¥O ACTUAL')

	       OTHERWISE
		   EXIT
	       ENDCASE
	    ELSE
	       EXIT
	    ENDIF
**********FIN VALIDACION DE LA FECHA POR PAGO OPORTUNO

       ENDDO
*>>>>FIN LECTURA Y VALIDACION DE LA FECHA PARA EL PAGO OPORTUNO

*>>>>GRABACION DE LA FECHA
       SELECT ANO
       IF ANO->(lRegLock(lShared,.F.))
	  REPL &dFecha WITH dOpoPenTan     // Graba la fecha
	  ANO->(DBCOMMIT())
	  IF lShared
	     ANO->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR LA FECHA')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LA FECHA

/*************************************************************************
* TITULO DE LA FUNCION..: GRABACION DE LOS CONCEPTOS A COBRAR            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:35 PM   AGO 09/96 VIE

OBJETIVOS:

1- Debe estar en uso el archivo de Configuraci¢n del A¤o

2- Permite visualizar y cambiar los conceptos por cobar de la matricula
   o la pension

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GrabarCon(lShared,nNroFil,nNroCol,nFilCon,nColCon,cConcep)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil			            // Fila Principal
       nNroCol			            // Columna Principal
       nFilCon                              // Fila Impresion de Conceptos
       nColCon                              // Columna impresion Conceptos
       cConcep                              // Campo del concepto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>GRABACION DE LOS CONCEPTOS A COBRAR
       SELECT ANO
       IF ANO->(lRegLock(lShared,.F.))
	  REPL &cConcep WITH cLeeConcep(nNroFil,nNroCol,nFilCon,nColCon)
	  ANO->(DBCOMMIT())
	  IF lShared
	     ANO->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR LOS CONCEPTOS')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LOS CONCEPTOS A COBRAR

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE LOS INTERESES POR PAGO EXTEMPORANEO *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:50 PM   AGO 09/96 VIE


1- Permite Consultar y cambiar los intereses por mora que se cobrar  por
   pago atrasado

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeIntMor(lShared,nNroFil,nNroCol,lHayInt,cIntMor,cVlrMor)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil				    // Fila de lectura
       nNroCol				    // Columna de lectura
       lHayInt                              // .T. Hay Intereses
       cIntMor                              // Campo de los Intereses
       cVlrMor                              // Campo Valor Mora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList:= {}                   // Variable del sistema

       LOCAL nIntMorTan := 0                // Intereses por mora
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS INTERESES POR MORA
       nIntMorTan := 0
       @ nNroFil,nNroCol GET nIntMorTan;
			 PICT IF(lHayInt,'99.99','9999999.99')
       READ
*>>>>FIN LECTURA DE LOS INTERESES POR MORA

*>>>>GRABACION DE LOS INTERESES
       SELECT ANO
       IF ANO->(lRegLock(lShared,.F.))
	  IF lHayInt
	     REPL &cIntMor WITH nIntMorTan
	     REPL &cVlrMor WITH 0
	  ELSE
	     REPL &cIntMor WITH 0
	     REPL &cVlrMor WITH nIntMorTan
	  ENDIF
	  ANO->(DBCOMMIT())
	  IF lShared
	     ANO->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL VALOR DE LOS INTERESES')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LOS INTERESES

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL MENSAJE PARA LA FACTURACION        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 04:55 PM   AGO 09/96 VIE

1- Permite Consultar y cambiar el mensaje de la facturacion

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeMensaj(lShared,nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil				    // Fila de lectura
       nNroCol				    // Columna de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList:= {}                   // Variable del sistema

       LOCAL cMensajTan := 0                // Mensaje para facturacion
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL MENSAJE
       cMensajTan := ANO->cMensajAno
       @ nNroFil,nNroCol GET cMensajTan PICT '@!'
       READ
*>>>>FIN LECTURA DEL MENSAJE

*>>>>GRABACION DEL MENSAJE
       SELECT ANO
       IF ANO->(lRegLock(lShared,.F.))
	  REPL ANO->cMensajAno WITH cMensajTan
	  ANO->(DBCOMMIT())
	  IF lShared
	     ANO->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL MENSAJE PARA LA FACTURACION')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL MENSAJE

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIO DEL BANCO PARA EL PAGO DE LOS RECIBOS   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   AGO 09/96 VIE


OBJETIVOS:

1- Debe estar en uso los archivos de Configuraci¢n del a¤o y Bancos

2- Permite establecer el c¢digo del banco para la facturaci¢n

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CambiaBan(lShared,nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup                        // Fila Superior
       LOCAL nColSup                        // Columna Superior
       LOCAL nFilInf                        // Fila Inferior
       LOCAL nColInf                        // Columna Inferior
       LOCAL cSavPan                        // Salvar Pantalla
       LOCAL nRegBan                        // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT BAN
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+LEN(BAN->cNombreBan)-1
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CODIGO DEL BANCO
       cSavPan := SAVESCREEN(0,0,24,79)
       BAN->(DBGOTOP())

       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nRegBan := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||BAN->cNombreBan})
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nRegBan == 0
	  RETURN NIL
       ENDIF
       BAN->(DBGOTO(nRegBan))
*>>>>FIN SELECCION DEL CODIGO DEL BANCO

*>>>>GRABACION DEL CODIGO DEL BANCO
       SELECT ANO
       IF ANO->(lRegLock(lShared,.F.))
	  REPL ANO->cCodBanAno WITH BAN->cCodigoBan
	  ANO->(DBCOMMIT())
	  IF lShared
	     ANO->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL BANCO DONDE SE DEBE PAGAR')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: CAMBIO DEL TIPO DE RECIBO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2005 MAR A
       Colombia, Bucaramanga        INICIO: 02:10 PM   DIC 06/2005 MAR


OBJETIVOS:

1- Debe estar en uso los archivos de Configuraci¢n del a¤o y
   Tipos de Recibos

2- Permite establecer el Tipo de Recibo para la facturaci¢n

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CambiaTrc(lShared,nNroFil,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup                        // Fila Superior
       LOCAL nColSup                        // Columna Superior
       LOCAL nFilInf                        // Fila Inferior
       LOCAL nColInf                        // Columna Inferior
       LOCAL cSavPan                        // Salvar Pantalla
       LOCAL nNroReg			    // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT TRC
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+LEN(TRC->cNombreTrc)-1
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL REGISTRO
       cSavPan := SAVESCREEN(0,0,24,79)
       TRC->(DBGOTOP())

       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||TRC->cNombreTrc})
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroReg == 0
	  RETURN NIL
       ENDIF
       TRC->(DBGOTO(nNroReg))
*>>>>FIN SELECCION DEL REGISTRO

*>>>>GRABACION DEL TIPO DE RECIBO
       SELECT ANO
       IF ANO->(lRegLock(lShared,.F.))
	  REPL ANO->cCodTrcAno WITH TRC->cCodigoTrc
	  ANO->(DBCOMMIT())
	  IF lShared
	     ANO->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE PUEDE GRABAR EL TIPO DE RECIBO')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL TIPO DE RECIBO