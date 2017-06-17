*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfStr := {}                  // Estructura del Archivo

       AADD(aDbfStr,{"cCodigoPro","Character", 06,0}) // C¢digo del profesor
       AADD(aDbfStr,{"cPasWwwPro","Character", 10,0}) // PassWord del Internet
       AADD(aDbfStr,{"cPasWorPro","Character", 10,0}) // PassWord del profesor
       AADD(aDbfStr,{"cMaiProPro","Character", 40,0}) // E-MAIL del Profesor
     *ÀInformaci¢n de identificaci¢n t‚cnica

       AADD(aDbfStr,{"cCodigoOrg","Character", 02,0}) // C¢digo de la organizaci¢n
       AADD(aDbfStr,{"cRevisaPro","Character", 03,0}) //  '000' Revisar sus alumnos en contabilidad de profesores
       AADD(aDbfStr,{"lSiProfPro","Logical"  , 01,0}) // .T. Puede entrar a la contabilidad de profesores
       AADD(aDbfStr,{"lCargasPro","Logical"  , 01,0}) // .T.=> Tiene Carga en Contabilidad .F.=>No tiene Carga
       AADD(aDbfStr,{"cMaeAluPro","Character", 09,0}) // Niveles donde dicta. Jardin, Primaria, Bachillerato
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

       AADD(aDbfStr,{"cVotConPro","Character",030,0}) // Voto al Consejo Directivo
     *ÀOtros
*>>>>FIN DECLARACION DE VARIABLES