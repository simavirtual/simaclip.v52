       AADD(aDbfStr,{"nCodigoPer","Numeric"  ,16,0}) // C¢digo de la Persona
     *ÀLlave principal

       AADD(aDbfStr,{"cDocNitPer","Character",16,0}) // Documento de Identidad
       AADD(aDbfStr,{"cTipNitPer","Character",01,0}) // Tipo de Documento. 1=>Cedula, 2=>Nits Empresariales, 3=>Nits de Extranjeria, 4=>Cedula de Estranjeria, 5=>NUIP: N£mero £nico de identificaci¢n personal
       AADD(aDbfStr,{"cLugNitPer","Character",20,0}) // Lugar del Documento
       AADD(aDbfStr,{"lFotNitPer","Logical"  ,01,0}) // .T. Fotocopia del Documneto
     *ÀIdentificaci¢n

       AADD(aDbfStr,{"cApeUnoPer","Character",20,0}) // Primer Apellido
       AADD(aDbfStr,{"cApeDosPer","Character",20,0}) // Segundo Apellido
       AADD(aDbfStr,{"cNomUnoPer","Character",20,0}) // Primer Nombre
       AADD(aDbfStr,{"cNomDosPer","Character",20,0}) // Segundo Nombre
     *ÀApellidos y Nombres

       AADD(aDbfStr,{"dFecNacPer","Date"     ,08,0}) // Fecha de nacimiento
       AADD(aDbfStr,{"cLugNacPer","Character",20,0}) // Lugar de nacimiento
       AADD(aDbfStr,{"lExtranPer","Logical"  ,01,0}) // .T. Extrajero
     *ÀLugar de Nacimiento

       AADD(aDbfStr,{"lSiQepdPer","Logical"  ,01,0}) // .T. Que En la Paz Del se¤or
       AADD(aDbfStr,{"lSexFemPer","Logical"  ,01,0}) // .T. Sexo Femenino .F. Sexo Masculino
       AADD(aDbfStr,{"cEstratPer","Character",01,0}) // Estrato
     *ÀInformaci¢n personal

       AADD(aDbfStr,{"cEstCivPer","Character",01,0}) // Estado Civil
       AADD(aDbfStr,{"cNitCmpPer","Character",01,0}) // Documento de Compa¤era(o)
       AADD(aDbfStr,{"cTntCmpPer","Character",01,0}) // Tipo de Documento de la Compa¤era(o)
     *ÀEstado Civil

       AADD(aDbfStr,{"cDireccPer","Character",60,0}) // Direccion de la casa
       AADD(aDbfStr,{"cBarrioPer","Character",40,0}) // Barrio de la direcci¢n
       AADD(aDbfStr,{"cCiudadPer","Character",40,0}) // Ciudad
     *ÀDireccion de Residencia

       AADD(aDbfStr,{"cTelefnPer","Character",30,0}) // Telefono Casa
       AADD(aDbfStr,{"cTelCelPer","Character",14,0}) // *Telefono celular del Padre
       AADD(aDbfStr,{"cTelFaxPer","Character",30,0}) // Telefono Fax de la Casa
       AADD(aDbfStr,{"cBipperPer","Character",30,0}) // *Biper del Padre
       AADD(aDbfStr,{"cMaiUnoPer","Character",40,0}) // E-MAIL del padre
       AADD(aDbfStr,{"cMaiDosPer","Character",40,0}) // E-MAIL del padre
       AADD(aDbfStr,{"cMaiTrePer","Character",40,0}) // E-MAIL del padre
     *ÀContacto personal

       AADD(aDbfStr,{"cDirEnvPer","Character",60,0}) // Direccion de Envio de Correspondencia
       AADD(aDbfStr,{"cBarEnvPer","Character",40,0}) // Barrio de Envio de Correspondencia
       AADD(aDbfStr,{"cCiuEnvPer","Character",40,0}) // Ciudad de Envio de la Correspondencia
       AADD(aDbfStr,{"cTelEnvPer","Character",30,0}) // Telefono Direccion de Correspondencia
       AADD(aDbfStr,{"cFaxEnvPer","Character",30,0}) // Fax Direcci¢n de Correspondencia
     *ÀDireccion de Envio de Correspondencia

       AADD(aDbfStr,{"cEmpTraPer","Character",26,0}) // Empresa del Trabajo
       AADD(aDbfStr,{"cCarTraPer","Character",20,0}) // Cargo de la Empresa
       AADD(aDbfStr,{"cDirTraPer","Character",60,0}) // Direccion del Trabajo
       AADD(aDbfStr,{"cBarTraPer","Character",40,0}) // Barrio del Trabajo
       AADD(aDbfStr,{"cCiuTraPer","Character",40,0}) // Ciudad del Trabajo
       AADD(aDbfStr,{"cTelTraPer","Character",30,0}) // Telefono del Trabajo
       AADD(aDbfStr,{"cFaxTraPer","Character",30,0}) // Fax del Trabajo
     *ÀInformaci¢n laboral

       AADD(aDbfStr,{"cProfesPer","Character",26,0}) // Profesi¢n de la Persona
     *ÀEstudios
*>>>>FIN DECLARACION DE LA ESTRUCTURA