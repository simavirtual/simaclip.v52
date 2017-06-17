/*                      SIMA - CONTABILIDAD ACADEMICA
	 BIBLIOTECAS DE FUNCIONES PARA LOS ARCHIVOS MAESTROS DE ALUMNOS

REQUERIMIENTOS:

- Compilar: clipper funcsAlu /w/m/b

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
       Colombia, Bucaramanga        INICIO: 03:40 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfAlu(lShared,PathAlu,FileAlu,lIntUno,fNtxAlu,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathAlu				    // Path del archivo
       FileAlu				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxAlu				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

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
       AADD(aDbfAlu,{"cRe2TntEst","Character",002,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"cDirRe2Est","Character",100,0}) // Direccion de la casa de la Referencia No. 2
       AADD(aDbfAlu,{"cBarRe2Est","Character",016,0}) // Barrio de la direcci¢n de la Referencia No. 2
       AADD(aDbfAlu,{"cTe1Re2Est","Character",014,0}) // Telefono No. 1 de la Referencia No. 2
       AADD(aDbfAlu,{"cTe2Re2Est","Character",014,0}) // Telefono No. 2 de la Referencia No. 2
       AADD(aDbfAlu,{"cApeFi1Est","Character",030,0}) // Apellidos del Fiador No. 1
       AADD(aDbfAlu,{"cNomFi1Est","Character",030,0}) // Nombres del Fiador No. 1
       AADD(aDbfAlu,{"cParFi1Est","Character",016,0}) // Parentesco del Fiador No. 1
       AADD(aDbfAlu,{"cFi1NitEst","Character",016,0}) // C‚dula del Fiador No. 1
       AADD(aDbfAlu,{"cFi1LugEst","Character",016,0}) // Lugar del Fiador No. 1
       AADD(aDbfAlu,{"cFi1TntEst","Character",002,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
       AADD(aDbfAlu,{"cDirFi1Est","Character",100,0}) // Direccion de la casa  Fiador No. 1
       AADD(aDbfAlu,{"cBarFi1Est","Character",016,0}) // Barrio de la direcci¢n Fiador No. 1
       AADD(aDbfAlu,{"cTe1Fi1Est","Character",014,0}) // Telefono No. 1 del Fiador No. 1
       AADD(aDbfAlu,{"cTe2Fi1Est","Character",014,0}) // Telefono No. 2 del Fiador No. 1
       AADD(aDbfAlu,{"cApeFi2Est","Character",030,0}) // Apellidos del Fiador No. 2
       AADD(aDbfAlu,{"cNomFi2Est","Character",030,0}) // Nombres del Fiador No. 2
       AADD(aDbfAlu,{"cParFi2Est","Character",016,0}) // Parentesco del Fiador No. 2
       AADD(aDbfAlu,{"cFi2NitEst","Character",016,0}) // C‚dula del Fiador No. 2
       AADD(aDbfAlu,{"cFi2LugEst","Character",016,0}) // Lugar del Fiador No. 2
       AADD(aDbfAlu,{"cFi2TntEst","Character",002,0}) // Tipo de Documento TI=>Tarjeta de Identidad CC=>Cedula de Ciudadania CE => Cedula de Extrajeria NI => Nit
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
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:45 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfAlu(lShared,PathAlu,FileAlu,lIntUno,fNtxAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathAlu			      // Path del sistema
       FileAlu			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxAlu			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathAlu+'\'+FileAlu,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfAlu(lShared,PathAlu,FileAlu,lIntUno,fNtxAlu)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION  DE LA ESTRUCTURA                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 27/99 MAR A
       Colombia, Bucaramanga        INICIO: 05:30 PM   JUL 27/99 MAR

OBJETIVOS:

1)- Valida la Estructura del archivo y la actualiza.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lActStrAlu(lShared,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       CreaDbfAlu(lShared,PathArc,cNomArc,,,@aStrNew)
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
			 {||CreaDbfAlu(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	  ENDIF
       ENDIF
       RETURN lCambio
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: INDEXAR LOS ARCHIVOS DE ALUMNOS                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 05:40 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Indexa los archivos maestros de alumnos

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION NtxAlu(lShared,cPatCon,cPatSis,cAnoSis,cMaeAlu,lMemUsb)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cPatCon				    // Path de la Contabilidad
       cPatSis                              // Path del Sistema
       cAnoSis                              // A¤o del sistema
       cMaeAlu                              // Maestros Habilitados
       lMemUsb                              // .T. SimaProf en Usb. .F. SimaProf en la Red */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL cPatTem := ''                  // Path Temporal

       FIELD cCodigoEst
       FIELD cApelliEst
       FIELD cNombreEst
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE INDICES PARA EL NIVEL
       lMemUsb := IF(lMemUsb == NIL,.F.,lMemUsb)
       FOR i := 1 TO LEN(cMaeAlu)/3

***********ANALISIS DEL NIVEL ESCOGIDO
	     cNomNiv := ''
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	     DO CASE
	     CASE 'JAR' $ cMaeAct
		  cNomNiv := 'JARDIN'
	     CASE 'PRI' $ cMaeAct
		  cNomNiv := 'PRIMARIA'
	     CASE 'BTO' $ cMaeAct
		  cNomNiv := 'BACHILLERATO'
	     ENDCASE
***********FIN ANALISIS DEL NIVEL ESCOGIDO

***********AREAS DE TRABAJO
	     aUseDbf := {}

	     AADD(aUseDbf,{.T.,cPatCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileAlu+cMaeAct+cAnoSis+ExtFile,;
			       cMaeAct,NIL,lShared,nModCry})
***********FIN AREAS DE TRABAJO

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbfs(aUseDbf)
		cError('ABRIENDO ARCHIVOS PARA INDEXAR '+cNomNiv)
		CloseDbf(cMaeAct)
		CloseDbf('JUI')
		CloseDbf('SEL')
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********CREACION DE INDEXES
	     Termometro(0,'INDEXANDO A '+cNomNiv)
	     Termometro(25)

	     SELECT &cMaeAct
	     fNtxAlu := cPatCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
			'MAE'+cMaeAct+cAnoSis+cExtNtx
	     INDEX ON cCodigoEst TO &fNtxAlu

	     Termometro(50)
	     fNtxAlu := cPatCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
			'APE'+cMaeAct+cAnoSis+cExtNtx
	     INDEX ON cApelliEst TO &fNtxAlu

	     Termometro(75)
	     fNtxAlu := cPatCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
			'NOM'+cMaeAct+cAnoSis+cExtNtx
	     INDEX ON cNombreEst TO &fNtxAlu

	     CloseDbf(cMaeAct)
***********FIN CREACION DE INDEXES

       NEXT
*>>>>FIN CREACION DE INDICES PARA EL NIVEL

*>>>>ANALISIS DE DECISION
      IF lMemUsb
	 RETURN NIL
      ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatCon+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatCon+'\'+PathSis+'\'+;
			 FileObG,'OBG',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS PARA INDEXAR')
	  CloseDbf('PER')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CREACION DE INDEXES GENERALES
       SELECT PER
       fNtxPer := cPatCon+'\'+PathSis+'\'+fNtxPer
       INDEX ON PER->nIdeCodPer TO &fNtxPer

       Ntx1Per := cPatCon+'\'+PathSis+'\'+Ntx1Per
       INDEX ON PER->cDocNitPer+PER->cTipNitPer TO &Ntx1Per

       CloseDbf('PER')

       SELECT OBG
       fNtxObG := cPatCon+'\'+PathSis+'\'+fNtxObG
       INDEX ON OBG->cCodigoEst TO &fNtxObG
       CloseDbf('OBG')

       RETURN NIL
*>>>>FIN CREACION DE INDEXES GENERALES

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

FUNCTION lUseMaeMtr(lShared,cPatSis,cMaeAlu,cAnoSis,lAnoAct,lUseNtx)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cPatSis			            // Path del Sistema
       cMaeAlu                              // Maestros habilitados
       cAnoSis                              // A¤o del sistema
       lAnoAct                              // .F. A¤o Anteriores
       lUseNtx                              // .T. Abrir Indixes */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL PathAlu := ''                  // Path de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lAnoAct := IF(lAnoAct==NIL,.T.,lAnoAct)
       lUseNtx := IF(lUseNtx==NIL,.T.,lUseNtx)
       IF 'GUA' $ cMaeAlu

	  PathAlu := cPatSis+'\GUA\'
	  IF !lUseDbf(.T.,PathAlu+FMaeGua+cAnoSis+ExtFile,;
		      IF(lAnoAct,'GUA','GAN'),;
		      IF(lUseNtx,PathAlu+fNtxGua+cAnoSis+cExtNtx,NIL),lShared)
	     cError('ABRIENDO ARCHIVOS DE GUARDERIA EN '+PathAlu)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF

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
* TITULO DE LA FUNCION..: SELECCION SELECION DEL ALIAS POR EL GRUPO      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 03/96 SAB A
       Colombia, Bucaramanga        INICIO: 02:50 PM   FEB 03/96 SAB

OBJETIVOS:

1- Seleciona el Alias de acuerdo al nivel

2- Retorna retorna el alias del nivel

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cAliasNiv(nNroNiv,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroNiv				    // N£mero del nivel
       lAnoAct                              // .T. A¤o Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNalias := ''                  // Nombre del Alias
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DEL MAESTRO DE ACUERDO A LA DIVISION
       lAnoAct := IF(lAnoAct == NIL,.T.,lAnoAct)
       DO CASE
       CASE nNroNiv >= 0 .AND. nNroNiv <= 5
	    cNalias := IF(lAnoAct,'PRI','PRA')

       CASE nNroNiv >= 6 .AND. nNroNiv <= 11
	    cNalias := IF(lAnoAct,'BTO','BTA')

       CASE nNroNiv >= 12  .AND. nNroNiv <= 16
	    cNalias := IF(lAnoAct,'JAR','JAA')

       OTHERWISE
	    cError('MAL PASADO EL NIVEL')
	    cNalias := 'ERROR'
       ENDCASE
       RETURN cNalias
*>>>>FIN SELECION DEL MAESTRO DE ACUERDO A LA DIVISION

/*************************************************************************
* TITULO DE LA FUNCION..: CONSULTA DE LOS DETALLES DE MATRICULA          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 03/96 SAB A
       Colombia, Bucaramanga        INICIO: 04:40 PM   FEB 03/96 SAB

OBJETIVOS:

1)- Consulta los detalles de la matricula del estudiante

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DetalleMat(cCodigo,nNroNiv,cNombre,cApelli,cLugNac,dFecNac,;
		    cNroNit,cLugNit,cDirecc,cBarrio,cTelefn,cNomPad,;
		    cPadNit,cPadLug,cProPad,cEmpPad,cCarPad,cTelPad,;
		    cNomMad,cMadNit,cMadLug,cProMad,cEmpMad,cCarMad,;
		    cTelMad,cNomAcu,cAcuNit,cAcuLug,cTe1Acu,cTe2Acu)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo de la estudiante
       nNroNiv				    // N£mero del nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       cLugNac                              // Lugar de Nacimiento
       dFecNac                              // Fecha de Nacimiento
       cNroNit                              // Documento de identidad
       cLugNit                              // Lugar de documento
       cDirecc                              // Direccion del estudiante
       cBarrio                              // Barrio
       cTelefn                              // Telefono
       cNomPad                              // Nombre del padre
       cPadNit                              // Cedula del padre
       cPadLug                              // Lugar de la Cedula
       cProPad                              // Profesion del padre
       cEmpPad			            // Empresa donde trabaja
       cCarPad                              // Cargo en la Empresa
       cTelPad                              // Telefono del padre
       cNomMad                              // Nombre de la madre
       cMadNit                              // Cedula de la madre
       cMadLug                              // Lugar de la Cedula
       cProMad                              // Profesion de la madre
       cEmpMad			            // Empresa donde trabaja
       cCarMad                              // Cargo de la madre
       cTelMad                              // Telefono de la madre
       cNomAcu                              // Nombre del acudiente
       cAcuNit                              // Cedula de la madre
       cAcuLug                              // Lugar de la Cedula
       cTe1Acu                              // Telefono uno del acudiente
       cTe2Acu                              // Telefono dos del acudiente */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la columna
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS TITULOS
       nNroFil := nMarco(0,'DETALLES DE LA MATRICULA DEL ESTUDIANTE',22,'°')
       nNroCol := 1

       cNombre := RTRIM(cApelli)+" "+RTRIM(cNombre)
       @ nNroFil,nNroCol SAY "NOMBRE:"        GET cNombre

       cNomNiv := cNomNiv(nNroNiv)
       @ nNroFil++,nNroCol+60 SAY "NIVEL: "   GET cNomNiv
       @nNroFil,nNroCol+00    SAY 'NACIDO EN:' GET cLugNac
       @nNroFil++,nNroCol+37  SAY 'FECHA:'     GET dFecNac
       @nNroFil  ,nNroCol+00  SAY 'DOCUMENTO:' GET cNroNit
       @nNroFil++,nNroCol+37  SAY 'DE:'        GET cLugNit
       @nNroFil,nNroCol+00    SAY 'DIRECCION:' GET cDirecc
       @++nNroFil,nNroCol+00  SAY 'BARRIO:'    GET cBarrio
       @nNroFil++,nNroCol+57  SAY 'TELEFONO:'  GET cTelefn

       @++nNroFil,nNroCol+00 SAY 'PADRE:'     GET cNomPad
       @nNroFil  ,nNroCol+57 SAY 'TELEFONO:'  GET cTelPad
       @++nNroFil,nNroCol+00 SAY 'DOCUMENTO:' GET cPadNit
       @nNroFil  ,nNroCol+28 SAY 'DE:'        GET cPadLug
       @++nNroFil,nNroCol+00 SAY 'PROFESION:' GET cProPad
       @++nNroFil,nNroCol+00 SAY 'EMPRESA:'   GET cEmpPad
       @nNroFil++,nNroCol+34 SAY 'CARGO:'     GET cCarPad

       @++nNroFil,nNroCol+00 SAY 'MADRE:'     GET cNomMad
       @nNroFil  ,nNroCol+57 SAY 'TELEFONO:'  GET cTelMad
       @++nNroFil,nNroCol+00 SAY 'DOCUMENTO:' GET cMadNit
       @nNroFil  ,nNroCol+28 SAY 'DE:'        GET cMadLug
       @++nNroFil,nNroCol+00 SAY 'PROFESION:' GET cProMad
       @++nNroFil,nNroCol+00 SAY 'EMPRESA:'   GET cEmpMad
       @nNroFil++,nNroCol+34 SAY 'CARGO:'     GET cCarMad

       @++nNroFil,nNroCol+00 SAY 'ACUDIENTE:' GET cNomAcu
       @nNroFil  ,nNroCol+57 SAY 'TEL CASA:'  GET cTe1Acu
       @++nNroFil,nNroCol+00 SAY 'DOCUMENTO:' GET cAcuNit
       @nNroFil  ,nNroCol+28 SAY 'DE:'        GET cAcuLug
       @nNroFil  ,nNroCol+57 SAY 'TEL OFIC:'  GET cTe2Acu

       CLEAR GETS
       RETURN NIL
*>>>>FIN IMPRESION DE LOS TITULOS

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

FUNCTION MantenAlu(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		   cPatSis,cIntUno,cIntDos,cIntTre,cIntCua,;
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
       cIntUno                              // Primera Integraci¢n
       cIntDos                              // Segunda Integraci¢n
       cIntTre                              // Tercera Integraci¢n
       cIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nModCry := 0                   // Modo de Protecci¢n
     *ÀVariables generales

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL oBrwAlu := NIL                 // Browse de Alumnos
       LOCAL GetList := {}                  // Variable del Sistema

       FIELD cCodigoEst                     // C¢digo del Estudiante
       FIELD cNombreEst                     // Nombre del Estudiante
       FIELD cApelliEst                     // Apellido del Estudiante
       FIELD cCodigoGru                     // C¢digo del Grupo
       SET DECIMALS    TO 0                 // Cifras decimales
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cNalias := cMaeAct
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMaeMtr(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
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

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

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
       oBrwAlu := oDefBrwAlu(lShared,nFilPal+1,00,22,79,cNalias,;
		 '<<  MANTENIMIENTO DE ALUMNOS DE '+cNalias+;
		 ' .TOTAL ='+STR(RECCOUNT(),4)+'  >>',;
		 '<F2>Informaci¢n Personal <F4>Modificar '+;
		 '<F5>Buscar  <ESC>Abandonar')
       SETKEY(K_F2,{||InfoAlu(nFilPal,1,cNalias,cNomEmp,cNomSis)})
*      SETKEY(K_F3,{||EstadoCta(lShared,nFilPal,1,cMaeAct)})
       SETKEY(K_F4,{||lDatosEst(lShared,nFilPal,1,cNalias,;
				cCodigoEst,;
				SUBS(ALLTRIM(cApelliEst)+' '+cNombreEst,1,40),;
				cCodigoGru)})
       SETKEY(K_F5,{||BuscarAlu(lShared,oBrwAlu,cNalias,cAnoSis,cIntUno)})

       DO CASE
       CASE cNalias == 'JAR'
	    JAR->(CtrlBrw(lShared,oBrwAlu))
       CASE cNalias == 'PRI'
	    PRI->(CtrlBrw(lShared,oBrwAlu))
       CASE cNalias == 'BTO'
	    BTO->(CtrlBrw(lShared,oBrwAlu))
       ENDCASE
       SETKEY(K_F2,NIL)
       SETKEY(K_F5,NIL)
       CLOSE ALL
       SET DECIMALS    TO 2                 // Cifras decimales
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

 oBrwAlu := oDefBrwAlu(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwAlu(lShared,nFilSup,nColSup,nFilInf,;
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
       LOCAL oBrwAlu := NIL		    // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       cTitUno := IF(cTitUno == NIL,'CONSULTA DE ALUMNOS',cTitUno)
       cTitDos := IF(cTitDos == NIL,'<ESC> Abandonar',cTitDos)

       oBrwAlu := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwAlu:ColSep    := '³'
       oBrwAlu:HeadSep   := 'Ä'
       oBrwAlu:Cargo     := {cTitUno,cTitDos}

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
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CURSO', {||JAR->cCodigoGru})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CURSO', {||PRI->cCodigoGru})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CURSO', {||BTO->cCodigoGru})
       ENDCASE
       oColumn:Cargo := {{'MODI',IF(MTR->nPruebaMtr==0,.F.,.T.)},;
			 {'ALIAS',cNalias},;
			 {'FIELD','cCodigoGru'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('APELLIDOS;DEL ESTUDIANTE',;
		       {||JAR->cApelliEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('APELLIDOS;DEL ESTUDIANTE',;
		       {||PRI->cApelliEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('APELLIDOS;DEL ESTUDIANTE',;
		       {||BTO->cApelliEst})
       ENDCASE

       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cApelliEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
       oBrwAlu:Freeze:= 3
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('NOMBRES;DEL ESTUDIANTE',;
		       {||JAR->cNombreEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('NOMBRES;DEL ESTUDIANTE',;
		       {||PRI->cNombreEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('NOMBRES;DEL ESTUDIANTE',;
		       {||BTO->cNombreEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cNombreEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('FECHA;DE RETIRO',{||cFecha(JAR->dFecRetEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('FECHA;DE RETIRO',{||cFecha(PRI->dFecRetEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('FECHA;DE RETIRO',{||cFecha(BTO->dFecRetEst)})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('MES PARA EL;ULTIMO RECIBO',{||JAR->nUltRecEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('MES PARA EL;ULTIMO RECIBO',{||PRI->nUltRecEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('MES PARA EL;ULTIMO RECIBO',;
				   {||BTO->nUltRecEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','nUltRecEst'}, {'PICTURE','99'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ULTIMO PERIODO;HABILITADO',{||JAR->nPerRetEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ULTIMO PERIODO;HABILITADO',{||PRI->nPerRetEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ULTIMO PERIODO;HABILITADO',;
				   {||BTO->nPerRetEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','nPerRetEst'}, {'PICTURE','9'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('REPITE',{||JAR->lRepiteEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('REPITE',{||PRI->lRepiteEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('REPITE',{||BTO->lRepiteEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTe1AcuEst'))

       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','lEstNewEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

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
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('FECHA DE;MATRICULA',{||cFecha(JAR->dFecMatEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('FECHA DE;MATRICULA',{||cFecha(PRI->dFecMatEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('FECHA DE MATRICULA',{||cFecha(BTO->dFecMatEst)})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('HORA DE;MATRICULA',{||cHoraSys(JAR->cHorMatEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('HORA DE;MATRICULA',{||cHoraSys(PRI->cHorMatEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('HORA DE;MATRICULA',{||cHoraSys(BTO->cHorMatEst)})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||JAR->nEstratEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||PRI->nEstratEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||BTO->nEstratEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','nEstratEst'}, {'PICTURE','99'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cConcepEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 1',{||JAR->cNitCo1Est})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 1',{||PRI->cNitCo1Est})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 1',{||BTO->cNitCo1Est})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cNitCo1Est'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 2',{||JAR->cNitCo2Est})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 2',{||PRI->cNitCo2Est})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 2',{||BTO->cNitCo2Est})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cNitCo2Est'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 3',{||JAR->cNitCo3Est})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 3',{||PRI->cNitCo3Est})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 3',{||BTO->cNitCo3Est})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cNitCo3Est'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 4',{||JAR->cNitCo4Est})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 4',{||PRI->cNitCo4Est})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CONTRATANTE No. 4',{||BTO->cNitCo4Est})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			    {'FIELD','cNitCo4Est'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('A. TECNICA',{||JAR->cCodigoMat})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('A. TECNICA',{||PRI->cCodigoMat})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('A. TECNICA',{||BTO->cCodigoMat})
       ENDCASE
       oColumn:Width := 10
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cCodigoMat'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(JAR->dFecNacEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(PRI->dFecNacEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(BTO->dFecNacEst)})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','dFecNacEst'}, {'PICTURE','@D'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('LUGAR', {||JAR->cLugNacEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('LUGAR', {||PRI->cLugNacEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('LUGAR', {||BTO->cLugNacEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cLugNacEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cDireccEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||JAR->cTelefnEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||PRI->cTelefnEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||BTO->cTelefnEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cTelefnEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cBarrioEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cNomPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cProPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cEmpPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cCarPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cTelPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cNomMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cProMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cEmpMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cCarMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cTelMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cNomAcuEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cTe1AcuEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
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
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS',cNalias},;
			 {'FIELD','cTe2AcuEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       RETURN oBrwAlu
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DEL PROGRAMA..: GRABACION DE LOS DATOS DEL ESTUDIANTE           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 05:20 PM   DIC 02/96 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de Estudiantes del respectivo Nivel

2- El archivo debe estar ubicado en el registro del estudiante y debe estar
   bloqueado

3- Graba los datos Generales del Estudiante

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDatosEst(lShared,nFilInf,nColInf,cMaeAct,;
		   cCodEst,cNombre,cCodGru,nNroOpc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila de lectura
       nColInf                              // Columna de lectura
       cMaeAct                              // Maestro Habilitado
       cCodEst			            // C¢digo del Estudiante
       cNombre                              // Nombre del estudiante
       cCodGru                              // C¢digo del grupo
       nNroOpc                              // N£mero de Opci¢n */
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
       LOCAL cTxtTem := ''                  // Texto temporal
       LOCAL nTipAcu := 0                   // Tipo de Acudiente

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cLugNacTes := ''               // Lugar de nacimiento
       LOCAL dFecNacTes := ''               // Fecha de nacimiento
       LOCAL cDocNitTes := ''		    // Documento de identidad
       LOCAL cLugNitTes := ''		    // Lugar de expedici¢n
       LOCAL cTipNitTes := ''               // Tipo del Documento
       LOCAL lSexFemTes := .F.              // Sexo del Estudiante
       LOCAL nEstratTes := 0                // Estracto del Estudiante
       LOCAL cDireccTes := ''		    // Direcci¢n del candidato
       LOCAL cBarrioTes := ''		    // Barrio
       LOCAL cCiudadTes := ''               // Ciudad del Estudiante
       LOCAL cTelefnTes := ''		    // Telefono de la residencia
       LOCAL cTelCelTes := ''               //*Telefono celular del Estudiante
       LOCAL cMaiEstTes := ''               // E-MAIL de la Casa o del Estudiante
       LOCAL cNomEpsTes := ''               // Nombre de la Eps
       LOCAL cGrupRhTes := ''               // Grupo Sanguineo

       LOCAL cViveCoTes := ''               // *Estudiante vive con.
       LOCAL nNroHerTes := ''               // *N£mero de Hermanos.
       LOCAL cHerGruTes := ''               // *Grupo de los Hermanos
       LOCAL cLocaliTes := ''               // *Localidad.
       LOCAL cZonaDiTes := ''               // *Zona de la Direcci¢n.

       LOCAL cApePadTes := ''               // Apellido del padre
       LOCAL cNomPadTes := ''		    // Nombre del padre
       LOCAL lPadQepTes := .F.              // Fallecido
       LOCAL cPadQepTes := ''               // Fallecido
       LOCAL cPadNitTes := ''               // C‚dula del padre
       LOCAL cPadLugTes := ''               // Lugar de la c‚dula
       LOCAL cPadTntTes := ''               // Tipo del Documento
       LOCAL cDirPadTes := ''               // Direcci¢n del Padre
       LOCAL cBarPadTes := ''               // Barrio del Padre
       LOCAL cCiuPadTes := ''               // Ciudad del Padre
       LOCAL cProPadTes := ''		    // Profesi¢n del padre
       LOCAL cEmpPadTes := ''		    // Empresa del padre
       LOCAL cCarPadTes := ''		    // Cargo del padre
       LOCAL cTelPadTes := ''               // Telefono del padre
       LOCAL cCelPadTes := ''               //*Telefono celular del Padre
       LOCAL cFaxPadTes := ''               //*Fax del Padre
       LOCAL cBipPadTes := ''               //*Biper del Padre
       LOCAL cMaiPadTes := ''               // E-MAIL del Padre

       LOCAL cApeMadTes := ''               // Apellido de la madre
       LOCAL cNomMadTes := ''		    // Nombre de la madre
       LOCAL lMadQepTes := .F.              // Fallecida
       LOCAL cMadQepTes := ''               // Fallecida
       LOCAL cMadNitTes := ''               // C‚dula de la madre
       LOCAL cMadLugTes := ''               // Lugar de la c‚dula
       LOCAL cMadTntTes := ''               // Tipo del Documento
       LOCAL cDirMadTes := ''               // Direcci¢n de la Madre
       LOCAL cBarMadTes := ''               // Barrio de la Madre
       LOCAL cCiuMadTes := ''               // Ciudad de la Madre
       LOCAL cProMadTes := ''		    // Profesi¢n de la madre
       LOCAL cEmpMadTes := ''		    // Empresa de la madre
       LOCAL cCarMadTes := ''		    // Cargo de la madre
       LOCAL cTelMadTes := ''		    // Telefono de la madre
       LOCAL cCelMadTes := ''               //*Telefono celular de la Madre
       LOCAL cFaxMadTes := ''               //*Fax de la Madre
       LOCAL cBipMadTes := ''               //*Biper de la Madre
       LOCAL cMaiMadTes := ''               // E-MAIL de la Madre

       LOCAL cApeAcuTes := ''               // Apellido del Acudiente
       LOCAL cNomAcuTes := ''		    // Nombre del acudiente
       LOCAL cAcuNitTes := ''               // C‚dula del acudiante
       LOCAL cAcuLugTes := ''               // Lugar de la c‚dula
       LOCAL cAcuTntTes := ''               // Tipo del Documento
       LOCAL cDirAcuTes := ''               // Direcci¢n del Acudiente
       LOCAL cBarAcuTes := ''               // Barrio del Acudiente
       LOCAL cCiuAcuTes := ''               // Ciudad del Acudiente
       LOCAL cProAcuTes := ''		    // Profesi¢n del Acudiente
       LOCAL cEmpAcuTes := ''		    // Empresa del Acudiente
       LOCAL cCarAcuTes := ''		    // Cargo de la Acudiente
       LOCAL cTe1AcuTes := ''		    // Telefono casa acudiente
       LOCAL cTe2AcuTes := ''		    // Telefono oficina acudiente
       LOCAL cCelAcuTes := ''               //*Telefono celular del Acudiente
       LOCAL cFaxAcuTes := ''               //*Fax del Acudiente
       LOCAL cBipAcuTes := ''               //*Biper del Acudiente
       LOCAL cMaiAcuTes := ''               // E-MAIL del Acudiente
       LOCAL cParAcuTes := ''               // Parentesco del Acudiente

       LOCAL GetList    := {}               // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>MENU DE ACTUALIZACION
       IF EMPTY(nNroOpc)
	  AADD(aMenus,'1<INFORMACION PERSONAL>')
	  AADD(aMenus,'2<INFORMACION FAMILIAR>')
	  AADD(aAyuda,'Actualiza la Informaci¢n Personal')
	  AADD(aAyuda,'Actualiza la Informaci¢n Familiar')

	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := 1
	  nNroOpc := nMenu(aMenus,aAyuda,10,25,'ACTUALIZAR',NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nNroOpc == 0
	     IF !EMPTY(cMaeAct)
		SELECT &cMaeAct
	     ENDIF
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN MENU DE ACTUALIZACION

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nTipCur := SETCURSOR(1)
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(nFilInf+1,;
		  IF(nNroOpc==1,;
		     'POR FAVOR ACTUALICE LA INFORMACION DEL ESTUDIANTE',;
		     'CODIGO: '+cCodEst+' '+cNombre+' '+;
		     'CURSO : '+cCodGru),22,'°')

       nNroCol := nColInf
       IF nNroOpc == 1
	  @ nNroFil,nNroCol+00 SAY 'CODIGO: '+cCodEst
	  @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+cNombre
	  @ nNroFil,nNroCol+65 SAY 'CURSO : '+cCodGru
       ENDIF
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       SET ESCAPE ON
       SELECT &cMaeAct
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES TANOORALES
	    IF lGrabar

	       cLugNacTes := &cMaeAct->cLugNacEst
	       dFecNacTes := &cMaeAct->dFecNacEst
	       cDocNitTes := &cMaeAct->cDocNitEst
	       cLugNitTes := &cMaeAct->cLugNitEst
	       cTipNitTes := &cMaeAct->cTipNitEst
	       lSexFemTes := &cMaeAct->lSexFemEst
	       nEstratTes := &cMaeAct->nEstratEst
	       IF lSexFemTes
		  cSexFem := 'F'
	       ELSE
		  cSexFem := 'M'
	       ENDIF
	       cDireccTes := &cMaeAct->cDireccEst
	       cBarrioTes := &cMaeAct->cBarrioEst
	       cCiudadTes := &cMaeAct->cCiudadEst
	       cTelefnTes := &cMaeAct->cTelefnEst
	       cTelCelTes := &cMaeAct->cTelCelEst
	       cMaiEstTes := &cMaeAct->cMaiEstEst
	       cNomEpsTes := &cMaeAct->cNomEpsEst
	       cGrupRhTes := &cMaeAct->cGrupRhEst
	     *ÀInformaci¢n Personal

	       cViveCoTes := &cMaeAct->cViveCoEst
	       nNroHerTes := &cMaeAct->nNroHerEst
	       cHerGruTes := &cMaeAct->cHerGruEst
	       cLocaliTes := &cMaeAct->cLocaliEst
	       cZonaDiTes := &cMaeAct->cZonaDiEst
	     *ÀInformaci¢n Personal

	       cApePadTes := &cMaeAct->cApePadEst
	       cNomPadTes := &cMaeAct->cNomPadEst
	       lPadQepTes := &cMaeAct->lPadQepEst
	       cPadQepTes := IF(lPadQepTes,'S','N')
	       cPadNitTes := &cMaeAct->cPadNitEst
	       cPadLugTes := &cMaeAct->cPadLugEst
	       cPadTntTes := &cMaeAct->cPadTntEst
	       cDirPadTes := &cMaeAct->cDirPadEst
	       cBarPadTes := &cMaeAct->cBarPadEst
	       cCiuPadTes := &cMaeAct->cCiuPadEst
	       cProPadTes := &cMaeAct->cProPadEst
	       cEmpPadTes := &cMaeAct->cEmpPadEst
	       cCarPadTes := &cMaeAct->cCarPadEst
	       cTelPadTes := &cMaeAct->cTelPadEst
	       cCelPadTes := &cMaeAct->cCelPadEst
	       cFaxPadTes := &cMaeAct->cFaxPadEst
	       cBipPadTes := &cMaeAct->cBipPadEst
	       cMaiPadTes := &cMaeAct->cMaiPadEst
	     *ÀInformaci¢n del Padre

	       cApeMadTes := &cMaeAct->cApeMadEst
	       cNomMadTes := &cMaeAct->cNomMadEst
	       lMadQepTes := &cMaeAct->lMadQepEst
	       cMadQepTes := IF(lMadQepTes,'S','N')
	       cMadNitTes := &cMaeAct->cMadNitEst
	       cMadLugTes := &cMaeAct->cMadLugEst
	       cMadTntTes := &cMaeAct->cMadTntEst
	       cDirMadTes := &cMaeAct->cDirMadEst
	       cBarMadTes := &cMaeAct->cBarMadEst
	       cCiuMadTes := &cMaeAct->cCiuMadEst
	       cProMadTes := &cMaeAct->cProMadEst
	       cEmpMadTes := &cMaeAct->cEmpMadEst
	       cCarMadTes := &cMaeAct->cCarMadEst
	       cTelMadTes := &cMaeAct->cTelMadEst
	       cCelMadTes := &cMaeAct->cCelMadEst
	       cFaxMadTes := &cMaeAct->cFaxMadEst
	       cBipMadTes := &cMaeAct->cBipMadEst
	       cMaiMadTes := &cMaeAct->cMaiMadEst
	     *ÀInformaci¢n de la Madre

	       cParAcuTes := &cMaeAct->cParAcuEst
	       cApeAcuTes := &cMaeAct->cApeAcuEst
	       cNomAcuTes := &cMaeAct->cNomAcuEst
	       cAcuNitTes := &cMaeAct->cAcuNitEst
	       cAcuLugTes := &cMaeAct->cAcuLugEst
	       cAcuTntTes := &cMaeAct->cAcuTntEst
	       cDirAcuTes := &cMaeAct->cDirAcuEst
	       cBarAcuTes := &cMaeAct->cBarAcuEst
	       cCiuAcuTes := &cMaeAct->cCiuAcuEst
	       cProAcuTes := &cMaeAct->cProAcuEst
	       cEmpAcuTes := &cMaeAct->cEmpAcuEst
	       cCarAcuTes := &cMaeAct->cCarAcuEst
	       cTe1AcuTes := &cMaeAct->cTe1AcuEst
	       cTe2AcuTes := &cMaeAct->cTe2AcuEst
	       cCelAcuTes := &cMaeAct->cCelAcuEst
	       cFaxAcuTes := &cMaeAct->cFaxAcuEst
	       cBipAcuTes := &cMaeAct->cBipAcuEst
	       cMaiAcuTes := &cMaeAct->cMaiAcuEst
	     *ÀInformaci¢n del Acudiente

	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES TANOORALES

**********LECTURA DE LOS DATOS DEL CANDIDATO
	    DO CASE
	    CASE nNroOpc == 1

*----------------INFORMACION PERSONAL
		   nNroFil := nFilInf+6
		   @nNroFil,nNroCol+00   SAY 'NACIDO EN:';
					 GET cLugNacTes PICT "@!";
					 VALID !EMPTY(cLugNacTes)

		   @nNroFil,nNroCol+34 SAY 'FECHA:';
					 GET dFecNacTes;
					 VALID !EMPTY(dFecNacTes)

		   @nNroFil,nNroCol+53 SAY 'SEXO:';
					 GET cSexFem;
					 VALID lValSexo(ROW(),COL()-1,;
					       @cSexFem,@lSexFemTes)

		   @nNroFil++,nNroCol+62 SAY 'ESTRATO:';
					 GET nEstratTes PICT "99"

		   @nNroFil  ,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cDocNitTes PICT "@!";
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

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiudadTes PICT "@!S30";
					 VALID !EMPTY(cCiudadTes)

		   @nNroFil++,nNroCol+40 SAY 'TELEFONO:';
					 GET cTelefnTes PICT "@S7"

		   @nNroFil  ,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiEstTes PICT "@X"

		   @nNroFil++,nNroCol+53 SAY 'CELULAR :';
					 GET cTelCelTes PICT "@!"

		   @nNroFil  ,nNroCol+00 SAY 'EPS :';
					 GET cNomEpsTes PICT "@!"

		   @nNroFil++,nNroCol+53 SAY 'GRUPO RH :';
					 GET cGrupRhTes PICT "@X"

		   IF .T.
		      @nNroFil++,nNroCol+00 SAY 'VIVE CON :';
					    GET cViveCoTes PICT "@!"

		      @nNroFil  ,nNroCol+00 SAY 'No.HERMANOS :';
					    GET nNroHerTes PICT "99"
		      @nNroFil++,nNroCol+17 SAY 'CURSOS :';
					    GET cHerGruTes PICT "@X"

		      @nNroFil++,nNroCol+00 SAY 'LOCALIDAD:';
					    GET cLocaliTes PICT "@!"

		      @nNroFil++,nNroCol+00 SAY 'ZONA:';
					    GET cZonaDiTes PICT "@!"
		   ENDIF
*----------------FIN INFORMACION PERSONAL

	    CASE nNroOpc == 2

*----------------ACTUALIZACION DE LOS DATOS DEL PADRE
		   nNroFil := nFilInf+3

		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS PADRE:';
					 GET cApePadTes PICT "@!S20"

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES PADRE:';
					 GET cNomPadTes PICT "@!S25"

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cPadNitTes PICT "@!"

		   @nNroFil,nNroCol+28 SAY 'TIPO:';
				       GET cPadTntTes PICT "@!";
				       VALID EMPTY(cPadTntTes) .OR.;
					     lValTipNit(ROW(),COL()-1,;
							@cPadTntTes)

		   @nNroFil,nNroCol+38 SAY 'DE:';
					 GET cPadLugTes PICT "@!"

		   @nNroFil++,nNroCol+59 SAY 'TEL:';
					 GET cTelPadTes PICT "@!9"

		   @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					 GET cEmpPadTes PICT "@!"

		   @nNroFil++,nNroCol+38  SAY 'CARGO:';
					  GET cCarPadTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
				       GET cDirPadTes PICT "@!S45"

		   @nNroFil++  ,nNroCol+52 SAY 'BARRIO:';
					   GET cBarPadTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiuPadTes PICT "@!S29"

		   @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					 GET cProPadTes PICT "@!"

		   @nNroFil  ,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiPadTes PICT "@X"

		   @nNroFil++,nNroCol+52 SAY 'FAX      :';
					 GET cFaxPadTes PICT "@!"

		   @nNroFil,nNroCol+00   SAY 'CELULAR  :';
					 GET cCelPadTes PICT "@!"

		   @nNroFil,nNroCol+26   SAY 'BIPER    :';
					 GET cBipPadTes PICT "@!"

		  @ nNroFil++,nNroCol+52 SAY 'FALLECIDO:';
					 GET cPadQepTes PICT '@!';
					 VALID lValSiNo(ROW(),COL()-1,;
					       @cPadQepTes,@lPadQepTes)
*----------------FIN ACTUALIZACION DE LOS DATOS DEL PADRE

*----------------ACTUALIZACION DE LOS DATOS DE LA MADRE
		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS MADRE:';
					 GET cApeMadTes PICT "@!S20"

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES MADRE:';
					 GET cNomMadTes PICT "@!S25"

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cMadNitTes PICT "@!"

		   @nNroFil  ,nNroCol+28 SAY 'TIPO:';
					 GET cMadTntTes PICT "@!";
					 VALID EMPTY(cMadTntTes) .OR.;
					 lValTipNit(ROW(),COL()-1,;
							  @cMadTntTes)

		   @nNroFil,nNroCol+38 SAY 'DE:';
					 GET cMadLugTes PICT "@!"

		   @nNroFil++,nNroCol+59 SAY 'TEL:';
					 GET cTelMadTes PICT "@!9"

		   @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					 GET cEmpMadTes PICT "@!"

		   @nNroFil++,nNroCol+38 SAY 'CARGO:';
					 GET cCarMadTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
				       GET cDirMadTes PICT "@!S45"

		   @nNroFil++,nNroCol+52 SAY 'BARRIO:';
					 GET cBarMadTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
				       GET cCiuMadTes PICT "@!S29"

		   @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					 GET cProMadTes PICT "@!"

		   @nNroFil  ,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiMadTes PICT "@X"

		   @nNroFil++,nNroCol+52 SAY 'FAX      :';
					 GET cFaxMadTes PICT "@!"

		   @nNroFil,nNroCol+00   SAY 'CELULAR  :';
					 GET cCelMadTes PICT "@!"

		   @nNroFil,nNroCol+26   SAY 'BIPER    :';
					 GET cBipMadTes PICT "@!"

		  @ nNroFil++,nNroCol+52 SAY 'FALLECIDA:';
					 GET cMadQepTes PICT '@!';
					 VALID lValSiNo(ROW(),COL()-1,;
					       @cMadQepTes,@lMadQepTes)
*----------------FIN ACTUALIZACION DE LOS DATOS DE LA MADRE

	    CASE nNroOpc == 3

*----------------LECTURA DEL PARENTESCO DEL ACUDIENTE
		   nNroFil := nFilInf+3

		   IF lPregunta('EL ACUDIENTE:'+ALLTRIM(cParAcuTes)+'.'+;
				'DESEA CAMBIAR EL ACUDIENTE? Si No')

		      nTipAcu := nLeeOpcion('ACUDIENTE: '+;
				'1<PADRE> 2<MADRE> 3<OTRO>?',3,'0')

		   ELSE

		      DO CASE
		      CASE 'PADRE' $ UPPER(cParAcuTes)
			   nTipAcu := 1

		      CASE 'MADRE' $ UPPER(cParAcuTes)
			   nTipAcu := 2

		      OTHERWISE

			   DO CASE
			   CASE nTipAcu == 1
				cParAcuTes := 'PADRE'
			   CASE nTipAcu == 2
				cParAcuTes := 'MADRE'
			   ENDCASE

		      ENDCASE

		   ENDIF

		   DO CASE
		   CASE nTipAcu == 1
			cParAcuTes := 'PADRE'
			cApeAcuTes := cApePadTes
			cNomAcuTes := cNomPadTes
			cAcuNitTes := cPadNitTes
			cAcuLugTes := cPadLugTes
			cAcuTntTes := cPadTntTes
			cDirAcuTes := cDirPadTes
			cBarAcuTes := cBarPadTes
			cCiuAcuTes := cCiuPadTes
			cProAcuTes := cProPadTes
			cEmpAcuTes := cEmpPadTes
			cCarAcuTes := cCarPadTes
			cTe1AcuTes := cTelPadTes
			cCelAcuTes := cCelPadTes
			cFaxAcuTes := cFaxPadTes
			cBipAcuTes := cBipPadTes
			cMaiAcuTes := cMaiPadTes
		      *ÀInformaci¢n del Padre

		   CASE nTipAcu == 2
			cParAcuTes := 'MADRE'
			cApeAcuTes := cApeMadTes
			cNomAcuTes := cNomMadTes
			cAcuNitTes := cMadNitTes
			cAcuLugTes := cMadLugTes
			cAcuTntTes := cMadTntTes
			cDirAcuTes := cDirMadTes
			cBarAcuTes := cBarMadTes
			cCiuAcuTes := cCiuMadTes
			cProAcuTes := cProMadTes
			cEmpAcuTes := cEmpMadTes
			cCarAcuTes := cCarMadTes
			cTe1AcuTes := cTelMadTes
			cCelAcuTes := cCelMadTes
			cFaxAcuTes := cFaxMadTes
			cBipAcuTes := cBipMadTes
			cMaiAcuTes := cMaiMadTes
		      *ÀInformaci¢n de la Madre
		   ENDCASE
*----------------FIN LECTURA DEL PARENTESCO DEL ACUDIENTE

*----------------ACTUALIZACION DE LOS DATOS DEL ACUDIENTE
		   IF nTipAcu == 3

		      nNroFil += 2

		      cParAcuTes = SUBS(cParAcuTes+SPACE(16),1,16)
		      @nNroFil++,nNroCol+00 SAY 'PARENTESCO DEL ACUDIENTE:';
					  GET cParAcuTes PICT "@!"

		      @nNroFil,nNroCol+00 SAY 'APELLIDOS ACUDIENTE:';
					  GET cApeAcuTes PICT "@!S16";
					  VALID !EMPTY(cApeAcuTes)

		      @nNroFil++,nNroCol+38 SAY 'NOMBRES ACUDIENTE:';
					    GET cNomAcuTes PICT "@!S21";
					    VALID !EMPTY(cNomAcuTes)

		      @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					    GET cAcuNitTes PICT "@!S11";
					    VALID !EMPTY(cAcuNitTes)

		      @nNroFil,nNroCol+23 SAY 'TIPO:';
					  GET cAcuTntTes PICT "@!";
					  VALID lValTipNit(ROW(),COL()-1,;
							   @cAcuTntTes)

		      @nNroFil,nNroCol+33 SAY 'DE:';
					  GET cAcuLugTes PICT "@!S12";
					  VALID !EMPTY(cAcuLugTes)

		      @nNroFil++,nNroCol+59 SAY 'TEL:';
					    GET cTe1AcuTes PICT "@!9"

		      @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					    GET cEmpAcuTes PICT "@!";
					    VALID !EMPTY(cEmpAcuTes)

		      @nNroFil++,nNroCol+38  SAY 'CARGO:';
					    GET cCarAcuTes PICT "@!";
					    VALID !EMPTY(cCarAcuTes)

		      @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					    GET cDirAcuTes PICT "@!S45";
					    VALID !EMPTY(cDirAcuTes)

		      @nNroFil++  ,nNroCol+52 SAY 'BARRIO:';
					      GET cBarAcuTes PICT "@!";
					      VALID !EMPTY(cBarAcuTes)

		      @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					    GET cCiuAcuTes PICT "@!S29";
					    VALID !EMPTY(cCiuAcuTes)

		      @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					    GET cProAcuTes PICT "@!" ;
					    VALID !EMPTY(cProAcuTes)

		      @nNroFil,nNroCol+00 SAY 'E-MAIL   :';
					    GET cMaiAcuTes PICT "@X"

		      @nNroFil++,nNroCol+52 SAY 'FAX      :';
					    GET cFaxAcuTes PICT "@!"

		      @nNroFil,nNroCol+00   SAY 'CELULAR  :';
					    GET cCelAcuTes PICT "@!"

		      @nNroFil++,nNroCol+38 SAY 'BIPER    :';
					    GET cBipAcuTes PICT "@!"
		   ENDIF
*----------------FIN ACTUALIZACION DE LOS DATOS DEL ACUDIENTE

	    ENDCASE
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
	    SELECT &cMaeAct
	    IF lGrabar
	       IF lRegLock(lShared,.F.)
		  DO CASE
		  CASE nNroOpc == 1

*----------------------GRABACION DE LA INFORMACION PERSONAL
			 REPL &cMaeAct->cLugNacEst WITH cLugNacTes
			 REPL &cMaeAct->dFecNacEst WITH dFecNacTes
			 REPL &cMaeAct->cDocNitEst WITH cDocNitTes
			 REPL &cMaeAct->cLugNitEst WITH cLugNitTes
			 REPL &cMaeAct->cTipNitEst WITH cTipNitTes
			 REPL &cMaeAct->lSexFemEst WITH lSexFemTes
			 REPL &cMaeAct->nEstratEst WITH nEstratTes
			 REPL &cMaeAct->cDireccEst WITH cDireccTes
			 REPL &cMaeAct->cBarrioEst WITH cBarrioTes
			 REPL &cMaeAct->cCiudadEst WITH cCiudadTes
			 REPL &cMaeAct->cTelefnEst WITH cTelefnTes
			 REPL &cMaeAct->cTelCelEst WITH cTelCelTes
			 REPL &cMaeAct->cMaiEstEst WITH LOWER(cMaiEstTes)
			 REPL &cMaeAct->cNomEpsEst WITH cNomEpsTes
			 REPL &cMaeAct->cGrupRhEst WITH cGrupRhTes

			 REPL &cMaeAct->cViveCoEst WITH cViveCoTes
			 REPL &cMaeAct->nNroHerEst WITH nNroHerTes
			 REPL &cMaeAct->cHerGruEst WITH cHerGruTes
			 REPL &cMaeAct->cLocaliEst WITH cLocaliTes
			 REPL &cMaeAct->cZonaDiEst WITH cZonaDiTes
*----------------------FIN GRABACION DE LA INFORMACION PERSONAL

		  CASE nNroOpc == 2

*----------------------GRABACION DE LA INFORMACION DE LOS PADRES
			 REPL &cMaeAct->cApePadEst WITH cApePadTes
			 REPL &cMaeAct->cNomPadEst WITH cNomPadTes
			 REPL &cMaeAct->lPadQepEst WITH lPadQepTes
			 REPL &cMaeAct->cPadNitEst WITH cPadNitTes
			 REPL &cMaeAct->cPadLugEst WITH cPadLugTes
			 REPL &cMaeAct->cPadTntEst WITH cPadTntTes
			 REPL &cMaeAct->cDirPadEst WITH cDirPadTes
			 REPL &cMaeAct->cBarPadEst WITH cBarPadTes
			 REPL &cMaeAct->cCiuPadEst WITH cCiuPadTes
			 REPL &cMaeAct->cProPadEst WITH cProPadTes
			 REPL &cMaeAct->cEmpPadEst WITH cEmpPadTes
			 REPL &cMaeAct->cCarPadEst WITH cCarPadTes
			 REPL &cMaeAct->cTelPadEst WITH cTelPadTes
			 REPL &cMaeAct->cCelPadEst WITH cCelPadTes
			 REPL &cMaeAct->cFaxPadEst WITH cFaxPadTes
			 REPL &cMaeAct->cBipPadEst WITH cBipPadTes
			 REPL &cMaeAct->cMaiPadEst WITH LOWER(cMaiPadTes)
		       *ÀGrabaci¢n de la Informaci¢n del Padre

			 REPL &cMaeAct->cApeMadEst WITH cApeMadTes
			 REPL &cMaeAct->cNomMadEst WITH cNomMadTes
			 REPL &cMaeAct->lMadQepEst WITH lMadQepTes
			 REPL &cMaeAct->cMadNitEst WITH cMadNitTes
			 REPL &cMaeAct->cMadLugEst WITH cMadLugTes
			 REPL &cMaeAct->cMadTntEst WITH cMadTntTes
			 REPL &cMaeAct->cDirMadEst WITH cDirMadTes
			 REPL &cMaeAct->cBarMadEst WITH cBarMadTes
			 REPL &cMaeAct->cCiuMadEst WITH cCiuMadTes
			 REPL &cMaeAct->cProMadEst WITH cProMadTes
			 REPL &cMaeAct->cEmpMadEst WITH cEmpMadTes
			 REPL &cMaeAct->cCarMadEst WITH cCarMadTes
			 REPL &cMaeAct->cTelMadEst WITH cTelMadTes
			 REPL &cMaeAct->cCelMadEst WITH cCelMadTes
			 REPL &cMaeAct->cFaxMadEst WITH cFaxMadTes
			 REPL &cMaeAct->cBipMadEst WITH cBipMadTes
			 REPL &cMaeAct->cMaiMadEst WITH LOWER(cMaiMadTes)
		       *ÀGrabaci¢n de la Informaci¢n de la Madre
*----------------------FIN GRABACION DE LA INFORMACION DE LOS PADRES

		  CASE nNroOpc == 3

*----------------------GRABACION DE LA INFORMACION DEL ACUDIENTE
			 REPL &cMaeAct->cApeAcuEst WITH cApeAcuTes
			 REPL &cMaeAct->cNomAcuEst WITH cNomAcuTes
			 REPL &cMaeAct->cAcuNitEst WITH cAcuNitTes
			 REPL &cMaeAct->cAcuLugEst WITH cAcuLugTes
			 REPL &cMaeAct->cAcuTntEst WITH cAcuTntTes
			 REPL &cMaeAct->cDirAcuEst WITH cDirAcuTes
			 REPL &cMaeAct->cBarAcuEst WITH cBarAcuTes
			 REPL &cMaeAct->cCiuAcuEst WITH cCiuAcuTes
			 REPL &cMaeAct->cProAcuEst WITH cProAcuTes
			 REPL &cMaeAct->cEmpAcuEst WITH cEmpAcuTes
			 REPL &cMaeAct->cCarAcuEst WITH cCarAcuTes
			 REPL &cMaeAct->cTe1AcuEst WITH cTe1AcuTes
			 REPL &cMaeAct->cTe2AcuEst WITH cTe2AcuTes
			 REPL &cMaeAct->cParAcuEst WITH cParAcuTes
			 REPL &cMaeAct->cCelAcuEst WITH cCelAcuTes
			 REPL &cMaeAct->cFaxAcuEst WITH cFaxAcuTes
			 REPL &cMaeAct->cBipAcuEst WITH cBipAcuTes
			 REPL &cMaeAct->cMaiAcuEst WITH LOWER(cMaiAcuTes)
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
**********FIN GRABACION DE LOS DATOS DEL CANDIDATO

**********GRABACION DE LA PROCEDENCIA DEL ESTUDIANTE
	    IF lPregunta('DESEA GRABAR LOS COLEGIOS DE '+;
			 'PROCEDENCIA DEL ESTUDIANTE? No Si')
	       lProceEst(lShared,nFilInf,nColInf,cCodEst,;
			 cNombre,cCodGru,cMaeAct)
	    END
	    EXIT
**********FIN GRABACION DE LA PROCEDENCIA DEL ESTUDIANTE

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(nTipCur)
       SET ESCAPE OFF
       RETURN lGrabar
*>>>>FIN LECTURA Y GRABACION DE LA HOJA DE VIDA

/*************************************************************************
* TITULO..: GRABACION DE LA PROCEDENCIA DEL ESTUDIANTE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/96 MIE A
       Colombia, Bucaramanga        INICIO: 10:20 PM   SEP 04/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de admisiones.

2- El archivo debe estar ubicado en el registro del Estudiante y debe estar
   bloqueado

3- Graba la procedencia del Estudiante

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lProceEst(lShared,nFilInf,nColInf,cCodEst,;
		   cNombre,cCodGru,cNalias,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila de lectura
       nColInf                              // Columna de lectura
       cCodEst			            // C¢digo del Estudiante
       cCodGru                              // C¢digo del grupo
       oBrowse			            // Browse de Consulta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL nOpcion := 0                   // N£mero de Opci¢n

       LOCAL       i := 0                   // Contador
       LOCAL aNroCol := {}                  // N£mero de Columnas
       LOCAL aProced[17,4]                  // Procendencia del Estudiante
       LOCAL GetList    := {}               // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF !EMPTY(oBrowse)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  SET CURSOR ON
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,'POR FAVOR INGRESE LA PROCEDENCIA DEL ESTUDIANTE',22,'°')
       nNroCol := nColInf
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+cCodEst
       @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+cNombre
       @ nNroFil,nNroCol+65 SAY 'CURSO : '+cCodGru
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       SET ESCAPE ON
       SELECT &cNalias
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES TEMPORALES
	    IF lGrabar

	       aProced[1,1] := SUBS(&cNalias->cCole01Est,01,04)  // A¤o
	       aProced[1,2] := SUBS(&cNalias->cCole01Est,05,10)  // Nivel
	       aProced[1,3] := SUBS(&cNalias->cCole01Est,15,40)  // Colegio
	       aProced[1,4] := SUBS(&cNalias->cCole01Est,55,20)  // Ciudad

	       aProced[2,1] := SUBS(&cNalias->cCole02Est,01,04)  // A¤o
	       aProced[2,2] := SUBS(&cNalias->cCole02Est,05,10)  // Nivel
	       aProced[2,3] := SUBS(&cNalias->cCole02Est,15,40)  // Colegio
	       aProced[2,4] := SUBS(&cNalias->cCole02Est,55,20)  // Ciudad

	       aProced[3,1] := SUBS(&cNalias->cCole03Est,01,04)  // A¤o
	       aProced[3,2] := SUBS(&cNalias->cCole03Est,05,10)  // Nivel
	       aProced[3,3] := SUBS(&cNalias->cCole03Est,15,40)  // Colegio
	       aProced[3,4] := SUBS(&cNalias->cCole03Est,55,20)  // Ciudad

	       aProced[4,1] := SUBS(&cNalias->cCole04Est,01,04)  // A¤o
	       aProced[4,2] := SUBS(&cNalias->cCole04Est,05,10)  // Nivel
	       aProced[4,3] := SUBS(&cNalias->cCole04Est,15,40)  // Colegio
	       aProced[4,4] := SUBS(&cNalias->cCole04Est,55,20)  // Ciudad

	       aProced[5,1] := SUBS(&cNalias->cCole05Est,01,04)  // A¤o
	       aProced[5,2] := SUBS(&cNalias->cCole05Est,05,10)  // Nivel
	       aProced[5,3] := SUBS(&cNalias->cCole05Est,15,40)  // Colegio
	       aProced[5,4] := SUBS(&cNalias->cCole05Est,55,20)  // Ciudad

	       aProced[6,1] := SUBS(&cNalias->cCole06Est,01,04)  // A¤o
	       aProced[6,2] := SUBS(&cNalias->cCole06Est,05,10)  // Nivel
	       aProced[6,3] := SUBS(&cNalias->cCole06Est,15,40)  // Colegio
	       aProced[6,4] := SUBS(&cNalias->cCole06Est,55,20)  // Ciudad

	       aProced[7,1] := SUBS(&cNalias->cCole07Est,01,04)  // A¤o
	       aProced[7,2] := SUBS(&cNalias->cCole07Est,05,10)  // Nivel
	       aProced[7,3] := SUBS(&cNalias->cCole07Est,15,40)  // Colegio
	       aProced[7,4] := SUBS(&cNalias->cCole07Est,55,20)  // Ciudad

	       aProced[8,1] := SUBS(&cNalias->cCole08Est,01,04)  // A¤o
	       aProced[8,2] := SUBS(&cNalias->cCole08Est,05,10)  // Nivel
	       aProced[8,3] := SUBS(&cNalias->cCole08Est,15,40)  // Colegio
	       aProced[8,4] := SUBS(&cNalias->cCole08Est,55,20)  // Ciudad

	       aProced[9,1] := SUBS(&cNalias->cCole09Est,01,04)  // A¤o
	       aProced[9,2] := SUBS(&cNalias->cCole09Est,05,10)  // Nivel
	       aProced[9,3] := SUBS(&cNalias->cCole09Est,15,40)  // Colegio
	       aProced[9,4] := SUBS(&cNalias->cCole09Est,55,20)  // Ciudad

	       aProced[10,1] := SUBS(&cNalias->cCole10Est,01,04)  // A¤o
	       aProced[10,2] := SUBS(&cNalias->cCole10Est,05,10)  // Nivel
	       aProced[10,3] := SUBS(&cNalias->cCole10Est,15,40)  // Colegio
	       aProced[10,4] := SUBS(&cNalias->cCole10Est,55,20)  // Ciudad

	       aProced[11,1] := SUBS(&cNalias->cCole11Est,01,04)  // A¤o
	       aProced[11,2] := SUBS(&cNalias->cCole11Est,05,10)  // Nivel
	       aProced[11,3] := SUBS(&cNalias->cCole11Est,15,40)  // Colegio
	       aProced[11,4] := SUBS(&cNalias->cCole11Est,55,20)  // Ciudad

	       aProced[12,1] := SUBS(&cNalias->cCole12Est,01,04)  // A¤o
	       aProced[12,2] := SUBS(&cNalias->cCole12Est,05,10)  // Nivel
	       aProced[12,3] := SUBS(&cNalias->cCole12Est,15,40)  // Colegio
	       aProced[12,4] := SUBS(&cNalias->cCole12Est,55,20)  // Ciudad

	       aProced[13,1] := SUBS(&cNalias->cCole13Est,01,04)  // A¤o
	       aProced[13,2] := SUBS(&cNalias->cCole13Est,05,10)  // Nivel
	       aProced[13,3] := SUBS(&cNalias->cCole13Est,15,40)  // Colegio
	       aProced[13,4] := SUBS(&cNalias->cCole13Est,55,20)  // Ciudad

	       aProced[14,1] := SUBS(&cNalias->cCole14Est,01,04)  // A¤o
	       aProced[14,2] := SUBS(&cNalias->cCole14Est,05,10)  // Nivel
	       aProced[14,3] := SUBS(&cNalias->cCole14Est,15,40)  // Colegio
	       aProced[14,4] := SUBS(&cNalias->cCole14Est,55,20)  // Ciudad

	       aProced[15,1] := SUBS(&cNalias->cCole15Est,01,04)  // A¤o
	       aProced[15,2] := SUBS(&cNalias->cCole15Est,05,10)  // Nivel
	       aProced[15,3] := SUBS(&cNalias->cCole15Est,15,40)  // Colegio
	       aProced[15,4] := SUBS(&cNalias->cCole15Est,55,20)  // Ciudad

	       aProced[16,1] := SUBS(&cNalias->cCole16Est,01,04)  // A¤o
	       aProced[16,2] := SUBS(&cNalias->cCole16Est,05,10)  // Nivel
	       aProced[16,3] := SUBS(&cNalias->cCole16Est,15,40)  // Colegio
	       aProced[16,4] := SUBS(&cNalias->cCole16Est,55,20)  // Ciudad

	       aProced[17,1] := SUBS(&cNalias->cCole00Est,01,04)  // A¤o
	       aProced[17,2] := SUBS(&cNalias->cCole00Est,05,10)  // Nivel
	       aProced[17,3] := SUBS(&cNalias->cCole00Est,15,40)  // Colegio
	       aProced[17,4] := SUBS(&cNalias->cCole00Est,55,20)  // Ciudad

	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES TEMPORALES

**********ANALISIS DE DECISION
	    nOpcion := nLeeOpcion('1<PREESCOLAR> 2<PRIMARIA> '+;
				  '3<BACHILLERATO> 4<ABANDONAR>?',4,'0')
	    IF nOpcion == 4
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION


**********IMPRESION DE LOS TITULOS DE ENCABEZADO
	    aNroCol := {01,06,17,58}
	    nNroFil := nFilInf+4
	    @ ++nNroFil,aNroCol[1] SAY 'A¥O'
	    @ nNroFil  ,aNroCol[2] SAY 'NIVEL'
	    @ nNroFil  ,aNroCol[3] SAY 'INSTITUCION'
	    @ nNroFil++,aNroCol[4] SAY 'CIUDAD'
**********FIN IMPRESION DE LOS TITULOS DE ENCABEZADO

**********LECTURA DEL PREESCOLAR
	    IF nOpcion == 1
	       nNroFil := nFilInf+6
	       @nNroFil,nNroCol+00   SAY 'PREESCOLAR:'
	       FOR i := 12 TO 17
		   @ ++nNroFil,aNroCol[1] GET aProced[i,1] PICT "@!"
		   @ nNroFil  ,aNroCol[2] GET aProced[i,2] PICT "@!"
		   @ nNroFil  ,aNroCol[3] GET aProced[i,3] PICT "@!"
		   @ nNroFil  ,aNroCol[4] GET aProced[i,4] PICT "@!"
	       ENDFOR
	    ENDIF
**********FIN LECTURA DE LOS DATOS DEL CANDIDATO

**********LECTURA DE LA PRIMARIA
	    IF nOpcion == 2
	       nNroFil := nFilInf+6
	       @nNroFil,nNroCol+00 SAY 'PRIMARIA:'
	       FOR i := 1 TO 5
		   @ ++nNroFil,aNroCol[1] GET aProced[i,1] PICT "@!"
		   @ nNroFil  ,aNroCol[2] GET aProced[i,2] PICT "@!"
		   @ nNroFil  ,aNroCol[3] GET aProced[i,3] PICT "@!"
		   @ nNroFil  ,aNroCol[4] GET aProced[i,4] PICT "@!"
	       ENDFOR
	    ENDIF
**********FIN LECTURA DE LA PRIMARIA

**********LECTURA DEL BACHILLERATO
	    IF nOpcion == 3
	       nNroFil := nFilInf+6
	       @nNroFil,nNroCol+00 SAY 'BACHILLERATO:'
	       FOR i := 6 TO 11
		   @ ++nNroFil,aNroCol[1] GET aProced[i,1] PICT "@!"
		   @ nNroFil  ,aNroCol[2] GET aProced[i,2] PICT "@!"
		   @ nNroFil  ,aNroCol[3] GET aProced[i,3] PICT "@!"
		   @ nNroFil  ,aNroCol[4] GET aProced[i,4] PICT "@!"
	       ENDFOR
	    ENDIF
	    READ
**********FIN LECTURA DEL BACHILLERATO

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
	       SELECT &cNalias
	       IF lRegLock(lShared,.F.)

		  REPL &cNalias->cCole01Est WITH aProced[1,1]+aProced[1,2]+;
						 aProced[1,3]+aProced[1,4]

		  REPL &cNalias->cCole02Est WITH aProced[2,1]+aProced[2,2]+;
						 aProced[2,3]+aProced[2,4]

		  REPL &cNalias->cCole03Est WITH aProced[3,1]+aProced[3,2]+;
						 aProced[3,3]+aProced[3,4]

		  REPL &cNalias->cCole04Est WITH aProced[4,1]+aProced[4,2]+;
						 aProced[4,3]+aProced[4,4]

		  REPL &cNalias->cCole05Est WITH aProced[5,1]+aProced[5,2]+;
						 aProced[5,3]+aProced[5,4]
		*ÀPrimaria

		  REPL &cNalias->cCole06Est WITH aProced[6,1]+aProced[6,2]+;
						 aProced[6,3]+aProced[6,4]

		  REPL &cNalias->cCole07Est WITH aProced[7,1]+aProced[7,2]+;
						 aProced[7,3]+aProced[7,4]

		  REPL &cNalias->cCole08Est WITH aProced[8,1]+aProced[8,2]+;
						 aProced[8,3]+aProced[8,4]

		  REPL &cNalias->cCole09Est WITH aProced[9,1]+aProced[9,2]+;
						 aProced[9,3]+aProced[9,4]

		  REPL &cNalias->cCole10Est WITH aProced[10,1]+aProced[10,2]+;
						 aProced[10,3]+aProced[10,4]

		  REPL &cNalias->cCole11Est WITH aProced[11,1]+aProced[11,2]+;
						 aProced[11,3]+aProced[11,4]
		*ÀBachillerato

		  REPL &cNalias->cCole12Est WITH aProced[12,1]+aProced[12,2]+;
						 aProced[12,3]+aProced[12,4]

		  REPL &cNalias->cCole13Est WITH aProced[13,1]+aProced[13,2]+;
						 aProced[13,3]+aProced[13,4]

		  REPL &cNalias->cCole14Est WITH aProced[14,1]+aProced[14,2]+;
						 aProced[14,3]+aProced[14,4]

		  REPL &cNalias->cCole15Est WITH aProced[15,1]+aProced[15,2]+;
						 aProced[15,3]+aProced[15,4]

		  REPL &cNalias->cCole16Est WITH aProced[16,1]+aProced[16,2]+;
						 aProced[16,3]+aProced[16,4]

		  REPL &cNalias->cCole00Est WITH aProced[17,1]+aProced[17,2]+;
						 aProced[17,3]+aProced[17,4]
		*ÀPreescolar

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
* TITULO..: GRABACION DE LOS EMAILS DEL ESTUDIANTE                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       INICIO: 11:50 AM  MAR 16/2009 LUN
       Colombia, Bucaramanga        FINAL : 02:00 PM  MAR 16/2009 LUN

OBJETIVOS:

1- Debe estar en uso el archivo de admisiones.

2- El archivo debe estar ubicado en el registro del Estudiante y debe estar
   bloqueado

3- Graba la procedencia del Estudiante

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lEmailsEst(lShared,nFilInf,nColInf,cCodEst,;
		    cNombre,cCodGru,cMaeAct,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila de lectura
       nColInf                              // Columna de lectura
       cCodEst			            // C¢digo del Estudiante
       cCodGru                              // C¢digo del grupo
       oBrowse			            // Browse de Consulta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero de Registro

       LOCAL       i := 0                   // Contador
       LOCAL aNroCol := {}                  // N£mero de Columnas

       LOCAL cTelefnTes := ''		    // Telefono de la residencia
       LOCAL cTelCelTes := ''               //*Telefono celular del Estudiante
       LOCAL cMaiEstTes := ''               // E-MAIL de la Casa o del Estudiante

       LOCAL cTelPadTes := ''               // Telefono del padre
       LOCAL cCelPadTes := ''               //*Telefono celular del Padre
       LOCAL cMaiPadTes := ''               // E-MAIL del Padre
       LOCAL cCelMadTes := ''               //*Telefono celular de la Madre
       LOCAL cMaiMadTes := ''               // E-MAIL de la Madre

       LOCAL GetList    := {}               // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF !EMPTY(oBrowse)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  SET CURSOR ON
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,'POR FAVOR INGRESE LA PROCEDENCIA DEL ESTUDIANTE',22,'°')
       nNroCol := nColInf
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+cCodEst
       @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+cNombre
       @ nNroFil,nNroCol+65 SAY 'CURSO : '+cCodGru
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       SET ESCAPE ON
       SELECT &cMaeAct
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES TANOORALES
	    IF lGrabar

	       cTelefnTes := &cMaeAct->cTelefnEst

	       cTelCelTes := &cMaeAct->cTelCelEst
	       cMaiEstTes := &cMaeAct->cMaiEstEst

	       cCelPadTes := &cMaeAct->cCelPadEst
	       cMaiPadTes := &cMaeAct->cMaiPadEst

	       cCelMadTes := &cMaeAct->cCelMadEst
	       cMaiMadTes := &cMaeAct->cMaiMadEst

	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES TANOORALES

**********INFORMACION DE CONTACTO
	    nNroFil := nFilInf+6

	    @nNroFil++,nNroCol+00 SAY 'INFORMACION DEL ESTUDIANTE:'
	    @nNroFil++,nNroCol+00 SAY 'CEL DEL ESTUDIANTE   :';
				  GET cTelCelTes PICT "@X"

	    @nNroFil++,nNroCol+00 SAY 'E-MAIL DEL ESTUDIANTE:';
				  GET cMaiEstTes PICT "@X"

	    @nNroFil++,nNroCol+00 SAY 'TEL CASA             :';
				  GET cTelefnTes PICT "@X"

	    nNroFil += 1
	    @nNroFil++,nNroCol+00 SAY 'INFORMACION DE PADRE:'
	    @nNroFil++,nNroCol+00 SAY 'CEL PADRE           :';
				  GET cCelPadTes PICT "@X"

	    @nNroFil,nNroCol+00   SAY 'E-MAIL DEL PADRE    :';
				  GET cMaiPadTes PICT "@X"

	    nNroFil += 2
	    @nNroFil++,nNroCol+00 SAY 'INFORMACION DE LA MADRE:'
	    @nNroFil++,nNroCol+00 SAY 'CELULAR DE LA PADRE  :';
				  GET cCelMadTes PICT "@X"

	    @nNroFil,nNroCol+00   SAY 'E-MAIL DE LA MADRE   :';
				  GET cMaiMadTes PICT "@X"
	    READ
**********INFORMACION DE CONTACTO

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
	       SELECT &cMaeAct
	       IF lRegLock(lShared,.F.)

		  REPL &cMaeAct->&cMaeAct->cTelefnEst WITH cTelefnTes

		  REPL &cMaeAct->&cMaeAct->cTelCelEst WITH cTelCelTes
		  REPL &cMaeAct->&cMaeAct->cMaiEstEst WITH LOWER(cMaiEstTes)

		  REPL &cMaeAct->&cMaeAct->cCelPadEst WITH cCelPadTes
		  REPL &cMaeAct->&cMaeAct->cMaiPadEst WITH LOWER(cMaiPadTes)

		  REPL &cMaeAct->&cMaeAct->cCelMadEst WITH cCelMadTes
		  REPL &cMaeAct->&cMaeAct->cMaiMadEst WITH LOWER(cMaiMadTes)

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
* TITULO..: FORMATO DE ACTUALIZACION DE LA INFORMACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2001 MAR A
       Colombia, Bucaramanga        INICIO: 05:25 PM   JUN 05/2001 MAR

OBJETIVOS:

1- Imprime el Formato para la Actualizaci¢n de la Informaci¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FrmActInf1(cMaeAct,nPrnOrd)

*>>>>PARAMETROS DE LA FUNCION
/*     cMaeAct			            // Maestro Actual
       nPrnOrd                              // Tipo de Orden de Matr¡cula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       cSavPan := SAVESCREEN(0,0,24,79)

       DO WHILE !Printer_on(); ENDDO

       @ PROW(),00 SAY INICIALIZA+GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMATO DE ACTUALIZACION
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'FORMATO DE ACTUALIZACION DE DATOS'
       @ PROW()+3,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := RTRIM(&cMaeAct->cApelliEst)+' '+;
		  RTRIM(&cMaeAct->cNombreEst)+'. '+;
		  'CODIGO: '+&cMaeAct->cCodigoEst+' '+;
		  'CURSO:'+&cMaeAct->cCodigoGru
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW(),00 SAY CONDEN_ON
       @ PROW()+2,02 SAY 'Se¤or Padre de Familia le solicitamos el favor '+;
			 'de revisar y corregir la informaci¢n de su '+;
			 'hijo(a) con el objectivo de mantener actualizado '+;
			 'el Directorio'
       @ PROW()+1,02 SAY 'de los Estudiantes. Favor confronte y solo haga '+;
			 'los cambios necesarios. Muchas Gracias.'
       @ PROW(),00 SAY CONDEN_OF

       LineaPrn({'NACIDO EN: ',&cMaeAct->cLugNacEst+' FECHA: '+;
		  cFecha(&cMaeAct->dFecNacEst)},2)

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+1,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ',&cMaeAct->cTipNitEst+SPACE(01),;
		 'No' ,cLenSpace(&cMaeAct->cDocNitEst,30),;
		 'DE' ,cLenSpace(&cMaeAct->cLugNitEst,31)})

       LineaPrn({'              : ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDireccEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarrioEst,21)})
       LineaPrn({'          ',REPL('_',49),'       ',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiudadEst,39),;
		 'TELEFONO:',cLenSpace(&cMaeAct->cTelefnEst,32)})
       LineaPrn({'       ',REPL('_',39),'         ',REPL('_',32)})
       LineaPrn({'E-MAIL DEL ESTUDIANTE:',cLenSpace(&cMaeAct->cMaiEstEst,39)})
       LineaPrn({'                     :',REPL('_',40)})


       LineaPrn({'APELLIDOS PADRE:',cLenSpace(&cMaeAct->cApePadEst,30),;
		 'NOMBRES PADRE:',cLenSpace(&cMaeAct->cNomPadEst,27)},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cPadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cPadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cPadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelPadEst,13)})

       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpPadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarPadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirPadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarPadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuPadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProPadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})
       LineaPrn({'E-MAIL DEL PADRE:',cLenSpace(&cMaeAct->cMaiPadEst,39)})
       LineaPrn({'                :',REPL('_',40)})


       LineaPrn({'APELLIDOS MADRE:',cLenSpace(&cMaeAct->cApeMadEst,30),;
		 'NOMBRES MADRE:',&cMaeAct->cNomMadEst},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cMadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cMadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cMadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelMadEst,13)})
       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpMadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarMadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirMadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarMadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuMadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProMadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL DE LA MADRE:',cLenSpace(&cMaeAct->cMaiMadEst,39)})
       LineaPrn({'                  :',REPL('_',40)})

       LineaPrn({'APELLIDOS ACUDIENTE:',cLenSpace(&cMaeAct->cApeAcuEst,26),;
		 'NOMBRES ACUDIENTE:',cLenSpace(&cMaeAct->cNomAcuEst,23)},2)
       LineaPrn({'                    ',REPL('_',26),;
		 '                  ',REPL('_',23)},)

       LineaPrn({'IDENTI: '+&cMaeAct->cAcuTntEst+;
		 ' No.:',cLenSpace(&cMaeAct->cAcuNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cAcuLugEst,19),;
		 'PARENTESCO:',cLenSpace(&cMaeAct->cParAcuEst,14)})
       LineaPrn({'        ___'+;
		 '     ',REPL('_',21),;
		 '  :',REPL('_',19),;
		 '          :',REPL('_',14)})

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirAcuEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarAcuEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuAcuEst,31),;
		 'TEL CASA:',cLenSpace(&cMaeAct->cTe1AcuEst,15),;
		 'TEL OFI:',cLenSpace(&cMaeAct->cTe2AcuEst,15)})
       LineaPrn({'      :',REPL('_',31),;
		 '        :',REPL('_',15),;
		 '       :',REPL('_',15)})
       LineaPrn({'E-MAIL DEL ACUDIENTE:',cLenSpace(&cMaeAct->cMaiAcuEst,39)})
       LineaPrn({'                    :',REPL('_',40)})

       EJECT
       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMATO DE ACTUALIZACION

FUNCTION cLenSpace(cTxtTem,nLenSpa)
RETURN SUBS(cTxtTem+SPACE(nLenSpa),1,nLenSpa)

/*************************************************************************
* TITULO..: FORMATO DE ACTUALIZACION DE LA INFORMACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2001 MAR A
       Colombia, Bucaramanga        INICIO: 05:25 PM   JUN 05/2001 MAR

OBJETIVOS:

1- Imprime el Formato para la Actualizaci¢n de la Informaci¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FrmActInf2(cMaeAct,cCodIso)

*>>>>PARAMETROS DE LA FUNCION
/*     cMaeAct			            // Maestro Actual
       cCodIso                              // C¢digo del Iso */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       cSavPan := SAVESCREEN(0,0,24,79)

       DO WHILE !Printer_on(); ENDDO

       @ PROW(),00 SAY INICIALIZA+GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*cCodIso := 'FOR-AM-014 08/08/2006 V.A'
*cCodIso := 'FOR-AM-014 04/09/2007 V.B'
*cCodIso := ''
*Ya se encuentra configurado por gestion documental

*>>>>IMPRESION DEL FORMATO DE ACTUALIZACION
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'FORMATO DE ACTUALIZACION DE DATOS'
       @ PROW()+3,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
		     RTRIM(&cMaeAct->cNombreEst)

       cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)

       cTxtPrn := cNombreTes+'. '+;
		  'CODIGO: '+&cMaeAct->cCodigoEst+' '+;
		  'CURSO:'+&cMaeAct->cCodigoGru+SPACE(06)+cCodIso
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW(),00 SAY CONDEN_ON
/*
       @ PROW()+2,02 SAY 'Se¤or Padre de Familia le solicitamos el favor '+;
			 'de revisar y corregir la informaci¢n de su '+;
			 'hijo(a) con el objectivo de mantener actualizado '+;
			 'el Directorio'
       @ PROW()+1,02 SAY 'de los Estudiantes. Favor confronte y solo haga '+;
			 'los cambios necesarios. Muchas Gracias.'
*/
       @ PROW()+1,02 SAY 'Se¤or Padre de Familia: favor '+;
			 'revisar y corregir la sgte informaci¢n '+;
			 'con el objetivo de mantener actualizado '+;
			 'el Directorio de los estudiantes. '
/*
       @ PROW()+1,02 SAY 'de los Estudiantes. Favor confronte y solo haga '+;
			 'los cambios necesarios. Muchas Gracias.'
*/
       @ PROW(),00 SAY CONDEN_OF

       LineaPrn({'NACIDO EN: ',&cMaeAct->cLugNacEst+' FECHA: '+;
		  cFecha(&cMaeAct->dFecNacEst)},2)

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+1,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ',&cMaeAct->cTipNitEst+SPACE(01),;
		 'No' ,cLenSpace(&cMaeAct->cDocNitEst,30),;
		 'DE' ,cLenSpace(&cMaeAct->cLugNitEst,31)})

       LineaPrn({'              : ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDireccEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarrioEst,21)})
       LineaPrn({'          ',REPL('_',49),'       ',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiudadEst,39),;
		 'TELEFONO:',cLenSpace(&cMaeAct->cTelefnEst,32)})
       LineaPrn({'       ',REPL('_',39),'         ',REPL('_',32)})



       LineaPrn({'EPS:',cLenSpace(&cMaeAct->cNomEpsEst,39),;
		 ' GRUPO RH:',cLenSpace(&cMaeAct->cGrupRhEst,32)})
       LineaPrn({'   :',REPL('_',40),;
		 '        :',REPL('_',17)})


       LineaPrn({'APELLIDOS PADRE:',cLenSpace(&cMaeAct->cApePadEst,30),;
		 'NOMBRES PADRE:',cLenSpace(&cMaeAct->cNomPadEst,27)},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cPadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cPadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cPadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelPadEst,13)})

       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpPadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarPadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirPadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarPadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuPadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProPadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL:',cLenSpace(&cMaeAct->cMaiPadEst,20),;
		 ' FAX:',cLenSpace(&cMaeAct->cFaxPadEst,16),;
		 'CELULAR:',cLenSpace(&cMaeAct->cCelPadEst,16),;
		 'BIPER:',cLenSpace(&cMaeAct->cBipPadEst,16)})
       LineaPrn({'      :',REPL('_',20),;
		 '     ',REPL('_',16),;
		 '       ',REPL('_',16),;
		 '      ',REPL('_',06)})

       LineaPrn({'APELLIDOS MADRE:',cLenSpace(&cMaeAct->cApeMadEst,30),;
		 'NOMBRES MADRE:',&cMaeAct->cNomMadEst},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cMadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cMadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cMadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelMadEst,13)})
       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpMadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarMadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirMadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarMadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuMadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProMadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL:',cLenSpace(&cMaeAct->cMaiMadEst,20),;
		 ' FAX:',cLenSpace(&cMaeAct->cFaxMadEst,16),;
		 'CELULAR:',cLenSpace(&cMaeAct->cCelMadEst,16),;
		 'BIPER:',cLenSpace(&cMaeAct->cBipMadEst,16)})
       LineaPrn({'      :',REPL('_',20),;
		 '     ',REPL('_',16),;
		 '       ',REPL('_',16),;
		 '      ',REPL('_',06)})


       LineaPrn({'APELLIDOS ACUDIENTE:',cLenSpace(&cMaeAct->cApeAcuEst,26),;
		 'NOMBRES ACUDIENTE:',cLenSpace(&cMaeAct->cNomAcuEst,23)},2)
       LineaPrn({'                    ',REPL('_',26),;
		 '                  ',REPL('_',23)},)

       LineaPrn({'IDENTI: '+&cMaeAct->cAcuTntEst+;
		 ' No.:',cLenSpace(&cMaeAct->cAcuNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cAcuLugEst,19),;
		 'PARENTESCO:',cLenSpace(&cMaeAct->cParAcuEst,14)})
       LineaPrn({'        ___'+;
		 '     ',REPL('_',21),;
		 '  :',REPL('_',19),;
		 '          :',REPL('_',14)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpAcuEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarAcuEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirAcuEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarAcuEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuAcuEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProAcuEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL:',cLenSpace(&cMaeAct->cMaiAcuEst,20),;
		 ' TEL:',cLenSpace(&cMaeAct->cFaxAcuEst,16),;
		 'CELULAR:',cLenSpace(&cMaeAct->cCelAcuEst,16),;
		 'BIPER:',cLenSpace(&cMaeAct->cBipAcuEst,16)})
       LineaPrn({'      :',REPL('_',20),;
		 '     ',REPL('_',16),;
		 '       ',REPL('_',16),;
		 '      ',REPL('_',06)})


       LineaPrn({'DESEA CONTINUAR EN LA INSTITUCION? SI:__ NO:__'},2)
       LineaPrn({'FIRMA:',REPL('_',40)})

       EJECT
       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMATO DE ACTUALIZACION

/*************************************************************************
* TITULO..: FORMATO DE ACTUALIZACION DE LA INFORMACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 27/2004 LUN A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 27/2004 LUN

OBJETIVOS:

1- Imprime el Formato para la Actualizaci¢n de la Informaci¢n solicitud
   colegio 2 Bogota con promoci¢n al siguiente grado.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FrmActInf3(cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cMaeAct			            // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL nSgtNiv := 0                   // Siguiente Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       cSavPan := SAVESCREEN(0,0,24,79)

       DO WHILE !Printer_on(); ENDDO

       @ PROW(),00 SAY INICIALIZA+GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMATO DE ACTUALIZACION
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SEPARACION DE CUPO'
       @ PROW()+1,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       nSgtNiv := nSgteNiv(VAL(SUBS(&cMaeAct->cCodigoGru,1,2)),;
		      &cMaeAct->lRepiteEst)

       cTxtPrn := RTRIM(&cMaeAct->cApelliEst)+' '+;
		  RTRIM(&cMaeAct->cNombreEst)+'. '+;
		  'CODIGO: '+&cMaeAct->cCodigoEst+' '+;
		  'NIVEL:'+cNomNiv(nSgtNiv)
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW(),00 SAY CONDEN_ON
       @ PROW()+2,02 SAY 'Se¤or Rector: Con el diligenciamiento de este '+;
			 'formato estoy solicitando cupo para mi hijo(a) '+;
			 'en el pr¢ximo a¤o lectivo, y acepto que esta '
       @ PROW()+1,02 SAY 'solicitud no implica mi promoci¢n '+;
			 'acad‚mica, mi obligatoriedad de matr¡cula '+;
			 'por parte del Colegio.'
       @ PROW(),00 SAY CONDEN_OF

       LineaPrn({'NACIDO EN: ',&cMaeAct->cLugNacEst+' FECHA: '+;
		  cFecha(&cMaeAct->dFecNacEst)},2)

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+1,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ',&cMaeAct->cTipNitEst+SPACE(01),;
		 'No' ,cLenSpace(&cMaeAct->cDocNitEst,30),;
		 'DE' ,cLenSpace(&cMaeAct->cLugNitEst,31)})

       LineaPrn({'              : ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDireccEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarrioEst,21)})
       LineaPrn({'          ',REPL('_',49),'       ',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiudadEst,39),;
		 'TELEFONO:',cLenSpace(&cMaeAct->cTelefnEst,32)})
       LineaPrn({'       ',REPL('_',39),'         ',REPL('_',32)})
       LineaPrn({'E-MAIL DEL ESTUDIANTE:',cLenSpace(&cMaeAct->cMaiEstEst,39)})
       LineaPrn({'                     :',REPL('_',40)})


       LineaPrn({'APELLIDOS PADRE:',cLenSpace(&cMaeAct->cApePadEst,30),;
		 'NOMBRES PADRE:',cLenSpace(&cMaeAct->cNomPadEst,27)},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cPadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cPadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cPadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelPadEst,13)})

       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpPadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarPadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirPadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarPadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuPadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProPadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})
       LineaPrn({'E-MAIL DEL PADRE:',cLenSpace(&cMaeAct->cMaiPadEst,39)})
       LineaPrn({'                :',REPL('_',40)})


       LineaPrn({'APELLIDOS MADRE:',cLenSpace(&cMaeAct->cApeMadEst,30),;
		 'NOMBRES MADRE:',&cMaeAct->cNomMadEst},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cMadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cMadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cMadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelMadEst,13)})
       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpMadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarMadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirMadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarMadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuMadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProMadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL DE LA MADRE:',cLenSpace(&cMaeAct->cMaiMadEst,39)})
       LineaPrn({'                  :',REPL('_',40)})

       LineaPrn({'APELLIDOS ACUDIENTE:',cLenSpace(&cMaeAct->cApeAcuEst,26),;
		 'NOMBRES ACUDIENTE:',cLenSpace(&cMaeAct->cNomAcuEst,23)},2)
       LineaPrn({'                    ',REPL('_',26),;
		 '                  ',REPL('_',23)},)

       LineaPrn({'IDENTI: '+&cMaeAct->cAcuTntEst+;
		 ' No.:',cLenSpace(&cMaeAct->cAcuNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cAcuLugEst,19),;
		 'PARENTESCO:',cLenSpace(&cMaeAct->cParAcuEst,14)})
       LineaPrn({'        ___'+;
		 '     ',REPL('_',21),;
		 '  :',REPL('_',19),;
		 '          :',REPL('_',14)})

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirAcuEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarAcuEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuAcuEst,31),;
		 'TEL CASA:',cLenSpace(&cMaeAct->cTe1AcuEst,15),;
		 'TEL OFI:',cLenSpace(&cMaeAct->cTe2AcuEst,15)})
       LineaPrn({'      :',REPL('_',31),;
		 '        :',REPL('_',15),;
		 '       :',REPL('_',15)})
       LineaPrn({'E-MAIL DEL ACUDIENTE:',cLenSpace(&cMaeAct->cMaiAcuEst,39)})
       LineaPrn({'                    :',REPL('_',40)})

       LineaPrn({'Firma:',REPL('_',40)},4)
       LineaPrn({'C.C No.:',''})

       EJECT
       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMATO DE ACTUALIZACION