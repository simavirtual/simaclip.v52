/*               	 SISTEMA CONTABILIDAD ACADEMICA
	    BIBLIOTECAS DE FUNCIONES PARA LOS ARCHIVOS MAESTROS DE ALUMNOS

REQUERIMIENTOS:

- Compilar: clipper FuncsAlu /w/m/b

OBJETIVOS:

- Funciones aplicadas para los archivos maestros de alumnos de la
  de la contabilidad acad‚mica

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 12:30 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo del maestro de jardin, primaria o
    Bachillerato

2)- Retorna NIL

SINTAXIS:

  CreaDbfAlu(cPatSis,FMaeJar+cAnoSis+ExtFile,'JAR',;
		     fNtxJar+cAnoSis+cExtNtx)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfAlu(PathAlu,FileAlu,cNalias,fNtxAlu,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     PathAlu                              // Path del Archivo Maestro
       FileAlu			            // Archivo de Maestro
       cNalias                              // Alias del Maestro
       fNtxAlu			            // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Archivo Compartido
       LOCAL PathAct := ''                  // Path Actual
       FIELD cCodigoEst                     // C¢digo del estudiante

       LOCAL aDbfAlu := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfAlu,{"cCodigoEst","Character",006,0}) // C¢digo del Estudiante
       AADD(aDbfAlu,{"cCodEstEst","Character",007,0}) // C¢digo del Estudiante
       AADD(aDbfAlu,{"cPasWorEst","Character",010,0}) // PassWord del Estudiante
       AADD(aDbfAlu,{"cUsrWwwEst","Character",012,0}) // Usuario del Internet
       AADD(aDbfAlu,{"cPasWwwEst","Character",010,0}) // PassWord del Internet
       AADD(aDbfAlu,{"lHayWwwEst","Logical"  ,001,0}) // .T. Acceso a Internet
       AADD(aDbfAlu,{"cAnoUsrEst","Character",004,0}) // A¤o del Maestro de estudiantes
       AADD(aDbfAlu,{"lGrupOkEst","Logical"  ,001,0}) // .T. Grupo OK no mezclar grupos
       AADD(aDbfAlu,{"cGruAntGru","Character",006,0}) // Codigo del grupo anterior
       AADD(aDbfAlu,{"cCodigoGru","Character",004,0}) // Codigo del grupo
       AADD(aDbfAlu,{"cNSalonGru","Character",004,0}) // N£mero del Salon
       AADD(aDbfAlu,{"lRetiroEst","Logical"  ,001,0}) // .T. Retirado
       AADD(aDbfAlu,{"dFecRetEst","Date"     ,008,0}) // Fecha del retiro
       AADD(aDbfAlu,{"nPerRetEst","Numeric"  ,002,0}) // Periodo del Retiro
       AADD(aDbfAlu,{"nUltRecEst","Numeric"  ,002,0}) // Ultimo Recibo que se debe facturar
       AADD(aDbfAlu,{"nAproboNot","Numeric"  ,002,0}) // Indicardor de Aprobaci¢n
       AADD(aDbfAlu,{"nAprAntNot","Numeric"  ,002,0}) // Indicardor de Aprobaci¢n Anterior
       AADD(aDbfAlu,{"lRepiteEst","Logical"  ,001,0}) // .T. Repite a¤o
       AADD(aDbfAlu,{"lSiCupoEst","Logical"  ,001,0}) // .T. Tiene Cupo
       AADD(aDbfAlu,{"lSiMatrEst","Logical"  ,001,0}) // .T. Si matriculado para sgte a¤o
       AADD(aDbfAlu,{"dFecMatEst","Date"     ,008,0}) // Fecha de matricula
       AADD(aDbfAlu,{"cHorMatEst","Character",008,0}) // Hora de matricula
       AADD(aDbfAlu,{"lEstNewEst","Logical"  ,001,0}) // .T. Estudiante Nuevo .F. Estudiante Antiguo
       AADD(aDbfAlu,{"cFolFinEst","Character",012,0}) // Folios del libro final
       AADD(aDbfAlu,{"cAnoIngEst","Character",004,0}) // Codigo de Ingreso del Estudiante
       AADD(aDbfAlu,{"nNroLisEst","Numeric"  ,003,0}) // N£mero de lista.
       AADD(aDbfAlu,{"nMorosoEst","Numeric"  ,002,0}) // C¢digo de Clasificaci¢n de los morosos.
       AADD(aDbfAlu,{"nNomFacEst","Numeric"  ,001,0}) // C¢digo del Nombre de la Factura 0=>Alumno 1=>Padre 2=>Madre 3=>Acudiente
       AADD(aDbfAlu,{"nEstratEst","Numeric"  ,002,0}) // Estatro del Estudiante

       AADD(aDbfAlu,{"cNomEpsEst","Character",030,0}) // Nombre de la Eps del Estudiante
       AADD(aDbfAlu,{"cGrupRhEst","Character",004,0}) // Nombre de la Eps del Estudiante

       AADD(aDbfAlu,{"cConcepEst","Character",016,0}) // Conceptos del Estudiante

       AADD(aDbfAlu,{"cCodigoRut","Character",010,0}) // Codigo de la Ruta
       AADD(aDbfAlu,{"cCodigoBus","Character",006,0}) // Codigo del Bus

       AADD(aDbfAlu,{"cBoletiEst","Character",010,0}) // Correci¢n del Boletin. Dos caracteres por periodo
     *ÀDetalles Generales

       AADD(aDbfAlu,{"cTxtTemEst","Character",030,0}) // Texto temporal

       AADD(aDbfAlu,{"cApelliEst","Character",030,0}) // Apellido del Estudiante
       AADD(aDbfAlu,{"cNombreEst","Character",030,0}) // Nombre del Estudiante
       AADD(aDbfAlu,{"dFecNacEst","Date"     ,008,0}) // Fecha de nacimiento
       AADD(aDbfAlu,{"cLugNacEst","Character",020,0}) // Lugar de nacimiento
       AADD(aDbfAlu,{"cDocNitEst","Character",016,0}) // Documento de Identidad
       AADD(aDbfAlu,{"cLugNitEst","Character",020,0}) // Lugar del Documento
       AADD(aDbfAlu,{"cTipNitEst","Character",004,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"lFotNitEst","Logical"  ,001,0}) // .T. Fotocopia
       AADD(aDbfAlu,{"lSexFemEst","Logical"  ,001,0}) // .T. Sexo Femenino .F. Sexo Masculino
       AADD(aDbfAlu,{"cDireccEst","Character",100,0}) // Direccion de la casa
       AADD(aDbfAlu,{"cBarrioEst","Character",016,0}) // Barrio de la direcci¢n
       AADD(aDbfAlu,{"cCiudadEst","Character",030,0}) // Ciudad del Estudiante
       AADD(aDbfAlu,{"cDepartEst","Character",030,0}) // Departamento del Estudiante
       AADD(aDbfAlu,{"cTelefnEst","Character",014,0}) // Telefono de la casa
       AADD(aDbfAlu,{"cTelCelEst","Character",014,0}) // *Telefono celular del Estudiante
       AADD(aDbfAlu,{"cMaiEstEst","Character",040,0}) // E-MAIL de la Casa o del Estudiante
       AADD(aDbfAlu,{"cParNitEst","Character",016,0}) // C‚dula de Parentesco
       AADD(aDbfAlu,{"cCodFamEst","Character",060,0}) // C¢digo de Estudiantes de los familiares
     *ÀDatos del Estudiante

       AADD(aDbfAlu,{"cViveCoEst","Character",40,0}) // *Estudiante vive con.
       AADD(aDbfAlu,{"nNroHerEst","Numeric"  ,02,0}) // *N£mero de Hermanos.
       AADD(aDbfAlu,{"cHerGruEst","Character",40,0}) // *Grupo de los Hermanos
       AADD(aDbfAlu,{"cLocaliEst","Character",30,0}) // *Localidad.
       AADD(aDbfAlu,{"cZonaDiEst","Character",30,0}) // *Zona de la Direcci¢n.

       AADD(aDbfAlu,{"nTotFacEst","Numeric",12,2})    // Total Facturado
       AADD(aDbfAlu,{"nTotPagEst","Numeric",12,2})    // Total Pagado

       AADD(aDbfAlu,{"cNitCo1Est","Character",016,0}) // Cedula Contrante No.1
       AADD(aDbfAlu,{"cTipCo1Est","Character",001,0}) // Tipo de Documento
       AADD(aDbfAlu,{"lNoRCo1Est","Logical"  ,001,0}) // .T. No Reportar .F. Si Reportar
       AADD(aDbfAlu,{"cNitCo2Est","Character",016,0}) // Cedula Contrante No.2
       AADD(aDbfAlu,{"cTipCo2Est","Character",001,0}) // Tipo de Documento
       AADD(aDbfAlu,{"lNoRCo2Est","Logical"  ,001,0}) // .T. No Reportar .F. Si Reportar
       AADD(aDbfAlu,{"cNitCo3Est","Character",016,0}) // Cedula Contrante No.3
       AADD(aDbfAlu,{"cTipCo3Est","Character",001,0}) // Tipo de Documento
       AADD(aDbfAlu,{"lNoRCo3Est","Logical"  ,001,0}) // .T. No Reportar .F. Si Reportar
       AADD(aDbfAlu,{"cNitCo4Est","Character",016,0}) // Cedula Contrante No.4
       AADD(aDbfAlu,{"cTipCo4Est","Character",001,0}) // Tipo de Documento
       AADD(aDbfAlu,{"lNoRCo4Est","Logical"  ,001,0}) // .T. No Reportar .F. Si Reportar
     *ÀDatos de los Contrantes 1,2,3,4

       AADD(aDbfAlu,{"cAsiEneEst","Character",031,0}) // Asistencia de Enero
       AADD(aDbfAlu,{"cAsiFebEst","Character",031,0}) // Asistencia de Febrero
       AADD(aDbfAlu,{"cAsiMarEst","Character",031,0}) // Asistencia de Marzo
       AADD(aDbfAlu,{"cAsiAbrEst","Character",031,0}) // Asistencia de Abril
       AADD(aDbfAlu,{"cAsiMayEst","Character",031,0}) // Asistencia de Mayo
       AADD(aDbfAlu,{"cAsiJunEst","Character",031,0}) // Asistencia de Junio
       AADD(aDbfAlu,{"cAsiJulEst","Character",031,0}) // Asistencia de Julio
       AADD(aDbfAlu,{"cAsiAgoEst","Character",031,0}) // Asistencia de Agosto
       AADD(aDbfAlu,{"cAsiSepEst","Character",031,0}) // Asistencia de Septiembre
       AADD(aDbfAlu,{"cAsiOctEst","Character",031,0}) // Asistencia de Octubre
       AADD(aDbfAlu,{"cAsiNovEst","Character",031,0}) // Asistencia de Noviembre
       AADD(aDbfAlu,{"cAsiDicEst","Character",031,0}) // Asistencia de Diciembre
     *ÀControl de Asistencia del Estudiante

       AADD(aDbfAlu,{"lCarnetEst","Logical"  ,001,0}) // .T. Carnet Perdido .F. Carnet Activo

       AADD(aDbfAlu,{"cResEneEst","Character",031,0}) // Servicio de Restaurante de Enero
       AADD(aDbfAlu,{"cResFebEst","Character",031,0}) // Servicio de Restaurante de Febrero
       AADD(aDbfAlu,{"cResMarEst","Character",031,0}) // Servicio de Restaurante de Marzo
       AADD(aDbfAlu,{"cResAbrEst","Character",031,0}) // Servicio de Restaurante de Abril
       AADD(aDbfAlu,{"cResMayEst","Character",031,0}) // Servicio de Restaurante de Mayo
       AADD(aDbfAlu,{"cResJunEst","Character",031,0}) // Servicio de Restaurante de Junio
       AADD(aDbfAlu,{"cResJulEst","Character",031,0}) // Servicio de Restaurante de Julio
       AADD(aDbfAlu,{"cResAgoEst","Character",031,0}) // Servicio de Restaurante de Agosto
       AADD(aDbfAlu,{"cResSepEst","Character",031,0}) // Servicio de Restaurante de Septiembre
       AADD(aDbfAlu,{"cResOctEst","Character",031,0}) // Servicio de Restaurante de Octubre
       AADD(aDbfAlu,{"cResNovEst","Character",031,0}) // Servicio de Restaurante de Noviembre
       AADD(aDbfAlu,{"cResDicEst","Character",031,0}) // Servicio de Restaurante de Diciembre
     *ÀServicion de Restaurante del Estudiante

       AADD(aDbfAlu,{"pNOMPADEST","Character",002,0}) // Posicion del Nombre del Padre
       AADD(aDbfAlu,{"cApePadEst","Character",030,0}) // Apellido del padre
       AADD(aDbfAlu,{"cNomPadEst","Character",040,0}) // Nombre del padre
       AADD(aDbfAlu,{"lPadQepEst","Logical"  ,001,0}) // .T. Fallecido
       AADD(aDbfAlu,{"dNacPadEst","Date"     ,008,0}) // Fecha de nacimiento
       AADD(aDbfAlu,{"cLugPadEst","Character",020,0}) // Lugar de nacimiento
       AADD(aDbfAlu,{"cPadNitEst","Character",016,0}) // C‚dula del padre
       AADD(aDbfAlu,{"cPadLugEst","Character",016,0}) // Lugar de la c‚dula
       AADD(aDbfAlu,{"cPadTntEst","Character",004,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"lPadFotEst","Logical"  ,001,0}) // .T. Fotocopia de la Cedula
       AADD(aDbfAlu,{"cProPadEst","Character",026,0}) // Profesi¢n del padre
       AADD(aDbfAlu,{"cEmpPadEst","Character",026,0}) // Empresa del padre
       AADD(aDbfAlu,{"cCarPadEst","Character",020,0}) // Cargo del padre
       AADD(aDbfAlu,{"cDirPadEst","Character",100,0}) // Direccion del Padre
       AADD(aDbfAlu,{"cBarPadEst","Character",016,0}) // Barrio de la direcci¢n del Padre
       AADD(aDbfAlu,{"cCiuPadEst","Character",030,0}) // Ciudad del Padre
       AADD(aDbfAlu,{"cDepPadEst","Character",030,0}) // Departamento del Padre
       AADD(aDbfAlu,{"cTelPadEst","Character",014,0}) // Telefono del padre
       AADD(aDbfAlu,{"cCelPadEst","Character",014,0}) // *Telefono celular del Padre
       AADD(aDbfAlu,{"cFaxPadEst","Character",014,0}) // *Fax del Padre
       AADD(aDbfAlu,{"cBipPadEst","Character",014,0}) // *Biper del Padre
       AADD(aDbfAlu,{"cMaiPadEst","Character",040,0}) // E-MAIL del padre
     *ÀDatos del Padre

       AADD(aDbfAlu,{"pNOMMADEST","Character",002,0}) // Posicion del Nombre de la Madre
       AADD(aDbfAlu,{"cApeMadEst","Character",030,0}) // Nombre de la madre
       AADD(aDbfAlu,{"cNomMadEst","Character",040,0}) // Nombre de la madre
       AADD(aDbfAlu,{"lMadQepEst","Logical"  ,001,0}) // .T. Fallecido
       AADD(aDbfAlu,{"dNacMadEst","Date"     ,008,0}) // Fecha de nacimiento
       AADD(aDbfAlu,{"cLugMadEst","Character",020,0}) // Lugar de nacimiento
       AADD(aDbfAlu,{"cMadNitEst","Character",016,0}) // C‚dula de la madre
       AADD(aDbfAlu,{"cMadLugEst","Character",016,0}) // Lugar de la c‚dula
       AADD(aDbfAlu,{"cMadTntEst","Character",004,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"lMadFotEst","Logical"  ,001,0}) // .T. Fotocopia de la Cedula
       AADD(aDbfAlu,{"cProMadEst","Character",026,0}) // Profesi¢n de la madre
       AADD(aDbfAlu,{"cEmpMadEst","Character",026,0}) // Empresa de la madre
       AADD(aDbfAlu,{"cCarMadEst","Character",020,0}) // Cargo de la madre
       AADD(aDbfAlu,{"cDirMadEst","Character",100,0}) // Direccion de la Madre
       AADD(aDbfAlu,{"cBarMadEst","Character",016,0}) // Barrio de la direcci¢n de la Madre
       AADD(aDbfAlu,{"cCiuMadEst","Character",030,0}) // Ciudad de la Madre
       AADD(aDbfAlu,{"cDepMadEst","Character",030,0}) // Departamento de la Madre
       AADD(aDbfAlu,{"cTelMadEst","Character",014,0}) // Telefono de la madre
       AADD(aDbfAlu,{"cCelMadEst","Character",014,0}) // *Telefono celular de la Madre
       AADD(aDbfAlu,{"cFaxMadEst","Character",014,0}) // *Fax de la Madre
       AADD(aDbfAlu,{"cBipMadEst","Character",014,0}) // *Biper de la Madre
       AADD(aDbfAlu,{"cMaiMadEst","Character",040,0}) // E-MAIL de la Madre
     *ÀDatos de la Madre

       AADD(aDbfAlu,{"pNOMACUEST","Character",002,0}) // Posicion del Nombre del Acudiente
       AADD(aDbfAlu,{"cApeAcuEst","Character",030,0}) // Apellido del Acudiente
       AADD(aDbfAlu,{"cNomAcuEst","Character",040,0}) // Nombre del Acudiente
       AADD(aDbfAlu,{"lAcuQepEst","Logical"  ,001,0}) // .T. Fallecido
       AADD(aDbfAlu,{"dNacAcuEst","Date"     ,008,0}) // Fecha de nacimiento
       AADD(aDbfAlu,{"cLugAcuEst","Character",020,0}) // Lugar de nacimiento
       AADD(aDbfAlu,{"cAcuNitEst","Character",016,0}) // C‚dula del Acudiente
       AADD(aDbfAlu,{"cAcuLugEst","Character",016,0}) // Lugar del Acudiente
       AADD(aDbfAlu,{"cAcuTntEst","Character",004,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"lAcuFotEst","Logical"  ,001,0}) // .T. Fotocopia de la Cedula
       AADD(aDbfAlu,{"cProAcuEst","Character",026,0}) //*Profesi¢n del Acudiente
       AADD(aDbfAlu,{"cEmpAcuEst","Character",026,0}) //*Empresa del Acudiente
       AADD(aDbfAlu,{"cCarAcuEst","Character",020,0}) //*Cargo del Acudiente
       AADD(aDbfAlu,{"cDirAcuEst","Character",100,0}) // Direccion de la casa del Acudiente
       AADD(aDbfAlu,{"cBarAcuEst","Character",016,0}) // Barrio de la direcci¢n del Acudiente
       AADD(aDbfAlu,{"cCiuAcuEst","Character",030,0}) // Ciudad del Acudiente
       AADD(aDbfAlu,{"cDepAcuEst","Character",030,0}) // Departamento del Acudiente
       AADD(aDbfAlu,{"cTe1AcuEst","Character",014,0}) // Telefono No. 1 del Acudiente
       AADD(aDbfAlu,{"cTe2AcuEst","Character",014,0}) // Telefono No. 2 del Acudiente
       AADD(aDbfAlu,{"cCelAcuEst","Character",014,0}) // *Telefono celular del Acudiente
       AADD(aDbfAlu,{"cFaxAcuEst","Character",014,0}) // *Fax del Acudiente
       AADD(aDbfAlu,{"cBipAcuEst","Character",014,0}) // *Biper del Acudiente
       AADD(aDbfAlu,{"cMaiAcuEst","Character",040,0}) // E-MAIL del Acudiente
       AADD(aDbfAlu,{"cParAcuEst","Character",016,0}) // Parentesco del Acudiente
     *ÀDatos del Acudiente

       AADD(aDbfAlu,{"cPazSdoEst","Character",020,0}) // Paz y Salvo. Espacio en Blanco =>SI Paz y Salvo. Diferente de Espacio =>NO Paz y Salvo
       AADD(aDbfAlu,{"cObsLibEst","Character",500,0}) // Observaci¢n para el libro.
       AADD(aDbfAlu,{"cObsRetEst","Character",100,0}) // Observaci¢n del Retiro.
       AADD(aDbfAlu,{"cCole13Est","Character",084,0}) // Procedencia de Caminadores
       AADD(aDbfAlu,{"cCole00Est","Character",084,0}) // Procedencia de Transici¢n
       AADD(aDbfAlu,{"cCole01Est","Character",084,0}) // Procedencia de Primero
       AADD(aDbfAlu,{"cCole02Est","Character",084,0}) // Procedencia de Segundo
       AADD(aDbfAlu,{"cCole03Est","Character",084,0}) // Procedencia de Tercero
       AADD(aDbfAlu,{"cCole04Est","Character",084,0}) // Procedencia de Cuarto
       AADD(aDbfAlu,{"cCole05Est","Character",084,0}) // Procedencia de Quinto
       AADD(aDbfAlu,{"cCole06Est","Character",084,0}) // Procedencia de Sexto
       AADD(aDbfAlu,{"cCole07Est","Character",084,0}) // Procedencia de Septimo
       AADD(aDbfAlu,{"cCole08Est","Character",084,0}) // Procedencia de Octavo
       AADD(aDbfAlu,{"cCole09Est","Character",084,0}) // Procedencia de Noveno
       AADD(aDbfAlu,{"cCole10Est","Character",084,0}) // Procedencia de D‚cimo
       AADD(aDbfAlu,{"cCole11Est","Character",084,0}) // Procedencia de Und‚cimo
       AADD(aDbfAlu,{"cCole12Est","Character",084,0}) // Procedencia de Maternales
       AADD(aDbfAlu,{"cCole14Est","Character",084,0}) // Procedencia de Parvulos
       AADD(aDbfAlu,{"cCole15Est","Character",084,0}) // Procedencia de Pre-Jardin
       AADD(aDbfAlu,{"cCole16Est","Character",084,0}) // Procedencia de Jardin
       AADD(aDbfAlu,{"cVotEscEst","Character",030,0}) // Voto Escolar del Estudiante
       AADD(aDbfAlu,{"cCodigoMat","Character",004,0}) // C¢digo de la materia del area Especializada
       AADD(aDbfAlu,{"cAnoEstMae","Character",068,0}) // A¤os en que estudio en el colegio

/*
       AADD(aDbfAlu,{"cApeRe1Est","Character",030,0}) // Apellidos de la Referencia No. 1
       AADD(aDbfAlu,{"cNomRe1Est","Character",030,0}) // Nombres de la Referencia No. 1
       AADD(aDbfAlu,{"cParRe1Est","Character",016,0}) // Parentesco de la Referencia No. 1
       AADD(aDbfAlu,{"cRe1NitEst","Character",016,0}) // C‚dula de la Referencia No.1
       AADD(aDbfAlu,{"cRe1LugEst","Character",016,0}) // Lugar de la Referencia No. 1
       AADD(aDbfAlu,{"cRe1TntEst","Character",004,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"cDirRe1Est","Character",100,0}) // Direccion de la casa de la Referencia No. 1
       AADD(aDbfAlu,{"cBarRe1Est","Character",016,0}) // Barrio de la direcci¢n de la Referencia No. 1
       AADD(aDbfAlu,{"cCiuRe1Est","Character",030,0}) // Ciudad de la Referencia
       AADD(aDbfAlu,{"cTe1Re1Est","Character",014,0}) // Telefono No. 1 de la Referencia No. 1
       AADD(aDbfAlu,{"cTe2Re1Est","Character",014,0}) // Telefono No. 2 de la Referencia No. 1
       AADD(aDbfAlu,{"cApeRe2Est","Character",030,0}) // Nombre de la Referencia No. 2
       AADD(aDbfAlu,{"cNomRe2Est","Character",030,0}) // Nombre de la Referencia No. 2
       AADD(aDbfAlu,{"cParRe2Est","Character",016,0}) // Parentesco de la Referencia No. 2
       AADD(aDbfAlu,{"cRe2NitEst","Character",016,0}) // C‚dula de la Referencia No. 2
       AADD(aDbfAlu,{"cRe2LugEst","Character",016,0}) // Lugar de la Referencia No. 2
       AADD(aDbfAlu,{"cRe2TntEst","Character",004,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"cDirRe2Est","Character",100,0}) // Direccion de la casa de la Referencia No. 2
       AADD(aDbfAlu,{"cBarRe2Est","Character",016,0}) // Barrio de la direcci¢n de la Referencia No. 2
       AADD(aDbfAlu,{"cTe1Re2Est","Character",014,0}) // Telefono No. 1 de la Referencia No. 2
       AADD(aDbfAlu,{"cTe2Re2Est","Character",014,0}) // Telefono No. 2 de la Referencia No. 2
       AADD(aDbfAlu,{"cApeFi1Est","Character",030,0}) // Apellidos del Fiador No. 1
       AADD(aDbfAlu,{"cNomFi1Est","Character",030,0}) // Nombres del Fiador No. 1
       AADD(aDbfAlu,{"cParFi1Est","Character",016,0}) // Parentesco del Fiador No. 1
       AADD(aDbfAlu,{"cFi1NitEst","Character",016,0}) // C‚dula del Fiador No. 1
       AADD(aDbfAlu,{"cFi1LugEst","Character",016,0}) // Lugar del Fiador No. 1
       AADD(aDbfAlu,{"cFi1TntEst","Character",004,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"cDirFi1Est","Character",100,0}) // Direccion de la casa  Fiador No. 1
       AADD(aDbfAlu,{"cBarFi1Est","Character",016,0}) // Barrio de la direcci¢n Fiador No. 1
       AADD(aDbfAlu,{"cTe1Fi1Est","Character",014,0}) // Telefono No. 1 del Fiador No. 1
       AADD(aDbfAlu,{"cTe2Fi1Est","Character",014,0}) // Telefono No. 2 del Fiador No. 1
       AADD(aDbfAlu,{"cApeFi2Est","Character",030,0}) // Apellidos del Fiador No. 2
       AADD(aDbfAlu,{"cNomFi2Est","Character",030,0}) // Nombres del Fiador No. 2
       AADD(aDbfAlu,{"cParFi2Est","Character",016,0}) // Parentesco del Fiador No. 2
       AADD(aDbfAlu,{"cFi2NitEst","Character",016,0}) // C‚dula del Fiador No. 2
       AADD(aDbfAlu,{"cFi2LugEst","Character",016,0}) // Lugar del Fiador No. 2
       AADD(aDbfAlu,{"cFi2TntEst","Character",004,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"cDirFi2Est","Character",100,0}) // Direccion de la casa Fiador No. 2
       AADD(aDbfAlu,{"cBarFi2Est","Character",016,0}) // Barrio de la direcci¢n Fiador No. 2
       AADD(aDbfAlu,{"cTe1Fi2Est","Character",014,0}) // Telefono No. 1 del Fiador No. 2
       AADD(aDbfAlu,{"cTe2Fi2Est","Character",014,0}) // Telefono No. 2 del Fiador No. 2
*/
*>>>>FIN DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfAlu
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathAlu) == 0
	    DBCREATE(FileAlu,aDbfAlu,"DBFNTX")

       CASE DIRCHANGE(PathAlu) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathAlu)

       CASE DIRCHANGE(PathAlu) == -5
	    cError('NO TIENE DERECHOS EN: '+PathAlu)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathAlu+'\'+FileAlu,cNalias,NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO '+FileAlu+' EN CREACION DE ESTRUCTURAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>CREACION DE INDICES
       SELECT &cNalias
       INDEX ON cCodigoEst TO &(PathAlu+'\'+fNtxAlu)
       CLOSE ALL
       RETURN NIL
*>>>>FIN CREACION DE INDICES

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 12:45 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo de Maestro de alumnos

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfAlu(PathAlu,FileAlu,cNalias,fNtxAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     PathAlu                        // Path del Maestro de Alumnos
       FileAlu			      // Archivo de Maestro
       cNalias                        // Alias del maestro
       fNtxAlu			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathAlu+'\'+FileAlu,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE "+FileAlu)
       Termometro(100)
       CreaDbfAlu(PathAlu,FileAlu,cNalias,fNtxAlu)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA PARA IMPORTAR                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 07/2011 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   MAR 07/2011 MIE

OBJETIVOS:

1- Crea la estructura del archivo del maestro de jardin, primaria o
    Bachillerato

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaImport()

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Archivo Compartido
       LOCAL PathAct := ''                  // Path Actual
       LOCAL nModCry := 0                   // Modo de Protecci¢n

       LOCAL       i := 0                   // Contador
       LOCAL aDetStr := {}                  // Detalles Estructura del Archivo
       LOCAL aDbfStr := {}                  // Estructura del Archivo


       LOCAL PathArc := ''                  // Path del Archivo
       LOCAL fArchvo := ''                  // Nombre del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DE LA ESTRUCTURA
       aDetStr := {}
       AADD(aDetStr,{'cCodigoEst','Character',060,0,'Codigo del Estudiante'})
       AADD(aDetStr,{'cCodigoGru','Character',014,0,'Codigo del grupo'})
       AADD(aDetStr,{'grado'     ,'Character',014,0,'Grado'})
       AADD(aDetStr,{'cTipNitEst','Character',014,0,'Tipo de Documento'})
       AADD(aDetStr,{'cDocNitEst','Character',014,0,'Documento de Identidad'})
       AADD(aDetStr,{'cLugNitEst','Character',014,0,'Lugar del Documento de identidad'})
       AADD(aDetStr,{'cDepNitEst','Character',014,0,'Departamento del Documento de identidad'})
       AADD(aDetStr,{'cApelliEst','Character',014,0,'Apellido del Estudiante'})
       AADD(aDetStr,{'cNombreEst','Character',014,0,'Nombre del Estudiante'})
       AADD(aDetStr,{'cSexFemEst','Character',014,0,'Sexo Femenino o Masculino'})
       AADD(aDetStr,{'cFecNacEst','Character',014,0,'Fecha de nacimiento'})
       AADD(aDetStr,{'cCiuNacEst','Character',014,0,'Ciudad de nacimiento'})
       AADD(aDetStr,{'cDepNacEst','Character',014,0,'Departamento Nacimiento'})

       AADD(aDetStr,{'cDireccEst','Character',014,0,'Direccion de la casa'})
       AADD(aDetStr,{'cBarrioEst','Character',014,0,'Barrio de la direccion'})
       AADD(aDetStr,{'cCiudadEst','Character',014,0,'Ciudad del Estudiante'})
       AADD(aDetStr,{'cDepartEst','Character',014,0,'Departamento del Estudiante'})
       AADD(aDetStr,{'cTelefnEst','Character',014,0,'Telefono de la casa'})
       AADD(aDetStr,{'cTelCelEst','Character',014,0,'Telefono celular del Estudiante'})
       AADD(aDetStr,{'cMaiEstEst','Character',014,0,'E-MAIL del Estudiante'})


       AADD(aDetStr,{'cFecMatEst','Character',014,0,'Fecha de matricula'})
       AADD(aDetStr,{'cHorMatEst','Character',014,0,'Hora de matricula'})

       AADD(aDetStr,{'estado'    ,'Character',014,0,'Estado del Estudiante'})
       AADD(aDetStr,{'cRetiroEst','Character',014,0,'Retirado'})
       AADD(aDetStr,{'cFecRetEst','Character',014,0,'Fecha del retiro'})

       AADD(aDetStr,{'cEstratEst','Character',014,0,'Estatro del Estudiante'})
       AADD(aDetStr,{'cNomEpsEst','Character',014,0,'Nombre de la Eps del Estudiante'})
       AADD(aDetStr,{'cGrupRhEst','Character',014,0,'Grupo Sanguineo'})
*>>>>FIN DETALLES DE LA ESTRUCTURA


*>>>>DECLARACION DE LA ESTRUCTURA
       aDbfStr := {}
       FOR i := 1 TO LEN(aDetStr)
	   AADD(aDbfStr,{aDetStr[i,1],aDetStr[i,2],aDetStr[i,3],aDetStr[i,4]})
       ENDFOR
*>>>>FIN DECLARACION DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathArc := 'BASES'
       fArchvo := 'MAEIMPOR.xls'
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
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'TEM',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO '+fArchvo)
	  CloseDbf('TEM')
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       FOR i := 1 TO 3

	   IF TEM->(lRegLock(lShared,.T.))

	      DO CASE
	      CASE i == 1
		   REPL TEM->cCodigoEst WITH ''
	      CASE i == 2
		   REPL TEM->cCodigoEst WITH 'DETALLES DE LOS CAMPOS:'
	      CASE i == 3
		   REPL TEM->cCodigoEst WITH ''
	      ENDCASE

	      TEM->(DBCOMMIT())
	      IF lShared
		 TEM->(DBUNLOCK())
	      ENDIF
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	   ENDIF
       ENDFOR
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       FOR i := 1 TO LEN(aDetStr)

	   IF TEM->(lRegLock(lShared,.T.))


	      LineaEstado('ARCHIVO:'+PathArc+'\'+fArchvo+;
			  'ºNo. '+STR(i,2)+'/'+;
				  STR(LEN(aDetStr),2),;
			  'POR FAVOR ESPERE...')


	      REPL TEM->cCodigoEst WITH aDetStr[i,1]+'=>'+aDetStr[i,5]

	      TEM->(DBCOMMIT())
	      IF lShared
		 TEM->(DBUNLOCK())
	      ENDIF
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	   ENDIF
       ENDFOR
       CloseDbf('TEM')
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO


*>>>>DETALLES DE LA ESTRUCTURA
       aDetStr := {}
       AADD(aDetStr,{'cCodigoEst','Character',060,0,'Codigo del Estudiante'})
       AADD(aDetStr,{'parentesco','Character',014,0,'Parentesco del Acudiente'})
       AADD(aDetStr,{'contratant','Character',014,0,'Contratante1 o Contratante2'})
       AADD(aDetStr,{'coodeudor' ,'Character',014,0,'Codeudor1 o Codeudor2'})

       AADD(aDetStr,{'cApeUnoPer','Character',014,0,'Primer Apellido'})
       AADD(aDetStr,{'cApeDosPer','Character',014,0,'Segundo Apellido'})
       AADD(aDetStr,{'cNomUnoPer','Character',014,0,'Primer Nombre'})
       AADD(aDetStr,{'cNomDosPer','Character',014,0,'Segundo Nombre'})

       AADD(aDetStr,{'cDocNitPer','Character',014,0,'Documento de Identidad'})
       AADD(aDetStr,{'cTipNitPer','Character',014,0,'Tipo del Documento'})
       AADD(aDetStr,{'cLugNitPer','Character',014,0,'Lugar del Documento'})
       AADD(aDetStr,{'cDepNitPer','Character',014,0,'Departamento del Documento de identidad'})

       AADD(aDetStr,{'cFecNacPer','Character',014,0,'Fecha de nacimiento'})
       AADD(aDetStr,{'cLugNacPer','Character',014,0,'Lugar de nacimiento'})
       AADD(aDetStr,{'cDepNacPer','Character',014,0,'Departamento Nacimiento'})

       AADD(aDetStr,{'cSexFemPer','Character',014,0,'Sexo Femenino o Masculino'})
       AADD(aDetStr,{'cTipoRhPer','Character',014,0,'Tipo de Sangre'})
       AADD(aDetStr,{'cEstratPer','Character',014,0,'Estrato'})

       AADD(aDetStr,{'cDireccPer','Character',014,0,'Direccion de la Casa'})
       AADD(aDetStr,{'cBarrioPer','Character',014,0,'Barrio de la Direccion'})
       AADD(aDetStr,{'cCiudadPer','Character',014,0,'Ciudad de la Direcci¢n'})
       AADD(aDetStr,{'cDepartPer','Character',014,0,'Departamento de la Direccion'})
       AADD(aDetStr,{'cTelefnPer','Character',014,0,'Telefono Casa'})
       AADD(aDetStr,{'cTelFaxPer','Character',014,0,'Telefono Fax de la Casa'})
       AADD(aDetStr,{'cTelCelPer','Character',014,0,'Telefono celular'})
       AADD(aDetStr,{'cMailPer'  ,'Character',014,0,'E-MAIL de la persona'})

       AADD(aDetStr,{'cProfesPer','Character',014,0,'Profesion de la Persona'})
       AADD(aDetStr,{'cEmpTraPer','Character',014,0,'Empresa del Trabajo'})
       AADD(aDetStr,{'cCarTraPer','Character',014,0,'Cargo de la Empresa'})
       AADD(aDetStr,{'cDirTraPer','Character',014,0,'Direccion del Trabajo'})
       AADD(aDetStr,{'cBarTraPer','Character',014,0,'Barrio del Trabajo'})
       AADD(aDetStr,{'cCiuTraPer','Character',014,0,'Ciudad del Trabajo'})
       AADD(aDetStr,{'cDepTraPer','Character',014,0,'Departamento del Trabajo'})
       AADD(aDetStr,{'cTelTraPer','Character',014,0,'Telefono del Trabajo'})
       AADD(aDetStr,{'cFaxTraPer','Character',014,0,'Fax del Trabajo'})
*>>>>FIN DETALLES DE LA ESTRUCTURA

*>>>>DECLARACION DE LA ESTRUCTURA
       aDbfStr := {}
       FOR i := 1 TO LEN(aDetStr)
	   AADD(aDbfStr,{aDetStr[i,1],aDetStr[i,2],aDetStr[i,3],aDetStr[i,4]})
       ENDFOR
*>>>>FIN DECLARACION DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathArc := 'BASES'
       fArchvo := 'ACUIMPOR.xls'
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
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'TEM',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO '+fArchvo)
	  CloseDbf('TEM')
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       FOR i := 1 TO 3

	   IF TEM->(lRegLock(lShared,.T.))

	      DO CASE
	      CASE i == 1
		   REPL TEM->cCodigoEst WITH ''
	      CASE i == 2
		   REPL TEM->cCodigoEst WITH 'DETALLES DE LOS CAMPOS:'
	      CASE i == 3
		   REPL TEM->cCodigoEst WITH ''
	      ENDCASE

	      TEM->(DBCOMMIT())
	      IF lShared
		 TEM->(DBUNLOCK())
	      ENDIF
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	   ENDIF
       ENDFOR
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       FOR i := 1 TO LEN(aDetStr)

	   IF TEM->(lRegLock(lShared,.T.))

	      LineaEstado('ARCHIVO:'+PathArc+'\'+fArchvo+;
			  'ºNo. '+STR(i,2)+'/'+;
				  STR(LEN(aDetStr),2),;
			  'POR FAVOR ESPERE...')

	      REPL TEM->cCodigoEst WITH aDetStr[i,1]+'=>'+aDetStr[i,5]

	      TEM->(DBCOMMIT())
	      IF lShared
		 TEM->(DBUNLOCK())
	      ENDIF
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	   ENDIF
       ENDFOR
       CloseDbf('TEM')
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO


/*************************************************************************
* TITULO DE LA FUNCION..: APERTURA DE LOS MAESTROS DE LA CONTABILIDAD    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:50 PM   FEB 02/96 VIE

OBJETIVOS:

1)- Pone en uso los archivos de alumnos de la contabilidad habilitados

2)- Retorna por referencia los param‚tros de la funci¢n marcados con @

3)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseXYZ(lShared,cPatSis,cMaeAlu,cAnoSis,lAnoAct,lUseNtx)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cPatSis			            // Path del Sistema
       cMaeAlu                              // Maestros habilitados
       cAnoSis                              // A¤o del sistema
       lAnoAct                              // .F. A¤o Anteriores
       lUseNtx                              // .T. Abrir Indixes */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema

       LOCAL PathAlu := ''                 // Path del Estudiante
       LOCAL lHayErr := .F.                // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lAnoAct := IF(lAnoAct==NIL,.T.,lAnoAct)
       lUseNtx := IF(lUseNtx==NIL,.T.,lUseNtx)
       IF 'JAR' $ cMaeAlu

	  PathAlu := cPatSis+'\JAR\'
	  IF !lUseDbf(.T.,PathAlu+FMaeJar+cAnoSis+ExtFile,;
		      IF(lAnoAct,'JAR','JAA'),;
		      IF(lUseNtx,PathAlu+fNtxJar+cAnoSis+cExtNtx,NIL),lShared)
	     cError('ABRIENDO ARCHIVOS DE JARDIN EN '+PathAlu)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu

	  PathAlu := cPatSis+'\PRI\'
	  IF !lUseDbf(.T.,PathAlu+FMaePri+cAnoSis+ExtFile,;
		      IF(lAnoAct,'PRI','PRA'),;
		      IF(lUseNtx,PathAlu+fNtxPri+cAnoSis+cExtNtx,NIL),lShared)
	     cError('ABRIENDO ARCHIVOS DE PRIMARIA EN '+PathAlu)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu

	  PathAlu := cPatSis+'\BTO\'
	  IF !lUseDbf(.T.,PathAlu+FMaeBto+cAnoSis+ExtFile,;
		      IF(lAnoAct,'BTO','BTA'),;
		      IF(lUseNtx,PathAlu+fNtxBto+cAnoSis+cExtNtx,NIL),lShared)
	     cError('ABRIENDO ARCHIVOS DE BACHILLERATO EN '+PathAlu)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE ALUMNOS		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Permite el mantenimiento del archivo Alumnos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenAlu(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
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
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro

       LOCAL aStrDbf := {'1'}               // Estructura del Archivo
       LOCAL oBrowse := NIL                 // Browse de Alumnos
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePer,'PER',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSel+cMaeAct+ExtFile,'SEL',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE ALUMNOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

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
       SELECT &cNalias
       CreaDbfAlu(cPatSis+'\'+cMaeAct,;
		  FileAlu+cMaeAct+cAnoSis+ExtFile,,,@aStrDbf)

       oBrowse := oDefBrwAlu(lShared,nFilPal+1,00,22,79,cNalias,;
		 '<<  MANTENIMIENTO DE ALUMNOS DE '+cNalias+;
		 ' .TOTAL ='+STR(RECCOUNT(),4)+'  >>',;
		 '<F2>Consultar '+;
		 '<F5>Buscar <F9>Otros <ESC>Abandonar',.F.)

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,cNalias,cNomEmp,cNomSis)})

       SETKEY(K_F5,{||BuscarAlu(lShared,oBrowse,cNalias,cAnoSis,cPatSis)})
       SETKEY(K_F9,{||MenuOtrAlu(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,cNomDpt,cNomMun,nFilPal,nFilInf,;
				 nColInf,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
				 lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
				 cJorTxt,cJornad,oBrowse,aStrDbf)})

       DO CASE
       CASE cNalias == 'JAR'
	    JAR->(CtrlBrw(lShared,oBrowse))
       CASE cNalias == 'PRI'
	    PRI->(CtrlBrw(lShared,oBrowse))
       CASE cNalias == 'BTO'
	    BTO->(CtrlBrw(lShared,oBrowse))
       ENDCASE
       SETKEY(K_F2,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       DBUNLOCKALL()
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE ALUMNOS		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Define el objeto Browse del archivo Alumnos

SINTAXIS:

 oBrowse := oDefBrwAlu(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwAlu(lShared,nFilSup,nColSup,nFilInf,;
		    nColInf,cNalias,cTitUno,cTitDos,lIntUno,lModLis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNomGra			            // Nombre Del Grado
       cNalias                              // Alias del maestro
       cTitUno                              // Titulo Uno de la pantalla
       cTitDos                              // Titulo Dos de la pantalla
       lIntUno                              // Primera Integraci¢n
       lModLis                              // .T. Modificar Nro Lista. */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       cTitUno := IF(cTitUno == NIL,'CONSULTA DE ALUMNOS',cTitUno)
       cTitDos := IF(cTitDos == NIL,'<ESC> Abandonar',cTitDos)

       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {cTitUno,cTitDos}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       lModLis := IF(EMPTY(lModLis),.F.,lModLis)

       SELECT &cNalias
       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CODIGO', {||JAR->cCodigoEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CODIGO', {||PRI->cCodigoEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CODIGO', {||BTO->cCodigoEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CURSO', {||JAR->cCodigoGru})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CURSO', {||PRI->cCodigoGru})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CURSO', {||BTO->cCodigoGru})
       ENDCASE
       IF SCO->lModPlaCon  // Se modifica por Matricula
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cCodigoGru'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||JAR->cApelliEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||PRI->cApelliEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||BTO->cApelliEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cApelliEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 3
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('NOMBRES',;
		       {||JAR->cNombreEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('NOMBRE',;
		       {||PRI->cNombreEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('NOMBRES',;
		       {||BTO->cNombreEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cNombreEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(JAR->lRetiroEst,;
						       'RETIRADO',;
						       ' ACTIVO ')})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(PRI->lRetiroEst,;
						       'RETIRADO',;
						       ' ACTIVO ')})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(BTO->lRetiroEst,;
						       'RETIRADO',;
						       ' ACTIVO ')})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('F.RETIRO',{||cFecha(JAR->dFecRetEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('F.RETIRO',{||cFecha(PRI->dFecRetEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('F.RETIRO',{||cFecha(BTO->dFecRetEst)})
       ENDCASE
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','dFecRetEst'}, {'PICTURE','@D'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('PERIODO;HABILITADO',{||JAR->nPerRetEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('PERIODO;HABILITADO',{||PRI->nPerRetEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('PERIODO;HABILITADO',{||BTO->nPerRetEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','nPerRetEst'}, {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('NUEVO',;
		       {||JAR->lEstNewEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('NUEVO',;
		       {||PRI->lEstNewEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('NUEVO',;
		       {||BTO->lEstNewEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','lEstNewEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF SCO->lModPlaCon
	  DO CASE
	  CASE cNalias == 'JAR'
	       oColumn := TBCOLUMNNEW('MATRICULA',{||JAR->dFecMatEst})
	  CASE cNalias == 'PRI'
	       oColumn := TBCOLUMNNEW('MATRICULA',{||PRI->dFecMatEst})
	  CASE cNalias == 'BTO'
	       oColumn := TBCOLUMNNEW('MATRICULA',{||BTO->dFecMatEst})
	  ENDCASE
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			    {'FIELD','dFecMatEst'}, {'PICTURE','@D'}}
       ELSE
	  DO CASE
	  CASE cNalias == 'JAR'
	       oColumn := TBCOLUMNNEW('MATRICULA',;
			  {||cFecha(JAR->dFecMatEst,3)})
	  CASE cNalias == 'PRI'
	       oColumn := TBCOLUMNNEW('MATRICULA',;
			  {||cFecha(PRI->dFecMatEst,3)})
	  CASE cNalias == 'BTO'
	       oColumn := TBCOLUMNNEW('MATRICULA',;
			  {||cFecha(BTO->dFecMatEst,3)})
	  ENDCASE

	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('HORA',{||JAR->cHorMatEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('HORA',{||PRI->cHorMatEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('HORA',{||BTO->cHorMatEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CURSO ANT',;
		       {||JAR->cGruAntGru})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CURSO ANT',;
		       {||PRI->cGruAntGru})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CURSO ANT',;
		       {||BTO->cGruAntGru})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('BOLETINES', {||JAR->cBoletiEst})
	    oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			      {'FIELD','cBoletiEst'}, {'PICTURE','9999999999'}}

       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('BOLETINES', {||PRI->cBoletiEst})
	    oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			      {'FIELD','cBoletiEst'}, {'PICTURE','9999999999'}}

       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('BOLETINES', {||BTO->cBoletiEst})
	    oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			      {'FIELD','cBoletiEst'}, {'PICTURE','9999999999'}}

       ENDCASE
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CONCEPTOS', {||JAR->cConcepEst})

       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CONCEPTOS', {||PRI->cConcepEst})

       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CONCEPTOS', {||BTO->cConcepEst})

       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('PAZ Y SALVO',{||JAR->cPazSdoEst})

       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('PAZ Y SALVO',{||PRI->cPazSdoEst})

       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('PAZ Y SALVO',{||BTO->cPazSdoEst})

       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('MODALIDAD', {||JAR->cCodigoMat})
	    oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			      {'FIELD','cCodigoMat'}, {'PICTURE','9999'}}

       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('MODALIDAD', {||PRI->cCodigoMat})
	    oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			      {'FIELD','cCodigoMat'}, {'PICTURE','9999'}}

       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('MODALIDAD', {||BTO->cCodigoMat})
	    oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			      {'FIELD','cCodigoMat'}, {'PICTURE','9999'}}

       ENDCASE
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('APROBACION',;
		       {||JAR->nAproboNot})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('APROBACION',;
		       {||PRI->nAproboNot})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('APROBACION',;
		       {||BTO->nAproboNot})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('APROBACION ANTERIOR',;
		       {||JAR->nAprAntNot})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('APROBACION ANTERIOR',;
		       {||PRI->nAprAntNot})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('APROBACION ANTERIOR',;
		       {||BTO->nAprAntNot})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('REPITE',{||IF(JAR->lRepiteEst,;
						       'SI',;
						       'NO')})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('REPITE',{||IF(PRI->lRepiteEst,;
						       'SI',;
						       'NO')})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('REPITE',{||IF(BTO->lRepiteEst,;
						       'SI',;
						       'NO')})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CUPO',{||IF(JAR->lSiCupoEst,;
						'SI',;
						'NO')})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CUPO',{||IF(PRI->lSiCupoEst,;
						'SI',;
						'NO')})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CUPO',{||IF(BTO->lSiCupoEst,;
						'SI',;
						'NO')})
       ENDCASE
       oColumn:Width := 4
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CEDULA DEL PARIENTE',;
		       {||JAR->cParNitEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CEDULA DEL PARIENTE',;
		       {||PRI->cParNitEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CEDULA DEL PARIENTE',;
		       {||BTO->cParNitEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cParNitEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||JAR->nEstratEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||PRI->nEstratEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||BTO->nEstratEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','nEstratEst'}, {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('HERMANOS',{||JAR->cCodFamEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('HERMANOS',{||PRI->cCodFamEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('HERMANOS',{||BTO->cCodFamEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       lModLis := .F.
       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('No.', {||JAR->nNroLisEst})
	    oColumn:Cargo := {{'MODI',lModLis},{'ALIAS',cNalias},;
			      {'FIELD','nNroLisEst'}, {'PICTURE','999'}}
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('No.', {||PRI->nNroLisEst})
	    oColumn:Cargo := {{'MODI',lModLis},{'ALIAS',cNalias},;
			      {'FIELD','nNroLisEst'}, {'PICTURE','999'}}
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('No.', {||BTO->nNroLisEst})
	    oColumn:Cargo := {{'MODI',lModLis},{'ALIAS',cNalias},;
			      {'FIELD','nNroLisEst'}, {'PICTURE','999'}}
       ENDCASE
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('MATRICULADO',{||IF(JAR->lSiMatrEst,;
						'SI',;
						'NO')})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('MATRICULADO',{||IF(PRI->lSiMatrEst,;
						'SI',;
						'NO')})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('MATRICULADO',{||IF(BTO->lSiMatrEst,;
						'SI',;
						'NO')})
       ENDCASE
       oColumn:Width := 11
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna



       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||JAR->nEstratEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||PRI->nEstratEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||BTO->nEstratEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTe1AcuEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','nEstratEst'}, {'PICTURE','99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CONCEPTOS',{||JAR->cConcepEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CONCEPTOS',{||PRI->cConcepEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CONCEPTOS',{||BTO->cConcepEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cConcepEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cConcepEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('A. TECNICA',{||JAR->cCodigoMat})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('A. TECNICA',{||PRI->cCodigoMat})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('A. TECNICA',{||BTO->cCodigoMat})
       ENDCASE
       oColumn:Width := 10
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cCodigoMat'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(JAR->dFecNacEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(PRI->dFecNacEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(BTO->dFecNacEst)})
       ENDCASE
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','dFecNacEst'}, {'PICTURE','@D'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('LUGAR', {||JAR->cLugNacEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('LUGAR', {||PRI->cLugNacEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('LUGAR', {||BTO->cLugNacEst})
       ENDCASE
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cLugNacEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||JAR->cDocNitEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||PRI->cDocNitEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||BTO->cDocNitEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('DE',{||JAR->cLugNitEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('DE',{||PRI->cLugNitEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('DE',{||BTO->cLugNitEst})
       ENDCASE
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cLugNitEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('DIRECCION',{||JAR->cDireccEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('DIRECCION',{||PRI->cDireccEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('DIRECCION',{||BTO->cDireccEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cDireccEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cDireccEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||JAR->cTelefnEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||PRI->cTelefnEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||BTO->cTelefnEst})
       ENDCASE
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cTelefnEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('BARRIO',{||JAR->cBarrioEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('BARRIO',{||PRI->cBarrioEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('BARRIO',{||BTO->cBarrioEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cBarrioEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cBarrioEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('PADRE',{||JAR->cNomPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('PADRE',{||PRI->cNomPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('PADRE',{||BTO->cNomPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cNomPadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cNomPadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('PROFESION',{||JAR->cProPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('PROFESION',{||PRI->cProPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('PROFESION',{||BTO->cProPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cProPadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cProPadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||JAR->cEmpPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||PRI->cEmpPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||BTO->cEmpPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cEmpPadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cEmpPadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CARGO',{||JAR->cCarPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CARGO',{||PRI->cCarPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CARGO',{||BTO->cCarPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cCarPadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cCarPadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||JAR->cTelPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||PRI->cTelPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||BTO->cTelPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTelPadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cTelPadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('MADRE',{||JAR->cNomMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('MADRE',{||PRI->cNomMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('MADRE',{||BTO->cNomMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cNomMadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cNomMadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('PROFESION',{||JAR->cProMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('PROFESION',{||PRI->cProMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('PROFESION',{||BTO->cProMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cProMadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cProMadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||JAR->cEmpMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||PRI->cEmpMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||BTO->cEmpMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cEmpMadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cEmpMadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CARGO',{||JAR->cCarMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CARGO',{||PRI->cCarMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CARGO',{||BTO->cCarMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cCarMadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cCarMadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||JAR->cTelMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||PRI->cTelMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||BTO->cTelMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTelMadEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cTelMadEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ACUDIENTE',{||JAR->cNomAcuEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ACUDIENTE',{||PRI->cNomAcuEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ACUDIENTE',{||BTO->cNomAcuEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cNomAcuEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cNomAcuEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO1',{||JAR->cTe1AcuEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO1',{||PRI->cTe1AcuEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO1',{||BTO->cTe1AcuEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTe1AcuEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cTe1AcuEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO2',{||JAR->cTe2AcuEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO2',{||PRI->cTe2AcuEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO2',{||BTO->cTe2AcuEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTe1AcuEst'))
       IF !lIntUno
	  oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cTe2AcuEst'}, {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/


       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: BROWSE DE ALUMNOS PARA EL CERTIFICADO  		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/97 LUN A
       Colombia, Bucaramanga        INICIO: 04:00 PM   JUL 07/97 LUN

OBJETIVOS:

1- Define el objeto Browse del archivo Alumnos

SINTAXIS:

 oBrowse := oBrowseCer(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwAluCer(lShared,nFilSup,nColSup,nFilInf,;
		    nColInf,cNalias,cTitUno,cTitDos)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNomGra			            // Nombre Del Grado
       cNalias                              // Alias del maestro
       cTitUno                              // Titulo Uno de la pantalla
       cTitDos                              // Titulo Dos de la pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       cTitUno := IF(cTitUno == NIL,'CONSULTA DE ALUMNOS',cTitUno)
       cTitDos := IF(cTitDos == NIL,'<ESC> Abandonar',cTitDos)

       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {cTitUno,cTitDos}

     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT &cNalias
       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CODIGO', {||JAR->cCodigoEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CODIGO', {||PRI->cCodigoEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CODIGO', {||BTO->cCodigoEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CURSO', {||JAR->cCodigoGru})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CURSO', {||PRI->cCodigoGru})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CURSO', {||BTO->cCodigoGru})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||JAR->cApelliEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||PRI->cApelliEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||BTO->cApelliEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cApelliEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 3
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('NOMBRES',;
		       {||JAR->cNombreEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('NOMBRE',;
		       {||PRI->cNombreEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('NOMBRES',;
		       {||BTO->cNombreEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cNombreEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(JAR->lRetiroEst,;
						       'RETIRADO',;
						       ' ACTIVO ')})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(PRI->lRetiroEst,;
						       'RETIRADO',;
						       ' ACTIVO ')})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(BTO->lRetiroEst,;
						       'RETIRADO',;
						       ' ACTIVO ')})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||JAR->cDocNitEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||PRI->cDocNitEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||BTO->cDocNitEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cDocNitEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('DE',{||JAR->cLugNitEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('DE',{||PRI->cLugNitEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('DE',{||BTO->cLugNitEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cLugNitEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('FOLIOS;LIBRO FINAL',{||JAR->cFolFinEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('FOLIOS;LIBRO FINAL',{||PRI->cFolFinEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('FOLIOS;LIBRO FINAL',{||BTO->cFolFinEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cFolFinEst'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION  DE LA ESTRUCTURA                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/99 LUN A
       Colombia, Bucaramanga        INICIO: 05:30 PM   ABR 19/99 LUN

OBJETIVOS:

1)- Valida la Estructura del archivo y la actualiza.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lActStrAlu(lShared,PathArc,cNomArc,FileNtx,cMaeAct,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo
       cMaeAct                              // Maestro Actual
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio de la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ALU',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE ALUMNOS')
	  CloseDbf('ALU')
	  RETURN lCambio
       ENDIF
       aStrOld := ALU->(DBSTRUCT())
       CloseDbf('ALU')
       CreaDbfAlu(PathArc,cNomArc,,,@aStrNew)
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
	  cError('El Archivo '+cNomArc+' Cambio su Estructura.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfAlu(PathArc,FileTem,cMaeAct,FileNtx)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	  ENDIF
       ENDIF
       RETURN lCambio
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MENU DE INFORMES                                             *
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

FUNCTION MenuOtrAlu(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		    cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		    lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		    cJornad,oBrowse,aStrDbf)

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
       oBrowse                              // Browse del Archivo
       aStrDbf                              // Structura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL aStrSql := {}                  // Estructura del Archivo

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION Y EJECUCION DEL MENU
       AADD(aMenus,'1<ESTUDIANTE RETIRADOS>')
       AADD(aMenus,'2<MATERIAS SELECTIVAS >')
       AADD(aMenus,'3<ESTRUCTURA SQL      >')
       AADD(aMenus,'4<ESTRUCTURA,DATOS SQL>')
       AADD(aMenus,'5<BOLETINES SQL       >')

       AADD(aAyuda,'Permite imprimir el listado de Retirados')
       AADD(aAyuda,'Visualiza las Materias Selectivas del Estudiante')
       AADD(aAyuda,'Exporta Solo Estructura a Sintasis MySql')
       AADD(aAyuda,'Exporta la Estructura y los registros a Sintasis MySql')
       AADD(aAyuda,'Exporta la Estructura para los Boletines')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrAlu01(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		     cNomDpt,cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,;
		     cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		     cMaeAlu,cMaeAct,cJorTxt,cJornad,oBrowse)
	  *ÀInforme de Retirados

       CASE nNroOpc == 2
	    OtrAlu02(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		     cNomDpt,cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,;
		     cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		     cMaeAlu,cMaeAct,cJorTxt,cJornad,oBrowse)
	  *ÀMaterias Selectivas

       CASE nNroOpc == 3
	    FileSql("FILEWWW","alumnos.dat",;
		    aStrDbf,NIL,.T.,oBrowse)
	   *Registro MySql

       CASE nNroOpc == 4
	    FileSql("FILEWWW",;
		    FileAlu+cMaeAct+cAnoSis+ExtFile,;
		    aStrDbf,cMaeAct,.T.,oBrowse)
	   *Estructura y Registros MySql

       CASE nNroOpc == 5

************ESTRUCTURA SQL
	      AADD(aStrSql,{"cCodigoEst","Character",006,0}) // C¢digo del Estudiante
	      AADD(aStrSql,{"cPasWwwEst","Character",010,0}) // PassWord del Internet
	      AADD(aStrSql,{"cCodigoGru","Character",004,0}) // Codigo del grupo
	      AADD(aStrSql,{"cApelliEst","Character",030,0}) // Apellido del Estudiante
	      AADD(aStrSql,{"cNombreEst","Character",030,0}) // Nombre del Estudiante
************FIN ESTRUCTURA SQL

************CREACION DEL ARCHIVO
	      FileSql('FILEWWW',;
		      'Boletin'+ExtFile,;
		      aStrSql,cMaeAct,.T.,oBrowse)
	     *Estructura y Registros MySql
************FIN CREACION DEL ARCHIVO

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: ESTUDIANTE RETIRADOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 01/2000 JUE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   JUN 91/2000 JUE

OBJETIVOS:

1- Imprime un informe con los Estudiantes Retirados

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrAlu01(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		  cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		  lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
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
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

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

       LOCAL nNroRet := 0                   // N£mero de Retirados
       LOCAL nAvance := 0                   // Avance de registros

       FIELD dFecRetEst		            // Fecha de Retiro
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       SELECT &cMaeAct
       IF RECCOUNT() == 0
	  cError('NO EXISTEN ESTUDIANTES GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>INDEXACION DEL ARCHIVO
       fNtxTem := cFileTempo('',SUBS(cNomUsr,1,4),cExtTem)
       INDEX ON dFecRetEst TO &fNtxTem
       DBSETINDEX(fNtxTem)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := &cMaeAct->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis+' JORNADA: '+cJorTxt+' DE '+cAnoUsr,;
		   'ESTUDIANTES RETIRADOS DE '+cTxtMaeAct(cMaeAct),;
		   '',;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,06,40,12,12,06,50}
       aTitulo := {'No.',;
		   'GRUPO ',;
		   'CODIGO',;
		   'NOMBRE DEL ESTUDIANTE',;
		   'MATRICULA',;
		   'RETIRO',;
		   'ULTPER',;
		   'MOTIVO'}
       cCabCol := cRegPrint(aTitulo,@aNroCol)
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
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>SELECCION DEL TIPO DE IMPRESION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	  RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS RECUPERACIONES
       cSavPan := SAVESCREEN(0,0,24,79)
       SELECT &cMaeAct
       GO TOP
       DO WHILE .NOT. EOF()

**********VISUALIZACION DE AVANCE
	    SELECT &cMaeAct
	    SET DEVICE TO SCREEN
	    LineaEstado('REGISTRO: '+STR(RECNO(),5)+'/'+;
			 STR(RECCOUNT(),5),cNomSis)
	    SET DEVICE TO PRINT
**********FIN VISUALIZACION DE AVANCE

**********ANALISIS DEL ESTUDIANTE
	    IF .NOT. &cMaeAct->lRetiroEst
	       DBSKIP()
	       LOOP
	    ENDIF
**********FIN ANALISIS DEL ESTUDIANTE

**********IMPRESION DEL REGISTRO
	    nNroRet++
	    aTitulo := {TRANS(nNroRet,"####"),;
			&cMaeAct->cCodigoGru,;
			&cMaeAct->cCodigoEst,;
			SUBS(RTRIM(&cMaeAct->cApelliEst)+' '+;
				   &cMaeAct->cNombreEst+SPACE(40),1,40),;
			cFecha(&cMaeAct->dFecMatEst),;
			cFecha(&cMaeAct->dFecRetEst),;
			STR(&cMaeAct->nPerRetEst,2),;
			SUBS(&cMaeAct->cObsRetEst,1,50)}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT &cMaeAct
	    DBSKIP()
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       DBCLEARIND()
       IF !lFileDelete(fNtxTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       GO TOP
       oBrowse:GOTOP()
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DE NUMERO DE LISTAS   		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 21/99 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   ABR 21/99 MIE


OBJETIVOS:

1- Permite el Mantenimiento de n£mero de listas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManNroLis(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro

       LOCAL oBrowse := NIL                 // Browse de Alumnos
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
       cNalias := cMaeAct
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(lShared,cPatSis+'\'+cMaeAct+'\'+;
		   FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE ALUMNOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT &cNalias
       oBrowse := oDefBrwAlu(lShared,nFilPal+1,00,22,79,cNalias,;
		 '<<  MANTENIMIENTO DE ALUMNOS DE '+cNalias+;
		 ' .TOTAL ='+STR(RECCOUNT(),4)+'  >>',;
		 '<F2>Consultar '+;
		 '<F5>Buscar <F9>Otros <ESC>Abandonar',.F.,.T.)

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,cNalias,cNomEmp,cNomSis)})

       SETKEY(K_F5,{||BuscarAlu(lShared,oBrowse,cNalias,;
				cAnoSis,cPatSis,.F.)})

       SETKEY(K_F9,{||MenuNroLis(aParam1,aParam2,aParam3,oBrowse)})

       DO CASE
       CASE cNalias == 'JAR'
	    JAR->(CtrlBrw(lShared,oBrowse))
       CASE cNalias == 'PRI'
	    PRI->(CtrlBrw(lShared,oBrowse))
       CASE cNalias == 'BTO'
	    BTO->(CtrlBrw(lShared,oBrowse))
       ENDCASE
       SETKEY(K_F2,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: MENU DE OTROS PARA LOS NUMEROS DE LISTA        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/99 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   ABR 20/99 MAR

OBJETIVOS:

1- Menu de otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuNroLis(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse			            // Browse de Alumnos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'1<NUMERO DE LISTA           >',;
		   '2<ORDENA POR NUMERO DE LISTA>'}

       aAyuda := {'Obtiene el N£mero de lista de los Estudiantes.',;
		  'Ordena el Maestro por N£mero de Lista'}

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
	    LeeNroLis(aParam1,aParam2,aParam3,oBrowse)
	   *Graba en el maestro el n£mero de lista.

       CASE nNroOpc == 2
	    OrdenaAlu(lShared,cAnoUsr,cPatSis,oBrowse,cMaeAct)
	   *Ordena el maestro por n£mero de lista.

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE LOS NUMEROS DE LISTA                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/99 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   ABR 20/99 MAR

OBJETIVOS:

1- Graba en el maestro los n£mero de lista.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeeNroLis(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse			            // Browse de Alumnos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(lShared,cPatSis+'\'+cMaeAct+'\'+;
		   FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		   cPatSis+'\'+cMaeAct+'\'+;
		   fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALLL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DE LOS NUMEROS DE LISTA
       SELECT GRU
       GO TOP
       DO WHILE .NOT. GRU->(EOF())

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		       GRU->cCodigoGru)

	      CloseDbf('GRU')
	      CloseDbf('NOT')
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LECTURA POR GRUPO
	    SELECT NOT
	    GO TOP
	    DO WHILE .NOT. EOF()

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(20),1,20)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+;
			     'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			      NOT->(STR(RECCOUNT(),2))+;
			     'ºNOMBRE: '+cNombreTes,cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------GRABACION DEL NUMERO DE LISTA
		 SELECT &cMaeAct
		 IF lRegLock(lShared,.F.)

		    REPL &cMaeAct->nNroLisEst WITH NOT->(RECNO())
		   *Grabaci¢n del n£mero de lista.

		    DBCOMMIT()
		 ELSE
		    cError('NO SE PUEDE GRABAR EL NUMERO DE LISTA')
		 ENDIF

		 IF lShared
		    DBUNLOCK()
		 ENDIF
*--------------FIN GRABACION DEL NUMERO DE LISTA

	       SELECT NOT
	       NOT->(DBSKIP())

	    ENDDO
	    CloseDbf('NOT')
**********FIN LECTURA POR GRUPO

	  SELECT GRU
	  GRU->(DBSKIP())

       ENDDO
*>>>>FIN LECTURA DE LOS NUMEROS DE LISTA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       CLOSE ALL
       IF !lUseDbf(lShared,cPatSis+'\'+cMaeAct+'\'+;
		   FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,NIL,lShared)
	  CLOSE ALL
       ENDIF
       SELECT &cMaeAct
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DE LA FUNCION..: ORDENAR EL ARCHIVO POR NUMERO DE LISTA         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/99 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   ABR 20/99 MAR


OBJETIVOS:

1- Ordena el archivo de alumnos por el n£mero de lista.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaAlu(lShared,cAnoUsr,cPatSis,oBrowse,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       oBrowse				    // Browse del Profesor
       cMaeAct                              // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       cError('DEBE HACER COPIA DE SEGURIDAD DEL ARCHIVO')
       IF !lPregunta('ESTA SEGURO QUE DESEA CONTINUAR? No Si')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>VALIDACION DEL CONTENIDO
       SELECT &cMaeAct
       IF RECCOUNT() == 0
	  cError('NO EXISTEN ALUMNOS GRABADOS')
	  RETURN NIL
       ENDIF
       CloseDbf(cMaeAct)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,cPatSis+'\'+cMaeAct+'\'+;
		    FileAlu+cMaeAct+cAnoSis+ExtFile,'cCodigoGru','nNroLisEst')
	  cError('NO SE ORDENO EL MAESTRO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO PROFESORES')
	  RETURN NIL
       ENDIF
       SELECT &cMaeAct
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO..: MATERIAS SELECTIVAS DEL ESTUDIANTE                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 17/2002 MIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   JUN 17/2002 MIE

OBJETIVOS:

1- Visualiza las materias selectivas del Estudiante

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrAlu02(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		  cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		  lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
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
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cCabeza := ''                  // Encabezado de columna
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cSecMat := ''                  // Secuencial de la Materia

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
       FIELD cCodigoEst                     // C¢digo del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DE LOS PROFESORES
       cCodigoTes := &cMaeAct->cCodigoEst
       SELECT SEL
       SET FILTER TO cCodigoEst == cCodigoTes
       GO TOP
       IF EOF()
	  cError('EL ESTUDIANTE NO TIENE MATERIAS SELECTIVAS')
	  SET FILTER TO
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>IMPRESION DEL NOMBRE
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(nFilPal+1,'MATERIAS SELECTIVAS',22,'°')
       nNroCol := nColInf

       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+&cMaeAct->cCodigoEst
       cSay(nNroFil,nNroCol,'CODIGO:',&cMaeAct->cCodigoEst)

       cSay(nNroFil,nNroCol+15,'NOMBRE:',RTRIM(&cMaeAct->cApelliEst)+' '+;
					       &cMaeAct->cNombreEst)
       cSay(nNroFil,nNroCol+65,'CURSO:',&cMaeAct->cCodigoGru)

*>>>>FIN IMPRESION DEL NOMBRE

*>>>>CONSULTA DE LAS MATERIAS SELECTIVAS
       nNroFil += 2
       cCabeza := cRegPrint({'MATERIA','PROFESOR','OBSERVACION'},;
			    {50,08,12},@aNroCol)
       @ nNroFil,01 SAY cCabeza
       nNroFil++

       SELECT SEL
       SEL->(DBGOTOP())
       DO WHILE .NOT. SEL->(EOF())

**********LECTURA DE LAS SELECTIVAS POR PERIODO
	    FOR i := 1 TO 5

		cSecMat := SUBS(SEL->cSecMatSel,i*2-1,2)
		IF !EMPTY(cSecMat)
		   cCodigoTma := SEL->cCodAreSel+cSecMat
		   cNombreTma := 'MATERIA:'+cCodigoTma+' NO EXISTE'
		   IF lLocCodigo('cCodigoMat','MAT',cCodigoTma)
		      cNombreTma := MAT->cNombreMat
		   ENDIF
		   cNombreTma := SUBS(cNombreTma+SPACE(40),1,40)

		   @ nNroFil,aNroCol[1] SAY cCodigoTma+'-'+;
					    STR(SEL->nNroLisEst,3)+' '+;
					    cNombreTma
		   @ nNroFil,aNroCol[2] SAY SEL->cCodigoPro
		   @ nNroFil,aNroCol[3] SAY 'PERIODO No. '+STR(i,1)
		   nNroFil++
		ENDIF

	    ENDFOR
**********FIN LECTURA DE LAS SELECTIVAS POR PERIODO

**********LOCALIZACION DE LA MATERIA SELECTIVA ACTUAL
	    cCodigoTma := SEL->cCodAreSel+SEL->cSecProSel
	    IF EMPTY(SEL->cSecProSel)
	       cNombreTma := 'NO figura Materia Seleccionada'
	    ELSE
	       cNombreTma := 'MATERIA:'+cCodigoTma+' NO EXISTE'
	    ENDIF
	    IF lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	       cNombreTma := MAT->cNombreMat
	    ENDIF
	    cNombreTma := SUBS(cNombreTma+SPACE(40),1,40)
	    @ nNroFil,aNroCol[1] SAY cCodigoTma+'-'+;
				     STR(SEL->nNroLisEst,3)+' '+;
				     cNombreTma
	    @ nNroFil,aNroCol[2] SAY SEL->cCodigoPro
	    @ nNroFil,aNroCol[3] SAY 'ACTUAL SELECIONADA'
**********FIN LOCALIZACION DE LA MATERIA SELECTIVA ACTUAL

	  nNroFil++
	  SEL->(DBSKIP())

       ENDDO
*>>>>FIN CONSULTA DE LAS MATERIAS SELECTIVAS

    SET FILTER TO
    cPausa()

    RESTSCREEN(0,0,24,79,cSavPan)
    SELECT &cMaeAct
    oBrowse:GOTOP()
    oBrowse:FORCESTABLE()
RETURN NIL

/*************************************************************************
* TITULO DE LA FUNCION..: DETALLES DEL AREA DEL ESTUDIANTE               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 16/97 LUN A
       Colombia, Bucaramanga        INICIO: 08:00 AM   MAR 16/97 LUN

OBJETIVOS:

1- Reemplaza las materias variables por la materia escogida o clasificada
   del estudiante.

1- Devuelve .T. si no se presentaron problemas.


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDetAreEst(aNotAre,aNotMat,nNroBis,cCodEst,lPrnAct)

*>>>>PARAMETROS DE LA FUNCION
/*     aNotAre                              // @Detalles de las areas
       aNotMat                              // @Detalles de las materias
       nNroBis                              // N£mero del Bimestre
       cCodEst                              // C¢digo del Estudiante
       lPrnAct                              // .T. Impresi¢n Activada */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador
       LOCAL cMsgErr := ''                  // Mensaje de Error
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cSecMat := ''                  // Secuencial de la materia
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL lMatVarTma := .F.              // .T. Materia Variable
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL lPrnVarTma := .F.              // .T. Imprimir la materia en el boletin
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REEMPLAZO DE LAS MATERIAS VARIABLES
       lPrnAct := IF(lPrnAct == NIL,.F.,lPrnAct)
       FOR i := 1 TO LEN(aNotMat)

***********BUSQUEDA DE LA MATERIA VARIABLE
	     cCodigoTma := SUBS(aNotMat[i,4],9,4)

	     IF lMatVarMat(cCodigoTma,.F.) .AND.;
		lLocCodigo('cCodigoMat','PLA',MAT->cCodigoMat)

*---------------BUSQUEDA DE LA SELECCION
		  IF lSekCodigo(cCodEst+SUBS(cCodigoTma,1,2),'SEL')

*....................ANALISIS DE LA MATERIA SELECTIVA
		       IF MAT->lPorNivMat
			  LOOP
		       ENDIF
*....................FIN ANALISIS DE LA MATERIA SELECTIVA

*....................VALIDACION DE LA SELECCION
		       cSecMat := SUBS(SEL->cSecMatSel,nNroBis*2-1,2)
		       IF EMPTY(cSecMat) .AND. !MAT->lModaliMat

			  cMsgTxt := 'ESTUDIANTE: '+cCodEst+;
				     ' NO LE APARECE LEIDA LA SELECCION '+;
				     ALLTRIM(MAT->cNombreMat)
			  IF lPrnAct
			     SET DEVICE TO SCREEN
			  ENDIF
*			  cError(cMsgTxt)
			  IF lPrnAct
			     SET DEVICE TO PRINT
			  ENDIF
			  lHayErr := .T.
		       ENDIF
*....................FIN VALIDACION DE LA SELECCION

*....................REEMPLAZO DE LA MATERIA DE LA SUBDIVISION
		       IF !EMPTY(cSecMat)

*                         LOCALIZACION DE LA MATERIA DE SELECIONADA
			    lPrnVarTma := MAT->lPrnVarMat
			   *De la materia variable

			    lLocCodigo('cCodigoMat','MAT',;
				       SUBS(cCodigoTma,1,2)+cSecMat)
*                         FIN LOCALIZACION DE LA MATERIA DE SELECIONADA

*                         ANALISIS DE LA MATERIA POR NIVELES
			    aNotMat[i,11] := '  '+;  // Nivel de la Materia
					     SUBS(cCodigoTma,1,2)+cSecMat
			   *Reemplazo de la materia

			    aNotMat[i,22] := MAT->lCertifMat
			  *Materia Fija de la Materia Variable. .T.=> Entra en el certificado de notas

			    IF !EMPTY(MAT->cCodigoPro)
			       aNotMat[i,11] := 'XX'+SUBS(cCodigoTma,1,2)+cSecMat
			      *Reemplazo de la materia por niveles
			    ENDIF
*                         FIN ANALISIS DE LA MATERIA POR NIVELES

*                         ANALISIS DE LA IMPRESION DE LA MATERIA VARIABLE
			    IF !lPrnVarTma
			       aNotMat[i,2] := MAT->cNombreMat
			      *Impresi¢n de la materia selecionada
			    ENDIF
*                         FIN ANALISIS DE LA IMPRESION DE LA MATERIA VARIABLE

		       ENDIF
*....................FIN REEMPLAZO DE LA MATERIA DE LA SUBDIVISION

*....................LECTURAS DE LAS MATERIAS SELECTIVAS
		       aNotMat[i,14] := ''
		       FOR j := 1 TO 5

			   cSecMat := SUBS(SEL->cSecMatSel,j*2-1,2)
			   IF !EMPTY(cSecMat)
			      cCodigoTma := SEL->cCodAreSel+cSecMat
			   ELSE
			      cCodigoTma := SPACE(04)
			   ENDIF
			   aNotMat[i,14] += cCodigoTma

		       ENDFOR
*....................FIN LECTURAS DE LAS MATERIAS SELECTIVAS

		  ELSE
		    IF !MAT->lModaliMat
			cMsgTxt := 'EL ESTUDIANTE COD '+cCodEst+;
				   ' NO TIENE LA SELECCION '+;
				   ALLTRIM(MAT->cNombreMat)
			IF lPrnAct
			   SET DEVICE TO SCREEN
			ENDIF
			cError(cMsgTxt)
			IF lPrnAct
			   SET DEVICE TO PRINT
			ENDIF
			lHayErr := .T.
		     ENDIF
		  ENDIF
*---------------FIN BUSQUEDA DE LA SELECCION

	     ENDIF
***********FIN BUSQUEDA DE LA MATERIA VARIABLE


       ENDFOR
       RETURN !lHayErr
*>>>>FIN REEMPLAZO DE LAS MATERIAS VARIABLES
