/*                       SIMA - MATRICULA ACADEMICA
		BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO ADMISION

REQUERIMIENTOS:

- Compilar: clipper funcsAdm /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfAdm(PathAdm,FileAdm,lIntUno,fNtxAdm)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfAdm(lShared,PathAdm,FileAdm,lIntUno,fNtxAdm,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathAdm				    // Path del Archivo
       FileAdm				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxAdm				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema
       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cNumeroAdm","Character",04,0}) // N£mero de inscripci¢n
       AADD(aDbfStr,{"cRecPagAdm","Character",10,0}) // Recibo de Pago
       AADD(aDbfStr,{"lRetiroAdm","Logical"  ,01,0}) // .T. Retirado
       AADD(aDbfStr,{"lExAlumAdm","Logical"  ,01,0}) // .T. Padres Exalumnos
       AADD(aDbfStr,{"dFecInsAdm","Date"     ,08,0}) // Fecha de Inscripci¢n
       AADD(aDbfStr,{"cNotExaAdm","Character",42,0}) // Notas del Examen
       AADD(aDbfStr,{"nDefExaAdm","Numeric"  ,04,1}) // Definitiva del Examen
       AADD(aDbfStr,{"lExamenAdm","Logical"  ,01,0}) // .T. Aprobo el Examen
       AADD(aDbfStr,{"lEntrevAdm","Logical"  ,01,0}) // .T. Citado a entrevista
       AADD(aDbfStr,{"dFecEntAdm","Date"     ,08,0}) // Fecha de la entrevista
       AADD(aDbfStr,{"cHorEntAdm","Character",08,0}) // Hora de la entrevista
       AADD(aDbfStr,{"cNotEntAdm","Character",42,0}) // Notas de la entrevista
       AADD(aDbfStr,{"nDefEntAdm","Numeric"  ,04,1}) // Definitiva de la entrevista
       AADD(aDbfStr,{"nIngMenAdm","Numeric"  ,12,2}) // Ingresos mensuales de la familia
       AADD(aDbfStr,{"cObservAdm","Character",80,0}) // Observaci¢n de la entrevista
       AADD(aDbfStr,{"cPrnNitAdm","Character",04,0}) // '0000' 0->No Imprimir 1->Imprimir, Padre,Madre,Acudiente
     *ÀDetalles de la Inscripci¢n

       AADD(aDbfStr,{"cCodigoEst","Character",06,0}) // C¢digo del Estudiante

       AADD(aDbfStr,{"lSiCupoEst","Logical"  ,01,0}) // .T. Tiene Cupo
       AADD(aDbfStr,{"lSiMatrEst","Logical"  ,01,0}) // .T. Se matriculo
       AADD(aDbfStr,{"dFecMatEst","Date"     ,08,0}) // Fecha de la Matricula
       AADD(aDbfStr,{"cHorMatEst","Character",10,0}) // Hora de la matricula
     *ÀDetalles de la Matr¡cula

       AADD(aDbfStr,{"nNomFacEst","Numeric"  ,01,0}) // C¢digo del Nombre de la Factura 0=>Alumno 1=>Padre 2=>Madre 3=>Acudiente
     *ÀDetalles de la Cartera

       AADD(aDbfStr,{"cCodigoGru","Character",04,0}) // Codigo del grupo
     *ÀDetalles Acad‚micos

       AADD(aDbfStr,{"cApelliEst","Character",30,0}) // Apellidos del Estudiante
       AADD(aDbfStr,{"cNombreEst","Character",30,0}) // Nombre del Estudiante
       AADD(aDbfStr,{"dFecNacEst","Date"     ,08,0}) // Fecha de nacimiento
       AADD(aDbfStr,{"cLugNacEst","Character",20,0}) // Lugar de Nacimiento
       AADD(aDbfStr,{"cDocNitEst","Character",16,0}) // N£mero del Documento
       AADD(aDbfStr,{"cLugNitEst","Character",20,0}) // Lugar del Documento
       AADD(aDbfStr,{"cTipNitEst","Character",03,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfStr,{"lSexFemEst","Logical"  ,01,0}) // .T. Sexo Femenino .F. Sexo Masculino
       AADD(aDbfStr,{"cNomEpsEst","Character",30,0}) // Nombre de la Eps del Estudiante
       AADD(aDbfStr,{"cGrupRhEst","Character",04,0}) // Nombre de la Eps del Estudiante
       AADD(aDbfStr,{"cViveCoEst","Character",40,0}) // *Estudiante vive con.
       AADD(aDbfStr,{"nNroHerEst","Numeric"  ,02,0}) // *N£mero de Hermanos.
       AADD(aDbfStr,{"cHerGruEst","Character",40,0}) // *Grupo de los Hermanos
     *ÀInformaci¢n personal

       AADD(aDbfStr,{"cDireccEst","Character",100,0}) // Direcci¢n del Estudiante
       AADD(aDbfStr,{"cBarrioEst","Character",16,0})  // Barrio de la Residencia
       AADD(aDbfStr,{"cCiudadEst","Character",30,0})  // Ciudad del Estudiante
       AADD(aDbfStr,{"cLocaliEst","Character",30,0})  // *Localidad.
       AADD(aDbfStr,{"cZonaDiEst","Character",30,0})  // *Zona de la Direcci¢n.
     *ÀDireccion del Estudiante

       AADD(aDbfStr,{"cTelefnEst","Character",14,0}) // Telefono del Estudiante
       AADD(aDbfStr,{"cTelCelEst","Character",14,0}) // Telefono celular del Estudiante
       AADD(aDbfStr,{"cMaiEstEst","Character",40,0}) // E-MAIL de la Casa o del Estudiante
     *ÀDatos del Estudiante

       AADD(aDbfStr,{"cParNitEst","Character",16,0}) // C‚dula del Pariente
       AADD(aDbfStr,{"cApePadEst","Character",30,0}) // Apellido del padre
       AADD(aDbfStr,{"cNomPadEst","Character",30,0}) // Nombre del Padre
       AADD(aDbfStr,{"lPadQepEst","Logical"  ,01,0}) // .T. Fallecido
       AADD(aDbfStr,{"dNacPadEst","Date"     ,08,0}) //*Fecha de nacimiento
       AADD(aDbfStr,{"cLugPadEst","Character",20,0}) //*Lugar de nacimiento
       AADD(aDbfStr,{"cPadNitEst","Character",16,0}) // C‚dula del padre
       AADD(aDbfStr,{"cPadLugEst","Character",20,0}) // Lugar de la c‚dula
       AADD(aDbfStr,{"cPadTntEst","Character",03,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfStr,{"lPadFotEst","Logical"  ,01,0}) //*.T. Fotocopia de la Cedula
       AADD(aDbfStr,{"cProPadEst","Character",26,0}) // Profesi¢n del Padre
       AADD(aDbfStr,{"cEmpPadEst","Character",26,0}) // Empresa del Padre
       AADD(aDbfStr,{"cCarPadEst","Character",20,0}) // Cargo del Padre
       AADD(aDbfStr,{"cDirPadEst","Character",100,0}) // Direccion del Padre
       AADD(aDbfStr,{"cBarPadEst","Character",16,0}) // Barrio de la direcci¢n del Padre
       AADD(aDbfStr,{"cCiuPadEst","Character",30,0}) // Ciudad del Padre
       AADD(aDbfStr,{"cTelPadEst","Character",14,0}) // Telefono del Padre
       AADD(aDbfStr,{"cCelPadEst","Character",14,0}) //*Telefono celular del Padre
       AADD(aDbfStr,{"cFaxPadEst","Character",14,0}) //*Fax del Padre
       AADD(aDbfStr,{"cBipPadEst","Character",14,0}) //*Biper del Padre
       AADD(aDbfStr,{"cMaiPadEst","Character",40,0}) // E-MAIL del padre
     *ÀDatos del Padre

       AADD(aDbfStr,{"cApeMadEst","Character",30,0}) // Nombre de la madre
       AADD(aDbfStr,{"cNomMadEst","Character",30,0}) // Nombre de la madre
       AADD(aDbfStr,{"lMadQepEst","Logical"  ,01,0}) // .T. Fallecido
       AADD(aDbfStr,{"dNacMadEst","Date"     ,08,0}) //*Fecha de nacimiento
       AADD(aDbfStr,{"cLugMadEst","Character",20,0}) //*Lugar de nacimiento
       AADD(aDbfStr,{"cMadNitEst","Character",16,0}) // C‚dula de la madre
       AADD(aDbfStr,{"cMadLugEst","Character",20,0}) // Lugar de la c‚dula
       AADD(aDbfStr,{"cMadTntEst","Character",03,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfStr,{"lMadFotEst","Logical"  ,01,0}) //*.T. Fotocopia de la Cedula
       AADD(aDbfStr,{"cProMadEst","Character",26,0}) // Profesi¢n de la madre
       AADD(aDbfStr,{"cEmpMadEst","Character",26,0}) // Empresa de la madre
       AADD(aDbfStr,{"cCarMadEst","Character",20,0}) // Cargo de la madre
       AADD(aDbfStr,{"cDirMadEst","Character",100,0}) // Direccion de la Madre
       AADD(aDbfStr,{"cBarMadEst","Character",16,0}) // Barrio de la direcci¢n de la Madre
       AADD(aDbfStr,{"cCiuMadEst","Character",30,0}) // Ciudad de la Madre
       AADD(aDbfStr,{"cTelMadEst","Character",14,0}) // Telefono de la madre
       AADD(aDbfStr,{"cCelMadEst","Character",14,0}) //*Telefono celular de la Madre
       AADD(aDbfStr,{"cFaxMadEst","Character",14,0}) //*Fax de la Madre
       AADD(aDbfStr,{"cBipMadEst","Character",14,0}) //*Biper de la Madre
       AADD(aDbfStr,{"cMaiMadEst","Character",40,0}) // E-MAIL de la Madre
     *ÀDatos de la Madre

       AADD(aDbfStr,{"cApeAcuEst","Character",30,0}) // Apellido del Acudiente
       AADD(aDbfStr,{"cNomAcuEst","Character",30,0}) // Nombre del Acudiente
       AADD(aDbfStr,{"cAcuNitEst","Character",16,0}) // C‚dula del Acudiente
       AADD(aDbfStr,{"cAcuLugEst","Character",20,0}) // Lugar del Acudiente
       AADD(aDbfStr,{"cAcuTntEst","Character",03,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfStr,{"lAcuFotEst","Logical"  ,01,0}) //*.T. Fotocopia de la Cedula
       AADD(aDbfStr,{"cProAcuEst","Character",26,0}) // Profesi¢n del Acudiente
       AADD(aDbfStr,{"cEmpAcuEst","Character",26,0}) // Empresa del Acudiente
       AADD(aDbfStr,{"cCarAcuEst","Character",20,0}) // Cargo del Acudiente
       AADD(aDbfStr,{"cDirAcuEst","Character",100,0}) // Direccion de la casa del Acudiente
       AADD(aDbfStr,{"cBarAcuEst","Character",16,0}) // Barrio de la direcci¢n del Acudiente
       AADD(aDbfStr,{"cCiuAcuEst","Character",30,0}) // Ciudad del Acudiente
       AADD(aDbfStr,{"cTe1AcuEst","Character",14,0}) // Telefono No.1 del Acudiente
       AADD(aDbfStr,{"cTe2AcuEst","Character",14,0}) // Telefono No.2 del Acudiente
       AADD(aDbfStr,{"cCelAcuEst","Character",14,0}) // Telefono celular del Acudiente
       AADD(aDbfStr,{"cFaxAcuEst","Character",14,0}) // Fax del Acudiente
       AADD(aDbfStr,{"cBipAcuEst","Character",14,0}) // Biper del Acudiente
       AADD(aDbfStr,{"cMaiAcuEst","Character",40,0}) // E-MAIL del Acudiente
       AADD(aDbfStr,{"cParAcuEst","Character",16,0}) // Parentesco del Acudiente
     *ÀDatos del Acudiente

       AADD(aDbfStr,{"nEstratEst","Numeric"  ,02,0}) // N£mero del Estrato del Estudiante
       AADD(aDbfStr,{"cConcepEst","Character",16,0}) // Conceptos por cobrar
       AADD(aDbfStr,{"cCole13Est","Character",84,0}) // Procedencia de Caminadores
       AADD(aDbfStr,{"cCole00Est","Character",84,0}) // Procedencia de Transicion
       AADD(aDbfStr,{"cCole01Est","Character",84,0}) // Procedencia de Primero
       AADD(aDbfStr,{"cCole02Est","Character",84,0}) // Procedencia de Segundo
       AADD(aDbfStr,{"cCole03Est","Character",84,0}) // Procedencia de Tercero
       AADD(aDbfStr,{"cCole04Est","Character",84,0}) // Procedencia de Cuarto
       AADD(aDbfStr,{"cCole05Est","Character",84,0}) // Procedencia de Quinto
       AADD(aDbfStr,{"cCole06Est","Character",84,0}) // Procedencia de Sexto
       AADD(aDbfStr,{"cCole07Est","Character",84,0}) // Procedencia de Septimo
       AADD(aDbfStr,{"cCole08Est","Character",84,0}) // Procedencia de Octavo
       AADD(aDbfStr,{"cCole09Est","Character",84,0}) // Procedencia de Noveno
       AADD(aDbfStr,{"cCole10Est","Character",84,0}) // Procedencia de D‚cimo
       AADD(aDbfStr,{"cCole11Est","Character",84,0}) // Procedencia de Und‚cimo
       AADD(aDbfStr,{"cCole12Est","Character",84,0}) // Procedencia de Maternales
       AADD(aDbfStr,{"cCole14Est","Character",84,0}) // Procedencia de Parvulos
       AADD(aDbfStr,{"cCole15Est","Character",84,0}) // Procedencia de PreJardin
       AADD(aDbfStr,{"cCole16Est","Character",84,0}) // Procedencia de Jardin
       AADD(aDbfStr,{"cCodigoMat","Character",04,0}) // C¢digo de la materia de la Especialidad
     *ÀColegios de Procedencia
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
       CASE DIRCHANGE(PathAdm) == 0
	    DBCREATE(FileAdm,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathAdm) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathAdm)

       CASE DIRCHANGE(PathAdm) == -5
	    cError('NO TIENE DERECHOS EN: '+PathAdm)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfAdm(lShared,PathAdm,FileAdm,lIntUno,fNtxAdm)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathAdm			      // Path del Archivo
       FileAdm			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxAdm			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathAdm+'\'+FileAdm,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE ADMISION")
       Termometro(100)

       CreaDbfAdm(lShared,PathAdm,FileAdm,lIntUno,fNtxAdm)
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

FUNCTION nActStrAdm(lShared,PathAdm,FileAdm)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathCar				    // Path del Archivo
       FileAdm				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('ADM')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathAdm+'\'+FileAdm,'ADM',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE ADMICIONES')
	  CloseDbf('ADM')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ADM->(DBSTRUCT())
       CloseDbf('ADM')
       CreaDbfAdm(lShared,PathAdm,FileAdm,,,@aStrNew)
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
	  cError('El Archivo ADMISIONES su Estructura Esta DesActualizada.',;
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
	  FileTem := SUBS(FileAdm,1,AT('.',FileAdm))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathAdm+'\'+FileAdm,;
			 PathAdm+'\'+FileTem,;
			 {||CreaDbfAdm(lShared,PathAdm,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA


/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL CANDIDATO                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 03:35 PM   ENE 03/96 MIE

1- Debe estar en uso los archivos Admisiones

2- Busca el c¢digo del Candidato

3- Retorna NIL

SINTAXIS:

  BuscarAdm(oBroAdm)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarAdm(lShared,cPatSis,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del Sistema
       oBrowse				    // Browse de Admisiones */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero de registro
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda

       LOCAL nColLin := 0                   // Columna de lectura de linea
       LOCAL nTecPul := 0                   // Tecla pulsada
       LOCAL nLenCam := 0                   // Longitud de campo a leer

       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL METODO DE BUSQUEDA
       aMenus := {'1<POR APELLIDO>',;
		  '2<POR NOMBRE  >',;
		  '3<POR CODIGO  >'}
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,NIL,10,30,'BUSQUEDA',NIL,1,.F.)
       IF nNroOpc == 0
	  oBrowse:REFRESHALL()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN SELECCION DEL METODO DE BUSQUEDA

*>>>>ACTIVACION DE LOS INDICES
       SELECT ADM
       DO CASE
       CASE nNroOpc == 1
	    fNtxAdm := cPatSis+'\'+Ntx1Adm

       CASE nNroOpc == 2
	    fNtxAdm := cPatSis+'\'+Ntx2Adm

       CASE nNroOpc == 3
	    fNtxAdm := cPatSis+'\'+fNtxAdm
       ENDCASE
       DBCLEARIND()
       IF lShared
	  DBSETINDEX(fNtxAdm)
       ELSE
	  SET INDEX TO (fNtxAdm)
       ENDIF
       GO TOP
       oBrowse:GOTOP()
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
*>>>>FIN ACTIVACION DE LOS INDICES

*>>>>IMPRESION DEL TITULO DE BUSQUEDA
       SET CURSOR ON
       DO CASE
       CASE nNroOpc == 1
	    nLenCam := LEN(cSpaces("ADM","cApelliEst"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL APELLIDO:')

       CASE nNroOpc == 2
	    nLenCam := LEN(cSpaces("ADM","cNombreEst"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL NOMBRE:')

       CASE nNroOpc == 3
	    nLenCam := LEN(cSpaces("ADM","cNumeroAdm"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE NRO INSCRIPCION:')

       ENDCASE
       nColLin := nNroCol
*>>>>FIN IMPRESION DEL TITULO DE BUSQUEDA

*>>>>BUSQUEDA DEL REGISTRO
       DO WHILE .T.

**********IMPRESION DEL TITULO DE BUSQUEDA
	    DO CASE
	    CASE nNroOpc == 1
		 TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL APELLIDO:')
		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigoTes+;
				      SPACE(nLenCam-LEN(cCodigoTes))
		 SET COLOR TO

	    CASE nNroOpc == 2
		 TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL NOMBRE:')
		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigoTes+;
				      SPACE(nLenCam-LEN(cCodigoTes))
		 SET COLOR TO

	    CASE nNroOpc == 3
		 TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE NRO INSCRIPCION:')
		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigoTes+;
				      SPACE(nLenCam-LEN(cCodigoTes))
		 SET COLOR TO

	    ENDCASE
**********FIN IMPRESION DEL TITULO DE BUSQUEDA

**********LECTURA DEL CARACTER
	    nTecPul := nLeeChr(nNroFil,nColLin)
	    IF nTecPul == 27 .OR. nTecPul == 13 .OR. LEN(cCodigoTes) == nLenCam
	       EXIT
	    ENDIF
	    cCodigoTes += CHR(nTecPul)
	    nColLin++
**********FIN LECTURA DEL CARACTER

**********BUSQUEDA DEL CODIGO
	    nNroReg := RECNO()
	    IF lSekCodigo(cCodigoTes,"ADM")
	       nNroReg := RECNO()
	    ENDIF
	    GO TOP
	    oBrowse:GOTOP()
	    GO nNroReg
	    oBrowse:FORCESTABLE()
**********FIN BUSQUEDA DEL CODIGO

       ENDDO
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN BUSQUEDA DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: CALCULO DE LA DEFINITIVA                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 06:15 PM   ENE 03/96 MIE

OBJETIVOS:

1- Calcula la definitiva del examen o entrevista por suma y division para
   un estudiante

2- Retorna la defintiva del examen o entrevista

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nDefinitiva(nTotNot,cNotas)

*>>>>PARAMETROS DE LA FUNCION
/*     nTotNot                              // Nombre del Sistema
       cNotas                               // Notas a calcular */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNota   := 0                   // Nota parcial
       LOCAL nNotDef := 0                   // Nota Definitiva
       LOCAL nNroNot := 0                   // N£mero de notas a dividir
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LA DEFINITIVA
       FOR i = 1 TO nTotNot
	   nNota := VAL(SUBS(cNotas,i*4-3,4))
	   IF nNota # 0
	      nNotDef := nNotDef + nNota
	      nNroNot := nNroNot + 1
	   ENDIF
       NEXT
       IF nNroNot # 0
	  nNotDef := nNotDef / nNroNot
       ENDIF
       RETURN nNotDef
*>>>>FIN CALCULO DE LA DEFINITIVA

/*************************************************************************
* TITULO DE LA FUNCION..: VERIFICACION DEL CALCULO DE LA DEFINITIVA      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 09:15 PM   FEB 02/96 VIE

1- Verifica si la nota del examen o de la entrevista esta
   actualizada.

2- Debe estar en uso el archivo de Admisiones

3- Retorna .T. si estan actualizadas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lNotDefOk(lExamen)

*>>>>PARAMETROS DE LA FUNCION
/*     lExamen                              // .T. Examen .F. Entrevista */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nDefiOk := 0                   // Contador
       LOCAL lDefiOk := .F.                 // .T. Definitiva Actulizada
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION DEFINITIVA OK
       SELECT ADM
       lExamen := IF(lExamen == NIL,.T.,lExamen)
       IF lExamen
	  COUNT ALL FOR SUBS(ADM->cNotExaAdm,41,1) == '*' TO nDefiOk
       ELSE
	  COUNT ALL FOR SUBS(ADM->cNotEntAdm,41,1) == '*' TO nDefiOk
       ENDIF
       IF nDefiOk == 0
	  lDefiOk := .T.
       ENDIF
       GO TOP
       RETURN lDefiOk
*>>>>FIN VERIFICACION DEFINITIVA OK

/*************************************************************************
* TITULO DE LA FUNCION..: CALCULO DE LAS DEFINITIVAS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 09:20 PM   FEB 02/96 VIE

OBJETIVOS:

1- Debe estar en uso el archivo de admision junto con el indice de los
   exemanes

2- Permite calcular la nota definitiva del examen o de la entrevista
   por suma y division.

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalculaDef(lShared,cNomSis,lExamen)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoSys                              // Nombre del Sistema
       lExamen                              // .T. Examen .F. Entrevista */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNota   := 0                   // Nota parcial
       LOCAL nNotDef := 0                   // Nota Definitiva
       LOCAL nNroNot := 0                   // N£mero de notas a dividir
       LOCAL nTotNot := 0                   // Total de notas
       LOCAL       i := 0                   // Contador
       FIELD nDefExaAdm                     // Nota defintiva del examen
       FIELD nDefEntAdm                     // Nota definitiva del examen
       FIELD cCodGruAdm                     // Codigo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LAS DEFINITIVAS POR PROMEDIO
       SELECT ADM
       GO TOP
       lExamen := IF(lExamen == NIL,.T.,lExamen)
       DO WHILE .NOT. EOF()

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('CALCULO DE DEFINITIVAS DE '+;
			IF(lExamen,'EXAMENES','ENTREVISTAS')+;
			' CANDIDATOS: '+ALLTRIM(STR(RECNO(),7))+'/'+;
			 ALLTRIM(STR(RECCOUNT(),7)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********CALCULO DE LA NOTA DEFINITIVA POR PROMEDIO
	    ADM->(lRegLock(lShared,.F.))
	   *Bloqueo del registro

	    nNotDef := 0
	    nNroNot := 0
	    nTotNot := IF(lExamen,ANO->nNroExaAno,ANO->nNroEntAno)
	    FOR i = 1 TO nTotNot
		nNota := IF(lExamen,VAL(SUBS(ADM->cNotExaAdm,i*4-3,4)),;
				    VAL(SUBS(ADM->cNotEntAdm,i*4-3,4)))
		IF nNota # 0
		   nNotDef := nNotDef + nNota
		   nNroNot := nNroNot + 1
		ENDIF
	    NEXT
	    IF nNroNot # 0
	       nNotDef := nNotDef / nNroNot
	    ENDIF
**********FIN CALCULO DE LA NOTA DEFINITIVA POR PROMEDIO

**********GRABACION DE LA NOTA DEFINITIVA
	    IF lExamen
	       REPL ADM->nDefExaAdm WITH nNotDef
	       REPLACE ADM->cNotExaAdm WITH ;  // Marca de grabaci¢n
		       STUFF(ADM->cNotExaAdm,41,1,' ')
	    ELSE
	       REPL ADM->nDefEntAdm WITH nNotDef
	       REPLACE ADM->cNotEntAdm WITH ;  // Marca de grabaci¢n
		       STUFF(ADM->cNotEntAdm,41,1,' ')
	    ENDIF
	    ADM->(DBUNLOCK())
**********FIN GRABACION DE LA NOTA DEFINITIVA

	  SKIP
	 *Avanza al siguiente candidato

       ENDDO
       SELECT ADM
       GO TOP
       RETURN NIL
*>>>>FIN CALCULO DE LAS DEFINITIVAS POR PROMEDIO