/*                       SIMA - CONTABILIDAD ACADEMICA
		       DETALLES DEL CONTROL DE VERSIONES

**************************************************************************
* NOMBRE DEL PROGRAMA......: VER-CONT.PRG                                *
* TITULO DEL PROGRAMA......: DETALLES DE CONTROL DE VERSION              *
* PROGRAMAS QUE LO INVOCAN.: El programa principal                       *
* PROGRAMAS QUE INVOCA.....: Ninguno                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 07/99 MIE A
       Colombia, Bucaramanga        INICIO: 10:20 AM   MAR 07/99 MIE

OBJETIVOS:

1- Identifica el n£mero de la versi¢n del Sistema.

2- Para cada versi¢n se detalla que cambios se realizaron


*------------------------------------------------------------------------*
*                       DETALLES DE LAS VERSIONES                        *
*------------------------------------------------------------------------*/

*>>>>VERSION ACTUAL
      LOCAL cVerSis := ' XML217.01b'               // Versi¢n Actual XML216.04-4
*>>>>FIN VERSION ACTUAL

/*
***************************************************************************
*----------------------------VERSION V99.0.4 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 932775212
*>>>>FIN REQUERIMIENTOS

*>>>>OBSERVACIONES GENERALES
     - Ajuste del libro final para el plan acad‚mico por grupos.
*>>>>FIN OBSERVACIONES GENERALES

*>>>>CAMBIOS DE ESTRUCTURAS
     - Archivo de Notas.
       (+) nNroLisEst = N£mero de lista.
	   -> Utilizado para ordenar el archivo y evitar descuadres en
	      las listas.

     - Maestro de Alumnos.
       (+) nNroLisEst = N£mero de lista.
	   -> Utilizado de referencia para que los sistemas ordenen sus
	      archivos.
	   -> Se puede modificar para cambiar el orden de lista.
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>CAMBIO DEL MENU

*>>>>FIN CAMBIO DEL MENU

*>>>>INFORMES
*>>>>FIN INFORMES

*>>>>PROCESOS
*>>>>FIN PROCESOS

***************************************************************************
*----------------------------VERSION V99.0.8 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 932775212
*>>>>FIN REQUERIMIENTOS

*>>>>OBSERVACIONES GENERALES
     - Cedulas de los padres y acudientes
*>>>>FIN OBSERVACIONES GENERALES

*>>>>CAMBIOS DE ESTRUCTURAS
     - Archivo de Notas.
       (+) nNroLisEst = N£mero de lista.
	   -> Utilizado para ordenar el archivo y evitar descuadres en
	      las listas.

     - Maestro de Alumnos.
       (+) nNroLisEst = N£mero de lista.
	   -> Utilizado de referencia para que los sistemas ordenen sus
	      archivos.
	   -> Se puede modificar para cambiar el orden de lista.
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>CAMBIO DEL MENU

*>>>>FIN CAMBIO DEL MENU

*>>>>INFORMES
*>>>>FIN INFORMES

*>>>>PROCESOS
*>>>>FIN PROCESOS


***************************************************************************
*--------------------------VERSION VY2K.01-2------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 932775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
     - Configuraci¢n del Nivel
       (+) nJuiExtTbl = N£mero de Logros Extras
	   -> Utilizado para ampliar el n£mero extra de reglones que
	      forman cada uno de los indicadores de logros.

       (M) cEvaIndTbl = Se Modifico su longitud a 7 Caracteres
       (M) cHayNotTbl = Se Modifico su longitud a 5 Caracteres
       (M) cNotNumTbl = Se Modifico su longitud a 5 Caracteres
       (M) cPrnNotTbl = Se Modifico su longitud a 5 Caracteres
			Para permitir manejar (5) Periodos.
     - Archivo de Grupos
       (+) cHorLunGru = Horario de Lunes
       (+) cHorMarGru = Horario de Martes
       (+) cHorMieGru = Horario de Miecorles
       (+) cHorJueGru = Horario de Jueves
       (+) cHorVieGru = Horario de Viernes
       (+) cHorSabGru = Horario de Sabado
       (+) cHorDomGru = Horario de Domingo

     - Archivo de Profesores
       (+) cHorLunPro = Horario de Lunes
       (+) cHorMarPro = Horario de Martes
       (+) cHorMiePro = Horario de Miercoles
       (+) cHorJuePro = Horario de Jueves
       (+) cHorViePro = Horario de Viernes
       (+) cHorSabPro = Horario de Sabado
       (+) cHorDomPro = Horario de Domingo

     - Plan Academico
       (M) cIntHorPla = Se modifica el tipo de campo de numerico a Caracter
	   ->Se modifico para permitir en la intensidad horaria definir
	     asignaturas sin intensidad como proyectos y permitir las
	     intensidades por fracci¢n.

     + Se adiciono el Archivo HORAS
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Permite ampliar los reglones para los indicadores de logros.
     - Permite asignar los c¢digos de los profesores del a¤o 2000.
     - Permite trabajar con cinco periodos.
     - Permite Grabar el Horario del Profesor.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
     - Se debe modificar el campo cIntHorPla manualmente en todas los
       archivos del plan acad‚mico. Solicitar asesoria Cel: 033-2775212
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K.02--------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 033-2775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
     - Materias
       (+) lPorNivMat = Materia Selectiva por Nivel.
	   -> Utilizado para permitir utilizar materias Selectivas por Nivel
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Permite definir en el Plan acad‚mico las materias selectivas por nivel
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
     - Si no se ha modificado las estructuras del plan acad‚mico.
       Se debe modificar el campo cIntHorPla manualmente en todas los
       archivos del plan acad‚mico. Solicitar asesoria Cel: 033-2775212
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K.03--------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 033-2775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
     - Maestro de Alumnos
       (+) cCodEstEst = C¢digo del Estudiante por Compatibilidad.
       (+) cCodigoRut = C¢digo de la Ruta
       (+) cCodigoBus = C¢dogo del Bus.
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Habilita el manejo del Transporte a trav‚s de las rutas.
     - Corrige la impresi¢n de Boletines y libros de asignaturas variables.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
     - Si no se ha modificado las estructuras del plan acad‚mico.
       Se debe modificar el campo cIntHorPla manualmente en todas los
       archivos del plan acad‚mico. Solicitar asesoria Cel: 033-2775212
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K.11--------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Maestro de Alumnos
       (+) nMorosoEst = Clasificaci¢n de los Morosos
       (+) nUltRecEst = Ultimo Recibo que se debe Facturar
       (+) cObsRetEst = Observaci¢n del Retiro
*>>>>FIN MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Agrega la observaci¢n del Retiro en libro Final
     - Agrega la observaci¢n del Retiro en el Certificado
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K.11-1------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>FIN MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Versi¢n por compatibilidad
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K1.01-------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>FIN MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Versi¢n por compatibilidad
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K1.02-------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>FIN MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Versi¢n por compatibilidad
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K1.03-------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Pendiente
*>>>>FIN MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Modificacion de LEXCOM Pendiente
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K1.04-------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguja
*>>>>FIN MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Se corregio la seleci¢n de alumnas en las materias variables por nivel caso Barrancabermeja
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K1.05-------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguja
*>>>>FIN MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Pendiente
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*--------------------------VERSION VY2K1.06-------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguja
*>>>>FIN MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Pendiente
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

*/
