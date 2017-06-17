/*                       SIMA - MATRICULA ACADEMICA
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

FUNCTION CreaDbfPro(lShared,PathPro,FilePro,lIntUno,fNtxPro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathAdm				    // Path del Archivo
       FileAdm				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxAdm				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfPro := {{"cCodigoPro","Character",06,0},; // C¢digo del profesor
			 {"cNombrePro","Character",26,0},; // Nombre del profesor
			 {"cApelliPro","Character",26,0},; // Apellido del profesor
			 {"cDireccPro","Character",40,0},; // Direccion del profesor
			 {"cTelUnoPro","Character",16,0},; // Telefono No. 1
			 {"cTelDosPro","Character",16,0},; // Telefono No. 2
			 {"cTituloPro","Character",30,0},; // T¡tulo
			 {"dFecTitPro","Character",08,0},; // Fecha del T¡tulo
			 {"nEscalaPro","Numeric"  ,02,0},; // N£mero del Escalafon
			 {"cResEscPro","Character",20,0},; // Resoluci¢n del Escalafon
			 {"cDictarPro","Character",20,0},; // Materias en capacidad de Dictar
			 {"cObsEvaPro","Character",20,0},; // Observaci¢n de la evaluaci¢n del Profesor
			 {"cObsEntPro","Character",20,0},; // Observaci¢n de la entrevista del profesor
			 {"lContraPro","Logical"  ,01,0},; // .T. Contratado
			 {"dFecIngPro","Date"     ,08,0},; // Fecha de Ingreso
			 {"dFecRetPro","Date"     ,08,0},; // Fecha del retiro
			 {"lRetiroPro","Logical"  ,01,0},; // .T. Profesor Retirado
			 {"cTipProPro","Character",10,0},; // 01 Profesor 02 Administrativo
			 {"nTipCarPro","Character",10,0},; // Tipo de Cargo. 01 Rector 02 Jefe Departamento Coordinador
			 {"nNomCarPro","Character",40,0},; // Nombre del cargo
			 {"cMaeAluPro","Character",09,0},; // Niveles donde dicta. Jardin, Primaria, Bachillerato
			 {"nNroDivPro","Character",02,0},; // N£mero de la Division en que pertenece
			 {"cCodigoGru","Character",04,0},; // C¢digo del grupo donde es titular
			 {"cPasWorPro","Character",10,0},; // PassWord del profesor
			 {"lRevisaPro","Logical"  ,01,0},; // .T. Revisar sus alumnos en contabilidad de profesores
			 {"cHorariPro","Character",280,0}} // Horario del Profesor. Puntero Dia(07),Puntero Hora(10),Codigo Materia(04)
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathPro) == 0
	    DBCREATE(FilePro,aDbfPro,"DBFNTX")

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
/*     lShared                              // .T. Sistema Compartido
       PathAdm				    // Path del Archivo
       FileAdm				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxAdm				    // Archivo de Indices */
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