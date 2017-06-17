/*************************************************************************
* TITULO ..: IMPRESION DE LOS PARAMETROS DEL ARCHIVO ASCII               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/99 JUE A
       Colombia, Bucaramanga        INICIO: 11:50 PM   MAY 21/99 JUE

OBJETIVOS:

1- Imprime los movimientos del extracto descriminados por tipo de Transaci¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrCob044(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
		   lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		   oBrowse,cMesIni)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo
       cMesIni                              // Mes Inical del pago */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

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

       LOCAL aCampos := {}                  // Descripci¢n del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'PARAMETROS DEL ARCHIVO PLANO ',;
		   '',;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := DRAFT_ON+PICA
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {40,08}
       aTitulo := {'CAMPOS','COLUMNAS'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n10Stan+50
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SELECT COB
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	  RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DESCRIPCION DE CAMPOS
       AADD(aCampos,{'CODIGO DEL COLEGIO       ','001-003'})
       AADD(aCampos,{'CODIGO DEL ESTUDIANTE    ','004-009'})
       AADD(aCampos,{'MES DE LA FACTURACION    ','010-011'})
       AADD(aCampos,{'DEUDA SIN INTERESES      ','012-021'})
       AADD(aCampos,{'INTERESES EN MORA        ','022-031'})
       AADD(aCampos,{'NUMERO DE MESES EN MORA  ','032-033'})
       AADD(aCampos,{'NOMBRE DEL ESTUDIANTE    ','034-059'})
       AADD(aCampos,{'APELLIDO DEL ESTUDIANTE  ','060-085'})
       AADD(aCampos,{'DIRECCION DE LA CASA     ','086-125'})
       AADD(aCampos,{'BARRIO                   ','126-141'})
       AADD(aCampos,{'TELEFONO DE LA CASA      ','142-151'})
       AADD(aCampos,{'NOMBRE DEL PADRE         ','152-191'})
       AADD(aCampos,{'CEDULA DEL PADRE         ','192-207'})
       AADD(aCampos,{'LUGAR DE LA CEDULA       ','208-223'})
       AADD(aCampos,{'TELEFONO DEL PADRE       ','224-233'})
       AADD(aCampos,{'NOMBRE DE LA MADRE       ','234-273'})
       AADD(aCampos,{'CEDULA DE LA MADRE       ','274-289'})
       AADD(aCampos,{'LUGAR DE LA CEDULA       ','290-305'})
       AADD(aCampos,{'TELEFONO DE LA MADRE     ','306-315'})
       AADD(aCampos,{'NOMBRE DEL ACUDIENTE     ','316-355'})
       AADD(aCampos,{'CEDULA DEL ACUDIENTE     ','356-371'})
       AADD(aCampos,{'LUGAR DE LA CEDULA       ','372-387'})
       AADD(aCampos,{'TEL No. 1 DEL ACUDIENTE  ','388-397'})
       AADD(aCampos,{'TEL No. 2 DEL ACUDIENTE  ','398-407'})
*>>>>FIN DESCRIPCION DE CAMPOS

*>>>>IMPRESION DE LOS PARAMETROS
       FOR i := 1 TO LEN(aCampos)
	   aTitulo := {}
	   FOR j := 1 TO 2
	       AADD(aTitulo,aCampos[i,j])
	   ENDFOR
	   cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDFOR
*>>>>FIN IMPRESION DE LOS PARAMETROS

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       SELECT COB
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS