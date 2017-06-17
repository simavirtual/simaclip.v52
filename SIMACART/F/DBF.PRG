       LOCAL aDbfAlu := {{"cCodigoEst","Character",006,0},; // C¢digo del Estudiante
			 {"cCodEstEst","Character",007,0},; // C¢digo del Estudiante
			 {"lRetiroEst","Logical"  ,001,0},; // .T. Retirado
			 {"dFecRetEst","Date"     ,008,0},; // Fecha del retiro
			 {"nUltRecEst","Numeric"  ,002,0},; // Ultimo Recibo que se debe facturar
			 {"nAproboNot","Numeric"  ,002,0},; // Indicardor de Aprobaci¢n
			 {"lRepiteEst","Logical"  ,001,0},; // .T. Repite a¤o
			 {"lSiCupoEst","Logical"  ,001,0},; // .T. Tiene Cupo
			 {"lSiMatrEst","Logical"  ,001,0},; // .T. Si matriculado para sgte a¤o
			 {"dFecMatEst","Date"     ,008,0},; // Fecha de matricula
			 {"cHorMatEst","Character",008,0},; // Hora de matricula
			 {"cFolFinEst","Character",012,0},; // Folios del libro final
			 {"lGrupOkEst","Logical"  ,001,0},; // .T. Grupo OK no mezclar grupos
			 {"cCodigoGru","Character",004,0},; // Codigo del grupo
			 {"nNroLisEst","Numeric"  ,003,0},; // N£mero de lista.
			 {"nMorosoEst","Numeric"  ,002,0},; // C¢digo de Clasificaci¢n de los morosos.
			 {"nNomFacEst","Numeric"  ,001,0},; // C¢digo del Nombre de la Factura 0=>Alumno 1=>Padre 2=>Madre 3=>Acudiente
			 {"cApelliEst","Character",030,0},; // Apellido del Estudiante
			 {"cNombreEst","Character",030,0},; // Nombre del Estudiante
			 {"dFecNacEst","Date"     ,008,0},; // Fecha de nacimiento
			 {"cLugNacEst","Character",020,0},; // Lugar de nacimiento
			 {"cDocNitEst","Character",016,0},; // Documento de Identidad
			 {"cLugNitEst","Character",020,0},; // Lugar del Documento
			 {"lSexFemEst","Logical"  ,001,0},; // .T. Sexo Femenino .F. Sexo Masculino
			 {"cDireccEst","Character",040,0},; // Direccion de la casa
			 {"cTelefnEst","Character",010,0},; // Telefono de la casa
			 {"cBarrioEst","Character",016,0},; // Barrio de la direcci¢n
			 {"cNomPadEst","Character",040,0},; // Nombre del padre
			 {"cPadNitEst","Character",016,0},; // C‚dula del padre
			 {"cPadLugEst","Character",016,0},; // Lugar de la c‚dula
			 {"cProPadEst","Character",026,0},; // Profesi¢n del padre
			 {"cEmpPadEst","Character",026,0},; // Empresa del padre
			 {"cCarPadEst","Character",020,0},; // Cargo del padre
			 {"cDirPadEst","Character",040,0},; // Direccion del Padre
			 {"cTelPadEst","Character",010,0},; // Telefono del padre
			 {"cNomMadEst","Character",040,0},; // Nombre de la madre
			 {"cMadNitEst","Character",016,0},; // C‚dula de la madre
			 {"cMadLugEst","Character",016,0},; // Lugar de la c‚dula
			 {"cProMadEst","Character",026,0},; // Profesi¢n de la madre
			 {"cEmpMadEst","Character",026,0},; // Empresa de la madre
			 {"cCarMadEst","Character",020,0},; // Cargo de la madre
			 {"cDirMadEst","Character",040,0},; // Direccion de la Madre
			 {"cTelMadEst","Character",010,0},; // Telefono de la madre
			 {"cNomAcuEst","Character",040,0},; // Nombre del Acudiente
			 {"cParAcuEst","Character",016,0},; // Parentesco del Acudiente
			 {"cAcuNitEst","Character",016,0},; // C‚dula del Acudiente
			 {"cAcuLugEst","Character",016,0},; // Lugar del Acudiente
			 {"cDirAcuEst","Character",040,0},; // Direccion de la casa del Acudiente
			 {"cTe1AcuEst","Character",010,0},; // Telefono No. 1 del Acudiente
			 {"cTe2AcuEst","Character",010,0},; // Telefono No. 2 del Acudiente
			 {"cEstratEst","Character",002,0},; // Estatro del Estudiante
			 {"cConcepEst","Character",016,0},; // Conceptos del Estudiante
			 {"cCodigoRut","Character",006,0},; // Codigo de la Ruta
			 {"cCodigoBus","Character",006,0},; // Codigo del Bus
			 {"cObsLibEst","Character",500,0},; // Observaci¢n para el libro.
			 {"cCole13Est","Character",084,0},; // Procedencia de Preescolar
			 {"cCole00Est","Character",084,0},; // Procedencia de Primaria
			 {"cCole06Est","Character",084,0},; // Procedencia de Sexto
			 {"cCole07Est","Character",084,0},; // Procedencia de Septimo
			 {"cCole08Est","Character",084,0},; // Procedencia de Octavo
			 {"cCole09Est","Character",084,0},; // Procedencia de Noveno
			 {"cCole10Est","Character",084,0},; // Procedencia de D‚cimo
			 {"cCole11Est","Character",084,0},; // Procedencia de Und‚cimo
			 {"cCole12Est","Character",084,0},; // Procedencia de DuoD‚cimo
			 {"cObsRetEst","Character",100,0},; // Observaci¢n del Retiro.
			 {"cVotEscEst","Character",030,0},; // Voto Escolar del Estudiante
			 {"cCodigoMat","Character",004,0},; // C¢digo de la materia del area Especializada
			 {"cAnoEstMae","Character",068,0},; // A¤os en que estudio en el colegio
			 {"cNomFi1Est","Character",040,0},; // Nombre del Fiador No. 1
			 {"cParFi1Est","Character",016,0},; // Parentesco del Fiador No. 1
			 {"cFi1NitEst","Character",016,0},; // C‚dula del Fiador No. 1
			 {"cFi1LugEst","Character",016,0},; // Lugar del Fiador No. 1
			 {"cDirFi1Est","Character",040,0},; // Direccion de la casa  Fiador No. 1
			 {"cBarFi1Est","Character",016,0},; // Barrio de la direcci¢n Fiador No. 1
			 {"cTe1Fi1Est","Character",010,0},; // Telefono No. 1 del Fiador No. 1
			 {"cTe2Fi1Est","Character",010,0},; // Telefono No. 2 del Fiador No. 1
			 {"cNomFi2Est","Character",040,0},; // Nombre del Fiador No. 2
			 {"cParFi2Est","Character",016,0},; // Parentesco del Fiador No. 2
			 {"cFi2NitEst","Character",016,0},; // C‚dula del Fiador No. 2
			 {"cFi2LugEst","Character",016,0},; // Lugar del Fiador No. 2
			 {"cDirFi2Est","Character",040,0},; // Direccion de la casa Fiador No. 2
			 {"cBarFi2Est","Character",016,0},; // Barrio de la direcci¢n Fiador No. 2
			 {"cTe1Fi2Est","Character",010,0},; // Telefono No. 1 del Fiador No. 2
			 {"cTe2Fi2Est","Character",010,0},; // Telefono No. 2 del Fiador No. 2
			 {"cNomRe1Est","Character",040,0},; // Nombre de la Referencia No. 1
			 {"cParRe1Est","Character",016,0},; // Parentesco de la Referencia No. 1
			 {"cRe1NitEst","Character",016,0},; // C‚dula de la Referencia No.1
			 {"cRe1LugEst","Character",016,0},; // Lugar de la Referencia No. 1
			 {"cDirRe1Est","Character",040,0},; // Direccion de la casa de la Referencia No. 1
			 {"cBarRe1Est","Character",016,0},; // Barrio de la direcci¢n de la Referencia No. 1
			 {"cTe1Re1Est","Character",010,0},; // Telefono No. 1 de la Referencia No. 1
			 {"cTe2Re1Est","Character",010,0},; // Telefono No. 2 de la Referencia No. 1
			 {"cNomRe2Est","Character",040,0},; // Nombre de la Referencia No. 2
			 {"cParRe2Est","Character",016,0},; // Parentesco de la Referencia No. 2
			 {"cRe2NitEst","Character",016,0},; // C‚dula de la Referencia No. 2
			 {"cRe2LugEst","Character",016,0},; // Lugar de la Referencia No. 2
			 {"cDirRe2Est","Character",040,0},; // Direccion de la casa de la Referencia No. 2
			 {"cBarRe2Est","Character",016,0},; // Barrio de la direcci¢n de la Referencia No. 2
			 {"cTe1Re2Est","Character",010,0},; // Telefono No. 1 de la Referencia No. 2
			 {"cTe2Re2Est","Character",010,0},; // Telefono No. 2 de la Referencia No. 2
			 {"cApePadEst","Character",030,0},; // Telefono No. 2 de la Referencia No. 2
			 {"cCodFamEst","Character",030,0}}  // C¢digo de Estudiantes de los familiares