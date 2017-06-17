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

2- Para cada versi¢n se detalla que cambios se realizaron.


*------------------------------------------------------------------------*
*                       DETALLES DE LAS VERSIONES                        *
*------------------------------------------------------------------------*/

*>>>>ARCHIVOS DEL SISTEMA
/*    Control de Usuarios
      Errores del Sistema
      Configuraci¢n general
      Configuraci¢n A¤o
      Bancos
      Conceptos
      Tarifas
      Clientes
      Pagos
      Gerencia Electr¢nica
      Cartas para morosos */

      LOCAL cVerSis := ' XML216.03-1'               // Versi¢n Actual
*>>>>FIN ARCHIVOS DEL SISTEMA

/*
***************************************************************************
*----------------------------VERSION V98.1.0 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Modificaci¢n: Sustancial

     - Ejecutar la herramienta para el sistema de Cartera
       "CartTool" £ltima versi¢n.

     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 932775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
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
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>CAMBIO DEL MENU
     - Uniformidad del men£ de Utilidades.
*>>>>FIN CAMBIO DEL MENU

*>>>>INFORMES
     - Facturaci¢n del mes.
     - Pagos del mes.
     - Facturaci¢n mas pagos.

     Estos informes permiten mostrar el cuadre de la cartera
     con contabilidad. En la generaci¢n permiten la consulta para
     detectar posibles inconsistencias.
*>>>>FIN INFORMES

*>>>>PROCESOS
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
*>>>>FIN PROCESOS

***************************************************************************
*----------------------------VERSION V99.0.1 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Actualizar la Configuraci¢n del A¤o

     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 932775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
     - Configuraci¢n A¤o:
	*Detalles de campos adicionados:
	   lPrnFecCaA == Informes por fechas

	*Modificaci¢n que origino:
	   <Config A¤o>
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>INFORMES
     - Relaci¢n de Pagos Facturados
     - Relaci¢n de Descuentos y Recargos
     - Pagos del mes.
     - Facturaci¢n mas pagos.

     Estos informes permiten ...
*>>>>FIN INFORMES

*>>>>PROCESOS
     - Modificaci¢n de todos los procesos para permitir la impresi¢n por fechas.
*>>>>FIN PROCESOS

***************************************************************************
*----------------------------VERSION V99.0.2 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
     - Modificaci¢n: No Sustancial

     - Para los detalles de Instalaci¢n consultar directamente
       Ing Nelson Fern ndez. Celular No. 932775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
     - Ninguna
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>INFORMES
     - Relaci¢n de Pagos Facturados
     - Relaci¢n Pagos por Grupos
     - Facturaci¢n del mes.
     - Pagos del mes.
     - Facturaci¢n mas pagos.
     - Morosos

     Fueron modificados para arreglar el total de la facturaci¢n y
     los pagos anticipados.
*>>>>FIN INFORMES

*>>>>PROCESOS
     - Modificaci¢n para la lectura de la fechas de los abonos sin
       ning£n problema.
     - Modificaci¢n para los morosos
     - Modificaci¢n del total de la facturaci¢n y los pagos anticipados
     - Modificaci¢n del informe pagos del mes en el valor del pago anticipado
       estaba restando los intereses por pago extemporaneo.
*>>>>FIN PROCESOS

***************************************************************************
*----------------------------VERSION V99.0.3 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
       - Modificaci¢n: No Sustancial

       - Para los detalles de Instalaci¢n consultar directamente
	 Ing Nelson Fern ndez. Celular No. 932775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
     - Configuraci¢n A¤o:
	*Detalles de campos adicionados:
	   dFecRecCaA = Fecha para el recibo.

	*Modificaci¢n que origino:
	   <Config A¤o>
	   Detalles de facturaci¢n.
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>INFORMES
     - Becas. Imprime las becas facturadas de cada mes.
     - Conciliaci¢n de la Cartera.
     - Facturaci¢n de los recibos de la fecha para pago.
*>>>>FIN INFORMES

*>>>>PROCESOS
     - Procesos de Conciliaci¢n de la cartera.
     - Tercera fecha para la facturaci¢n.
*>>>>FIN PROCESOS

***************************************************************************
*----------------------------VERSION V99.0.4 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>REQUERIMIENTOS
       - Modificaci¢n: No Sustancial

       - Para los detalles de Instalaci¢n consultar directamente
	 Ing Nelson Fern ndez. Celular No. 932775212
*>>>>FIN REQUERIMIENTOS

*>>>>CAMBIOS DE ESTRUCTURAS
     - Configuraci¢n del Sistema:
	*Detalles de campos adicionados:
	   lPrnArcCar = Imprimir en archivo

	*Modificaci¢n que origino:
	   <Config Sistema>
	   Detalles de facturaci¢n.
*>>>>FIN CAMBIOS DE ESTRUCTURAS

*>>>>INFORMES
     - Facturaci¢n del mes. Casos de Abonos soportado (7)
*>>>>FIN INFORMES

*>>>>PROCESOS
     - Permite la impresi¢n en un archivo SIMATEMP.PRN
     - Casos de Abonos soportados (7)
     - Actualiza automaticamente la estructura del archivo Config Sistema.
*>>>>FIN PROCESOS

***************************************************************************
*----------------------------VERSION V99.0.7 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
       TIPOSMOV.DAT -> Tipos de movimientos del Estracto
       CONCEMOV.DAT -> Conceptos para describir los movimientos
       19990601.DAT -> Archivos con los movimientos de un d¡a.
       PA199903.DAT -> Archivos con los movimientos de la facturaci¢n
       01199901.DAT -> Archivo con los movimientos del estracto
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Configuraci¢n General:
       cModemCar = Banco para la Gerencia Electronica
		   Se refleja en la opci¢n de pagos por Modem.

     - Movimientos de Facturaci¢n, se ajustaron los campos.
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Se creo el directorio MODEM para almacenar los archivos diarios,
       mensuales y el estracto con todos los movimientos del a¤o.

     - Se renombro la opci¢n <FORMA DE PAGO> por <REGISTRO DE RECIBOS>

     - Se redise¤o la opci¢n para el control del Banco o Coorporaci¢n,
       agregando las siguientes opciones:
       <MOVIMIENTO DIARIO>
       <MOVIMIENTO FACTURACION>
       <EXTRACTO BANCARIO>
       <TIPOS DE TRANSACIONES>
       <CONCEPTOS TRANSACIONES>

     - Se ajusto los procesos para la conciliaci¢n de la Cartera respecto
       a los abonos, llevando el control de los saldos antes de la aplicaci¢n
       de los abonos.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Sacar copia del programa anterior al directior EXE

     - Copiar los ejecutables en el directorio principal.

     - Ingresar al sistema y verificar la creaci¢n de los nuevos archivos

     - Grabar el Banco actual de la Gerencia Electr¢nica:
       <UTILIDADES><MANTENIMIENTO><CONFIG. SISTEMA>
       BANCO MODEM = CONAVI

     - Grabar la longitud de la referencia del Banco:
       <UTILIDADES><MANTENIMIENTO><BANCOS>
       POS ANCHO REFERENCIA = 11

     - Grabar y unificar los tipos de transaciones
     - Grabar y unificar los conceptos de transaciones

     - Actualizar los archivos de la Gerencia Electr¢nica.
       Renombrando y moviendo los archivos al directorio MODEM.
       Ejemplo:
	       GELE0599.DAT a MODEM\PA199905.DAT

     - Ajustar los saldos antes de abonos corregiendo la utilidad
       CARTTOOL.EXE version 99.0.7 ejecutando la opci¢n:
       <ACTUALIZAR><ACTUALIZAR SALDOS ANT> para todos los grupos.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION V99.0.9 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
       - Archivo de Cobros:
			   Permite el control de cobro de la cartera
	  por medio de la Fiducia en su parter inicial
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Bancos
       nLenAnoBan = Longitud del a¤o 2 o 4 cifras

     - Movimientos Diarios
     - Movimientos de la Facturaci¢n
     - Movimientos del Estracto
       Se amplio el campo n£merico del valor de la transaci¢n para
       permitir un mayor rango en el registro control.
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - En el descuento de abonos se cambio el mes del descuento que estaba
       con el mes de la fecha del abono por el mes selecionado como mes
       de descuento.

     - Adecuaci¢n de todos los informes de la gerencia electr¢nica para
       mostrar la fecha con el a¤o.

     - Adici¢n del informe de morosos por n£mero de meses atrasados.

     - Habilitaci¢n del archivo de errores del Sistema
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Sacar copia del programa anterior al directior EXE

     - Copiar los ejecutables en el directorio principal.

     - Ingresar al sistema y garantizar que no hayan usuarios trabajando en
       la red en el programa de Cartera, verificar y actualizar los
       siguientes archivos:

       * DESCUENTOS

     - Salir del Sistema de Cartera.

     - Borrar el archivo de errores del Sistema
       Ejemplo:
	       CD BASES
	       BASES>Del errorsys.dat

     - Ingresar a la Cartera para volver a Crear el Archivo de Errores
       del Sistema. Esta es la forma de Borrar todos los registros
       de errores que aparecen en dicho Archivo. Salir del Sistema

     - Ejecutar el CARTTOOL.EXE Version 99.09 para:

       * Actualizar los archivos de CLIENTES y PAGOS de la forma acostumbrada.

       * Verificar que no existan registro de errores en el Sistema:
	 <INFORMES><ERRORES>

	 Si existen registros Borrar el Archivo de Errores del Sistema
	 seg£n indicaci¢n anterior.

       * Actualizar los Abonos:
	 <ACTUALIZAR><ACTUALIZAR ABONOS>

       * Sacar un informe de los errores del sistema.

*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION V99.1.0 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
       - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Movimientos del Estracto
	+ cNroComTra => N£mero del Comprobante
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Se habilito la impresi¢n de los abonos por fechas.
     - Se implemento el pago parcial de conceptos
     - Eliminaci¢n de Abonos, Descuentos, Recargos, Pagos parciales
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION V99.1.1 -----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Permite imprimir recibos no controlando si el recibo no lo pago
       o lo pago extemporaneo.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION V99.12 ------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Descuentos
       +lDesEfeDes => .T. Abono como Descuento .F. Abono como ingreso
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Permite aplicar abonos como abonos o Descuentos como Abonos
     - Se modifico la Relaci¢n de Abonos, Descuentos, Recargos para reflejar
       los abonos aplicados como descuentos.
     - Permite aplicar abonos para un solo mes.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION VY2K.02------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Permite la conciliaci¢n del Banco Vs Extracto
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION VY2K.03------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - FormaPago => Habilita los diferentes pagos por caja, por Banco.
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Configuraci¢n del A¤o
       +lForPagCaA => Habilitar la forma de pago
     - Pagos
       +cCodigoFpg => C¢digo de la Forma de Pago. Ej: Por Caja, Por Banco
       +cNroFpgPag => N£mero del Soporte de la Forma de pago.
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Permite la conciliaci¢n del Banco Vs Extracto
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa y Actualizar pagos.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION VY2K.04------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Los informes de la Forma de Pago se modificaron para recorrer
       los pagos por fechas en los diferentes meses.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION VY2K.05------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Relaci¢n de los pagos por fechas en los diferentes meses.
     - Se arreglo los Pagos parciales que se grabavan en el archivo de
       Pagos como Descuentos.
     - Se arreglo en la Versi¢n MonoUsuario la opci¢n para procesar los
       NO PAGO por la opci¢n del Modem.
     - Se habilit¢ la posibilidad de proteger la Bases de Datos.
     - Se habilit¢ el Control de la Numeraci¢n de la Factura.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*----------------------------VERSION VY2K.06------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Recibos
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Configuraci¢n General
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Control de Recibos
     - Recibo No. 3
     - Incriptaci¢n de la opci¢n para protecci¢n de las bases de datos
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION


***************************************************************************
*----------------------------VERSION VY2K.11------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Puc => Plan Unico de Cuentas
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Facturaci¢n del Mes con cortes de fecha
     - Control sobre el total de Estudiantes
     - Relaci¢n de Estudiantes Facturados
     - Relaci¢n de Estudiantes Retirados
     - Relaci¢n de Estudiantes No Facturados
     - Relaci¢n de Estudiantes Por Justificar
     - Control del £ltimo recibo que se debe facturar.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*---------------------------VERSION VY2K.11-1-----------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Aplicaci¢n del Abono sin afectar mes anterior si se pago
     - Arreglo de la facturaci¢n del mes por cortes
     - Conciliaci¢n del Estracto de diferentes meses.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa
     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*---------------------------VERSION VY2K.12-------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Configuraci¢n del A¤o
       +cAnoMtrCaA => A¤o para procesar las matr¡culas
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Procesa las matr¡culas del Banco
     - Los informes muestran el nombre de los estudiantes nuevos.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa y actualizar las estructuras de todos
       los a¤os.

     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*---------------------------VERSION VY2K1.01------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Descuentos
       +nVlrMorPag => Valor de la mora del mes actual
       +nVlrMorDes => Valor de la mora del mes anterior
     -Configuraci¢n del A¤o
       +cAnoUsrCaa => A¤o para el maestro de Estudiates para Gerencia Electronica
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Permite eliminar el abono para el mes anterior a la facturaci¢n.
     - Se corrig¡o la actualizaci¢n del saldo en la eliminaci¢n de novedades
       de abonos para el mes actual.
     - Se adiciono la aplicaci¢n de abonos cuando existe valor de recargo.
     - Permite trabajar en la Gerencia Electronica con el Maestro de Estudiantes
       que se especifique y procesa dichos movimientos.
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa y actualizar las estructuras de todos
       los a¤os.

     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*---------------------------VERSION VY2K1.02------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     - Ninguna
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Reorganizaci¢n de las opciones del Extracto para mayor
       descriminaci¢n.
     - Permite recibir pagos con varias Coorporaciones de Ahorro
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa y actualizar las estructuras de todos
       los a¤os.

     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*---------------------------VERSION VY2K1.03------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
     -Estracto de Banco
       +cObsValTra => Observaci¢n de la conciliaci¢n del Extracto
     -Configuraci¢n del A¤o
       +nNomFacCaA => C¢digo del Nombre de la Factura
     -Pagos
       +cNomFacPag =>Control Nombre de la Factura
       +dFecRepPag =>Fecha de reporte
     -Clientes
       +lHayRepCli =>Reportar al Estudiante
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
     - Cambia el termino de Becas por Ayudas Educativas
     - Mejora el Control de Estudiantes al adicionar fechas de Matr¡culas
     - Permite imprimir el Recibo con Nombre al Estudiante,Padre,Madre o Acudiente LEXCOM
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa y actualizar las estructuras de todos
       los a¤os.

     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*---------------------------VERSION VY2K1.04------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS
*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa y actualizar las estructuras de todos
       los a¤os.

     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*---------------------------VERSION VY2K1.05------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa y actualizar las estructuras de todos
       los a¤os.

     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

***************************************************************************
*---------------------------VERSION VY2K1.06------------------------------*
*------------------------DETALLES DE LA VERSION --------------------------*
***************************************************************************

*>>>>CREACION DE ARCHIVOS
     - Ninguna
*>>>>FIN CREACION DE ARCHIVOS

*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>MODIFICACION DE ESTRUCTURAS

*>>>>DETALLES DE LA MODIFICACION
*>>>>FIN DETALLES DE LA MODIFICACION

*>>>>PASOS PARA LA ACTUALIZACION
     - Instalar solo el programa y actualizar las estructuras de todos
       los a¤os.

     - Ejecutar el programa de proteci¢n de Bases de Datos si se habilit¢
       dicha opci¢n.
*>>>>FIN PASOS PARA LA ACTUALIZACION

*/

