/*                       SIMA - CARTERA ACADEMICA
		     DETALLES DEL CONTROL DE VERSIONES

**************************************************************************
* NOMBRE DEL PROGRAMA......: VER-CART.PRG                                *
* TITULO DEL PROGRAMA......: DETALLES DE CONTROL DE VERSION              *
* PROGRAMAS QUE LO INVOCAN.: El programa principal                       *
* PROGRAMAS QUE INVOCA.....: Ninguno                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 22/98 JUE A
       Colombia, Bucaramanga        INICIO: 10:20 AM   OCT 22/98 JUE

OBJETIVOS:

1- Identifica el n£mero de la versi¢n del Sistema.

2- Para cada versi¢n se detalla que cambios se realizaron


*------------------------------------------------------------------------*
*                       DETALLES DE LAS VERSIONES                        *
*------------------------------------------------------------------------*/

*>>>>ARCHIVOS DEL SISTEMA
/*    Control de Usuarios
      Errores del Sistema
      Configuraci¢n general
      Configuraci¢n A¤o
      Admisiones
      Bancos
      Conceptos
      Tarifas
      Pagos */

      LOCAL cVerSis := ' XML217.03b1'            // Versi¢n Actual
*>>>>FIN ARCHIVOS DEL SISTEMA

/*
*>>>>DETALLES DE LA VERSION V98.1.0 Modificaci¢n: "Sustancial"

*******REQUERIMIENTOS
       - Ejecutar la herramienta para el sistema de Cartera
	 "CartTool" £ltima versi¢n.

       - Para los detalles de Instalaci¢n consultar directamente
	 Ing Nelson Fern ndez. Celular No. 932775212
*******FIN REQUERIMIENTOS

*******CAMBIOS DE ESTRUCTURAS
       - Configuraci¢n A¤o:
	  *Detalles de campos adicionados:
	     Maestros y jornadas habilitadas.

	  *Modificaci¢n que origino:
	     <Config A¤o>

       - Bancos:
	  *Detalles de campos adicionados:
	     Digito de Verificaci¢n

	  *Modificaci¢n que origino:
	     <Bancos>,<Solo un recibo>,<Todos los recibos>,<Por Adelantado>

       - Pagos:
	  *Detalles de campos adicionados:
	     Tipo de intereses,Mes ammistia,Saldos Anteriores sin abonos,
	     Abonos,anticipos del mes.

	  *Modificaci¢n que origino:
	     <Pagos>,<Detalles de pago>,<Solo un recibo>,
	     <Todos los recibos>,<Por Adelantado>,<Descontar Abonos>

       - Clientes:
	  *Detalles de campos adicionados:
	     Saldos Anteriores sin abonos

	  *Modificaci¢n que origino:
	     <Mantenimiento>,<F6 Saldos>"Opci¢n Nueva",<Descontar Abonos>
	     <Eliminar Recibos>
*******FIN CAMBIOS DE ESTRUCTURAS

*******CAMBIO DEL MENU
       - Uniformidad del men£ de Utilidades.
*******FIN CAMBIO DEL MENU

*******INFORMES
       - Facturaci¢n del mes.
       - Pagos del mes.
       - Facturaci¢n mas pagos.

       Estos informes permiten mostrar el cuadre de la cartera
       con contabilidad. En la generaci¢n permiten la consulta para
       detectar posibles inconsistencias.
*******FIN INFORMES

*******PROCESOS
       - Adicion de d¡gitos de chequeo y adecuaci¢n de los recibos.

       - Creaci¢n del paz y salvo No. 2

       - Modificaci¢n del paz y salvo No. 1 para permitir un mensaje
	 de observaci¢n.

       - Adici¢n de la consulta de los saldos actuales y sin abonos
	 para cada estudiante.

       - Modificaci¢n de los detalles de pago para mostrar
	 abonos,anticipos del mes,saldos anteriores sin abonos,mes de
	 ammistia,tipo de intereses de lo facturado.

       - En mantenimiento de clientes desactivada la opci¢n de modificar
	 saldos.
*******FIN PROCESOS

*>>>>FIN DETALLES DE LA VERSION V98.1.0 Modificaci¢n: "Sustancial"

*>>>>DETALLES DE LA VERSION V99.0.2 Modificaci¢n: "No Sustancial"
*******REQUERIMIENTOS
       - Para los detalles de Instalaci¢n consultar directamente
	 Ing Nelson Fern ndez. Celular No. 932775212
*******FIN REQUERIMIENTOS

*******CAMBIOS DE ESTRUCTURAS
       - Ninguna
*******FIN CAMBIOS DE ESTRUCTURAS

*******INFORMES
       - Informes por fechas
*******FIN INFORMES

*******PROCESOS
       - Procesos para informes por fechas
*******FIN PROCESOS
*>>>>FIN DETALLES DE LA VERSION V99.0.2 Modificaci¢n: "No Sustancial"
*/

/*
*>>>>DETALLES DE LA VERSION V99.0.9 Modificaci¢n: "No Sustancial"
*******REQUERIMIENTOS
       - Para los detalles de Instalaci¢n consultar directamente
	 Ing Nelson Fern ndez. Celular No. 932775212
*******FIN REQUERIMIENTOS

*******CAMBIOS DE ESTRUCTURAS
       - Configuraci¢n A¤o:
	  *Detalles de campos adicionados:
	     Tipo de Formulario de Admision
	     1 => Formulario por defecto
	     2 => Formulario Virrey Solis

	  *Modificaci¢n que origino:
	     <Config A¤o>
*******FIN CAMBIOS DE ESTRUCTURAS

*******INFORMES
       - Creaci¢n de los Formularios de inscripci¢n
*******FIN INFORMES

*******PROCESOS
       - Adecuaci¢n de los c¢digos para la matr¡cula seg£n a¤o 2000
	 Ejemplo:
		 Para anteriores del  2000 => A¤oInscripci¢n. 990001
		 Para posteriores del 2000 => Primer d¡gito del a¤o,A¤o,Inscripci¢n 200001
*******FIN PROCESOS
*>>>>FIN DETALLES DE LA VERSION V99.0.8 Modificaci¢n: "No Sustancial"


*>>>>DETALLES DE LA VERSION V99.0.9-2 Modificaci¢n: "No Sustancial"

*******CAMBIOS DE ESTRUCTURAS
       - Configuraci¢n A¤o:
	  *Detalles de campos adicionados:
	     Tipo de Formulario de Admision
	     3 => Colegios de Procedencia

       - Maestro de Alumnos
	  * Detalles de campos adicionados
	      cCole13Est,cCole00Est,cCole06Est,cCole07Est,cCole08Est
	      cCole09Est,cCole10Est,cCole11Est,cCole12Est

*******FIN CAMBIOS DE ESTRUCTURAS

*******DETALLES DE LA MODIFICACION
       - Habilitaci¢n para permitir el trabajo con n£meros para la
	 Inscripci¢n, orden de matr¡cula, hoja de matr¡cula
*******FIN DETALLES DE LA MODIFICACION

*>>>>FIN DETALLES DE LA VERSION V99.0.9-2 Modificaci¢n: "No Sustancial"

***************************************************************************
*--------------------------VERSION VY2K.02--------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 033-2775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
     - Ninguno
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Permite descriminar el pago de las matriculas por meses de pago.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
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
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
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
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Se habilito la captura de la observaci¢n del Retiro y mes del
       £ltimo recibo a imprimir
     - Se habilito la posibilidad de generar el c¢digo del estudiante externamente
     - Habilitar la impresi¢n del nombre del Colegio en la Hoja de Matr¡cula
     - Hoja de separaci¢n cupo
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
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Se permite el registro de los recibos sin necesidad de Matriculas
     - Consulta de pagos sin necesidad de matr¡culas
     - Habilitar la impresi¢n del nombre del Colegio en la Hoja de Matr¡cula
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
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Por cambio de a¤o.
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
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Por compatibilidad
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
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - LEXCON pendiente
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
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - LEXCON pendiente
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
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - LEXCON pendiente
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
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - LEXCON pendiente
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

*/